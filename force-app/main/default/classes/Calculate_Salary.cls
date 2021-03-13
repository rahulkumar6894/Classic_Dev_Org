public class Calculate_Salary {
    String Empcode;
    String EmpName;
    integer BS;
    public Calculate_Salary (){
        Empcode='Emp-01';
        EmpName='Job Alex';
        BS=15000;
    }
    public Integer HR(){
        integer hr=BS*50/100;
         return hr;
    }
  public Integer DA(){
        integer da=BS*20/100;
         return da;
    }
    public Integer TA(){
        integer ta=BS*30/100;
         return ta;
    }
public  void Show(){
        
    System.debug('EmpCode:-'+Empcode);
    System.debug('EmpName:-'+Empname);  
        System.debug('HR:-'+HR()); 
        System.debug('DA:-'+DA());
        System.debug('TA:-'+TA());
    //integer c=DA();
        integer NetSalary=BS+HR()+DA()+TA();
    System.debug('NetSalary:-'+NetSalary);
         
    }
}