/*--------------------------------------------------------------------
-- - Purpose           : DAL
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
public class DAL {

    // Fonction qui récupère la liste des fonctions
    /*public static Map<ID,String> getFonctionByIds (set<ID> p_FonctionIds){
        List<Fonction__c> listFonction = [select id,Libell_de_la_fonction__c from Fonction__c where id IN: p_FonctionIds];

        Map<ID,String> fonctions = new Map<ID,String>();

        for(Fonction__c fonc : listFonction){
            fonctions.put(fonc.id, fonc.Libell_de_la_fonction__c);
        }

        return fonctions;
    }
    */

    //Fonction qui récupère la liste des pistes
    public static List<Lead> getLeads(String queryCondition){

        queryCondition = (queryCondition != null ? queryCondition.replaceAll('\'true\'', 'true') : queryCondition);
        queryCondition = (queryCondition != null ? queryCondition.replaceAll('\'false\'', 'false') : queryCondition);

        System.debug('### Resultat :' + queryCondition);
        try{
            return Database.query('SELECT FirstName,LastName,title ,Company,Email,Id FROM Lead' + queryCondition + ' LIMIT 50');
        }Catch(Exception e){
            return new List<Lead>();
        }
    }

    //Fonction qui récupère la liste des contacts
    public static List<Contact> getContacts(String queryCondition){

        queryCondition = (queryCondition != null ? queryCondition.replaceAll('\'true\'', 'true') : queryCondition);
        queryCondition = (queryCondition != null ? queryCondition.replaceAll('\'false\'', 'false') : queryCondition);

        System.debug('### Resultat :' + queryCondition);
        try{
            return Database.query('SELECT FirstName,LastName,accountid,title ,Email,Id FROM contact' + queryCondition + ' LIMIT 50');
        }Catch(Exception e){
            return new List<Contact>();
        }
    }

    //Fonction qui récupère la liste des statuts de la campagne
    public static List<CampaignMemberStatus> getCampaignMemberStatus(String id){
         return [SELECT ID,Label FROM CampaignMemberStatus where campaignid = :id];
    }

    //Fonction qui récupère le nom de la campagne
    public static String getCampaignMemberName(String id){
         Campaign c = [SELECT Name FROM Campaign where id = :id];

         return c.name;
    }
    
    //Fonction qui récupère l'id du propriétaire de la campagne
    public static String getCampaignOwnerId(String id){
         Campaign c = [SELECT Owner.Id FROM Campaign where id = :id];

         return c.Owner.Id;
    }
    
    //Fonction qui récupère l'email du propriétaire de la campagne
    public static String getCampaignOwnerEmail(String id){
         Campaign c = [SELECT Owner.Email FROM Campaign where id = :id];

         return c.Owner.Email;
    }

    //Fonction qui récupère la liste des leads avec leur status dans la campage
    public static Map<String,String> getMemberCampaignStatus(String id){

        List<CampaignMember> laliste = new List<CampaignMember>();
        laliste = [SELECT LeadId,Status FROM CampaignMember where campaignid = :id];

        Map<String,String> lemap = new Map<String,String>();

        for(CampaignMember c : laliste)
            lemap.put(c.LeadId, c.Status);

        return lemap;
    }

    //Fonction qui récupère la liste des contacts avec leur status dans la campage
    public static Map<String,String> getMemberCampaignStatusContact(String id){

        List<CampaignMember> laliste = new List<CampaignMember>();
        laliste = [SELECT ContactId,Status FROM CampaignMember where campaignid = :id];

        Map<String,String> lemap = new Map<String,String>();

        for(CampaignMember c : laliste)
            lemap.put(c.ContactId, c.Status);

        return lemap;
    }



    // //Fonction qui récupère la liste des contacts avec leur date dans la campage
    // public static Map<String,Datetime> getMemberCampaignContactLastModifiedDate (String id){
    //
    //     List<CampaignMember> laliste = new List<CampaignMember>();
    //     laliste = [SELECT ContactId,LastModifiedDate  FROM CampaignMember where campaignid = :id];
    //
    //     Map<String,Datetime> lemap = new Map<String,Datetime>();
    //
    //     for(CampaignMember c : laliste)
    //         lemap.put(c.ContactId, c.LastModifiedDate );
    //
    //     return lemap;
    // }

    // //Fonction qui récupère la liste des leads avec leur id dans la campage
    // public static Map<String,Lead> getMemberCampaignLead(String id){
    //
    //     List<CampaignMember> laliste = new List<CampaignMember>();
    //     List<String> lalisteIds = new List<String>();
    //     laliste = [SELECT LeadId FROM CampaignMember where campaignid = :id];
    //
    //     for(CampaignMember c :laliste )
    //         lalisteIds.add(c.LeadId);
    //
    //
    //     List<Lead> laliste2 = new List<Lead>();
    //     laliste2 = [SELECT FirstName,LastName,title ,Company,Email,Id FROM Lead where Id in :lalisteIds];
    //
    //     Map<String,Lead> lemap = new Map<String,Lead>();
    //
    //     for(Lead c : laliste2)
    //         lemap.put(c.Id, c);
    //
    //     return lemap;
    // }

    // //Fonction qui récupère la liste des contacts avec leur id dans la campage
    // public static Map<String,Contact> getMemberCampaignContact(String id){
    //
    //     List<CampaignMember> laliste = new List<CampaignMember>();
    //     List<String> lalisteIds = new List<String>();
    //     laliste = [SELECT ContactId FROM CampaignMember where campaignid = :id];
    //
    //     for(CampaignMember c :laliste )
    //         lalisteIds.add(c.ContactId);
    //
    //
    //     List<Contact> laliste2 = new List<Contact>();
    //     laliste2 = [SELECT FirstName,LastName,accountid,title ,Email,Id FROM Contact where Id in :lalisteIds];
    //
    //     Map<String,Contact> lemap = new Map<String,Contact>();
    //
    //     for(Contact c : laliste2)
    //         lemap.put(c.Id, c);
    //
    //     return lemap;
    // }

    // //Fonction qui récupère la liste des contacts ajoutés par rapport avec leur id dans la campage
    // public static Map<String,Contact> getMemberCampaignContactRapport(String id){
    //
    //     List<CampaignMember> laliste = new List<CampaignMember>();
    //     List<String> lalisteIds = new List<String>();
    //     laliste = [SELECT ContactId,LastModifiedDate,Date_chargement_VF__c FROM CampaignMember where campaignid = :id];
    //
    //     for(CampaignMember c :laliste )
    //     if(c.Date_chargement_VF__c == null || c.LastModifiedDate > c.Date_chargement_VF__c)
    //         lalisteIds.add(c.ContactId);
    //
    //
    //     List<Contact> laliste2 = new List<Contact>();
    //     laliste2 = [SELECT FirstName,LastName,accountid,title ,Email,Id FROM Contact where Id in :lalisteIds];
    //
    //     Map<String,Contact> lemap = new Map<String,Contact>();
    //
    //     for(Contact c : laliste2)
    //         lemap.put(c.Id, c);
    //
    //     return lemap;
    // }

    // //Fonction qui récupère la liste des contacts/leads
    // public static Map<String,String> getMemberCampaignContactLead(String id){
    //
    //     List<CampaignMember> laliste = new List<CampaignMember>();
    //     List<String> lalisteIds = new List<String>();
    //     laliste = [SELECT ContactId,LeadId,Id
    //                 FROM CampaignMember
    //                 where campaignid = :id];
    //
    //
    //     Map<String,String> lemap = new Map<String,String>();
    //
    //     for(CampaignMember c : laliste )
    //         if(c.ContactId != null) lemap.put(c.ContactId, c.Id );
    //         else if (c.LeadId != null) lemap.put(c.LeadId,  c.Id);
    //
    //     return lemap;
    // }

    //Fonction qui récupère la liste des Leads avec leur id dans la campage
    public static Map<String,String> getMemberCampaignId(String id){

        List<CampaignMember> laliste = new List<CampaignMember>();
        laliste = [SELECT LeadId,Id FROM CampaignMember where campaignid = :id];

        Map<String,String> lemap = new Map<String,String>();

        for(CampaignMember c : laliste)
            lemap.put(c.LeadId, c.Id);

        return lemap;
    }

    //Fonction qui récupère la liste des Leads avec leur id dans la campage
    public static Map<String,String> getMemberCampaignIdContact(String id){

        List<CampaignMember> laliste = new List<CampaignMember>();
        laliste = [SELECT ContactId,Id FROM CampaignMember where campaignid = :id];

        Map<String,String> lemap = new Map<String,String>();

        for(CampaignMember c : laliste)
            lemap.put(c.ContactId, c.Id);

        return lemap;
    }


    //Fonction qui récupère la liste des membres
    public static List<CampaignMember> getMemberCampaignById(List<CampaignMember> liste){

        return [SELECT Id,Date_chargement_VF__c,lastModifiedDate FROM CampaignMember where id in :liste];

    }

    //Fonction qui récupère la liste des comptes avec leur id
    public static Map<String,String> getAcounts(List<String> ids){

        List<Account> laliste = new List<Account>();
        laliste = [SELECT Id, Name FROM Account where Id in :ids];

        Map<String,String> lemap = new Map<String,String>();

        for(Account c : laliste)
            lemap.put(c.id, c.Name);

        return lemap;
    }

    //Fonction qui récupère la liste des contacts avec leur email
    public static Map<String,Contact> getContactsEmail(List<String> ids){
        System.debug('### Resultat : ' + ids);
        for(String t : ids){
            System.debug('### Resultat id : ' + t);
        }
        List<Contact> laliste = new List<Contact>();
        laliste = [SELECT Id, Email_EM_Lyon__c, Email_de_repli__c, Adresse_Email_Personnelle__c from Contact
                    where Id in :ids];

        Map<String,Contact> lemap = new Map<String,Contact>();

        for(Contact c : laliste)
            lemap.put(c.id, c);

        return lemap;

    }
}