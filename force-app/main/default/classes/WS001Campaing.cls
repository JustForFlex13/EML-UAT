/*--------------------------------------------------------------------
-- - Purpose             : Webservice campaign
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- XX/XX/20XX  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
global class WS001Campaing{
webservice static boolean dedupeContacts(ID CampaingID){
//    System.debug('=================dedupeContacts=======================ash==>>');
    //on recupere l'objet 
    Campaign camp = [select id,ParentID,Priorit_dedoublonnage__c  from Campaign where id =:CampaingID limit 1 ];
    List <Campaign> camps= new List <Campaign>();
    if (camp.ParentID==null){//cas parent , on doit recuperer les fils et ajouter a la fin le parent
//        System.debug('=================parent=======================ash==>>');
        camps = [select id,ParentID,Priorit_dedoublonnage__c  from Campaign where ParentID =:CampaingID ];
        camps.add(camp);
    }else{//cas fils  , on recupere les fils du pere
//        System.debug('=================not parent=======================ash==>>');
        CampaingID=camp.ParentID;   
        camp = [select id,ParentID,Priorit_dedoublonnage__c  from Campaign where id =:CampaingID limit 1 ];
        camps = [select id,ParentID,Priorit_dedoublonnage__c  from Campaign where ParentID =:CampaingID ];
        camps.add(camp);
    }
    integer i;
    integer j;
    camp=new Campaign();
    integer p ; 
    //trie par priorite
    for (i=0 ;i<camps.size()-1 ;i++){       
        p=i;
        for (j=i+1;j<camps.size() ;j++){
            if (camps[p].Priorit_dedoublonnage__c>camps[j].Priorit_dedoublonnage__c)
            p=j;
        }
        camp=camps[i];
        camps[i]=camps[p];
        camps[p]=camp;
    }

//    System.debug('=================tri fini=======================ash==>>'+camps);
    //on construi une list des ids des Campaign
    List <id> campsIDs = new List<id>();
    for (i=0 ;i<camps.size() ;i++){ 
        campsIDs.add(camps[i].id);
    }
    List<CampaignMember> allCM=[select id, contactID,CampaignID from CampaignMember where CampaignID in :campsIDs ];

    Map<id,List<CampaignMember>> themap=new Map<id,List<CampaignMember>>();
    for (i=0 ;i<allCM.size() ;i++){ 
//        System.debug('==================================les camp='+i+'=====ash==>>'+allCM[i]);

        if (!themap.containsKey(allCM[i].CampaignID)){
            themap.put(allCM[i].CampaignID,new List<CampaignMember>());
        }
        themap.get(allCM[i].CampaignID).add(allCM[i]);
    }
    set<id> ctct= new set<id>();//les campaing memver 
    List<id> cmToDel= new List<id>(); //les campaing memer 
    //on difini un set des id contact, et commence par le plus prioritaire, si on trouve un doublons apres on supprime le campign member
    set <id> ctctsIDs = new set<id>();
    for (i=0 ;i<campsIDs.size() ;i++){
        if  (themap.containsKey(campsIDs[i])){
            for (j=0 ;j< themap.get(campsIDs[i]).size() ;j++){ 
             //  System.debug('=============================bclbclbclbclbc==========i='+i+'==>>');
                if (ctctsIDs.contains(themap.get(campsIDs[i])[j].contactID)){
                    cmToDel.add(themap.get(campsIDs[i])[j].id);
                }else ctctsIDs.add(themap.get(campsIDs[i])[j].contactID);

            }
        }
    }

    
       // System.debug('=============================ctctsIDs===========ash==>>'+ctctsIDs);
//        System.debug('=============================Cm=to=del===========ash==>>'+cmToDel);
//    integer j ;
    List<id> l1;    
    for(i=0;i<cmToDel.size();i+=8000){
        l1= new  List<id>();
        For(j=i;(j<i+8000 && j<cmToDel.size());j++){

           l1.add(cmToDel[j]);
        }
      //  System.debug('================ j ==== '+j);
      //  System.debug('================ i ==== '+i);
      //  System.debug('================ size l1 ==== '+l1.size());
        //if (i>0)
         myFutureMethod(l1);
//        if (i==0 ) Database.delete(l1);       
    }

    //Database.delete(cmToDel);

  
    for (campaign c: camps)  {c.Dedoublonage_effectue__c=true;}
    List<campaign> lc1;
    for(i=0;i<camps.size();i+=5000){
        lc1= new  List<campaign>();
        For(j=i;(j<i+5000 && j<camps.size());j++){
           lc1.add(camps[j]);
        }
        Database.update(lc1);
        

    }


    
        
    for (campaign c: camps)  {c.Dedoublonage_effectue__c=true;}
    Database.update(camps);
 




    


return true;
}



 @future
    public static void myFutureMethod(List <id> l)   
    {   
     Database.delete(l);    
    }
    
}