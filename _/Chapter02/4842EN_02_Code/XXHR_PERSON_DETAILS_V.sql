-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_PERSON_DETAILS_V
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
CREATE OR REPLACE FORCE VIEW APPS.XXHR_PERSON_DETAILS_V 
	(PERSON_ID, 
	 FULL_NAME, 
	 EMPLOYEE_NUMBER, 
	 EMAIL_ADDRESS, 
	 SUPERVISOR_ID)
AS
  (SELECT emp.person_id,
          emp.full_name ,
          emp.employee_number ,
          emp.email_address ,
          empa.supervisor_id
     FROM per_all_people_f emp,
          per_all_assignments_f empa
    WHERE emp.person_id   = empa.person_id
      AND empa.primary_flag = 'Y'
	  AND emp.business_group_id = hr_general.get_business_group_id
      AND TRUNC(SYSDATE) BETWEEN TRUNC(emp.effective_start_date) AND TRUNC(emp.effective_end_date)
      AND TRUNC(SYSDATE) BETWEEN TRUNC(empa.effective_start_date) AND TRUNC(empa.effective_end_date));