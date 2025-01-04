// ==================================================================
//                    ROAD & RAIL LINES
// ==================================================================



// draw perpendicular dash for railway
#roads_low[zoom>=7][zoom<=8][type='railway']::rail_perpendicular,
#roads_med[zoom>=9][zoom<=10][type='railway']::rail_perpendicular {
    /* background: to avoid weird pattern when many tracks are overlapping */
    background/line-color: @land;
    background/line-width: 4;

    line-color: @rail-line;
    line-cap: butt;
    line-dasharray: 0,4,1,4; /* start with space to avoid dense pattern on very short ways */
    line-width: 4;

}

// low level : only motorway/trunk/railway
#roads_low{

  line-width: [roadsize];
  line-color: @motorway-trunk-fill;
  [type='railway'] { line-color: @rail-line;}
}

// At mid-level scales start to show primary  routes
#roads_med{
  line-color: @motorway-trunk-fill;

  [type='motorway'][can_bicycle='yes'] {
    line-color: @motorway-trunk-cycle-fill;
  }
  [type='primary'] {
    line-color: @primary-fill;
  }

  [type='railway'] {
    line-color: @rail-line;
  }

  line-width: [roadsize];

}

// At higher levels the roads become more complex. We're now showing
//more than just automobile and railway routes - footways, and cycleways
//come in as well.

// ----------------------------------------------------------
// ---------------- Variables -------------------------------
// ----------------------------------------------------------
//
// * Road width variables that are used in road & bridge styles.
// *
// * Roads are drawn in two steps. First, a line if the width of the road + the
// * two borders is drawn and then a line of the width of the road is drawn on
// * top, to make a road with borders. Here, the width of the ways is the width
// * of the fill of the road and the border width is the width of a single
// * border, on one side (first line is drawn with a width of way with + 2 *
// * border_width).



// ---- Rail background with hatches -------------------------

#roads_high[zoom>=11][tunnel='no']
{
    [type='railway']::rail_perpendicular {
      [service!='minor'],
      [service='minor'][zoom>=13]
      {
        line-cap: butt;
        line-color: @rail-line;
        [service='minor'] {
          line-color: lighten(@rail-line, 25%);
        }

        /* hatches: start with space to avoid dense pattern on very short ways */
        line-dasharray: 0,2,1,2;
        [zoom>=14] { line-dasharray: 0,4,1,4; }

        line-width: 3;
        [zoom>=19] { line-width: 6; }
      }
    }
}

// ---- Casing for roads -----------------------------------------------

// Line to draw both borders (left and right)
#roads_high::outline {

  [type='motorway'],[type='motorway_link']
  ,[type='primary'] ,[type='primary_link']
  ,[type='secondary'] ,[type='secondary_link']
  ,[type='tertiary'] ,[type='tertiary_link']
  ,[type='unclassified'],[type='residential'] 
  ,[type='living_street'],[type='pedestrian']
  ,[type='service'][service!='minor'] 
  {

    line-cap: round;
    line-join: round;

    [tunnel!='no'],[bridge!='no'] {  line-cap: butt;    }
    [tunnel!='no']                {  line-dasharray: 3,3; }  // dashed line for tunnel
    
    line-width: [roadsize] + 2*[roadcase];
    [type='service'][service='minor'] {  line-width: 0.5*[roadsize] + [roadcase]; } // size divided by 2

    line-color: @standard-case; 
    [type='motorway'],[type='motorway_link']     {line-color: @motorway-trunk-case; }
    [type='primary'],[type='primary_link']       {line-color: @primary-case; }
    [type='secondary'] ,[type='secondary_link']  {line-color: @secondary-case; }
    [type='tertiary'] ,[type='tertiary_link']    {line-color: @tertiary-case; }
    [type='living_street'],[type='pedestrian']   {line-color: @pedestrian-case; }

    // specific color for bridge
    [zoom>=14][bridge!='no'] { line-color: @bridge_case;}

  }
}

// no casing for track...cycleway,path  excepted when tunnel or bridge  when high zoom
#roads_high::outlineline[zoom>=16] {
    [type='track'],[type='bridleway'],[type='footway'],[type='cycleway'],[type='path']{
        [tunnel!='no'],[bridge!='no'] {

            line-color: @bridge_case;
            [type='cycleway'],[type='path'][can_bicycle='designated'] {  line-color: @bridge_path_case; }
            line-cap: butt;
            line-join: round;
            line-dasharray: 3,3;
            line-width: [roadsize] + 2*[roadcase];

            // enlarge size for cycleway
            [type='cycleway'][oneway='no'][oneway_bicycle='no'] { line-width: 1.5*[roadsize]  + 2*[roadcase]; }  
        }
    }
}

