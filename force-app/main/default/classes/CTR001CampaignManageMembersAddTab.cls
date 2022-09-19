/*--------------------------------------------------------------------
-- - Purpose             : Controller for Campaign Member
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  -------------------------------
-- 00/00/20XX  XXXX  XXXXXXX  1.0      Initial version
--------------------------------------------------------------------*/
public class CTR001CampaignManageMembersAddTab{

    public class MyMember{
        public Boolean checked;
        public String FirstName;
        public String LastName;
        public String title;
        public String Company;
        public String Email;
        public String id;
        public String status;

        public Boolean getChecked() {return checked;}
        public void setChecked(Boolean p_checked) {checked = p_checked;}
        public String getFirstName() {return FirstName;}
        public String getLastName() {return LastName;}
        public String getTitle() {return title;}
        public String getCompany() {return Company;}
        public String getEmail() {return Email;}
        public String getStatus() {return status;}
    }

    /*public class MyMemberExist{
        private Boolean checked;
        private String Name;
        private String title;
        private String Company;
        private String Email;
        private String Type;
        private String LaDate;
        private String id;
        private String status;

        public Boolean getChecked() {return checked;}
        public void setChecked(Boolean p_checked) {checked = p_checked;}
        public String getName() {return Name;}
        public String getTitle() {return title;}
        public String getCompany() {return Company;}
        public String getEmail() {return Email;}
        public String getStatus() {return status;}
        public String getType() {return type;}
        public String getLaDate() {return LaDate;}
        public String getId() {return id;}
    }*/

    // Liste des produits sélectionnés séparé par des virgules (pour utilisation en JS).
    public String selectedItems{get;set;}

    public String selectedItemsJson {get {  List<String> res = new List<String>();
                                          if (!String.isBlank(selectedItems)) {
                                              res = new List<String>((List<String>) this.listSelectedMemberIds);
                                          }
                                          return JSON.serialize(res);
                                         }}


    public CTR001CampaignManageMembersAddTab(ApexPages.StandardController controller){
        this.controller = controller;
        campaignId = ApexPages.currentPage().getParameters().get('campaignid');
        campaignName = DAL.getCampaignMemberName(campaignId);
        campaignOwnerEmail = DAL.getCampaignOwnerEmail(campaignId);
        campaignOwnerid = DAL.getCampaignOwnerId(campaignId);
        setMembersUncheckable(false);
        type = 'Pistes';
        initialiser();
    }

    public void initialiser(){
        selectedTab = 'tab1';
        populateLeadsFields();
        populateOperators();
        populateCampaignMemberStatus();

        if(type.equals('Pistes'))
            visible = false;
        else
            visible = true;
    }

    public void initialisertab2(){
        selectedTab = 'tab2';
        populateMyMembersExist();

    }

    private ApexPages.StandardController controller;
    private String idToDelete;
    private String selectedTab;
    private String email1;
    private String email2;
    private String email1Rapport;
    private String email2Rapport;
    private boolean visible;
    private String campaignId;
    private String campaignName;
    private String campaignOwnerEmail;
    private Id campaignOwnerId;
    private String type;
    private List<Lead> leads;
    private List<Contact> contacts;
    private list<CampaignMember> members;
    private list<MyMember> myMembers;
    private List<SelectOption> leadsFields_1;
    private String leadsField_1;
    private String leadsField_2;
    private String leadsField_3;
    private String leadsField_4;
    private List<SelectOption> operators_1;
    private String operator_1;
    private String operator_2;
    private String operator_3;
    private String operator_4;
    private String queryCondition_1;
    private String queryCondition_2;
    private String queryCondition_3;
    private String queryCondition_4;
    private Boolean checkedAll;
    private Boolean checkedAllExist;
    private String query;
    private List<SelectOption> campaignMemberStatus;
    private String campaignMemberStatusSelected;
    private String campaignMemberStatusSelectedRapport;
    private Boolean checkedAllExistRapport;
    private Boolean displayPopup;
    private Boolean membersUncheckable;

