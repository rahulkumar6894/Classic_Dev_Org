trigger Update_contact on Individual ( after insert, after Update) 
{
  
  for( Individual  ind : trigger.new)
  {
      Map<String, Object> inputs = new Map<String, Object>();
      inputs.put('Individual_id', ind.id);
      Flow.Interview.Update_Contact_2 flow = new Flow.Interview.Update_Contact_2(inputs);     
      flow.start();
  }

}