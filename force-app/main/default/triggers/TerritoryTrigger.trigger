trigger TerritoryTrigger on Territory__c (before insert, before Update) {

           if(trigger.isInsert && trigger.isbefore){
          territoryTriggerHandler.beforeInsertHandler(trigger.new, trigger.newmap);      
        } 
        if(trigger.isUpdate && trigger.isbefore){
            territoryTriggerHandler.beforeUpdateHandler(trigger.new, trigger.newmap, trigger.old, trigger.oldmap);  
        } 
    
    

}