    public List<Lead> getLeads() {return leads;}
    public List<Contact> getContacts() {return contacts;}
    public List<SelectOption> getLeadsFields() {return leadsFields_1;}
    public String getLeadsField_1() {return leadsField_1;}
    public void setLeadsField_1 (String p_LeadsField_1) {LeadsField_1 = p_LeadsField_1;}
    public String getLeadsField_2() {return leadsField_2;}
    public void setLeadsField_2 (String p_LeadsField_2) {LeadsField_2 = p_LeadsField_2;}
    public String getLeadsField_3() {return leadsField_3;}
    public void setLeadsField_3 (String p_LeadsField_3) {LeadsField_3 = p_LeadsField_3;}
    public String getLeadsField_4() {return leadsField_4;}
    public void setLeadsField_4 (String p_LeadsField_4) {LeadsField_4 = p_LeadsField_4;}
    public List<SelectOption> getOperators() {return operators_1;}
    public String getOperator_1() {return operator_1;}
    public void setOperator_1 (String p_operator_1) {operator_1 = p_operator_1;}
    public String getOperator_2() {return operator_2;}
    public void setOperator_2 (String p_operator_2) {operator_2 = p_operator_2;}
    public String getOperator_3() {return operator_3;}
    public void setOperator_3 (String p_operator_3) {operator_3 = p_operator_3;}
    public String getOperator_4() {return operator_4;}
    public void setOperator_4 (String p_operator_4) {operator_4 = p_operator_4;}
    public list<CampaignMember> getMembers() {return members;}
    public list<MyMember> getMyMembers() {return myMembers;}
    public List<SelectOption> getCampaignMemberStatus() {return campaignMemberStatus;}
    public String getCampaignMemberStatusSelected() {return campaignMemberStatusSelected;}
    public void setCampaignMemberStatusSelected (String p_campaignMemberStatusSelected) {campaignMemberStatusSelected= p_campaignMemberStatusSelected;}
    public String getCampaignMemberStatusSelectedRapport() {return campaignMemberStatusSelectedRapport;}
    public void setCampaignMemberStatusSelectedRapport (String p_campaignMemberStatusSelectedRapport) {campaignMemberStatusSelectedRapport= p_campaignMemberStatusSelectedRapport;}
    public String getType() {return type;}
    public void setType (String p_type) {type = p_type;}
    public boolean getVisible() {return visible;}
    public void setVisible(boolean p_visible) {visible = p_visible;}
    public String getSelectedTab(){return selectedTab;}
    public void setSelectedTab (String p_selectedTab) {selectedTab = p_selectedTab;}
    public String getEmail1(){return email1;}
    public void setEmail1 (String p_email1) {email1= p_email1;}
    public String getEmail2(){return email2;}
    public void setEmail2 (String p_email2) {email2= p_email2;}
    public String getEmail1Rapport(){return email1Rapport;}
    public void setEmail1Rapport (String p_email1Rapport) {email1Rapport= p_email1Rapport;}
    public String getEmail2Rapport(){return email2Rapport;}
    public void setEmail2Rapport (String p_email2Rapport) {email2Rapport= p_email2Rapport;}
    public String getCampaignId() {return CampaignId;}
    public void setCampaignId(String p_campaignId) {campaignId = p_campaignId;}
    public String getCampaignName() {return CampaignName;}
    public void setCampaignName(String p_campaignName) {campaignName = p_campaignName;}
    public String getCampaignOwnerEmail() {return campaignOwnerEmail;}
    public void setCampaignOwnerEmail(String p_campaignOwnerEmail) {campaignOwnerEmail = p_campaignOwnerEmail;}
    public Id getCampaignOwnerId() {return CampaignOwnerId;}
    public void setCampaignOwnerId(String p_campaignOwnerId) {CampaignOwnerId = p_campaignOwnerId;}

    public String getQueryCondition_1() {return queryCondition_1;}
    public void setQueryCondition_1(String p_queryCondition_1) {queryCondition_1 = p_queryCondition_1;}
    public String getQueryCondition_2() {return queryCondition_2;}
    public void setQueryCondition_2(String p_queryCondition_2) {queryCondition_2 = p_queryCondition_2;}
    public String getQueryCondition_3() {return queryCondition_3;}
    public void setQueryCondition_3(String p_queryCondition_3) {queryCondition_3 = p_queryCondition_3;}
    public String getQueryCondition_4() {return queryCondition_4;}
    public void setQueryCondition_4(String p_queryCondition_4) {queryCondition_4 = p_queryCondition_4;}

