create or replace 
PROCEDURE ps.PSM_ASSETCONTENT_New_EC IS

  CURSOR EC_PSM_ASTFLD_STR IS 
    SELECT EC.FOLDER, EC.FOLDER_ID, EC.PARENTASSETFOLDER_ID, EC.FOLDER_NAME, EC.ASSET_NAME, EC.ASSET_ID, EC.ASSETFOLDER_ID
    FROM (SELECT FOLDER1.FOLDER FOLDER, 
          folder1.id FOLDER_ID, folder1.parentassetfolder_id parentassetfolder_id, folder1.name folder_name, file1.name asset_name, file1.id asset_id, file1.assetfolder_id assetfolder_id
          from (
                SELECT SYS_CONNECT_BY_PATH(NAME , '/') FOLDER, LEVEL-1 PATHLES, CONNECT_BY_ROOT NAME ROOT, ID, NAME, PARENTASSETFOLDER_ID
                from ec_psm_assetfolder folder1
                connect by prior id = parentassetfolder_id
          )FOLDER1
    left outer join ec_psm_asset file1 on file1.assetfolder_id=folder1.id
    WHERE ROOT='WEB_ROOT'
    --AND FILE1.NAME = 'StudentNumberIssue.html'
    ORDER BY  FOLDER1.ID, FOLDER1.PARENTASSETFOLDER_ID) EC
    WHERE EC.FOLDER IN
    (SELECT FOLDER1.FOLDER
    from (
      select sys_connect_by_path(name , '/') folder, level-1 pathles, connect_by_root name root, id, name, parentassetfolder_id
      from psm_assetfolder folder1
      connect by prior id = parentassetfolder_id
      )folder1
    LEFT OUTER JOIN PSM_ASSET FILE1 ON FILE1.ASSETFOLDER_ID=FOLDER1.ID
    WHERE ROOT='WEB_ROOT')
    and EC.ASSET_NAME is not null
    ORDER BY EC.FOLDER_ID, EC.PARENTASSETFOLDER_ID;
    
    
    --cursor for identifying the assetfolder_id for the new asset from psm_Assetfolder
    
  CURSOR PSM_ASTFLDSTR IS
    (SELECT FOLDER1.FOLDER,folder1.id, folder1.parentassetfolder_id, folder1.name, file1.name, file1.id, file1.assetfolder_id
    from (
      select sys_connect_by_path(name , '/') folder, level-1 pathles, connect_by_root name root, id, name, parentassetfolder_id
      from psm_assetfolder folder1
      connect by prior id = parentassetfolder_id
      )folder1
    LEFT OUTER JOIN PSM_ASSET FILE1 ON FILE1.ASSETFOLDER_ID=FOLDER1.ID
    WHERE ROOT='WEB_ROOT');
    
    R_EC_PSM_ASTFLD_STR  EC_PSM_ASTFLD_STR%ROWTYPE;
    V_PSM_ASSETFOLDER PSM_ASSETFOLDER%ROWTYPE;
    V_PSM_ASSET PSM_ASSET%ROWTYPE;
    V_PSM_ASSETcontent PSM_ASSETcontent%ROWTYPE;
    V_PARENTASSETFOLDER_ID PSM_ASSETFOLDER.PARENTASSETFOLDER_ID%TYPE;
    V_ASSETFOLDER_ID PSM_ASSET.ASSETFOLDER_ID%TYPE;
    V_ASSET_ID PSM_ASSETCONTENT.ASSET_ID%TYPE;
    V_PSM_FLDRSTR VARCHAR(90 CHAR);
    FOLDER_LEVELS NUMBER(2);
    
    
    
BEGIN

  OPEN EC_PSM_ASTFLD_STR;
  --OPEN PSM_ASTFLDSTR;
  
  LOOP
    FETCH EC_PSM_ASTFLD_STR INTO R_EC_PSM_ASTFLD_STR;
    
    EXIT WHEN EC_PSM_ASTFLD_STR%NOTFOUND;
    
    --Folder levels:
    
    SELECT REGEXP_COUNT(R_EC_PSM_ASTFLD_STR.folder,'[^/]+') into folder_levels
    FROM DUAL;
    
      SELECT
      SUBSTR(R_EC_PSM_ASTFLD_STR.FOLDER, 1, INSTR(R_EC_PSM_ASTFLD_STR.folder, '/',1,FOLDER_LEVELS)-1)
      into V_PSM_FLDRSTR
      FROM DUAL;
      
      SELECT PARENT.AID INTO V_ASSET_ID
      from (SELECT FOLDER1.FOLDER,folder1.id PID, folder1.parentassetfolder_id, folder1.name, file1.name, file1.id AID, file1.assetfolder_id
            from (
                  select sys_connect_by_path(name , '/') folder, level-1 pathles, connect_by_root name root, id, name, parentassetfolder_id
                  from psm_assetfolder folder1
                  CONNECT BY PRIOR ID = PARENTASSETFOLDER_ID
                 )FOLDER1
      LEFT OUTER JOIN PSM_ASSET FILE1 ON FILE1.ASSETFOLDER_ID=FOLDER1.ID
      WHERE ROOT='WEB_ROOT'
      AND FOLDER1.FOLDER=R_EC_PSM_ASTFLD_STR.FOLDER
      and file1.name=R_EC_PSM_ASTFLD_STR.asset_name) parent;
      
    --select row from ec_psm_asset table
    
    SELECT * INTO V_PSM_ASSETCONTENT
      FROM EC_PSM_ASSETCONTENT
      WHERE ASSET_ID = R_EC_PSM_ASTFLD_STR.ASSET_ID;
      
   MERGE INTO PSM_ASSETContent B
   USING (SELECT * 
      FROM EC_PSM_ASSETCONTENT
      WHERE ASSET_ID = R_EC_PSM_ASTFLD_STR.ASSET_ID)
  ON (b.asset_id=V_ASSET_ID)
  WHEN MATCHED THEN
    UPDATE SET B.STATUS=V_PSM_ASSETCONTENT.STATUS,
               B.BLOB_CONTENT = V_PSM_ASSETCONTENT.BLOB_CONTENT,
               B.clob_content = V_PSM_ASSETCONTENT.clob_content,
               B.LASTMODIFIED_BY=V_PSM_ASSETCONTENT.LASTMODIFIED_BY,
               B.LASTMODIFIED_TS=V_PSM_ASSETCONTENT.LASTMODIFIED_TS,
               B.CREATED_BY=V_PSM_ASSETCONTENT.CREATED_BY,
               B.CREATED_TS=V_PSM_ASSETCONTENT.CREATED_TS
  WHEN NOT MATCHED THEN
    INSERT VALUES (PSM_ASSETcontent_ID_SQ.NEXTVAL, 
                                  V_ASSET_ID,
                                  V_PSM_ASSETCONTENT.STATUS,
                                  V_PSM_ASSETCONTENT.BLOB_CONTENT,
                                  V_PSM_ASSETCONTENT.clob_content,
                                          V_PSM_ASSETCONTENT.LASTMODIFIED_BY,
                                          V_PSM_ASSETCONTENT.LASTMODIFIED_TS,
                                          V_PSM_ASSETCONTENT.CREATED_BY,
                                          V_PSM_ASSETCONTENT.CREATED_TS);
      
    DBMS_OUTPUT.PUT_LINE('Processing next record');
  
  END LOOP;
  
  CLOSE EC_PSM_ASTFLD_STR;
  
end;
/