-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_CREATE_ABS_AQ 
--            TYPE:   SQL Script 
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   11/09/2008
--
--     DESCRIPTION:   
--
--        This is a SQL script to create inbound advanced queue
--        Note:  Run this script as APPLSYS user.
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  ----------------------
--     1.0      23/09/2010    Andy Penver      N/A      Initial Version
----------------------------------------------------------------------------------------------
begin
    dbms_aqadm.create_queue_table(queue_table=>'APPLSYS.XXHR_ABS_DOC_IN', queue_payload_type=>'APPS.WF_EVENT_T', multiple_consumers=>TRUE, compatible=>'8.1');
	dbms_aqadm.create_queue (queue_name=>'APPLSYS.XXHR_ABS_DOC_IN', queue_table=>'APPLSYS.XXHR_ABS_DOC_IN', max_retries=> 5, retention_time=>604800, comment=>'user defineable');
	dbms_aqadm.start_queue  (queue_name=>'APPLSYS.XXHR_ABS_DOC_IN');
end;
/
