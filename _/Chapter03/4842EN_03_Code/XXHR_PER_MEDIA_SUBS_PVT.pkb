CREATE OR REPLACE PACKAGE body XXHR_PER_MEDIA_SUBS_PVT IS
-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_PER_MEDIA_SUBS_PVT
--            TYPE:   Package Body
-- ORIGINAL AUTHOR:   Andy Penver
--            DATE:   16/07/2011
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
-----------------------------------------------------------------------------------------------------
      -- insert
      PROCEDURE insert_row (  P_MEDIA_SUBS_ID IN XXHR_PER_MEDIA_SUBS.MEDIA_SUBS_ID%TYPE ,
                              P_CODE IN XXHR_PER_MEDIA_SUBS.CODE%TYPE ,
                              P_DATE_START IN XXHR_PER_MEDIA_SUBS.DATE_START%TYPE,
                              p_date_end in xxhr_per_media_subs.date_end%type ,
                              P_DELIVERY_METHOD IN XXHR_PER_MEDIA_SUBS.DELIVERY_METHOD%TYPE ,
                              P_ATTRIBUTE_CATEGORY IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE_CATEGORY%TYPE ,
                              P_ATTRIBUTE1 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE3%TYPE ,
                              P_ATTRIBUTE2 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE2%TYPE ,
                              P_ATTRIBUTE3 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE1%TYPE ,
                              P_ATTRIBUTE4 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE4%TYPE ,
                              P_ATTRIBUTE5 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE5%TYPE ,
                              P_ATTRIBUTE6 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE6%TYPE ,            
                              P_ATTRIBUTE7 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE7%TYPE ,
                              P_ATTRIBUTE8 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE8%TYPE ,
                              P_ATTRIBUTE9 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE9%TYPE ,
                              P_ATTRIBUTE10 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE10%TYPE ,
                              P_ATTRIBUTE11 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE13%TYPE ,
                              P_ATTRIBUTE12 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE14%TYPE ,
                              P_ATTRIBUTE13 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE11%TYPE ,
                              P_ATTRIBUTE14 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE12%TYPE ,
                              P_ATTRIBUTE15 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE15%TYPE ,
                              P_ATTRIBUTE16 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE16%TYPE ,
                              P_ATTRIBUTE17 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE17%TYPE,
                              P_ATTRIBUTE18 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE18%TYPE ,
                              P_ATTRIBUTE19 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE19%TYPE ,  
                              P_ATTRIBUTE20 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE20%TYPE ,
                              P_CREATED_BY IN XXHR_PER_MEDIA_SUBS.CREATED_BY%TYPE ,
                              P_CREATION_DATE IN XXHR_PER_MEDIA_SUBS.CREATION_DATE%TYPE ,
                              P_LAST_UPDATE_DATE IN XXHR_PER_MEDIA_SUBS.LAST_UPDATE_DATE%TYPE ,
                              P_LAST_UPDATED_BY IN XXHR_PER_MEDIA_SUBS.LAST_UPDATED_BY%TYPE ,
                              P_LAST_UPDATE_LOGIN IN XXHR_PER_MEDIA_SUBS.LAST_UPDATE_LOGIN%TYPE ,
                              P_PERSON_ID IN XXHR_PER_MEDIA_SUBS.PERSON_ID%type) IS
        
        l_media_subs_id XXHR_PER_MEDIA_SUBS.MEDIA_SUBS_ID%TYPE;
     BEGIN
	  -- Create a unique sequence number for the MEDIA_SUBS_ID
      SELECT XXHR_PER_MEDIA_SUBS_SEQ.NEXTVAL 
      INTO l_media_subs_id
      FROM dual;
	  
	  -- INSERT into the XXGR_PER_MEDIA_SUBS table      
      INSERT INTO  XXHR_PER_MEDIA_SUBS( MEDIA_SUBS_ID,
                                        CODE, 
                                        DATE_END,
                                        DATE_START, 
                                        DELIVERY_METHOD,
                                        PERSON_ID,
                                        ATTRIBUTE_CATEGORY, 
                                        ATTRIBUTE1,  
                                        ATTRIBUTE2,  
                                        ATTRIBUTE3, 
                                        ATTRIBUTE4, 
                                        ATTRIBUTE5,
                                        ATTRIBUTE6,
                                        ATTRIBUTE7,
                                        ATTRIBUTE8,
                                        ATTRIBUTE9, 
                                        ATTRIBUTE10, 
                                        ATTRIBUTE11,
                                        ATTRIBUTE12, 
                                        ATTRIBUTE13,   
                                        ATTRIBUTE14,  
                                        ATTRIBUTE15,    
                                        ATTRIBUTE16,
                                        ATTRIBUTE17,
                                        ATTRIBUTE18,
                                        ATTRIBUTE19, 
                                        ATTRIBUTE20,
                                        CREATION_DATE,    
                                        CREATED_BY,
                                        LAST_UPDATE_DATE,
                                        LAST_UPDATED_BY,
                                        LAST_UPDATE_LOGIN)
                                        VALUES (
                                        l_media_subs_id,
                                        P_CODE, 
                                        P_DATE_END,
                                        P_DATE_START, 
                                        P_DELIVERY_METHOD,
                                        P_PERSON_ID,
                                        P_ATTRIBUTE_CATEGORY, 
                                        P_ATTRIBUTE1,  
                                        P_ATTRIBUTE2,  
                                        P_ATTRIBUTE3, 
                                        P_ATTRIBUTE4, 
                                        P_ATTRIBUTE5,
                                        P_ATTRIBUTE6,
                                        P_ATTRIBUTE7,
                                        P_ATTRIBUTE8,
                                        P_ATTRIBUTE9, 
                                        P_ATTRIBUTE10, 
                                        P_ATTRIBUTE11,
                                        P_ATTRIBUTE12, 
                                        P_ATTRIBUTE13,   
                                        P_ATTRIBUTE14,  
                                        P_ATTRIBUTE15,    
                                        P_ATTRIBUTE16,
                                        P_ATTRIBUTE17,
                                        P_ATTRIBUTE18,
                                        P_ATTRIBUTE19, 
                                        P_ATTRIBUTE20,
                                        P_CREATION_DATE,    
                                        P_CREATED_BY,
                                        P_LAST_UPDATE_DATE,
                                        P_LAST_UPDATED_BY,
                                        P_LAST_UPDATE_LOGIN);
        commit;
    END;
          -- update
   PROCEDURE update_row ( P_MEDIA_SUBS_ID IN XXHR_PER_MEDIA_SUBS.MEDIA_SUBS_ID%TYPE ,
                          P_CODE IN XXHR_PER_MEDIA_SUBS.CODE%TYPE ,
                          P_DATE_START IN XXHR_PER_MEDIA_SUBS.DATE_START%TYPE,
                          p_date_end in xxhr_per_media_subs.date_end%type ,
                          P_DELIVERY_METHOD IN XXHR_PER_MEDIA_SUBS.DELIVERY_METHOD%TYPE ,
                          P_ATTRIBUTE_CATEGORY IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE_CATEGORY%TYPE ,
                          P_ATTRIBUTE1 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE3%TYPE ,
                          P_ATTRIBUTE2 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE2%TYPE ,
                          P_ATTRIBUTE3 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE1%TYPE ,
                          P_ATTRIBUTE4 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE4%TYPE ,
                          P_ATTRIBUTE5 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE5%TYPE ,
                          P_ATTRIBUTE6 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE6%TYPE ,            
                          P_ATTRIBUTE7 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE7%TYPE ,
                          P_ATTRIBUTE8 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE8%TYPE ,
                          P_ATTRIBUTE9 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE9%TYPE ,
                          P_ATTRIBUTE10 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE10%TYPE ,
                          P_ATTRIBUTE11 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE13%TYPE ,
                          P_ATTRIBUTE12 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE14%TYPE ,
                          P_ATTRIBUTE13 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE11%TYPE ,
                          P_ATTRIBUTE14 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE12%TYPE ,
                          P_ATTRIBUTE15 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE15%TYPE ,
                          P_ATTRIBUTE16 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE16%TYPE ,
                          P_ATTRIBUTE17 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE17%TYPE,
                          P_ATTRIBUTE18 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE18%TYPE ,
                          P_ATTRIBUTE19 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE19%TYPE ,  
                          P_ATTRIBUTE20 IN XXHR_PER_MEDIA_SUBS.ATTRIBUTE20%TYPE ,
                          P_CREATED_BY IN XXHR_PER_MEDIA_SUBS.CREATED_BY%TYPE ,
                          P_CREATION_DATE IN XXHR_PER_MEDIA_SUBS.CREATION_DATE%TYPE ,
                          P_LAST_UPDATE_DATE IN XXHR_PER_MEDIA_SUBS.LAST_UPDATE_DATE%TYPE ,
                          P_LAST_UPDATED_BY IN XXHR_PER_MEDIA_SUBS.LAST_UPDATED_BY%TYPE ,
                          P_LAST_UPDATE_LOGIN IN XXHR_PER_MEDIA_SUBS.LAST_UPDATE_LOGIN%TYPE ,
                          P_PERSON_ID IN XXHR_PER_MEDIA_SUBS.PERSON_ID%type) IS
    BEGIN
	  -- UPDATE the XXGR_PER_MEDIA_SUBS table
      UPDATE XXHR_PER_MEDIA_SUBS
      SET CODE = p_code, 
          DATE_END = p_date_end,
          DATE_START = p_date_start, 
          DELIVERY_METHOD =  p_delivery_method,
          PERSON_ID = p_person_id,
          ATTRIBUTE_CATEGORY = p_attribute_category, 
          ATTRIBUTE1 = p_attribute1,  
          ATTRIBUTE2 = p_attribute2,    
          ATTRIBUTE3 = p_attribute3,   
          ATTRIBUTE4 = p_attribute4,  
          ATTRIBUTE5 = p_attribute5,  
          ATTRIBUTE6 = p_attribute6,  
          ATTRIBUTE7 = p_attribute7,  
          ATTRIBUTE8 = p_attribute8,  
          ATTRIBUTE9 = p_attribute9,   
          ATTRIBUTE10 = p_attribute10,  
          ATTRIBUTE11 = p_attribute11,  
          ATTRIBUTE12 = p_attribute12,  
          ATTRIBUTE13 = p_attribute13,     
          ATTRIBUTE14 = p_attribute14,    
          attribute15 = p_attribute15,      
          ATTRIBUTE16 = p_attribute16,  
          ATTRIBUTE17 = p_attribute17,  
          ATTRIBUTE18 = p_attribute18,  
          ATTRIBUTE19 = p_attribute19,  
          ATTRIBUTE20 = p_attribute20,  
          CREATION_DATE = p_creation_date,      
          CREATED_BY = p_created_by,  
          LAST_UPDATE_DATE = p_last_update_date,  
          LAST_UPDATED_BY = p_last_updated_by,  
          LAST_UPDATE_LOGIN = p_last_update_login
      WHERE MEDIA_SUBS_ID = p_MEDIA_SUBS_ID;
      
      commit;
    END;
    -- del
    PROCEDURE delete_row(p_media_subs_id IN XXHR_PER_MEDIA_SUBS.MEDIA_SUBS_ID%type ) IS
    begin
	  -- DELETE from the XXHR_PER_MEDIA_SUBS table
      DELETE FROM XXHR_PER_MEDIA_SUBS
      WHERE MEDIA_SUBS_ID = p_media_subs_id;
      
      commit;
    END;
END XXHR_PER_MEDIA_SUBS_PVT;
