create or replace
PROCEDURE   PS.CAS_EC_CODE_SYNC_PROC AS
BEGIN

-- GRAB CODE DEFINITIONS FROM ENTERPRISE CONTROLLER
MERGE INTO PS.gen lg
USING (SELECT cat, name, value, sortorder, value2, valueli, valueli2, valuer, valueli3, valuer2, date_value, date2, time1, time2, spedindicator, yearid
  FROM gen@DBL_ENTCON
  WHERE cat IN ('codedefs','entrycodes','exitcodes','federalrace','race','subtype','ethnicity','logentrycodes','logtype')) rg
  ON (lg.cat = rg.cat
  AND lg.name = rg.name)
WHEN NOT MATCHED THEN
  INSERT (lg.dcid, lg.id, lg.cat, lg.name, lg.value, lg.sortorder, lg.value2, lg.valueli, lg.valueli2, lg.valuer, lg.valueli3, lg.valuer2, lg.date_value, lg.date2, lg.time1, lg.time2, lg.spedindicator, lg.yearid)
  VALUES (gen_dcid_sq.nextval, gen_id_sq.nextval, rg.cat, rg.name, rg.value, rg.sortorder, rg.value2, rg.valueli, rg.valueli2, rg.valuer, rg.valueli3, rg.valuer2, rg.date_value, rg.date2, rg.time1, rg.time2, rg.spedindicator, rg.yearid)
WHEN MATCHED THEN
  UPDATE SET
  lg.value = rg.value, 
  lg.sortorder = rg.sortorder, 
  lg.value2 = rg.value2, 
  lg.valueli = rg.valueli, 
  lg.valueli2 = rg.valueli2, 
  lg.valuer = rg.valuer, 
  lg.valueli3 = rg.valueli3, 
  lg.valuer2 = rg.valuer2, 
  lg.date_value = rg.date_value, 
  lg.date2 = rg.date2, 
  lg.time1 = rg.time1, 
  lg.time2 = rg.time2, 
  lg.spedindicator = rg.spedindicator, 
  lg.yearid = rg.yearid;
-- GRAB CODES FROM ENTERPRISE CONTROLLER
MERGE INTO PS.gen lg
USING (SELECT cat, name, value, sortorder, value2, valueli, valueli2, valuer, valueli3, valuer2, date_value, date2, time1, time2, spedindicator, yearid
  FROM gen@DBL_ENTCON
  WHERE cat IN (SELECT g2.name FROM gen@dbl_entcon g2 WHERE g2.cat='codedefs')
  )  rg
  ON (lg.cat = rg.cat
  AND lg.name = rg.name)
WHEN NOT MATCHED THEN
  INSERT (lg.dcid, lg.id, lg.cat, lg.name, lg.value, lg.sortorder)
  VALUES (gen_dcid_sq.nextval, gen_id_sq.nextval, rg.cat, rg.name, rg.value, rg.sortorder)
WHEN MATCHED THEN
  UPDATE SET
  lg.value = rg.value, 
  lg.sortorder = rg.sortorder, 
  lg.value2 = rg.value2, 
  lg.valueli = rg.valueli, 
  lg.valueli2 = rg.valueli2, 
  lg.valuer = rg.valuer, 
  lg.valueli3 = rg.valueli3, 
  lg.valuer2 = rg.valuer2, 
  lg.date_value = rg.date_value, 
  lg.date2 = rg.date2, 
  lg.time1 = rg.time1, 
  lg.time2 = rg.time2, 
  lg.spedindicator = rg.spedindicator, 
  lg.yearid = rg.yearid;
  
-- GRAB IMMUNIZATIONS FROM ENTERPRISE CONTROLLER
MERGE INTO HEALTHVACCINE local_immunization
USING HEALTHVACCINE@DBL_ENTCON remote_immunization
  ON (local_immunization.vaccinecode = remote_immunization.vaccinecode)
