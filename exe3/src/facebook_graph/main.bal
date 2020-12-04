import ballerina/http;
import ballerina/oauth2;
import ballerina/log;


oauth2:OutboundOAuth2Provider oauth2Provider = new({
    accessToken:"Your Facebook Graph API access token",
    refreshConfig:{
        clientId:"<Your client id>",
        clientSecret:"<Your client secret>",
        refreshToken:"",
        refreshUrl:"",
        clientConfig:{
            secureSocket:{
                trustStore:{
                    path:"/usr/lib/ballerina/distributions/ballerina-slp5/bre/security/ballerinaTruststore.p12",
                    password:"ballerina"
                }
            }
        }
    }
});

http:BearerAuthHandler oauth2Handler = new(oauth2Provider);

http:Client clientEP = new("https://graph.facebook.com/", {
        auth: {
            authHandler: oauth2Handler
        },
        secureSocket:{
                trustStore:{
                    path:"/usr/lib/ballerina/distributions/ballerina-slp5/bre/security/ballerinaTruststore.p12",
                    password:"ballerina"
                }
            }
    });

public function main() {
    var response = clientEP->get("/me");
    if (response is http:Response) {
        var result = response.getTextPayload();
        log:printInfo((result is error) ? "Failed to retrieve payload." : result);
    } else {
        log:printError("Failed to call the endpoint.", <error>response);
    }
}
