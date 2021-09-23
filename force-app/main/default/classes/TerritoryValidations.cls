public with sharing class TerritoryValidations {
        Public Static void redundantZipCodes(List<string> zipcodes,List<Territory__c> tList){
               map<string,Integer> zipCountMap = new map<string,Integer>(); 
             for(AggregateResult result: [select Zip_Code__c,Count(Id) from Territory__c where Zip_Code__c in:zipcodes group by Zip_Code__c]){
                 zipCountMap.put((string) result.get('Zip_Code__c'), (Integer)result.get('expr0'));
             }
            for(Territory__c t: tList){
                    if(zipCountMap.get(t.Zip_Code__c)>=3){
                        t.addError('Only 3 records per zip code can be created');
                    }
            }
            
        }

    }

