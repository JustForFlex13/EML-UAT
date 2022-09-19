/*--------------------------------------------------------------------
-- - Purpose             : Implementation of methods called by trigger on opportunity line items.
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  XXXX  XXXXXXX  1.0      Initial version
-- 14/02/2018  T.CH  MODIS    2.0      1018's implementation
-- 27/03/2018  T.CH  MODIS    2.1      Integration's check of Opportunity on BeforeInsert
--------------------------------------------------------------------*/
public class TR002ManageOpportunityLineItem {
   
    public static void checkIncrementCompteurOPPLine(List<OpportunityLineItem> lOppLine, Boolean forceChange) {
        List<OpportunityLineItem> lOppLineToUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> lOppLineCandidates = new List<OpportunityLineItem>();

        // Récupération des opp lines sans Code Agresso
        for(OpportunityLineItem oppLine : lOppLine){
            if(oppLine.CodeAgresso_Poste_Opportunite__c == null){
                lOppLineCandidates.add(oppLine);
            }
        }
        
        // Récupération du dernier Compteur du Code Agresso connu
        Integer lastCompteurOppLine = TR002ManageOpportunityLineItem.getLastCompteurOppLine();
        
        // Si la MàJ est forcée par une MàJ d'opp
        if (forceChange) {
            // Incrémentation des opp line
            lOppLineToUpdate = TR002ManageOpportunityLineItem.IncrementCompteurOPPLine(lOppLineCandidates, lastCompteurOppLine);

            // Mise à jour des opp lines
            if(lOppLineToUpdate.size() > 0){
                update lOppLineToUpdate;
            }            
        } else {
            // Récupération des opportunités pour vérification des critères
            Set<Id> oppIds = new Set<Id>();
            for (OpportunityLineItem oppLine: lOppLineCandidates) {            
                oppIds.add(oppLine.OpportunityId);
            }
            
            Map<Id, Opportunity> opps = new Map<Id, Opportunity>([
                    SELECT Id, RecordTypeId, StageName
                    FROM Opportunity
                    WHERE Id in :oppIds]);

            Id recordTypeFormationCourteId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Formation courte');
            Id recordTypeProgrammeLongDiplomantId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Programme Long Diplômant');
            Id recordTypeFormationIntraId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Formation intra-entreprise');
            Id recordTypeFormationInitialeId = APU_ApexUtils.getOpportunityRecordTypeIdByName('Formation initiale');
            
            // Vérification des critères 
            for(OpportunityLineItem oppLine :lOppLineCandidates) {
                Opportunity opp = opps.get(oppLine.OpportunityId);
                if(opp!=null){ // Si l'opportunité a bien été insérée en SF
                    if (    (opp.RecordTypeId == recordTypeFormationCourteId
                             && ((opp.StageName == 'Pré inscrit') || (opp.StageName == 'Inscrit')))
                        ||  (opp.RecordTypeId == recordTypeProgrammeLongDiplomantId
                             && ((opp.StageName == 'Admis') || (opp.StageName == 'Intégré') || (opp.StageName == 'Candidat')))
                        ||  (opp.RecordTypeId == recordTypeFormationIntraId)
                        ||  (opp.RecordTypeId == recordTypeFormationInitialeId
                             && opp.StageName == 'Inscrit' && oppLine.Famille__c == 'Programme apprentissage')
                       ){
                            lOppLineToUpdate.add(oppLine);
                    }
                }
            }

            // Incrémentation des opp line
            if (lOppLineToUpdate.size()>0){
                TR002ManageOpportunityLineItem.IncrementCompteurOPPLine(lOppLineToUpdate, lastCompteurOppLine);
            }
        }
    }

