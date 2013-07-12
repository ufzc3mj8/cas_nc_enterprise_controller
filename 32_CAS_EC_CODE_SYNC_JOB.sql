BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name => 'PS.CAS_EC_CODE_SYNC_JOB',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN CAS_EC_CODE_SYNC_PROC(); END;',
    start_date => SYSTIMESTAMP,
    repeat_interval => 'freq=daily;byhour=3;byminute=0;bysecond=0',
    end_date => NULL,
    enabled => TRUE,
    comments => 'ENTERPRISE CONTROLLER - CUSTOM PAGE SYNC'
  );
END;
/