    public String getQuery() {return query;}
    public void setQuery(String p_query) {query= p_query;}
    public String getIdToDelete() {return idToDelete;}
    public void setIdToDelete(String p_idToDelete) {idToDelete= p_idToDelete;}

    public Boolean getCheckedAll() {return checkedAll;}
    public void setCheckedAll(Boolean p_checkedAll) {checkedAll = p_checkedAll;}
    public Boolean getCheckedAllExist() {return checkedAllExist;}
    public void setCheckedAllExist(Boolean p_checkedAllExist) {checkedAllExist = p_checkedAllExist;}
    public Boolean getCheckedAllExistRapport() {return checkedAllExistRapport;}
    public void setCheckedAllExistRapport(Boolean p_checkedAllExistRapport) {checkedAllExistRapport = p_checkedAllExistRapport;}

    public Boolean getDisplayPopup() {return displayPopup;}
    public void setDisplayPopup(Boolean p_displayPopup) {displayPopup = p_displayPopup;}
    
    public Boolean getMembersUncheckable() {return membersUncheckable;}
    public void setMembersUncheckable(Boolean p_membersUncheckable) {membersUncheckable = p_membersUncheckable;}
   
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    
    public void populateMyMembers(){

    if(type.equals('Pistes')){
        leads = DAL.getLeads(query);

        Map<String,String> lemap = new Map<String,String>();
        lemap = DAL.getMemberCampaignStatus(campaignId );

        myMembers = new List<myMember>();
        for(Lead l : leads){
            MyMember myMember = new MyMember();
            myMember.FirstName = l.FirstName;
            myMember.LastName = l.LastName;
            myMember.title = l.title;
            myMember.Company = l.Company;
            myMember.Email = l.Email;
            myMember.checked = false;
            myMember.Id = l.Id;
            myMember.status = (String)lemap.get(l.Id);
            myMembers.add(myMember);
        }
      }else{
        contacts = DAL.getContacts(query);

        Map<String,String> lemap2 = new Map<String,String>();
        lemap2 = DAL.getMemberCampaignStatusContact(campaignId );

        Map<String,String> lemap = new Map<String,String>();
        List<String> ids = new List<String>();
        for(Contact l : contacts){
            ids.add(l.AccountId);
        }
        lemap = DAL.getAcounts(ids);

        myMembers = new List<myMember>();
        for(Contact l : contacts){
            MyMember myMember = new MyMember();
            myMember.FirstName = l.FirstName;
            myMember.LastName = l.LastName;
            myMember.title = l.title;
            myMember.Company = (String)lemap.get(l.AccountId);
            myMember.Email = l.Email;
            myMember.checked = false;
            myMember.Id = l.Id;
            myMember.status = (String)lemap2.get(l.Id);
            myMembers.add(myMember);
        }
      }
    }


    private Set<Id> selectedMemberIds = new Set<Id>();
    private List<Id> listSelectedMemberIds = new List<Id>();

    // -- Utilisé pour l'ajout d'élément à la liste d'éléments sélectionnés
    //
    public void selectItems(){
        if (!String.isBlank(selectedItems) && selectedItems != 'all') {
            this.selectedMemberIds = new Set<Id>((List<Id>)this.selectedItems.split(','));
            this.listSelectedMemberIds = new List<Id>(selectedMemberIds);
        } else {
            this.selectedMemberIds = new Set<Id>();
        }
    }

    // Standard set controller for the tab2.
    public Pagination paginationTab2 {get;set;}

    public void populateMyMembersExist(){
        paginationTab2 = new Pagination('select Id, Name__c, Title__c, Company__c, Email__c, Type__c, LastModifiedDate, Status'
                                                +   ' From CampaignMember'
                                                +    ' Where CampaignId = \''+campaignId+'\'');
    }

    public List<CampaignMember> getRecordsTab2() {
        List<CampaignMember> records;
        if (paginationTab2!=null)
            records = (List<CampaignMember>) paginationTab2.getRecords();
        return records;
    }

    public void nextPageTab2() {
        if (paginationTab2!=null)
            paginationTab2.next();
    }

