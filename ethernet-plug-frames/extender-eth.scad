$fn = 100;
use <commons.scad>

PLATE_W = 146;
PLATE_H = 126;
PLATE_ROUND_R = 2;

FRAME_HOLES_X = 98;
FRAME_HOLES_Y = 77;
FRAME_HOLE_D = 5;

PLATE_HOLES_X = 82.5;
PLATE_HOLE_D = 4.9;

BOX_IN_X = 75;
BOX_OUT_X = FRAME_HOLES_X + FRAME_HOLE_D;
BOX_IN_Y = 50;
BOX_OUT_Y = FRAME_HOLES_Y + FRAME_HOLE_D;

INNER_BOX_H = 15;
INNER_BOX_OUT_X = BOX_OUT_X - 10;
INNER_BOX_THICK = 20;


PLATE_THICK = 2;
BOX_DEPTH = 6 + PLATE_THICK;
WALL_THICK = 1;
WALL_W = 2;

difference () {
    union() {
        cube_rim([ PLATE_W, PLATE_H, PLATE_THICK + WALL_THICK ], rim = WALL_W, r = PLATE_ROUND_R, center = [ true, true, false ]);
        cube_centered([ PLATE_W, PLATE_H, PLATE_THICK ], r = PLATE_ROUND_R, center = [ true, true, false ]);
        for (m=[0:1]) mirror([m, 0, 0]) {
            translate([BOX_IN_X / 2, 0, 0])
                cube_centered([ (BOX_OUT_X - BOX_IN_X) / 2, BOX_OUT_Y, BOX_DEPTH ], r = FRAME_HOLE_D / 2, center = [ false, true, false ]);

        }
    }
    union() {
        cube_centered([ BOX_IN_X, BOX_IN_Y, 20 ], r = PLATE_ROUND_R, center = [ true, true, true ]);
        hole(d = FRAME_HOLE_D, t = [ FRAME_HOLES_X, FRAME_HOLES_Y ], n = [ 2, 2 ], center = [ true, true, true ], h = 50);
        hole(d = PLATE_HOLE_D, t = [ PLATE_HOLES_X, 0 ], n = [ 2, 1 ], center = [ true, true, true ], h = 50);
        matrix(t = [BOX_OUT_X, BOX_OUT_Y], n = 2, m = 2, z_t = PLATE_THICK)
                cube_centered([ FRAME_HOLE_D * 2, FRAME_HOLE_D * 2, 20 ], r = FRAME_HOLE_D / 2, center = [ true, true, false ]);
    }
}
