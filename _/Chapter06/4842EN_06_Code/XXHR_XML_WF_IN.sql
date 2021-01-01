-----------------------------------------------------------------------------------------------------
--
--            NAME:   xxhr_xml_wf_in
--            TYPE:   Create Table Script
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2011
--
--     DESCRIPTION:
--
--        This creates a table for use with my book
--        Extending Oracle E-Business Suite Release 12.
--
--
--  CHANGE HISTORY:
--
--     VERSION  DATE          AUTHOR           LABEL     DESCRIPTION
--     -------  --------      -------------    --------  --------------------------------------------
--     1.0      17/07/2011    Andy Penver      N/A       Initial Version
-----------------------------------------------------------------------------------------------------
CREATE TABLE XXHR.xxhr_xml_wf_in 
  ( ITEMKEY 	       NUMBER NOT NULL ENABLE,
    XML_STREAM         CLOB NOT NULL ENABLE,
    STATUS 		       VARCHAR2(10),
    ERROR_TEXT 		   VARCHAR2(2000),
    LAST_UPDATE_DATE   DATE,
    LAST_UPDATED_BY    NUMBER(15,0),
    LAST_UPDATE_LOGIN  NUMBER(15,0),
    CREATED_BY         NUMBER(15,0),
    CREATION_DATE 	 DATE
  )
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING STORAGE
  (
    INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645 PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT
  )
  TABLESPACE XXHR ;