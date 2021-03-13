trigger LastName on Contact (before insert) {
List<Contact> lnameobj=trigger.new;
for(Contact lname:lnameobj){
lname.LastName+='NavatarGroup';}

}