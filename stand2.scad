hex_thickness = 1;

thickness = 3;
//height = 116;
angle_from_vertical = 40;
width = 80;
lip_height = 20;
lip_width = 15;

main_part_width = width - lip_width;
// cos = adj/hyp
// hyp = adj / cos
//tn = opp/adj
//adj = opp/tan
main_part_height = (main_part_width / tan(angle_from_vertical));
height = lip_height + main_part_height;
slant_length = main_part_height / cos(angle_from_vertical);

translate([-height/2,-width/2,0])
    main();

module main()
{
  stands();
}

module stands()
{
  union() {
      translate([0,(width/2)+2,0])
        stand(true);
      mirror([0,1,0])
      translate([0,-(width/2)+2,0])
        stand(false);

//    translate([height - 20,width,0])
//      rotate(180)
//        stand(true);
//    translate([20,0,0])
//      stand(false);
  }
}

module stand(top_cut)
{
    linear_extrude(thickness)
        difference()
        {
            stand_piece(true, top_cut);
            intersection()
            {
                stand_piece(false, top_cut);
                hex_grid_inverted(height,width,10);
            }
        }
}

module stand_piece(outer, top_cut)
{
    main_square_translation = outer ? [0,0] : [thickness,thickness];
    main_square_size = outer ? [height,width] : [height-(2*thickness),width-(2*thickness)];
    cutout_translation = outer ? [0,0] : [thickness,-thickness];

    difference()
    {
        translate(main_square_translation)
            square(size=main_square_size);
        slit(outer, top_cut);
        rotate(angle_from_vertical)
            translate(cutout_translation)
                square(size=[slant_length,slant_length]);
    }
}

module slit(outer, top_cut)
{
    slit_x = width * 0.10;
    // tan = opp / adj
    // adj = opp / tan
    half_height = 0.5 * (height - (slit_x / tan(angle_from_vertical)));

    if (top_cut)
    {
        translation = outer ? [height - half_height + thickness, slit_x + thickness] : [height - half_height + thickness + thickness, slit_x];
        bounds = outer ? [thickness, half_height + thickness] : [3*thickness, half_height + thickness];
        translate(translation)
            rotate(90)
                square(size=bounds);
    }
    else
    {
        translation = outer ? [height, slit_x + thickness] : [height, slit_x];
        bounds = outer ? [thickness, half_height - thickness] : [3*thickness, half_height];
        translate(translation)
            rotate(90)
                square(size=bounds);
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
  // 2.5: 1mm
  // 2.7: 0.5mm
    circle(r=2.7,$fn=6);
//    circle(r=hex_radius-hex_radius,$fn=6);
}