// stuff for segregated cycleway on path
#roads_high::path_outline_right[zoom>=17][type='path'][can_bicycle='designated'][segregated='yes'],
{
  line-cap: butt;
  line-color: @path-fill;

  line-width: [roadsize];
  line-offset: [roadsize]/2 + [sizecycle]/2;
  [oneway='no'][oneway_bicycle='no'] {
    line-width: [roadsize]; 
    line-offset: [roadsize]/2 + [sizecycle]*1.5/2;
  }


}

//===========================================================================
// right and left border showing level of comfort for cycling . 
// also add arrow for oneway 
//===========================================================================

// Eventually overload right border for cycleways
#roads_high::outline_right[zoom>=11][cycleway_right_render='track'],
#roads_high::outline_right[zoom>=11][cycleway_right_render='shared_track'],
#roads_high::outline_right[zoom>=11][cycleway_right_render='sidewalk'],
#roads_high::outline_right[zoom>=12][cycleway_right_render='lane'],
#roads_high::outline_right[zoom>=12][cycleway_right_render='busway'],
{
    [type='motorway'],[type='motorway_link'],
    [type='primary'],[type='primary_link'],
    [type='secondary'] ,[type='secondary_link'],
    [type='tertiary'] ,[type='tertiary_link'],
    [type='unclassified'],[type='residential'] ,
    [type='living_street'],[type='pedestrian'],
    [type='service'],
    {
        line-cap: butt;

        line-color: @cycle_track_case;

        [cycleway_right_render='sidewalk'] {
           line-color: @path-fill;
        }

        [cycleway_right_render='lane'] {
          line-dasharray: 6,3;
          line-color: @mixed-cycle-fill;
        }

        [cycleway_right_render='busway'] {
          line-dasharray: 6,10;
          line-color: @mixed-cycle-fill;
        }

        [cycleway_right_render='shared_track'] {
          line-color: @mixed-cycle-fill;
        }

        line-offset: 1 * [sizecycle];
        [cycleway_right_oneway='no'] { line-offset: 1.5 * [sizecycle]; }
        line-width: [roadsize];

    }
}

// Right oneway marker
#roads_high::cycleway_right[zoom>=18][cycleway_right_render='shared_track'][cycleway_right_oneway='yes'],
#roads_high::cycleway_right[zoom>=18][cycleway_right_render='shared_track'][cycleway_right_oneway='-1'],
#roads_high::cycleway_right[zoom>=18][cycleway_right_render='track'][cycleway_right_oneway='yes'],
#roads_high::cycleway_right[zoom>=18][cycleway_right_render='track'][cycleway_right_oneway='-1'],
{
  [type='motorway'],
  [type='primary'],
  [type='secondary'],
  [type='tertiary'],
  [type='living_street'],
  [type='unclassified'],
  [type='residential'],
  [type='tertiary_link'],
  [type='secondary_link'],
  [type='primary_link'],
  [type='motorway_link'],
  [type='service'],
  [type='pedestrian'] {

    marker-placement: line;
    marker-max-error: 0.5;
    marker-spacing: 100;
    marker-file: url(symbols/oneway.svg);
    [cycleway_right_oneway='-1'] {
      marker-file: url(symbols/oneway-reverse.svg);
    }
    marker-fill: #ddf;

    marker-transform: translate(0, 0.5 * [roadsize] + 0.5 * [sizecycle] ); 

  }
}

// Eventually overload left border for cycleways
#roads_high::outline_left[zoom>=11][cycleway_left_render='track'],
#roads_high::outline_left[zoom>=11][cycleway_left_render='shared_track'],
#roads_high::outline_left[zoom>=11][cycleway_left_render='sidewalk'],
#roads_high::outline_left[zoom>=12][cycleway_left_render='lane'],
#roads_high::outline_left[zoom>=12][cycleway_left_render='busway'],
{
        line-cap: butt;

        line-color: @cycle_track_case;

        [cycleway_left_render='sidewalk'] {
           line-color: @path-fill;
        }

        [cycleway_left_render='lane'] {
          line-dasharray: 6,3;
          line-color: @mixed-cycle-fill;
        }

        [cycleway_left_render='busway'] {
          line-dasharray: 6,10;
          line-color: @mixed-cycle-fill;
        }

        [cycleway_left_render='shared_track'] {
          line-color: @mixed-cycle-fill;
        }

        line-offset: -1 * [sizecycle];
        [cycleway_left_oneway='no'] { line-offset: -1.5 * [sizecycle]; }
        line-width: [roadsize];

}


