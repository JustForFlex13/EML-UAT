/*--------------------------------------------------------------------
-- - Purpose             : Classe utilitaire pour l'extraction de données pertinentes de la production 
--						    pour les insérer vers une autre sandbox
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 27/02/2017  J.NG  MODIS    1.0      Initial version
--------------------------------------------------------------------*/
public class DataExtractUtils {

    private static final String FIELDNAME_FOR_DATA_TRANSFERRING_BOOLEAN = 'TECH_Is_Record_Transferring__c';

    private static void extractDataToCsv(String fileNumber, String objectName,
            Set<String> fieldNamesToExport, Set<String> fieldNamesNotToExport,
            String whereCondition, Integer recordsLimit) {
        extractDataToCsv(new List<String> {fileNumber}, objectName, fieldNamesToExport, fieldNamesNotToExport,
                whereCondition, recordsLimit);
    }

    private static void extractDataToCsv(List<String> fileNumber, String objectName,
            Set<String> fieldNamesToExport, Set<String> fieldNamesNotToExport,
            String whereCondition, Integer recordsLimit) {

        System.debug('--- BEGIN DataExtractUtils / extractDataToCsv(PARAMS) ---');
        System.debug('--- PARAM String fileNumber : ' + fileNumber);
        System.debug('--- PARAM String objectName : ' + objectName);
        System.debug('--- PARAM Set<String> fieldNamesToExport : ' + fieldNamesToExport);
        System.debug('--- PARAM Set<String> fieldNamesNotToExport : ' + fieldNamesNotToExport);
        System.debug('--- PARAM String whereCondition : ' + whereCondition);
        System.debug('--- PARAM Integer recordsLimit : ' + recordsLimit);

        // Récupération du type de l'objet à partir du nom
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(objectName);
        String csv = '';
        String query = 'SELECT ';

        // Récupération de la description de l'objet
        Schema.DescribeSObjectResult objectDescribe  = sObjectType.getDescribe();

        // Récupération des champs de l'objet
        Map<String, Schema.SObjectField> fieldMap = new Map<String, Schema.SObjectField>(objectDescribe.fields.getMap());

        // Filtrage des champs qui ne sont pas dans la liste des champs à récupérer
        if(fieldNamesToExport != null && !fieldNamesToExport.isEmpty()) {
            DataExtractUtils.keepFieldsByName(fieldMap, fieldNamesToExport);
        }

        // Filtrage des champs qu'on ne veut pas garder
        if (fieldNamesNotToExport != null && !fieldNamesNotToExport.isEmpty()) {
            DataExtractUtils.removeFieldsByName(fieldMap, fieldNamesNotToExport);
        }

        // Filtrage des champs qui ne peuvent être créés lors d'une insertion
        DataExtractUtils.removeNotCreatableFields(fieldMap);

        if(fieldMap.isEmpty()) {
            return;
        }

        // Construction de l'en-tête du csv et insertion des champs nécessaires à la requete SOQL
        for(String fieldName : fieldMap.keySet() ) {
            csv += '"' + fieldName.toUpperCase() + '",';
            query += fieldName + ',';
        }

        // Suppression derniere virgule
        csv = csv.left(csv.length() - 1);
        csv += '\n';

        System.debug('--- PARAM csv : ' + csv);

        query = query.left(query.length() - 1);
        query += ' FROM ' + sObjectType;

        // Ajout condition WHERE
        if ( whereCondition != null && String.isNotBlank(whereCondition) ) {
            query += ' ' + whereCondition;
        }

        // Ajouts LIMIT et donc ORDER BY les enregistrements les plus récents
        if ( recordsLimit != null && recordsLimit > 0 ) {
            query += ' ORDER BY CreatedDate DESC LIMIT ' + recordsLimit;
        }

        System.debug('--- PARAM query : ' + query);
        for ( String word : query.split(',')) {
            System.debug('--- PARAM query\'s detail : --' + word);
        }

        List<sObject> sObjects = Database.query(query);

        if (sObjects.isEmpty()) {
            System.debug('Aucun enregistrement n\'a été trouvé, pas de fichier CSV généré.');
            return;
        }

        // Construction du fichier Csv
        String csvBuilt = DataExtractUtils.buildCsvFile(csv, sObjects, fieldMap);

        // Génération et enregistrement du fichier Csv
        DataExtractUtils.generateCsvFile(csvBuilt, objectName, fileNumber);

        System.debug('--- END DataExtractUtils / extractDataToCsv(PARAMS) ---');
    }

