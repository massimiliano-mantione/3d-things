$fn = 64;

MAGNET_H = 3;
SENSOR_H = 2;
MAGNET_SENSOR_H = MAGNET_H + SENSOR_H;

MAGNET_D_OUT = 10;
MAGNET_D_IN = 7;

MOTOR_D_OUT = 35;
MOTOR_D_IN = 5;
MOTOR_SHAFT_D = 4;


MOTOR_H = 15;

MOTOR_FIX_HOLE_D = 3;

MOTOR_BASE_HOLE_D = 12;

MOTOR_BASE_D1 = 16;
MOTOR_BASE_D2 = 19;

MOTOR_TOP_D1 = 16;
MOTOR_TOP_D2 = 16;

MOTOR_TOP_H = 10;

DRIVER_SIDE = 20;
DRIVER_CORNER_HOLE_D = 2;

DRIVER_PILLAR_D = 5;
DRIVER_PILLAR_FIX_H = 2;
DRIVER_INNER_FIX_L = 8;
DRIVER_INNER_FIX_W = 1;

BASE_H = 3;

BASE_W = 20;
BASE_L = 50;

BASE_FOOT_W = 50;
BASE_FOOT_L = 20;
BASE_FOOT_HOLE_W = 40;
BASE_FOOT_HOLE_WL = 10;
BASE_FOOT_HOLE_D = 2;
BASE_FOOT_HOLE_HEAD_D = 4;

BASE_LEG_W = 8;
BASE_LEG_L = 50;

module driver_pillar() {
    translate([0, 0, MAGNET_SENSOR_H/2])
    union() {
        difference() {
            translate([0, 0, DRIVER_PILLAR_FIX_H/2]) cylinder(r=DRIVER_PILLAR_D/2, h=MAGNET_SENSOR_H + DRIVER_PILLAR_FIX_H, center=true);
            translate([DRIVER_PILLAR_D/2, DRIVER_PILLAR_D/2, 0]) cube([DRIVER_PILLAR_D, DRIVER_PILLAR_D, MAGNET_SENSOR_H*2], center=true);
        }
        translate([0, 0, -MAGNET_SENSOR_H/4]) cylinder(r=DRIVER_PILLAR_D/2, h=MAGNET_SENSOR_H/2, center=true);
        rotate([0, 0, 45]) cube([DRIVER_INNER_FIX_L, DRIVER_INNER_FIX_W, MAGNET_SENSOR_H], center=true);
    }

}

module driver_pillar_hole() {
    translate([0, 0, MAGNET_SENSOR_H/2])
    cylinder(r=DRIVER_CORNER_HOLE_D/2, h=MAGNET_SENSOR_H*2, center=true);    
}

module driver_corner_fix() {
    difference() {
        driver_pillar();
        driver_pillar_hole();
    }
}

module driver_corners() {
    translate([+DRIVER_SIDE/2, +DRIVER_SIDE/2, 0]) rotate([0, 0, 180]) driver_corner_fix();
    translate([+DRIVER_SIDE/2, -DRIVER_SIDE/2, 0]) rotate([0, 0, 90]) driver_corner_fix();
    translate([-DRIVER_SIDE/2, +DRIVER_SIDE/2, 0]) rotate([0, 0, -90]) driver_corner_fix();
    translate([-DRIVER_SIDE/2, -DRIVER_SIDE/2, 0]) rotate([0, 0, 0]) driver_corner_fix();
}

AS5048A_BASE_W = 26;
AS5048A_BASE_L = 11;
AS5048A_BASE_H = 2;
AS5048A_H = 2.5;
MAGNET_H = 4;

AS5048A_HOLE_D = 2;
AS5048A_SUPP_D = MOTOR_FIX_HOLE_D + 2;
AS5048A_SUPP_H = AS5048A_H + MAGNET_H + AS5048A_BASE_H + 0.5 - BASE_H;
AS5048A_SUPP_W = 12;

AS5048A_CLEAR_W = AS5048A_SUPP_W + 5;

module as5048a_support_holes() {
    union() {
        translate([+AS5048A_SUPP_W/2, 0, 0]) cylinder(r=AS5048A_HOLE_D/2, h=50, center=true);
        translate([-AS5048A_SUPP_W/2, 0, 0]) cylinder(r=AS5048A_HOLE_D/2, h=50, center=true);
        translate([+MOTOR_BASE_D2/2, 0, 0]) cylinder(r=MOTOR_FIX_HOLE_D/2, h=50, center=true);
        translate([-MOTOR_BASE_D2/2, 0, 0]) cylinder(r=MOTOR_FIX_HOLE_D/2, h=50, center=true);
    }
}

module as5048a_support_pillars() {
    union() {
        translate([+MOTOR_BASE_D2/2, 0, AS5048A_SUPP_H/2]) cylinder(r=AS5048A_SUPP_D/2, h=AS5048A_SUPP_H, center=true);
        translate([-MOTOR_BASE_D2/2, 0, AS5048A_SUPP_H/2]) cylinder(r=AS5048A_SUPP_D/2, h=AS5048A_SUPP_H, center=true);
    }
}

