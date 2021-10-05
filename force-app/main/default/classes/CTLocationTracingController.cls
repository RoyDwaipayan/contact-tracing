public with sharing class CTLocationTracingController {
    public static List<Location_Tracing__c> getVisitors(String locationId) {
         List<Location_Tracing__c> tracings = [SELECT Id, Person__r.Health_status__c, Person__r.Token__c, Person__c, Location__c, Visit_Date__c 
                  FROM Location_Tracing__c WHERE Id= :locationId
                  ORDER BY Visit_Date__c DESC];
        return tracings;
    }

    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds){
        List<Location_Tracing__c> tracings = [SELECT Id, Person__c, Location__c
                    FROM Location_Tracing__c WHERE Person__c IN :personIds
                     AND Visit_Date__c > LAST_N_DAYS:10];
        return tracings;
    }

    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        List<Location_Tracing__c> tracings = [SELECT Id, Person__c, Location__c
                    FROM Location_Tracing__c WHERE Location__c IN :locationIds
                     AND Person__r.Health_status__c = 'Green'
                     AND Visit_Date__c > LAST_N_DAYS:10];
        return tracings;
    }

    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> newLocationTraces){
       /*
       ***This commented code uses nested for loops***
       List<Location_Tracing__c> allTracings = [SELECT Id, Person__c, Location__c, Visit_date__c
                        FROM Location_Tracing__c];
        
        List<Location_Tracing__c> duplicateTraces = new List<Location_Tracing__c>();
        for(Location_Tracing__c trace : locationTraces){
            for(Location_Tracing__c check : allTracings){
                if(trace.Location__c == check.Location__c && trace.Person__c == check.Person__c && trace.Visit_Date__c == check.Visit_Date__c){
                    duplicateTraces.add(trace);
                    break;
                }
            }
        } */

        Set<Id> personId = new Set<Id>();
        Set<Id> locationId = new Set<Id>();
        List<Location_Tracing__c> existingLocationTraces = [SELECT Id, Person__c, Location__c 
                                                    FROM Location_Tracing__c];

        for(Location_Tracing__c trace : newLocationTraces){
            personId.add(trace.Person__c);
            locationId.add(trace.Location__c);
        }
        //Create map of all existing locaton and person Ids
        Map<Id ,Set<Id>> mapOfLocationTracing = new Map<Id, Set<Id>>();
        if(existingLocationTraces != null && existingLocationTraces.size()>0){
            for(Location_Tracing__c trace : existingLocationTraces){
                if(!mapOfLocationTracing.containsKey(trace.Location__c)){
                    mapOfLocationTracing.put(trace.Location__c, new Set<Id>());
                }
                mapOfLocationTracing.get(trace.Location__c).add(trace.Person__c);

            }
    }
        List<Location_Tracing__c> duplicateTraces = new List<Location_Tracing__c>();

        for(Location_Tracing__c trace : newLocationTraces){
            if(mapOfLocationTracing.containsKey(trace.Location__c) && 
            mapOfLocationTracing.get(trace.Location__c).contains(trace.Person__c)){
                duplicateTraces.add(trace);
            }
        }

        return duplicateTraces;

    }
}
