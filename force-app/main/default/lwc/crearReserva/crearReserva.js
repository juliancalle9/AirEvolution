import { api, LightningElement, wire } from 'lwc';
import {createRecord,  getRecord, getFieldValue} from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import TITULARDERESERVA_FIELD from '@salesforce/schema/Opportunity.Titular_de_reserva__c';
import ESTADO_FIELD from '@salesforce/schema/Opportunity.StageName';
import NOMBREDERESERVA_FIELD from '@salesforce/schema/Opportunity.Name';
import FECHADEPAGO_FIELD from '@salesforce/schema/Opportunity.CloseDate';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



export default class creaOEdita extends LightningElement {
    @api recordId; 
    @wire(getRecord, {recordId: '$recordId', fields: [NAME_FIELD]}) record;
    objectApiName = OPPORTUNITY_OBJECT;
    opportunityId;
    estado = 'pre-venta';
    fecha = new Date().toISOString().slice(0, 10);

    get contactName(){
        return this.record.data ? getFieldValue(this.record.data, NAME_FIELD) : '';
    }

    createOpportunity(){
        const fields = {}
        fields[TITULARDERESERVA_FIELD.fieldApiName] = this.recordId;
        fields[ESTADO_FIELD.fieldApiName] = this.estado;
        fields[NOMBREDERESERVA_FIELD.fieldApiName] = this.contactName;
        fields[FECHADEPAGO_FIELD.fieldApiName] = this.fecha;
       
        const recordInput ={apiName: OPPORTUNITY_OBJECT.objectApiName, fields };
        console.log(recordInput);
        createRecord(recordInput)
        .then(opportunity => {
            
            this.opportunityId = opportunity.id;
            const eventoShow = new ShowToastEvent({
                title: 'Éxito',
                message: 'Reserva creada con éxito',
                variant: 'success',
            });
            this.dispatchEvent(eventoShow);
            console.log(fields);
            console.log('Cuenta agregada con éxito');
        })
        .catch(error => {
            console.error(error);
        })
    }

}