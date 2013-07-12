create or replace
TRIGGER CAS_MOVE_SN_SSN 
BEFORE INSERT OR UPDATE OF STUDENT_NUMBER ON STUDENTS 
  FOR EACH ROW
  BEGIN
    :new.state_studentnumber := :new.student_number;
  END;