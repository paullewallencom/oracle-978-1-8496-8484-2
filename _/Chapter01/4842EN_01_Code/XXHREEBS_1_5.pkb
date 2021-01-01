CREATE OR REPLACE PACKAGE BODY APPS.XXHREEBS AS
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
--     1.3      27/07/2011    Andy Penver      N/A       Added the p_org_id parameter to the package body
--     1.4      27/07/2011    Andy Penver      N/A       Added the p_person_id parameter to the package body
--     1.5      27/07/2011    Andy Penver      N/A       Added the procedure write_log
--     1.6      27/07/2011    Andy Penver      N/A       Added calls to the write_log procedure to show the parameters passed in to
--                                                       First_Concurrent_Program procedure.
-----------------------------------------------------------------------------------------------------
    
    -- This variable is to be used in reporting the name of the package that executued code
    v_package_name    VARCHAR2(30) := 'XXHREEBS';

    /* 1.5 - the procedure below is a local procedure to write to the concurrent program log file.
             If the profile option XXHR Write to Concurrent Program Logfile is set to 'Y' then
             the message passed in is written to the log file. */
    
    PROCEDURE write_log (p_msg IN VARCHAR2) IS
    BEGIN
        -- Check the Debug profile option
        IF cv_write_to_log = 'Y' THEN
            fnd_file.put_line (fnd_file.log, p_msg);
        END IF;
    END;
    
    /* The procedure below is called First_Concurrent_Program and is called from the executable XXHR1001
       It passes in two parameters errbuf and retcode which are mandatory parameters passed out when the 
       procedure is called from a concurrent program.
       
       Valid return values for retcode are
        0 - Success
        1 - Success and warning
        2 - Error
    */

    PROCEDURE  First_Concurrent_Program (errbuf     OUT VARCHAR2,
                                         retcode    OUT NUMBER,
                                         p_run_date IN  VARCHAR2, -- 1.1 Added p_run_date parameter
                                         p_org_id   IN  VARCHAR2, -- 1.3 Added p_org_id parameter
                                         p_person_id IN NUMBER) IS -- 1.4 Added p_person_id parameter
                                         
       v_procedure_name   VARCHAR2(30) := 'First_Concurrent_Program'; -- local variable containing the name of the procudeure    
       v_run_date         DATE := TO_DATE(p_run_date,'YYYY/MM/DD HH24:MI:SS');                                  
    BEGIN
    
      -- 1.6 Add messages to the log file showing the parameters passed in
      write_log(v_procedure_name||' Parameters are:');
      write_log(' p_run_date -> '||p_run_date);
      write_log(' p_org_id -> '||p_org_id);
      write_log(' p_person_id -> '||p_person_id);
      
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
/
