/*--------------------------------------------------------------------
-- - Purpose             : Handler pour le trigger EventTrigger
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 23/03/2017  J.NG  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
public class EventTriggerHandler extends TriggerHandler {

    // Maps and list initialized from the Trigger context
    private Map<Id, Event> oldMap;
    private Map<Id, Event> newMap;
    private List<Event> oldList;
    private List<Event> newList;

    // Constructor
    public EventTriggerHandler() {
        this.oldMap = (Map<Id, Event>) Trigger.oldMap;
        this.newMap = (Map<Id, Event>) Trigger.newMap;
        this.oldList = (List<Event>) Trigger.Old;
        this.newList = (List<Event>) Trigger.New;
    }

    protected override void beforeInsert() {
        System.debug('--- BEGIN EventTriggerHandler beforeInsert() ---');

        /* Récupération d'un contact quelconque afin de permettre l'insertion des événements dans la sandbox
        dans le cadre du transfert de données entre les environnements
         */
        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        for (Event e : this.newList) {

            // Vérification qu'on est bien dans le cas d'une insertion de données de la production vers une sandbox
            if (e.TECH_Is_Record_Transferring__c) {
                if (e.TECH_External_What_Id__c != null || e.TECH_External_Who_Id__c != null) {
                /**
                Attribution du premier contact trouvé aux événements pour pouvoir les insérer
                car les champs polymorphiques WhatId et WhoId ne peuvent pas faire référence à des External Id
                 */
                    // Attribution de ce contact au champ WhoId des nouveaux événements
                    e.WhoId = contact.Id;

                    System.debug('-- PARAM e.WhoId : ' + e.WhoId);
                    System.debug('-- PARAM contact.Id : ' + contact.Id);
                }
            }
        }

        System.debug('--- END EventTriggerHandler beforeInsert() ---');
    }

    public override void afterInsert() {
        System.debug('--- BEGIN EventTriggerHandler afterInsert() ---');

        List<Event> eventsJustInserted = this.newList;
        // eventsToUpdateAfterInsert est une variable qui pourra être réutilisée pour des update en after insert
        List<Event> eventsToUpdateAfterInsert = new List<Event>();

        /*
         Vérification si nous sommes en transfert de données entre sandbox, si oui on ajoute les tasks à la liste
         tasksToUpdateAfterInsert pour les mettre à jour
          */
        List<Event> eventsInTransferBetweenSandboxs = completeWhoAndWhatIdFields(eventsJustInserted);
        if (eventsInTransferBetweenSandboxs != null && !eventsInTransferBetweenSandboxs.isEmpty()) {
            eventsToUpdateAfterInsert.addAll(eventsInTransferBetweenSandboxs);
        }

        if (eventsToUpdateAfterInsert != null && !eventsToUpdateAfterInsert.isEmpty()) {
            try {
                Database.update(eventsToUpdateAfterInsert, false);
            } catch (Exception e) {
                System.debug('Update impossible pour en after insert d\'Event' + e);
            }
        }

        System.debug('--- END EventTriggerHandler afterInsert() ---');
    }

    /**
    Lors d'un transfert de données entre la production et une sandbox :
    Méthode qui récupère les valeurs contenues dans les champs TECH_External_What_Id__c et TECH_External_Who_Id__c
    afin de les réattribuer aux champs WhatId et WhoId
    Si les champs TECH_External_What_Id__c et TECH_External_Who_Id__c ne sont pas vides, on réattribue leur
    valeur à WhatId et/ou à WhoId. Sinon, on remet le champ à null (car précédemment nous avons inséré un
    contact au champ WhoId pour permettre l'insertion, mais il n'avait rien à voir avec les événements)
    */
    private static List<Event> completeWhoAndWhatIdFields(List<Event> newEvents) {

        Set<Id> ids = new Set<Id>();
        for (Event e : newEvents) {
            ids.add(e.Id);
        }

        List<Event> events = [SELECT Id, WhoId, WhatId, TECH_External_Who_Id__c, TECH_External_What_Id__c, TECH_Is_Record_Transferring__c
                                    FROM Event
                                    WHERE Id IN :ids];


        // Vérification qu'on est dans le cas d'un transfert de données avec le champ TECH_Is_Record_Transferring__c à true
        for (Integer i = 0; i < events.size() ; i++) {
            if (!events.get(i).TECH_Is_Record_Transferring__c == true) {
                events.remove(i);
            }
        }

        if (events.isEmpty()){
            return null;
        }

        // Map qui va stocker les préfixes d'ID et le nom de l'objet correspondant
        Map<String, String> prefixObjects = new Map<String, String>();

        // Map qui va stocker les préfixes d'ID et la liste des TECH_External_Who_Id__c et TECH_External_What_Id__c
        Map<String, List<Id>> whoAndWhatTechIdsMap = new Map<String, List<Id>>();

        List<Event> eventsToUpdate = new List<Event>();

        for (Event event : events) {
            /* On repasse le champ TECH_Is_Record_Transferring__c à false pour que les enregistrements ne repassent
             plus dans cette partie de code
              */
            event.TECH_Is_Record_Transferring__c = false;

            if (event.TECH_External_Who_Id__c != null) {
                System.debug('-- EventTriggerHandler : event.TECH_External_Who_Id__c : ' + event.TECH_External_Who_Id__c);

                /*
                Utilisation du préfixe de WhoId pour récupérer le nom de l'objet correspondant
                 */
                String whoIdPrefix = event.TECH_External_Who_Id__c.substring(0, 3);
                if(!prefixObjects.containsKey(whoIdPrefix)) {
                    prefixObjects.put(whoIdPrefix, Utils.findObjectNameFromRecordIdPrefix(whoIdPrefix));

                    /* Si whoIdPrefix existe, récupération de la liste associée + ajout item, sinon création entrée avec nouveau
                    préfixe
                     */
                    whoAndWhatTechIdsMap.put(whoIdPrefix, new List<Id>{event.TECH_External_Who_Id__c});
                } else {
                    whoAndWhatTechIdsMap.get(whoIdPrefix).add(event.TECH_External_Who_Id__c);
                }
            }

            if (event.TECH_External_What_Id__c != null) {
                if ( event.TECH_External_Who_Id__c == null ) {
                    /*
                 Retour à une valeur WhoId null dans le cas où à l'insertion on est rentré dans le TaskTrigger en beforeInsert,
                 c'est-à-dire qu'on a attribué une valeur de contact juste pour permettre l'insertion
                  */
                    event.WhoId = null;
                }

                System.debug('-- EventTriggerHandler : event.TECH_External_What_Id__c : ' + event.TECH_External_What_Id__c);

                /*
                Utilisation du préfixe de WhatId pour récupérer le nom de l'objet correspondant
                 */
                String whatIdPrefix = event.TECH_External_What_Id__c.substring(0, 3);

                if(!prefixObjects.containsKey(whatIdPrefix)) {
                    prefixObjects.put(whatIdPrefix, Utils.findObjectNameFromRecordIdPrefix(whatIdPrefix));
                  /* Si whatIdPrefix existe, récupération de la liste associée + ajout item, sinon création entrée avec nouveau
                    préfixe
                     */
                    whoAndWhatTechIdsMap.put(whatIdPrefix, new List<Id>{event.TECH_External_What_Id__c});
                } else {
                    whoAndWhatTechIdsMap.get(whatIdPrefix).add(event.TECH_External_What_Id__c);
                }
            }
            eventsToUpdate.add(event);
        }

        /* Map qui va stocker les TECH_External_Id__c, TECH_External_Who_Id__c, TECH_External_What_Id__c
        et les ID correspondants
        */
        Map<String, Id> recordsRelatedToEvents = new Map<String, Id>();

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
                recordsRelatedToEvents.put((String)record.get('TECH_External_Id__c'), record.Id);
            }
        }

        for (Event event : eventsToUpdate) {
            if (event.TECH_External_Who_Id__c != null) {
                event.whoId = recordsRelatedToEvents.get(event.TECH_External_Who_Id__c);
            }

            if (event.TECH_External_What_Id__c != null) {
                event.whatId = recordsRelatedToEvents.get(event.TECH_External_What_Id__c);
            }
        }

        return eventsToUpdate;
    }
}