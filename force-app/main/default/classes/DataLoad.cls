public class DataLoad {
    
    public static Vehicle__c createVehicle(){
        return new Vehicle__c(Name = 'Vehicle test');
    }
    
    public static Product2 createEquipment(String equipName){
        return new Product2(Name = equipName,
                            Lifespan_Months__c = 10,
                            Maintenance_Cycle__c = 10,
                            Replacement_Part__c = true);
    }
    
    public static Case createMaintenanceRequest(String subject, String vehicleId){
        return new Case(Type = 'Repair', 
                        Subject = subject,
                        Status = 'New',
                        //Equipment__c = equipment.Id,
                        Vehicle__c = vehicleId);
    }
    
    public static Equipment_Maintenance_Item__c createEquipMaintenItem(String reqId, String equipId){
        return new Equipment_Maintenance_Item__c(
        	Maintenance_Request__c = reqId,
            Equipment__c = equipId
        );
    }

}