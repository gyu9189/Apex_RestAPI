/**
 * @description       : 
 * @author            : ilgyu.jeon@dkbmc.com
 * @group             : 
 * @last modified on  : 10-02-2023
 * @last modified by  : ilgyu.jeon@dkbmc.com
**/

public without sharing class ContactUsRequestController {
    
    @AuraEnabled(cacheable=true)
    public static List<String> getCategoryPickList() {
        List<String> pickListValues = new List<String>();
        Schema.DescribeFieldResult fr = Contact_Us__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> values = fr.getPicklistValues();
		for( Schema.PicklistEntry pickVal : values){
			pickListValues.add(pickVal.getLabel());
		}
        return pickListValues;
    }

    @AuraEnabled
    public static String doSubmit(Map<String, Object> paramMap) {
        try {
            Contact_Us__c conUs = new Contact_Us__c();
            conUs.Account__c = string.valueOf(System.Label.ContactUsAccount);
            conUs.Status__c = 'Received';
            conUs.Category__c = string.valueOf(paramMap.get('category'));
            conUs.Subject__c = string.valueOf(paramMap.get('subject'));
            conUs.Description__c = string.valueOf(paramMap.get('description'));
            conUs.Requestor__c = string.valueOf(paramMap.get('email'));
            if(paramMap.get('emailItem') != null) conUs.Collaborators__c = setCollaborators((List<Object>) paramMap.get('emailItem'));
            insert conUs;

            if(paramMap.get('files') != null) setFiles((List<Object>) paramMap.get('files'), conUs.Id);
            
        } catch (Exception e) {
            return 'Line : ' + e.getLineNumber() + ' Message : ' + e.getMessage();
        }
        return 'Succsee';
    }

    private static String setCollaborators(List<Object> collaborators) {
        String addEmail = '';

        for(Object collaborator : collaborators) {
            addEmail += string.valueOf(collaborator) + ';';
            if(!collaborator.equals(collaborators.get(collaborators.size()-1))) addEmail += ' ';
        }
        return addEmail;
    }

    private static void setFiles(List<Object> files, String LinkedEntityId) {
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        for(Object file : files) {
            Map<Object, Object> tempMap = (Map<Object, Object>)file;
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.ContentDocumentId = string.valueOf(tempMap.get('documentId'));
            cdl.LinkedEntityId = LinkedEntityId;
            cdl.ShareType = 'V';

            cdlList.add(cdl);
        }
        insert cdlList;
    }
}