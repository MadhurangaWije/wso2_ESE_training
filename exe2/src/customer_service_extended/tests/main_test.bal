import ballerina/http;
import ballerina/test;
import ballerina/log;

http:Client httpClientEndpoint = new ("http://localhost:8080");

Customer testCustomer ={
    customerId:101010,
    name:"Nimal Silva",
    age:12,
    location:"Maharagama"
};


@test:Config{}
public function testAddCustomer(){
    http:Request req = new;

    json jsonRequest = {name:testCustomer.name, age:testCustomer.age, location:testCustomer?.location};

    req.setJsonPayload(jsonRequest);
    var res = httpClientEndpoint -> post("/customer", req);
    if(res is http:Response){
        var jsonResponse = res.getJsonPayload();
        log:printDebug("Status Code : "+ res.statusCode.toString()+ " Message : "+ jsonResponse.toString());
    }
    else{
        log:printError("Test Request Failed");
        test:assertFail(res.toString());
    }
}

@test:Config{
    dependsOn:["testAddCustomer"]
}
public function testGetCustomer(){
    var res = httpClientEndpoint -> get("/customer/" + testCustomer?.customerId.toString());

    if(res is http:Response){
        var jsonResponse = res.getJsonPayload();
        if(jsonResponse is json){
            log:printDebug("Status Code : "+ res.statusCode.toString()+ " Message : "+ jsonResponse.toString());
        }
        else{
            log:printDebug("Status Code : "+ res.statusCode.toString()+ " Message : Malformed payload recieved");
        }
    }
    else{
        log:printError("Test Request Failed");
        test:assertFail(res.toString());
    }
}


@test:Config{
    dependsOn:["testAddCustomer"]
}
public function testUpdateCustomer(){
    http:Request req = new;

    json jsonRequest = {"name" :"Updated Customer Name", age:32, location:"Dehiwala"};

    var res = httpClientEndpoint -> put("/customer/"+testCustomer?.customerId.toString(),req);

    if(res is http:Response){
        var jsonResponse = res.getJsonPayload();
        if(jsonResponse is json){
            log:printDebug("Status Code : "+ res.statusCode.toString()+ " Message : "+ jsonResponse.toString());
        }else{
            log:printDebug("Status Code : "+ res.statusCode.toString()+ " Message : Malformed payload recieved");
        }
    }
    else{
        log:printError("Test Request Failed");
        test:assertFail(res.toString());
    }
}
