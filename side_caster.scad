thickness = 3;
frame_height = 30;
frame_width = 20;
frame_depth = 25;
frame_bottom_extension_width = 8;
screw_hole_diameter = 4;
axle_diameter = 4;
clip_hole_depth = 8;

wheel_diameter = 45;
wheel_width = 12;

clip_hole_diameter = clip_hole_diameter - 0.25;
axle_hole_diameter = axle_diameter - 0.1;

//rotate([0,-40,0])
//rotate([90,0,0])
//translate([0,0,-frame_height/2])
    main();

module main()
{
    translate([0,40,0])
        frame();
    translate([0,-40,0])
        rotate([0,90,0])
            wheel();
    axle();
}

module frame()
{
    union()
    {
        top();
        side(-1);
        side(1);
        bottom();
    }
}

module top()
{
    linear_extrude(thickness)
        square(size=[frame_width,frame_depth], center=true);
}

module side(side)
{
    translate([side * (frame_width - thickness)/2,0,0])
        translate([-thickness/2,0,frame_height/2])
            rotate([0,90,0])
                linear_extrude(thickness)
                    side_piece();
}

module side_piece()
{
    difference()
    {
        square(size=[frame_height,frame_depth], center=true);
        side_hole(0.25,0.25);
        side_hole(0.75,0.25);
        clip_hole();
    }
}

module side_hole(x_fraction, y_fraction)
{
    translate([-(frame_depth * y_fraction)+(frame_height/2),(frame_depth * x_fraction)-(frame_depth/2),0])
    circle(screw_hole_diameter/2, $fn = 50);
}

module clip_hole()
{
    translate([-clip_hole_depth,0])
    union()
    {
        circle(clip_hole_diameter/2, $fn = 50);
        polygon(points=[[0,-clip_hole_diameter*0.35],[0,clip_hole_diameter*0.35],[-clip_hole_depth,clip_hole_diameter*0.5],[-clip_hole_depth,-clip_hole_diameter*0.5]], paths=[[0,1,2,3,0]]);
    }
}

module bottom()
{
    translate([(frame_width + frame_bottom_extension_width)/2,0,frame_height-thickness])
        linear_extrude(thickness)
            bottom_piece();
}

module bottom_piece()
{
    difference()
    {
        square(size=[frame_bottom_extension_width,frame_depth], center=true);
        bottom_hole(0.25);
    }
}

module bottom_hole(fraction)
{
    circle(screw_hole_diameter/2, $fn = 50);
}

module wheel()
{
    union()
    {
        wheel_outer();
        wheel_inner();
        spokes();
    }
}

module wheel_outer()
{
    rotate_extrude($fn = 50)
        translate([(wheel_diameter - wheel_width)/2,0,0])
            difference()
            {
                circle(r=wheel_width/2, $fn = 50);
//                translate([-wheel_width,-(wheel_width/2)])
//                    square(wheel_width);
            }
}

module wheel_inner()
{
    rotate_extrude($fn = 50)
        translate([(axle_hole_diameter + thickness)/2,0,0])
            rotate([0,0,90])
                square(thickness, center=true);
}

module spokes()
{
    for (spoke_angle = [0:360/5:359])
        spoke(spoke_angle);
}

module spoke(spoke_angle)
{
    rotate([0,0,spoke_angle])
        translate([0,(axle_hole_diameter + thickness)/2,0])
            rotate([-90,0,0])
                linear_extrude((wheel_diameter - wheel_width - thickness)/2)
                    square(thickness, center=true);
}

module axle()
{
    translate([-(frame_width/2),0,0])
    rotate([0,90,0])
    linear_extrude(frame_width)
        circle(r=axle_diameter/2, $fn = 50);
}
