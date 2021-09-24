public with sharing class TerritoryAssignment {
    Public Static void AssignNewOwner(list<account> accList, map<id,account> oldMap){
        System.debug('AssignNewOwner method:'+accList);
        set<id> accId =  new set<Id>();
        // list<account> accUpdateList = new list<Account>();
        // list<contact> conUpdateList = new list<contact>();
        // list<opportunity> OppUpdateList = new list<opportunity>();
        List<sObject> UpdateList = new List<sObject>();
        List<sObject> insertList = new List<sObject>();
        
        List<Assignment_History__C> HistoryList =  new List<Assignment_History__C>();
        //create map of ZipCode and OwnerId 
        map<string,List<Territory__c>> mapZipCodetoOwnerid = getTerritories();
        System.debug('mapZipCodetoOwnerid'+mapZipCodetoOwnerid);
        for(account a: accList){
               accId.add(a.Id); 
        }
        for(Account acc:[select id,ownerId,BillingPostalCode,Territory__c, (select id,OwnerId from contacts),(select id,OwnerId from Opportunities) from Account where Id in:accId]){
                string PreviousOwner =  acc?.OwnerId;
                string PreviousTerritory = acc?.Territory__c;
                Territory__c randTerritory =  getRandomTerritory(mapZipCodetoOwnerid,acc.BillingPostalCode);
                if(randTerritory!=null){
                acc.ownerId = randTerritory?.OwnerId;
                acc.Territory__c = randTerritory?.Id;
                UpdateList.add(acc);


                //Create Assignment History records
                 Assignment_History__C  aHistory =  new Assignment_History__C();
                 If(oldMap!=null){
                 aHistory.Previous_Owner__c = PreviousOwner;
                 aHistory.Previous_Territory__c =  PreviousTerritory;
                }
                aHistory.New_Territory__c = randTerritory.Id;
                aHistory.new_Owner__c = randTerritory.OwnerId;
                aHistory.Changed_By__c =UserInfo.getUserId() ;
                aHistory.Account__c = acc.Id;
                insertList.add(aHistory);
                insert insertList; 
                // End Assignment History Records


                for(contact c:acc.contacts){
                        c.ownerId = randTerritory?.OwnerId;
                        // conUpdateList.add(c);
                        UpdateList.add(c);
                }

                for(opportunity o:acc.Opportunities){
                    o.ownerId = randTerritory?.OwnerId;
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

    private static map<string, List<Territory__c>> getTerritories(){
        map<string, List<Territory__c>> returnList  = new map<string, List<Territory__c>>();
        for(Territory__c t: [select Id,Zip_Code__c,ownerId from Territory__c]){
            if(!returnList.isEmpty()){
                if(!returnList.containsKey(t.Zip_Code__c)){
                    returnList.put(t.Zip_Code__c,new List<Territory__c>{t});
                }else{
                    returnList.get(t.Zip_Code__c).add(t);
                }
            }else{
                returnList.put(t.Zip_Code__c,new List<Territory__c>{t});
            }
    }
    if(!returnList.isEmpty())
    {
        return returnList;
    }else return null;
    }

   private static Territory__c getRandomTerritory(map<string,List<Territory__c>> mapZipCodetoOwnerid,string zipCode)
   { 
    List<Territory__c> Territories = new List<Territory__c>();
       if(mapZipCodetoOwnerid.containsKey(zipcode)){
        Territories= mapZipCodetoOwnerid.get(zipCode);
    }else {return null;}
        Double randomNumber = Math.random(); 
        Integer arrayLength = Territories.size(); 
        Integer randomIndex = (randomNumber *(arrayLength-1)).intValue(); 
        return Territories[randomIndex];
   } 

 
}
