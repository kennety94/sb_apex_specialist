@isTest
public with sharing class MaintenanceRequestHelperTest {
    
    @TestSetup
    static void setup() {
        //insert vehicle, case, equipement maintenance item and product2
        Vehicle__c vehicle = DataLoad.createVehicle();
        insert vehicle;

        Product2 equipment = DataLoad.createEquipment('Equip test 1');
        equipment.Maintenance_Cycle__c = 365;
        Product2 equipment2 = DataLoad.createEquipment('Equip test 2');
        equipment2.Maintenance_Cycle__c = 1;
        List<Product2> equips = new List<Product2>{equipment, equipment2};
        insert equips;

        List<Case> cases = new List<Case>();
        for(integer i = 0; i < 300 ; i++) {
            Case c = DataLoad.createMaintenanceRequest('Test ' + i, vehicle.Id);
            cases.add(c);
        }
        
        insert cases;
        
        List<Equipment_Maintenance_Item__c> maintItem = new List<Equipment_Maintenance_Item__c>();
        List<Case> requests = [SELECT Id, Subject from Case WHERE Subject LIKE 'Test%'];
        for(Case request : requests) {
            Equipment_Maintenance_Item__c item;
            if(request.Subject == 'Test 1') {
                item = DataLoad.createEquipMaintenItem(request.Id, equipment2.Id);
            } else {
                item = DataLoad.createEquipMaintenItem(request.Id, equipment.Id);
            }
            
            maintItem.add(item);
        }
        
        insert maintItem;

    }

    @IsTest
    static void testAutomation(){
        List<Case> lstCurrentRequests = [SELECT Id FROM Case WHERE Subject LIKE 'Test%'];
        List<Case> lstRequestsToUpdate = new List<Case>();
        for(Case request : lstCurrentRequests){
            request.Status = 'Closed';
            lstRequestsToUpdate.add(request);
        }
        
        Test.startTest();
        update lstRequestsToUpdate;
        Test.stopTest();
        
        System.assertEquals(300, [SELECT count() FROM Case WHERE Type = 'Routine Maintenance' and Date_Reported__c = :Date.today()]);
    }

}