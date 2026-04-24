$fn = 100;

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

motor_cable_length = 47; // Is an under count for margin

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
	
	translate([0, 3, arm_thickness/2])
	round_rect(pi_center_x_distance+(wall_thickness*2), pi_center_y_distance+(wall_thickness*2), arm_thickness, mount_hole_r, center = true);
	
	translate([0, -13.5, arm_thickness/2])
	round_rect(battery_holder_width, battery_holder_len, arm_thickness, mount_hole_r, center = true);
}

difference(){
	base();
	
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
	
	translate([0, -40, 0])
	round_rect(12, 15, 100, mount_hole_r, center = true);
	
	translate([0, 0, 0])
	round_rect(12, 35, 100, mount_hole_r, center = true);
	
	translate([15, 0, 0])
	round_rect(10, 12, 100, mount_hole_r, center = true);
	
	translate([-15, 0, 0])
	round_rect(10, 12, 100, mount_hole_r, center = true);
}