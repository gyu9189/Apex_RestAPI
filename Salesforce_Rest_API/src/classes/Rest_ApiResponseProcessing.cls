/**
 * Created by 전일규 on 2024-01-03.
 */

global without sharing class Rest_ApiResponseProcessing {
    @AuraEnabled public Object response         {get;set;}
    @AuraEnabled public String code             {get;set;}
    @AuraEnabled public String status           {get;set;}
    @AuraEnabled public Datetime responseDate   {get;set;}

    public Rest_ApiResponseProcessing() {
        this.code = '0';
        this.status = 'success';
        this.responseDate = System.now();
    }
}
