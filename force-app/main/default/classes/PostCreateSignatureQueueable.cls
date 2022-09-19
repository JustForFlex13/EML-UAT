/*--------------------------------------------------------------------
-- - Purpose             : Queueable class that call eSign API to PostCreateSignature 
--            
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks 
-- ----------  ----  -------  -------  -------------------------------
-- 14/01/2018  T.CH  MODIS    1.0      Creation
--------------------------------------------------------------------*/
public class PostCreateSignatureQueueable implements Queueable,Database.AllowsCallouts {
    Id demandeId;
    Boolean isForConvention;

    public PostCreateSignatureQueueable(Id demandeIdParam, Boolean isForConventionParam){
        this.demandeId          = demandeIdParam;
        this.isForConvention    = isForConventionParam;
    }

    public void execute(QueueableContext context) {
        Case demande = [SELECT Id,Convsta_Langue__c,Convsta_eSign_ExtId__c,CaseNumber, 
                        		CreatedDate,
                        		ParentId,
		                        parent.Responsable_administratif_entreprise__c,
                                Convsta_Tuteur__r.Email,
                                Convsta_Tuteur__r.LastName,
                                Convsta_Tuteur__r.FirstName,
                                Convsta_Tuteur__c,
                                Responsable_administratif_entreprise__r.Email,
                                Responsable_administratif_entreprise__r.LastName,
                                Responsable_administratif_entreprise__r.FirstName,
                                Responsable_administratif_entreprise__c,
                                Contact.Email,
                                Contact.LastName,
                                Contact.FirstName,
                                Contact.Id,
                                Convsta_Signataire_delegue__r.Email,
                                Convsta_Signataire_delegue__r.FirstName,
                                Convsta_Signataire_delegue__r.LastName,
                                Convsta_Signataire_delegue__c,
                                Convsta_Referent_pedagogique__r.Email,
                                Convsta_Referent_pedagogique__r.FirstName,
                                Convsta_Referent_pedagogique__r.LastName,
                                Convsta_Referent_pedagogique__c,
                        		Convsta_Table_des_Regles_Experience_Pro__c,
                                Convsta_Table_des_Regles_Experience_Pro__r.Ne_pas_faire_signer_le_resp_pedagogique__c            
                        FROM Case 
                        WHERE Id= :this.demandeId LIMIT 1];
        
        Convsta_WS_Helper.doPostSignatureCreateFromQueueable(demande, this.isForConvention);        
    }

    //Relancer en finish
}