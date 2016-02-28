/* [Global] */
// thickness of the walls
thickness = 3; // [3:8]
// width, excluding the outside walls
innerWidth = 194; // [10:1000]
// depth, excluding the back wall
innerDepth = 100; // [10:500]
// heights of the rows, from bottom to top
innerHeights = [45, 40, 40];
// number of drawers per row, from bottom to top
drawersPerLevel = [1, 2, 3];

// which part to render?
part = "frame"; // [frame:Frame,drawer:Drawer]

/* [Frame] */
// width of the bars on the back wall
backBarWidth = 5; // [3:100]
// approximate gap between the back wall bars
approximateBackBarGap = 20; // [0:100]

/* [Drawer] */
// render a drawer for this row, counting from the bottom row. Zero based.
drawerRowFromBottom = 0; // [0:10]
// diameter for the finger hole
fingerHoleDiameter = 20; // [10:30]

/* [Hidden] */
innerHeight = ((len(innerHeights)-1) * thickness) + sum(innerHeights);
outerHeight = innerHeight + (2 * thickness);
outerWidth = innerWidth + (2 * thickness);

echo ("total height: ", outerHeight);
echo ("total width: ", outerWidth);

// back bars
gaps = ceil(innerWidth / (backBarWidth + approximateBackBarGap));
bars = gaps - 1;
total_bar_width = backBarWidth * (gaps - 1);
total_gap_width = innerWidth - total_bar_width;
gap_width = total_gap_width / gaps;
/*echo("gaps", gaps);
echo("total_bar_width", total_bar_width);
echo("total_gap_width", total_gap_width);
echo("gap_width", gap_width);*/

main();

function sum(v,n=999, i = 0) = i < len(v) && i < n ? v[i] + sum(v,n, i+1) : 0;

module main()
{
  if (part == "frame")
  {
    frame();
  }
  else if (part == "drawer")
  {
    drawerCountForRow = drawersPerLevel[drawerRowFromBottom];
    drawerWidth = (innerWidth / drawerCountForRow) - 1;

    drawerHeight = innerHeights[drawerRowFromBottom] - 1;
    drawer(drawerWidth, drawerHeight);
  }
}

module frame()
{
  translate([-outerWidth/2, -outerHeight/2, 0])
  {
    shell();
    /*solid_back();*/
    gap_back();
    shelves();
  }
}

module shell()
{
  linear_extrude(height=innerDepth + thickness)
  shell_shape();
}

module shell_shape()
{
  union()
  {
    translate([0, thickness, 0])
      square([thickness, innerHeight]);
    translate([thickness + innerWidth, thickness, 0])
      square([thickness, innerHeight]);
    translate([thickness, 0, 0])
      square([innerWidth, thickness]);
    translate([thickness, thickness + innerHeight, 0])
      square([innerWidth, thickness]);

    corner(0);
    translate([thickness + innerWidth, 0, 0])
      corner(90);
    translate([thickness + innerWidth, thickness + innerHeight, 0])
      corner(180);
    translate([0, thickness + innerHeight, 0])
      corner(270);
  }
}

module corner(rotation)
{
  translate([thickness/2, thickness/2, 0])
  rotate([0, 0, rotation])
  translate([-thickness/2, -thickness/2, 0])
    intersection()
    {
      translate([thickness, thickness, 0])
        circle(thickness);
      square(thickness, thickness);
    }
}

module solid_back()
{
  translate([thickness, thickness])
    linear_extrude(height=thickness)
    {
      square([innerWidth, innerHeight]);
    }
}

module gap_back()
{
  linear_extrude(thickness)
    gap_back_shape();
}

module gap_back_shape()
{
  offset = thickness + gap_width;
  step = backBarWidth + gap_width;

  for (i=[0:bars-1]) {
    translate([offset + (step * i), thickness])
      square([backBarWidth, innerHeight]);
  }
}

module shelves()
{
  linear_extrude(innerDepth + thickness)
    shelves_shape();
}

module shelves_shape()
{
  // for each row...
  for (i=[0:len(innerHeights)-1]) {
    // make a shelf for the drawers to sit on
    gapHeight = innerHeights[i];
    yOffset = sum(innerHeights, i) + (i * thickness);
    translate([thickness, yOffset, 0])
      square([innerWidth, thickness]);

    // and for each drawer in that row...
    drawersForLevel = drawersPerLevel[i];
    drawerWidth = innerWidth / drawersForLevel;
    for (j=[0:drawersForLevel]) {
      // make some runners
      translate([(thickness) + (drawerWidth * j), yOffset + (thickness*0.75), 0])
        rotate(90)
          circle(d=thickness, $fn=3);
    }
  }
}

module drawer(drawerWidth, drawerHeight)
{
  translate([-innerDepth/2, -drawerWidth/2, 0])
  {
    drawer_base(drawerWidth);

    // two sides
    drawer_side(drawerHeight);
    translate([0, drawerWidth - thickness, 0]) {
      drawer_side(drawerHeight);
    }

    // back
    drawer_back(drawerWidth, drawerHeight);

    // front
    drawer_front(drawerWidth, drawerHeight);
  }
}

module drawer_base(drawerWidth)
{
  difference()
  {
    linear_extrude(thickness)
      drawer_base_shape(drawerWidth);
    runner_cutout();
      translate([0, drawerWidth, 0])
      runner_cutout();
  }
}

module drawer_base_shape(drawerWidth)
{
  square([innerDepth, drawerWidth]);
}

module runner_cutout()
{
  rotate([0,90,0])
  linear_extrude(innerDepth)
    rotate(180)
      circle(d=thickness, $fn=3);
}

module drawer_side(drawerHeight)
{
  translate([0, 0, thickness])
    linear_extrude(drawerHeight - thickness)
      square([innerDepth, thickness]);
}

module drawer_back(drawerWidth, drawerHeight)
{
  translate([0, 0, thickness])
    linear_extrude(drawerHeight - thickness)
      square([thickness, drawerWidth]);
}

module drawer_front(drawerWidth, drawerHeight)
{
  translate([innerDepth, 0, thickness])
  rotate([0, -90, 0])
    difference()
      linear_extrude(thickness)
        difference()
        {
          square([drawerHeight - thickness, drawerWidth]);
          translate([(drawerHeight/2)-thickness, drawerWidth/2])
            circle(d=fingerHoleDiameter);
        }
}
