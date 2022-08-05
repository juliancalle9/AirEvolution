import { LightningElement, api,wire } from 'lwc';
import getAuxiliares from '@salesforce/apex/TripulacionRequerida.getAuxiliares';
import saveAuxiliares from '@salesforce/apex/TripulacionRequerida.saveAuxiliares';

export default class EditarVuelo extends LightningElement {
    @api vueloId;
    options = [];
    values = [];
    _selected = [];
    @wire (getAuxiliares, {idVuelo : '$vueloId'}) 
    tripulantes({error, data}){
        if(data){
            this.options = data.map(key => ({ value: key.value, label: key.label }));
            this.values = data.filter(element => element.selected == true).map(key => key.value);
        }else if(error){
            console.log('error-->'+JSON.stringify(error));
        }
    }
    

    handleChange(e) {
        this._selected = e.detail.value;
    }
    handleSuccess(event) {
        if(this._selected.length == 0){
            this._selected = this.values;
        }
        saveAuxiliares({auxiliares : this._selected, idVuelo : this.vueloId})
        .then((result) => {
            console.log('sucess');
            this.error = undefined;
            console.log(this.vueloId);
        })
        .catch((error) => {
            this.error = error;
            console.log(error);
        });
    }

}