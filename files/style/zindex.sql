/*
==================================================================================================
           Index creation for performance
==================================================================================================
*/

/*
-- This alternative does not really change performances 
drop index zpoly_way_area;
drop index zpoly_way_area_multi;

create index zpoly_way_area_multi on planet_osm_polygon USING btree (way_area) WHERE 
landuse IS NOT NULL or
leisure IS NOT NULL or
"natural" IS NOT NULL or
highway IS NOT NULL or 
amenity IS NOT NULL or
man_made IS NOT NULL; 

create index zpoly_multi on planet_osm_polygon using gist(way) WHERE 
landuse IS NOT NULL or
leisure IS NOT NULL or
"natural" IS NOT NULL or
highway IS NOT NULL or 
amenity IS NOT NULL or
man_made IS NOT NULL; 
*/


drop index if exists   zpoly_way_area   ;    create index zpoly_way_area on planet_osm_polygon USING btree (way_area);


drop index if exists   zpoly_natural   ;   create index zpoly_natural on planet_osm_polygon USING btree ("natural") where "natural" is not null ;  -- double quote because NATURAL is a keyword
drop index if exists   zpoly_leisure   ;   create index zpoly_leisure on planet_osm_polygon USING btree (leisure) where "leisure" is not null ;
drop index if exists   zpoly_amenity   ;   create index zpoly_amenity on planet_osm_polygon USING btree (amenity) where "amenity" is not null;
drop index if exists   zpoly_highway   ;   create index zpoly_highway on planet_osm_polygon USING btree (highway) where "highway" is not null;
drop index if exists   zpoly_landuse   ;   create index zpoly_landuse on planet_osm_polygon USING btree (landuse) where "landuse" is not null;
drop index if exists   zpoly_man_made   ;   create index zpoly_man_made on planet_osm_polygon USING btree (man_made) where "man_made" is not null;


drop index if exists   zpoly_boundary   ;   create index zpoly_boundary on planet_osm_polygon USING btree (boundary)             WHERE boundary IS NOT NULL;
drop index if exists   zpoly_building   ;   create index zpoly_building on planet_osm_polygon USING btree (building)             WHERE building IS NOT NULL;
drop index if exists   zpoly_waterway   ;   create index zpoly_waterway on planet_osm_polygon USING btree (waterway)             WHERE waterway IS NOT NULL; 
drop index if exists   zpoly_tunnel   ;   create index zpoly_tunnel on planet_osm_polygon USING btree (tunnel)                 WHERE tunnel IS NOT NULL; 
drop index if exists   zpoly_tunnel   ;   create index zpoly_barrier on planet_osm_polygon USING btree (barrier)               WHERE barrier IS NOT NULL; 
drop index if exists   zpoly_historic   ;   create index zpoly_historic on planet_osm_polygon USING btree (historic)             WHERE historic IS NOT NULL; 
drop index if exists   zpoly_railway   ;   create index zpoly_railway on planet_osm_polygon USING btree (railway)               WHERE railway IS NOT NULL; 
drop index if exists   zpoly_shop   ;   create index zpoly_shop on planet_osm_polygon USING btree (shop)                     WHERE shop IS NOT NULL;
drop index if exists   zpoly_admin_level   ;   create index zpoly_admin_level on planet_osm_polygon USING btree (admin_level)       WHERE admin_level IS NOT NULL;
drop index if exists   zpoly_military   ;   create index zpoly_military on planet_osm_polygon USING btree (military)             WHERE military IS NOT NULL;
drop index if exists   zpoly_name   ;   create index zpoly_name on planet_osm_polygon USING btree (name)                     WHERE name IS NOT NULL;

drop index if exists   zline_waterway   ;   create index zline_waterway on planet_osm_line USING btree (waterway)                WHERE waterway IS NOT NULL; 
drop index if exists   zline_tunnel   ;   create index zline_tunnel on planet_osm_line USING btree (tunnel)                    WHERE tunnel IS NOT NULL; 
drop index if exists   zline_bridge   ;   create index zline_bridge on planet_osm_line USING btree (bridge)                    WHERE bridge IS NOT NULL; 
drop index if exists   zline_man_made   ;   create index zline_man_made on planet_osm_line USING btree (man_made)                WHERE man_made IS NOT NULL; 
drop index if exists   zline_aeroway   ;   create index zline_aeroway on planet_osm_line USING btree (aeroway)                  WHERE aeroway IS NOT NULL; 
drop index if exists   zline_leisure   ;   create index zline_leisure on planet_osm_line USING btree (leisure)                  WHERE leisure IS NOT NULL; 
drop index if exists   zline_aerialway   ;   create index zline_aerialway on planet_osm_line USING btree (aerialway)              WHERE aerialway IS NOT NULL; 
drop index if exists   zline_route   ;   create index zline_route on planet_osm_line USING btree (route)                      WHERE route IS NOT NULL; 
drop index if exists   zline_power   ;   create index zline_power on planet_osm_line USING btree (power)                      WHERE power IS NOT NULL; 
drop index if exists   zline_barrier   ;   create index zline_barrier on planet_osm_line USING btree (barrier)                  WHERE barrier IS NOT NULL; 
drop index if exists   zline_historic   ;   create index zline_historic on planet_osm_line USING btree (historic)                WHERE historic IS NOT NULL; 
drop index if exists   zline_highway   ;   create index zline_highway on planet_osm_line USING btree (highway)                  WHERE highway IS NOT NULL; 

drop index if exists   zpoint_place   ;   create index zpoint_place on planet_osm_point USING btree (place)                    WHERE place IS NOT NULL;
drop index if exists   zpoint_capital   ;   create index zpoint_capital on planet_osm_point USING btree (capital)                WHERE capital IS NOT NULL;
drop index if exists   zpoint_power   ;   create index zpoint_power on planet_osm_point USING btree (power)                    WHERE power IS NOT NULL;
drop index if exists   zpoint_barrier   ;   create index zpoint_barrier on planet_osm_point USING btree (barrier)                WHERE barrier IS NOT NULL;
drop index if exists   zpoint_name   ;   create index zpoint_name on planet_osm_point USING btree (name)                       WHERE name IS NOT NULL;

drop index if exists   zroads_boundary   ;   create index zroads_boundary on planet_osm_roads USING btree (boundary)              WHERE boundary IS NOT NULL;
drop index if exists   zroads_admin_level   ;   create index zroads_admin_level on planet_osm_roads USING btree (admin_level)        WHERE admin_level IS NOT NULL;
drop index if exists   zroads_highway   ;   create index zroads_highway on planet_osm_roads USING btree (highway)                WHERE highway IS NOT NULL;



