trigger MaintenanceRequestTrigger on Case (after update) {
    if(Trigger.isAfter){
        MaintenanceRequestHelper.handleAfterUpdate(Trigger.new);
    }
}