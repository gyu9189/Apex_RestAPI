/**
 * Created by 전일규 on 2024-01-02.
 */

@RestResource(urlMapping='/restapi/*')
global without sharing class Rest_ApiGateWay {

    @HttpPut
    global static void doPut() {
        System.debug('inbound ::: doPut method');
        try{
            commonRestApi();
        } catch (CalloutException e) {
            System.debug('ErrorMessage : ' + e.getMessage());
        }
    }

    @HttpPatch
    global static void doPatch() {
        System.debug('inbound ::: doPatch method');
        try{
            commonRestApi();
        } catch (CalloutException e) {
            System.debug('ErrorMessage : ' + e.getMessage());
        }
    }

    @HttpGet
    global static void doGet() {
        System.debug('inbound ::: doGet method');
        try{
            commonRestApi();
        } catch (CalloutException e) {
            System.debug('ErrorMessage : ' + e.getMessage());
        }
    }

    @HttpPost
    global static void doPost() {
        System.debug('inbound ::: doPost method');
        try{
            commonRestApi();
        } catch (CalloutException e) {
            System.debug('ErrorMessage : ' + e.getMessage());
        }
    }

    @HttpDelete
    global static void doDelete() {
        System.debug('inbound ::: doDelete method');
        try{
            commonRestApi();
        } catch (CalloutException e) {
            System.debug('ErrorMessage : ' + e.getMessage());
        }
    }

    public static void commonRestApi() {
        System.debug('inner commonRestApi Method');
        try{
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;

            // request data가공
            Rest_ApiRequestProcessing requestData = new Rest_ApiRequestProcessing(req);
            System.debug('requestData :::  ' + requestData);

            // request doRequest
            Rest_ApiResponseProcessing responseData = Rest_ApiRequestUtil.doRequest(requestData);
            System.debug('commonRestApi method responseData :::  ' + responseData);

            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(JSON.serialize(responseData));
            system.debug('RestContext.response.responseBody :::  ' + res.responseBody.toString());
        }catch (Exception e) {
            System.debug('commonRestApi method error');
            System.debug('ErrorMessage : ' + e.getMessage());
        } finally {
            // Logging work to be added
        }
    }
}