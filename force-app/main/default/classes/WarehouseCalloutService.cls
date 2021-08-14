public with sharing class WarehouseCalloutService implements Queueable {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    public void execute(QueueableContext ctx) {

        List<WarehouseJSON> results = getEquipmentWarehouseItems();
        List<Product2> equipments = new List<Product2>();

        for (WarehouseJSON i : results) {
            Product2 product = new Product2();
            product.Name = i.name;
            product.Replacement_Part__c = i.replacement;
            product.Cost__c = i.cost;
            product.Lifespan_Months__c = i.lifespan;
            product.Maintenance_Cycle__c = i.maintenanceperiod;
            product.Warehouse_SKU__c = i.sku;
            product.ExternalId = i.sku;

            equipments.add(product);
        }

        Database.upsert(equipments);
    }

    public static List<WarehouseJSON> getEquipmentWarehouseItems() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(WAREHOUSE_URL);
        
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200) {
            List<WarehouseJSON> results = WarehouseJSON.parse(res.getBody());
            return results;
        }
        return null;
    }
    
}