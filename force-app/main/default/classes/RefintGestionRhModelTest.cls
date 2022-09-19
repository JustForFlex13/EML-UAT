@isTest
private class RefintGestionRhModelTest {
    @isTest
    private static void equalsSameInstance() {
        RefintGestionRhModel gestionRhModel1 = RefintGestionRhModel.getExample();
        RefintGestionRhModel gestionRhModel2 = gestionRhModel1;
        RefintGestionRhModel gestionRhModel3 = new RefintGestionRhModel();
        RefintGestionRhModel gestionRhModel4 = gestionRhModel3;

        System.assert(gestionRhModel1.equals(gestionRhModel2));
        System.assert(gestionRhModel2.equals(gestionRhModel1));
        System.assert(gestionRhModel1.equals(gestionRhModel1));
        System.assert(gestionRhModel3.equals(gestionRhModel4));
        System.assert(gestionRhModel4.equals(gestionRhModel3));
        System.assert(gestionRhModel3.equals(gestionRhModel3));
    }

    @isTest
    private static void equalsIdenticalInstance() {
        RefintGestionRhModel gestionRhModel1 = RefintGestionRhModel.getExample();
        RefintGestionRhModel gestionRhModel2 = RefintGestionRhModel.getExample();
        RefintGestionRhModel gestionRhModel3 = new RefintGestionRhModel();
        RefintGestionRhModel gestionRhModel4 = new RefintGestionRhModel();

        System.assert(gestionRhModel1.equals(gestionRhModel2));
        System.assert(gestionRhModel2.equals(gestionRhModel1));
        System.assert(gestionRhModel3.equals(gestionRhModel4));
        System.assert(gestionRhModel4.equals(gestionRhModel3));
    }

    @isTest
    private static void notEqualsDifferentType() {
        RefintGestionRhModel gestionRhModel1 = RefintGestionRhModel.getExample();
        RefintGestionRhModel gestionRhModel2 = new RefintGestionRhModel();

        System.assertEquals(false, gestionRhModel1.equals('foo'));
        System.assertEquals(false, gestionRhModel2.equals('foo'));
    }

    @isTest
    private static void notEqualsNull() {
        RefintGestionRhModel gestionRhModel1 = RefintGestionRhModel.getExample();
        RefintGestionRhModel gestionRhModel2 = new RefintGestionRhModel();
        RefintGestionRhModel gestionRhModel3;

        System.assertEquals(false, gestionRhModel1.equals(gestionRhModel3));
        System.assertEquals(false, gestionRhModel2.equals(gestionRhModel3));
    }

    @isTest
    private static void consistentHashCodeValue() {
        RefintGestionRhModel gestionRhModel1 = RefintGestionRhModel.getExample();
        RefintGestionRhModel gestionRhModel2 = new RefintGestionRhModel();

        System.assertEquals(gestionRhModel1.hashCode(), gestionRhModel1.hashCode());
        System.assertEquals(gestionRhModel2.hashCode(), gestionRhModel2.hashCode());
    }

    @isTest
    private static void equalInstancesHaveSameHashCode() {
        RefintGestionRhModel gestionRhModel1 = RefintGestionRhModel.getExample();
        RefintGestionRhModel gestionRhModel2 = RefintGestionRhModel.getExample();
        RefintGestionRhModel gestionRhModel3 = new RefintGestionRhModel();
        RefintGestionRhModel gestionRhModel4 = new RefintGestionRhModel();

        System.assert(gestionRhModel1.equals(gestionRhModel2));
        System.assert(gestionRhModel3.equals(gestionRhModel4));
        System.assertEquals(gestionRhModel1.hashCode(), gestionRhModel2.hashCode());
        System.assertEquals(gestionRhModel3.hashCode(), gestionRhModel4.hashCode());
    }

    @isTest
    private static void defaultValuesPopulated() {
        RefintGestionRhModel gestionRhModel = new RefintGestionRhModel();
        System.assertEquals(new List<String>(), gestionRhModel.listeCodeIso3LangueEnseignement);
        System.assertEquals(new List<RefintSocieteRattachementModel>(), gestionRhModel.listeSocieteRattachement);
        System.assertEquals(null, gestionRhModel.codeValeurAxeStatut);
        System.assertEquals(null, gestionRhModel.codeValeurAxeTypeContrat);
        System.assertEquals(null, gestionRhModel.numeroEtpFtp);
        System.assertEquals(null, gestionRhModel.dateDebutContrat);
        System.assertEquals(null, gestionRhModel.dateFinContrat);
        System.assertEquals(null, gestionRhModel.codeValeurAxeModeRemuneration);
        System.assertEquals(null, gestionRhModel.idContactInterne);
        System.assertEquals(null, gestionRhModel.autreContact);
        System.assertEquals(null, gestionRhModel.codeValeurAxeGroupeDisciplinairePrincipal);
        System.assertEquals(null, gestionRhModel.codeValeurAxeGroupeDisciplinaireMineur);
        System.assertEquals(null, gestionRhModel.codeValeurAxeTypeIntervenant);
        System.assertEquals(null, gestionRhModel.codeValeurAxeTitre);
        System.assertEquals(null, gestionRhModel.codeValeurAxeClassification);
        System.assertEquals(null, gestionRhModel.codeValeurAxeUniteBudgetaire);
        System.assertEquals(null, gestionRhModel.codeValeurAxeCampusRattachement);
        System.assertEquals(null, gestionRhModel.anneeExperienceFormationContinue);
        System.assertEquals(null, gestionRhModel.anneeExperienceFormationInitiale);
        System.assertEquals(null, gestionRhModel.mobiliteFrance);
        System.assertEquals(null, gestionRhModel.mobiliteEurope);
        System.assertEquals(null, gestionRhModel.mobiliteAutre);
        System.assertEquals(null, gestionRhModel.libelleMobiliteAutre);
        System.assertEquals(null, gestionRhModel.autresCaracteristiquesStatut);
        System.assertEquals(null, gestionRhModel.codeItIntervenant);
        System.assertEquals(null, gestionRhModel.statutDossier);
        System.assertEquals(null, gestionRhModel.statutDossierEnum);
    }
}