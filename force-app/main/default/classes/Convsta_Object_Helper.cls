/*-------------------------------------------------------------------
-- - Purpose : Helper for Convsta's objects
--
-- - Maintenance History:
--
-- Date        Name  Company     Version  Remarks
-- ----------  ----  ----------- -------  ----------------------------
-- XX/XX/20XX  E.BE  MODIS       1.0      Initial version
-- 14/12/2018  T.CH  MODIS       1.1      Adding method for Resp. Admin. and Tuteur creations, company check & upsert
-- 16/05/2019  T.CH  MODIS       1.2      Adding method to share a file from back office to community
-- 04/06/2019  E.CA  MODIS       1.3      Adding method to map fonction contact
-- 17/12/2019  Y.GA  MODIS		 1.4	  MAJ checkMatchingAccountAndContact : update Account if SIRET already exists, create an Account 
--------------------------------------------------------------------*/
public without sharing class Convsta_Object_Helper {
    
    public static Case checkMatchingAccountAndContact(Id demandeId){
        Case demande = new Case(Id=demandeId);

        try{
            Boolean updateDemandeBool = false;
            // Get entreprise and resp.admin. informations from the company of the request
            Convsta_Entreprise__c entreprise = [SELECT  Id, MD_Demande__r.Convsta_Localisation_de_l_entreprise__c , Nom_Entreprise__c, Pays2__c, Ville__c, //Check existing account & Upsert french account
                                                        Prenom_Signataire_Convention__c, Nom_Signataire_Convention__c, Email_Signataire_Convention__c, Telephone_Signataire_Convention__c, //Check existing & update contact
                                                        SIRET__c, Adresse_Entreprise__c, Code_Postal__c, Tranche_effectif_etablissement__c, Code_NAF__c //Upsert french account                                               
                                                FROM    Convsta_Entreprise__c
                                                WHERE   MD_Demande__c = :demandeId];

            // Check french company : upsert
            if(entreprise.MD_Demande__r.Convsta_Localisation_de_l_entreprise__c == 'En France'){
                List<Pays__c> lPays =  [SELECT  Id
                                        FROM    Pays__c
                                        WHERE   Code_Pays_2_caracteres__c = :entreprise.Pays2__c];
                String codeApe = entreprise.Code_NAF__c.replaceAll('\\W','');
                NAF__c nafRef =    [
                    SELECT  Id
                    FROM    NAF__c
                    WHERE   CODE_APE__c = :codeApe
                    LIMIT 1];
                if(lPays.size() > 0){
                    ID interfaceId = [SELECT Id FROM User WHERE Name = 'Interface'].Id;
                    Boolean accountFound = false ;
                    // 17/12/2019 - Y.GA - MODIS - 1.4
                    List<Account> listAcc = [SELECT Id, 
                                   		  SIRET__c, 
                                   		  Adresse_Rue__c, 
                                   		  CodePays__c,
										  CodeAPE__c,
										  Code_Postal__c,
										  Adresse_Ville__c,
										  Tranche_d_effectif__c,
										  Convsta_Modifie_par_Convsta__c
                                   FROM Account 
                                   WHERE SIRET__c =: entreprise.SIRET__c
                                  ] ;
                    Account acc ;
                    if(listAcc.size()==0){   
                        /*Account*/ acc = new Account(    SIRET__c =              entreprise.SIRET__c,
                                                  Name =                  entreprise.Nom_Entreprise__c,
                                                  Adresse_Rue__c =        entreprise.Adresse_Entreprise__c,
                                                  CodePays__c =           lPays[0].Id,
                                                  CodeAPE__c =            nafRef.Id,
                                                  Code_Postal__c =        entreprise.Code_Postal__c,
                                                  Adresse_Ville__c =      entreprise.Ville__c,
                                                  Tranche_d_effectif__c = entreprise.Tranche_effectif_etablissement__c,
                                                  Convsta_Modifie_par_Convsta__c = true,
                                                  OwnerId= interfaceId);
                        Database.insert(acc, false) ;
                    }
                    else{
                        /*Account*/ acc = listAcc.get(0) ;
                                                  acc.Adresse_Rue__c =        entreprise.Adresse_Entreprise__c;
                                                  acc.CodePays__c =           lPays[0].Id;
                                                  acc.Code_Postal__c =        entreprise.Code_Postal__c;
                                                  acc.Adresse_Ville__c =      entreprise.Ville__c;
                                                  acc.Tranche_d_effectif__c = entreprise.Tranche_effectif_etablissement__c;
                                                  acc.Convsta_Modifie_par_Convsta__c = true;
                        						  if (acc.CodeAPE__c == null) {
                                                    acc.CodeAPE__c =          nafRef.Id;
                                                  }

                        Database.update(acc, false) ;                        
                    }                                                
                    //Database.upsert(acc, Account.Fields.SIRET__c);
                    demande.Convsta_Entreprise__c = acc.Id;
                    updateDemandeBool=true;
                }
            }else{
                List<Account> lMatchingAccount = [  SELECT  Id
                                                    FROM    Account
                                                    WHERE   Name =                                  :entreprise.Nom_Entreprise__c
                                                    AND     CodePays__r.Code_Pays_2_caracteres__c = :entreprise.Pays2__c
                                                    AND     Adresse_Ville__c =                      :entreprise.Ville__c];
                // Affect existing foreign account to request
                if(lMatchingAccount.size() > 0){
                    demande.Convsta_Entreprise__c = lMatchingAccount[0].Id;
                    updateDemandeBool=true;
                }
            }
            // Update contacts if we have a company
            if(demande.Convsta_Entreprise__c != null){
                // Get tuteur informations from the mission of the request
                Convsta_Mission__c mission = [  SELECT  Id,
                                                        Prenom_Tuteur_Entreprise__c, Nom_Tuteur_Entreprise__c, Email_Tuteur_Entreprise__c, Telephone_Tuteur_Entreprise__c
                                                FROM    Convsta_Mission__c
                                                WHERE   MD_Demande__c = :demande.Id];
                
                // Check for existing tuteur or resp.admin from mission and company
                List<Contact> lMatchingContacts = [ SELECT      Id, LastName, FirstName, AccountId, Email, Phone
                                                    FROM        Contact
                                                    WHERE(      LastName  = :entreprise.Nom_Signataire_Convention__c
                                                            AND FirstName = :entreprise.Prenom_Signataire_Convention__c
                                                            AND AccountId = :demande.Convsta_Entreprise__c)
                                                    OR(         LastName  = :mission.Nom_Tuteur_Entreprise__c
                                                            AND FirstName = :mission.Prenom_Tuteur_Entreprise__c
                                                            AND AccountId = :demande.Convsta_Entreprise__c)];
                if(lMatchingContacts.size() > 0){
                    List<Contact> ctcList = new List<Contact>();
                    for(Contact ctc :lMatchingContacts){
                        //Responsable Administratif presence
                        if(     ctc.LastName    == entreprise.Nom_Signataire_Convention__c
                            &&  ctc.FirstName   == entreprise.Prenom_Signataire_Convention__c
                            &&  ctc.AccountId   == demande.Convsta_Entreprise__c)
                        {
                            ctc.Phone = entreprise.Telephone_Signataire_Convention__c;
                            ctc.Email = entreprise.Email_Signataire_Convention__c;
                            ctcList.add(ctc);

                            demande.Responsable_administratif_entreprise__c = ctc.Id;
                            updateDemandeBool= true;
                        }
                        
                        // Tuteur presence
                        if(     ctc.LastName    == mission.Nom_Tuteur_Entreprise__c
                            &&  ctc.FirstName   == mission.Prenom_Tuteur_Entreprise__c
                            &&  ctc.AccountId   == demande.Convsta_Entreprise__c)
                        {
                            ctc.Phone = mission.Telephone_Tuteur_Entreprise__c;
                            ctc.Email = mission.Email_Tuteur_Entreprise__c;
                            ctcList.add(ctc);

                            demande.Convsta_Tuteur__c = ctc.Id;
                            updateDemandeBool= true;
                        }
                    }
                    if(ctcList.size()>0){
                        update ctcList;
                    }
                }
            }

            if(updateDemandeBool){
                update demande;
            }
            
            return demande;
        }catch(Exception e){
            
            demande.Convsta_eSign_Errors__c += 'Erreur lors de la méthode checkMatchingAccountAndContact :\r\n';
            demande.Convsta_eSign_Errors__c += 'Numéro de la ligne en erreur : ' + e.getLineNumber() + '\r\n';
            demande.Convsta_eSign_Errors__c += 'Message de l\'erreur : ' + e.getMessage() + '\r\n';
            demande.Convsta_eSign_Errors__c += 'Trace de l\'erreur : ' + e.getStackTraceString() + '\r\n';
            demande.Convsta_eSign_Errors__c += 'Type de l\'erreur : ' + e.getTypeName() + '\r\n';
            demande.Convsta_eSign_Errors__c += 'Cause de l\'erreur : ' + e.getCause();
            system.debug(demande.Convsta_eSign_Errors__c);
            update demande;

            return demande;
        }        
    }

    public static void setIsSoumisEtudiant(List<SObject> triggerNew) {
        if(UserInfo.getUserType()!='Standard'){
            for(SObject obj:triggerNew){
                obj.put('is_soumis_etudiant__c',true);
            }
        }
    }

    @AuraEnabled
    public static void caseSetDocumentAVerifier(Id caseId, String typeDocument) { 
        System.debug('typeDocument : '+typeDocument);
        update new Case(Id=caseId, Convsta_Document_a_verifier__c=true, Convsta_Type_de_document__c=typeDocument);
    }

    public static void handleTrigger(List<SObject> triggerNew, Boolean isUpdate, Boolean isBefore){
        if(isUpdate && isBefore){
            setIsSoumisEtudiant(triggerNew);
        }
    }

    @AuraEnabled
    public static void evalSetEvaluee(Id evalId) { 
        update new Convsta_Evaluation__c(Id=evalId, Statut__c='Évaluée', Date_Reception_Evalutation__c= dateTime.now());
    }
    private static Group internalCareerCenterQueue = null;
    public static Group getCareerCenterQueue(){
        if(internalCareerCenterQueue == null){
        	internalCareerCenterQueue =   [SELECT Id
                       FROM Group WHERE 
                       DeveloperName = 'Convsta_En_attente_de_validation_admin'];
        }
        return internalCareerCenterQueue;
    }
       @AuraEnabled
    public static void shareFileToCommunity(Id caseId, Id documentId){
        Case demande = [SELECT Id FROM Case WHERE Id =:caseId LIMIT 1];
        demande.Status ='Convention signée';
        demande.Convsta_Statut_Signature__c ='Signée';
        demande.Date_Reception_Convention__c =Datetime.now();
        update demande;

        ContentDocumentLink cdl = [SELECT Id,LinkedEntityId FROM ContentDocumentLink WHERE ContentDocumentId =:documentId AND LinkedEntityId =:caseId LIMIT 1];
        cdl.ShareType = 'V';
        cdl.Visibility = 'AllUsers';
        update cdl;
    }
    public static String mapFonctionContact(String inFonctionString){
        string outFonctionCodeeString ='';
        switch on inFonctionString {
            when 'Commercial/Ventes' {
                outFonctionCodeeString = 'Conseil Commercial/Ventes';
            }
            when 'Direction Générale' {
                outFonctionCodeeString = 'Directeur ou Conseil en Stratégie';
            }
            when 'Enseignement/Education' {
                outFonctionCodeeString = 'Professeur';
            }
            when 'Etud/Recherche/Dévelop/Qualité' {
                outFonctionCodeeString = 'Conseil Etudes/Recherche';
            }
            when 'Finance/Gest./Adminis./Juridi.' {
                outFonctionCodeeString = 'Consultant Finance/Gestion/Audit';
            }
            when 'Marketing/Communication' {
                outFonctionCodeeString = 'Conseil en Marketing';
            }
            when 'Organisation/Systèmes d’Informations' {
                outFonctionCodeeString = 'Conseil Organis./SI';
            }
            when 'Production/Achats' {
                outFonctionCodeeString = 'Responsable des Achats';
            }
            when 'Ressources Humaines/Formation' {
                outFonctionCodeeString = 'Conseil en Ress. Humaines/ Outplacement';
            }
        }
        return outFonctionCodeeString;
    }

    @AuraEnabled
    public static void updateEvaluationDocumentId(Id evalId, Id evalDocumentId) { 
        Convsta_Evaluation__c eval = [SELECT Id, Demande__c 
                                        FROM Convsta_Evaluation__c
                                        WHERE Id= :evalId];
        Case demande = [SELECT Id, Convsta_EvaluationDocumentId__c
                        FROM Case
                        WHERE Id = :eval.Demande__c];
        demande.Convsta_EvaluationDocumentId__c = evalDocumentId;
        update demande;
        ContentDocumentLink cdl = new ContentDocumentLink(
            ContentDocumentId =evalDocumentId , 
            LinkedEntityId =demande.Id,
            ShareType = 'V',
            Visibility = 'AllUsers'
            );
        insert cdl;
    }
    @AuraEnabled
    public static void uploadAvenant(Id avenantId, Id avenantcontentDocumentId){
        try {
        Case demande = [SELECT Id,ParentId
                        FROM   Case 
                        WHERE  Id = :avenantId LIMIT 1];
        
        List<ContentDocumentLink> listCl = new List<ContentDocumentLink>();
        insert new ContentDocumentLink(LinkedEntityId = demande.ParentId, ContentDocumentId = avenantcontentDocumentId, ShareType = 'I', Visibility='AllUsers');
        demande.Status ='Avenant signé';
        demande.Convsta_Statut_Signature__c = 'Signée';
        demande.Convsta_Convention__c = true;
        demande.Date_Reception_Convention__c = Datetime.now();
        update demande; 
        
        ContentDocumentLink avenantCdl =[Select id from ContentDocumentLink Where LinkedEntityId = :avenantId AND ContentDocumentId = :avenantcontentDocumentId LIMIT 1];
        avenantCdl.ShareType = 'I';
        avenantCdl.Visibility='AllUsers';
        update avenantCdl;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}