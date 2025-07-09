$fn = 64;

LARGE_HOLE_D = 19;
LARGE_HOLE_R = LARGE_HOLE_D / 2;

LARGE_HOLE_H = 23;

HEAD_D = 15;
HEAD_R = HEAD_D / 2;

PIN_D = 9;
PIN_R = PIN_D / 2;
PIN_H = 30;

INNER_PIN_D = 6;
INNER_PIN_R = INNER_PIN_D / 2;
INNER_PIN_H = 14;

SECTION_D = INNER_PIN_H;
SECTION_R = SECTION_D / 2;

BRIDGE_D = SECTION_D - 3.5;
BRIDGE_R = BRIDGE_D / 2;
BRIDGE_R_IN = BRIDGE_R - 2.5;
BRIDGE_OFF = PIN_R;
BRIDGE_L_IN = 8;
BRIDGE_L = BRIDGE_L_IN + (BRIDGE_OFF * 2);

BASE_D = LARGE_HOLE_D + 3;
BASE_R = BASE_D / 2;
BASE_H_OUT = 3;
BASE_H_IN = 10;
BASE_H_HEAD = 4;


module cil_hole(r_out, r_in, h) {
    translate([0, 0, h/2])
    difference() {
        cylinder(r=r_out, h=h, center=true);
        translate([0, 0, -h]) cylinder(r=r_in, h=h * 4, center=true);
    }
}

module section() {
    cil_hole(r_out = SECTION_R, r_in = INNER_PIN_R, h = INNER_PIN_H);

    translate([BRIDGE_OFF, 0, INNER_PIN_H / 2])
    rotate([0, 90, 0])
        cil_hole(r_out = BRIDGE_R, r_in = BRIDGE_R_IN, h = BRIDGE_L_IN);
    
    translate([BRIDGE_L, 0, INNER_PIN_H / 2])
    rotate([90, 0, 0])
    translate([0, 0, -INNER_PIN_H / 2])
        cil_hole(r_out = SECTION_R, r_in = INNER_PIN_R, h = INNER_PIN_H);
}

module section_1() {
    cil_hole(r_out = SECTION_R, r_in = PIN_R, h = INNER_PIN_H);

    translate([BRIDGE_OFF, 0, INNER_PIN_H / 2])
    rotate([0, 90, 0])
        cil_hole(r_out = BRIDGE_R, r_in = BRIDGE_R_IN, h = BRIDGE_L_IN);
    
    translate([BRIDGE_L, 0, INNER_PIN_H / 2])
    rotate([90, 0, 0])
    translate([0, 0, -INNER_PIN_H / 2])
        cil_hole(r_out = SECTION_R, r_in = PIN_R, h = INNER_PIN_H);
}

module base_out() {
    translate([0, 0, BASE_H_IN])
    rotate([180, 0, 0])
    difference() {
        union() {
            translate([0, 0, BASE_H_OUT/2]) cylinder(r=BASE_R, h=BASE_H_OUT, center=true);
            translate([0, 0, BASE_H_IN/2]) cylinder(r=LARGE_HOLE_R, h=BASE_H_IN, center=true);
        }
        union() {
            cylinder(r=HEAD_R, h=BASE_H_HEAD * 2, center=true);
            cylinder(r=PIN_R, h=PIN_H * 2, center=true);
        }
    }
}

module base_in() {
    difference() {
        union() {
            translate([0, 0, BASE_H_OUT/2]) cylinder(r=BASE_R, h=BASE_H_OUT, center=true);
            translate([0, 0, BASE_H_IN/2]) cylinder(r=LARGE_HOLE_R, h=BASE_H_IN, center=true);
        }
        union() {
            cylinder(r=PIN_R, h=PIN_H * 2, center=true);
        }
    }
}

//module filler_base() {
//    cil_hole(r_out = SECTION_R, r_in = PIN_R, h = PIN_H + BASE_H_IN - (LARGE_HOLE_H + BASE_H_OUT + INNER_PIN_H));
//}

module filler_section() {
    cil_hole(r_out = SECTION_R, r_in = PIN_R, h = 15);
}

//section_1();
//base_out();
//base_in();
//filler_base();
filler_section();
