$fn = 64;

THICK = 4;
WIDTH = 25;
HEIGHT = 20;
LENGTH = 80;
SIDE_L = 50;
SIDE_H = 15;

HOLE_D = 4;
HOLE_L1 = 50;
HOLE_L2 = 70;
HOLE_H = 12;

module wardrobe_fix() {
    difference() {
        union() {
            translate([0, LENGTH / 2, THICK / 2]) cube([WIDTH, LENGTH, THICK], center=true);
            rotate([90, 0, 0]) translate([0, HEIGHT / 2, THICK / 2]) cube([WIDTH, HEIGHT, THICK], center=true);
            translate([+(WIDTH - THICK) / 2, SIDE_L / 2, THICK + (SIDE_H / 2)]) cube([THICK, SIDE_L, SIDE_H], center=true);
            translate([-(WIDTH - THICK) / 2, SIDE_L / 2, THICK + (SIDE_H / 2)]) cube([THICK, SIDE_L, SIDE_H], center=true);
        }
        union() {
            translate([0, 0, SIDE_H + THICK]) rotate([0, 90, 0]) translate([0, SIDE_L, 0]) scale([SIDE_H, SIDE_L, 1])  cylinder(r=1, h=HEIGHT + 100, center=true);
            translate([0, HOLE_L1, 0]) cylinder(r=HOLE_D/2, h=HEIGHT + 100, center=true);
            translate([0, HOLE_L2, 0]) cylinder(r=HOLE_D/2, h=HEIGHT + 100, center=true);
            translate([0, 0, HOLE_H]) rotate([90, 0, 0]) cylinder(r=HOLE_D/2, h=HEIGHT + 100, center=true);
        }
    }
}

wardrobe_fix();