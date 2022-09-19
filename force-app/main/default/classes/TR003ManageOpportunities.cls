/*--------------------------------------------------------------------
-- - Purpose             : Implementation of methods called by triggers on opportunities.
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  XXXX  XXXXXXX  1.0      Initial version
-- 14/02/2018  T.CH  MODIS    2.0      1018's implementation 
--------------------------------------------------------------------*/
global class TR003ManageOpportunities {

    public static void checkIncrementCompteurOPPT(List<Opportunity> lOpp, Boolean forceOppLine) {
        List<Opportunity> lOppToUpdate = new List<Opportunity>();

        Id recordTypeFormationCourteId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Formation courte');
        Id recordTypeProgrammeLongDiplomantId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Programme Long Diplômant');
        Id recordTypeFormationIntraId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Formation intra-entreprise');
        Id recordTypeFormationInitialeId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Formation initiale');    
        
        // Filtrage des opp concernées
        for(Opportunity opp :lOpp) {
            // Si l'opp n'a pas encore de Code Agresso
            if(opp.Code_Agresso_Opportunit__c == null){
                if (    (opp.RecordTypeId == recordTypeFormationCourteId
                         && ((opp.StageName == 'Pré inscrit') || (opp.StageName == 'Inscrit')))
                    ||  (opp.RecordTypeId == recordTypeProgrammeLongDiplomantId
                         && ((opp.StageName == 'Admis') || (opp.StageName == 'Intégré') || (opp.StageName == 'Candidat')))
                    ||  (opp.RecordTypeId == recordTypeFormationIntraId)  
                    ){
                        lOppToUpdate.add(opp);
                }
            }         
        }
        
        //Pour les opp portant sur un apprentissage on doit récupérer le format du produit sur les oppLineItem
        Map<Id,Opportunity> m = new Map<Id,Opportunity>([SELECT Id, Compteur_OPPT__c, Code_Agresso_Opportunit__c, RecordTypeId, StageName, (SELECT Id, Famille__c from OpportunityLineItems WHERE Famille__c = 'Programme apprentissage') FROM Opportunity WHERE Id IN:lOpp]);
        if(m.size()>0){
        for(Opportunity oppt :lOpp) {
            Integer count = 0;
            if(oppt.Code_Agresso_Opportunit__c == null
            	&& oppt.RecordTypeId == recordTypeFormationInitialeId
               	&& oppt.StageName == 'Inscrit'
              	&& (m.get(oppt.id).OpportunityLineItems).size()>0 ){
                  for(OpportunityLineItem oli: m.get(oppt.id).OpportunityLineItems){
                	count++;
            		}
                }
            		if(count>0){
               	 lOppToUpdate.add(oppt);
              	 }  
            }
        }
        
        if (lOppToUpdate.size() > 0) {
            // Si la MàJ des oppLine est forcée 
            if (forceOppLine) {
                // Récupérer les oppLine des opp
                Set<Id> oppIds = new Set<Id>();
                for (Opportunity opp: lOppToUpdate) {
                    oppIds.add(opp.Id);
                }                
                List<OpportunityLineItem> oppLineItem = [
                    SELECT Id, Code_OLI__c, CodeAgresso_Poste_Opportunite__c
                    FROM OpportunityLineItem
                    WHERE OpportunityId in :oppIds
                ];
                
                if(oppLineItem.size() > 0){
                	// MàJ forcée des oppLine
                	TR002ManageOpportunityLineItem.checkIncrementCompteurOPPLine(oppLineItem, true);   
                }
            } else {
                // Incrémenter les compteur du Code Agreso des opp
                Integer lastCompteurOPPT = TR003ManageOpportunities.getLastCompteurOPPT();
                TR003ManageOpportunities.IncrementCompteurOPPT(lOppToUpdate, lastCompteurOPPT);
            }
        }
    }
    
    public static Integer getLastCompteurOPPT() {
        Integer lastCompteurOpp = 0;
        Date lastYear = Date.today().addMonths(-12);
        // Récupérer le dernier enregistrement avec un Compteur_OPPT
        List<Opportunity> lastOppCompteurOPPT = [SELECT Id, Compteur_OPPT__c, createdDate 
                                                 FROM Opportunity 
                                                 WHERE createdDate > :lastYear
                                                 AND Compteur_OPPT__c > 0 
                                                 ORDER BY Compteur_OPPT__c DESC 
                                                 LIMIT 1];

        // Récupérer la dernière valeur du Code_OPPT
        if (lastOppCompteurOPPT.size() != 0){
            lastCompteurOpp = (Integer)lastOppCompteurOPPT[0].Compteur_OPPT__c;
        }
        return lastCompteurOpp;
    }

    public static void IncrementCompteurOPPT(List<Opportunity> lOpp, Integer lastCompteurOPPT){
        for(Opportunity opp :lOpp){
            lastCompteurOPPT++;
            opp.Compteur_OPPT__c = lastCompteurOPPT;
        }
    }
    
    public static void UpdateOppsNumber(Set<Id> psContactsIds){
        // Récupération du nombre d'opp par contact central par statut d'opportunité par exercice
        List<AggregateResult> ctcCentralByStage = [SELECT Contact_central__c,Contact_central__r.RecordTypeId Contact_central_RecordTypeId, RecordTypeId rtId, ExerciceNum_ro__c, StageName, Exercice__c, Count(Id)
                                                   FROM Opportunity
                                                   WHERE Contact_central__c IN :psContactsIds
                                                   GROUP BY Contact_central__c, StageName, Exercice__c,ExerciceNum_ro__c, RecordTypeId, Contact_central__r.RecordTypeId,InterfaceExternalId__c
                                                   ORDER BY Contact_central__c];

        if(ctcCentralByStage.size() > 0){
            Map<Id,Contact> mapIdCon = new Map<Id,Contact>();
            for (AggregateResult aggregateResult : ctcCentralByStage){
                // Récupération des RecordTypeId de critères
                Id recordTypeProfessionnelId = APU_ApexUtils.getContactRecordTypeIdByName('Professionnel');
                Id recordTypeFormationCourteId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Formation courte');
                Id recordTypeFormationLongDiplomantId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Programme Long Diplômant');

                // Récupération des critères de comptabilisation
                Set<String> statusEnCours = new Set<String>(Label.OpportunityCriteria.split(';',-1));
                Set<String> statusConseillers = new Set<String>(Label.OpportunityCriteriaSansIP.split(';',-1));
                Set<String> statusProfessionnel = new Set<String>(Label.OpportunityCriteriaProfessionnel.split(';',-1));

                // Détermination de l'exercice actuel
                Date endExerciceDate = Date.newinstance(System.Today().year(), 8, 31);
                Date actualDate = Date.today();
                Integer actualExercice = 0;
                if(actualDate>endExerciceDate){
                    actualExercice = actualDate.year() + 1;
                }else{
                    actualExercice = actualDate.year();
                }

                // Gestion du contact traité précedemment
                Id conId = (Id)aggregateResult.get('Contact_central__c');
                if(!mapIdCon.containsKey(conId)){
                    mapIdCon.put(conId,new Contact(Id=conId,
                                                Nombre_opportunit_s__c='0',
                                                Nombre_opportunites_sur_criteres__c='0',
                                                nb_SIP_en_cours__c=0));
                }
                Contact lastCtc = mapIdCon.get(conId);

                // Calcul du compteur d'opp total
                lastCtc.Nombre_opportunit_s__c = String.valueOf(
                        Integer.valueOf(lastCtc.Nombre_opportunit_s__c)
                    +   Integer.valueOf(aggregateResult.get('expr0'))
                );

                // Calcul du compteur d'opp en cours sur l'exercice en cours
                if (   aggregateResult.get('Contact_central_RecordTypeId') == recordTypeProfessionnelId
                    && statusProfessionnel.contains(String.valueOf(aggregateResult.get('StageName')))
                    && aggregateResult.get('ExerciceNum_ro__c') != null
                    && (aggregateResult.get('rtId') == recordTypeFormationCourteId || aggregateResult.get('rtId') == recordTypeFormationLongDiplomantId)
                ) {
                    Integer year = Integer.valueOf(aggregateResult.get('ExerciceNum_ro__c'));

                    if (year >= actualExercice - 2 && year <= actualExercice + 2) {
                        lastCtc.Nombre_opportunites_sur_criteres__c = String.valueOf(
                            Integer.valueOf(aggregateResult.get('expr0'))
                            +   Integer.valueOf(lastCtc.Nombre_opportunites_sur_criteres__c)
                        );
                    }
                } else {
                    if (statusEnCours.contains(String.valueOf(aggregateResult.get('StageName')))
                        && Integer.valueOf(aggregateResult.get('Exercice__c')) == actualExercice){
                        lastCtc.Nombre_opportunites_sur_criteres__c = String.valueOf(
                                Integer.valueOf(aggregateResult.get('expr0'))
                            +   Integer.valueOf(lastCtc.Nombre_opportunites_sur_criteres__c)
                        );
                    }
                }

                // Calcul du compteur d'opp conseillers sur l'exercice en cours
                if (statusConseillers.contains(String.valueOf(aggregateResult.get('StageName')))
                    && Integer.valueOf(aggregateResult.get('Exercice__c')) == actualExercice)
                {
                    lastCtc.nb_SIP_en_cours__c += Integer.valueOf(aggregateResult.get('expr0'));
                }
            }

            // Modification des contacts
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr = Database.update(mapIdCon.values(), dml);
        }else{
            List<Contact> lCtcToUpdate = new List<Contact>();
            List<Contact> lCtcVides = [SELECT Id, Nombre_opportunit_s__c, Nombre_opportunites_sur_criteres__c, nb_SIP_en_cours__c 
                                      FROM Contact 
                                      WHERE Id in :psContactsIds];

            for(Contact ctc :lCtcVides){
                ctc.Nombre_opportunit_s__c = String.valueOf(0);
                ctc.Nombre_opportunites_sur_criteres__c = String.valueOf(0);
                ctc.nb_SIP_en_cours__c = 0;
                lCtcToUpdate.add(ctc);
            }

            // Modification des contacts
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.AllowSave = true;
            Database.SaveResult[] sr = Database.update(lCtcToUpdate, dml);
        }        
    }

    public static void checkOwnerIdChange(List<Opportunity> lOpp, String oldOwnerId){
        Profile p = [SELECT id, Name
                     FROM Profile
                     WHERE Id = :userinfo.getProfileid()
                     LIMIT 1];
        User currentUser = [SELECT ProfileId, UserRole.Id
                            FROM User
                            WHERE Id = :userinfo.getUserId()
                            LIMIT 1 ];
        Opportunity currentOpp = lOpp[0];
        Set<ID> OwnerIdSet = new Set<ID>();

         for(Opportunity o:lOpp){
             OwnerIdSet.add(o.OwnerId);
         }

        Map<Id, Group> groupMap = new Map<Id, Group>([
            SELECT Id, Name
            FROM Group
            WHERE Name = 'Administrateurs Opportunités'
            ]);

        Map<Id, GroupMember> groupAdminOpp = New Map<Id, GroupMember>([
            SELECT Id, UserOrGroupId
            FROM GroupMember
            WHERE GroupId IN :groupMap.keySet()
            AND UserOrGroupId  = :currentUser.Id
            ]);

        // si l'utilisateur actuel est dans le groupe Administrateurs Opportunités
        // ou si l'utilisateur actuel est dans le profil administrateur ou interface
        // on ne fait rien
        if (groupAdminOpp.size()>0 || p.Name=='Administrateur système' || p.Name =='Interface' || p.Name == 'System Administrator'){
            return;
        } else {
             User newOwner = [SELECT ProfileId, UserRole.Id
                              FROM User
                              WHERE Id = :OwnerIdSet
                              LIMIT 1];
             User oldOwner = [SELECT id, UserRole.id
                              FROM User
                              WHERE id= :oldOwnerId
                              LIMIT 1] ;

            for (Opportunity o:lOpp){
                // cette partie de trigger n'est utilisé que lorsque l'on est en mode saisie manuelle
                // elle ne s'exécute pas pour les traitements en rafale constitués d'un tableau
                // d'enregistrements
                if (newOwner.UserRole.id != oldOwner.UserRole.id ) {
                    o.Adderror('Le propriétaire actuel de l\'opportunité  et le nouveau propriétaire doivent avoir le même rôle !');
                    return;
                }

                if(newOwner.UserRole.id != currentUser.UserRole.Id){
                    o.Adderror('Vous ne pouvez pas réaffecter une opportunité qui n\'est pas dans votre pôle !');
                    return;
                }
           }
        }
    }

    // 20150212_ABO: Nouveau traitement d'assignation de suiveur à une opportunité.
    // Déclenché en after insert sur OpportunityLineItem
    public static void AssignOwnerToOppty(Map<Id,OpportunityLineItem> newopplines) {
        // Liste des opportunités dont le suiveur est à assigner (i.e. qui ont un InterfaceExternalId__c non nul):
        List<Opportunity> opptyListToUpdate = [SELECT Id, OwnerId, Contact_central__c, RecordtypeId 
                                               FROM Opportunity
                                               WHERE Id IN (SELECT OpportunityId
                                                            FROM OpportunityLineItem
                                                            WHERE Id = : newopplines.keySet())
                                               AND InterfaceExternalId__c <> null
                                               AND StageName <> 'Clos (Perdu)'];

        if (!opptyListToUpdate.isEmpty()) {
            // Ensemble des id de contacts centraux
            Set<Id> contactIds = new Set<Id>();
            // Ensemble des id des opportunités à traiter
            Set<Id> opptyToUpdateIds = new Set<Id>();
            for (Opportunity oppty : opptyListToUpdate) {
                opptyToUpdateIds.add(oppty.Id);
                if (oppty.Contact_central__c != null)
                contactIds.add(oppty.Contact_central__c);
            }

            // Map associant un id d'opportunité à un id de ligne d'opportunité (pour la gestion d'erreur)
            Map<Id,OpportunityLineItem> opptyLineByOpptyId = new Map<Id,OpportunityLineItem>();
            // Map associant un id d'opportunité à l'id de son produit
            Map<Id, Id> productIdByOpptyId = new Map<Id, Id>();
            for (OpportunityLineItem opptyLine : newopplines.values()) {
                productIdByOpptyId.put(opptyLine.OpportunityId, opptyLine.Product2Id);
                opptyLineByOpptyId.put(opptyLine.OpportunityId, opptyLine);
            }

            // Map des produits associés
            Map<Id, Product2> productMap = new Map<Id, Product2>([SELECT Id, Suiveur__c 
                                                                  FROM Product2 
                                                                  WHERE Id in : productIdByOpptyId.values()]);

            // Mise à jour du suiveur (i.e. le owner) des opportunités à traiter
            for (Opportunity oppty : opptyListToUpdate) {
                // => On affecte le suiveur du produit
                Id productId = productIdByOpptyId.get(oppty.Id);
                Product2 p = productMap.get(productId);
                if (p.Suiveur__c != null) {
                    oppty.OwnerId = p.Suiveur__c;
                }
            }

            try {
                update opptyListToUpdate;
            }catch (System.DMLException e) {
                Boolean errorLogged = false;
                for (Integer i=0; i<e.getNumDml();i++) {
                    Id opptyId = e.getDmlId(i);
                    if (opptyLineByOpptyId.containsKey(opptyId)) {
                        opptyLineByOpptyId.get(opptyId).addError(e.getDmlMessage(i));
                        errorLogged = true;
                    }
                }

                if (!errorLogged)
                    throw e;
            }
        }
    }

    public static void AutomaticConvertLeads(Map<Id, Opportunity> opportunityMap){
       List<Contact> contacts= [SELECT Id, Nature_du_premier_contact__c, Email from Contact where id in (SELECT Contact_central__c from Opportunity where id in :opportunityMap.keySet()) AND Nature_du_premier_contact__c = 'Site internet'];

       if (contacts != null && !contacts.isEmpty()) {
           List<String> emails = new List<String>();
           for (Contact contact : contacts) {
               emails.add(contact.Email);
           }

           List<Id> leadIds = new List<Id>(new Map<Id, Lead>([SELECT Id from Lead where Email in :emails AND (RecordType.developerName = 'Sur_Mesure' OR RecordType.developerName = 'Formation_courte' OR RecordType.developerName = 'Principal' OR RecordType.developerName = 'Programme_Long_Diplomant')]).keySet());
           
           if (!leadIds.isEmpty()) {
                AutoConvertLeads.leadAssign(leadIds);
           }
       }
    }
}