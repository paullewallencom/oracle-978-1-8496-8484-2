set serveroutput on size 200000
declare
  v_out NUMBER;
  v_msg_text VARCHAR2(1000);
  
  -- Define variable to pass in the business event
  v_event VARCHAR2(100) := 'oracle.apps.xxhr.absence.inbound';
  -- Define variable to pass in the agent (AQ)
  v_agent VARCHAR2(100) := 'XXHR_ABS_DOC_IN';
  -- Define variable to store the XML we are puuting onto the AQ
  v_xml CLOB := '<Absence>'||CHR(10)||
                '  <DateTime></DateTime>'||CHR(10)||
                '  <EmployeeNumber></EmployeeNumber>'||CHR(10)||
                '  <AbsenceType></AbsenceType>'||CHR(10)||
                '  <AbsenceReason></AbsenceReason>'||CHR(10)||
                '  <AbsenceStartDate></AbsenceStartDate>'||CHR(10)||
                '  <AbsenceEndDate></AbsenceEndDate>'||CHR(10)||
                '  <AbsenceDuration></AbsenceDuration>'||CHR(10)||
                '</Absence>';
begin
  -- Call to PL/SQL package to enqueue xml message to the XXHR_ABS_DOC_IN advanced
  -- queue
  v_out := xxhr_absence_in_wf_pkg.enqueue_msg (v_event, v_xml, v_agent, v_msg_text);
  dbms_output.put_line(v_out||' - '||v_msg_text);
  commit;
end;