    public void previousPageTab2() {
        if (paginationTab2!=null)
            paginationTab2.previous();
    }

    public class Pagination {
        public Integer offset {get;set;}
        public Integer pageSize {get;set;}
        public Boolean hasNext {get;set;}
        public Integer pageNumber {get;set;}
        public Integer resultSize {get;set;}
        private String originalQuery;
        private String paginatedQuery;

        public Pagination(String query) {
            originalQuery = query;
            offset = 0;
            resultSize = 0;
            pageSize = 25;
            pageNumber = 1;
        }


        private transient List<SObject> recordsList;

        public List<SObject> getRecords() {
            if (recordsList==null) {
                paginatedQuery = originalQuery + ' LIMIT ' + (pageSize + 1);
                paginatedQuery += ' OFFSET ' + offset;

                recordsList = Database.query(paginatedQuery);
                system.debug('########paginatedQuery='+paginatedQuery);
                system.debug('########recordsList.size()='+recordsList.size());
                hasNext = recordsList.size()>pageSize;
                if (hasNext)recordsList.remove(pageSize);// Remove the last record from the list (to avoid displaying it).
                resultSize = ((pageNumber-1) * pageSize) + recordsList.size();
            }
            return recordsList;
        }

        public void next() {
            if (hasNext) {
                offset += pageSize;
                pageNumber++;
            }
            recordsList = null;
            getRecords();
        }

        public void previous() {
            offset -= pageSize;
            offset = (offset<0)? 0 : offset;
            pageNumber = (pageNumber>1)? (pageNumber-1) : 1;
            recordsList = null;
            getRecords();
        }
    }

    // Standard set controller for the tab3.
    public Pagination paginationTab3 {get;set;}

    public void populateMyMembersExistRapport(){
        paginationTab3 = new Pagination('select Id, Name__c, Title__c, Company__c, Email__c, Type__c, LastModifiedDate, Status'
                                                +   ' From CampaignMember'
                                                +    ' Where CampaignId = \''+campaignId+'\''
                                                +    ' And MembreExistant__c = true');
    }

    public void selectAllMembersTab3() {
        transient Map<Id, CampaignMember> membersMap = new Map<Id, CampaignMember>(
            [Select Id
             From CampaignMember
             Where CampaignId = :campaignId AND MembreExistant__c = true]);
        
        //Récuperer seulement les IDs dans un set (seule solution depuis une map)
        this.selectedMemberIds = membersMap.keySet();
        //Récupérer les IDs des membres sélectionnés dans une liste pour traitements e-mail et statut
        this.listSelectedMemberIds = new List<Id>(selectedMemberIds);
        
        //Assigner une chaine pour palier le problème de rechargement des cases à cocher dans la VF page
        this.selectedItems = 'all';
        
        //Rendre incheckable les membres de la campagne
        setMembersUncheckable(true);
    }

    public List<CampaignMember> getRecordsTab3() {
        transient List<CampaignMember> records;
        if (paginationTab3!=null)
            records = (List<CampaignMember>) paginationTab3.getRecords();
        return records;
    }

    public void nextPageTab3() {
        selectItems();
        if (paginationTab3!=null)
            paginationTab3.next();
    }

    public void previousPageTab3() {
        selectItems();
        if (paginationTab3!=null)
            paginationTab3.previous();
    }


    // Utilisé pour le comptage du nombre d'éléments sélectionnés.
    public Integer getNbSelected(){
        return this.selectedMemberIds.size();
    }
    
    public void populateCampaignMemberStatus(){
        campaignMemberStatus = new List<SelectOption>();
        for(CampaignMemberStatus c : DAL.getCampaignMemberStatus(campaignId))
            campaignMemberStatus.add(new SelectOption(c.Label,c.Label));
    }

