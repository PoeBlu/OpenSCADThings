thickness = 1;
hex_thickness = 1;

translate([-50,-40,0])
    main();

module main()
{
  render(convexity = 3)
  {
    stand();
  }
}

module stand()
{
    union()
    {
        hollow_rect(100,80);
        hex_grid(100,80,10);
    }
}

module hollow_rect(length,width)
{
    difference()
    {
        square(size=[length,width]);
        translate([thickness/2,thickness/2])
            square(size=[length-thickness,width-thickness]);
    }
}

module hex_grid(length,width,hex_diameter)
{
    difference()
    {
        square(size=[length,width]);
        hex_grid_inverted(length,width,hex_diameter);
    }
}

module hex_grid_inverted(length,width,hex_diameter)
{
    hex_radius = hex_diameter / 2;
    x_step = sin(60);
    y_step = cos(60);
    
    for (y_index = [0:y_step:length/hex_diameter])
        for (x_index = [0:x_step:(width/hex_diameter)+2])
        {
            x = x_index*hex_diameter;
            y = y_index*hex_diameter;
            translate([x,y,0])
                hex(hex_radius);
            translate([x+(hex_radius * sin(60)),y+(hex_radius * cos(60)),0])
                hex(hex_radius);
        }
}

module hex(hex_radius)
{
    circle(r=2.7,$fn=6);
//    circle(r=hex_radius-hex_radius,$fn=6);
}
