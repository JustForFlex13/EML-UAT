/*--------------------------------------------------------------------
-- - Purpose             : DiplomeTrigger Handler
--            
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks 
-- ----------  ----  -------  -------  -------------------------------
-- 12/02/2018  A.DO  MODIS    1.0      Creation
-- 07/03/2018  T.CH  MODIS    1.1      Remove TR008 for HasRun on AfterInsert & AfterUpdate
--------------------------------------------------------------------*/

public class TH_DiplomeTriggerHandler extends TriggerHandler {
    /********************************************************************************
    * BEFORE INSERT
    ********************************************************************************/
    protected override void beforeInsert() {
        System.debug('## >>> Diplome Before insert - START');
        //règles de gestion
        System.debug('## >>> Diplome Before insert - END');
    }

    /********************************************************************************
    * AFTER INSERT
    ********************************************************************************/
    protected override void afterInsert() {
        System.debug('## >>> Diplome After insert - START');

        // on sauvegarde la liste des enregistrements en cours de mdofication dans un tableau d'id
        Set<Id> mDipl = Trigger.Newmap.Keyset();
        TR005ManageDiplomes.majDateContact(mDipl);
        
        // Retirer le trigger des diplomes des classes déjà executées
        // Suite à l'éxecution dans méthode majDateContact (ContactAfterUpdate)
        // Pour permettre calcul nbDiplome si identifiant créé
        PAD.removeTriggerHasRun('TR005ManageDiplomes');

        // Mettre à jour l'Identifiant Diplômé
        TR005ManageDiplomes.majIdentifiantDiplome(Trigger.New);
    
        System.debug('## >>> Diplome After insert - END');
    }

    /********************************************************************************
    * BEFORE UPDATE
    ********************************************************************************/
    protected override void beforeUpdate() {
        System.debug('## >>> Diplome Before Update - START');
        //règles de gestion
        System.debug('## >>> Diplome Before Update - END');
    }

    /********************************************************************************
    * AFTER UPDATE
    ********************************************************************************/
    protected override void afterUpdate() {
        System.debug('## >>> Diplome After Update - START');

        // on sauvegarde la liste des enregistrements en cours de mdofication dans un tableau d'id
        Set<Id> mDipl = Trigger.Newmap.Keyset();
        TR005ManageDiplomes.majDateContact(mDipl);

        // Retirer le trigger des diplomes des classes déjà executées
        // Suite à l'éxecution dans méthode majDateContact (ContactAfterUpdate)
        // Pour permettre calcul nbDiplome si identifiant créé
        PAD.removeTriggerHasRun('TR005ManageDiplomes');

        // Mettre à jour l'Identifiant Diplômé
        TR005ManageDiplomes.majIdentifiantDiplome(Trigger.New);
    
        System.debug('## >>> Diplome After Update - END');
    }

    /********************************************************************************
    * BEFORE DELETE
    ********************************************************************************/
    protected override void beforeDelete() {
        System.debug('## >>> Diplome before Delete - START');
        //règles de gestion
        System.debug('## >>> Diplome before Delete - END');
    }
}