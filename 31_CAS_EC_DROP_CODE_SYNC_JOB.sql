BEGIN
  DBMS_SCHEDULER.drop_job (job_name => 'PS.CAS_EC_CODE_SYNC_JOB');
END;
/