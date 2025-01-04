
-- Generated Code: do not modify this file

-- transforms scale_denominator to zoom value
DROP FUNCTION IF EXISTS zzoom;
CREATE OR REPLACE FUNCTION zzoom( scale numeric)    
  returns integer language plpgsql as $$
BEGIN
  RETURN ROUND(   log( 2 , 559082264 / scale )     );
END
$$;

-- allows to trace
DROP FUNCTION IF EXISTS ztrace;
CREATE OR REPLACE FUNCTION ztrace( msg text, txt text )    
  returns text language plpgsql as $$
BEGIN
  RAISE INFO 'ZTRACE %  value=%', msg , txt ;
  RETURN txt;
END
$$;


-- Generated Code: do not modify it
DROP FUNCTION IF EXISTS zfact_roadsize ;
CREATE OR REPLACE FUNCTION zfact_roadsize( key text, scale numeric)    
                returns numeric language plpgsql as $$

DECLARE
  zoom integer;
  r    numeric;
BEGIN
  -- zoom = ROUND(   log( 2 , 559082264 / scale )     );


  CASE
    WHEN False THEN r = 0::numeric ;
    WHEN key  = 'motorway'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 23::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 16::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 10::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 6::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 4::numeric ; --zoom >= 14 
        WHEN scale < 400000 THEN  r = 3::numeric ; --zoom >= 11 
        WHEN scale < 7500000 THEN  r = 2::numeric ; --zoom >= 7 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'trunk'  THEN
      CASE
        WHEN scale < 7500000 THEN  r = 2::numeric ; --zoom >= 7 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'primary'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 20::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 14::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 8::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 5::numeric ; --zoom >= 15 
        WHEN scale < 400000 THEN  r = 3::numeric ; --zoom >= 11 
        WHEN scale < 7500000 THEN  r = 1::numeric ; --zoom >= 7 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'secondary'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 20::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 14::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 8::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 4::numeric ; --zoom >= 15 
        WHEN scale < 400000 THEN  r = 3::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'motorway_link'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 14::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 8::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 5::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 3::numeric ; --zoom >= 15 
        WHEN scale < 200000 THEN  r = 2::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 1.5::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'primary_link'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 14::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 8::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 4::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 2::numeric ; --zoom >= 15 
        WHEN scale < 400000 THEN  r = 1.5::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'secondary_link'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 14::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 8::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 4::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 2::numeric ; --zoom >= 15 
        WHEN scale < 400000 THEN  r = 1.5::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'tertiary'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 16::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 8::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 6::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 3::numeric ; --zoom >= 15 
        WHEN scale < 200000 THEN  r = 2::numeric ; --zoom >= 12 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'tertiary_link'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 14::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 8::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 4::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 1.5::numeric ; --zoom >= 15 
        WHEN scale < 200000 THEN  r = 1::numeric ; --zoom >= 12 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'unclassified'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 16::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 10::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 6::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 3::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 2::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 1.5::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 1::numeric ; --zoom >= 12 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'residential'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 14::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 8::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 4::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 2::numeric ; --zoom >= 15 
        WHEN scale < 100000 THEN  r = 1::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.5::numeric ; --zoom >= 12 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'living_street'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 11::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 7.5::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 3::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 1.5::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.5::numeric ; --zoom >= 12 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'service'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 10::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 6::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 3.5::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 2::numeric ; --zoom >= 15 
        WHEN scale < 100000 THEN  r = 1::numeric ; --zoom >= 13 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'pedestrian'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 4::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 3::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 2::numeric ; --zoom >= 16 
        WHEN scale < 100000 THEN  r = 1::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.5::numeric ; --zoom >= 12 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  IN ( 'track','footway','bridleway') THEN
      CASE
        WHEN scale < 3000 THEN  r = 7::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 4::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 3::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 2::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 1.5::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 1::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.5::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'cycleway'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 4::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 3::numeric ; --zoom >= 17 
        WHEN scale < 50000 THEN  r = 2::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 1::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.7::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.4::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'path'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 2.5::numeric ; --zoom >= 18 
        WHEN scale < 12500 THEN  r = 2::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 2::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.65::numeric ; --zoom >= 13 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'railway'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 1::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 1::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 0.8::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 0.6::numeric ; --zoom >= 14 
        WHEN scale < 7500000 THEN  r = 0.5::numeric ; --zoom >= 7 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'turning_circle'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 21::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 15::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 6::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 1.65::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 1.1::numeric ; --zoom >= 14 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'steps'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 3.5::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 3::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 1.25::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 0.6::numeric ; --zoom >= 15 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'runway'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 23::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 19::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 15::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 11::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 7::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 5::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 3::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 2::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'taxiway'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 6::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 5::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 4::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 3::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 2::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 1.5::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 1::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.2::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
      ELSE r = 0::numeric ;
  END CASE;
  RETURN r;
