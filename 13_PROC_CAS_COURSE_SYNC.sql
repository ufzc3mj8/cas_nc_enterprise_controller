create or replace
PROCEDURE PS.CAS_COURSE_SYNC AS 
BEGIN
 --INCLUDE ANY FIELDS IN THE COURSES TABLE THAT NEEDS TO BE KEPT UP TO DATE
UPDATE COURSES LOC_C
SET loc_c.credittype = (SELECT REM_C.CREDITTYPE from COURSES@DBL_ENTCON REM_C where (SUBSTR(loc_c.course_number,1,7) = SUBSTR(rem_c.course_number,1,7)))
WHERE SUBSTR(loc_c.course_number,1,7) = 
(SELECT SUBSTR(REM_C.COURSE_NUMBER,1,7) from COURSES@DBL_ENTCON REM_C where (SUBSTR(loc_c.course_number,1,7) = SUBSTR(rem_c.course_number,1,7)));

--CREATE S_NC_COURSEINFO TABLE IF IT DOES NOT EXIST FOR A COURSE
  FOR COURSE_DATA IN (
    SELECT LOC_C.dcid, LOC_S_NC_C.COURSESDCID
    FROM COURSES LOC_C
    LEFT OUTER JOIN S_NC_COURSEINFO LOC_S_NC_C ON LOC_C.DCID = LOC_S_NC_C.COURSESDCID
  )
  LOOP
    IF COURSE_DATA.COURSESDCID IS NULL THEN
      INSERT INTO PS.S_NC_COURSEINFO (COURSESDCID)
      VALUES (COURSE_DATA.DCID);
    ELSE
        UPDATE (
          SELECT substr(c.course_number,1,7) cnum, s_nc_c.* 
          FROM courses c 
          INNER JOIN s_nc_courseinfo s_nc_c ON c.dcid = s_nc_c.coursesdcid
        ) update_table
        SET
          (ACADEMIC_LEVEL_CODE, COURSE_EXTERNAL_PROVIDER)
          = 
          (SELECT
          ACADEMIC_LEVEL_CODE, COURSE_EXTERNAL_PROVIDER
          FROM S_NC_COURSEINFO@DBL_ENTCON REM_S_NC_C
          INNER JOIN (SELECT dcid, course_number FROM COURSES@DBL_ENTCON) REM_C ON REM_C.DCID = REM_S_NC_C.COURSESDCID
          WHERE update_table.cnum = SUBSTR(REM_C.COURSE_NUMBER,1,7))
        WHERE update_table.cnum IN 
          (SELECT substr(rem_c2.course_number,1,7) FROM courses@DBL_ENTCON rem_c2);
    END IF;
  END LOOP;

END CAS_COURSE_SYNC;
/