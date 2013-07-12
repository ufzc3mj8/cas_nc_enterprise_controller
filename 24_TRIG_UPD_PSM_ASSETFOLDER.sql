create or replace 
TRIGGER "PS"."UPD_PSM_ASSETFOLDER" 
after insert or delete on PS.ec_psm_assetFOLDER
for each row
declare
    
  
    
    id_parentassetfolder number(6);
    objcount number(6);

begin
    
    
    --select id into id_parentassetfolder from psm_assetfolder where name = (select name from ec_psm_assetfolder 
  --where id = (select parentassetfolder_id from ec_psm_assetfolder where name = :new.name));
    
    --select name into asset_name from ec_psm_Assetfolder 
    --where id = :new.assetfolder_id;

    --select id into astfldr_id from psm_assetfolder
    --where name = asset_name;
     
  
    if inserting then
    
      select count(*) into objcount from psm_assetfolder where name = :new.name;
        if objcount = 0 then
        
          INSERT INTO PSM_ASSETFOLDER (ID, NAME, PARENTASSETFOLDER_ID, LASTMODIFIED_BY, LASTMODIFIED_TS, CREATED_BY, CREATED_TS)
          VALUES (psm_assetfolder_id_sq.nextval, :new.name, 1 , 
              :new.LASTMODIFIED_BY, :new.LASTMODIFIED_TS, :new.CREATED_BY, :new.CREATED_TS);
        end if;
     -- commit;
          
   elsif deleting then
   
   --select id into del_Assetfolder_id from psm_asset where name = :old.name;
   
   delete from psm_assetfolder where name = :old.name;
   
   end if;
   
end;
/