public with sharing class pagination {

    public void previous() {
        OffsetSize = OffsetSize - LimitSize;
    }
    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
    }
    public boolean getnxt()
    {
        if((OffsetSize + LimitSize) > totalRecs)
        return true;
        else
        return false;
    }
     public void LastPage()
    {
    OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
    }
    

    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 10;
    
    public Pagination()
    {
        totalRecs = [select count() from account];
    }
    public List<account> getacclist()
    {
        List<account> acc = Database.Query('SELECT Name, website, AnnualRevenue, description, Type FROM account LIMIT :LimitSize OFFSET :OffsetSize');
        System.debug('Values are' + acc);
        return acc;
    }
    
    public void FirstPage() {
        OffsetSize = 0;
    }
    
    public boolean getPrev1() {
        if(OffsetSize == 0)
        return true;
        else
        return false;
    }

    
}