    private void populateLeadsFields(){
        Map<String, Schema.SObjectField> schemaFieldMap;

        if(type.equals('Pistes'))
            schemaFieldMap = Schema.SObjectType.Lead.fields.getMap();
        else
            schemaFieldMap = Schema.SObjectType.Contact.fields.getMap();

        leadsFields_1 = new List<SelectOption>();

        for (String fieldName: schemaFieldMap.keySet()) {
        if(((Schema.SObjectField)schemaFieldMap.get(fieldName)).getDescribe().isAccessible())
            if(((Schema.SObjectField)schemaFieldMap.get(fieldName)).getDescribe().getType() == DisplayType.REFERENCE)
                leadsFields_1.add(new SelectOption(((Schema.SObjectField)schemaFieldMap.get(fieldName)).getDescribe().getRelationshipName() + '.Name', ((Schema.SObjectField)schemaFieldMap.get(fieldName)).getDescribe().getLabel()));
            else
                leadsFields_1.add(new SelectOption(fieldName, ((Schema.SObjectField)schemaFieldMap.get(fieldName)).getDescribe().getLabel()));
        }

        leadsFields_1 = SortOptionList(leadsFields_1);
    }

    private void populateOperators(){
        operators_1 = new List<SelectOption>();
        operators_1.add(new SelectOption('=', 'égale à'));
        operators_1.add(new SelectOption('!=', 'diffèrent de'));
        operators_1.add(new SelectOption('like_commence_par', 'commence par'));
        operators_1.add(new SelectOption('like_contient', 'contient'));
        operators_1.add(new SelectOption('like_ne_contient_pas', 'ne contient pas'));
        operators_1.add(new SelectOption('<', 'inférieur à'));
        operators_1.add(new SelectOption('>', 'supérieur à'));
        operators_1.add(new SelectOption('<=', 'inférieur ou égal à'));
        operators_1.add(new SelectOption('>=', 'supérieur ou égal à'));
    }


    public void selectDeselectAll(){
        if (myMembers != null)
            for(myMember m: myMembers)m.checked = checkedAll;
    }


    public void effacerFiltres(){
        queryCondition_1 = '';
        queryCondition_2 = '';
        queryCondition_3 = '';
        queryCondition_4 = '';
        populateLeadsFields();
    }

