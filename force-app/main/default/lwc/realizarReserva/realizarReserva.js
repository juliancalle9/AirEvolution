import { LightningElement, track, wire } from 'lwc';
import buscarCliente from '@salesforce/apex/Cliente.buscarCliente';
import obtenerVuelos from '@salesforce/apex/Cliente.encontrarVuelos';
import validarReservas from '@salesforce/apex/Cliente.validarReservas';
import crearReservas from '@salesforce/apex/Cliente.crearReserva';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const columns = [
    { label: 'Código',fieldName: 'codVuelo'},
    { label: 'Fecha y hora de partida', fieldName: 'fechaPartida', type: 'datetime' },
    { label: 'Fecha y hora estimida de llegada',fieldName: 'fechaEstimadaLlegada', type: 'datetime'},
    { label: 'Aeropuerto de partida', fieldName: 'aeropuertoSalida', type: 'text'},
    { label: 'Aeropuerto de llegada', fieldName: 'aeropuertoLlegada', type: 'text'},
    { label: 'Precio', fieldName: 'precioUnitario'}, 
   
];


export default class RealizarReserva extends LightningElement {
    data = [];
    columns = columns;


    @track crearCliente = false;
    @track mostrarCrearReserva = false;
    @track mostrarVuelos = false;
    @track clienteConReservas = false; 
    @wire(obtenerVuelos)vuelos(result){
        console.log(this.result);
        if(result.data) {
            console.log('si trajo algo');
            this.data = result.data;
            console.log(this.data[0]);
            this.error = undefined;
        }else if(result.error) {
            console.log('no trajo nada');
            console.log(result.error);
            this.error = result.error;
            this.data = undefined;
        }

    }
    
    numeroidentificacion;
    tipoidentificacion;
    contacto;
    idcontacto;
    codigoVuelo;
    idvuelo;
    vueloSeleccionado;
    isModalOpen;
    tieneReserva;
    listaPrecio;
    
    

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

    get contactoId(){
        if(this.contacto != null){
            return this.contacto.id;
        }else{
            return '';
        }
    }

    buscarClienteClick(event){
        buscarCliente({numeroIdentificacion : this.numeroidentificacion, tipoIdentificacion : this.tipoidentificacion})
        .then((result) =>{
            this.contacto = result;
            this.error = undefined;
            if(this.contacto === null){
                this.crearCliente = true;

            }else{
                validarReservas({idContacto : this.contacto})
                .then((result) =>{
                    this.error = undefined;
                    if(result === true){
                        
                        this.isModalOpen = true;
                    }else{
                        this.clienteConReservas = true;
                    }
                }); 
            }
        });
    }

    crearClienteClick(event){
        this.isModalOpen = true;
    }

    guardarTipoListaClick(event){
        console.log(this.contacto);
        crearReservas({idContacto : this.contacto, tipoTiquete : this.listaPrecio})
        .then((result) =>{
            this.error = undefined;
            this.mostrarCrearReserva = true;
            this.isModalOpen = false;
        });
    }

    
    handleChangeListaPrecios(event){
        this.listaPrecio = event.detail.value;
        console.log(this.listaPrecio);
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
        this.contacto.id = event.detail.id;
        String(this.contacto.id);
        console.log(this.contacto.id + ' id contacto');
        
    }

    seleccionarVueloFila(event){
        const selectedRows = event.detail.selectedRows;
        this.vueloSeleccionado = selectedRows[0].codVuelo;
        console.log(this.vueloSeleccionado);
    }
    
}