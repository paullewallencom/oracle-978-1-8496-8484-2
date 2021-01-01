#!/bin/ksh

## ++++++++++++++++++++++++++++++++++++++++++++++
##
## FNDLOAD Download Script
##
## Usage 
## -----
## UNIX> fndload_download.sh <apps_pwd>
##
## Parameter $1 is the apps password
##
## ++++++++++++++++++++++++++++++++++++++++++++++

## Lookups

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/aflvmlu.lct LU_XXHR_SOCIETY_LOV.ldt FND_LOOKUP_TYPE APPLICATION_SHORT_NAME='XXHR' LOOKUP_TYPE='XXHR_SOCIETY_LOV'

## Descriptive Flexfields

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/afffload.lct DFF_XXHR_PER_SOCIETIES.ldt DESC_FLEX APPLICATION_SHORT_NAME='XXHR' DESCRIPTIVE_FLEXFIELD_NAME='XXHR_PER_SOCIETIES'

## Concurrent Programs

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/afcpprog.lct CP_XXHR_FIRST_CONC_PROG.ldt PROGRAM APPLICATION_SHORT_NAME="XXHR" CONCURRENT_PROGRAM_NAME="XXHR_FIRST_CONC_PROG"

## Request Sets and Request Set Links

FNDLOAD apps/$1 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcprset.lct RS_XXHR20001.ldt REQ_SET REQUEST_SET_NAME="FNDRSSUB3714"
FNDLOAD apps/$1 0 Y DOWNLOAD $FND_TOP/patch/115/import/afcprset.lct RSL_XXHR20001.ldt REQ_SET_LINKS REQUEST_SET_NAME="FNDRSSUB3714" 

## Profile Options

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/afscprof.lct PROF_XXHR_WRITE_LOGFILE.ldt PROFILE PROFILE_NAME="XXHR_WRITE_LOGFILE" APPLICATION_SHORT_NAME="XXHR"

## Forms and Form Functions

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/afsload.lct FORM_XXHRSOCC.ldt FORM FORM_APP_SHORT_NAME='XXHR' FORM_NAME='XXHRSOCC'
FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/afsload.lct FUNC_XXHR_EMP_SOCIETY.ldt FUNCTION FUNC_APP_SHORT_NAME='XXHR' FUNCTION_NAME='XXHR_EMP_SOCIETY'

## Menus

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/afsload.lct MENU_XXHR_TEST_MENU.ldt MENU MENU_NAME="XXHR_TEST_MENU"

## Request Groups

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/afcpreqg.lct RG_XXHR_REQUEST_GROUP.ldt REQUEST_GROUP REQUEST_GROUP_NAME"XXHR_REQUEST_GROUP" APPLICATION_SHORT_NAME="XXHR"

## Responsibilities

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/afscursp.lct RESP_XXHR_ADMIN.ldt FND_RESPONSIBILITY RESP_KEY="XXHR_ADMIN"

## Personzlizations

FNDLOAD apps/$1 O Y DOWNLOAD $FND_TOP/patch/115/import/affrmcus.lct PZ_PERWSHRG.ldt FND_FORM_CUSTOM_RULES FORM_NAME="PERWSHRG"