    public void rechercher(){


        Pattern isnumbers = Pattern.Compile('^[0-9]+$');
        Matcher numberMatch_1 = isnumbers.matcher(queryCondition_1 );
        if(!''.equals(queryCondition_1 ) && !numberMatch_1 .Matches()){
            queryCondition_1 = '\'' + queryCondition_1 + '\'';
        }
        Matcher numberMatch_2 = isnumbers.matcher(queryCondition_2 );
        if(!''.equals(queryCondition_2 ) && !numberMatch_2 .Matches()){
            queryCondition_2 = '\'' + queryCondition_2 + '\'';
        }
        Matcher numberMatch_3 = isnumbers.matcher(queryCondition_3 );
        if(!''.equals(queryCondition_3 ) && !numberMatch_3 .Matches()){
            queryCondition_3 = '\'' + queryCondition_3 + '\'';
        }
        Matcher numberMatch_4 = isnumbers.matcher(queryCondition_4 );
        if(!''.equals(queryCondition_4 ) && !numberMatch_4 .Matches()){
            queryCondition_4 = '\'' + queryCondition_4 + '\'';
        }

        if(operator_1.contains('like') && !queryCondition_1.contains('\''))
            queryCondition_1 = '\'' + queryCondition_1 + '\'';
        if(operator_2.contains('like') && !queryCondition_2.contains('\''))
            queryCondition_2 = '\'' + queryCondition_2 + '\'';
        if(operator_3.contains('like') && !queryCondition_3.contains('\''))
            queryCondition_3 = '\'' + queryCondition_3 + '\'';
        if(operator_4.contains('like') && !queryCondition_4.contains('\''))
            queryCondition_4 = '\'' + queryCondition_4 + '\'';

        String query1 = queryCondition_1.equals('') ? null : LeadsField_1  + ' ' + operator_1 + ' ' + queryCondition_1;
        String query2 = queryCondition_2.equals('') ? null : LeadsField_2  + ' ' + operator_2 + ' ' + queryCondition_2;
        String query3 = queryCondition_3.equals('') ? null : LeadsField_3  + ' ' + operator_3 + ' ' + queryCondition_3;
        String query4 = queryCondition_4.equals('') ? null : LeadsField_4  + ' ' + operator_4 + ' ' + queryCondition_4;


        if(query1 == null && query2 != null) query2 = query2;
        else if(query1 != null && query2 != null) query2 =  'XANDX' + query2;
        else query2 = null;

        if(query2 == null && query3 != null) query3 = query3;
        else if(query2 != null && query3 != null) query3 =  'XANDX' + query3;
        else query3 = null;

        if(query1 == null && query4 != null) query4 = query4;
        else if(query1 != null && query4 != null) query4 =  'XANDX' + query4;
        else query4 = null;

        if(query1 == null && query3 != null) query3 = query3;
        else if(query1 != null && query3 != null) query3 =  'XANDX' + query3;
        else query3 = null;

        if(query3 == null && query4 != null) query4 = query4;
        else if(query3 != null && query4 != null) query4 =  'XANDX' + query4;
        else query4 = null;

        if(query2 == null && query4 != null) query4 = query4;
        else if(query2 != null && query4 != null) query4 =  'XANDX' + query4;
        else query4 = null;

        query1 = query1 != null ? query1 : '';
        query2 = query2 != null ? query2 : '';
        query3 = query3 != null ? query3 : '';
        query4 = query4 != null ? query4 : '';


        /************ Traitement des LIKE ****************************************************/
        if(query1 != null && query1.contains('like_commence_par') && query1.contains('\'')){
            query1 = query1.replace('like_commence_par','like');
            query1 = query1.substring(0,query1.lastIndexOf('\'')) + '%' + query1.substring(query1.lastIndexOf('\''),query1.length());
        }
        if(query1 != null && query1.contains('like_contient') && query1.contains('\'')){
            query1 = query1.replace('like_contient','like');
            query1 = query1.substring(0,query1.indexOf('\'')+1) + '%' + query1.substring(query1.indexOf('\'')+1,query1.lastIndexOf('\'')) + '%' + query1.substring(query1.lastIndexOf('\''),query1.length());
        }
        if(query1 != null && query1.contains('like_ne_contient_pas') && query1.contains('\'')){
            query1 = query1.replace('like_ne_contient_pas','not like');
            query1 = query1.substring(0,query1.indexOf('\'')+1) + '%' + query1.substring(query1.indexOf('\'')+1,query1.lastIndexOf('\'')) + '%' + query1.substring(query1.lastIndexOf('\''),query1.length());
        }
        if(query2 != null && query2.contains('like_commence_par') && query2.contains('\'')){
            query2 = query2.replace('like_commence_par','like');
            query2 = query2.substring(0,query2.lastIndexOf('\'')) + '%' + query2.substring(query2.lastIndexOf('\''),query2.length());
        }
        if(query2 != null && query2.contains('like_contient') && query2.contains('\'')){
            query2 = query2.replace('like_contient','like');
            query2 = query2.substring(0,query2.indexOf('\'')+1) + '%' + query2.substring(query2.indexOf('\'')+1,query2.lastIndexOf('\'')) + '%' + query2.substring(query2.lastIndexOf('\''),query2.length());
        }
        if(query2 != null && query2.contains('like_ne_contient_pas') && query2.contains('\'')){
            query2 = query2.replace('like_ne_contient_pas','not like');
            query2 = query2.substring(0,query2.indexOf('\'')+1) + '%' + query2.substring(query2.indexOf('\'')+1,query2.lastIndexOf('\'')) + '%' + query2.substring(query2.lastIndexOf('\''),query2.length());
        }
        if(query3 != null && query3.contains('like_commence_par') && query3.contains('\'')){
            query3 = query3.replace('like_commence_par','like');
            query3 = query3.substring(0,query3.lastIndexOf('\'')) + '%' + query3.substring(query3.lastIndexOf('\''),query3.length());
        }
        if(query3 != null && query3.contains('like_contient') && query3.contains('\'')){
            query3 = query3.replace('like_contient','like');
            query3 = query3.substring(0,query3.indexOf('\'')+1) + '%' + query3.substring(query3.indexOf('\'')+1,query3.lastIndexOf('\'')) + '%' + query3.substring(query3.lastIndexOf('\''),query3.length());
        }
        if(query3 != null && query3.contains('like_ne_contient_pas') && query3.contains('\'')){
            query3 = query3.replace('like_ne_contient_pas','not like');
            query3 = query3.substring(0,query3.indexOf('\'')+1) + '%' + query3.substring(query3.indexOf('\'')+1,query3.lastIndexOf('\'')) + '%' + query3.substring(query3.lastIndexOf('\''),query3.length());
        }
        if(query4 != null && query4.contains('like_commence_par') && query4.contains('\'')){
            query4 = query4.replace('like_commence_par','like');
            query4 = query4.substring(0,query4.lastIndexOf('\'')) + '%' + query4.substring(query4.lastIndexOf('\''),query4.length());
        }
        if(query4 != null && query4.contains('like_contient') && query4.contains('\'')){
            query4 = query4.replace('like_contient','like');
            query4 = query4.substring(0,query4.indexOf('\'')+1) + '%' + query4.substring(query4.indexOf('\'')+1,query4.lastIndexOf('\'')) + '%' + query4.substring(query4.lastIndexOf('\''),query4.length());
        }
        if(query4 != null && query4.contains('like_ne_contient_pas') && query4.contains('\'')){
            query4 = query4.replace('like_ne_contient_pas','not like');
            query4 = query4.substring(0,query4.indexOf('\'')+1) + '%' + query4.substring(query4.indexOf('\'')+1,query4.lastIndexOf('\'')) + '%' + query4.substring(query4.lastIndexOf('\''),query4.length());
        }

        query1 = query1.replace('\'%\'','');
        query1 = query1.replace('\'%%\'','');

        query2 = query2.replace('\'%\'','');
        query2 = query2.replace('\'%%\'','');

        query3 = query3.replace('\'%\'','');
        query3 = query3.replace('\'%%\'','');

        query4 = query4.replace('\'%\'','');
        query4 = query4.replace('\'%%\'','');

        /*************************************************************************************/

        query = query1 + query2 + query3 + query4;

        query = query.replace('XANDXXANDXXANDX', ' AND ');
        query = query.replace('XANDXXANDX', ' AND ');
        query = query.replace('XANDX', ' AND ');


        if(type.equals('Pistes')){
            if(query != null && !''.equals(query))
                query = ' where ' + query + ' and status = \'En cours\'';
            else
                query = ' where status = \'En cours\'';
        }else if(query != null && !''.equals(query))
                query = ' where ' + query;

        populateMyMembers();


        queryCondition_1 = queryCondition_1.replaceAll('\'','');
        queryCondition_2 = queryCondition_2.replaceAll('\'','');
        queryCondition_3 = queryCondition_3.replaceAll('\'','');
        queryCondition_4 = queryCondition_4.replaceAll('\'','');
    }

