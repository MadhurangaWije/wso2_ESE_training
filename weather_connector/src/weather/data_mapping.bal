function convertToWeatherDataResponse(json responseJson) returns WeatherDataResponse {
    WeatherDataResponse weatherDataResponse = {};

    var mainWeatherData = responseJson.main;
    if(mainWeatherData is json){
        weatherDataResponse.main = convertToMainWeatherData(mainWeatherData);
    }

    return weatherDataResponse;
}

function convertToMainWeatherData(json mainWeatherDataJson)returns Main{
    Main mainWeatherData = {};

    var temp=mainWeatherDataJson.temp;
    if (temp is json) {
        mainWeatherData.temp= temp!=null? convertToDecimal(temp):0;
    }

    var feelsLike=mainWeatherDataJson.feels_like;
    if (feelsLike is json) {
        mainWeatherData.feels_like= temp!=null? convertToDecimal(feelsLike):0;
    }

    var tempMin=mainWeatherDataJson.temp_min;
    if (feelsLike is json) {
        mainWeatherData.temp_min= temp!=null? convertToDecimal(feelsLike):0;
    }

    var tempMax=mainWeatherDataJson.temp_max;
    if (tempMax is json) {
        mainWeatherData.temp_max= temp!=null? convertToDecimal(tempMax):0;
    }

    var pressure=mainWeatherDataJson.pressure;
    if (pressure is json) {
        mainWeatherData.pressure= temp!=null? convertToInt(pressure):0;
    }

    var humidity=mainWeatherDataJson.humidity;
    if (humidity is json) {
        mainWeatherData.humidity= temp!=null? convertToInt(humidity):0;
    }

    return mainWeatherData;
}

function convertToInt(json jsonVal) returns int {
    if (jsonVal is int) {
        return jsonVal;
    }
    panic error("Error occurred when converting " + jsonVal.toString() + " to int");
}

function convertToDecimal(json jsonVal) returns decimal {
    if (jsonVal is decimal) {
        return jsonVal;
    }
    panic error("Error occurred when converting " + jsonVal.toString() + " to decimal");
}