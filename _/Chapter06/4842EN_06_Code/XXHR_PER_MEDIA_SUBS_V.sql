-----------------------------------------------------------------------------------------------------
--
--            NAME:   XXHR_PER_MEDIA_SUBS _V
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
CREATE OR REPLACE VIEW APPS.XXHR_PER_MEDIA_SUBS_V (MEDIA_SUBS_ID, CODE, NAME, DATE_START, DATE_END, DELIVERY_METHOD, ATTRIBUTE_CATEGORY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20, LAST_UPDATE_DATE, LAST_UPDATED_BY, LAST_UPDATE_LOGIN, CREATED_BY, CREATION_DATE, PERSON_ID)
AS
  SELECT xpms.MEDIA_SUBS_ID,
    xpms.CODE,
    flv.MEANING,
    xpms.DATE_START,
    xpms.DATE_END,
    xpms.DELIVERY_METHOD,
    xpms.ATTRIBUTE_CATEGORY,
    xpms.ATTRIBUTE1,
    xpms.ATTRIBUTE2,
    xpms.ATTRIBUTE3,
    xpms.ATTRIBUTE4,
    xpms.ATTRIBUTE5,
    xpms.ATTRIBUTE6,
    xpms.ATTRIBUTE7,
    xpms.ATTRIBUTE8,
    xpms.ATTRIBUTE9,
    xpms.ATTRIBUTE10,
    xpms.ATTRIBUTE11,
    xpms.ATTRIBUTE12,
    xpms.ATTRIBUTE13,
    xpms.ATTRIBUTE14,
    xpms.ATTRIBUTE15,
    xpms.ATTRIBUTE16,
    xpms.ATTRIBUTE17,
    xpms.ATTRIBUTE18,
    xpms.ATTRIBUTE19,
    xpms.ATTRIBUTE20,
    xpms.LAST_UPDATE_DATE,
    xpms.LAST_UPDATED_BY,
    xpms.LAST_UPDATE_LOGIN,
    xpms.CREATED_BY,
    xpms.CREATION_DATE,
	xpms.PERSON_ID
  FROM XXHR_PER_MEDIA_SUBS xpms
    , fnd_lookup_values flv
  WHERE xpms.code = flv.lookup_code (+)
    AND flv.lookup_type = 'XXHR_SUBS_LOV';