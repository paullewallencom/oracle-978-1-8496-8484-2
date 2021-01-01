set serveroutput on size 200000
declare
  v_out NUMBER;
  v_msg_text VARCHAR2(1000);
  
  -- Define variable to pass in the business event
  v_event VARCHAR2(100) := 'oracle.apps.xxhr.absence.inbound';
  -- Define variable to pass in the agent (AQ)
  v_agent VARCHAR2(100) := 'XXHR_ABS_DOC_IN';
  -- Define variable to store the XML we are puuting onto the AQ
  v_xml CLOB;
  v_datetime VARCHAR2(30);
  
  v_emp_number VARCHAR2(30) := '11xxx';
  v_abs_type VARCHAR2(100) := 'Sickness';
  v_abs_reason VARCHAR2(100) := 'Cold';
  v_abs_start_date VARCHAR2(11) := '10-MAR-2011';
  v_abs_end_date VARCHAR2(11) := '11-MAR-2011';
  v_abs_duration VARCHAR2(10) := '2';

begin

  SELECT TO_CHAR(sysdate, 'DD-MON-RRRR HH24:MI:SS') 
    INTO v_datetime
    FROM dual; 

    v_xml :=  '<Absence>'||CHR(10)||
              '  <DateTime>'||v_datetime||'</DateTime>'||CHR(10)||
              '  <EmployeeNumber>'||v_emp_number||'</EmployeeNumber>'||CHR(10)||
              '  <AbsenceType>'||v_abs_type||'</AbsenceType>'||CHR(10)||
              '  <AbsenceReason>'||v_abs_reason||'</AbsenceReason>'||CHR(10)||
              '  <AbsenceStartDate>'||v_abs_start_date||'</AbsenceStartDate>'||CHR(10)||
              '  <AbsenceEndDate>'||v_abs_end_date||'</AbsenceEndDate>'||CHR(10)||
              '  <AbsenceDuration>'||v_abs_duration||'</AbsenceDuration>'||CHR(10)||
              '</Absence>';
  -- Call to PL/SQL package to enqueue xml message to the XXHR_ABS_DOC_IN advanced
  -- queue
  v_out := xxhr_absence_in_wf_pkg.enqueue_msg (v_event, v_xml, v_agent, v_msg_text);
  dbms_output.put_line(v_out||' - '||v_msg_text);
  commit;
end;


