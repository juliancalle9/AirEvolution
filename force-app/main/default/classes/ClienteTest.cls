@isTest
public class ClienteTest {
	@TestSetup
    static void makeData(){
        string numIdentificacion = String.valueOf(Math.random() * 1000);
        date fecha = date.today();
        //CLIENTES Y PASAJEROS
        List<Contact> clientes = new List<Contact>();
        List<Contact> pasajeros = new List<Contact>();
        Contact clienteExistente = new Contact(firstName = 'Toño', LastName = 'Gonzoles',Numero_de_identificacion__c = '1',Tipo_de_identificacion__c = 'Cédula de ciudadania');
        Contact clienteExistente2 = new Contact(firstName = 'Tona', LastName = 'Gonzoles',Numero_de_identificacion__c = '2',Tipo_de_identificacion__c = 'Cédula de ciudadania');
        for(integer i = 0; i < 10; i++){
            clientes.add(new Contact(firstName = 'Juan' +i , LastName = 'test'+i, Numero_de_identificacion__c = numIdentificacion, Tipo_de_identificacion__c = 'Cédula de ciudadania'));
        }
        for(integer i = 0; i < 10; i++){
            pasajeros.add(new Contact(firstName = 'valentina' +i , LastName = 'test'+i, Numero_de_identificacion__c = numIdentificacion, Tipo_de_identificacion__c = 'Cédula de extranjería'));
        }
		insert clientes;
        insert clienteExistente;
        insert clienteExistente2;
        insert pasajeros;
        
        //RESERVAS
        //Opportunity reserva = new Opportunity(Titular_de_reserva__c =clienteExistente.id , StageName = 'pre-venta', CloseDate = fecha, Name = 'Nombre', Pricebook2Id = idLista)
        
    }
    
    @IsTest
    public static void buscarClienteTest(){    
        Contact clienteactual = [Select id, Numero_de_identificacion__c,Tipo_de_identificacion__c from contact where  Numero_de_identificacion__c = '1'];
        string resultado = Cliente.buscarCliente(clienteactual.Numero_de_identificacion__c, clienteactual.Tipo_de_identificacion__c);
        System.assertEquals(clienteactual.Id,resultado);
    }
    
    @IsTest
    public static void validarReservasTest(){
        Contact clienteActual1 = [Select id, Numero_de_identificacion__c,Tipo_de_identificacion__c from contact where  Numero_de_identificacion__c = '1'];
        Contact clienteActual2 = [Select id, Numero_de_identificacion__c,Tipo_de_identificacion__c from contact where  Numero_de_identificacion__c = '2'];
        
        
    }
}