    /**
    Construction du fichier .csv
     */
    private static String buildCsvFile(String csv, List<sObject> sObjects, Map<String, Schema.SObjectField> fieldMap) {
        Integer size = sObjects.size();
        System.debug('--PARAM sObjects.size() : ' + size);
        // Remplissage du csv
        Map<String, Schema.DisplayType > typeMap = new Map<String, Schema.DisplayType >();
        for ( SObject sObj : sObjects ) {
            for ( String fieldName : fieldMap.keySet() ) {
                if(!typeMap.containsKey(fieldName)){
                    typeMap.put(fieldName, fieldMap.get(fieldName).getDescribe().type);
                }
                Schema.DisplayType type = typeMap.get(fieldName);
                // Ajout de la valeur nulle si le champ est null
                if ( sObj.get(fieldName) == null ) {
                    csv += '"",';
                } else if ( type == Schema.DisplayType.STRING || type == Schema.DisplayType.TEXTAREA || type == Schema.DisplayType.PICKLIST
                        || type == Schema.DisplayType.MULTIPICKLIST || type == Schema.DisplayType.COMBOBOX ) {
                    // Remplacement des retours chariots pour une bonne génération du fichier CSV
                    String contentField = ((String) sObj.get(fieldName)).replaceAll('\r\n','\n');

                    // Traitement escapeCsv pour les champs de type STRING et TEXTAREA
                    csv += contentField.escapeCsv() + ',';
                } else if ( fieldName.equalsIgnoreCase(FIELDNAME_FOR_DATA_TRANSFERRING_BOOLEAN) ){
                    /* Changement de la valeur du champ technique TECH_Is_Data_Transferring__c en true
                    pour que les enregistrements puissent être traités en before et after insert dans les triggers
                     */
                    csv += '"true",';
                } else {
                    csv += '"' + sObj.get(fieldName) + '",';
                }
            }
            // Retour à la ligne entre chaque enregistrement
            csv = csv.left(csv.length() - 1);
            csv += '\r';
        }

        // Suppression du \r et de la dernière "," à la fin du traitement
        return csv.left(csv.length() - 1);
    }

    /**
    Conversion d'une Set<Id> en une String compatible pour une requête SOQL
    @param setIds: set d'id à convertir en une chaîne de String
     */
    public static String convertSetToString(Set<Id> setIds){
        System.debug('--- METHOD DataExtractUtils / convertSetToString(Set<Id>) ---');
        String setToString = '(';
        for( String item : setIds ) {
            setToString += '\'' + item + '\',';
        }

        System.debug('-- PARAM Set converted to String : ' + setToString.substring(0, setToString.length() - 1) + ')');

        System.debug('--- END DataExtractUtils / convertSetToString(Set<Id>) ---');
        return ( setToString.substring(0, setToString.length() - 1) + ')');
    }


    /**
    Méthode qui génère un fichier Csv et l'insère dans les fichiers Salesforce
    @ param csv: String csv construite
    @ param objName: Nom de l'objet à traiter
    @ param nbForInsertOrder: Numérotation du fichier pour l'ordre à l'insertion des données
     */
    @Future
    private static void generateCsvFile(String csv, String objName, List<String> nbForInsertOrder) {
        System.debug('--- METHOD DataExtractUtils / generateCsvFile(PARAMS) ---');
        System.debug('--PARAM csv : ' + csv);
        System.debug('--PARAM objName : ' + csv);
        System.debug('--PARAM nbForInsertOrder : ' + nbForInsertOrder);
        try {
            List<ContentVersion> files = new List<ContentVersion>();
            for(String name : nbForInsertOrder){
                files.add(
                    new ContentVersion(
                        title = name + '-' + objName + '.csv',
                        versionData = Blob.valueOf(csv),
                        pathOnClient = '/' + objName + '.csv'
                    )
                );
            }
            insert files;
        } catch (Exception e) {
            System.debug('Erreur génération du csv pour l\'objet ' + objName + ' : '  + e);
        }
    }

