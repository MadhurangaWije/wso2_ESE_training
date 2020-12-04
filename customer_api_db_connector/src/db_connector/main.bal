import ballerina/sql;
import ballerina/java.jdbc;
import ballerina/log;

public type Customer record {
    int customerId?;
    string name;
    int age;
    string location?;
};

public type CustomerApiDBConfig record {
    string url;
    string username;
    string password;
};

public client class Client{
    private jdbc:Client jdbcClient;

    public function init(CustomerApiDBConfig config)returns error?{
        self.jdbcClient=check new(config.url,config.username,config.password);
    }

    public remote function getCustomer(string customerId)returns @untainted json|error{
        stream<record{}, error> rs = self.jdbcClient->query(`SELECT * FROM Customer WHERE customerId=${<@untainted>customerId}`);

        record {|record{} value;|}? entry = check rs.next();

        if (entry is record{|record{} value;|}) {
            json|error result=entry.value.cloneWithType(json);
            if (result is error) {
                log:printError(result.toString());
                return error("Error parsing the result to JSON");
            }else{
                return <@untainted>result;
            }
        }else{
            log:printError(entry.toString());
            return error("Error: customer not found");
        }
    }

    public remote function addCustomer(Customer customer) returns string|error?{
        var result = self.jdbcClient->execute(`INSERT INTO Customer(name, age, location) VALUES(${<@untainted>customer.name},${<@untainted>customer.age},${<@untainted>customer?.location})`);

        if result is sql:ExecutionResult{
            return "Customer "+<@untainted> customer.name+" is added successfully!"; 
        }else{
            log:printError(result.toString());
            return result.toString();
        }
    }

    public remote function updateCustomer(string customerId, Customer customer) returns string|error? {
        var result = self.jdbcClient->execute(`UPDATE Customer SET name=${<@untainted>customer.name}, age=${<@untainted>customer.age}, location=${<@untainted>customer?.location} WHERE customerId=${<@untainted>customerId}`);

        if result is sql:ExecutionResult{
            return "Customer "+<@untainted> customer.name+" updated successfully!"; 
        }else{
            log:printError(result.toString());
            return result.toString();
        }
    }

    public remote function deleteCustomer(string customerId)returns string|error?{
        var result = self.jdbcClient->execute(`DELETE FROM Customer WHERE customerId=${<@untainted>customerId}`);

        if result is sql:ExecutionResult{
            return "Customer ID:"+<@untainted> customerId+" deleted successfully!"; 
        }else{
            log:printError(result.toString());
            return result.toString();
        }
    }
}