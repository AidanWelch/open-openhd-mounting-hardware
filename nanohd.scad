$fn = 50;

prop_length = 76.2;
arm_thickness = 4;
base_thickness = 2;
wall_thickness = 3;

fc_mount_dist = 35;
fc_angle = 45;

mount_hole_d = 2.75;
mount_hole_r = mount_hole_d / 2;

mount_hole_divet_d = 5;
mount_hole_divet_r = mount_hole_divet_d/2;

pi_center_x_distance = 23;
pi_center_y_distance = 65-7;

battery_holder_len = 77;
battery_holder_width = 21;

motor_cable_length = 52;

module cylinder_rect(l, w, h, r, center = false) {
	hl = l/2;
	hw = w/2;
	movement = center ? [0, 0, 0] : [hl, hw, h/2];
	
	translate(movement)
	union(){
		translate([hl, hw, 0])
		cylinder(h, r = r, center = true);
		translate([hl, -hw, 0])
		cylinder(h, r = r, center = true);
		translate([-hl, hw, 0])
		cylinder(h, r = r, center = true);
		translate([-hl, -hw, 0])
		cylinder(h, r = r, center = true);
	}
}

module round_rect(l, w, h, r, center = false) {
	d = r*2;
	movement = center ? [0, 0, 0] : [hl/2, hw/2, h/2];
	
	translate(movement)
	union(){
		cube([l-d, w, h], center = true);
		cube([l, w-d, h], center = true);
		cylinder_rect(l-d, w-d, h, r, center = true);
	}
}

module base() {
	translate([0, 0, base_thickness/2])
	rotate([0, 0, fc_angle])
	round_rect(fc_mount_dist+(wall_thickness*2), fc_mount_dist+(wall_thickness*2), base_thickness, mount_hole_r, center = true);

	translate([0, 3+(wall_thickness/2), base_thickness/2])
	round_rect(pi_center_x_distance+(wall_thickness*2), pi_center_y_distance+(wall_thickness*3), base_thickness, mount_hole_r, center = true);
	
	translate([0, -10, arm_thickness/2])
	round_rect(battery_holder_width, battery_holder_len, arm_thickness, mount_hole_r, center = true);
}

module camera_mount() {
	mounting_external_distance_x = 23;
	mounting_external_distance_z = 14.65;
	mounting_hole_diameter = 2;
	
	mh_c_x = (mounting_external_distance_x/2) - (mounting_hole_diameter/2);
	mh_c_z = (mounting_external_distance_z/2) - (mounting_hole_diameter/2);
	
	camera_module_height = 24;
	translate([0, 0, mh_c_z+wall_thickness+0.2])
	rotate([90, 0, 0])
	difference() {
		translate([0, -wall_thickness/2, 0])
		round_rect(mh_c_x+(wall_thickness*2), mh_c_z+(wall_thickness*3), wall_thickness, mount_hole_r, center = true);
		cylinder_rect(mh_c_x, mh_c_z, 100, mount_hole_r, center = true);
	}
}

module motor_mount(x, y) {
	motor_screw_d = 2.4;
	motor_screw_r = motor_screw_d / 2;

	motor_center_hole_d = 4.5;
	
	motor_screw_center_distance = 9;
	
	fc_connect_right = [fc_mount_dist/2, 0, -1];
	fc_connect_left = [-fc_mount_dist/2, 0, -1];
	
	closer_connect = (x > 0) ? fc_connect_right : fc_connect_left;
	motor_connect = [x, y, arm_thickness];
	wire_color = (norm(motor_connect-closer_connect) < motor_cable_length) ? [0, 0.8, 0, 0.4] : [0.9, 0, 0, 0.9];
	
	% translate([x, y, 10])
	% cylinder(h = 3, d = prop_length, center = true);
	% color(c = wire_color)
	% hull() {
		translate(closer_connect)
		sphere(r = 1);
		
		translate(motor_connect)
		sphere(r = 1);
	};
	
	translate([x, y, arm_thickness/2])
	difference(){
		hull(){
			translate([0, motor_screw_center_distance/2, 0])
			cylinder(h = arm_thickness, d = motor_screw_d + wall_thickness, center = true);
			
			cylinder(h = arm_thickness, d = motor_center_hole_d + wall_thickness, center = true);
			
			translate([0, -motor_screw_center_distance/2, 0])
			cylinder(h = arm_thickness, d = motor_screw_d + wall_thickness, center = true);
		};
	
		translate([0, motor_screw_center_distance/2, 0])
		cylinder(h = 100, r = motor_screw_r, center = true);
		translate([0, -motor_screw_center_distance/2, 0])
		cylinder(h = 100, r = motor_screw_r, center = true);
		
		cylinder(h = 100, d = motor_center_hole_d, center = true);
	};
	
	arm_connection_d = 4;
	
	module arm_shape(){
		hull(){
			translate([x, y, arm_thickness/2])
			cylinder(h = arm_thickness, d = arm_connection_d, center = true);
			
			translate([0, 0, arm_thickness/2])
			cylinder(h = arm_thickness, d = motor_center_hole_d, center = true);
			
			translate([0, (y > 0) ? 10 : -10, arm_thickness/2])
			cylinder(h = arm_thickness, d = motor_center_hole_d, center = true);
		};
	};
	
	centroid = ([x, y] + [0, 0] + [0, (y > 0) ? 10 : -10]) / 3;
	
	difference(){
		arm_shape();
		
		translate([x, y, arm_thickness/2])
		cylinder(h = 100, d = motor_center_hole_d, center = true);
		
		translate([centroid[0], centroid[1], -50])
		scale([0.5, 0.5, 100])
		translate([-centroid[0], -centroid[1], 0])
		arm_shape();
	};
}

difference(){
	union(){
		base();
		
		translate([0, ((pi_center_y_distance+(wall_thickness*3))/2)+3, 0])
		camera_mount();
		
		motor_mount(50, 39);
		motor_mount(50, -39);
		
		motor_mount(-50, 39);
		motor_mount(-50, -39);
	};
		
	rotate([0, 0, fc_angle])
	union(){
		cylinder_rect(fc_mount_dist, fc_mount_dist, 100, mount_hole_r, center = true);
		translate([0, 0, 50 + base_thickness])
		cylinder_rect(fc_mount_dist, fc_mount_dist, 100, mount_hole_divet_r, center = true);
	};
	
	translate([0, 3, 0])
	cylinder_rect(pi_center_x_distance, pi_center_y_distance, 100, mount_hole_r, center = true);
	translate([0, 3, 50 + base_thickness])
	cylinder_rect(pi_center_x_distance, pi_center_y_distance, 100, mount_hole_divet_r, center = true);
	
	translate([0, -37, 0])
	round_rect(12, 15, 100, mount_hole_r, center = true);
	
	translate([0, 0, 0])
	round_rect(12, 38, 100, mount_hole_r, center = true);
	
	translate([15, 0, 0])
	round_rect(10, 12, 100, mount_hole_r, center = true);
	
	translate([-15, 0, 0])
	round_rect(10, 12, 100, mount_hole_r, center = true);
	
	translate([0, 32, 0])
	round_rect(10, 6, 100, mount_hole_r, center = true);
}