
function setResponseError(json reponseJson) returns error {
    json|error errors = check reponseJson.errors;
    error err;
    if (errors is json[]) {
        err = error(WEATHER_ERROR_CODE, message = errors[0].message.toString());
    } else if (errors is error) {
        err = errors;
    } else {
        err = error(WEATHER_ERROR_CODE);
    }
    return err;
}