    public static Integer getLastCompteurOppLine() {
        Integer lastCompteurOppLine = 0;
        Date lastYear = Date.today().addMonths(-12);
        // Récupérer le dernier enregistrement avec un Code_OLI
        List<OpportunityLineItem> lastOppLineCodeOLI = [SELECT Id, Code_OLI__c
                                                        FROM OpportunityLineItem 
                                                        WHERE Code_OLI__c > 0 
                                                        ORDER BY Code_OLI__c DESC 
                                                        LIMIT 1];

        // Récupérer la dernière valeur du Code_OLI
        if (lastOppLineCodeOLI.size() > 0) {            
            lastCompteurOppLine = (Integer)lastOppLineCodeOLI[0].Code_OLI__c;
        }

        return lastCompteurOppLine;
    }
    
    public static List<OpportunityLineItem> IncrementCompteurOPPLine(List<OpportunityLineItem> lOppLine, Integer lastCompteurOppLine){
        for(OpportunityLineItem oppLine :lOppLine){
            lastCompteurOppLine++;
            oppLine.Code_OLI__c = lastCompteurOppLine;
        }

        return lOppLine;
    }

    public static void addProductFilter(List<OpportunityLineItem> oli){
        //Récupération des priceBookEntry ids
        Set<Id> idPriceBook = new Set<Id>();
        for(OpportunityLineItem op :oli){
            idPriceBook.add(op.PricebookEntryId);
        }

        List<PricebookEntry> priceBookEntry = [Select p.Product2Id, p.Id From PricebookEntry p where p.Id in :idPriceBook];

        //Récupération des produits à partir du priceBookEntry
        Map<Id,Id> maps = new Map<Id,ID>();
        for(PricebookEntry pE :priceBookEntry){
            maps.put(pe.Id,pE.Product2Id);
        }

        //Modification du champ ProduitFiltreSession__c de l'OpportunityLineItem
        for(OpportunityLineItem o :oli){
            o.ProduitFiltreSession__c=maps.get(o.PricebookEntryId);
        }
    }

    public static void attachSession(list<OpportunityLineItem > oppLines){
        Set<Id> id_opp = new set<Id>();
        Set<Id> id_session = new set<Id>();
        Map<Id,Session__c> map_module = new Map<Id,Session__c>();
        list<OpportunityLineItem> po_module = new list<OpportunityLineItem>();
        for(OpportunityLineItem po : oppLines)  
        {
            if(po.Session_de_formation__c != null && po.Type_produit__c == 'Pack')
            { 
                id_opp.add(po.OpportunityId);
                id_session.add(po.Session_de_formation__c);
            }
        }
        
        po_module = [select Id, OpportunityId,PricebookEntry.Product2Id from OpportunityLineItem where Type_produit__c = 'Module' and OpportunityId IN :id_opp];
        
        for( Detail_pack_session__c  s : [select Id, Name ,Composant_session__r.Produits__c, Composant_session__c  from Detail_pack_session__c where Pack_Session__c IN :id_session ])
        {
            map_module.put(s.Composant_session__r.Produits__c,s.Composant_session__r);
        }  

        list<OpportunityLineItem> poToUpdate;
        
        for(OpportunityLineItem po: po_module)
        {
            if(map_module.ContainsKey(po.PricebookEntry.Product2Id) )
            {
                po.Session_de_formation__c = map_module.get(po.PricebookEntry.Product2Id).Id;
            }
        }
                
    }

