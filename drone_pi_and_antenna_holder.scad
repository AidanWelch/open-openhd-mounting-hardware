$fn = 300;
screw_size = 2.5;
screw_hole_size = 3.2;
wall = 2;
post_height = 3;

screw_outer_x_distance = 40;
screw_center_x_distance = screw_outer_x_distance - screw_size;
screw_outer_y_distance = 56;
screw_center_y_distance = screw_outer_y_distance - screw_size;

plate_width = screw_center_x_distance+screw_hole_size+wall;
plate_length = screw_center_y_distance+screw_hole_size+wall;

module main_screw_holes(){
	translate([(screw_hole_size + wall)/2,(screw_hole_size + wall)/2,0])
	union() {
		translate([0,0,0])
		cylinder(h = 100, d = screw_hole_size, center = true);
		
		translate([screw_center_x_distance,0,0])
		cylinder(h = 100, d = screw_hole_size, center = true);
		
		translate([0,screw_center_y_distance,0])
		cylinder(h = 100, d = screw_hole_size, center = true);

		translate([screw_center_x_distance,screw_center_y_distance,0])
		cylinder(h = 100, d = screw_hole_size, center = true);
	};
}

module base_plate( h = wall ) {
	translate([plate_width/2, plate_length/2, (h/2)])
	cube([plate_width, plate_length, h], center=true);
}

vent_hole_width = 11;
vent_hole_length = 18;

module vent_hole(side = 1) {
	translate([(plate_width/2) + side * ((vent_hole_width+wall)/2), plate_length/2, 0])
	cube([vent_hole_width, vent_hole_length, 100], center = true);
}

base_plate_thickness = 1.5;

module bottom_plate(){
	difference() {
		union() {
			translate([(screw_hole_size + wall)/2,(screw_hole_size + wall)/2,post_height/2])
			union() {
				translate([0,0,0])
				cylinder(h = post_height, d = screw_hole_size + wall, center = true);
				
				translate([screw_center_x_distance,0,0])
				cylinder(h = post_height, d = screw_hole_size + wall, center = true);
				
				translate([0,screw_center_y_distance,0])
				cylinder(h = post_height, d = screw_hole_size + wall, center = true);

				translate([screw_center_x_distance,screw_center_y_distance,0])
				cylinder(h = post_height, d = screw_hole_size + wall, center = true);
			};
			
			translate([0,0,post_height])
			base_plate(h = base_plate_thickness);
		};
	
		main_screw_holes();
		vent_hole(side = 1);
		vent_hole(side = -1);
        
		pi_screw_holes(h = 100, d = screw_hole_size + wall);
        
        translate([0, -pi_center_y_distance/2, 0])
        translate([plate_width/2, plate_length/2, 0])
        cube([pi_center_x_distance, screw_hole_size + wall, 100], center = true);
        
        translate([0, pi_center_y_distance/2, 0])
        translate([plate_width/2, plate_length/2, 0])
        cube([pi_center_x_distance, screw_hole_size + wall, 100], center = true);
    };
}

translate([-3,0, post_height + base_plate_thickness])
rotate([0, 180, 0])
bottom_plate();

blm8812eu2_height = 3.4 + 0.2; // 0.2 margin
blm8812eu2_side = 32 + 0.5; // 0.5 margin
blm8812eu2_antenna_channel_width = 8;
blm8812eu2_pin_channel_distance_from_side = 8;
blm8812eu2_pin_channel_width = blm8812eu2_side - (blm8812eu2_pin_channel_distance_from_side*2);

blm8812eu2_pin_channel_thickness = 0.4;


module blm8812eu2_channels () {
	cube([blm8812eu2_side, blm8812eu2_side, 100], center = true);
	
	translate([0, (blm8812eu2_side-blm8812eu2_antenna_channel_width)/2, 0])
	cube([plate_width+2, blm8812eu2_antenna_channel_width, 100], center = true);
	
	translate([0, -blm8812eu2_side/2, -blm8812eu2_pin_channel_thickness ])
	cube([blm8812eu2_pin_channel_width, blm8812eu2_side, 100], center = true);
}

pi_center_x_distance = 23;
pi_center_y_distance = 65-7;

module pi_screw_holes (h = 100, d = screw_hole_size) {
	translate([plate_width/2, plate_length/2, 0])
	translate([-pi_center_x_distance/2,-pi_center_y_distance/2,0])
	union() {
		translate([0,0,0])
		cylinder(h = h, d = d, center = true);
		
		translate([pi_center_x_distance,0,0])
		cylinder(h = h, d = d, center = true);
		
		translate([0,pi_center_y_distance,0])
		cylinder(h = h, d = d, center = true);

		translate([pi_center_x_distance,pi_center_y_distance,0])
		cylinder(h = h, d = d, center = true);
	};
}

module top_vents (x, y) {
    vent_width = 2;
    vent_length = 20;
    
    half_width = vent_width/2;
    
    y_lower = y - 5;
    
    y_upper = y_lower + (vent_length/2) + wall;
    
    translate([x + (blm8812eu2_pin_channel_width/2) + half_width + wall, y_lower, 0])
    cube([vent_width, vent_length, 100], center = true);
    translate([x + (blm8812eu2_pin_channel_width/2) + half_width + (3*wall), y_lower, 0])
    cube([vent_width, vent_length, 100], center = true);
    
    translate([x - (blm8812eu2_pin_channel_width/2) - half_width - wall, y_lower, 0])
    cube([vent_width, vent_length, 100], center = true);
    translate([x - (blm8812eu2_pin_channel_width/2) - half_width - (3*wall), y_lower, 0])
    cube([vent_width, vent_length, 100], center = true);
    
    translate([x, y_upper, 0])
    cube([vent_length, vent_width, 100], center = true);
    translate([x, y_upper+(2*wall), 0])
    cube([vent_length, vent_width, 100], center = true);
    translate([x, y_upper+(4*wall), 0])
    cube([vent_length, vent_width, 100], center = true);
}

top_plate_thickness = 0.6;

module top_plate() {
	difference() {
		union() {
			base_plate(h = top_plate_thickness + blm8812eu2_height);
			
			translate([0,0, (top_plate_thickness + blm8812eu2_height) / 2])
			pi_screw_holes(h = top_plate_thickness + blm8812eu2_height, d = screw_hole_size + wall*2);
		};
		main_screw_holes();
		
		translate([plate_width/2, plate_length/2, 50 + top_plate_thickness])
		blm8812eu2_channels();
		
		translate([0,0, 50 + blm8812eu2_height])
		pi_screw_holes(h = 100, d = screw_hole_size + wall);
		
		pi_screw_holes();
           
        top_vents(plate_width/2, plate_length/2);
	}
}

top_plate();