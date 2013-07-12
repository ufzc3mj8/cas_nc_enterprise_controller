create or replace 
TRIGGER "PS"."UPD_PSM_ASSET" 
after insert or delete on PS.ec_psm_asset
for each row

declare
    
    astfldr_name varchar2 (50 char);
    astfldr_id number;
    ast_id number;
    del_asset_id number;
    ec_assetcontent ec_psm_Assetcontent%rowtype;

begin

    if inserting then
      
      select name into astfldr_name from ec_psm_Assetfolder 
    where id = :new.assetfolder_id
   and parentassetfolder_id=1;

    select id into astfldr_id from psm_assetfolder
    where name = astfldr_name
    and parentassetfolder_id=1;
    
      INSERT INTO PSM_ASSET (ID, ASSETFOLDER_ID, NAME, MIME_TYPE, IS_BINARY, LASTMODIFIED_BY, LASTMODIFIED_TS, CREATED_BY, CREATED_TS)
      VALUES (psm_asset_id_sq.nextval, astfldr_id, :new.name, :new.MIME_TYPE, :new.IS_BINARY, 
              :new.LASTMODIFIED_BY, :new.LASTMODIFIED_TS, :new.CREATED_BY, :new.CREATED_TS)
      RETURNING id into ast_id;
      
      --commit;
      
      --select id into ast_id from psm_asset where name = :new.name;
      --select * into ec_assetcontent
      --from ec_psm_assetcontent where asset_id = :new.id;
      
      --insert into psm_assetcontent (ID, ASSET_ID, STATUS, BLOB_CONTENT, CLOB_CONTENT, LASTMODIFIED_BY, LASTMODIFIED_TS, CREATED_BY, CREATED_TS)
      --values (psm_assetcontent_id_sq.nextval, ast_id,ec_assetcontent.status, ec_assetcontent.blob_content, 
           -- ec_assetcontent.clob_content, ec_assetcontent.lastmodified_by, ec_assetcontent.lastmodified_ts, 
           -- ec_assetcontent.created_by, ec_assetcontent.created_ts); 
          
   elsif deleting then
   
   select id into del_Asset_id from psm_asset where name = :old.name and assetfolder_id = astfldr_id;
   
   delete from psm_assetcontent 
   where asset_id = del_asset_id;
   
   delete from psm_asset 
   where name = :old.name
   and assetfolder_id = astfldr_id;
   
   end if;
   
end;
/