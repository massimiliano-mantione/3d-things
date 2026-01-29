$fn = 100;

SUB_HEIGHT = 100;

PIN_STEP = 2.54;

M4_HOLE = 4.1;
M4_GRIP = 3.8;
M4_FREE_SPACE = 8;

M3_HOLE = 3.1;
M3_GRIP = 2.8;
M3_FREE_SPACE = 6;

M2_HOLE = 2.1;
M2_GRIP = 1.8;

M3_NUT = 6;
M3_NUT_HEIGHT = 4;

M2_NUT = 5;
M2_NUT_HEIGHT = 2.5;

MAX_HEIGHT = 200;

function x(v) = [ v, 0, 0 ];
function y(v) = [ 0, v, 0 ];
function z(v) = [ 0, 0, v ];
function xyz(v) = [ v, v, v ];

module hole(d = 3, t = [ 0, 0 ], n = [ 1, 1 ], center = [ true, true, true ], h = 2 * MAX_HEIGHT)
{
    translate([ center.x ? (-t.x * (n.x - 1) / 2) : 0, center.y ? (-t.y * (n.y - 1) / 2) : 0, center.z ? (-h / 2) : 0 ])
    {
        for (x = [1:n.x])
        {
            for (y = [1:n.y])
            {
                translate([ (x - 1) * t.x, (y - 1) * t.y, 0 ]) cylinder(r = d / 2, h = h);
            }
        }
    }
}

// CUBES

module cube_centered(size, r = 0, center = [ true, true, false ])
{
    r = (r > 0) ? r : 0;
    translate([ center.x ? (-size.x / 2) : 0, center.y ? (-size.y / 2) : 0, center.z ? (-size.z / 2) : 0 ]) union()
    {
        for (i = [ 0, 1 ], j = [ 0, 1 ])
        {
            translate([ r + i * (size.x - 2 * r), r + j * (size.y - 2 * r), 0 ]) cylinder(h = size.z, r = r);
        }
        for (i = [ [ 0, 1 ], [ 1, 0 ] ])
        {
            translate([ i.x * r, i.y * r, 0 ]) cube(size - [ i.x * 2 * r, i.y * 2 * r, 0 ]);
        }
    }
}

module cube_rim(size, rim, r = 0, center = [ true, true, false ])
{
    translate([ center.x ? (-size.x / 2) : 0, center.y ? (-size.y / 2) : 0, center.z ? (-size.z / 2) : 0 ]) difference()
    {
        cube_centered(size = size, r = r, center = [ false, false, false ]);
        translate([ rim, rim, -1 ]) cube_centered(size = (size - [ 2 * rim, 2 * rim, 0 ] + z(2)), r = r - rim,
                                                  center = [ false, false, false ]);
    }
}

module cube_mirrored_x(size, t = [ 0, 0, 0 ])
{
    module left()
    {
        translate(t + [ -size.x, 0, 0 ]) cube(size);
    }
    left();

    mirror([ 1, 0, 0 ]) left();
}

module cube_sub(size, r = 0, center = [ true, true, false ])
{
    cube_centered([ size.x, size.y, SUB_HEIGHT ], r = r, center = center);
}

// RAYS

module ray(angle_x, angle_z, s = 1, l = 100, start = [ 10, 10 ])
{
    x = start.x * s;
    z = start.y * s;

    s_x = (2 * (l * tan(angle_x / 2)) + x) / x;
    s_z = (2 * (l * tan(angle_z / 2)) + z) / z;

    rotate([ -90, 0, 0 ]) linear_extrude(height = l, scale = [ s_x, s_z ]) square([ x, z ], center = true);
}

// CYLINDERS

module cylinder_h(d, l)
{
    rotate([ 0, 90, 0 ]) cylinder(r = d / 2, h = l);
}

module cylinder_h_cut(d, h, l)
{
    difference()
    {
        cylinder_h(d, l);

        translate([ -1, -d / 2, h / 2 ]) cube([ l + 2, d, d / 2 ]);

        mirror([ 0, 0, 1 ]) translate([ -1, -d / 2, h / 2 ]) cube([ l + 2, d, d / 2 ]);
    }
}

module matrix(t = [ 0, 0 ], n = 1, m = 1, center = [ true, true ], z_t = 0)
{
    translate([ center.x ? -(t.x * (n - 1) / 2) : 0, center.y ? -(t.y * (m - 1) / 2) : 0, z_t ]) for (i = [0:1:n - 1],
                                                                                                      j = [0:1:m - 1])
    {
        translate([ i * t.x, j * t.y, 0 ]) children();
    }
}

module mirror_copy(v)
{
    mirror(v = v) children();

    children();
}

module _bool()
{
    for (i = [0:1:$children - 1])
    {
        echo(i);
    }
}

module test()
{
    _bool()
    {
        cube([ 1, 1, 1 ]);
        _diff();
        cube([ 1, 1, 1 ]);
        cube([ 1, 1, 1 ]);
        cube([ 1, 1, 1 ]);
    }
}

module click(h, w = 5, l = 2, tip_l = 1, tip_h = 1.5)
{
    translate(y(-l)) difference()
    {
        union()
        {
            cube_centered([ w, l, h + tip_h ], center = [ true, false, false ]);
            translate(z(h)) cube_centered([ w, l + tip_l, tip_h ], center = [ true, false, false ]);
        }
        translate([ 0, l + tip_l, h ]) rotate(x(atan((tip_l + l / 2) / tip_h)))
            cube_centered([ w + 1, 2 * (l + tip_l + tip_h), 2 * (l + tip_l + tip_h) ], center = [ true, false, false ]);
    }
}

module side_t(size = [ 0, 0, 0 ])
{
    translate([ size.x / 2, size.y / 2, 0 ]) rotate(z(90)) children();

    translate([ -size.x / 2, size.y / 2, 0 ]) rotate(z(-90)) children();
}

module front_t(size = [ 0, 0, 0 ])
{
    translate([ 0, 0, 0 ]) children();

    translate([ 0, size.y, 0 ]) rotate(z(180)) children();
}

module lock(w = 5, l = 2)
{
    intersection()
    {
        rotate(x(45)) rotate(y(90)) cube_centered([ sqrt(2) * l, sqrt(2) * l, w ], center = [ true, true, true ]);

        cube_centered([ w + 1, l, 2 * l ], center = [ true, false, true ]);
    }
}

module
line(thickness, points = [[0, 0]], rounded_ends = false) {
    for (i = [0 : (len(points) - 1)]) {
        if (i != (len(points) - 1)) {
            lenght = sqrt(pow(points[i].x - points[i+1].x, 2) + pow(points[i].y - points[i+1].y, 2));
            angle = atan((points[i].y - points[i+1].y) / (points[i].x - points[i+1].x));
            translate([
                (points[i].x + points[i+1].x) / 2,
                (points[i].y + points[i+1].y) / 2,
                0])
            rotate([0, 0, angle])
                square([lenght, thickness], center=true);
        }
        if (rounded_ends || (i != 0 && i != (len(points) - 1)))
        translate([points[i].x, points[i].y, 0]) 
            circle(r = thickness / 2);
    }
}
