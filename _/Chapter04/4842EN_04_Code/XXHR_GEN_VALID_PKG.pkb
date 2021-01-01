CREATE OR REPLACE PACKAGE BODY XXHR_GEN_VALID_PKG AS
-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_GEN_VALID_PKG
--            TYPE:   Package Body
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2010
--
--     DESCRIPTION:
--
--        This package body is to define the public pl/sql procedures and functions for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
-----------------------------------------------------------------------------------------------------


    /* The procedure Secure_Email_Address function is used in chapter 4.*/
    FUNCTION Secure_Email_Address (p_email_address IN VARCHAR2) RETURN VARCHAR2 IS
    
      CURSOR get_email_domains IS
      SELECT meaning 
        FROM FND_LOOKUP_VALUES 
       WHERE lookup_type = 'XXHR_EMAIL_VALIDATION' 
         AND TRUNC(SYSDATE) BETWEEN TRUNC(NVL(start_date_active, sysdate)) AND TRUNC(NVL(end_date_active, sysdate));
         
       l_return VARCHAR2(1) := 'N';
       
    BEGIN
	  -- CURSOR to fetch the strings from the XXHR_EMAIL_VALIDATION lookup
      FOR r_email_domain IN get_email_domains LOOP
	     -- If the string exists in the email address then return 'Y' as the email address is in a secure domain
         IF UPPER(INSTR(p_email_address, r_email_domain.meaning)) > 0 THEN
           l_return := 'Y';
         END IF;
      END LOOP;
      
      -- Return the default value of 'N' as there has been no string that has matched
	  RETURN l_return;
    END Secure_Email_Address;

END XXHR_GEN_VALID_PKG;
