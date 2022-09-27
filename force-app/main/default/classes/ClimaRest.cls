public class ClimaRest {
    public static clima__c llamadaOpenweather(decimal latitud, decimal longitud, string idAeropuerto){
        Clima__c climas;
        string codigoApi = '0e64d11255d835cdac09ee7ba5cc53b5';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.openweathermap.org/data/2.5/weather?lat='+latitud+'&lon='+longitud+'&appid='+ codigoApi +'&units=metric');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> clima = (Map<String, Object>) results.get('main'); 
            climas = new Clima__c(Temperatura__c = (Decimal)clima.get('temp'), Unidad__c = 'Centigrados', Aeropuerto__c = idAeropuerto, Fecha_y_hora_de_prediccion__c = datetime.now());
        }
        return climas;
    }
}