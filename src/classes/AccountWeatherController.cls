/**
 * Component의 Backend를 다루는 Controller.
 */
public with sharing class AccountWeatherController {

    public String city {get;set;}
    public Decimal temp {get;set;}
    public Integer pressure {get;set;}
    public Integer humidity {get;set;}
    public Decimal temp_min {get;set;}
    public Decimal temp_max {get;set;}
    public String description {get;set;}

    public AccountWeatherController(){ // new comment

    }

    public AccountWeatherController(ApexPages.StandardController stdController) {
        Account account = (Account)stdController.getRecord();
        System.debug('account.Id : ' + account.Id);
        account = [SELECT Id, ShippingCity FROM Account WHERE Id =: account.Id];

        String accountCity = account.ShippingCity;
        String apiKey = '5a5945a9e60654f2359a8df875390410';

        String requestEndpoint = 'https://api.openweathermap.org/data/2.5/weather';
        requestEndpoint += '?q=' + accountCity;
        requestEndpoint += '&units=metric';
        requestEndpoint += '&appid=' + apiKey;

        // Instantiate a new Http object
        Http http = new Http();
        // Instantiate a new HTTP Request
        HttpRequest request = new HttpRequest();
        // specify the endpoint
        request.setEndpoint(requestEndpoint);
        // specify the method(GET)
        request.setMethod('GET');
        // Send the request
        HttpResponse response = http.send(request);

        system.debug('JSON.deserializeUntyped : ' + JSON.deserializeUntyped(response.getBody()));

        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {

            // Deserialize the JSON string into collections of primitive data types.
            AWC_Wrapper_master results = (AWC_Wrapper_master)JSON.deserialize(response.getBody(),AWC_Wrapper_master.class);
            system.debug('results : ' + results);

            description = results.weather[0].description;
            city = results.name;
            temp = results.main.temp;
            pressure = results.main.pressure;
            humidity = results.main.humidity;
            temp_min = results.main.temp_min;
            temp_max = results.main.temp_max;

        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error retrieving the weather information.');
            ApexPages.addMessage(myMsg);
        }


    }
}