// left oneway markers
#roads_high::cycleway_left[zoom>=18][cycleway_left_render='shared_track'][cycleway_left_oneway='yes'],
#roads_high::cycleway_left[zoom>=18][cycleway_left_render='shared_track'][cycleway_left_oneway='-1'],
#roads_high::cycleway_left[zoom>=18][cycleway_left_render='track'][cycleway_left_oneway='yes'],
#roads_high::cycleway_left[zoom>=18][cycleway_left_render='track'][cycleway_left_oneway='-1'],
{
  [type='motorway'],
  [type='primary'],
  [type='secondary'],
  [type='tertiary'],
  [type='living_street'],
  [type='unclassified'],
  [type='residential'],
  [type='tertiary_link'],
  [type='secondary_link'],
  [type='primary_link'],
  [type='motorway_link'],
  [type='service'],
  [type='pedestrian'] {

    marker-placement: line;
    marker-max-error: 0.5;
    marker-spacing: 100;
    marker-file: url(symbols/oneway.svg);
    [cycleway_left_oneway='-1'] {
      marker-file: url(symbols/oneway-reverse.svg);
    }
    marker-fill: #ddf;

    marker-transform: translate(0, -0.5 * [roadsize] - 0.5 * [sizecycle] ); 

  }
}

// Steps equiped with a ramp : draw a line of size roadcase*2  at the right of the road line
#roads_high::steps_ramp_left[zoom >= 15],
{
  [type='steps'] {
    [has_ramp!='no'][has_ramp!=null][has_ramp!='separate'] {
      line-color: @cycle-fill;
      line-width: [roadcase] * 2;
      line-offset: [roadsize]/2 + [roadcase];

    }
  }
}

//===========================================================================
// roads inner  color
//
// remind that view cyclosm_ways combines motorway/trunk
//===========================================================================
#roads_high::inline {

    [type='motorway'],[type='motorway_link'],
    [type='primary'],[type='primary_link'],
    [type='secondary'],[type='secondary_link'],
    [type='tertiary'],[type='tertiary_link'],
    [type='unclassified'],
    [type='residential'],
    [type='service'][service!='minor'],
    [type='service'][service='minor'][zoom>=15],
    [type='living_street'],
    [type='pedestrian'],
    [type='steps']        

    {
     
        // tunnel : put a white background , and set a small opacity to draw the road with a very light color
        [tunnel!='no']{
            b/line-width: [roadsize];
            b/line-color: white;
            line-opacity: 0.1;
        }
     
        line-cap: round;
        line-join: round;
        line-width: [roadsize];
        [type='service'][service='minor'] { line-width: 0.5*[roadsize] ;}

        line-color: @standard-fill;
        [type='motorway'],[type='motorway_link'] {   line-color: @motorway-trunk-fill; }
        [type='primary'],[type='primary_link']    {   line-color: @primary-fill; }
        [type='secondary'],[type='secondary_link']    {   line-color: @secondary-fill; }
        [type='pedestrian']                          { line-color: @pedestrian-fill; }
        [type='steps']                               { line-color: @footway-fill; }
        //line-color: @motorway-trunk-cycle-fill;

        [type!='pedestrian'][type!='steps'] {
            [maxspeed_kmh < 33] {  line-color: @speed32-fill; }
            [maxspeed_kmh < 21] {  line-color: @speed20-fill; }
            [maxspeed_kmh < 10] {  line-color: @speedWalk-fill; }
        }

        [motor_vehicle='no'][can_bicycle!='no'][cyclestreet='no'][type!='pedestrian'][type!='steps'] { line-color: @nomotor-fill; }

        [cyclestreet='yes'] { line-color: @mixed-cycle-fill; }

        //[can_bicycle='no'] {   line-color: @motorway-trunk-fill; }
        // special color if can_bicycle=no  but not for motorway/primary
        
        // for roads smaller than primary, special color if forbidden to bikes
        [can_bicycle='no']
            [type!='motorway'][type!='motorway_link'][type!='primary'][type!='primary_link']
                { line-color: @standard-nobicycle;}

 
        // dash line for steps
        [type='steps'] {
            line-cap: butt;
            line-dasharray: 0.5,0.5;
            [zoom>=16] { line-dasharray: 1.5,0.75; }
            [zoom>=17] {  line-dasharray: 2,1; }

        }

        // For higher zoom, add a dashed dark overlay, when surface is bad, depending on surface type
        [zoom>=14][type!='steps'] {

            [surface_type='cyclocross'],[surface_type='mtb'] {
                surface/line-width: [roadsize];
                surface/line-cap: butt;
                surface/line-join: round;
                surface/line-opacity: 0.2;
                surface/line-color: black;
            }

            [surface_type='cyclocross'] { surface/line-dasharray: 5,5; }
            [surface_type='mtb']        {  surface/line-dasharray:10,5; }
        }

  }
}