WHEN NOT MATCHED THEN
  INSERT (LOCAL_IMMUNIZATION.HEALTHVACCINEID,LOCAL_IMMUNIZATION.VACCINECODE,LOCAL_IMMUNIZATION.VACCINEDESC,LOCAL_IMMUNIZATION.VACCINENAME,LOCAL_IMMUNIZATION.NUMBEROFDOSES,LOCAL_IMMUNIZATION.STATEREPORTCODE,LOCAL_IMMUNIZATION.STATEREPORTNAME,LOCAL_IMMUNIZATION.STATEOFRECORD,LOCAL_IMMUNIZATION.DISPLAYORDER,LOCAL_IMMUNIZATION.ISMANDATORY,LOCAL_IMMUNIZATION.ISRULESREADY,LOCAL_IMMUNIZATION.ISUSEDBYRULEENGINE,LOCAL_IMMUNIZATION.WHOCREATED,LOCAL_IMMUNIZATION.WHENCREATED,LOCAL_IMMUNIZATION.WHOMODIFIED,LOCAL_IMMUNIZATION.WHENMODIFIED,LOCAL_IMMUNIZATION.HEALTHVACCINERULEID)
  VALUES (healthvaccine_healthvaccine_sq.nextval,REMOTE_IMMUNIZATION.VACCINECODE,REMOTE_IMMUNIZATION.VACCINEDESC,REMOTE_IMMUNIZATION.VACCINENAME,REMOTE_IMMUNIZATION.NUMBEROFDOSES,REMOTE_IMMUNIZATION.STATEREPORTCODE,REMOTE_IMMUNIZATION.STATEREPORTNAME,REMOTE_IMMUNIZATION.STATEOFRECORD,REMOTE_IMMUNIZATION.DISPLAYORDER,REMOTE_IMMUNIZATION.ISMANDATORY,REMOTE_IMMUNIZATION.ISRULESREADY,REMOTE_IMMUNIZATION.ISUSEDBYRULEENGINE,REMOTE_IMMUNIZATION.WHOCREATED,REMOTE_IMMUNIZATION.WHENCREATED,REMOTE_IMMUNIZATION.WHOMODIFIED,REMOTE_IMMUNIZATION.WHENMODIFIED,NULL)
WHEN MATCHED THEN
  UPDATE SET
  LOCAL_IMMUNIZATION.VACCINEDESC = REMOTE_IMMUNIZATION.VACCINEDESC,
  LOCAL_IMMUNIZATION.VACCINENAME = REMOTE_IMMUNIZATION.VACCINENAME,
  LOCAL_IMMUNIZATION.NUMBEROFDOSES = REMOTE_IMMUNIZATION.NUMBEROFDOSES,
  LOCAL_IMMUNIZATION.STATEREPORTCODE = REMOTE_IMMUNIZATION.STATEREPORTCODE,
  LOCAL_IMMUNIZATION.STATEREPORTNAME = REMOTE_IMMUNIZATION.STATEREPORTNAME,
  LOCAL_IMMUNIZATION.STATEOFRECORD = REMOTE_IMMUNIZATION.STATEOFRECORD,
  LOCAL_IMMUNIZATION.DISPLAYORDER = REMOTE_IMMUNIZATION.DISPLAYORDER,
  LOCAL_IMMUNIZATION.ISMANDATORY = REMOTE_IMMUNIZATION.ISMANDATORY,
  LOCAL_IMMUNIZATION.ISRULESREADY = REMOTE_IMMUNIZATION.ISRULESREADY,
  LOCAL_IMMUNIZATION.ISUSEDBYRULEENGINE = REMOTE_IMMUNIZATION.ISUSEDBYRULEENGINE,
  LOCAL_IMMUNIZATION.WHOCREATED = REMOTE_IMMUNIZATION.WHOCREATED,
  LOCAL_IMMUNIZATION.WHENCREATED = REMOTE_IMMUNIZATION.WHENCREATED,
  LOCAL_IMMUNIZATION.WHOMODIFIED = REMOTE_IMMUNIZATION.WHOMODIFIED,
  LOCAL_IMMUNIZATION.WHENMODIFIED = REMOTE_IMMUNIZATION.WHENMODIFIED;
-- GRAB HEALTH EXEMPTIONS FROM ENTERPRISE CONTROLLER
MERGE INTO HEALTHIMMEXEMPT local_exemptions
USING HEALTHIMMEXEMPT@DBL_ENTCON remote_exemptions
  ON (local_exemptions.IMMUNIZATIONEXEMPTIONCODE = remote_exemptions.IMMUNIZATIONEXEMPTIONCODE)
