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

UPPER_SNAP_D_OUT = 54;
UPPER_SNAP_W = 3.5;
UPPER_SNAP_H = 3;
UPPER_SNAP_SIDE = UPPER_SNAP_H / sqrt(2);
UPPER_SNAP_OFF_IN = (UPPER_SNAP_D_OUT - UPPER_SNAP_W) / 2;
UPPER_SNAP_OFF_L = BASE_IN / 2;
UPPER_SNAP_OFF_H = BASE_WALL_H + FLOOR + UPPER_WALL_H - UPPER_SNAP_H;

LOWER_SNAP_L = 40;
LOWER_SNAP_H = 3.5;
LOWER_SNAP_SIDE = LOWER_SNAP_H / sqrt(2);
LOWER_SNAP_OFF = (BASE_OUT - WALL) / 2;
LOWER_SNAP_OFF_H = 3;

HDD_PAD = 1.5;
HDD_W_IN = 70;
HDD_L_IN = 101;
HDD_W = HDD_W_IN + (HDD_PAD * 2);
HDD_L = HDD_L_IN + (HDD_PAD * 2);

HDD_WALL_H = 4;
HDD_WALL_THICK = 1;

HDD_USB_OFF = 21;
HDD_USB_SPARE = BASE_W - (HDD_W + HDD_USB_OFF);

HDD_OFF_W = 0;
HDD_OFF_L = -7.5;

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
        translate([-RIM, BASE_WALL_H]) square([RIM, UPPER_WALL_H + FLOOR]);
        translate([0, BASE_WALL_H + UPPER_WALL_H + FLOOR]) scale([(RIM - WALL)/UPPER_WALL_H, 1]) circle(r = UPPER_WALL_H);
    }
}
// upper_wall_profile();

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

module upper_snaps() {
    for(dx = [1, -1])
    for(dy = [1, -1])
    translate([dx * UPPER_SNAP_OFF_IN, dy * UPPER_SNAP_OFF_L, UPPER_SNAP_OFF_H])
    rotate([45, 0, 0])
    cube([UPPER_SNAP_W, UPPER_SNAP_SIDE, UPPER_SNAP_SIDE]);
}

module lower_snaps(l) {
    for(mx = [0, 1])
    mirror([mx, 0, 0])
    translate([LOWER_SNAP_OFF, 0, LOWER_SNAP_OFF_H])
    difference() {
        rotate([0, -45, 0]) translate([0, -l/2, 0]) cube([LOWER_SNAP_SIDE, l, LOWER_SNAP_SIDE]);
        translate([0.01, -(l+1)/2, -1]) cube([LOWER_SNAP_SIDE, (l+1), LOWER_SNAP_SIDE * 2]);
    }
}

OUTER_SNAP_OFF = 10;
OUTER_SNAP_W = 10;

module outer_snaps() {
    for(m = [[0, 0], [1, 1]])
    mirror(m)
    for(m = [[0, 0], [1, 0]])
    mirror(m)
    for(m = [[0, 0], [0, 1]])
    mirror(m)
    translate([-OUTER_SNAP_OFF, (BASE_OUT / 2) - (WALL*2), 0])
    rotate([0, -90, 0])
    linear_extrude(height = OUTER_SNAP_W, center = false, convexity = 10, twist = 0)
    polygon(points = [ [0,0],[FLOOR,0],[FLOOR,WALL*2],[0,WALL] ]);
}
//outer_snaps();

module upper_base() {
    upper_snaps();
    lower_snaps(LOWER_SNAP_L);
    upper_wall_extrusion() {
        upper_wall_profile();
    }
}

LOVER_WALL_H = 5;
LOWER_BASE_R = (BASE_OUT / 2) - (BASE_LINE / 2);

module lower_wall_profile() {
    difference() {
        translate([-(WALL * 2), 0]) square([WALL, LOVER_WALL_H]);
        rotate([0, 0, 45]) square([WALL * 2 * sqrt(2), WALL * 2 * sqrt(2)], center = true);
    }
    translate([-(LOWER_BASE_R), 0]) square([(LOWER_BASE_R - (WALL * 2)), FLOOR]);
}
//lower_wall_profile();

module base_hdd_on() {
    translate([HDD_OFF_W, HDD_OFF_L, (HDD_WALL_H / 2) + FLOOR])
    cube([HDD_W + HDD_WALL_THICK, HDD_L + HDD_WALL_THICK, HDD_WALL_H], center=true);
}

module base_hdd_off() {
    translate([HDD_OFF_W, HDD_OFF_L, (HDD_WALL_H / 2) + FLOOR])
    cube([HDD_W, HDD_L, HDD_WALL_H + 0.1], center=true);
}

module base_hdd() {
    difference() {
        base_hdd_on();
        base_hdd_off();
    }
}



module lower_base() {
    

    translate([0, 0, FLOOR]) {
        base_hdd();
        difference() {
            for(mx = [0, 1])
            mirror([mx, 0, 0])
            translate([WALL-(BASE_OUT / 2), 0, 0])
            translate([WALL, 0, LOWER_SNAP_OFF_H]) cube([WALL * 2, LOWER_SNAP_L - 0.1, LOWER_SNAP_OFF_H * 2], center = true);
            lower_snaps(LOWER_SNAP_L);
        }
    }
    outer_snaps();
    upper_wall_extrusion() {
        lower_wall_profile();
    }
    translate([0, 0, FLOOR / 2]) cube([BASE_LINE, BASE_LINE, FLOOR], center = true);
}

//translate([0, 0, 10]) upper_base();

lower_base();


//square([BASE_OUT, BASE_OUT], center=true);
