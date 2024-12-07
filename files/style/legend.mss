/*---------------- obsolete stuff ---------------------
#legend-icons {
    marker-file: url("symbols/legend/[icon].svg");
    marker-fill: #000;
    marker-placement: interior;
    marker-clip: false;
    marker-height: 20;
}

#legend-icons::text {
    text-name: "[label]";
    text-size: 13;
    text-face-name: @sans_bold;
    text-halo-radius: @standard-halo-radius;
    text-halo-fill: @standard-halo-fill;
    text-placement: point;
    text-dx: 20;
}
------------------------------------------*/

#legend-labels {

    // text for the LEGENG border
    [label='LEGEND'] {
        text-name: "[label]";
        text-size: 20; 

        text-face-name: @sans_bold;
        text-placement: point;
    }

    // text for the LEGENG items
    [label !='LEGEND'][zoom>=15] { 
        text-name: "[label]";
        text-size: 15;     
        text-face-name: @sans_bold;
        text-placement: point;
        text-vertical-alignment: middle;
        text-dx: 20;
        text-dy: 0;
    }
}

#legend-border {
    polygon-fill : white;
    line-color:    black;
    line-width: 3;

}

