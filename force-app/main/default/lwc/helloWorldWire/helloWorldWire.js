import {api, LightningElement, wire } from 'lwc';
import { updateRecord,createRecord,getFieldValue, getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account'
import NAME_FIELD from '@salesforce/schema/Account.Name';
import ID_FIELD from '@salesforce/schema/Account.Id';


export default class HelloWorldWire extends LightningElement { 
    @api recordId = '0018a00001pSJCnAAO';
    accountId;
    name = '';
    @wire(getRecord, {recordId:  '$recordId', fields:[NAME_FIELD]})
    record;

    get acctName(){
        return this.record.data ? getFieldValue(this.record.data, NAME_FIELD): '';
    }
    handleNameChange(event){
        this.accountId = undefined;
        this.name = event.target.value;
    }
    createAccount(){
        const fields = {}
        fields[NAME_FIELD.fieldApiName] = this.name;
        const recordInput ={apiName: ACCOUNT_OBJECT.objectApiName, fields };
        createRecord(recordInput)
        .then(account => {
            this.accountId = account.id;
            console.log('Cuenta agregada con éxito');
        })
        .catch(error => {
            console.error(error);
        })
    }

    updateAccount(){
        const fields = {}
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[NAME_FIELD.fieldApiName] = this.name;
        const recordInput ={ fields };
        updateRecord(recordInput)
        .then(() => {
            
            console.log('Cuenta actualizada con éxito');
        })
        .catch(error => {
            console.error(error);
        })
    }
    


}
/*const fields =[ 
    {label: 'Nombre', fieldName: FIRSTNAME.fieldApiName, type: 'text'},
    {label: 'Apellido', fieldName: LASTNAME.fieldApiName, type: 'text'},
    {label: 'Tipo de identificación', fieldName: TIPODEIDENTIFICACION.fieldApiName, type: 'text'}, 
    {label: 'Número de identificación',fieldName: NUMERODEIDENTIFICACION.fieldApiName, type: 'text'}, 
    {label: 'Número de pasaporte',fieldName: NUMERODEPASAPORTE.fieldApiName, type: 'text'}]*/

    /*<lightning-record-form
            object-api-name={objectApiName}
            record-id={recordId}
            fields={fields2}
            onsuccess={handleSuccess}>
            <div class="slds-form-element__control">
            
                    <lightning-input-field field-name="firstName" label="Nombre"></lightning-input-field>
                    <lightning-input-field label="Apellido" field-name="lastName" > </lightning-input-field>
                    <lightning-input-field label="Tipo de identificación" field-name="tipoDeIdentificacion__c" > </lightning-input-field>
                    <lightning-input-field label="Número de identificación" field-name="numeroDeIdentificacion__c"> </lightning-input-field>
                    <lightning-input-field label="Número de pasaporte" field-name="numeroDePasaporte__c"> </lightning-input-field>
                    <lightning-input-field type="date" label="Fecha de nacimiento" field-name="Birthdate"> </lightning-input-field>
                    <lightning-input-field type="email" label="Correo electrónico" field-name="Email"> </lightning-input-field>
                    <lightning-input-field label="Nacionalidad" field-name="nacionalidad__c"> </lightning-input-field>
            </div>

        </lightning-record-form>*/