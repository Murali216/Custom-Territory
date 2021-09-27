public with sharing class territoryTriggerHandler {

    public static void beforeInsertHandler(list<Territory__c> newList, map<id,territory__c> newMap) {
        List<string> tList = new List<string>();
        List<Territory__c> trigList =  new List<territory__c>();
        for(Territory__c t:newList)
        {
                if(t.Zip_Code__c!=null && t.Zip_Code__c!=''){
                tList.add(t.Zip_Code__c);
                trigList.add(t);
            }
            If(!trigList.isEmpty()){
            TerritoryValidations.redundantZipCodes(tList,trigList);
            }
        }
        
    }

    public static void beforeUpdateHandler(list<territory__c> newList, map<id,territory__c> newMap, list<territory__c> oldList, map<id,territory__c> oldMap){
        List<string> tList = new List<string>();
        List<Territory__c> trigList =  new List<territory__c>();
        for(Territory__c t:newList)
                {
            if(t.Zip_Code__c!= oldMap.get(t.Id).Zip_Code__c){
                tList.add(t.Zip_Code__c);
                trigList.add(t);
            }
        }
        If(!trigList.isEmpty()){
        TerritoryValidations.redundantZipCodes(tList,trigList);
        }
    }

    public static void afterUpdateHandler(list<territory__c> newList, map<id,territory__c> newMap, list<territory__c> oldList, map<id,territory__c> oldMap){
        List<Territory__c> trigList =  new List<territory__c>();
        for(Territory__c t:newList){
        if(t.OwnerId!= oldMap.get(t.Id).OwnerId){
            trigList.add(t);
    }
    }
    System.debug('After Update Handler'+trigList);
    If(!trigList.isEmpty()){
    id jobID = system.EnqueueJob(new UpdateOwnersQueueable(trigList));
}
}
}
