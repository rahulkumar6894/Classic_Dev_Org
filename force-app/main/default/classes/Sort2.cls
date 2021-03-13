public class Sort2 {
   integer []arr;
    integer temp;
    integer i;
    public sort2(){arr =new integer[]{32,45,1,0,15,6};}
    public void show(){
        for(integer i = 1 ; i <arr.size() ; ){
       if(arr[i] < arr[i-1]){
            temp = arr[i];
            arr[i] = arr[i -1];
            arr[i -1] = temp;
           i--;
              }
        
              
       
    }
       System.debug('Desending Order'+arr);  
    }
         
}