$fn = 100;
use <commons.scad>

// BOX_L 92
// BOX_R 29

WIRE_THICK = 3;
PLATE_THICK = 2;
WALL_THICK = 2;
WALL_RIM_R = 4;

FIBER_PLATE_DY = 5;
FIBER_HOLE_Y = 10;

BOX_SIDE = 80;
HOLE_DX = 13;
HOLE_DY = 9;

BOX_EXTRA_Y_UP = 5;
BOX_EXTRA_Y_DOWN = 20;
BOX_EXTRA_X_LEFT = 5;
BOX_EXTRA_X_RIGHT = 44.5;

BOX_W = BOX_SIDE + BOX_EXTRA_X_LEFT + BOX_EXTRA_X_RIGHT;
BOX_H = BOX_SIDE + BOX_EXTRA_Y_UP + BOX_EXTRA_Y_DOWN;
BOX_THICK = WIRE_THICK + PLATE_THICK;

BOX_HOLE_RIM = 15;
BOX_HOLE_SIDE = BOX_SIDE - (BOX_HOLE_RIM * 2);

PIN_HOLE_1_X = BOX_EXTRA_X_LEFT + HOLE_DX;
PIN_HOLE_2_X = BOX_EXTRA_X_LEFT + BOX_SIDE - HOLE_DX;
PIN_HOLE_1_Y = BOX_EXTRA_Y_DOWN + HOLE_DY;
PIN_HOLE_2_Y = BOX_EXTRA_Y_DOWN + BOX_SIDE - HOLE_DY;
PIN_HOLE_R_OUT = 5;
PIN_HOLE_R_IN = 2;

rotate([0,180,0])
mirror([0,0,1])
difference () {
    union() {
        cube_rim([ BOX_W, BOX_H, BOX_THICK ], rim = WALL_THICK, r = WALL_RIM_R, center = [ false, false, false ]);
        cube_centered([ BOX_W, BOX_H, PLATE_THICK ], r = WALL_RIM_R, center = [ false, false, false ]);
        translate([ BOX_EXTRA_X_LEFT, BOX_EXTRA_Y_DOWN, 0])
            cube_centered([ BOX_SIDE, BOX_SIDE, PLATE_THICK + 0.5 ], r = WALL_RIM_R, center = [ false, false, false ]);
        translate([ PIN_HOLE_1_X, PIN_HOLE_1_Y, 0])
            cylinder(r = PIN_HOLE_R_OUT, h = BOX_THICK - 0.5);
        translate([ PIN_HOLE_2_X, PIN_HOLE_2_Y, 0])
            cylinder(r = PIN_HOLE_R_OUT, h = BOX_THICK - 0.5);
    }
    union() {
        translate([ BOX_EXTRA_X_LEFT + BOX_HOLE_RIM, BOX_EXTRA_Y_DOWN + BOX_HOLE_RIM, 0])
            cube_centered([ BOX_HOLE_SIDE, BOX_HOLE_SIDE, 10 ], r = WALL_RIM_R, center = [ false, false, true ]);
        translate([ PIN_HOLE_1_X, PIN_HOLE_1_Y, -1])
            cylinder(r = PIN_HOLE_R_IN, h = BOX_THICK + 2);
        translate([ PIN_HOLE_2_X, PIN_HOLE_2_Y, -1])
            cylinder(r = PIN_HOLE_R_IN, h = BOX_THICK + 2);
        translate([BOX_W, BOX_H - (FIBER_PLATE_DY + (FIBER_HOLE_Y / 2)), PLATE_THICK + 0.1])
            cube_centered([ 10, FIBER_HOLE_Y, WIRE_THICK ], r = 1, center = [ true, true, false ]);
    }
}