END
$$;

-- Generated Code: do not modify it
DROP FUNCTION IF EXISTS zfact_roadcase ;
CREATE OR REPLACE FUNCTION zfact_roadcase( key text, scale numeric)    
                returns numeric language plpgsql as $$

DECLARE
  zoom integer;
  r    numeric;
BEGIN
  -- zoom = ROUND(   log( 2 , 559082264 / scale )     );


  CASE
    WHEN False THEN r = 0::numeric ;
    WHEN key  = 'motorway'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 2::numeric ; --zoom >= 18 
        WHEN scale < 12500 THEN  r = 1.25::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 1.25::numeric ; --zoom >= 15 
        WHEN scale < 200000 THEN  r = 1::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 1::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'primary'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 2::numeric ; --zoom >= 18 
        WHEN scale < 12500 THEN  r = 1.25::numeric ; --zoom >= 16 
        WHEN scale < 200000 THEN  r = 1::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.8::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'secondary'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 2::numeric ; --zoom >= 18 
        WHEN scale < 12500 THEN  r = 1.25::numeric ; --zoom >= 16 
        WHEN scale < 200000 THEN  r = 1::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.8::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'motorway_link'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'primary_link'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'secondary_link'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'tertiary'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 200000 THEN  r = 1::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.4::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'tertiary_link'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'unclassified'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 1::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 1::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.35::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'residential'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.2::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'living_street'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 3::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 1.75::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 1.5::numeric ; --zoom >= 16 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'service'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.3::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'pedestrian'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 4::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 3::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 2::numeric ; --zoom >= 16 
        WHEN scale < 50000 THEN  r = 1::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.15::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'bridge'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.5::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 1::numeric ; --zoom >= 17 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'turning_circle'  THEN
      CASE
        WHEN scale < 3000 THEN  r = 1.75::numeric ; --zoom >= 18 
        WHEN scale < 50000 THEN  r = 1.::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 0.6::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.25::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.2::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
    WHEN key  = 'steps'  THEN
      CASE
        WHEN scale < 25000 THEN  r = 1::numeric ; --zoom >= 15 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
      ELSE r = 0::numeric ;
  END CASE;
  RETURN r;
END
$$;

-- Generated Code: do not modify it
DROP FUNCTION IF EXISTS zfact_sizecycle ;
CREATE OR REPLACE FUNCTION zfact_sizecycle( key text, scale numeric)    
                returns numeric language plpgsql as $$

DECLARE
  zoom integer;
  r    numeric;
BEGIN
  -- zoom = ROUND(   log( 2 , 559082264 / scale )     );


  CASE
    WHEN False THEN r = 0::numeric ;
    ELSE
      CASE
        WHEN scale < 3000 THEN  r = 4::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 3::numeric ; --zoom >= 17 
        WHEN scale < 50000 THEN  r = 2::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 1::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.7::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.4::numeric ; --zoom >= 11 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
  END CASE;
  RETURN r;
END
$$;

-- Generated Code: do not modify it
DROP FUNCTION IF EXISTS zfact_watersize ;
CREATE OR REPLACE FUNCTION zfact_watersize( key text, scale numeric)    
                returns numeric language plpgsql as $$

DECLARE
  zoom integer;
  r    numeric;
BEGIN
  -- zoom = ROUND(   log( 2 , 559082264 / scale )     );


  CASE
    WHEN False THEN r = 0::numeric ;
    WHEN key  IN ( 'river','canal') THEN
      CASE
        WHEN scale < 750 THEN  r = 7::numeric ; --zoom >= 20 
        WHEN scale < 1500 THEN  r = 6::numeric ; --zoom >= 19 
        WHEN scale < 3000 THEN  r = 5::numeric ; --zoom >= 18 
        WHEN scale < 6000 THEN  r = 4::numeric ; --zoom >= 17 
        WHEN scale < 12500 THEN  r = 3::numeric ; --zoom >= 16 
        WHEN scale < 25000 THEN  r = 2::numeric ; --zoom >= 15 
        WHEN scale < 50000 THEN  r = 1.5::numeric ; --zoom >= 14 
        WHEN scale < 100000 THEN  r = 1::numeric ; --zoom >= 13 
        WHEN scale < 200000 THEN  r = 0.8::numeric ; --zoom >= 12 
        WHEN scale < 400000 THEN  r = 0.6::numeric ; --zoom >= 11 
        WHEN scale < 750000 THEN  r = 0.4::numeric ; --zoom >= 10 
        WHEN scale < 1500000 THEN  r = 0.2::numeric ; --zoom >= 9 
        WHEN scale < 3000000 THEN  r = 0.1::numeric ; --zoom >= 8 
        WHEN false THEN r = 0::numeric ;
        ELSE r = 0::numeric ;
      END CASE;
      ELSE r = 0::numeric ;
  END CASE;
  RETURN r;
END
$$;