#roads_high::inline {
    [type='track'],[type='bridleway'],[type='footway'],[type='cycleway']{

      // different type of dash, depending on surface . 
      // If can_bicycle=no then small points ( do not use a specific color for this, because now we take hiking in consideration )


      
      
      // tunnel : set a white background and a small opacity to draw the road with a very light color
      [tunnel!='no']{ 
            background/line-join: round;
            background/line-opacity: 0.4;
            background/line-color: #FFFFFF;
            background/line-width: [roadsize];
            [type='cycleway'][oneway='no'][oneway_bicycle='no']
                { background/line-width: [roadsize] *1.5; }  // enlarge size for cycleway line-opacity: 0.1;  
      }

      line-cap: butt;
      line-join: round;
      line-width: [roadsize];
      [type='cycleway'][oneway='no'][oneway_bicycle='no'] { line-width: [roadsize] *1.5; }  // enlarge size for cycleway

      [surface_type='cyclocross'] {  line-dasharray: 10,1; }

      [surface_type='mtb'] {
        line-dasharray: 10,4;
        [zoom>=16] { line-dasharray: 10,4; }
        [zoom>=17] { line-dasharray: 20,8; }
      }

      [can_bicycle='no']  {
        line-dasharray: 2,2;
        [zoom>=16] { line-dasharray: 4,4; }
        [zoom>=17] { line-dasharray: 8,8; }
      }
    

      //  colors for track/bridleway/footway
      [type='track']     {  line-color: @track-fill; }
      [type='bridleway'] {  line-color: @bridleway-fill; }
      [type='footway']   { line-color: @footway-fill; }
      [type='cycleway']  { line-color: @cycle-fill; }


  }
}

// if path compatible bike ( 'alpine'='no' and can_bicycle != no ) 
//   take color mixed-cycle-fill , and make difference between road/cyclocross/mtb+unknown
// otherwise take color path-fill and make difference alpine='no' / alpine='low' / 'alpine='medium'/alpine='high' 
#roads_high::inline {
  [type='path']
  {


      
      // tunnel : set a small opacity to draw the road with a  light color
      // since there is no casing, we put middle opacity
      [tunnel!='no']{  
        background/line-join: round;
        background/line-color: #FFFFFF;
        background/line-width: [roadsize];
        line-opacity: 0.5; 
      }

    line-cap: butt;
    line-join: round;

    line-width: [roadsize];

    // too difficult or not bike compatible => pink color
    line-color: @path-fill;
    [alpine='low'] { line-dasharray: 24,2; }
    [alpine='medium'] { line-dasharray: 12,4; }
    [alpine='high'] { line-dasharray: 4,4; }
    [alpine='veryhigh'] { line-dasharray: 1,4; }


    // easy and not bike incompatible => blue color
    [alpine='no'][can_bicycle != 'no']{
        line-color: @mixed-cycle-fill;
        // note: some path in mountain have smoothness=intermediate, which makes surface=road 
        [surface_type='cyclocross']                         { line-dasharray: 10,1; }  
        [surface_type='mtb'],[surface_type='unknown']       { line-dasharray: 10,4; }
    }
  }
}




