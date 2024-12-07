/*
-----------------------------------------------------
optimization for contours
-----------------------------------------------------
*/

-- compute elegroup : valeurs 10,20,50,100
update planet_osm_line
    set elegroup = 
        CASE
            WHEN  ele IS NOT NULL AND MOD(ele::numeric, 100) = 0  THEN 100
            WHEN  ele IS NOT NULL AND MOD(ele::numeric, 50) = 0  THEN 50
            WHEN  ele IS NOT NULL AND MOD(ele::numeric, 20) = 0  THEN 20
            WHEN  ele IS NOT NULL AND MOD(ele::numeric, 10) = 0  THEN 10
            ELSE NULL
        END
;

-- create index , only for values 100 and 50 , to reduce size
create index zline_elegroup on planet_osm_line USING btree (elegroup)  WHERE ele=100 OR ele=50  ;
     
