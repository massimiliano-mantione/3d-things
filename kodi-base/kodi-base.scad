$fn = 64;

// r * sqrt(2) = r + d
// r = (r + d) / sqrt(2)
// r = (r / sqrt(2)) + (d / sqrt(2)) 
// r - (r / sqrt(2)) = (d / sqrt(2)) 
// r - (r / sqrt(2)) = (d / sqrt(2)) 
// ((r * sqrt(2)) - r) = d
// r * (sqrt(2) - 1) = d
// r = d / (sqrt(2) - 1)

BASE_W = 108;
// BASE_DIAG = 142;
// BASE_DIAG_MAX = BASE_W * sqrt(2);
// BASE_DIAG_DELTA = (BASE_DIAG_MAX - BASE_DIAG) / 2;
// BASE_R = BASE_DIAG_DELTA / (sqrt(2) - 1); // 12.95
BASE_R = 12;

BASE_WALL = 2;
BASE_BRIM = 5;

BASE_FLOOR_H = 2;
BASE_WALL_H = 21.5;

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
base_pc_test();

//base();


