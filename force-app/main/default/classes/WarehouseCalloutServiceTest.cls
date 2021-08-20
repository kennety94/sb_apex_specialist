@IsTest
private class WarehouseCalloutServiceTest {
    @IsTest
    static void testWarehouseService(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        
        Test.startTest();
        WarehouseCalloutService.execute();
        Test.stopTest();
        
        //22 items
        System.assertEquals(22, [SELECT COUNT() FROM PRODUCT2]);
        
    }
}