    public void addMembersToCampaing(){
        try{

            List<CampaignMember> listcmToInsert = new List<CampaignMember>();
            List<CampaignMember> listcmToUpdate = new List<CampaignMember>();
            List<CampaignMember> listcmToUpdateAll = new List<CampaignMember>();
            List<CampaignMember> listcmToUpdateAllDB = new List<CampaignMember>();

            Map<String,String> lemap = new Map<String,String>();
            lemap = DAL.getMemberCampaignId(campaignId);

            Map<String,String> lemap2 = new Map<String,String>();
            lemap2 = DAL.getMemberCampaignIdContact(campaignId);

            if(myMembers != null){

                if(type.equals('Contacts')) updateContactEmail();

                for(MyMember m :myMembers ){
                    if(m.checked){
                        CampaignMember cm = new CampaignMember();
                        cm.CampaignId = campaignId;

                        if(type.equals('Pistes')){
                            cm.LeadId = m.Id;
                        }else{
                            cm.ContactId = m.Id;
                        }

                        cm.Status = campaignMemberStatusSelected;
                        if(lemap.get(m.Id) == null && lemap2.get(m.Id) == null){
                            System.debug('### resultat : ' + cm.Id);
                            listcmToInsert.add(cm);
                        }
                        else{
                            if(type.equals('Pistes')){
                                cm.id = (String) lemap.get(m.Id);
                            }else{
                                cm.id = (String) lemap2.get(m.Id);
                            }

                            System.debug('### resultat : ' + cm.Id);
                            listcmToUpdate.add(cm);
                            }
                    }
                }
            insert listcmToInsert;
            update listcmToUpdate;
            }

            if(listcmToInsert != null )listcmToUpdateAll.addAll(listcmToInsert);
            if(listcmToUpdate!= null )listcmToUpdateAll.addAll(listcmToUpdate);

            listcmToUpdateAllDB = DAL.getMemberCampaignById(listcmToUpdateAll);

            for(CampaignMember c : listcmToUpdateAllDB )
                c.Date_chargement_VF__c = c.lastModifiedDate ;

            update listcmToUpdateAllDB ;

            selectedTab = 'tab2';
            rechercher();
            checkedAll = false;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
        }
    }


