public with sharing class MaintenanceRequestHelper {
    
    public static void handleAfterUpdate(List<Case> cases) {

        List<Case> newCases = new List<Case>();
        Map<String, Integer> lstDueDates = getDueDate(cases);
        Map<String, Case> mpCases = new Map<String, Case>();
        
        for (Case c : cases) {
            
            if(c.Status == 'closed') {
                if(c.Type == 'Repair' || c.Type == 'Routine Maintenance') {
                    Case newCase = new Case();
                    newCase.Vehicle__c = c.Vehicle__c;
                    newCase.Status = 'New';
                    newCase.Type = 'Routine Maintenance';
                    newCase.Subject = 'Routine Maintenance Subject';
                    newCase.Date_Reported__c = Date.today();
                    
                    if(lstDueDates.get(c.Id) != null) {
                        newCase.Date_Due__c = Date.today() + lstDueDates.get(c.Id);
                    } else {
                        newCase.Date_Due__c = Date.today();
                    }
                    
                    newCases.add(newCase);
                    mpCases.put(c.Id, newCase);
                }
            }
            
        }
        
        insert newCases;
        setEquipmentMaintenanceItemsToCase(mpCases);
    }

    private static Map<String, Integer> getDueDate(List<Case> cases){
        Map<String, Integer> mpDueDate = new Map<String, Integer>();
        Map<Id, Case> caseKeys = new Map<Id, Case>(cases);
        
        List<AggregateResult> aggResults =  [
            SELECT Maintenance_Request__r.Id caseId, MIN(Equipment__r.Maintenance_Cycle__c) cycleDays
            FROM Equipment_Maintenance_Item__c
            WHERE Maintenance_Request__r.Id in :caseKeys.keySet()
            GROUP BY Maintenance_Request__r.Id
        ];

        for(AggregateResult aggRes : aggResults){
            integer addDays = 0;
            if(aggRes.get('cycleDays') != null) {
                addDays += Integer.valueOf(aggRes.get('cycleDays'));
            }

            mpDueDate.put((String)aggRes.get('caseId'), addDays);
        }

        return mpDueDate;
    }

    private static void setEquipmentMaintenanceItemsToCase(Map<String, Case> cases) {
        List<Equipment_Maintenance_Item__c> manItems = [
            SELECT Id, Maintenance_Request__r.Id
            FROM Equipment_Maintenance_Item__c
            WHERE Maintenance_Request__r.Id in :cases.keySet()
        ];
        
        for(Equipment_Maintenance_Item__c emi : manItems){
            emi.Maintenance_Request__c = cases.get(emi.Maintenance_Request__c).Id;
        }
        
        update manItems;
    }
}