module as5048a_support() {
    difference() {
        union() {
            as5048a_support_pillars();
            translate([0, 0, AS5048A_BASE_H/2]) {
                intersection() {
                    cube([AS5048A_BASE_W, AS5048A_BASE_L, AS5048A_BASE_H], center=true);
                    cylinder(r=AS5048A_BASE_W/2, h=AS5048A_BASE_H, center=true);
                }
            }
        }
        union() {
            as5048a_support_holes();
            translate([0, 0, AS5048A_BASE_H + 25]) {
                cube([AS5048A_CLEAR_W, AS5048A_CLEAR_W, 50], center=true);
            }
        }
    }
}

module base_plate() {
    difference() {
        union() {
            translate([0, 0, BASE_H/2]) {
                cylinder(r=MOTOR_D_OUT/2, h=BASE_H, center=true);
                cube([BASE_W, BASE_L, BASE_H], center=true);
            }
        }
        union() {
            cylinder(r=MOTOR_BASE_HOLE_D/2, h=50, center=true);
            translate([+MOTOR_BASE_D2/2, 0, 0]) cylinder(r=MOTOR_FIX_HOLE_D/2, h=50, center=true);
            translate([-MOTOR_BASE_D2/2, 0, 0]) cylinder(r=MOTOR_FIX_HOLE_D/2, h=50, center=true);
            translate([0, +MOTOR_BASE_D1/2, 0]) cylinder(r=MOTOR_FIX_HOLE_D/2, h=50, center=true);
            translate([0, -MOTOR_BASE_D1/2, 0]) cylinder(r=MOTOR_FIX_HOLE_D/2, h=50, center=true);
        }
    }
}

module base_foot() {
    translate([0, -(BASE_L + BASE_H) / 2, BASE_FOOT_L/2])
    rotate([-90, 0, 0])
    difference() {
        union() {
            cube([BASE_FOOT_W, BASE_FOOT_L, BASE_H], center=true);
            translate([-(BASE_H - BASE_W) / 2, (BASE_FOOT_L / 4) - BASE_H, (BASE_H / 2) + (BASE_FOOT_L / 4)]) cube([BASE_H, BASE_FOOT_L / 2, BASE_FOOT_L / 2], center=true);
            translate([+(BASE_H - BASE_W) / 2, (BASE_FOOT_L / 4) - BASE_H, (BASE_H / 2) + (BASE_FOOT_L / 4)]) cube([BASE_H, BASE_FOOT_L / 2, BASE_FOOT_L / 2], center=true);
        }
        union() {
            translate([+BASE_FOOT_HOLE_W/2, +BASE_FOOT_HOLE_WL/2, 0]) cylinder(r=BASE_FOOT_HOLE_D/2, h=50, center=true);
            translate([-BASE_FOOT_HOLE_W/2, +BASE_FOOT_HOLE_WL/2, 0]) cylinder(r=BASE_FOOT_HOLE_D/2, h=50, center=true);
            translate([+BASE_FOOT_HOLE_W/2, -BASE_FOOT_HOLE_WL/2, 0]) cylinder(r=BASE_FOOT_HOLE_D/2, h=50, center=true);
            translate([-BASE_FOOT_HOLE_W/2, -BASE_FOOT_HOLE_WL/2, 0]) cylinder(r=BASE_FOOT_HOLE_D/2, h=50, center=true);
            translate([0, -BASE_H, (BASE_H + BASE_FOOT_L) / 2]) rotate([0, 90, 0]) cylinder(r=BASE_FOOT_L/2, h=50, center=true);
        }
    }
}

module base_mosquito() {
    driver_corners();
    base_plate();
    base_foot();
}

module base_as5048a() {
    base_plate();
    base_foot();
}

module base_leg() {
    difference() {
        union() {
            cube([BASE_LEG_W, BASE_LEG_L, BASE_H], center=true);
        }
        translate([0, -10, 0])
        union() {
            translate([0, +BASE_FOOT_HOLE_WL/2, 0]) cylinder(r=BASE_FOOT_HOLE_D/2, h=50, center=true);
            translate([0, -BASE_FOOT_HOLE_WL/2, 0]) cylinder(r=BASE_FOOT_HOLE_D/2, h=50, center=true);
            translate([0, +BASE_FOOT_HOLE_WL/2, 25]) cylinder(r=BASE_FOOT_HOLE_HEAD_D/2, h=50, center=true);
            translate([0, -BASE_FOOT_HOLE_WL/2, 25]) cylinder(r=BASE_FOOT_HOLE_HEAD_D/2, h=50, center=true);
        }
    }
}


module shaft_fix() {
    difference() {
        union() {
            translate([0, 0, MAGNET_H/2]) cylinder(r=MAGNET_D_IN/2, h=MAGNET_H, center=true);
            translate([0, 0, (MOTOR_H/2) + MAGNET_H]) cylinder(r=MOTOR_D_IN/2, h=MOTOR_H, center=true);
        }
        cylinder(r=MOTOR_SHAFT_D/2, h=50, center=true);
    }
}

as5048a_support();
//base_as5048a();

//translate([35, 0, 0]) base_leg();
//translate([-35, 0, 0]) base_leg();
//shaft_fix();