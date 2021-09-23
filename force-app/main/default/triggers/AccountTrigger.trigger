trigger AccountTrigger on Account (After insert, After Update) {

    if(trigger.isInsert && trigger.isAfter){
      accountTriggerHandler.afterInsertHandler(trigger.new, trigger.newmap);      
    } 
    if(trigger.isUpdate && trigger.isAfter){
        accountTriggerHandler.afterUpdateHandler(trigger.new, trigger.newmap, trigger.old, trigger.oldmap);  
    } 

}