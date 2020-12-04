import ballerina/http;

public client class Client{
    string apiKey;
    http:Client weatherClient;

    public function init(WeatherConfiguration weatherConfig) returns error?{
        self.weatherClient = new(WEATHER_API_URL);
        self.apiKey = weatherConfig.apiKey;
    }

    public remote function getCurrentWeather(string city) returns @tainted WeatherDataResponse|error  {
        http:Request request = new;
        string weatherPath = CURRENT_CITY_WEATHER_END_POINT;
        string urlParams = QUERY + city + APP_ID + self.apiKey;

        weatherPath=weatherPath+"?"+urlParams;

        var httpResponse = self.weatherClient->get(weatherPath);
        if(httpResponse is http:Response){
            int statusCode = httpResponse.statusCode;
            var jsonPayload = httpResponse.getJsonPayload();
            if (jsonPayload is json) {
                if(statusCode==http:STATUS_OK){
                    return convertToWeatherDataResponse(jsonPayload);
                }else{
                    return setResponseError(jsonPayload);
                }
            }else{
                return error(WEATHER_ERROR_CODE,message="Error occured while accessing the JSON payload of the response");
            }
        }else{
                return error(WEATHER_ERROR_CODE,message="Error occured while invoking the REST API");
        }
    }
} 

public type WeatherConfiguration record {
    string apiKey;
};

