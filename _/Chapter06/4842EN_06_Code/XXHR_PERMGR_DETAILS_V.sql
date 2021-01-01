-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_PERMGR_DETAILS_V
--            TYPE:   View for XXHRSOCC form 
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2011
--
--     DESCRIPTION:
--
--        This view is for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
-----------------------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW APPS.XXHR_PERMGR_DETAILS_V ( EMP_PERSON_ID
                                                  , EMP_FULL_NAME
												  , EMP_EMPLOYEE_NUMBER
												  , EMP_EMAIL_ADDRESS
												  , EMP_SUPERVISOR_ID
												  , MGR_PERSON_ID
												  , MGR_FULL_NAME
												  , MGR_EMPLOYEE_NUMBER
												  , MGR_EMAIL_ADDRESS
												  , MGR_SUPERVISOR_ID)
AS
  (SELECT emp.person_id,
    emp.full_name ,
    emp.employee_number ,
    emp.email_address ,
    emp.supervisor_id,
    mgr.person_id,
    mgr.full_name ,
    mgr.employee_number ,
    mgr.email_address,
    mgr.supervisor_id
  FROM XXHR_PERSON_DETAILS_V emp,
    XXHR_PERSON_DETAILS_V mgr
  WHERE mgr.person_id = emp.supervisor_id
  );