    /**
    Retrait des champs de la map de champs qui ne sont pas 'isCreateable()' et qui sont de
    type ADDRESS
	@param fields: Set de champs à filtrer
	 */
    public static void removeNotCreatableFields(Map<String, Schema.SObjectField> fields) {
        for(String fieldName : fields.keySet() ) {
            System.debug('--- PARAM fieldname : ' + fieldName);
            if (!fields.get(fieldName).getDescribe().isCreateable()
                    || fields.get(fieldName).getDescribe().type == Schema.DisplayType.ADDRESS
                    || fieldName.contains('__pc')) {
                fields.remove(fieldName);
            }
        }
    }

	/**
	Retrait des champs de la map qui ne sont pas inclus dans le set de champs que l'on veut garder
	@param fields: Map de champs à filtrer
	@param fieldNamesToKeep: Set de noms de champs à garder
	 */
    private static void keepFieldsByName(Map<String, Schema.SObjectField> fields, Set<String> fieldNamesToKeep) {
        for ( String fieldName : fields.keySet() ) {
            // Si le champ n'est pas inclus dans l'ensemble des champs à garder, il est supprimé de la map
            if ( !fieldNamesToKeep.contains(fieldName) ) {
                fields.remove(fieldName);
            }
        }
    }

    /**
    Retrait des champs de la map qui sont dans le set de champs que l'on ne veut pas garder
    @param fields: Map de champs à filtrer
	@param fieldNamesToRemove: Set de noms de champs à ne pas garder
     */
    private static void removeFieldsByName(Map<String, Schema.SObjectField> fields, Set<String> fieldNamesToRemove) {
        for ( String fieldName : fields.keySet() ) {
            for ( String fieldToRemove : fieldNamesToRemove ) {
                // Si le champ de la map se trouve être le dans le set de champs à ne pas garder, on l'enlève
                if ( fieldName.equalsIgnoreCase(fieldToRemove) ) {
                    System.debug('!!! DataExtractUtils : fieldname : ' + fieldName);
                    System.debug('!!! DataExtractUtils : fieldNamesToRemove : ' + fieldNamesToRemove);
                    fields.remove(fieldName);
                }
            }
        }
    }

    /**
    Extraction de tous les champs avec possibilité de limiter le nombre d'enregistrements
     */
    public static void extractAllFieldsToCSV(String fileNumber, String objectName, Integer numberOfRecords) {
        System.debug('--- Begin DataExtractUtils / extractAllFieldsToCSV(PARAMS) ---');
        System.debug('--- PARAM String fileNumber : ' + fileNumber);
        System.debug('--- PARAM String objectName : ' + objectName);
        System.debug('--- PARAM Integer numberOfRecords : ' + numberOfRecords);
        DataExtractUtils.extractDataToCsv(fileNumber, objectName, null, null, null, numberOfRecords);
        System.debug('--- End DataExtractUtils / extractAllFieldsToCSV(PARAMS) ---');
    }

    /**
    Extraction de tous les champs d'un set d'enregistrements spécifiques
     */
    public static void extractAllFieldsSpecificRecordsToCSV(String fileNumber, String objectName, Set<Id> idsToExport) {
        System.debug('--- Begin DataExtractUtils / extractAllFieldsSpecificRecordsToCSV(PARAMS) ---');
        System.debug('--- PARAM String fileNumber : ' + fileNumber);
        System.debug('--- PARAM String objectName : ' + objectName);
        System.debug('--- PARAM Set<Id> idsToExport : ' + idsToExport);
        String whereCondition = ' WHERE ID IN ' + convertSetToString(idsToExport);
        DataExtractUtils.extractDataToCsv(fileNumber, objectName, null, null, whereCondition, null);
        System.debug('--- End DataExtractUtils / extractAllFieldsSpecificRecordsToCSV(PARAMS) ---');
    }

