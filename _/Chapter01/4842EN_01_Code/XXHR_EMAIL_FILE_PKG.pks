CREATE OR REPLACE PACKAGE APPS.XXHR_EMAIL_FILE_PKG IS

---------------------------------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_EMAIL_FILE_PKG
--            TYPE:   Package Specification
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   05/01/2012
--
--     DESCRIPTION:
--
--        This package contains the API's related to Notification generation
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  ------------- ---------------- --------  -------------------------------------------------------------------
--     1.0      05/01/2012    Andy Penver      N/A       Initial Version
----------------------------------------------------------------------------------------------------------------------------

   -- -------------------------------------------------------------------------
   -- PROCEDURE: process_main
   -- -------------------------------------------------------------------------
   --
   -- This procedure will generate a file that will be created on the file system
   -- -------------------------------------------------------------------------
   
   PROCEDURE process_main (p_errbuf            OUT VARCHAR2
                          ,p_retcode           OUT NUMBER
                          ,p_subject           IN VARCHAR2
                          ,p_email_to          IN VARCHAR2);

 
end XXHR_EMAIL_FILE_PKG;
/
