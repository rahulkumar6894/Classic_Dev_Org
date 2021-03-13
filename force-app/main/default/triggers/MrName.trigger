trigger MrName on Contact (before insert) {
    List<Contact> ls=trigger.new;
    for(Contact c:ls)
    {
        c.FirstName='Mr'+c.FirstName;
    }

}