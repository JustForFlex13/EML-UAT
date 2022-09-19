/*
 * Create this object to obtain a grap of interesting object to test
 * Used in test classes
 */
@IsTest
public class DataTests {

    public User user {get;set;}
    public Account account {get;set;}
    public Contact contact {get;set;}
    public List<Opportunity> opps {get;set;}
    public List<Contact> contacts {get;set;}
}