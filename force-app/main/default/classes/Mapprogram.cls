public class Mapprogram {
    Map<Integer,String> mymap;
    public Mapprogram(){
        mymap=new map<Integer,String>{1=>'Rahul',2=>'Rohit'};
    }
    public void show(){
        System.debug(mymap);
        //ContainsKey
        if(mymap.containsKey(3)){System.debug('Yes I Have ');}
        else{System.debug('Sorry');}
        //put Method
        mymap.put(3, 'Imran Sir');
        System.debug(mymap);
        //getMethod 
       System.debug( mymap.get(3));
        //remove method 
        /*mymap.remove(3);
        System.debug(mymap);*/
        mymap.put(4, 'Jon');
         mymap.put(5, 'Jon5');
         mymap.put(6, 'Jon6');
         mymap.put(7, 'Jon7');
         mymap.put(8, 'Jon8');
         mymap.put(9, 'Jon9');
         mymap.put(10, 'Jon10');
         System.debug( mymap);
         System.debug( mymap.get(7));
    }

}