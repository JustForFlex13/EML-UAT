/*--------------------------------------------------------------------
-- - Purpose             : Utils class
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- XX/XX/20XX  M.BE  EM Lyon  1.0      Initial version
--------------------------------------------------------------------*/
Public class Utils{
    
 // Maj automatique du champ département lorsque le pays est FRANCE et que le code postal 
    // adresse personnelle est renseigné
    
    
    public static void setDptAccount(List<Account> listAcctNew){
        // on crée une liste des départements en dehors de la boucle d'enregistrements
        // pour la màj automatique du dpt en fonction du code postal saisi
        List<D_partement__c> listDpt = [select id, Code_d_partement__c from D_partement__c];
        String myDptCode='';
        try{
            for(integer i=0;i<listAcctNew.size();i++){
                
                
                if(listAcctNew[i].CountryName__c == 'FRANCE' && listAcctNew[i].Code_Postal__c!=null && listAcctNew[i].Code_Postal__c.trim().length()==5  ){
                    myDptCode = listAcctNew[i].Code_Postal__c.substring(0,2);
                    for(D_partement__c d: listDpt  )
                    {
                        
                        if(d.Code_d_partement__c==myDptCode){
                            listAcctNew[i].Departement__c= d.Id;     
                        break;
                        }
                    }
                }
                
                // on ne peux pas choisir un code postal débutant par "99"
                
                if(listAcctNew[i].CountryName__c == 'FRANCE' && MyDptCode=='99'  ){
                    listAcctNew[i].addError('Vous ne pouvez pas sélectionner ce code postal pour le pays FRANCE !');
                }
                
            }
        }
        catch(Exception e){
            System.debug(e);
        }
    }
    
    public static void setDptContact(List<Contact> listContactsNew){
        // on crée une liste des départements en dehors de la boucle d'enregistrements
        // pour la màj automatique du dpt en fonction du code postal saisi
        List<D_partement__c> listDpt = [select id, Code_d_partement__c from D_partement__c];
        String myDptCode='';
        //System.debug('Nb de contacts'+listContactsNew.size());
        
        try{
            for(integer i=0;i<listContactsNew.size();i++){
                
                if(listContactsNew[i].CountryName__c == 'FRANCE' && listContactsNew[i].Adresse_code_postal__c!=null && listContactsNew[i].Adresse_code_postal__c.trim().length()==5  ){
                    myDptCode =  listContactsNew[i].Adresse_code_postal__c.substring(0,2); 
                    //System.debug('Dpt Contact' + myDptCode);
                    for(D_partement__c d: listDpt  )
                    {
                        
                        if(d.Code_d_partement__c==myDptCode){
                            listContactsNew[i].D_partement__c= d.Id;
                            break;
                            }
                        
                        
                    }
                    
                }
                
                
                // on ne peux pas choisir un code postal débutant par "99"
                
                if(listContactsNew[i].CountryName__c == 'FRANCE' && MyDptCode=='99'  ){
                    listContactsNew[i].addError('Vous ne pouvez pas sélectionner ce code postal pour le pays FRANCE !');
                }
                
                
            }
        }
        catch(Exception e){
            System.debug(e);
        }
    }
    
    
    /**
@Author : Julie NGUYEN - Modis
Created on : 23/03/2017
Méthode permettant de récupérer le nom d'un objet à partir du préfix de l'ID d'un enregistrement
*/
    public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix) {
        String objectName = '';
        try{
            // Récupère le préfixe à partir de l'ID de l'enregistrement
            String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
            
            // Récupération du schéma
            Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe();
            
            // Boucle à travers tous les types de sObjects retournés par le Schéma
            for(Schema.SObjectType stype : gd.values()){
                Schema.DescribeSObjectResult r = stype.getDescribe();
                String prefix = r.getKeyPrefix();
                // System.debug('-- Prefix is ' + prefix);
                
                // Vérifie que le préfixe matche avec le préfixe requêté
                if(prefix != null && prefix.equals(myIdPrefix)){
                    objectName = r.getName();
                    //System.debug('-- Object Name! ' + objectName);
                    break;
                }
            }
        }catch(Exception e){
            System.debug(e);
        }
        return objectName;
    }
    
    /**
*
* @author Mahmoud BECHAA 
* Created on : 12/04/2017
* Cette méthode permet de modifier la casse du nom (tout en majuscule) et 
du prénom sur le contact (1ère lettre en majuscule)
*/
    
    public static void contactToUpper(Contact c){
        
        try{
            String firstname = c.FirstName.toLowerCase();
            // mise en majuscule de la 1re lettre
            
            String formatedFirstName;
            String letter='';
            formatedFirstName=firstname.mid(0,1).toUpperCase();
            
            //System.debug('Length : ' + firstname.length());
            
            integer size = firstname.length()-1;
            
            // balayage du reste des lettres
            for(Integer i=1; i< firstname.length();i++)
            {
                letter = firstname.mid(i, 1);
                // gestion des prénoms composés (ex. jean-baptiste sera transformé en Jean-Baptiste)
                if(letter==' ' || letter=='-'){
                    
                    
                    i++;
                    size=size-1;      
                    letter=letter=firstname.mid(i-1,1) + firstname.mid(i,1).toUpperCase();
                    
                } 
                else{
                    
                    letter=firstname.mid(i,1).toLowerCase();
                }
                
                size=size-1;
                formatedFirstName+=letter;
                
            }
            
            //System.debug('Prénom : '+formatedFirstName);
            
            c.FirstName=formatedFirstName;
            
            // pour finir : transformation du nom en majuscule 
            c.LastName=c.LastName.toUpperCase();
            
        }
        catch(Exception e){
            System.debug(e);
        }
    }
    
}