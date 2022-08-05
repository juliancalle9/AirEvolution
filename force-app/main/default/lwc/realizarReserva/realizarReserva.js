import { LightningElement, track, wire } from 'lwc';
import buscarCliente from '@salesforce/apex/Cliente.buscarCliente';
import crearReserva from '@salesforce/apex/Cliente.validarReservas';
import obtenerVuelos from '@salesforce/apex/Cliente.encontrarVuelos';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Código',fieldName: 'codVuelo'},
    { label: 'Fecha y hora de partida', fieldName: 'fechaPartida', type: 'datetime' },
    { label: 'Fecha y hora estimida de llegada',fieldName: 'fechaEstimadaLlegada', type: 'datetime'},
    { label: 'Aeropuerto de partida', fieldName: 'aeropuertoSalida', type: 'text'},
    { label: 'Aeropuerto de llegada', fieldName: 'aeropuertoLlegada', type: 'text'}, 
   
];


export default class RealizarReserva extends LightningElement {
    data = [];
    columns = columns;


    @track crearCliente = false;
    @track mostrarCrearReserva = false;
    @track mostrarVuelos = false;
    @wire(obtenerVuelos)vuelos;
    
    numeroidentificacion;
    tipoidentificacion;
    contacto;
    idcontacto;
    codigoVuelo;
    idvuelo;
    tipoTiquete;
    vueloSeleccionado;
    lista;
    isModalOpen;

    get tipos(){
        return [
            { label: 'Cédula de ciudadania', value: 'Cédula de ciudadania' },
            { label: 'Cédula de extranjería', value: 'Cédula de extranjería' },
            
        ];
    }

    get Listas() {
        return [
            { label: 'Clase turista', value: 'Standard Price Book' },
            { label: 'Clase negocios', value: 'Tiquete negocios' },
            
        ];
    }

    buscarClienteClick(event){
        buscarCliente({numeroIdentificacion : this.numeroidentificacion, tipoIdentificacion : this.tipoidentificacion})
        .then((result) =>{
            this.contacto = result;
            this.error = undefined;
            if(this.contacto === null){
                this.crearCliente = true;
            }else{
                this.mostrarCrearReserva = true;
            }
            this.isModalOpen = true;
        });
    }
    
    handleChangeListaPrecios(event){
        this.lista = event.detail.value;
        console.log(this.lista);
    }

    onchangeTipoDoc(event) {
        this.tipoidentificacion = event.detail.value;
        console.log(this.tipoidentificacion);
    }
    onchangeNumId(event){
        this.numeroidentificacion = event.detail.value;
        console.log(this.numeroidentificacion);
    }

    closeModal(event){
        this.isModalOpen = false;
    }

    //creación de cliente
    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Cliente creado',
            message: 'Cliente creado con éxito',
            variant: 'success',
        });
       
        this.dispatchEvent(evt);
        this.crearCliente = false;
        this.idcontacto = event.detail.id;
        String(this.idcontacto);
        console.log(this.idcontacto + ' id contacto');
        crearReserva({idContacto : this.idcontacto})
        .then((result) =>{
                console.log('si entro');
                console.log(this.idcontacto);
                this.mostrarCrearReserva = true;
                this.error = undefined;
        });
    }

    seleccionarVueloFila(event){
        const selectedRows = event.detail.selectedRows;
        this.vueloSeleccionado = selectedRows[0].codVuelo;
        console.log(this.vueloSeleccionado);
    }
    
}