public class UpdateOwnersQueueable implements Queueable {
    private List<Territory__c> ters;
    public UpdateOwnersQueueable(List<Territory__c> ters){
        this.ters=ters;
    }
    public void execute(System.QueueableContext context){
        List<account> UpdateList = new List<Account>();
        List<Assignment_History__C> insertList = new List<Assignment_History__C>();
        map<String, Territory__c> mapZipCodetoTerritory  = new map<string,Territory__c>();

        //Attach transaction Finalizer
        AssignmentHistoryFinalizer f =  new AssignmentHistoryFinalizer();
        system.attachFinalizer(f);


        for(Territory__c t: ters){
            if(!mapZipCodetoTerritory.isEmpty()){
                if(!mapZipCodetoTerritory.containsKey(t.Zip_Code__c)){
                    mapZipCodetoTerritory.put(t.Zip_Code__c,t);
                }
            }else{
                mapZipCodetoTerritory.put(t.Zip_Code__c,t);
            }
        }
        System.debug('In Queueable'+mapZipCodetoTerritory);
          for(account acc: [select id,BillingPostalCode,OwnerId,Territory__c from account where BillingPostalCode in : mapZipCodetoTerritory.keySet()])  
          {
            Assignment_History__C aHistory = new Assignment_History__C();
            aHistory.Previous_Owner__c = acc?.ownerId;
            aHistory.Previous_Territory__c = acc?.Territory__c;

              acc.OwnerId = mapZipCodetoTerritory.get(acc.BillingPostalCode).OwnerId;
              acc.Territory__c = mapZipCodetoTerritory.get(acc.BillingPostalCode).Id;
              UpdateList.add(acc);

             aHistory.New_Territory__c = mapZipCodetoTerritory.get(acc.BillingPostalCode).Id;
             aHistory.new_Owner__c = mapZipCodetoTerritory.get(acc.BillingPostalCode).OwnerId;
             aHistory.Changed_By__c =UserInfo.getUserId();
             aHistory.Account__c = acc.Id;
             f.createInsertList(aHistory);
          }
          If(UpdateList!=null && !UpdateList.isEmpty()){
            update UpdateList;
        }
        //     If(insertList!=null && !insertList.isEmpty()){
        //     insert insertList;
        // }
    }
}
