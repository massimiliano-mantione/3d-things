$fn = 64;

BASE_L_DELTA = 16; // 210 - 194

// actual: 192
STAND_L = 194;
//STAND_L = 40;
// actual: 9
STAND_W = 10;

// actual: 210
BASE_L = 209;
//BASE_L = STAND_L + BASE_L_DELTA;
// actual: 20
BASE_W = 19;

// actual: 6.1
BASE_H = 5.6;

STAND_SINK = 3;;

BASE_INNER_W_SPACE = 2.5;
STAND_W_OFFSET = (BASE_W/2) - (STAND_W + BASE_INNER_W_SPACE);

OVERHANG_L = 90;
//OVERHANG_L = 30;
OVERHANG_OUT = 4;

OVERHANG_W = STAND_W + BASE_INNER_W_SPACE + OVERHANG_OUT;
OVERHANG_W_OFFSET = STAND_W_OFFSET  + (OVERHANG_W / 2);

OVERHANG_H = BASE_INNER_W_SPACE;

BASE_HOLLOW_H = 0.9;
BASE_HOLLOW_W = BASE_W - 4;
BASE_HOLLOW_L = BASE_L - 2;

//cylinder(r=R_SMALL, h=HOLDER_H, center=true);
//cube([BASE_W + (BASE_RIM_R*2), BASE_L, BASE_H], center=true);

module platform() {
  union() {
    translate([0, BASE_L/2, BASE_H/2]) cube([BASE_W, BASE_L, BASE_H], center=true);
    translate([0, 0, BASE_H/2]) cylinder(r=BASE_W/2, h=BASE_H, center=true);
  }
}

module overhang() {
  difference () {
    {
      translate([OVERHANG_W_OFFSET, 0, BASE_H])
      {
        translate([0, OVERHANG_L/2, OVERHANG_H/2]) cube([OVERHANG_W, OVERHANG_L, OVERHANG_H], center=true);
        translate([0, 0, 0]) rotate([0, 90, 0]) cylinder(r=OVERHANG_H, h=OVERHANG_W, center=true);
        translate([0, OVERHANG_L, 0]) rotate([0, 90, 0]) cylinder(r=OVERHANG_H, h=OVERHANG_W, center=true);
        translate([OVERHANG_W/2, OVERHANG_L/2, 0]) rotate([90, 0, 0]) cylinder(r=OVERHANG_H, h=OVERHANG_L, center=true);
        translate([OVERHANG_W/2, 0, 0]) sphere(r=OVERHANG_H);
        translate([OVERHANG_W/2, OVERHANG_L, 0]) sphere(r=OVERHANG_H);
      }
    }
    {
      cube([500, 500, BASE_H * 2], center=true);
    }
  }
}

module stand() {
  translate([(STAND_W/2) + STAND_W_OFFSET, 250, (BASE_H - STAND_SINK) + 50]) {
    cube([STAND_W, 500, 100], center=true);
  }
}

module base_hollow() {
  translate([0, BASE_HOLLOW_L/2, 0]) cube([BASE_HOLLOW_W, BASE_HOLLOW_L, BASE_HOLLOW_H*2], center=true);
}

module base() {
  difference() {
    union() {
      platform();
      overhang();
    }
    union() {
      stand();
      base_hollow();
    }
  }
}

base();

translate([50, 0, 0]) mirror([1, 0, 0]) base();
