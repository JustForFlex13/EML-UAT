/*--------------------------------------------------------------------
-- - Purpose             : TaskTrigger Handler
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 24/03/2017  J.NG  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
public class TaskTriggerHandler extends TriggerHandler {

    // Maps and list initialized from the Trigger context
    private Map<Id, Task> oldMap;
    private Map<Id, Task> newMap;
    private List<Task> oldList;
    private List<Task> newList;

    // Préfixe de l'objet Quote
    private final static String QUOTE_PREFIX = '0Q0';

    // Constructor
    public TaskTriggerHandler() {
        this.oldMap = (Map<Id, Task>) Trigger.oldMap;
        this.newMap = (Map<Id, Task>) Trigger.newMap;
        this.oldList = (List<Task>) Trigger.Old;
        this.newList = (List<Task>) Trigger.New;
    }

    protected override void beforeInsert() {
        System.debug('--- BEGIN TaskTriggerHandler beforeInsert() ---');

        // Récupération d'un contact quelconque afin de permettre l'insertion des tâches dans la sandbox
        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        for (Task t : this.newList) {

            // Vérification qu'on est bien dans le cas d'une insertion de données de la production vers une sandbox
            if (t.TECH_Is_Record_Transferring__c) {
                if (t.TECH_External_What_Id__c != null || t.TECH_External_Who_Id__c != null) {

                /**
                Attribution du premier contact trouvé aux tâches pour pouvoir les insérer
                car les champs polymorphiques WhatId et WhoId ne peuvent pas faire référence à des External Id
                 */
                    // Attribution de ce contact au champ WhoId des nouvelles tâches
                    t.WhoId = contact.Id;

                    System.debug('-- PARAM t.WhoId : ' + t.WhoId);
                    System.debug('-- PARAM contact.Id : ' + contact.Id);
                }
            }
        }
        System.debug('--- END TaskTriggerHandler beforeInsert() ---');
    }

    public override void afterInsert() {
        System.debug('--- BEGIN TaskTriggerHandler afterInsert() ---');

        List<Task> tasksJustInserted = this.newList;
        // tasksToUpdateAfterInsert est une variable qui pourra être réutilisée pour des update en after insert
        List<Task> tasksToUpdateAfterInsert = new List<Task>();

        /*
         Vérification si nous sommes en transfert de données entre sandbox, si oui on ajoute les tasks à la liste
         tasksToUpdateAfterInsert pour les mettre à jour
          */
        List<Task> tasksInTransferBetweenSandboxs = completeWhoAndWhatIdFields(tasksJustInserted);
        if (tasksInTransferBetweenSandboxs != null && !tasksInTransferBetweenSandboxs.isEmpty()) {
            tasksToUpdateAfterInsert.addAll(tasksInTransferBetweenSandboxs);
        }

        if (tasksToUpdateAfterInsert != null && !tasksToUpdateAfterInsert.isEmpty()) {
            try {
                Database.update(tasksToUpdateAfterInsert, false);
            } catch (Exception e) {
                System.debug('Update impossible pour en after insert de Task' + e);
            }
        }

        System.debug('--- END TaskTriggerHandler afterInsert() ---');
    }

    /**
    Lors d'un transfert de données entre la production et une sandbox :
    Méthode qui récupère les valeurs contenues dans les champs TECH_External_What_Id__c et TECH_External_Who_Id__c
    afin de les réattribuer aux champs WhatId et WhoId
    Si les champs TECH_External_What_Id__c et TECH_External_Who_Id__c ne sont pas vides, on réattribue leur
    valeur à WhatId et/ou à WhoId. Sinon, on remet le champ à null (car précédemment nous avons inséré un
    contact au champ WhoId pour permettre l'insertion, mais il n'avait rien à voir avec les tâches)
    */
    private static List<Task> completeWhoAndWhatIdFields(List<Task> newTasks) {
        Set<Id> ids = new Set<Id>();
        for (Task t : newTasks) {
            ids.add(t.Id);
        }

        List<Task> tasks = [SELECT Id, WhoId, WhatId, TECH_External_Who_Id__c, TECH_External_What_Id__c, TECH_Is_Record_Transferring__c
                                FROM Task
                                WHERE Id IN :ids];

        // Vérification qu'on est dans le cas d'un transfert de données avec le champ TECH_Is_Record_Transferring__c à true
        for (Integer i = 0; i < tasks.size() ; i++) {
            if (!tasks.get(i).TECH_Is_Record_Transferring__c == true) {
                tasks.remove(i);
            }
        }

        if (tasks.isEmpty()){
            return null;
        }

        // Map qui va stocker les préfixes d'ID et le nom de l'objet correspondant
        Map<String, String> prefixObjects = new Map<String, String>();

        // Map qui va stocker les préfixes d'ID et la liste des TECH_External_Who_Id__c et TECH_External_What_Id__c
        Map<String, List<Id>> whoAndWhatTechIdsMap = new Map<String, List<Id>>();

        List<Task> tasksToUpdate = new List<Task>();
        for (Task task : tasks) {
            /* On repasse le champ TECH_Is_Record_Transferring__c à false pour que les enregistrements ne repassent
             plus dans cette partie de code
              */
            task.TECH_Is_Record_Transferring__c = false;

            if (task.TECH_External_Who_Id__c != null) {
                System.debug('-- TaskTriggerHandler : task.TECH_External_Who_Id__c : ' + task.TECH_External_Who_Id__c);

                /*
                Utilisation du préfixe de WhoId pour récupérer le nom de l'objet correspondant
                 */
                String whoIdPrefix = task.TECH_External_Who_Id__c.substring(0, 3);
                if(!prefixObjects.containsKey(whoIdPrefix)) {
                    prefixObjects.put(whoIdPrefix, Utils.findObjectNameFromRecordIdPrefix(whoIdPrefix));

                    /* Si whoIdPrefix existe, récupération de la liste associée + ajout item, sinon création entrée avec nouveau
                    préfixe
                     */
                    whoAndWhatTechIdsMap.put(whoIdPrefix, new List<Id>{task.TECH_External_Who_Id__c});
                } else {
                    whoAndWhatTechIdsMap.get(whoIdPrefix).add(task.TECH_External_Who_Id__c);
                }
            }

            if (task.TECH_External_What_Id__c != null) {
                if ( task.TECH_External_Who_Id__c == null ) {
                    /*
                 Retour à une valeur WhoId null dans le cas où à l'insertion on est rentré dans le TaskTrigger en beforeInsert,
                 c'est-à-dire qu'on a attribué une valeur de contact juste pour permettre l'insertion
                  */
                    task.WhoId = null;
                }

                System.debug('-- TaskTriggerHandler : task.TECH_External_What_Id__c : ' + task.TECH_External_What_Id__c);

                /*
                Utilisation du préfixe de WhatId pour récupérer le nom de l'objet correspondant
                 */
                String whatIdPrefix = task.TECH_External_What_Id__c.substring(0, 3);

                if(!prefixObjects.containsKey(whatIdPrefix)) {
                    prefixObjects.put(whatIdPrefix, Utils.findObjectNameFromRecordIdPrefix(whatIdPrefix));
                  /* Si whatIdPrefix existe, récupération de la liste associée + ajout item, sinon création entrée avec nouveau
                    préfixe
                     */
                    whoAndWhatTechIdsMap.put(whatIdPrefix, new List<Id>{task.TECH_External_What_Id__c});
                } else {
                    whoAndWhatTechIdsMap.get(whatIdPrefix).add(task.TECH_External_What_Id__c);
                }
            }
            tasksToUpdate.add(task);
        }

        /* Map qui va stocker les TECH_External_Id__c, TECH_External_Who_Id__c, TECH_External_What_Id__c
        et les ID correspondants
        */
        Map<String, Id> recordsRelatedToTasks = new Map<String, Id>();

        for (String prefix : prefixObjects.keySet()) {
            // Récupération nom de l'objet
            String objectName = prefixObjects.get(prefix);

            Set<Id> whoAndWhatIds = new Set<Id>(whoAndWhatTechIdsMap.get(prefix));

            // Requête avec la liste d'ID de la map whoAndWhatTechIdsMap sur le nom de l'objet
            String query = 'SELECT Id, TECH_External_Id__c FROM ' + objectName + ' WHERE TECH_External_Id__c IN ' +
                    DataExtractUtils.convertSetToString(whoAndWhatIds);
            List<sObject> sObjects = Database.query(query);

            // Remplissage d'une map
            for (sObject record : sObjects) {
                recordsRelatedToTasks.put((String)record.get('TECH_External_Id__c'), record.Id);
            }
        }

        for (Task task : tasksToUpdate) {
            if (task.TECH_External_Who_Id__c != null) {
                task.whoId = recordsRelatedToTasks.get(task.TECH_External_Who_Id__c);
            }

            if (task.TECH_External_What_Id__c != null) {
                task.whatId = recordsRelatedToTasks.get(task.TECH_External_What_Id__c);
            }
        }

        return tasksToUpdate;
    }
}