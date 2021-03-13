public class ArraySorting{
    integer []arr;
    integer temp;
    integer i,j;
    public ArraySorting(){arr =new integer[]{10,20,30,40,1,5,8,6};}
    public void show(){
        for(i=4;i<arr.size();i++){
            for(j=i;j<arr.size();j++){
            if(arr[i]< arr[j]){
                temp=arr[i];
                arr[i]=arr[j];
                arr[j]=temp;}
            }
        
            }
           System.debug(arr);  
    }
         
        
    }