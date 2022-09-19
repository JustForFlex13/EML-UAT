/*---------------------------------------------------------------------
-- - Purpose             : CRUD Contact class
--
-- - Maintenance History :
--
-- Date        Name  Company  Version  Remarks
-- ----------  ----  -------  -------  --------------------------------
-- 28/11/2017  ????  ???????  1.0      Creation
---------------------------------------------------------------------*/ 
public class ContactDAO {    
    
    public static void updateBulk (List<Contact> contacts){
        Database.update(contacts, false);
    }
}