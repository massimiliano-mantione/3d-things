$fn = 64;

HOLDER_L = 7;
HOLDER_W = 5;
DELTA = 0.6;

SLOT_R = 0.85;
SLOT_DL = -SLOT_R;
SLOT_DW = -HOLDER_W/2;

HOLDER_H = 10;
BASE_H = 2.5;

N = 3;
DISTANCE_W = 18;
BASE_L = 20;
BASE_W = DISTANCE_W * N;

DISPLACEMENT_L = -3;

BASE_RIM_R = 3;

module base() {
    translate([0, 0, BASE_H/2]) {
        cube([BASE_W + (BASE_RIM_R*2), BASE_L, BASE_H], center=true);
        cube([BASE_W, BASE_L + (BASE_RIM_R*2), BASE_H], center=true);
        translate([+BASE_W/2, +BASE_L/2, 0]) cylinder(r=BASE_RIM_R, h=BASE_H, center=true);
        translate([+BASE_W/2, -BASE_L/2, 0]) cylinder(r=BASE_RIM_R, h=BASE_H, center=true);
        translate([-BASE_W/2, +BASE_L/2, 0]) cylinder(r=BASE_RIM_R, h=BASE_H, center=true);
        translate([-BASE_W/2, -BASE_L/2, 0]) cylinder(r=BASE_RIM_R, h=BASE_H, center=true);
    }
}

function hypotenuse(l1, l2) = sqrt((l1*l1)+(l2*l2));
function leg(h, l) = sqrt((h*h)-(l*l));

module holder() {
    L2_MAX = HOLDER_L / 2;
    L2_MIN = L2_MAX - DELTA;
    W2_MAX = HOLDER_W / 2;
    W2_MIN = W2_MAX - DELTA;

    OUT_SMALL = hypotenuse(W2_MIN, DELTA);
    R_SMALL = OUT_SMALL * W2_MIN / DELTA;
    IN_SMALL = leg(R_SMALL, W2_MIN);

    OUT_BIG = hypotenuse(L2_MIN, DELTA);
    R_BIG = OUT_BIG * L2_MIN / DELTA;
    IN_BIG = leg(R_BIG, L2_MIN);

    C_SMALL = L2_MAX - R_SMALL;
    C_BIG = W2_MAX - R_BIG;

    difference() {
        intersection() {
            translate([0, +C_SMALL, BASE_H + (HOLDER_H / 2)]) cylinder(r=R_SMALL, h=HOLDER_H, center=true);
            translate([0, -C_SMALL, BASE_H + (HOLDER_H / 2)]) cylinder(r=R_SMALL, h=HOLDER_H, center=true);
            translate([+C_BIG, 0, BASE_H + (HOLDER_H / 2)]) cylinder(r=R_BIG, h=HOLDER_H, center=true);
            translate([-C_BIG, 0, BASE_H + (HOLDER_H / 2)]) cylinder(r=R_BIG, h=HOLDER_H, center=true);
        }
        translate([SLOT_DW, SLOT_DL, BASE_H + (HOLDER_H / 2)]) cylinder(r=SLOT_R, h=HOLDER_H*2, center=true);
    }
}

translate([-DISTANCE_W, DISPLACEMENT_L, 0]) holder();
translate([0, DISPLACEMENT_L, 0]) holder();
translate([+DISTANCE_W, DISPLACEMENT_L, 0]) holder();
base();
