global class WarehouseSyncSchedule implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        //String sch = '0 0 1 * * ?';
        WarehouseCalloutService job = new WarehouseCalloutService();
    }
}