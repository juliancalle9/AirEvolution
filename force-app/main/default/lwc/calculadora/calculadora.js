import { LightningElement } from 'lwc';

export default class Calculadora extends LightningElement {
    cadena = '';
    cadena2 = '';
    valor1 = '';
    valor2 = '';
    resultado = '';
    operacion = '';
    temp = '';

    numberClick(event){
        console.log('número-->'+event.target.dataset.id);
        switch(event.target.dataset.id){
            case '1':
                this.temp = '1';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                
                break;
            case '2':
                this.temp = '2';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
            case '3':
                this.temp = '3';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
            case '4':
                this.temp = '4';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
            case '5':
                this.temp = '5';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
            case '6':
                this.temp = '6';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
            case '7':
                this.temp = '7';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
            case '8':
                this.temp = '8';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
            case '9':
                this.temp = '9';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
            case '0':
                this.temp = '0';
                this.cadena += this.temp;
                this.cadena2 += this.temp;
                break;
        }
    }

    operationClick(event){
        switch(event.target.dataset.id){
            case '+':                
                this.valor1 = Number(this.cadena);
                this.cadena2 += ' + ' ;
                this.operacion = 'sumar';
                this.temp = '';
                this.cadena = '';
            break;
            case '-':
                this.valor1 = Number(this.cadena);
                this.cadena2 += ' - ';
                this.operacion = 'restar';
                this.temp = '';
                this.cadena = '';
            break;
            case '*':
                this.valor1 = Number(this.cadena);
                this.cadena2 += ' * ';
                this.operacion = 'multiplicar';
                this.temp = '';
                this.cadena = '';
            break;
            case '/':
                this.valor1 = Number(this.cadena);
                this.cadena2 += ' / ';
                this.operacion = 'dividir';
                this.temp = '';  
                this.cadena = '';      
        }
    }

    clear(){
        this.cadena = '';
        this.valor1 = '';
        this.valor2 = '';
        this.temp = '';
        this.operacion = '';
        this.resultado = '';
        this.cadena2 = '';
    }

    operate(){
        switch(this.operacion){
            case 'sumar':
                this.valor2 = Number(this.cadena);
                this.resultado = this.valor1 + this.valor2;
                this.cadena = this.resultado;
            break;
            case 'restar':
                this.valor2 = Number(this.cadena);
                this.resultado = this.valor1 - this.valor2;
                this.cadena = this.resultado;
            break;
            case 'multiplicar':
                this.valor2 = Number(this.cadena);
                this.resultado = this.valor1 * this.valor2;
                this.cadena = this.resultado;
            break;
            case 'dividir':
                this.valor2 = Number(this.cadena);
                this.resultado = this.valor1 / this.valor2;
                this.cadena = this.resultado;
            break;            
        }
    }
}