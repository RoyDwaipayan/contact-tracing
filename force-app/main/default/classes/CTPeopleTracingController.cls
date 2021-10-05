public with sharing class CTPeopleTracingController {
    public static List<People_Tracing__c> getTraces(String recordId) {
        List<People_Tracing__c> peopleTraces = [SELECT Id, Name, Contact_Date__c, Contact_Type__c, 
                                        Person_1__c, Person_1__r.Health_status__c, Person_1__r.Token__c,
                                        Person_2__c, Person_2__r.Health_status__c, Person_2__r.Token__c
                                        FROM People_Tracing__c
                                        WHERE Person_1__c = :recordId 
                                        OR Person_2__c = :recordId
                                        ORDER BY Contact_Date__c DESC];
        return peopleTraces;
    }

    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newPeopleTraces){
      
         Set<Id> personId_1 = new Set<Id>();
         Set<Id> personId_2 = new Set<Id>();
         List<People_Tracing__c> existingPeopleTraces = [SELECT Id, Person_1__c, Person_2__c 
                                                            FROM People_Tracing__c];
 
         for(People_Tracing__c trace : newPeopleTraces){
            personId_1.add(trace.Person_1__c);
            personId_2.add(trace.Person_2__c);
         }
         //Create map of all existing locaton and person Ids
         Map<Id ,Set<Id>> mapOfPeopleTracing = new Map<Id, Set<Id>>();
         if(existingPeopleTraces != null && existingPeopleTraces.size()>0){
             for(People_Tracing__c trace : existingPeopleTraces){
                 if(!mapOfPeopleTracing.containsKey(trace.Person_1__c)){
                     mapOfPeopleTracing.put(trace.Person_1__c, new Set<Id>());
                 }
                 mapOfPeopleTracing.get(trace.Person_1__c).add(trace.Person_2__c);
 
             }
     }
         List<People_Tracing__c> duplicateTraces = new List<People_Tracing__c>();
 
         for(People_Tracing__c trace : newPeopleTraces){
            if(mapOfPeopleTracing.containsKey(trace.Person_1__c) 
                    && mapOfPeopleTracing.get(trace.Person_1__c).contains(trace.Person_2__c)){
                        duplicateTraces.add(trace);
            } else if(mapOfPeopleTracing.containsKey(trace.Person_2__c) 
                    && mapOfPeopleTracing.get(trace.Person_2__c).contains(trace.Person_1__c)){
                        duplicateTraces.add(trace);
                    }
         }
 
         return duplicateTraces;
 
     }
}
