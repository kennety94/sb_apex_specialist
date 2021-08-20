@isTest
public with sharing class WarehouseSyncScheduleTest {
    
    @IsTest
    static void testWarehouseSyncSchedule(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        Test.startTest();
        String jobID = System.schedule('WarehouseSyncScheduleTest', '0 0 1 * * ?', new WarehouseSyncSchedule());
        Test.stopTest();

        System.assertEquals(1, [SELECT count() FROM CronTrigger WHERE CronJobDetail.Name = 'WarehouseSyncScheduleTest']);
    }
}