/*--------------------------------------------------------------------
-- - Purpose           : Queueable Job for UpdateContact
--                       This method was in TR003ManageOpportunities and is called after insert and update on Opportunity
--
-- Maintenance History :
--
-- Date         Name  Company  Version  Remarks
-- -----------  ----  -------  -------  ------------------------------
-- 18/01/2018   T.CH  MODIS    1.0      Creation
--------------------------------------------------------------------*/
public class AsyncUpdateContact implements Queueable {
    private List<Opportunity> lOpp;

    public AsyncUpdateContact(List<Opportunity> lOppParam){
        this.lOpp = lOppParam;
    }

    public void execute(QueueableContext context) {
        List<Contact> contactsList = new List <Contact>();
        set<id> CtcCentralIds =new set<id>();
        set<Opportunity> myOpportunities =new set<Opportunity>();
        Id RecordTypeFundraisingB2CId= APU_ApexUtils.getOpportunityRecordTypeIdByName('Fundraising B2C');

        for (Opportunity opp : this.lOpp) {
            CtcCentralIds.add(opp.Contact_central__c);
        }

        if (CtcCentralIds.size()>0 ){
            contactsList = [SELECT a.Somme_Montant_Don__c ,a.Id FROM Contact a where id in: CtcCentralIds];
            myOpportunities = new set<Opportunity>([SELECT Contact_central__c, Amount, closeDate from Opportunity where Contact_central__c in:CtcCentralIds And stageName= 'Conclu' And recordTypeID=:RecordTypeFundraisingB2CId]);
        }

        Map<Id, Contact> mpIdContact = new Map<Id, Contact>();
        Map<Id, List<Opportunity>> mpOppByContactCentral = new Map<Id, List<Opportunity>>();

        // Parcourir chaque opportunité
        for (Opportunity o :[SELECT Contact_central__r.Id, Amount, closeDate
                             FROM Opportunity
                             WHERE Contact_central__r.Id in:CtcCentralIds
                             AND stageName= 'Conclu'
                             AND recordTypeID=:RecordTypeFundraisingB2CId])
        {
            // Si son contact central n'a pas été ajouté
            if(!mpOppByContactCentral.containsKey(o.Contact_central__r.Id)) {
                // Ajouter son contact central en clé
                 mpOppByContactCentral.put(o.Contact_central__r.Id, new List<Opportunity>());
            }
            // Ajouter cette opportunité à la liste des opportunités de son contact central
            mpOppByContactCentral.get(o.Contact_central__r.Id).add(o);

            if(mpIdContact.containsKey(o.Contact_central__r.Id) != null){
                mpIdContact.put(o.Contact_central__r.Id, o.Contact_central__r);
            }
        }

        Set<Contact> sConToUpdate = new Set<Contact>();
        for(Id conId :mpOppByContactCentral.keySet()){
            Contact con = mpIdContact.get(conId);
            con.Somme_Montant_Don__c=0;
            for(Opportunity o :mpOppByContactCentral.get(conId)){
                if(Date.today() <= o.closeDate.addYears(Integer.valueof(Label.x.trim())))
                {
                    con.Somme_Montant_Don__c += o.Amount;
                }
                if (!sConToUpdate.contains(con)) {
                    sConToUpdate.add(mpIdContact.get(conId));
                }
            }
        }

        Map<Id,Contact> mpConToUpdate = new Map<Id,Contact>();
        mpConToUpdate.putAll(new List<Contact>(sConToUpdate));

        if (mpConToUpdate.size()>0){
            update mpConToUpdate.values();
        }
	}
}