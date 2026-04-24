$fn = 300;

camera_angle = 0;

post_internal_diameter = 6.5;
wall_thickness = 1;
post_height = 25;
post_external_distance = 37.5;
post_internal_distance = post_external_distance - post_internal_diameter;  
post_external_diameter = post_internal_diameter + (wall_thickness * 2);

// Both measured far interal edge of each screw
mounting_external_distance_x = 23;
mounting_external_distance_z = 14.65;
mounting_hole_diameter = 2;
camera_module_height = 24;
ribbon_plug_height = 5.5 + 1; // 1 for margin
ribbon_plug_width = 22 + 1; // 1 for margin
module mounting_holes(d = mounting_hole_diameter, teardrop = true){
	module mh(x = 0, z = 0){
		translate([x, 0, z])
		rotate([90, 0, 0])
		// 0.8 for margin
		cylinder(h = 100, d = d+0.8, center = true);
        
        rad = (d+0.8)/2;
        if (teardrop) {
            translate([x, 0, z])
            rotate([-90, 0, 0])
            linear_extrude(100, center = true)
            polygon([[-rad, 0], [rad, 0], [0, 2]]);
        }
    }
	mh_c_x = (mounting_external_distance_x/2) - (mounting_hole_diameter/2);
	mh_c_z = (mounting_external_distance_z/2) - (mounting_hole_diameter/2);
	mh(mh_c_x, mh_c_z);
	mh(-mh_c_x, mh_c_z);
	mh(mh_c_x, -mh_c_z);
	mh(-mh_c_x, -mh_c_z);
	//cube([mounting_external_distance_x, 100, mounting_external_distance_z], center = true);
}

plate_length = post_external_distance + (wall_thickness*2);
plate_thickness = post_external_diameter + 2;
plate_mh_wall_thickness = 1; // I measured 0.95 but its hard to say
mount_thickness = 7 ;
mount_cut = plate_thickness-mount_thickness;

module mount(){
	difference() {
		union(){
			cube([plate_length, plate_thickness, post_height]);
			
			translate([plate_length/2, 0, (post_height/2)])
			guard();
		}
		
		translate([0, 0, -50])
		rotate([camera_angle, 0, 0])
		cube(100, center = true);
				translate([0, 0, 50 + post_height])
		rotate([camera_angle, 0, 0])
		cube(100, center = true);
		

		
		// Posts
		translate([(post_external_diameter/2), plate_thickness/2, post_height/2])
		cylinder(h = post_height + 10, d = post_internal_diameter+0.1, center = true);
		
		translate([(plate_length-post_external_diameter/2), plate_thickness/2, post_height/2])
		cylinder(h = post_height + 10, d = post_internal_diameter+0.1, center = true);
		
		// Mounting screws
		mount_z_offset = -(wall_thickness+1); // the +1 is just for margin
		translate([plate_length/2, 0, (post_height/2 + (post_height-mounting_external_distance_z)/2) + mount_z_offset])
		mounting_holes();
        
        translate([plate_length/2, 50 + mount_thickness, (post_height/2 + (post_height-mounting_external_distance_z)/2) + mount_z_offset])
		mounting_holes(d = mounting_hole_diameter + 1);
        
		translate([plate_length/2, 50 +mount_thickness, 0])
        cube([camera_width-2.2, 100, 100], center = true);
		
		// I'm not entirely sure my math with the plate_mh_wall_thickness is correct but it errs on the side of more space so it will fit
		translate([plate_length/2, 0, -50 + (post_height-((camera_module_height-plate_mh_wall_thickness)-ribbon_plug_height)) + mount_z_offset])
		cube([ribbon_plug_width, 100, 100], center = true);
	};
}

guard_depth = 22; // camera depth with the lens protector on
camera_width = 25 + 2; // with a 2mm margin
guard_wall_thickness = 2.5;
module guard() {
	// translate such that when moved to the center of the plate is at the correct place
	translate([0, -guard_depth/2, (post_height - guard_depth)/2])
	difference(){
		union(){			
			rotate([0, 90, 0])
			cylinder(h = camera_width + (2*guard_wall_thickness), d = guard_depth, center = true);
			
			translate([0, guard_depth/4, 0])
			cube([camera_width + (2*guard_wall_thickness), guard_depth/2, guard_depth], center = true);
		};
		
		cube([camera_width, 100, 100], center = true);
	};
}


translate([0, 0, post_height])
rotate([180-camera_angle, 0, 0])
mount();



module wedge(angle) {
    wedge_height = (camera_module_height-ribbon_plug_height) + plate_mh_wall_thickness;
    
    rotate([90, 0, 0])
    difference(){
        rotate([0, 90, 0])
        translate([-wedge_height/2, 0, -camera_width/2])
        rotate_extrude(angle = angle, convexity = 10)
        square([wedge_height, camera_width]);
    
        mounting_holes(teardrop = false);
        
        translate([0, 0, -(49+(wedge_height/2))])
        cube([100, 100, 100], center = true);
    }
}

translate([-15, 20, 0])
wedge(5);

translate([-15, 0, 0])
wedge(10);

translate([-15, -20, 0])
wedge(20);