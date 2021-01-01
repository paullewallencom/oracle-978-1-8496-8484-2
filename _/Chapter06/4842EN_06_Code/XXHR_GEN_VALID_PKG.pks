CREATE OR REPLACE PACKAGE XXHR_GEN_VALID_PKG AS
-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_GEN_VALID_PKG
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
-----------------------------------------------------------------------------------------------------


    /* The procedure Secure_Email_Address function is used in chapter 4.*/
    FUNCTION Secure_Email_Address (p_email_address IN VARCHAR2) RETURN VARCHAR2;

END XXHR_GEN_VALID_PKG;
