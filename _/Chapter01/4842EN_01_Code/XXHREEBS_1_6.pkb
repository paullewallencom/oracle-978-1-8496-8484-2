CREATE OR REPLACE PACKAGE BODY APPS.XXHREEBS AS
-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHREEBS
--            TYPE:   Package Body
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2010
--
--     DESCRIPTION:
--
--        This package body contains the public and local pl/sql procedures and functions for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
--     1.1      21/07/2011    Andy Penver      N/A       Added the p_run_date parameter to First_Concurrent_Program
--     1.2      21/07/2011    Andy Penver      N/A       Added the conditions to set the completion status
--     1.3      27/07/2011    Andy Penver      N/A       Added the p_org_id parameter to the package body
--     1.4      27/07/2011    Andy Penver      N/A       Added the p_person_id parameter to the package body
--     1.5      27/07/2011    Andy Penver      N/A       Added the procedure write_log
--     1.6      27/07/2011    Andy Penver      N/A       Added calls to the write_log procedure to show the parameters passed in to
--                                                       First_Concurrent_Program procedure.
--     1.7      27/07/2011    Andy Penver      N/A       Added the procedure write_output
--     1.8      27/07/2011    Andy Penver      N/A       Added the c_emp_dtls cursor to get some employee details
--     1.9      27/07/2011    Andy Penver      N/A       Write the report header to the output file
--     1.10     27/07/2011    Andy Penver      N/A       Write the returned records to the output file
-----------------------------------------------------------------------------------------------------
    
    -- This variable is to be used in reporting the name of the package that executued code
    v_package_name    VARCHAR2(30) := 'XXHREEBS';

    /* 1.5 - the procedure below is a local procedure to write to the concurrent program log file.
             If the profile option XXHR Write to Concurrent Program Logfile is set to 'Y' then
             the message passed in is written to the log file. */
    
    PROCEDURE write_log (p_msg IN VARCHAR2) IS
    BEGIN
        -- Check the Debug profile option
        IF cv_write_to_log = 'Y' THEN
            fnd_file.put_line (fnd_file.log, p_msg);
        END IF;
    END;
    
    -- 1.6 - the procedure below is a local procedure to write to the concurrent program output file.
    PROCEDURE write_output (p_msg IN VARCHAR2) IS
    BEGIN
            fnd_file.put_line (fnd_file.output, p_msg);
    END;
    
   
    /* The procedure below is called First_Concurrent_Program and is called from the executable XXHR1001
       It passes in two parameters errbuf and retcode which are mandatory parameters passed out when the 
       procedure is called from a concurrent program.
       
       Valid return values for retcode are
        0 - Success
        1 - Success and warning
        2 - Error
    */

    PROCEDURE  First_Concurrent_Program (errbuf     OUT VARCHAR2,
                                         retcode    OUT NUMBER,
                                         p_run_date IN  VARCHAR2, -- 1.1 Added p_run_date parameter
                                         p_org_id   IN  VARCHAR2, -- 1.3 Added p_org_id parameter
                                         p_person_id IN NUMBER) IS -- 1.4 Added p_person_id parameter
                                         
       v_procedure_name   CONSTANT VARCHAR2(30) := 'First_Concurrent_Program'; -- local variable containing the name of the procudeure    
       v_run_date         DATE := TO_DATE(p_run_date,'YYYY/MM/DD HH24:MI:SS'); 

       /* 1.8 - cursor to fetch some employee details
              - Note the person_id can be null so that if a person_id parameter is not passed all emplyees for a specific 
              - organisation will be returned */
       CURSOR c_emp_dtls (c_org_id IN hr_all_organization_units.organization_id%TYPE,
                          c_person_id IN per_all_people_f.person_id%TYPE) IS
        SELECT ho.name, ppf.full_name
             , ppf.employee_number
             , PPF.NATIONAL_IDENTIFIER
             , PPF.email_address
             , NVL2(payroll_id, 'Yes', 'No') payroll -- is the employee on a payroll
             , NVL2(supervisor_id, 'Yes', 'No') supervisor -- does the employee have a supervisor
          FROM per_people_f ppf
             , per_assignments_f paf 
             , hr_all_organization_units ho
         WHERE ppf.person_id = paf.person_id 
           AND paf.primary_flag = 'Y'
           AND paf.assignment_type = 'E' 
           AND paf.organization_id = ho.organization_id
           AND TRUNC(SYSDATE) BETWEEN ppf.effective_start_date AND ppf.effective_end_date
           AND TRUNC(SYSDATE) BETWEEN paf.effective_start_date AND paf.effective_end_date 
           AND SYSDATE BETWEEN NVL(ho.date_from, SYSDATE) AND NVL (ho.date_to, SYSDATE) 
           AND paf.organization_id = c_org_id
           AND ppf.person_id = NVL(c_person_id,ppf.person_id)  
         ORDER BY ppf.full_name;
                                          
    BEGIN
    
      -- 1.6 Add messages to the log file showing the parameters passed in
      write_log(v_procedure_name||' Parameters are:');
      write_log(' p_run_date -> '||p_run_date);
      write_log(' p_org_id -> '||p_org_id);
      write_log(' p_person_id -> '||p_person_id);
      
      -- 1.9 Add a report header
      write_output('                              Report Output for Employee Details');
      write_output('                              ----------------------------------'||CHR(10));
      write_output(' Report Date: '||TO_CHAR(v_run_date, 'DD-MON-YYYY')||CHR(10));
      
      -- 1.10 Call the cursor and write details to the output file
      FOR r_emp_dtls IN c_emp_dtls (p_org_id, p_person_id) LOOP
      
        write_output(CHR(10));
        write_output('      Organsization : '||r_emp_dtls.name);
        write_output('          Full Name : '||r_emp_dtls.full_name); 
        write_output('    Employee Number : '||r_emp_dtls.employee_number); 
        write_output('National Identifier : '||r_emp_dtls.national_identifier); 
        write_output('      Email Address : '||r_emp_dtls.email_address);
        write_output('         On Payroll : '||r_emp_dtls.payroll);        
        write_output('         Supervisor : '||r_emp_dtls.supervisor);         
        write_output(CHR(10));
              
      END LOOP;

      -- 1.2 Added the conditions to set the completion status
      -- If the run date is the same as the date it is run on then complete with success
      -- If the run date is less than the date it is run on the complete with warning
      -- If the run date is greater than the date it is run oncomplete the concurrent program as failed
      IF TRUNC(v_run_date) = TRUNC(SYSDATE) THEN
        retcode := SUCCESS;
      ELSIF TRUNC(v_run_date) < TRUNC(SYSDATE) THEN
        retcode := WARNING;
      ELSIF TRUNC(v_run_date) > TRUNC(SYSDATE) THEN
        retcode := FAILED;
      END IF;
    
    EXCEPTION WHEN OTHERS THEN
        -- A procedure will always have an EXCEPTIONS section to catch errors
        -- At a minimum there will ba a catch all other errors statement
        errbuf  := SQLERRM;
        retcode := FAILED;
    END;                                         

END XXHREEBS;
/
