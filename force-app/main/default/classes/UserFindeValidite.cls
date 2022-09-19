/*--------------------------------------------------------------------
-- - Purpose             : Job de gestion des fins de validité des comptes utilisateur
--                         Daily at 19:00
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- XX/XX/20XX  M.BE  EM Lyon  1.0      Initial version
--------------------------------------------------------------------*/
global class UserFindeValidite implements Schedulable {
    
    global void execute(SchedulableContext SC) {        
        Date currentDate = system.Date.today();
        List<User> lUsers = [select Id, isActive from user where  IsActive=true and date_de_fin_de_validite__c !=null and date_de_fin_de_validite__c <=: currentDate  ];

        // si aucun enregistrement trouvé, on met fin au traitement
        if(lUsers.size()==0)
            return;
        // sinon on continue
        for(User u : lUsers){             
            u.IsActive=false;
        }
        
        update lUsers;         
     }
}