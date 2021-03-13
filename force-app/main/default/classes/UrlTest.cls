public with sharing class UrlTest {

   public UrlTest()
   { 
        String y = ApexPages.currentPage().getURL();
        System.debug('URL&&&&&&&&&&&&&&&&&&&&&'+y);
      String x =   ApexPages.currentPage().getHeaders().get('Host') ;
       System.debug('XXXXXXX&&&&&&&&&&&&&&&&&&&&&'+x);
   }
 
}