    public void addMembersToCampaignRapport(){
        selectItems();
        try{
            if (this.listSelectedMemberIds.size()>0) {
                
                //Executer un batch pour palier la limite de temps de transaction Apex
                //Mettre à jour l'email des membres de la campagnes sélectionnés
                BatchUpdateContactEmailCampaignMembers batchEmail = new BatchUpdateContactEmailCampaignMembers(listSelectedMemberIds, email1Rapport, email2Rapport, campaignOwnerEmail, campaignName);
                Database.executeBatch(batchEmail); 
         
                //Executer un batch pour palier la limite de requête DML
                //Mettre à jour le statut des membres de la campagne sélectionnés
                BatchUpdateStatusCampaignMembers batchStatus = new BatchUpdateStatusCampaignMembers(listSelectedMemberIds, campaignMemberStatusSelectedRapport);
                Database.executeBatch(batchStatus);
                
                //Afficher un pop-up pour indiquer que le traitement batch est en cours
                showPopup();
			}

            selectedTab = 'tab2';
            populateMyMembersExistRapport();
            checkedAllExistRapport= false;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.FATAL,ex.getMessage()));
        }
    }

    public void deleteCampaignMember(){

        CampaignMember c = new CampaignMember ();
        System.debug('RESULTAT : ' +  idToDelete);
        c.id = idToDelete;


        delete c;

        populateMyMembersExist();

    }

    private void updateContactEmail(){

        Map<String,Contact> lemap = new Map<String,Contact>();
        List<String> ids = new List<String>();
        for(MyMember m :myMembers ){
            ids.add(m.id);
        }
        lemap = DAL.getContactsEmail(ids);

        List<Contact> contactUpdate = new List<Contact>();

        for(MyMember m :myMembers ){
        if(m.checked){
            Contact c = new Contact();
            c.id = m.Id;

            if(email1.equals('Email_de_repli__c')){
                c.email = ((Contact) lemap.get(m.id)).Email_de_repli__c;
            }

            if(email1.equals('Email_EM_Lyon__c')){
                c.email = ((Contact) lemap.get(m.id)).Email_EM_Lyon__c;
            }

            if(email1.equals('Adresse_Email_Personnelle__c')){
                c.email = ((Contact) lemap.get(m.id)).Adresse_Email_Personnelle__c;
            }

            if(c.email == null || ''.equals(c.email)){
                if(email2.equals('Email_de_repli__c')){
                    c.email = ((Contact) lemap.get(m.id)).Email_de_repli__c;
                }

                if(email2.equals('Email_EM_Lyon__c')){
                    c.email = ((Contact) lemap.get(m.id)).Email_EM_Lyon__c;
                }

                if(email2.equals('Adresse_Email_Personnelle__c')){
                    c.email = ((Contact) lemap.get(m.id)).Adresse_Email_Personnelle__c;
                }
            }

            contactUpdate.add(c);
           }
        }

        update contactUpdate;

    }

    private List<SelectOption> SortOptionList(List<SelectOption> ListToSort)
    {
        if(ListToSort == null || ListToSort.size() <= 1)
            return ListToSort;

        List<SelectOption> Less = new List<SelectOption>();
        List<SelectOption> Greater = new List<SelectOption>();

        integer pivot = ListToSort.size() / 2;
        // save the pivot and remove it from the list
        SelectOption pivotValue = ListToSort[pivot];
        ListToSort.remove(pivot);
        for(SelectOption x : ListToSort)
        {
            if(x.getLabel() <= pivotValue.getLabel())
                Less.add(x);
            else if(x.getLabel() > pivotValue.getLabel()) Greater.add(x);
        }
        List<SelectOption> returnList = new List<SelectOption> ();
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue);
        returnList.addAll(SortOptionList(Greater));
        return returnList;
    }
}