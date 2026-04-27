$fn = 50;

wall = 1.5;

mount_hole_diameter = 7;
holder_diameter = 13;
laptop_thickness = 6.2;
clip_height = 17; // this is just a bit smaller than the top bezel

laptop_back_bezel_angle = 50; // I just measured roughly 50 degrees from a picture

rotate([90, 0, 0])
union() {
    difference() {
        union(){
            cylinder(h = wall, d = holder_diameter);
            
            translate([0, -holder_diameter/2, 0])
            cube([holder_diameter/2, holder_diameter, wall]);

            translate([holder_diameter/2, -holder_diameter/2, 0])
            cube([laptop_thickness + (wall*2), holder_diameter, wall + clip_height]);
            
        };
        cylinder(h = 100, d =  mount_hole_diameter, center = true);
        
        translate([(holder_diameter/2) + wall, -50, wall])
        cube([laptop_thickness, 100, 100]);
    };

    translate([(holder_diameter/2) + wall, holder_diameter/2, wall])
    rotate([90, 0, 0])
    linear_extrude(holder_diameter)
    polygon([[0, 0], [laptop_thickness, 0], [0, tan(90 - laptop_back_bezel_angle) * laptop_thickness]]);   
}