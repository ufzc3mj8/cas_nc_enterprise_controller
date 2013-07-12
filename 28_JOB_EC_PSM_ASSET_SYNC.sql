BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name => 'PS.EC_PSM_ASSET_SYNC',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN PSM_ASSETCONTENT_New_EC(); END;',
    start_date => SYSTIMESTAMP,
    repeat_interval => 'freq=daily;byhour=12;byminute=0;bysecond=0',
    end_date => NULL,
    enabled => TRUE,
    comments => 'ENTERPRISE CONTROLLER - CUSTOM PAGE SYNC'
  );
END;
/