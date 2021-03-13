public class SelectListCon {

       public List<String> SelectDealOption {get;set;}

       public String acxxxx { get; set; }
       public String sSelectedDeal { get; set; }

        public List<SelectOption> sViewPickList {get;set;}
        
        public SelectListCon (){
                sViewPickList  = new  List<SelectOption>();
                 SelectDealOption = new List<String>();
                 sSelectedDeal  ='';
                 SelectDealOption.add('"'+ 'Canada11111'+'¤'+'1'+'"');
                 SelectDealOption.add('"'+ 'Canada1222222'+'¤'+'2'+'"');
                 SelectDealOption.add('"'+ 'Canada13333333'+'¤'+'3'+'"');

               // sSelectedDeal = 'CANADA1';
        }
    }