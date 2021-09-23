public with sharing class TerritoryAssignment {
    Public Static void AssignNewOwner(list<account> accList){
        System.debug('AssignNewOwner method:'+accList);
        set<id> accId =  new set<Id>();
        list<account> accUpdateList = new list<Account>();
        list<contact> conUpdateList = new list<contact>();
        list<opportunity> OppUpdateList = new list<opportunity>();
        List<sObject> UpdateList = new List<sObject>();
        //create map of ZipCode and OwnerId 
        map<string,List<string>> mapZipCodetoOwnerid = getTerritories();
         System.debug('mapZipCodetoOwnerid'+mapZipCodetoOwnerid);
        for(account a: accList){
               accId.add(a.Id); 
        }
        for(Account acc:[select id,ownerId,BillingPostalCode, (select id,OwnerId from contacts),(select id,OwnerId from Opportunities) from Account where Id in:accId]){
                string oId =  getRandomOwner(mapZipCodetoOwnerid,acc.BillingPostalCode);
                if(oId!='' && oId!=null){
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

    private static map<string, List<String>> getTerritories(){
        map<string, List<String>> returnList  = new map<string, List<String>>();
        for(Territory__c t: [select Id,Zip_Code__c,ownerId from Territory__c]){
            if(!returnList.isEmpty()){
                if(!returnList.containsKey(t.Zip_Code__c)){
                    returnList.put(t.Zip_Code__c,new List<string>{t.ownerId});
                }else{
                    returnList.get(t.Zip_Code__c).add(t.ownerId);
                }
            }else{
                returnList.put(t.Zip_Code__c,new List<string>{t.ownerId});
            }
    }
    if(!returnList.isEmpty())
    {
        return returnList;
    }else return null;
    }

   private static string getRandomOwner(map<string,List<string>> mapZipCodetoOwnerid,string zipCode)
   { 
    List<String> owners = new List<string>();
       if(mapZipCodetoOwnerid.containsKey(zipcode)){
        owners= mapZipCodetoOwnerid.get(zipCode);
    }else {return null;}
        Double randomNumber = Math.random(); 
        Integer arrayLength = owners.size(); 
        Integer randomIndex = (randomNumber *(arrayLength-1)).intValue(); 
        return owners[randomIndex];
   } 
}
