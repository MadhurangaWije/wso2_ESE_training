import ballerina/http;
import ballerina/log;

listener http:Listener httpListener = new(8080);

map<json> customers={};

@http:ServiceConfig {
    basePath:"/"
}
service CustomerService on httpListener {

    @http:ResourceConfig {
        path:"/customer",
        methods: ["POST"]
    }
    resource function addNewCustomer(http:Caller caller, http:Request request) {
        
        json|error requestBody = request.getJsonPayload();        
        
        http:Response res=new;

        if (requestBody is error) {
            log:printError("Error retrieving request body!");
            res.statusCode=400;
            res.setJsonPayload("Error retrieving request body");
        }else{
            var customerId = requestBody.customerId;
            if (customerId == null) {
                log:printError("Malformed request body!");
                res.statusCode=400;
                res.setJsonPayload("Malformed request body");
            }else{
                customers[customerId.toString()]=<@untainted>requestBody;
                res.statusCode=201;
                res.setJsonPayload({status:"Success", customerId:<@untainted>customerId.toString()});
            }
        }

        var result = caller->respond(res);
        if (result is error) {
            log:printError("Error sending response`");
        }
    }

    @http:ResourceConfig {
        path:"/customer/{customerId}",
        methods: ["GET"]
    }
    resource function getCustomer(http:Caller caller, http:Request request, string customerId) {
        http:Response res=new;

        if (customerId.trim()=="") {
            res.statusCode=400;
            res.setJsonPayload("Invalid Customer ID");
            log:printError("Invalid customer ID");
        }else{
            json? customer = customers[customerId];
            if (customer is ()) {
                res.statusCode=404;
                res.setJsonPayload("No such customer exists");
                log:printError("No such customer exists");
            }else{
                res.statusCode=200;
                res.setJsonPayload(<@untainted><json>customer);
            }
        }

        var result=caller->respond(res);
        if (result is error) {
            log:printError("Error in sending the response!");
        }
    }

    @http:ResourceConfig {
        path:"/customer/{customerId}",
        methods: ["PUT"]
    }
    resource function updateCustomer(http:Caller caller, http:Request request, string customerId) {
        http:Response res=new;
        json|error requestPayload = request.getJsonPayload();
        if (requestPayload is error) {
            log:printError("Invalid payload");
            res.statusCode=400;
            res.setJsonPayload("Invalid payload");
        }else if (customerId.trim()=="") {
            res.statusCode=400;
            res.setJsonPayload("Invalid Customer ID");
            log:printError("Invalid customer ID");
        }else{
            customers[customerId]=<@untainted>requestPayload;
            res.statusCode=200;
            res.setJsonPayload("Customer Updated");
        }

        var result = caller->respond(res);
        if (result is error) {
            log:printError("Error in sending the response");
        }
    }
}
