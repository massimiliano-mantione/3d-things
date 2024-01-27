$fn = 64;

// r * sqrt(2) = r + d
// r = (r + d) / sqrt(2)
// r = (r / sqrt(2)) + (d / sqrt(2)) 
// r - (r / sqrt(2)) = (d / sqrt(2)) 
// r - (r / sqrt(2)) = (d / sqrt(2)) 
// ((r * sqrt(2)) - r) = d
// r * (sqrt(2) - 1) = d
// r = d / (sqrt(2) - 1)

BASE_IN = 108;
BASE_IN_R = 12;
BASE_LINE = BASE_IN - (BASE_IN_R * 2);

BASE_OUT = 128;
BASE_OUT_R = (BASE_OUT-BASE_LINE) / 2;

WALL = 2;
FLOOR = 2;

BASE_WALL_H = 21.5;
UPPER_WALL_H = 5.5;

SNAP_D_OUT = 54;

HDD_PAD = 1;
HDD_W_IN = 70;
HDD_L_IN = 101;
HDD_W = HDD_W_IN + (HDD_PAD * 2);
HDD_L = HDD_L_IN + (HDD_PAD * 2);

HDD_WALL_H = 4;
HDD_WALL_THICK = 1;

HDD_USB_OFF = 21;
HDD_USB_SPARE = BASE_W - (HDD_W + HDD_USB_OFF);

HDD_OFF_W = (HDD_USB_OFF - HDD_USB_SPARE) / 2;
HDD_OFF_L = (BASE_W - HDD_L) / 2;

HDD_CABLE_THICK = 4.5;
HDD_CABLE_OFF_FROM_HDD_SIDE = 14.5 - (HDD_CABLE_THICK / 2);
HDD_CABLE_OFF_FROM_HDD_CENTER = (HDD_W_IN / 2) + HDD_CABLE_OFF_FROM_HDD_SIDE;
HDD_CABLE_OFF = HDD_OFF_W + HDD_CABLE_OFF_FROM_HDD_CENTER;
HDD_CABLE_OFF_H = 9;

module rounded_cube(w = 20, l = 20, h = 10, r = 5) {
    translate([0, 0, h/2]) {
        cube([w-(r*2), l, h], center=true);
        cube([w, l-(r*2), h], center=true);
        translate([+((w/2)-r), +((w/2)-r), 0]) cylinder(r=r, h=h, center=true);
        translate([+((w/2)-r), -((w/2)-r), 0]) cylinder(r=r, h=h, center=true);
        translate([-((w/2)-r), +((w/2)-r), 0]) cylinder(r=r, h=h, center=true);
        translate([-((w/2)-r), -((w/2)-r), 0]) cylinder(r=r, h=h, center=true);
    }
}

module upper_wall_profile() {
    RIM = (BASE_OUT - BASE_IN) / 2;
    translate([-WALL, 0]) square([WALL, BASE_WALL_H]);
    difference() {
        translate([-(RIM + WALL), BASE_WALL_H]) square([RIM + WALL, UPPER_WALL_H + FLOOR]);
        translate([0, BASE_WALL_H + UPPER_WALL_H + FLOOR]) scale([RIM/UPPER_WALL_H, 1]) circle(r = UPPER_WALL_H);
    }
}
//upper_wall_profile() {}

module upper_wall_extrusion() {
    for(m = [[0, 0], [1, 1]])
    mirror(m)
    for(m = [[0, 0], [1, 0]])
    mirror(m)
    for(m = [[0, 0], [0, 1]])
    mirror(m)
    translate([0, BASE_LINE / 2, 0])
    {
        rotate([90, 0, 0])
        linear_extrude(height = BASE_LINE / 2, center = false, convexity = 10, twist = 0)
        translate([BASE_OUT/2, 0, 0])
        for(i=[0:1:$children-1]) {
            children(i);
        }
        translate([BASE_LINE/2, 0, 0])
        rotate_extrude(angle = 45, convexity = 10)
        translate([BASE_OUT_R, 0, 0])
        for(i=[0:1:$children-1]) {
            children(i);
        }
    }
}

upper_wall_extrusion() {
    upper_wall_profile();
}

//square([BASE_OUT, BASE_OUT], center=true);

module rounded_slot(r=5, h=10) {
    H=20;
    rotate([-90, 0, 0]) union() {
        cylinder(r=r, h=H, center=true);
        translate([0, -h/2, 0]) cube([r*2, h, H], center=true);
    }

}

module base_pc(fh = BASE_FLOOR_H, wh = BASE_WALL_H) {
    difference() {
        union() {
            rounded_cube(w = BASE_W + BASE_WALL, l = BASE_W + BASE_WALL, h = fh + wh, r = BASE_R);
            rounded_cube(w = BASE_W + BASE_WALL + BASE_BRIM, l = BASE_W + BASE_WALL + BASE_BRIM, h = fh, r = BASE_R + BASE_WALL);
        }
        union() {
            translate([0, 0, fh]) rounded_cube(w = BASE_W, l = BASE_W, h = wh + 0.1, r = BASE_R);
        }
    }
}

module base_pc_test() {
    difference() {
        base_pc(fh = 1, wh = 2);
        translate([0, 0, -1]) rounded_cube(w = BASE_W - 10, l = BASE_W - 10, r = BASE_R);
    }
}

module base_hdd_on() {
    translate([HDD_OFF_W, HDD_OFF_L, (HDD_WALL_H / 2) + BASE_FLOOR_H])
    cube([HDD_W + HDD_WALL_THICK, HDD_L + HDD_WALL_THICK, HDD_WALL_H], center=true);
}

module base_hdd_off() {
    translate([HDD_OFF_W, HDD_OFF_L, (HDD_WALL_H / 2) + BASE_FLOOR_H])
    union() {
        cube([HDD_W, HDD_L, HDD_WALL_H + 0.1], center=true);
        translate([0, 0, 50 + (HDD_WALL_H / 2)]) cube([HDD_W, HDD_L + (BASE_WALL * 2) + 0.01, 100], center=true);
    }

    translate([HDD_CABLE_OFF, BASE_W/2, BASE_FLOOR_H + HDD_CABLE_OFF_H]) rounded_slot(r=HDD_CABLE_THICK/2, h=20);
}

module base() {
    difference() {
        union() {
            base_pc();
            base_hdd_on();
        }
        union() {
            base_hdd_off();
        }
    }

}

//rounded_slot();
//base_pc_test();

//base();


