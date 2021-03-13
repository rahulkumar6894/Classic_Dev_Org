public class Array2D {
    List<List<Integer>>arr;
    public Array2D (){
       arr = new List<List<Integer>>{
    new List<Integer>{10,20,30},
    new List<Integer>{60,80,90},
    new List<Integer>{100,5,2}};
        }  
   
       // Method of max value 
       public Integer Maxvalue() {
        integer maxValue = arr[0][0];
        for (integer j = 0; j < arr.size(); j++) {
            for (integer i = 0; i < arr.size(); i++) {
                if (arr[j][i] > maxValue) {
                    maxValue = arr[j][i];
                }
            }
        }
        return maxValue;
       }
    // Method of min value 
       public Integer Minvalue() {
        integer minValue = arr[0][0];
        for (integer j = 0; j < arr.size(); j++) {
            for (integer i = 0; i < arr.size(); i++) {
                if (arr[j][i] < minValue) {
                    minValue = arr[j][i];
                }
            }
        }
        return minValue;
       }
        
    public void Show(){
        integer a=Maxvalue();
         integer b=Minvalue();
        System.debug('Max value in 2d array'+a);
        System.debug('Max value in 2d array'+b);
    }    
        
        
        
    


}