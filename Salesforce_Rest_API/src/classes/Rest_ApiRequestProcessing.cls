/**
 * Created by 전일규 on 2024-01-03.
 */

global without sharing class Rest_ApiRequestProcessing {
    @AuraEnabled public String uri                      {get;set;}
    @AuraEnabled public String method                   {get;set;}
    @AuraEnabled public String interfaceId              {get;set;}
    @AuraEnabled public Map<String, Object> requestData {get;set;}
    @AuraEnabled public Map<String,String> header       {get;set;}
    @AuraEnabled public Datetime requestDate            {get;set;}

    public Rest_ApiRequestProcessing() {}

    public Rest_ApiRequestProcessing(RestRequest req) {
        System.debug('Rest_ApiRequestProcessing(param1) method ::: ');
        String requestBody = req.requestBody.toString();

        if(String.isNotEmpty(requestBody)) {
            System.debug('inner requestBody if');
            Map<String, Object> requestInfo = (Map<String, Object>)JSON.deserializeUntyped(requestBody);
            this.uri = req.requestURI;
            this.method = req.httpMethod;
            this.header = req.headers;
            this.requestData = (Map<String, Object>) requestInfo.get('request');
            System.debug('this.requestData :::  ' + this.requestData);
            this.interfaceId = String.valueOf(requestInfo.get('interfaceId'));
        }
        this.requestDate = System.now();
    }
}