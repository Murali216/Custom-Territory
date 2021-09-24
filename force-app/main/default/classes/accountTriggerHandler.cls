public with sharing class accountTriggerHandler {
    public static void afterInsertHandler(list<Account> newList, map<id,Account> newMap) {
        List<account> accPostalCodeChanged = new List<Account>();
        for(account a: newList){
            if(a.BillingPostalCode!=null && a.BillingPostalCode!=''){
                accPostalCodeChanged.add(a);
            }
        }
        TerritoryAssignment.AssignNewOwner(accPostalCodeChanged,null);
   
    }

    public static void afterUpdateHandler(list<Account> newList, map<id,Account> newMap, list<Account> oldList, map<id,Account> oldMap) {
        List<account> accPostalCodeUpdated = new List<Account>();
        for(account a: newList){
            if(a.BillingPostalCode!=oldMap.get(a.Id).BillingPostalCode){
                accPostalCodeUpdated.add(a);
            }
        }
        TerritoryAssignment.AssignNewOwner(accPostalCodeUpdated,oldMap);


    } 
    }


