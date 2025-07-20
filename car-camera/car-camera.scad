$fn = 64;

W = 15;
L = 20;
H = 5;
HR = 2;
HL = 10.9/2;

module car_camera() {
    difference() {
        union() {
            cube([W, L, H], center=true);
        }
        union() {
            translate([+HL, 0, 0]) cylinder(r=HR, h=50, center=true);;
            translate([-HL, 0, 0]) cylinder(r=HR, h=50, center=true);;
        }
    }
}

car_camera();