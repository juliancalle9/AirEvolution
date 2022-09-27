import { LightningElement, wire, api } from 'lwc';
import obtenerVuelos from '@salesforce/apex/TripulacionRequerida.obtenerVuelos';
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
        this.datos = event.detail.row;
        this.codigoV = this.datos.codVuelo;
        this.auxRequeridos = this.datos.numAuxiliares;
        this.auxFaltantes = this.datos.numAxiliaresRestantes;
        this.tienePiloto = this.datos.piloto;
        this.tieneCopiloto = this.datos.copiloto;
        this.id = this.datos.idVuelo;
    }

    get idvuelom(){
        return this.id;
    }
    closeModal(event){
        this.isModalOpen = false;
    }

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    handleChange(e) {
        this._selected = e.detail.value;
    }

}