    /**
    Extraction de champs spécifiques avec possibilité de restreindre le nombre d'enregistrements
     */
    public static void extractSpecificFieldsToCSV(String fileNumber, String objectName, Set<String> fieldNamesToExport,
            Integer numberOfRecords) {
        System.debug('--- Begin DataExtractUtils / extractSpecificFieldsToCSV(PARAMS) ---');
        System.debug('--- PARAM String fileNumber : ' + fileNumber);
        System.debug('--- PARAM String objectName : ' + objectName);
        System.debug('--- PARAM Set<String> fieldNamesToExport : ' + fieldNamesToExport);
        System.debug('--- PARAM Integer numberOfRecords : ' + numberOfRecords);
        DataExtractUtils.extractDataToCsv(fileNumber, objectName, fieldNamesToExport, null, null, numberOfRecords);
        System.debug('--- End DataExtractUtils / extractSpecificFieldsToCSV(PARAMS) ---');
    }

    /**
    Extraction de champs spécifiques pour un set d'enregistrements
     */
    public static void extractSpecificFieldsAndRecordsToCSV(String fileNumber, String objectName,
            Set<String> fieldNamesToExport, Set<Id> idsToExport) {
        System.debug('--- Begin DataExtractUtils / extractSpecificFieldsAndRecordsToCSV(PARAMS) ---');
        System.debug('--- PARAM String fileNumber : ' + fileNumber);
        System.debug('--- PARAM String objectName : ' + objectName);
        System.debug('--- PARAM Set<String> fieldNamesToExport : ' + fieldNamesToExport);
        System.debug('--- PARAM Set<Id> idsToExport : ' + idsToExport);
        String whereCondition = ' ID IN ' + convertSetToString(idsToExport);
        DataExtractUtils.extractDataToCsv(fileNumber, objectName, fieldNamesToExport, null, whereCondition, null);
        System.debug('--- End DataExtractUtils / extractSpecificFieldsAndRecordsToCSV(PARAMS) ---');
    }

    /**
    Extraction de champs spécifiques avec des critères d'exclusion pour les champs, une clause where et possibilité
    de restreindre le nombre d'enregistrements
     */
    public static void extractFieldsWithExceptionsToCSV(String fileNumber, String objectName,
            Set<String> fieldNamesNotToExport, String whereClause, Integer numberOfRecords) {
        System.debug('--- Begin DataExtractUtils / extractFieldsWithExceptionsToCSV(PARAMS) ---');
        System.debug('--- PARAM String fileNumber : ' + fileNumber);
        System.debug('--- PARAM String objectName : ' + objectName);
        System.debug('--- PARAM Set<String> fieldNamesNotToExport : ' + fieldNamesNotToExport);
        System.debug('--- PARAM String whereClause : ' + whereClause);
        System.debug('--- PARAM Integer numberOfRecords : ' + numberOfRecords);
        DataExtractUtils.extractDataToCsv(fileNumber, objectName, null, fieldNamesNotToExport, whereClause, numberOfRecords);
        System.debug('--- End DataExtractUtils / extractFieldsWithExceptionsToCSV(PARAMS) ---');
    }

    /**
    Extraction avec une clause where particulière
     */
    public static void extractAllFieldWithSpecificWhereClause(String fileNumber, String objectName, String whereClause) {
        System.debug('--- Begin DataExtractUtils / extractAllFieldWithSpecificWhereClause(PARAMS) ---');
        System.debug('--- PARAM String fileNumber : ' + fileNumber);
        System.debug('--- PARAM String objectName : ' + objectName);
        System.debug('--- PARAM String whereClause : ' + whereClause);
        DataExtractUtils.extractDataToCsv(fileNumber, objectName, null, null, whereClause, null);
        System.debug('--- End DataExtractUtils / extractAllFieldWithSpecificWhereClause(PARAMS) ---');
    }