WHEN NOT MATCHED THEN
  INSERT (
    local_exemptions.HEALTHIMMEXEMPTID,
    local_exemptions.IMMUNIZATIONEXEMPTIONCODE,
    local_exemptions.IMMUNIZATIONEXEMPTIONNAME,
    local_exemptions.EXEMPTEXPIREINDAYS,
    local_exemptions.STATEREPORTCODE,
    local_exemptions.STATEREPORTNAME,
    local_exemptions.STATEOFRECORD,
    local_exemptions.WHOCREATED,
    local_exemptions.WHENCREATED,
    local_exemptions.WHOMODIFIED,
    local_exemptions.WHENMODIFIED
  )
  VALUES (
    healthimmexempt_healthimmex_sq.nextval,
    remote_exemptions.IMMUNIZATIONEXEMPTIONCODE,
    remote_exemptions.IMMUNIZATIONEXEMPTIONNAME,
    remote_exemptions.EXEMPTEXPIREINDAYS,
    remote_exemptions.STATEREPORTCODE,
    remote_exemptions.STATEREPORTNAME,
    remote_exemptions.STATEOFRECORD,
    remote_exemptions.WHOCREATED,
    remote_exemptions.WHENCREATED,
    remote_exemptions.WHOMODIFIED,
    remote_exemptions.WHENMODIFIED
  )
WHEN MATCHED THEN
  UPDATE SET
    local_exemptions.IMMUNIZATIONEXEMPTIONNAME = remote_exemptions.IMMUNIZATIONEXEMPTIONNAME,
    local_exemptions.EXEMPTEXPIREINDAYS = remote_exemptions.EXEMPTEXPIREINDAYS,
    local_exemptions.STATEREPORTCODE = remote_exemptions.STATEREPORTCODE,
    local_exemptions.STATEREPORTNAME = remote_exemptions.STATEREPORTNAME,
    local_exemptions.STATEOFRECORD = remote_exemptions.STATEOFRECORD,
    local_exemptions.WHOCREATED = remote_exemptions.WHOCREATED,
    local_exemptions.WHENCREATED = remote_exemptions.WHENCREATED,
    local_exemptions.WHOMODIFIED = remote_exemptions.WHOMODIFIED,
    local_exemptions.WHENMODIFIED = remote_exemptions.WHENMODIFIED;
-- GRAB HEALTH CERTIFICATIONS FROM ENTERPRISE CONTROLLER
MERGE INTO HEALTHIMMSOURCE local_certificates
USING HEALTHIMMSOURCE@DBL_ENTCON remote_certificates
  ON (local_certificates.IMMUNIZATIONSOURCECODE = remote_certificates.IMMUNIZATIONSOURCECODE)
WHEN NOT MATCHED THEN
  INSERT (
    local_certificates.HEALTHIMMSOURCEID,
    local_certificates.IMMUNIZATIONSOURCECODE,
    local_certificates.IMMUNIZATIONSOURCENAME,
    local_certificates.STATEREPORTCODE,
    local_certificates.STATEREPORTNAME,
    local_certificates.STATEOFRECORD,
    local_certificates.ISDEFAULTSOURCE,
    local_certificates.WHOCREATED,
    local_certificates.WHENCREATED,
    local_certificates.WHOMODIFIED,
    local_certificates.WHENMODIFIED
  )
  VALUES (
    HEALTHIMMSOURCE_HEALTHIMMSO_SQ.nextval,
    remote_certificates.IMMUNIZATIONSOURCECODE,
    remote_certificates.IMMUNIZATIONSOURCENAME,
    remote_certificates.STATEREPORTCODE,
    remote_certificates.STATEREPORTNAME,
    remote_certificates.STATEOFRECORD,
    remote_certificates.ISDEFAULTSOURCE,
    remote_certificates.WHOCREATED,
    remote_certificates.WHENCREATED,
    remote_certificates.WHOMODIFIED,
    remote_certificates.WHENMODIFIED
  )
WHEN MATCHED THEN
  UPDATE SET
    local_certificates.IMMUNIZATIONSOURCENAME = remote_certificates.IMMUNIZATIONSOURCENAME,
    local_certificates.STATEREPORTCODE = remote_certificates.STATEREPORTCODE,
    local_certificates.STATEREPORTNAME = remote_certificates.STATEREPORTNAME,
    local_certificates.STATEOFRECORD = remote_certificates.STATEOFRECORD,
    local_certificates.ISDEFAULTSOURCE = remote_certificates.ISDEFAULTSOURCE,
    local_certificates.WHOCREATED = remote_certificates.WHOCREATED,
    local_certificates.WHENCREATED = remote_certificates.WHENCREATED,
    local_certificates.WHOMODIFIED = remote_certificates.WHOMODIFIED,
    local_certificates.WHENMODIFIED = remote_certificates.WHENMODIFIED;
END CAS_EC_CODE_SYNC_PROC;
/