public class AssignmentHistoryFinalizer implements finalizer{
    List<Assignment_History__c> insertList ;
    public AssignmentHistoryFinalizer() {
        insertList =  new List<Assignment_History__C>();
    }

    public void execute(FinalizerContext ctx){

        if (ctx.getResult() == ParentJobResult.SUCCESS){
            //create Assignment History records
            insert InsertList;

        }else{
            System.debug('Error in Processing: '+ctx.getException().getMessage());
        }

    }

    public void createInsertList(Assignment_History__C aH){
        InsertList.add(aH);
    }
}
