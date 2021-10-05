public with sharing class CTLocationController {

    public static List<Location__c> getRecentHealthChanges(){

        List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c, 
                        Red_Score__c, Status_Update_Date__c, Status__c 
                        FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST
                        LIMIT 100];
        return locations;

    }

    public static List<Location__c> searchPeople(String searchTerm){

        searchTerm = searchTerm + '%';
        List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c, 
                        Red_Score__c, Status_Update_Date__c, Status__c 
                        FROM Location__c 
                        WHERE Name LIKE :searchTerm 
                        OR Address__c LIKE :searchTerm 
                        OR Pincode__c LIKE :searchTerm 
                        ORDER BY Status_Update_Date__c DESC];

        return locations;
    }

    public static Location__c getPersonById(String locationId){

        List<Location__c> location = [SELECT Id, Name, Address__c, Pincode__c, 
                    Red_Score__c, Status_Update_Date__c, Status__c 
                    FROM Location__c  WHERE Id= :locationId LIMIT 1];
        if (location != null) {
            return location[0];
        } 
        return null;
    }
}