/*
//------------------------------------------------------
//skip details for MountainBike difficulty
//------------------------------------------------------
#roads_high::mtbscale[mtb_scale>=0][zoom>=15]
{
  [type='service'],
  [type='track'],
  [type='bridleway'],
  [type='footway'],
  [type='path'],
  [type='cycleway']
  {
    line-color: #2076ff;
    line-dasharray: 1,8;

    [mtb_scale=1] {
      line-dasharray: 1,1,1,8;
    }
    [mtb_scale>=2] {
      line-color: #FF0000;
    }
    [mtb_scale>=3] {
      line-color: #000000; //one dash |
    }
    [mtb_scale>=4] {
      line-dasharray: 1,1,1,8;// 2 dashes ||
    }
    [mtb_scale>=5] {
      line-dasharray: 1,1,1,1,1,8;// 3 dashes |||
    }
    [mtb_scale>=6] {
      line-dasharray: 1,1,1,1,1,1,1,8;// 4 dashes ||||
    }

    line-width: [roadsize]*2;

  }
}

#roads_high::mtbscale[mtb_scale=null][mtb_scale_imba>=0][zoom>=15]
{
  [type='service'],
  [type='track'],
  [type='bridleway'],
  [type='footway'],
  [type='path'],
  [type='cycleway']
  {
    line-cap: round;
    line-color: #FFFFFF;
    line-dasharray: 0.1,12;

    [mtb_scale_imba>=1] {
      line-color: #4e9b00;
    }
    [mtb_scale_imba>=2] {
      line-color: #2076ff;
    }
    [mtb_scale_imba>=3] {
      line-color: #000000;
    }
    [mtb_scale_imba>=4] {
      line-color: #000000;
      line-dasharray: 0.1,4,0.1,18;
    }

    line-width: [roadsize]*2;

    [zoom>=17] {
      line-dasharray: 0.1,24;
      [mtb_scale_imba>=4] {
        line-dasharray: 0.1,4,0.1,36;
      }
    }

  }
}

-------------------------------------
*/

// railway line
#roads_high::rail_line[zoom>=11],
{
    [type='railway'][tunnel='no'] {
        [service!='minor'],
        [service='minor'][zoom>=13]
        {

            line-color: @rail-line;
            [service='minor'] {
                line-color: lighten(@rail-line, 25%);
            }

        line-width: [roadsize];

        }
    }
}


// ---- Turning Circles ---------------------------------------------

// CAUTION: for turning_circle , the roadcase value for turning_circle must be identical to the roadcase value of 'residential'
// because original Cyclosm was using the 'residential' casing value for 'turning_circle' casing
// I do not know the impact if we change this
#turning_circle_case[zoom>=14] {
  marker-fill: @standard-fill;
  marker-line-color: @standard-case;
  marker-line-width: 2* [roadcase];
  marker-allow-overlap: true;
  marker-width: [roadsize];
}

#turning_circle_fill[zoom>=14] {
  marker-fill: @standard-fill;
  marker-line-width: 0;
  marker-line-opacity: 0;
  marker-allow-overlap: true;
  marker-width: [roadsize];
}


// ==================================================================
// AEROWAYS
// ==================================================================

#aeroway[zoom>=11] {
    line-color: @aeroway;
    line-width: [roadsize];
}

// ==================================================================
// BICYCLE ROUTES
// ==================================================================

/*---------------- skip this part than changes the color of standard highways

#bicycle_routes_gen0[zoom >= 2] {
  opacity: 0.75;

  line-color: @icn-overlay;
  [route='mtb'] {
    line-color: @mtb-overlay;
  }

  line-width: 1;
}
#bicycle_routes_gen1[zoom >= 5] {
  opacity: 0.75;
  line-color: @icn-overlay;
  line-width: 1;

  [type='ncn'] {
    line-color: @ncn-overlay;
    [zoom >= 5] { line-width: 0.5; }
    [zoom >= 7] { line-width: 1; }
  }
  [route='mtb'] {
    line-color: @mtb-overlay;
  }

  [state='proposed'] {
    line-dasharray: 6,6;
  }
}
#bicycle_routes_gen2[zoom >= 8] {
  opacity: 0.6;
  line-color: @icn-overlay;
  [type='ncn'] {
    line-color: @ncn-overlay;
  }
  [type='rcn'] {
    line-color: @rcn-overlay;
  }
  [route='mtb'] {
    line-color: @mtb-overlay;
  }

  [state='proposed'] {
    line-dasharray: 6,6;
  }

  line-width: 1;
  [zoom >= 9] { line-width: 1.5; }
  [zoom >= 10] { line-width: 2; }
}

*/

#hiking_routes{
  opacity: 0.20;
  line-color: red;
  line-width:8;

}

#bicycle_routes_bicycle_gen3{
  opacity: 0.20;
  line-color: @lcn-overlay;
  [type != 'lcn'] { line-color: @icn-overlay;}  // combine icn/ncn/rcn

  line-width:8;
  [zoom>=12]{line-width: 12;}
}


#bicycle_routes_mtb_gen3 {
  opacity: 0.20;
  line-color: @mtb-overlay;

  line-width:8;
  [zoom>=12]{line-width: 12;}


}




