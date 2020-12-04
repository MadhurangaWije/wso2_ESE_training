import ballerina/io;
import ballerina/test;
import ballerina/java.jdbc;
import ballerina/sql;
import ballerina/log;

Customer testCustomer = {
    customerId:10101,
    name:"Kamal",
    age:32,
    location:"Colombo 03"
};

CustomerApiDBConfig config={
    url:"<JDBC url /+ DB name>",
    username:"<your database username>",
    password:"<your database password>"
};

jdbc:Client dbClientTest = check new(config.url,config.username, config.password);

@test:Config{}
public function testAddCustomer(){
    var result = dbClientTest->execute(`INSERT INTO Customer(name, age, location) VALUES(${<@untainted>testCustomer.name},${<@untainted>testCustomer.age},${<@untainted>testCustomer?.location})`);

    if result is sql:ExecutionResult{
        io:println("Customer "+<@untainted> testCustomer.name+" is added successfully!"); 
    }else{
        log:printError(result.toString());
        test:assertFail(result.toString());
    }
}

@test:Config{}
public function testUpdateCustomer(){
    var result = dbClientTest->execute(`UPDATE Customer SET name=${<@untainted>testCustomer.name}, age=${<@untainted>testCustomer.age}, location=${<@untainted>testCustomer?.location} WHERE customerId=${<@untainted>testCustomer?.customerId}`);

    if result is sql:ExecutionResult{
        io:println("Customer "+<@untainted> testCustomer.name+" updated successfully!"); 
    }else{
        log:printError(result.toString());
        test:assertFail(result.toString());
    }
}

@test:Config{}
public function testDeleteCustomer(){
    var result = dbClientTest->execute(`DELETE FROM Customer WHERE customerId=${<@untainted>testCustomer?.customerId}`);

    if result is sql:ExecutionResult{
        io:println("Customer "+<@untainted> testCustomer.name+" deleted successfully!"); 
    }else{
        log:printError(result.toString());
        test:assertFail(result.toString());
    }
}