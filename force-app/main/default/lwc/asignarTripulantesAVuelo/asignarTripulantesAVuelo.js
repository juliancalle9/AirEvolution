import { LightningElement, wire, api } from 'lwc';
import obtenerVuelos from '@salesforce/apex/TripulacionRequerida.obtenerVuelos';
import getAuxiliares from '@salesforce/apex/TripulacionRequerida.getAuxiliares';
const actions = [{
    label: 'Asignar', name: 'asignar'
},];

const columns = [
    { label: 'Código', fieldName: 'codVuelo'},
    { label: 'Auxiliares Requeridos', fieldName: 'numAuxiliares' , type: 'number' },
    { label: 'Auxiliares Faltantes', fieldName: 'numAxiliaresRestantes', type: 'number'},
    { label: 'Tiene Piloto', fieldName: 'piloto', type: 'boolean' },
    { label: 'Tiene Copiloto', fieldName: 'copiloto', type: 'boolean' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];
export default class AsignarTripulantesAVuelo extends LightningElement {
    _selected = [];
    columns = columns;
    isModalOpen;
    @wire(obtenerVuelos) vuelos;
    id;
    codigoV;
    auxRequeridos;
    tienePiloto; 
    tieneCopiloto;
    auxFaltantes;

    handleRowAction(event){
        this.isModalOpen = true;
        const row = event.detail.row;
        this.codigoV = row.codVuelo;
        this.auxRequeridos = row.numAuxiliares;
        this.auxFaltantes = row.numAxiliaresRestantes;
        this.tienePiloto = row.piloto;
        this.tieneCopiloto = row.copiloto;
        this.id = row.idVuelo;
    }

    get idvuelom(){
        return this.id;
    }
    closeModal(event){
        this.isModalOpen = false;
    }


    
}