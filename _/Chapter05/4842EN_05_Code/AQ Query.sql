SELECT   TO_CHAR (t.enq_time, 'DD-MON-YYYY HH24:MI:SS') enq_time, 
         TO_CHAR (t.deq_time, 'DD-MON-YYYY HH24:MI:SS') deq_time,
         t.state,
         t.delay,
         t.priority,
         t.user_data.event_data
    FROM APPLSYS.XXHR_ABS_DOC_IN t
   WHERE TO_CHAR (t.enq_time, 'DD-MON-YYYY') > sysdate - 5
ORDER BY t.enq_time DESC;