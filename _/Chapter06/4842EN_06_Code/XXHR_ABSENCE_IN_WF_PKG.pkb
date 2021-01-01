create or replace
PACKAGE BODY XXHR_ABSENCE_IN_WF_PKG AS

  FUNCTION get_business_group_id RETURN NUMBER IS
  
    CURSOR Get_Resp_Info IS
    SELECT responsibility_id, application_id 
      FROM fnd_responsibility_vl 
     WHERE responsibility_name = gResponsibility;
     
     r_init Get_Resp_Info%ROWTYPE;
     
     v_business_group_id per_business_groups.business_group_id%TYPE;
     
   BEGIN
   
       OPEN Get_Resp_Info;
       FETCH Get_Resp_Info INTO r_init;
       CLOSE Get_Resp_Info;
       
       v_business_group_id := fnd_profile.value_specific('PER_BUSINESS_GROUP_ID', null, r_init.responsibility_id, r_init.application_id);
       
       RETURN v_business_group_id; 
   END;
   --
   -- PROCEDURE search_for_tag
   --
   -- This procudure searches for a tag in the XML document
   -- If the tag is found then the value stored in the tag will be returned
   -- If the tag is not found then the result is set to ERROR
   --
   PROCEDURE search_for_tag ( p_itemkey IN VARCHAR2
                            , p_xml IN SYS.XMLDOM.domdocument
                            , p_tag_name IN VARCHAR2
                            , x_value OUT VARCHAR2
                            , x_result OUT VARCHAR2) IS 

      nodelist                SYS.XMLDOM.domnodelist;
      xmllength               NUMBER;
      node                    SYS.XMLDOM.domnode;
     
   BEGIN
      nodelist :=  SYS.XMLDOM.getelementsbytagname (p_xml, p_tag_name);
      xmllength := SYS.XMLDOM.getlength (nodelist);

      -- If the tag is found then the length will equal 1
      IF xmllength = 1 THEN
         node := SYS.XMLDOM.item (nodelist, 0);
         node := SYS.XMLDOM.getfirstchild (node);
         x_value := SYS.Xmldom.getnodevalue (node); -- return the value in the tag
      ELSE
         x_result := gError; -- return error if the tag is not found
      END IF;  
   
   END;

   --
   -- PROCEDURE parse_xml_elements
   --
   -- This procudure parses the XML document
   -- It checks for the existence of elements in the XML
   -- For each element the value is stored in an attribute in the workflow
   --
   
   PROCEDURE parse_xml_elements (
      p_xml              IN       SYS.XMLDOM.domdocument,
      p_itemtype         IN       VARCHAR2,
      p_itemkey          IN       VARCHAR2,
      x_error_text       OUT      VARCHAR,
      x_result           OUT      NUMBER
   )
   IS
      -- Declare a nested table 
      TYPE xml_elements_nt IS TABLE OF VARCHAR2(100);
      
      -- Declare an ELEMENTS collection for the XML Elements
      -- Assign 7 elements to the collection representing the XML we are passing in
      xml_e xml_elements_nt := xml_elements_nt ( 'DateTime'  				-- xml_e(1)
                                               , 'EmployeeNumber'			-- xml_e(2)
                                               , 'AbsenceType'				-- xml_e(3)
                                               , 'AbsenceReason'			-- xml_e(4)
                                               , 'AbsenceStartDate'			-- xml_e(5)
                                               , 'AbsenceEndDate'			-- xml_e(6)
                                               , 'AbsenceDuration');		-- xml_e(7)
                           
      -- Declare a VALUES collection for the XML element values
      xml_v xml_elements_nt := xml_elements_nt();
     
      v_value                 VARCHAR2 (100); -- value returned from the XML Element
      v_result                NUMBER; -- result if the call to the search_for_tag call
     
      -- variable to store the number of elements in the XML
      -- set the variable to 1
      i binary_integer := xml_e.first;
      
   BEGIN
      
      -- Loop for the number of elements in the ELEMENTS collection
      -- There are 7 elements defined in the xml_e collection so the loop count will be 7
      WHILE i IS NOT NULL LOOP
      
        -- Check that each element in the XML structure exists and return the value stored
        -- in the XML that is passed in. The element name in the ELEMENTS collection 
        -- is passed in i.e. the first one will be DateTime
        search_for_tag (p_itemkey, p_xml, xml_e(i), v_value, v_result);
        
        -- Store the value in the XML element in the VALUES collection 
        xml_v.extend;
        xml_v(i) := v_value; -- assign the xml_v collection with the value for the element
        
        -- If an error occurs set the result and store the error
        IF v_result = gError THEN
          x_result := gError;
          x_error_text := x_error_text||' Error - '||xml_e(i)||' - Incorrect XML format';
        END IF;
        i := xml_e.next(i);
        
      END LOOP;
      
      IF x_result = gError THEN
        RETURN;
      ELSE

        -- Store XML Element Values in attributes in workflow
        WF_ENGINE.setitemattrdate (itemtype      => p_itemtype,
                                   itemkey       => p_itemkey,
                                   aname         => 'XML_DATETIME',
                                   avalue        => TO_DATE (xml_v(1) , 'DD-MON-RRRR HH24:MI:SS'));
                                   
        WF_ENGINE.setitemattrtext (itemtype      => p_itemtype,
                                   itemkey       => p_itemkey,
                                   aname         => 'EMP_NUMBER',
                                   avalue        => xml_v(2));
                                   
        WF_ENGINE.setitemattrtext (itemtype      => p_itemtype,
                                   itemkey       => p_itemkey,
                                   aname         => 'ABS_TYPE',
                                   avalue        => xml_v(3));   
       
        WF_ENGINE.setitemattrtext (itemtype      => p_itemtype,
                                   itemkey       => p_itemkey,
                                   aname         => 'ABS_REASON',
                                   avalue        => xml_v(4)); 
        
        WF_ENGINE.setitemattrdate (itemtype      => p_itemtype,
                                   itemkey       => p_itemkey,
                                   aname         => 'ABS_START_DATE',
                                   avalue        => TO_DATE (xml_v(5) , 'DD-MON-RRRR'));
                                   
        WF_ENGINE.setitemattrdate (itemtype      => p_itemtype,
                                   itemkey       => p_itemkey,
                                   aname         => 'ABS_END_DATE',
                                   avalue        => TO_DATE (xml_v(6) , 'DD-MON-RRRR'));
  
        WF_ENGINE.setitemattrnumber (itemtype      => p_itemtype,
                                     itemkey       => p_itemkey,
                                     aname         => 'ABS_DURATION',
                                     avalue        => xml_v(7));                                  
      END IF;
      
      -- Delete the rows in the collections and free memory
      xml_e.delete;
      xml_v.delete;
      
      x_result := gSuccess;
      
   EXCEPTION
     WHEN OTHERS THEN
         x_result := gError;
         x_error_text := 'ERROR: '||SQLERRM;
   END parse_xml_elements;

   --
   -- PROCEDURE parse_and_store_xml
   --
   -- This procudure stores the XML document
   -- It calls a procedure that will parse the XML and store the elements in attributes in the workflow
   --

   PROCEDURE parse_and_store_xml (  itemtype    IN              VARCHAR2,
									itemkey     IN              VARCHAR2,
									actid       IN              NUMBER,
									funcmode    IN              VARCHAR2,
									resultout   IN OUT NOCOPY   VARCHAR2) IS
                          
      package_name       VARCHAR2 (30)      := 'XXHR_ABSENCE_IN_WF_PKG';
      procedure_name     VARCHAR2 (30)      := 'parse_and_store_xml';

      v_xml_stream       CLOB;
      v_event_t          WF_EVENT_T;
      v_xml              SYS.XMLDOM.DOMDOCUMENT;
      xml_parser         SYS.XMLPARSER.PARSER;

      v_result           NUMBER;
      v_error_text       VARCHAR (2000);
      
   BEGIN
   
      IF (funcmode <> WF_ENGINE.eng_run) THEN
         resultout := WF_ENGINE.eng_null;
         RETURN;
      END IF;

      v_event_t :=  WF_ENGINE.getitemattrevent (itemtype      => itemtype,
                                                itemkey       => itemkey,
                                                name          => 'EVENT_MESSAGE');
      v_xml_stream := v_event_t.geteventdata ();

      --Store XML stream into a table
      INSERT INTO xxhr.xxhr_xml_wf_in
                  (itemkey, xml_stream, status, error_text,
                   created_by, creation_date, last_updated_by,
                   last_update_date, last_update_login
                  )
           VALUES (itemkey, v_xml_stream, 'NEW', NULL,
                   fnd_global.user_id, SYSDATE, fnd_global.user_id,
                   SYSDATE, fnd_global.login_id
                  );

      xml_parser := sys.xmlparser.newparser;
      sys.xmlparser.parseclob (xml_parser, v_xml_stream);
      v_xml := SYS.Xmlparser.getdocument (xml_parser);

      parse_xml_elements (p_xml                 => v_xml,
                          p_itemtype            => itemtype,
                          p_itemkey             => itemkey,
                          x_error_text          => v_error_text,
                          x_result              => v_result);

      IF v_result = gerror  THEN
         RAISE_APPLICATION_ERROR (-20100, 'Unable to Traverse XML Element');
      END IF;

      --Clear out the DOM object from memory
      SYS.XMLPARSER.freeparser (xml_parser);
      SYS.XMLDOM.freedocument (v_xml);
      
      -- Return COMPLETE result to the calling workflow
      resultout := 'COMPLETE';
   
   EXCEPTION 
     WHEN OTHERS THEN
         WF_CORE.CONTEXT ( gWorkflowItemType 
                         , procedure_name
                         , v_error_text );
                         
         v_error_text := SUBSTR ( 'ERROR:' || package_name || '.' || procedure_name || ' ' || v_error_text || SQLERRM, 2000);

         UPDATE xxhr.xxhr_xml_wf_in
            SET status = 'ERROR',
                error_text = v_error_text
          WHERE itemkey = itemkey;

         RAISE;
   END parse_and_store_xml; 
   

  FUNCTION enqueue_msg ( p_event IN VARCHAR2,
                         p_doc   IN CLOB,
                         p_agent IN VARCHAR2,
                         p_msg_text OUT VARCHAR2) RETURN NUMBER IS

        function_name		  VARCHAR2(30) := 'enqueue_msg';
        v_xml				      SYS.XMLType;
        v_EventKey			  VARCHAR2(240);
        v_parameter_list	wf_parameter_list_t;
        event  				    wf_event_t;
        agent  				    wf_agent_t;

    BEGIN

        SELECT xxhr_event_enqueue_s.nextval
        INTO   v_EventKey
        FROM   dual;

        wf_event_t.initialize(event);

        agent := wf_agent_t(p_agent, wf_event.local_system_name);

        event.Send_Date      := sysdate;
        event.Event_Name     := p_event;
        event.Event_Key      := v_eventkey;
        event.Parameter_List := v_parameter_list;
        event.to_agent       := agent;
        event.event_data     := p_doc ;
        --
        wf_event.enqueue(event,agent);

        p_msg_text := 'Successfully enqueued message';
        RETURN gSuccess;
        --
  EXCEPTION
    WHEN OTHERS THEN
        p_msg_text := function_name||' Error: Unable to enqueue message..Err Msg:'||SQLERRM;
        RETURN gError;
  END enqueue_msg;   
  
   --
   -- PROCEDURE validate_employee
   --
   -- This procudure validates if the employee number was passed in the XML payload.
   -- If the employee number is found it will then check to see if there is a current 
   -- employee record in Oracle. It is assumed that there is only 1 business group otherwise
   -- that restriction would need to be added to the emp_number_exists cursor select statement.
   --
  PROCEDURE validate_employee ( itemtype    IN              VARCHAR2,
                                itemkey     IN              VARCHAR2,
                                actid       IN              NUMBER,
                                funcmode    IN              VARCHAR2,
                                resultout   IN OUT NOCOPY   VARCHAR2) IS
                                 
    procedure_name VARCHAR2(100) := 'validate_employee'; 
    v_empno        per_all_people_f.employee_number%TYPE :=   
                         WF_ENGINE.GETITEMATTRTEXT (itemtype      => itemtype,
                                                    itemkey       => itemkey,
                                                    aname         => 'EMP_NUMBER');
                                                    
    CURSOR emp_number_exists (cp_employee_number per_all_people_f.employee_number%TYPE,
                              cp_business_group_id per_all_people_f.business_group_id%TYPE) IS
    SELECT count(*)
      FROM per_all_people_f ppf
     WHERE ppf.employee_number = cp_employee_number
       AND ppf.business_group_id = cp_business_group_id
       AND TRUNC(SYSDATE) BETWEEN ppf.effective_start_date and ppf.effective_end_date;
       
       v_emp_count NUMBER := 0;
       v_error_msg VARCHAR2(2000);
       v_business_group_id per_business_groups.business_group_id%TYPE;

  BEGIN
  
     IF (funcmode <> WF_ENGINE.eng_run) THEN
         resultout := WF_ENGINE.eng_null;
         RETURN;
     END IF;
     
     IF v_empno IS NOT NULL THEN 

       v_business_group_id := get_business_group_id;
       
       OPEN emp_number_exists (v_empno, v_business_group_id);
       FETCH emp_number_exists INTO v_emp_count;
       CLOSE emp_number_exists;
     
     END IF;

     IF v_empno IS NULL OR v_emp_count = 0 THEN 
     
        IF v_empno IS NULL THEN
          v_error_msg := 'No employee number in the XML';
        ELSE 
          v_error_msg := 'No active employee record found';
        END IF;
        
        WF_ENGINE.SETITEMATTRTEXT (itemtype      => itemtype,
                                   itemkey       => itemkey,
                                   aname         => 'ERROR_MSG',
                                   avalue        => v_error_msg);
        resultout := 'COMPLETE:FAIL';
        RETURN;
     END IF;
 
     resultout := 'COMPLETE:SUCCESS';

  EXCEPTION
    WHEN OTHERS THEN
           WF_CORE.CONTEXT ( gWorkflowItemType
                           , procedure_name
                           , 'ERROR:'||SQLERRM);
                           
    resultout := 'COMPLETE:FAIL';
    
  END;

   --
   -- PROCEDURE validate_absence_type
   --
   -- This procudure validates if the absence type was passed in the XML payload.
   -- If the absence type is found it will then check to see if it exists in Oracle. 
   -- It is assumed that there is only 1 business group otherwise
   -- that restriction would need to be added to the cursor select statement.
   --
	
  PROCEDURE validate_absence_type ( itemtype    IN              VARCHAR2,
                                    itemkey     IN              VARCHAR2,
                                    actid       IN              NUMBER,
                                    funcmode    IN              VARCHAR2,
                                    resultout   IN OUT NOCOPY   VARCHAR2) IS
                                 
    procedure_name VARCHAR2(100) := 'validate_absence_type';

    v_absence_type       per_absence_attendance_types.name%TYPE :=   
                         WF_ENGINE.GETITEMATTRTEXT (itemtype      => itemtype,
                                                    itemkey       => itemkey,
                                                    aname         => 'ABS_TYPE');
                                                    
    CURSOR absence_type_exists (cp_absence_type per_absence_attendance_types.name%TYPE,
                                cp_business_group_id per_absence_attendance_types.business_group_id%TYPE) IS
    SELECT count(*)
      FROM per_absence_attendance_types pat
     WHERE pat.name = cp_absence_type
       AND pat.business_group_id = cp_business_group_id
       AND TRUNC(SYSDATE) BETWEEN NVL(pat.date_effective, sysdate -1) AND NVL(pat.date_end, sysdate + 1);
       
    v_absence_type_count NUMBER := 0;
    v_business_group_id per_business_groups.business_group_id%TYPE;
    v_error_msg VARCHAR2(2000);
    
  BEGIN
  
     IF (funcmode <> WF_ENGINE.eng_run) THEN
         resultout := WF_ENGINE.eng_null;
         RETURN;
     END IF;
 
     IF v_absence_type IS NOT NULL THEN 
     
         v_business_group_id := get_business_group_id;

         IF v_business_group_id IS NULL THEN 
           WF_ENGINE.SETITEMATTRTEXT (itemtype      => itemtype,
                                      itemkey       => itemkey,
                                      aname         => 'ERROR_MSG',
                                      avalue        => 'No business group');
         ELSE
           WF_ENGINE.SETITEMATTRNUMBER (itemtype      => itemtype,
                                        itemkey       => itemkey,
                                        aname         => 'BUSINESS_GROUP_ID',
                                        avalue        => v_business_group_id);
         END IF;
         
         OPEN absence_type_exists (v_absence_type, v_business_group_id);
         FETCH absence_type_exists INTO v_absence_type_count;
         CLOSE absence_type_exists;
         
     END IF;

     IF v_absence_type IS NULL OR v_absence_type_count = 0 THEN 
     
        IF v_absence_type IS NULL THEN
          v_error_msg := 'No absence type in the XML';
        ELSE 
          v_error_msg := 'No active absence type record found';
        END IF;
        
        WF_ENGINE.SETITEMATTRTEXT (itemtype      => itemtype,
                                   itemkey       => itemkey,
                                   aname         => 'ERROR_MSG',
                                   avalue        => v_error_msg);
        resultout := 'COMPLETE:FAIL';
        RETURN;
     END IF;
     resultout := 'COMPLETE:SUCCESS';
     
  EXCEPTION
    WHEN OTHERS THEN
           WF_CORE.CONTEXT ( gWorkflowItemType
                           , procedure_name
                           , 'ERROR:'||SQLERRM);
                           
    resultout := 'COMPLETE:FAIL';    
  END;

   --
   -- PROCEDURE validate_absence_dates
   --
   -- This procudure validates if the absence start date was passed in the XML payload.
   -- If the absence start date exists it will then check to if there is and absence end date. 
   -- If the absence end date is not NULL it must be greater or equal to the absence start date.
   --
   
  PROCEDURE validate_absence_dates ( itemtype    IN              VARCHAR2,
                                     itemkey     IN              VARCHAR2,
                                     actid       IN              NUMBER,
                                     funcmode    IN              VARCHAR2,
                                     resultout   IN OUT NOCOPY   VARCHAR2) IS
                                      
    procedure_name VARCHAR2(100) := 'validate_absence_dates'; 
    
    v_abs_start        per_absence_attendances.date_start%TYPE :=   
                         WF_ENGINE.GETITEMATTRDATE (itemtype      => itemtype,
                                                    itemkey       => itemkey,
                                                    aname         => 'ABS_START_DATE');

    v_abs_end        per_absence_attendances.date_end%TYPE :=   
                         WF_ENGINE.GETITEMATTRDATE (itemtype      => itemtype,
                                                    itemkey       => itemkey,
                                                    aname         => 'ABS_END_DATE');
                                 
  BEGIN
  
     IF (funcmode <> WF_ENGINE.eng_run) THEN
         resultout := WF_ENGINE.eng_null;
         RETURN;
     END IF;
     
     IF v_abs_start IS NULL THEN
         WF_ENGINE.SETITEMATTRTEXT (itemtype      => itemtype,
                                    itemkey       => itemkey,
                                    aname         => 'ERROR_MSG',
                                    avalue        => 'No absence start date in the XML');
         resultout := 'COMPLETE:FAIL';
         RETURN;
     ELSIF v_abs_start > v_abs_end THEN
         WF_ENGINE.SETITEMATTRTEXT (itemtype      => itemtype,
									itemkey       => itemkey,
									aname         => 'ERROR_MSG',
									avalue        => 'Absence end date cannot be before the absence start date');
         resultout := 'COMPLETE:FAIL';
         RETURN;
     END IF;
 
     resultout := 'COMPLETE:SUCCESS';
     
  EXCEPTION
    WHEN OTHERS THEN
           WF_CORE.CONTEXT ( gWorkflowItemType
                           , procedure_name
                           , 'ERROR:'||SQLERRM);
                           
    resultout := 'COMPLETE:FAIL';  

  END;    
  
  PROCEDURE create_absence ( itemtype    IN              VARCHAR2,
                             itemkey     IN              VARCHAR2,
                             actid       IN              NUMBER,
                             funcmode    IN              VARCHAR2,
                             resultout   IN OUT NOCOPY   VARCHAR2) IS
                             
    procedure_name VARCHAR2(100) := 'create_absence'; 
    
    x_absence_days                  number;
    x_absence_hours                 number;
    x_absence_attendance_id         number;
    x_object_version_number         number;
    x_occurrence                    number;
    x_dur_dys_less_warning          boolean;
    x_dur_hrs_less_warning          boolean;
    x_exceeds_pto_entit_warning     boolean;
    x_exceeds_run_total_warning     boolean;
    x_abs_overlap_warning           boolean;
    x_abs_day_after_warning         boolean;
    x_dur_overwritten_warning       boolean;
    v_effective_date                date := hr_general.effective_date;
    v_person_id                     number;
    v_business_group_id             number := 
                         WF_ENGINE.GETITEMATTRNUMBER (itemtype      => itemtype,
                                                      itemkey       => itemkey,
                                                      aname         => 'BUSINESS_GROUP_ID');
    v_absence_attendance_type_id    number;
    v_abs_attendance_reason_id      number;
    v_date_start                    per_absence_attendances.date_start%TYPE :=   
                         WF_ENGINE.GETITEMATTRDATE (itemtype      => itemtype,
                                                    itemkey       => itemkey,
                                                    aname         => 'ABS_START_DATE');
    v_date_end                      per_absence_attendances.date_end%TYPE :=   
                         WF_ENGINE.GETITEMATTRDATE (itemtype      => itemtype,
                                                    itemkey       => itemkey,
                                                    aname         => 'ABS_END_DATE');
    v_employee_number               per_all_people_f.employee_number%TYPE :=   
                         WF_ENGINE.GETITEMATTRTEXT (itemtype      => itemtype,
                                                    itemkey       => itemkey,
                                                    aname         => 'EMP_NUMBER');
    v_absence_type       per_absence_attendance_types.name%TYPE :=   
                         WF_ENGINE.GETITEMATTRTEXT (itemtype      => itemtype,
                                                    itemkey       => itemkey,
                                                    aname         => 'ABS_TYPE');
                                                    
   v_error_text VARCHAR2 (2000);                                                    
    
    CURSOR Get_Person_Rec (cp_employee_number IN per_all_people_f.employee_number%TYPE,
                           cp_business_group_id IN per_business_groups.business_group_id%TYPE) IS
    SELECT person_id
      FROM per_all_people_f
     WHERE employee_number = cp_employee_number
       AND business_group_id = cp_business_group_id
       AND TRUNC(SYSDATE) BETWEEN effective_start_date AND effective_end_date;
       
    CURSOR Get_Absence_Type_Rec (cp_absence_type per_absence_attendance_types.name%TYPE,
                                 cp_business_group_id per_absence_attendance_types.business_group_id%TYPE) IS
    SELECT absence_attendance_type_id
      FROM per_absence_attendance_types pat
     WHERE pat.name = cp_absence_type
       AND pat.business_group_id = cp_business_group_id
       AND TRUNC(SYSDATE) BETWEEN NVL(pat.date_effective, sysdate -1) AND NVL(pat.date_end, sysdate + 1);
       
   CURSOR get_init IS
   SELECT fu.user_id, furg.responsibility_id, fr.application_id
     FROM fnd_responsibility_tl fr
    ,     fnd_user_resp_groups furg
    ,     fnd_user fu
    where fr.responsibility_name = gResponsibility
    and   fr.responsibility_id = furg.responsibility_id
    and   fr.application_id = furg.responsibility_application_id
    and   furg.user_id = fu.user_id
    and   fu.end_date is null;
    
    init_rec get_init%ROWTYPE;
  
  BEGIN
  
     IF (funcmode <> WF_ENGINE.eng_run) THEN
         resultout := WF_ENGINE.eng_null;
         RETURN;
     END IF;
     
     OPEN get_init;
     FETCH get_init INTO init_rec;
     CLOSE get_init;
     
     fnd_global.apps_initialize( user_id   => init_rec.user_id 
                               , resp_id   => init_rec.responsibility_id 
                               , resp_appl_id  => init_rec.application_id);
     
     v_business_group_id := get_business_group_id;
     
     OPEN Get_Person_Rec (v_employee_number, v_business_group_id);
     FETCH Get_Person_Rec INTO v_person_id;
     CLOSE Get_Person_Rec;

     v_business_group_id := get_business_group_id;

     OPEN Get_Absence_Type_Rec (v_absence_type, v_business_group_id);
     FETCH Get_Absence_Type_Rec INTO v_absence_attendance_type_id;
     CLOSE Get_Absence_Type_Rec;  
      
     WF_ENGINE.SETITEMATTRTEXT (itemtype      => itemtype,
                                itemkey       => itemkey,
                                aname         => 'ERROR_MSG',
                                avalue        => 'v_person_id=>'||v_person_id||' '||
                                                 'v_business_group_id=>'||v_business_group_id||' '||
                                                 'v_absence_attendance_type_id=>'||v_absence_attendance_type_id); 
                                    
    hr_person_absence_api.create_person_absence
                        (p_effective_date                => v_effective_date
                        ,p_person_id                     => v_person_id
                        ,p_business_group_id             => v_business_group_id
                        ,p_absence_attendance_type_id    => v_absence_attendance_type_id
                        ,p_abs_attendance_reason_id      => v_abs_attendance_reason_id
                        ,p_date_start                    => v_date_start
                        ,p_date_end                      => v_date_end
                        ,p_absence_days                  => x_absence_days
                        ,p_absence_hours                 => x_absence_hours
                        ,p_absence_attendance_id         => x_absence_attendance_id 
                        ,p_object_version_number         => x_object_version_number
                        ,p_occurrence                    => x_occurrence
                        ,p_dur_dys_less_warning          => x_dur_dys_less_warning
                        ,p_dur_hrs_less_warning          => x_dur_hrs_less_warning
                        ,p_exceeds_pto_entit_warning     => x_exceeds_pto_entit_warning
                        ,p_exceeds_run_total_warning     => x_exceeds_run_total_warning 
                        ,p_abs_overlap_warning           => x_abs_overlap_warning
                        ,p_abs_day_after_warning         => x_abs_day_after_warning
                        ,p_dur_overwritten_warning       => x_dur_overwritten_warning);

      -- Return COMPLETE result to the calling workflow
      resultout := 'COMPLETE';
   
   EXCEPTION 
     WHEN OTHERS THEN
         WF_CORE.CONTEXT ( gWorkflowItemType 
                         , procedure_name
                         , SQLERRM );
         resultout := 'FAIL';
                         
  END;
  

END XXHR_ABSENCE_IN_WF_PKG;