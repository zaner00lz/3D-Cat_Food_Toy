CYLINDER_DIAMETER = 40;
CYLINDER_THICKNESS = 3;
//CYLINDER_LENGTH = 80;
CYLINDER_LENGTH = 30;
//CYLINDER_LENGTH = 20;
CYLINDER_EDGE = 2;

DIAMOND_HOLE_WIDTH = 8;
DIAMONDL_HOLE_HEIGHT = 4;
DIAMOND_HOLE_ANGLE = 12;
DIAMOND_HOLE_DISTANCE = 1;

DISPENSER_HOLE_DIAMETER = 12;

DETAIL = 20;
//DETAIL = 100;

module mainTube()
{
    difference()
    {
        cylinder(h = CYLINDER_LENGTH, r = CYLINDER_DIAMETER / 2, $fn = DETAIL);
        translate(v = [0, 0, -1])
            cylinder(h = CYLINDER_LENGTH + 2, r = (CYLINDER_DIAMETER - CYLINDER_THICKNESS - CYLINDER_THICKNESS) / 2, $fn = DETAIL);
    }
}

module edge(height)
{
    translate(v = [0, 0, height])
    {
        difference()
        {
            cylinder(h = CYLINDER_EDGE, r = CYLINDER_DIAMETER / 2, $fn = DETAIL);
            translate(v = [0, 0, -1])
                cylinder(h = CYLINDER_EDGE + 2, r = (CYLINDER_DIAMETER - CYLINDER_THICKNESS - CYLINDER_THICKNESS) / 2, $fn = DETAIL);
        }
    }
}

module displenserHole(height)
{
    translate(v = [0, 0, height])
        rotate(a = [90, 0, 0])
            cylinder(h = CYLINDER_DIAMETER, r = DISPENSER_HOLE_DIAMETER / 2, $fn = DETAIL);
}

module dispenserHoleRing(height)
{
    difference()
    {
        intersection()
        {
            translate(v = [0, 0, height])
                rotate(a = [90, 0, 0])
                    cylinder(h = CYLINDER_DIAMETER, r = DISPENSER_HOLE_DIAMETER / 2 + CYLINDER_EDGE, $fn = DETAIL);
            difference()
            {
                cylinder(h = CYLINDER_LENGTH, r = CYLINDER_DIAMETER / 2, $fn = DETAIL);
                translate(v = [0, 0, -1])
                    cylinder(h = CYLINDER_LENGTH + 2, r = (CYLINDER_DIAMETER - CYLINDER_THICKNESS - CYLINDER_THICKNESS) / 2, $fn = DETAIL);
            }
        }
        dispenserHole(height);
    }
}

module diamond()
{
    rotate(a = [90, 0, 0])
    {
        linear_extrude(height = CYLINDER_DIAMETER / 2, center = false, convexity = 3, twist = 0, slices = DETAIL)
            polygon(points=[[0,0],[DIAMONDL_HOLE_HEIGHT/2,DIAMOND_HOLE_WIDTH/2],[0,DIAMOND_HOLE_WIDTH]]);
    }
    rotate(a = [90, 0, -3])
    {
        linear_extrude(height = CYLINDER_DIAMETER / 2, center = false, convexity = 3, twist = 0, slices = DETAIL)
            polygon(points=[[0,0],[0,DIAMOND_HOLE_WIDTH],[DIAMONDL_HOLE_HEIGHT/-2,DIAMOND_HOLE_WIDTH/2]]);
    }
}

module holeMesh()
{
    for (angle = [0 : (DIAMOND_HOLE_ANGLE * 2) : 360])
    {
        rotate(a = [0, 0, angle])
        {
            for (z = [0 : DIAMOND_HOLE_WIDTH + DIAMOND_HOLE_DISTANCE : CYLINDER_LENGTH])
            {
                translate(v = [0, 0, z])
                    diamond();
            }
        }
        rotate(a = [0, 0, angle + DIAMOND_HOLE_ANGLE])
        {
            translate(v = [0, 0, (DIAMOND_HOLE_WIDTH + DIAMOND_HOLE_DISTANCE) / 2])
            {
                for (z = [0 : DIAMOND_HOLE_WIDTH + DIAMOND_HOLE_DISTANCE : CYLINDER_LENGTH])
                {
                    translate(v = [0, 0, z])
                        diamond();
                }
            }
        }
    }
}

difference()
{
    union()
    {
        difference()
        {
            mainTube();
            holeMesh();
        }
        dispenserHoleRing(CYLINDER_LENGTH / 2);
        edge(0);
        edge(CYLINDER_LENGTH - CYLINDER_EDGE);
    }
    displenserHole(CYLINDER_LENGTH / 2);
}