    /**
    Génération de deux fichiers excel : utile pour permettre des insertions différentes avec des mappings
    différents
     */
    public static void extractSpecificRecordsHandlingLookupsToCSV(String firstFileNumber, String secondFileNumber,
            String objectName, Set<Id> idsToExport, Set<String> fieldNamesNotToExportFirst) {
        System.debug('--- Begin DataExtractUtils / extractSpecificRecordsHandlingLookupsToCSV(PARAMS) ---');
        System.debug('--- PARAM String firstFileNumber : ' + firstFileNumber);
        System.debug('--- PARAM String secondFileNumber : ' + secondFileNumber);
        System.debug('--- PARAM String objectName : ' + objectName);
        System.debug('--- PARAM Set<Id> idsToExport : ' + idsToExport);
        System.debug('--- PARAM Set<String> fieldNamesNotToExportFirst : ' + fieldNamesNotToExportFirst);
        String whereCondition = ' WHERE ID IN ' + convertSetToString(idsToExport);

        List<String> nbForFiles = new List<String> {firstFileNumber, secondFileNumber};
        DataExtractUtils.extractDataToCSV(nbForFiles, objectName, null, null, whereCondition, null);
        System.debug('--- End DataExtractUtils / extractSpecificRecordsHandlingLookupsToCSV(PARAMS) ---');
    }

    /**
    Récupérer un set d'id spécifique en triant grâce à une clause where et en limitant le nombre d'enregistrements
    @param objName: Nom de l'objet à traiter
    @param whereClause: Clause WHERE pour la requête SOQL
    @param nbOfRecords: Nombre pour la clause LIMIT
     */
    public static Set<Id> extractIdsFromSpecificRecords(String objName, String whereClause, Integer nbOfRecords) {
        System.debug('--- BEGIN METHOD DataExtractUtils / extractIdsFromSpecificRecords(PARAMS)---');
        System.debug('--PARAM objName: '+ objName);
        System.debug('--PARAM whereClause: '+ whereClause);
        System.debug('--PARAM nbOfRecords: '+ nbOfRecords);

        String query = 'SELECT ID FROM ' + objName;
        Set<Id> ids = new Set<Id>();

        if ( whereClause != null && String.isNotBlank(whereClause) ) {
            query += ' ' + whereClause;
        }

        if ( nbOfRecords != null && nbOfRecords > 0 ) {
            query += ' LIMIT ' + nbOfRecords;
        }

        System.debug('--- QUERY : ' + query);

        List<sObject> sObjects = Database.query(query);

        if (sObjects.isEmpty()) {
            return ids;
        }

        for ( sObject obj : sObjects ) {
            if ( obj.Id != null ) {
                ids.add(obj.Id);
            }
        }

        System.debug('--- END METHOD DataExtractUtils / extractIdsFromSpecificRecords(PARAMS)---');
        return ids;
    }

    public static void selectAccountsRelatedToContacts(Set<Id> conIds, DataToExport dataExport) {
        // Sélection des comptes liés aux contacts précédemment sélectionnés
        String query = ' SELECT AccountId FROM ' + DataExtract012Contact.OBJECT_NAME_CONTACT + ' WHERE ID IN ' +
                DataExtractUtils.convertSetToString(conIds);

        List<Contact> contacts = Database.query(query);
        if (contacts != null && !contacts.isEmpty()) {
            Set<Id> accountIds = new Set<Id>();
            for (Contact con : contacts) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }

            /* Ajout des nouveaux comptes à accountsToBeExportedRelatedToMinimalQuotas pour pouvoir être extraits
            dans un autre fichier CSV mais aussi à accountsToExport afin de continuer à extraire des enregistrements liés
            */
            dataExport.accountsToBeExportedRelatedToMinimalQuotas.addAll(accountIds);
            dataExport.accountsToExport.addAll(accountIds);
        }
    }
}