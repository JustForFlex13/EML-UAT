import { api, wire, track, LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import fetchRecords from '@salesforce/apex/SIS_CTRL_CustomRelatedList.fetchRecords';

// import LABEL_ERROR_MESSAGE_TITLE from '@salesforce/label/c.SIS_Error_message_title';
import LABEL_SORTED_BY from '@salesforce/label/c.SIS_Sorted_by';
import LABEL_ITEMS from '@salesforce/label/c.SIS_Items';

export default class SisCustomRelatedList extends LightningElement {
    @api recordId;
    @api objectName; 
    @api fieldsToDisplay;
    @api className; 
    @api methodName; 
    @api totalNumberOfRows;
    @track error;
    @track columns;
    @track data = [];
    @track titleWithCount;
    @track numberOfRecords;
    @track recordsBool;
    @track iconName;
    @track countBool = false;
    objectFields;
    rowOffset = 0;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    sortedByLabel;
    loadMoreStatus;

    label = {
        LABEL_SORTED_BY,
        LABEL_ITEMS
    };

    @wire(getObjectInfo, { objectApiName: '$objectName' })
    wiredObjectInfo({ error, data }) {
        if (data) {
            this.titleWithCount = data.labelPlural;
            // Building icon name dynamically
            let splitIconUrl = data.themeInfo.iconUrl.split("/");
            let iconType = splitIconUrl[splitIconUrl.length-2];
            let iconName = splitIconUrl[splitIconUrl.length-1];
            this.iconName = iconType + ':' + iconName.split('_')[0];
            
            this.columns = [];
            this.objectFields = new Map(Object.entries(data.fields));
            const fieldsToDisplayArray = this.fieldsToDisplay.replace(/\,$/, '').split(",").map(element => {
                return element.trim();
            });

            fieldsToDisplayArray.forEach(field => {
                if (!this.objectFields.get(field)) return;
                let fieldType;
                switch(this.objectFields.get(field)['dataType']) {
                    case 'Boolean':
                        fieldType = 'boolean';
                        break;
                    case 'Date':
                        fieldType = 'date';
                        break;
                    case 'Datetime':
                        fieldType = 'date';
                        break;
                    case 'Double':
                        fieldType = 'number';
                        break;
                    case 'Currency':
                        fieldType = 'currency';
                        break;
                    case 'Percent':
                        fieldType = 'percent';
                        break;
                    case 'Phone':
                        fieldType = 'phone';
                        break;
                    case 'Reference':
                        fieldType = 'text'; // value will be 'url' when we support this data type.
                        break;
                    case 'Url':
                        fieldType = 'url';
                        break;
                    default:
                        fieldType = 'text'
                }
                let newColumn;
                if (this.objectFields.get(field)['apiName'] === 'Name') {
                    newColumn =
                    {
                        label: this.objectFields.get(field)['label'], fieldName: 'nameFieldUrl', type: 'url', sortable: true, hideDefaultActions: true, displayReadOnlyIcon: true, typeAttributes: 
                        {
                            label: { fieldName: 'nameFieldName' },
                            target : '_self'
                        } 
                    }
                    
                } else {
                    newColumn = {
                        label : this.objectFields.get(field)['label'], 
                        fieldName: this.objectFields.get(field)['apiName'], 
                        type: fieldType, 
                        sortable: true, 
                        hideDefaultActions: true,
                        displayReadOnlyIcon: true
                    };
                }
                this.columns.push(newColumn);
            })
        } else if (error) {
            this.error = error;
            this.showErrorMessage(error);
        }
    }

    @wire(fetchRecords, { p_className: '$className', p_methodName: '$methodName', p_parentRecordId: '$recordId'}) 
    wiredRecords( { error, data } ) {
        if ( data ) {
            this.data = data.recordsList;
            this.data = this.data.map(row=>{
                return {
                    ...row, 
                    nameFieldName: row.Name,
                    nameFieldUrl: '/' + row.Id
                }
            });
            if ( data.recordCount ) {
                // this.totalNumberOfRows =  data.recordCount;
                // If we want to display only a few records on the related list
                // if ( data.recordCount > 3 ) {
                //     this.titleWithCount += ' (3+)';
                //     this.countBool = true;
                // } else {
                    this.countBool = false;
                    this.numberOfRecords = data.recordCount;
                    this.recordsBool = true;
                    this.titleWithCount += ' (' + data.recordCount + ')';
                // }
            } else {
                this.titleWithCount += ' (0)';
                this.recordsBool = false;
            }
        } else if (error) {
            this.error = error;
            this.showErrorMessage(error);
        }

    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.data];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.data = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
        this.sortedByLabel = sortedBy == "nameFieldUrl" ? "Name" : this.objectFields.get(sortedBy)['label'];
    }

    sortBy(field, reverse, primer) {
        const key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };

        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    // loadMoreData(event) {
    //     //Display a spinner to signal that data is being loaded
    //     event.target.isLoading = true;
    //     //Display "Loading" when more data is being loaded
    //     this.loadMoreStatus = 'Loading';
    //     fetchData(50).then((data) => {
    //         if (data.length >= this.totalNumberOfRows) {
    //             event.target.enableInfiniteLoading = false;
    //             this.loadMoreStatus = 'No more data to load';
    //         } else {
    //             const currentData = this.data;
    //             //Appends new data to the end of the table
    //             const newData = currentData.concat(data);
    //             this.data = newData;
    //             this.loadMoreStatus = '';
    //         }
    //         event.target.isLoading = false;
    //     });
    // }
    
    showErrorMessage(error, title = LABEL_ERROR_MESSAGE_TITLE) {
        console.log(error);
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: error.body.message !== null ? error.body.message : error.message ,
                variant: 'error'
            })
        );
    }
}