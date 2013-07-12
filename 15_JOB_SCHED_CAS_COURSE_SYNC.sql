BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name => 'PS.SCHED_CAS_COURSE_SYNC',
    job_type => 'PLSQL_BLOCK',
    job_action => 'BEGIN CAS_COURSE_SYNC(); END;',
    start_date => SYSTIMESTAMP,
    repeat_interval => 'freq=daily;byhour=1;byminute=0;bysecond=0',
    end_date => NULL,
    enabled => TRUE,
    comments => 'Job defined for synchronizing courses with enterprise controller only.'
  );
END;
/