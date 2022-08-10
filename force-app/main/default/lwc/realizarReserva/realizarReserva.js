import { LightningElement, track, wire } from 'lwc';
import buscarCliente from '@salesforce/apex/Cliente.buscarCliente';
import obtenerVuelos from '@salesforce/apex/Cliente.encontrarVuelos';
import validarReservas from '@salesforce/apex/Cliente.validarReservas';
import crearReservas from '@salesforce/apex/Cliente.crearReserva';
import crearTiquete from '@salesforce/apex/cliente.crearTiquete';

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
    _selected = [];
    columns = columns;
    pasajerosTiquete = [];

    //Variables
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
    reservaCreada;
    tiqueteCreado;
    arrayEquipaje;
    seEstaCreadoPasajero = false;


    //templates y metodos con wire
    @track crearCliente = false;
    @track mostrarCrearReserva = false;
    @track mostrarVuelos = false;
    @track clienteConReservas = false;
    @track seleccionPasajerosTemplate = false; 
    @wire(obtenerVuelos,{lista : '$listaPrecio'})vuelos(result){
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
    // metodos get
    get equipajes(){
        return [
            {label: 'Personal', value: 'Personal'},
            {label: 'Maleta de cabina', value: 'Maleta de cabina'},
            {label: 'Maleta de bodega', value: 'Maleta de bodega'},
        ];
    }

    get selected() {
        return this._selected.length ? this._selected : 'none';
    }

    get tipos(){
        return [
            { label: 'Cédula de ciudadania', value: 'Cédula de ciudadania' },
            { label: 'Cédula de extranjería', value: 'Cédula de extranjería' },
        ];
    }

    get identPasajeros(){
        return [
            { label: 'Cédula de ciudadania', value: 'Cédula de ciudadania' },
            { label: 'Cédula de extranjería', value: 'Cédula de extranjería' },
            {label: 'Tarjeta de identidad', value: 'Tarjeta de Identidad' }
        ]
    }

    get Listas() {
        return [
            { label: 'Clase turista', value: 'Standard Price Book' },
            { label: 'Clase negocios', value: 'Tiquete negocios' },
        ];
    }

    /*get contactoId(){
        if(this.contacto != null){
            return this.contacto.id;
        }else{
            return '';
        }
    }*/

    //Onclick
    buscarClienteClick(event){
        buscarCliente({numeroIdentificacion : this.numeroidentificacion, tipoIdentificacion : this.tipoidentificacion})
        .then((result) =>{
            this.contacto = result;
            this.error = undefined;
            if(this.contacto === null){
                this.seEstaCreadoPasajero = false;
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

    buscarPasajeroClick(event){
        buscarCliente({numeroIdentificacion : this.numeroidentificacion, tipoIdentificacion : this.tipoidentificacion})
        .then((result) =>{
            this.contacto = result;
            this.error = undefined;
            if(this.contacto === null){
                this.crearCliente = true;
                this.isModalOpen = false;
                this.seEstaCreadoPasajero = true;
            }else{
                this.pasajerosTiquete.push(this.contacto);
                console.log('se encontro');
            }
        });
    }

    crearClienteClick(event){
        if(this.seEstaCreadoPasajero === false){
        this.isModalOpen = true;
        this.contacto = event.detail.id
        console.log(this.contacto);
        }else{
            this.contacto = event.detail.id
            this.pasajerosTiquete.push(this.contacto);
            console.log(this.contacto);
            this.crearCliente = false;
        }
    }

    guardarTipoListaClick(event){
        crearReservas({idContacto : this.contacto, tipoTiquete : this.listaPrecio})
        .then((result) =>{
            this.reservaCreada = result;
            this.error = undefined;
            this.mostrarCrearReserva = true;
            this.isModalOpen = false;
        });
    }

    crearTiqueteClick(event){
        crearTiquete({codigoVuelo : this.vueloSeleccionado, idReserva : this.reservaCreada, pasajero : this.contacto, equipaje : this._selected.join(";")})
        .then((result)=>{
            console.log(this.reservaCreada);
            console.log(this.contacto);

            this.error = undefined;
            this.tiqueteCreado = result;
            console.log(this.tiqueteCreado);
            alert('Se ha creado un tiquete para este cliente');
            this.mostrarCrearReserva = false;
            this.seleccionPasajerosTemplate = true;
        });
    }

    agregarPasajeroClick(event){
        for(let i = 0; i < this.pasajerosTiquete.length; i++){
            crearTiquete({codigoVuelo : this.vueloSeleccionado, idReserva : this.reservaCreada, pasajero : this.pasajerosTiquete[i], equipaje : this._selected.join(";")})
            .then((result)=>{
                console.log(this.pasajerosTiquete[i]);
                this.error = undefined;
                this.tiqueteCreado = result;
                console.log(this.tiqueteCreado);
                this.mostrarCrearReserva = false;
            });
            alert('Se han creado los tiquetes para estos clientes');

        }
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

    handleTiqueteCreado(event){
        const tiquete = new ShowToastEvent({
            title: 'Tiquete creado',
            message: 'Tiquete creado con éxito',
            variant: 'success',
        });
       
        this.dispatchEvent(tiquete);
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
        this.contacto = event.detail.id;
        String(this.contacto.id);
        console.log(this.contacto.id + ' id contacto');
        
    }

    handleEquipaje(event){
        this._selected = event.detail.value;
        console.log(this._selected);
    }

    seleccionarVueloFila(event){
        const selectedRows = event.detail.selectedRows;
        this.vueloSeleccionado = selectedRows[0].codVuelo;
        console.log(this.vueloSeleccionado);
    }
    
}