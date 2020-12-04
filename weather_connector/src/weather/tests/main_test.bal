import ballerina/io;
import ballerina/test;

WeatherConfiguration testConf = {
    apiKey: "<your api key>"
};

string countryName = "Colombo";

Client weatherClient = check new(testConf);

@test:Config{}
function testGetCurrentWeatherByCity(){
    
    WeatherDataResponse|error result = weatherClient->getCurrentWeather(countryName);
    
    if result is WeatherDataResponse{
        io:println("testGetCurrentWeatherByCity : ",result);
    }else{
        io:println(result.message());
        test:assertFail(result.toString());
    }
}
