public with sharing class CTPersonController {

    public static String getToken(String mobile) {
        Blob targetBlob = Blob.valueOf(mobile);
        Blob hash = Crypto.generateDigest('MD5',targetBlob);
        
        //Get the string value of blob
        return EncodingUtil.base64Encode(hash);
        
    }

    public static List<Person__c> getRecentHealthChanges(){

        List<Person__c> persons = [SELECT Id, Health_Status__c, Mobile__c,
                        Name, Status_Update_Date__c, Token__c, OwnerId 
                        FROM Person__c ORDER BY Status_Update_Date__c 
                        DESC NULLS LAST LIMIT 100];
        return persons;

    }

    public static List<Person__c> searchPeople(String searchTerm){

        searchTerm = searchTerm + '%';
        List<Person__c> persons = [SELECT Id, Health_Status__c, Mobile__c,
                        Name, Status_Update_Date__c, Token__c, OwnerId 
                        FROM Person__c WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm
                        OR Token__c LIKE :searchTerm 
                        ORDER BY Status_Update_Date__c DESC];

        return persons;
    }

    public static Person__C getPersonById(String personId){

        List<Person__c> person = [SELECT Id, Health_Status__c, Mobile__c,
                    Name, Status_Update_Date__c, Token__c, OwnerId 
                    FROM Person__c WHERE Id= :personId LIMIT 1];
        if (person != null) {
            return person[0];
        } 
        return null;
    }
}
