CREATE OR REPLACE PACKAGE BODY APPS.XXHR_EMAIL_FILE_PKG IS

---------------------------------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_EMAIL_FILE_PKG
--            TYPE:   Package Body
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   05/01/2012
--
--     DESCRIPTION:
--
--        This package comprises of all the API's related to file generation
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  ------------- ---------------- --------  -------------------------------------------------------------------
--     1.0      05/01/2012    Andy Penver      N/A       Initial Version
----------------------------------------------------------------------------------------------------------------------------

   -- Global Constants
   gc_success             NUMBER   := 0;
   gc_warning             NUMBER   := 1;
   gc_failed              NUMBER   := 2;
   gc_error               NUMBER   := 3;

   -- Global Variables
   gv_user_id             NUMBER        := -1;
   gv_login_id            NUMBER        := -1;


   -- -------------------------------------------------------------------------
   -- PROCEDURE: generate_xml
   -- -------------------------------------------------------------------------
   --
   -- This procedure will generate a dummy XML message for a given employee
   -- -------------------------------------------------------------------------
   
   PROCEDURE generate_xml(p_xml_message OUT CLOB
                         ,p_result      OUT NUMBER
                         ,p_message     OUT VARCHAR2)
   IS
   
      lv_proc_name      CONSTANT VARCHAR2(100) := 'generate_xml';
      
  
   BEGIN
   
      FND_FILE.put_line(fnd_file.log,lv_proc_name||'Entering');
      
      -- Create XML message
      p_xml_message := '<NotificationSet>'||chr(13);
      p_xml_message := p_xml_message||'  <EmployeeNumber>'||'11'||'</EmployeeNumber>'||chr(13);
      p_xml_message := p_xml_message||'  <EmployeeFirstName>'||'Andy'||'</EmployeeFirstName>'||chr(13);
      p_xml_message := p_xml_message||'  <EmployeeLastName>'||'Penver'||'</EmployeeLastName>'||chr(13);
      p_xml_message := p_xml_message||'</NotificationSet>';
      
      p_result  := gc_success;
      p_message := 'XML Generated successfully';
      
      FND_FILE.put_line(fnd_file.log,lv_proc_name||'p_result  : '||p_result);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||'p_message : '||p_message);
   
   EXCEPTION WHEN OTHERS THEN
         p_result  := gc_error;
         p_message := 'Unexpected error '||SQLERRM;
         FND_FILE.put_line(fnd_file.log,lv_proc_name||' OTHER exception'||SQLERRM);
  
   END generate_xml;

   
   -- -------------------------------------------------------------------------
   -- PROCEDURE: create_xml_file
   -- -------------------------------------------------------------------------
   --
   -- This procedure will generate the ORT XML file on the server
   -- -------------------------------------------------------------------------
   
   PROCEDURE create_xml_file(p_xml_msg   IN  CLOB
                            ,p_directory OUT VARCHAR2
                            ,p_filename  OUT VARCHAR2
                            ,p_result    OUT NUMBER
                            ,p_message   OUT VARCHAR2) IS
      
      CURSOR c_xml_batch_sequence
      IS
      SELECT xxcsc_xml_batch_seq.NEXTVAL
      FROM   dual;
      
      CURSOR c_directory_path
      IS
      SELECT directory_path
      FROM   dba_directories
      WHERE  directory_name = 'XXHR_XML_OUT';
      
      fHandle           UTL_FILE.FILE_TYPE;
      
      lv_proc_name      CONSTANT VARCHAR2(100) := 'create_xml_file';
      lv_dir_path       VARCHAR2(1000);
      lv_filename       VARCHAR2(250);
      lv_xml_batch_n    NUMBER;
      lv_buffer         VARCHAR2(4000);
   
   BEGIN
   
      p_result   := gc_success;
      p_message  := 'XML File created successfully';
      
      -- Generate the XML filename
      -- Format: Notification_n_YYYYMMDD_HH24MISS.xml (n = unique number incrementing from 1)
      
      -- First get the next XML batch sequence number
      OPEN c_xml_batch_sequence;
      FETCH c_xml_batch_sequence INTO lv_xml_batch_n;
      CLOSE c_xml_batch_sequence;
      
      FND_FILE.put_line(fnd_file.log,lv_proc_name||'XML batch number : '||TO_CHAR(NVL(lv_xml_batch_n,0)));
      
      -- Create filename
      lv_filename := 'XXHR_FILE_'||TO_CHAR(NVL(lv_xml_batch_n,0))||'_'||TO_CHAR(SYSDATE,'YYYYMMDD_HH24MISS')||'.xml';
      
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Getting directory path for '||lv_filename);
      
      -- Get dir path
      OPEN c_directory_path;
      FETCH c_directory_path INTO lv_dir_path;
      CLOSE c_directory_path;
      
      -- Set OUT parameters
      p_directory := lv_dir_path;
      p_filename  := lv_filename;
      
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Directory Path : '||lv_dir_path);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Filename: '||lv_filename);
      
      fHandle := UTL_FILE.FOPEN(lv_dir_path,lv_filename,'W',4000);

      lv_buffer := dbms_lob.substr(p_xml_msg||'\n',3999,1);
        
      -- Write XML to a file
       
      UTL_FILE.PUTF(fHandle,lv_buffer);
     
      UTL_FILE.FCLOSE(fHandle);
      
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' p_result  : '||p_result);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' p_message : '||p_message);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Leaving');
   
   EXCEPTION
      WHEN OTHERS THEN
         p_result  := gc_error;
         p_message := lv_proc_name||' Unexpected error '||SQLERRM;
         FND_FILE.put_line(fnd_file.log,lv_proc_name||' OTHER exception'||SQLERRM);
   
   END create_xml_file;



   -- -------------------------------------------------------------------------
   -- PROCEDURE: email_xml_file
   -- -------------------------------------------------------------------------
   --
   -- This procedure will email the specified XML file to nominated recipients
   -- (adapted from HR HRe Payroll Interface email file)
   -- -------------------------------------------------------------------------
   
   PROCEDURE email_xml_file( p_directory   IN VARCHAR2
                            ,p_filename    IN VARCHAR2
                            ,p_subject     IN VARCHAR2
                            ,p_email_to    IN VARCHAR2
                            ,p_result      OUT NUMBER
                            ,p_message     OUT VARCHAR2)
   IS
      
      lv_proc_name      CONSTANT VARCHAR2(100) := 'email_xml_file';
      lv_submit_request	VARCHAR2(50);

   BEGIN

      p_result  := gc_success;
      p_message := 'XML File emailed successfully';
      
     
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Directory Path : '||p_directory);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Submit Conc Prog : '||chr(10)||
                                                   '   application => XXHR'||chr(10)||
                                                   '   program     => XXHR_GEN_EMAIL_FILE'||chr(10)||
                                                   '   argument1   => '||p_subject||chr(10)||
                                                   '   argument2   => '||p_email_to||chr(10)||
                                                   '   argument3   => '||p_filename||chr(10)||
                                                   '   argument4   => '||p_directory||chr(10)||
                                                   '   argument5   => '||null);
      
      -- Submit email Conc Prog
      lv_submit_request := fnd_request.submit_request(application => 'XXHR'
                                                     ,program     => 'XXHR_GEN_EMAIL_FILE'
                                                     ,description =>  NULL
                                                     ,start_time  =>  NULL
                                                     ,sub_request =>  FALSE
                                                     ,argument1   =>  p_subject
                                                     ,argument2   =>  p_email_to
                                                     ,argument3   =>  p_filename
                                                     ,argument4   =>  p_directory
                                                     ,argument5   =>  null);
                                                     
      p_result := lv_submit_request;
      
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' p_result  : '||p_result);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' p_message : '||p_message);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Leaving');
   
   EXCEPTION
      WHEN OTHERS THEN
         p_result  := gc_error;
         p_message := lv_proc_name||' Unexpected error '||SQLERRM;
         FND_FILE.put_line(fnd_file.log,lv_proc_name||' OTHER exception'||SQLERRM);
   END email_xml_file;
   
   -- -------------------------------------------------------------------------
   -- PROCEDURE: process_main
   -- -------------------------------------------------------------------------
   --
   -- This procedure will process a collection of transformation records that
   -- are waiting to have ORT Opt In / Out Notifications generated
   -- -------------------------------------------------------------------------
   
   PROCEDURE process_main (p_errbuf            OUT VARCHAR2
                          ,p_retcode           OUT NUMBER
                          ,p_subject           IN VARCHAR2
                          ,p_email_to          IN VARCHAR2)
   IS
   
      lv_proc_name            CONSTANT VARCHAR2(100) := 'process_main';
      
      lv_xml_message          CLOB;
      
      lv_success_count        NUMBER := 0;
      lv_warning_count        NUMBER := 0;
      lv_error_count          NUMBER := 0;
      
      lv_pon_compl_warning    BOOLEAN := FALSE;
      lv_pon_compl_failed     BOOLEAN := FALSE;
      lv_pon_compl_error      BOOLEAN := FALSE;
      
      lv_notif_result         NUMBER;
      lv_buffer               VARCHAR2(1000);
      lv_val_proc_return      VARCHAR2(20);
      lv_val_debug_level      VARCHAR2(1);
      lv_val_eff_date         VARCHAR2(20);
      lv_val_bg_id            VARCHAR2(5);
      lv_val_valid_count      NUMBER := 0;
      lv_val_warning_count    NUMBER := 0;
      lv_val_error_count      NUMBER := 0;
      lv_gen_xml_result       NUMBER;
      lv_gen_xml_message      VARCHAR2(1000);
      lv_g_number             NUMBER;
      lv_mrr_result           NUMBER;
      lv_mrr_message          VARCHAR2(1000);
      lv_mdh_result           NUMBER;
      lv_mdh_message          VARCHAR2(1000);
      lv_cxf_directory        VARCHAR2(100);
      lv_cxf_filename         VARCHAR2(100);
      lv_cxf_result           NUMBER;
      lv_cxf_message          VARCHAR2(1000);
      lv_exf_result           NUMBER;
      lv_exf_message          VARCHAR2(1000);
   
   BEGIN

      -- Set Globals
      gv_user_id         := NVL(fnd_profile.value('USER_ID'),-1);
      gv_login_id        := NVL(fnd_profile.value('LOGIN_ID'),-1);
      
      FND_FILE.put_line(fnd_file.output, lv_proc_name||' : '||TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS'));
      
      -- +++++++++++++++++++++++++++++++++++
      --
      -- GENERATE XML 
      -- 
      -- +++++++++++++++++++++++++++++++++++
               
      generate_xml(p_xml_message => lv_xml_message
                  ,p_result      => lv_gen_xml_result
                  ,p_message     => lv_gen_xml_message);

      -- +++++++++++++++++++++++++++++++++++++
      --
      -- CREATE XML FILE ON THE SERVER
      -- 
      -- +++++++++++++++++++++++++++++++++++++
         
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Before Create XML File');
      
      create_xml_file(p_xml_msg   => lv_xml_message
                     ,p_directory => lv_cxf_directory
                     ,p_filename  => lv_cxf_filename
                     ,p_result    => lv_cxf_result
                     ,p_message   => lv_cxf_message);
         
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' After Create XML File');
           
      -- +++++++++++++++++++++++++++++++++++++++++++++++
      --
      -- EMAIL XML FILE IF FILE CREATED
      --
      -- +++++++++++++++++++++++++++++++++++++++++++++++
      
      IF lv_cxf_result = gc_success THEN
         
         FND_FILE.put_line(fnd_file.log,lv_proc_name|| 'Before Email XML File');
         
         email_xml_file(p_directory => lv_cxf_directory
                       ,p_filename  => lv_cxf_filename
                       ,p_subject   => p_subject
                       ,p_email_to  => p_email_to
                       ,p_result    => lv_exf_result
                       ,p_message   => lv_exf_message);     
                            
         FND_FILE.put_line(fnd_file.log,lv_proc_name|| 'After Email XML File');
         
      END IF;
      
      -- +++++++++++++++++++++++++++++++++++++
      --
      -- SET COMPLETION PARAMETERS
      -- 
      -- +++++++++++++++++++++++++++++++++++++

      IF lv_exf_result = 1 THEN
         p_retcode := gc_warning;
         p_errbuf  := 'Completion Status: WARNING';
      ELSIF lv_exf_result = 0 THEN
         p_retcode := gc_success;
         p_errbuf  := 'Completion Status: SUCCESS';
      ELSIF lv_exf_result = 2 THEN
         p_retcode := gc_error;
         p_errbuf  := 'Completion Status: FAIL';         
      END IF;

      FND_FILE.put_line(fnd_file.log,lv_proc_name||' p_retcode : '||p_retcode);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' p_errbuf  : '||p_errbuf);
      FND_FILE.put_line(fnd_file.log,lv_proc_name||' Leaving : '||TO_CHAR(SYSDATE,'DD-MON-YYYY HH24:MI:SS'));
   
   EXCEPTION
      WHEN OTHERS THEN
         p_retcode  := gc_failed;
         p_errbuf   := 'Unexpected Exception : '||SQLERRM;
         FND_FILE.put_line(fnd_file.log,lv_proc_name||' OTHER exception'||SQLERRM);
   
   END process_main;   
   
end XXHR_EMAIL_FILE_PKG; 
/

