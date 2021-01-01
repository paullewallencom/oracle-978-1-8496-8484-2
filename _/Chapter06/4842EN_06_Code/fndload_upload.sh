#!/bin/ksh

## ++++++++++++++++++++++++++++++++++++++++++++++
##
## FNDLOAD Upload Script
##
## Usage 
## -----
## UNIX> fndload_upload.sh <apps_pwd>
##
## Parameter $1 is the apps password
##
## ++++++++++++++++++++++++++++++++++++++++++++++

## Lookups

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/aflvmlu.lct LU_XXHR_SOCIETY_LOV.ldt

## Descriptive Flexfields

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/afffload.lct DFF_XXHR_PER_SOCIETIES.ldt

## Concurrent Programs

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/afcpprog.lct CP_XXHR_FIRST_CONC_PROG.ldt

## Request Sets and Request Set Links

FNDLOAD apps/$1 0 Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct RS_XXHR20001.ldt
FNDLOAD apps/$1 0 Y UPLOAD $FND_TOP/patch/115/import/afcprset.lct RSL_XXHR20001.ldt

## Profile Options

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/afscprof.lct PROF_XXHR_WRITE_LOGFILE.ldt

## Forms and Form Functions

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/afsload.lct FORM_XXHRSOCC.ldt
FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/afsload.lct FUNC_XXHR_EMP_SOCIETY.ldt

## Menus

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/afsload.lct MENU_XXHR_TEST_MENU.ldt

## Request Groups

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/afcpreqg.lct RG_XXHR_REQUEST_GROUP.ldt

## Responsibilities

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/afscursp.lct RESP_XXHR_ADMIN.ldt

## Personzlizations

FNDLOAD apps/$1 O Y UPLOAD $FND_TOP/patch/115/import/affrmcus.lct PZ_PERWSHRG.ldt

