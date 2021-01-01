CREATE OR REPLACE PACKAGE APPS.XXHREEBS AS
-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHREEBS
--            TYPE:   Package Specification
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2010
--
--     DESCRIPTION:
--
--        This package specificication is to define the public pl/sql procedures and functions for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
--     1.1      21/07/2011    Andy Penver      N/A       Added the p_run_date parameter to First_Concurrent_Program
--     1.2      27/07/2011    Andy Penver      N/A       Added the p_org_id parameter
-----------------------------------------------------------------------------------------------------

     -- The following 3 variables represent the return values that we will set retcode to
     -- They are purely used to make reading the code easier. 
     
     SUCCESS                            NUMBER   := 0;
     WARNING                            NUMBER   := 1;
     FAILED                             NUMBER   := 2;

    /* The procedure First_Concurrent_Program is used in chapter 0.
       It is called First_Concurrent_Program and is called from the executable XXHR1001
       It passes in two parameters errbuf and retcode which are mandatory parameters passed out when the 
       procedure is called from a concurrent program.
       
       Valid return values for retcode are
        0 - Success
        1 - Completed Successfully with Warnings
        2 - Error
    */
    PROCEDURE  First_Concurrent_Program (errbuf     OUT VARCHAR2,
                                         retcode    OUT NUMBER,
                                         p_run_date IN VARCHAR2, -- 1.1 Added p_run_date parameter
                                         p_org_id   IN VARCHAR2);-- 1.2 Added p_org_id parameter

END XXHREEBS;
/
