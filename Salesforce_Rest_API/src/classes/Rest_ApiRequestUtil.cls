/**
 * Created by 전일규 on 2024-01-03.
 */

global without sharing class Rest_ApiRequestUtil {

    public static Rest_ApiResponseProcessing doRequest(Rest_ApiRequestProcessing request) {
        System.debug('doRequest method::: ');
        Rest_ApiResponseProcessing response = null;
        try {
            ApiInfo__c apiInfo = getApiInfo(request);

            Rest_ApiDoProcess apiDoProcess = (Rest_ApiDoProcess) Type.forName(apiInfo.Name).newInstance();
            response = (Rest_ApiResponseProcessing)apiDoProcess.doProcess(request, response);
            System.debug('doReques method response data ::::::: ' + response.toString());
        }catch(Exception e) {
            System.debug('doRequest method Exception \n message : ' + e.getMessage());
            system.debug('Line : ' + e.getLineNumber());
        }
        return response;
    }

    private static ApiInfo__c getApiInfo(Rest_ApiRequestProcessing requestData) {
        System.debug('getApiInfo method :::');
        ApiInfo__c apiInfo = null;
        try {
            apiInfo = (ApiInfo__c) [
                    SELECT Name, InterfaceId__c
                    FROM ApiInfo__c
                    WHERE InterfaceId__c = :requestData.interfaceId
                    AND Active__c = true
            ].get(0);
        }catch (QueryException queryException) {
            System.debug('getApiInfo method queryException \n message : ' + queryException.getMessage());
            System.debug('Line : ' + queryException.getLineNumber());
        }
            return apiInfo;
    }
}