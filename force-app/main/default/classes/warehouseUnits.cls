global with sharing class warehouseUnits{
public warehouseUnits(ApexPages.StandardSetController controller) { }
 
@RemoteAction

global static List<Warehouse__c> findNearbyWarehouses(String lat, String lon) {

List<Warehouse__c> results = new List<Warehouse__c>();
    String queryString =
'SELECT Id, Name, Location__Longitude__s, Location__Latitude__s, ' +
'Street_Address__c, Phone__c, City__c ' +
'FROM Warehouse__c ' +
'WHERE DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') < 20 ' +
'ORDER BY DISTANCE(Location__c, GEOLOCATION('+lat+','+lon+'), \'mi\') ' +
'LIMIT 10';
results = database.Query(queryString);
    system.debug(queryString);


return results;
}

 }