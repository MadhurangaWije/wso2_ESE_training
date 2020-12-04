import ballerina/io;
import ballerina/http;
import ballerina/log;
import ballerina/java.jdbc;

jdbc:Client dbClient =check new("jdbc:mysql://localhost:3306/<DB_NAME>","<Your database username>","<Your database password>");


type Customer record {
    int customerId?;
    string name;
    int age;
    string location?;
};

@http:ServiceConfig {
    basePath:"/customer"
}
service CustomerServiceExtended on new http:Listener(8080) {

    @http:ResourceConfig {
        path:"/",
        methods:["POST"],
        body:"entry"
    }
    resource function addCustomer(http:Caller caller, http:Request request, Customer entry) returns error? {

        _ = check dbClient->execute(`INSERT INTO Customer(name, age, location) VALUES(${<@untainted>entry.name},${<@untainted>entry.age},${<@untainted>entry?.location})`);

        check caller->ok();
    }

    @http:ResourceConfig {
        path:"/{customerId}",
        methods:["GET"]
    }
    resource function getCustomer(http:Caller caller, http:Request request, string customerId) returns @untainted error? {

        stream<record{}, error> rs = dbClient->query(`SELECT * FROM Customer WHERE customerId=${<@untainted>customerId}`);

        record {|record{} value;|}? entry = check rs.next();

        if (entry is record{|record{} value;|}) {
            io:println(entry.value);
            json|error r=entry.value.cloneWithType(json);
            if (r is error) {
                check caller->notFound();
            }else{
                check caller->ok(<@untainted>r);
            }
        }else{
            check caller->notFound();
        }

    }

    @http:ResourceConfig {
        path:"/",
        methods:["GET"]
    }
    resource function getAllCustomer(http:Caller caller, http:Request request) returns @untainted error? {

        stream<record{}, error> queryResult = dbClient->query(`SELECT * FROM Customer`);

        json[] customerList=[];

        error? e = queryResult.forEach(function(record{} customer){
            var cus = customer.cloneWithType(json);
            if (cus is error) {
                log:printError("Error in converting customer to json");
            }else{
                customerList.push(cus);
            }
        });

        if e is error{
            check caller->notFound();
        }else{
            http:Response res=new;
            res.statusCode=200;
            map<json[]> payload={
                "customers":customerList
            };

            json responsePayload = check payload.cloneWithType(json);

            check caller->respond(responsePayload);
        }

    }

    @http:ResourceConfig {
        path:"/{customerId}",
        methods:["PUT"],
        body:"customer"
    }
    resource function updateCustomer(http:Caller caller, http:Request request, string customerId, Customer customer) returns error?{
        
        _ = check dbClient->execute(`UPDATE Customer SET name=${<@untainted>customer.name}, age=${<@untainted>customer.age}, location=${<@untainted>customer?.location} WHERE customerId=${<@untainted>customerId}`);

        check caller->ok();
    }

    @http:ResourceConfig {
        path:"/{customerId}",
        methods:["DELETE"]
    }
    resource function deleteCustomer(http:Caller caller, http:Request request,string customerId) returns error?{  
        
        _ = check dbClient->execute(`DELETE FROM Customer WHERE customerId=${<@untainted>customerId}`);

        check caller->ok();
    }
}