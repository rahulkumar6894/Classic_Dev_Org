public class SetProgram {
    Set<String> myset;
    
    public SetProgram(){
        myset=new Set<String>{'a','b','c','d'};
         }
    public void Show(){
        System.debug(myset);
        myset.add('a');
        myset.add('e');
        myset.add('f');
        myset.add('g');
       
              
         System.debug(myset);
        if(myset.contains('h')){System.debug('Hello A');}
        else{System.debug('Sorry');}
         }
}