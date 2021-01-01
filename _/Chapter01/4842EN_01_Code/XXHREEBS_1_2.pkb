create or replace
PACKAGE BODY XXHREEBS AS
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
--     1.1      21/07/2011    Andy Penver      N/A       Added the p_run_date parameter to First_Concurrent_Program
--     1.2      21/07/2011    Andy Penver      N/A       Added the conditions to set the completion status
-----------------------------------------------------------------------------------------------------
    
    -- This variable is to be used in reporting the name of the package that executed the code
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
                                         retcode    OUT NUMBER,
                                         p_run_date IN VARCHAR2) IS -- 1.1 Added p_run_date parameter
                                         
       v_procedure_name   VARCHAR2(30) := 'First_Concurrent_Program'; -- local variable containing the name of the procudeure    
       v_run_date         DATE := TO_DATE(p_run_date,'YYYY/MM/DD HH24:MI:SS'); -- 1.2 added local variable to store p_run_date parameter                                 
    BEGIN
      
      -- 1.2 Added the conditions to set the completion status
      -- If the run date is the same as the date it is run on then complete with success
      -- If the run date is less than the date it is run on the complete with warning
      -- If the run date is greater than the date it is run oncomplete the concurrent program as failed
      IF TRUNC(v_run_date) = TRUNC(SYSDATE) THEN
        retcode := SUCCESS;
      ELSIF TRUNC(v_run_date) < TRUNC(SYSDATE) THEN
        retcode := WARNING;
      ELSIF TRUNC(v_run_date) > TRUNC(SYSDATE) THEN
        retcode := FAILED;
      END IF;
    
    EXCEPTION WHEN OTHERS THEN
        -- A procedure will always have an EXCEPTIONS section to catch errors
        -- At a minimum there will ba a catch all other errors statement
        errbuf  := SQLERRM;
        retcode := FAILED;
    END; 
    
END XXHREEBS;

    