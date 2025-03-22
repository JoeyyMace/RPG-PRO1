**FREE
Ctr-Opt DftActGrp(*No) ActGrp(*New) Main(Main);

Dcl-S custID    Int(10);
Dcl-S firstName char(50);
Dcl-S lastName  char(50);
Dcl-S email     char(100);
Dcl-S phone     char(15);

Dcl-Proc Main;
    Dcl-S choice Char(1);

    DoU choice = '3';
        Dsply '1. Add Customer' '*EXT' choice;
        Dsply '2. List Customers' '*EXT' choice;
        Dsply '3. Exit' '*EXT' choice;

        Select
            When choice = '1';
                CallP AddCustomer();
            When choice = '2';
                Callp ListCustomers();
        EndSl;
    EndDo;
End-Proc;

Dcl-Proc AddCustomer;
    Dsply 'Enter First Name: ' '*EXT' firstName;
    Dsply 'Enter Last Name : ' '*EXT' lastName;
    Dsply 'Enter EMAIL : ' '*EXT' email;
    Dsply 'Enter Phone Number: ' '*EXT' phone;

    Exec SQL 
        INSERT INTO CUSTOMERS (FIRST_NAME, LAST_NAME, EMAIL, PHONE)
        VALUES (:firstName, :lastName, :email, :phone)
    
    Dsply 'Customer added succecfully';
End-Proc;

Dcl-Proc ListCustomers;
    Dcl-S customerRow char(200);

    Exec SQL DECLARE c1 CURSOR FOR
        SELECT ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE FROM CUSTOMERS;

    Exec SQL OPEN c1;

    DoU SQLCODE <> 100; //Loop unitl no more rows
        Exec SQL FETCH NEXT FROM c1 INTO :custID, :firstName, :lastName, :email, :phone;
        If SQLCODE = 0;
            Eval customerRow = %Trim(firstName) + ' ' + %Trim(lastName) + ' (' + email + ')';
            Dsply customerRow;
        EndIf;
    EndDo;

    Exec SQL CLOSE c1;
End-Proc;
