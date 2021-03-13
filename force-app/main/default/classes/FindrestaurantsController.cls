public class FindrestaurantsController {

  // Public Properties
  Public map < String, decimal > mylocation {
    get;
    private set;
  }
  Public List < NearestRestaurants > NearestRestaurantsList {
    get;
    set;
  }

  /*Public FindrestaurantsController() {
    //Company__c Company = new Company__c();
 String CompanyId = ApexPages.currentPage().getParameters().get('id');
    //Company = [Select Id, Name, Location__latitude__s, Location__longitude__s From Company__c Where Id =: CompanyId];

    mylocation = new Map < String, Double > {
      'latitude' => Company.Location__latitude__s,
      'longitude' => Company.Location__longitude__s
    };

    String queryString =
      'SELECT Id, Name, Radius__c, Location__c, Location__longitude__s,' +
      'Location__latitude__s ' +
      'FROM Restaurant__c ' +
      'WHERE Id != \'' + Company.id + '\' AND DISTANCE(Location__c, GEOLOCATION(' + Company.Location__latitude__s +
      ',' + Company.Location__longitude__s + '), \'mi\') < ' +
      Company.Distance__c + ' ' +
      'ORDER BY DISTANCE(Location__c, GEOLOCATION(' + Company.Location__latitude__s + ',' + Company.Location__longitude__s +
      '), \'mi\') ';
 
 // Getting nearest Restaurant records 
    List < Restaurant > otherRestaurants = new List < Restaurant > ();
    otherRestaurants = Database.query(queryString);
 
    NearestRestaurantsList = new List < NearestRestaurants > ();
 // Building wrapper List
    for (Restaurant otherRestaurant: otherRestaurants) {
  NearestRestaurants wrapItem = new NearestRestaurants(
                             new Map < String, Double > {
                                    'latitude' => otherRestaurant.Location__latitude__s,
                                       'longitude' => otherRestaurant.Location__longitude__s                     },
                                       otherRestaurant.Name);

  NearestRestaurantsList.add(wrapItem);
    }

  }
 */
  // Wrapper Class to store nearest restaurants detail
  Public Class NearestRestaurants {
    Public map < String, decimal > location {
      get;
      private set;
    }
    Public String RestaurantName {
      get;
      private set;
    }
    public NearestRestaurants(Map < String, Double > nearestlocation, String myResName) {
      location = nearestlocation;
      RestaurantName = myResName;
    }
  }
}