    public static void createOppLineItem(list <OpportunityLineItem> oppLines)
    {
        // GGA 30/11 - Le trigger ne doit pas se déclencher si le champ système est rempli (il est rempli par WF à la création). 
        // En cas de clonage, le champ serait rempli donc ne se déclenche pas.
        list<OpportunityLineItem> po_clonage = new list<OpportunityLineItem>();
        for(OpportunityLineItem clonepo :oppLines)  
        {                
            if(clonepo.Champ_syst_me_pour_clonage__c == null)
            {
                po_clonage.add(clonepo);
            }
        }

        if (po_clonage.size() > 0)
        {
            list <OpportunityLineItem> oppLineItemsToInsert= new list <OpportunityLineItem>();
            set<id> ProductsIds = new set<id>();
            set<id> packProductsIds = new set<id>();
            map<id,List<Detail_pack__c>> mapPackModuleProducts = new map<id,List<Detail_pack__c>>();
            List<Detail_pack__c>  moduleProducts = new List<Detail_pack__c>();   
            List<OpportunityLineItem> oppLineFormationCourte = new List<OpportunityLineItem>();
            Id OppFormationCourteId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Formation courte').getRecordTypeId();
            
            Set<Id> OppIds = new Set<Id>();
            for (OpportunityLineItem oppLineItem: po_clonage){
                OppIds.add(oppLineItem.OpportunityId);
            }
            
            Map<Id,Opportunity> mpOppById = new Map<Id,Opportunity>([SELECT Id, RecordTypeId FROM Opportunity where ID in :OppIds]);
            for (OpportunityLineItem oppLineItem: po_clonage){
                Opportunity opp = mpOppById.get(oppLineItem.OpportunityId);
                if(opp != null && opp.RecordTypeId == OppFormationCourteId){
                    oppLineFormationCourte.add(oppLineItem);
                }
            }
            
            for (OpportunityLineItem oppLineItem: oppLineFormationCourte){
                ProductsIds.add(oppLineItem.Product2Id);
            }
            
            map<id,Product2> mapProducts = new map <id,Product2>([select id,Produit_Pack__c from product2 where id IN: ProductsIds ]);
            for (OpportunityLineItem oppLineItem: oppLineFormationCourte){
                if (mapProducts.get(oppLineItem.Product2Id).Produit_Pack__c){
                    packProductsIds.add(oppLineItem.Product2Id) ;   
                }
            }
            
            moduleProducts = [select Pack__c,Composant__c from Detail_pack__c where Pack__c IN: packProductsIds];
            for (Detail_pack__c prod: moduleProducts){
                
                if (mapPackModuleProducts.containsKey(prod.Pack__c))
                {
                    mapPackModuleProducts.get(prod.Pack__c). add(prod);
                }
                else {
                    mapPackModuleProducts.put(prod.Pack__c, new  List <Detail_pack__c> { prod });
                }
            }
            
            
            for (OpportunityLineItem oppLineItem: oppLineFormationCourte){                
                if (mapProducts.get(oppLineItem.Product2Id).Produit_Pack__c){                    
                    if (mapPackModuleProducts.get(oppLineItem.Product2Id)!=null){                        
                        for (Detail_pack__c pro : mapPackModuleProducts.get(oppLineItem.Product2Id)){                            
                            OpportunityLineItem newOppLineItem = new OpportunityLineItem();
                            
                            PricebookEntry[] listPricebookEntry = [Select p.UseStandardPrice, p.UnitPrice, p.SystemModstamp, p.ProductCode, p.Product2Id, 
                                                                p.Pricebook2Id, p.Name, p.LastModifiedDate, p.LastModifiedById, p.IsDeleted, p.IsActive, p.Id, 
                                                                p.CreatedDate, p.CreatedById 
                                                                from PricebookEntry p where p.Product2Id =: pro.Composant__c And Pricebook2Id IN (Select Pricebook2Id From Opportunity Where ID =:oppLineItem.OpportunityId) limit 1];
                            
                            if (listPricebookEntry.size() > 0){
                                newOppLineItem.PricebookEntryId = listPricebookEntry[0].Id;
                                newOppLineItem.OpportunityId= oppLineItem.OpportunityId;    
                                newOppLineItem.UnitPrice =0;
                                newOppLineItem.Quantity = oppLineItem.Quantity; 
                                
                                oppLineItemsToInsert.add(newOppLineItem);
                            }                        
                        }
                    }
                    
                }
            }
            
            insert oppLineItemsToInsert;
        }

        
    }  
}