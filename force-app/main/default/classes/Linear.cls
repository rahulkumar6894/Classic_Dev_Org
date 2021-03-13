public class Linear {
    public integer []arr;
    
    public Linear(){
        arr=new integer[]{10,12,13,15,17};}
    
    
    public void show(){
        for(integer i=0;i<arr.size();i++)
        {
            if(arr[i]==13){
             System.debug('found Element in array is'+arr[i]); 
                System.debug('location  of Array is'+i);}
            
        
            else {
                System.debug('value does not exits'); } 
                
        } 
              
            
    }
    

}