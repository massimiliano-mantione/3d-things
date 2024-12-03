$fn = 64;

BASE_L = 47.5;
BASE_W = 22;

PIN_RADIUS_INNER = 1;
PIN_RADIUS_OUTER = 4.5/2;

BASE_H = 2;
PIN_H = 8;

HOLE_H = 30;

WALL_THICKNESS = 2;

HOLDER_OUT = (BASE_W/2) + 15;
HOLDER_IN = (BASE_W/2) - 5;
HOLDER_L = 40;
HOLDER_H = 15;

HOLDER_W = HOLDER_OUT + HOLDER_IN;
HOLDER_CENTER = (-HOLDER_OUT + HOLDER_IN) / 2;

module plate(w, l, h) {
    translate([0, 0, h/2]) {
        cube([w, l, h], center=true);
    }
}

module pin(r, h) {
    translate([0, 0, h/2]) {
        cylinder(r=r, h=h, center=true);
    }
}

module base() {
    difference() {
        plate(BASE_W + (PIN_RADIUS_OUTER*2), BASE_L, PIN_H);
        translate([0, 0, BASE_H]) plate(BASE_W + ((PIN_RADIUS_OUTER+WALL_THICKNESS)*2), BASE_L, PIN_H);
    }
    difference() {
        plate(BASE_W, BASE_L + (PIN_RADIUS_OUTER*2), PIN_H);
        translate([0, 0, BASE_H]) plate(BASE_W, BASE_L + ((PIN_RADIUS_OUTER-WALL_THICKNESS)*2), PIN_H);
    }
    translate([+BASE_W/2, +BASE_L/2, 0]) pin(r=PIN_RADIUS_OUTER, h=PIN_H);
    translate([+BASE_W/2, -BASE_L/2, 0]) pin(r=PIN_RADIUS_OUTER, h=PIN_H);
    translate([-BASE_W/2, +BASE_L/2, 0]) pin(r=PIN_RADIUS_OUTER, h=PIN_H);
    translate([-BASE_W/2, -BASE_L/2, 0]) pin(r=PIN_RADIUS_OUTER, h=PIN_H);
}

module pin_holes() {
    translate([0, 0, -HOLE_H/2]) {
        translate([+BASE_W/2, +BASE_L/2, 0]) pin(r=PIN_RADIUS_INNER, h=HOLE_H);
        translate([+BASE_W/2, -BASE_L/2, 0]) pin(r=PIN_RADIUS_INNER, h=HOLE_H);
        translate([-BASE_W/2, +BASE_L/2, 0]) pin(r=PIN_RADIUS_INNER, h=HOLE_H);
        translate([-BASE_W/2, -BASE_L/2, 0]) pin(r=PIN_RADIUS_INNER, h=HOLE_H);
    }
}


module holder_fill() {
    translate([HOLDER_CENTER, 0, 0])
    plate(HOLDER_W, HOLDER_L, HOLDER_H);
}

module holder_empty() {
    translate([HOLDER_CENTER, 0, BASE_H])
    plate(HOLDER_W - (WALL_THICKNESS*2), HOLDER_L + 1, HOLDER_H);
}

module holder() {
    difference() {
        holder_fill();
        holder_empty();
    }
}

module all() {
    difference() {
        translate() {
            base();
            holder_fill();
        }
        translate() {
            pin_holes();
            holder_empty();
        }
    }
}

all();