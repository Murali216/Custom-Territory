trigger TerritoryTrigger on Territory__c (before insert, before Update, after Update) {

           if(trigger.isInsert && trigger.isbefore){
          territoryTriggerHandler.beforeInsertHandler(trigger.new, trigger.newmap);      
        } 
        if(trigger.isUpdate && trigger.isbefore){
            territoryTriggerHandler.beforeUpdateHandler(trigger.new, trigger.newmap, trigger.old, trigger.oldmap);  
        } 
        if(trigger.isUpdate && trigger.isAfter){
            territoryTriggerHandler.AfterUpdateHandler(trigger.new, trigger.newmap, trigger.old, trigger.oldmap);  
        } 
    
    

}