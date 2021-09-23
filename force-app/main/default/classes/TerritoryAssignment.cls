public with sharing class TerritoryAssignment {
    Public Static void AssignNewOwner(list<account> accList){
        System.debug('AssignNewOwner method:'+accList);
        set<id> accId =  new set<Id>();
        list<account> accUpdateList = new list<Account>();
        list<contact> conUpdateList = new list<contact>();
        list<opportunity> OppUpdateList = new list<opportunity>();
        List<sObject> UpdateList = new List<sObject>();
        //create map of ZipCode and OwnerId 
        map<string,string> mapZipCodetoOwnerid = new map<string,string>();
        for(Territory__c t: [select Id,Zip_Code__c,ownerId from Territory__c]){
                if(!mapZipCodetoOwnerid.isEmpty()){
                    if(!mapZipCodetoOwnerid.containsKey(t.Zip_Code__c)){
                        mapZipCodetoOwnerid.put(t.Zip_Code__c,t.ownerId);
                    }
                }else{
                    mapZipCodetoOwnerid.put(t.Zip_Code__c,t.ownerId);
                }
        }
        System.debug('mapZipCodetoOwnerid'+mapZipCodetoOwnerid);
        for(account a: accList){
               accId.add(a.Id); 
        }
        for(Account acc:[select id,ownerId,BillingPostalCode, (select id,OwnerId from contacts),(select id,OwnerId from Opportunities) from Account where Id in:accId]){
                string oId =  mapZipCodetoOwnerid.get(acc.BillingPostalCode);
                acc.ownerId = oId;
                UpdateList.add(acc);

                for(contact c:acc.contacts){
                        c.ownerId = oId;
                        // conUpdateList.add(c);
                        UpdateList.add(c);
                }

                for(opportunity o:acc.Opportunities){
                    o.ownerId = oId;
                    // OppUpdateList.add(o);
                    UpdateList.add(o);
            }
        }
        // If(accUpdateList!=null && !accUpdateList.isEmpty())
        // update accUpdateList;
        // If(conUpdateList!=null && !conUpdateList.isEmpty())
        // update conUpdateList;
        // If(OppUpdateList!=null && !OppUpdateList.isEmpty())
        // update OppUpdateList;
        If(UpdateList!=null && !UpdateList.isEmpty()){
            update UpdateList;
        }


    }
}
