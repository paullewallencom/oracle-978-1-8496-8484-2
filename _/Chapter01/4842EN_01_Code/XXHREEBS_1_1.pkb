CREATE OR REPLACE PACKAGE BODY XXHREEBS AS
-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHREEBS
--            TYPE:   Package Body
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2010
--
--     DESCRIPTION:
--
--        This package body contains the public and local pl/sql procedures and functions for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
-----------------------------------------------------------------------------------------------------
    
    -- This variable is to be used in reporting the name of the package that executued code
    v_package_name    CONSTANT VARCHAR2(30) := 'XXHREEBS';

    /* The procedure below is used in chapter 0.
       It is called First_Concurrent_Program and is called from the executable XXHR1001
       It passes in two parameters errbuf and retcode which are mandatory parameters passed out when the 
       procedure is called from a concurrent program.
       
       Valid return values for retcode are
        0 - Success
        1 - Success and warning
        2 - Error
    */
    PROCEDURE  First_Concurrent_Program (errbuf     OUT VARCHAR2,
                                         retcode    OUT NUMBER) IS
                                         
       v_procedure_name VARCHAR2(30) := 'First_Concurrent_Program'; -- local variable containing the name of the procudeure                                        
                                         
    BEGIN
       
      retcode := SUCCESS; -- When the program runs we want to return 0 which means the program has run successfully
    
    EXCEPTION WHEN OTHERS THEN
        -- A procedure will always have an EXCEPTIONS section to catch errors
        -- At a minimum there will ba a catch all other errors statement
        errbuf  := SQLERRM;
        retcode := FAILED;
    END;                                         

END XXHREEBS;
/