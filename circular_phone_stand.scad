/* [Main] */
// in mm
stand_height = 65; // [50:5:100]
// in mm
stand_diameter = 50; // [30:5:50]
// in mm
stand_thickness = 2; // [2:0.5:5]
// in degrees
stand_angle = 30; // [20:5:50]
// in mm
stand_lip_depth = 8; // [5:1:15]
// in mm
front_lip_offset = 10; // [0:1:20]
// in mm
cable_hole_width = 5; // [3:1:10]

main();

module main()
{
    render(convexity = 1)
    difference() {
        tube();
        moved_cutout();
        cable_hole();
    }
}

module tube()
{
    linear_extrude(stand_height)
    difference() {
        circle(r=stand_diameter*0.5, $fn=180);
        circle(r=(stand_diameter*0.5)-stand_thickness, $fn=180);
    }
}

module moved_cutout()
{
    translate([front_lip_offset-(stand_diameter*0.5), 0, stand_height])
    rotate([0, -stand_angle, 0])
    translate([stand_diameter*0.5, 0, -stand_diameter])
    cutout();
}

module cutout()
{
    cube();
    lip();
}

module cube()
{
    linear_extrude(stand_diameter)
        square(size=stand_diameter, center=true);
}

module lip()
{
    translate([stand_lip_depth-(stand_diameter*0.5), 0, 0])
    rotate([0, stand_angle, 0])
    translate([stand_diameter*0.5, 0, 0])
    cube();
}

module cable_hole()
{
    translate([-stand_thickness, 0, 0])
    rotate([0, -90, 0])
    translate([0, 0, -stand_thickness])
    linear_extrude(stand_diameter*0.5)
    union() {
        translate([0, -cable_hole_width*0.5, 0])
            square(size=[cable_hole_width*0.5, cable_hole_width]);
        translate([cable_hole_width*0.5, 0, 0])
        circle(r=cable_hole_width*0.5, $fn=30);
    }
}