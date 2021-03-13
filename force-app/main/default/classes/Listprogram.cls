public class Listprogram {
    List<Integer> mylist;
    List<Integer> mylist1;
      List<Integer> mylist2;
    Public Listprogram(){
        mylist=new List<Integer>{1,3,9,70,67,2,12,5};
         mylist1=new List<Integer>{0,1,2};
             mylist2=new List<Integer>{};
    }
    public void  show(){ 
        mylist.sort();
        System.debug('Sorted Array'+mylist);
        mylist.add(55);
        mylist.add(54);
        mylist.add(56);
        System.debug('Add Array'+mylist);
        
        mylist.add(0,333);
         System.debug('Add index Array'+mylist);
        mylist.remove(3);
         System.debug('After remove index Array'+mylist);
        mylist1.addAll(mylist);
         System.debug('After Adding Array'+mylist1);
        mylist2= mylist.clone();
          System.debug('Clone  Array'+mylist2);
    }  
    
}