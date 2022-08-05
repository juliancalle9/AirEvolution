import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import crearReserva from '@salesforce/apex/Cliente.validarReservas';


export default class CrearCliente extends LightningElement {
    @api tipoIdent;
    @api numIdent;
    @track mostrarCrearReserva = false;
    idContacto;

    get idContacto(){
        return this.idContacto;
    }

    handleSuccess(event) {
        crearReserva({idContacto : this.idContacto})
        .then((result) =>{
                this.mostrarCrearReserva = true;
        })
        const evt = new ShowToastEvent({
            title: 'Cliente creado',
            message: 'Cliente creado con éxito',
            variant: 'success',
        });

        this.dispatchEvent(evt);
    }
}