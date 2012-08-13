module wedge(dx, dy, dz) {
	polyhedron(
		points = [[0,0,0],[dx,0,0],[dx,dy,0],[0,dy,0],[0,0,dz],[dx,0,dz]],
		triangles = [
			[0,1,3],[1,2,3], // bottom
			[4,1,0],[1,4,5], // vertical
			[5,3,2],[5,4,3], // slope
			[1,5,2], // right side
			[0,3,4]  // left side
		]
	);
}

module hole(r, h, rota, rotv, position) {
	translate(position) {
		rotate(a = rota, v = rotv) {
			cylinder(h = h, r = r, center = true);
		}
	}
}

thickness = 2;
rackPlateWidth = 20;
rackPlateLength = 21;
rackPlate2HolePos = 6;
rackScrewHoleRadius = 2;
rackScrewWellDepth = 2;
wedgeDepth = 20;
overhangHeight = 8;
overhangDepth = 8;
rackBarRadius = 4;
lightPlateWidth = 20;
lightPlateLength = 50;
lightScrewHoleRadius = 2.5;
lightScrewWellDepth = 0;

module rackPlate() {
	difference() {
		union() {
			translate([-rackPlateWidth/2, 0, 0]) {
				cube([rackPlateWidth, rackPlateLength, thickness]);
			}
			translate([0, rackPlateLength, 0]) {
				cylinder(h=thickness, r=rackPlateWidth/2);
			}
			if (rackScrewWellDepth > 0) {
				translate([0, rackPlateLength, 0]) {
					cylinder(h=thickness+rackScrewWellDepth, r=rackScrewHoleRadius+thickness);
				}
				translate([0, rackPlate2HolePos, 0]) {
					cylinder(h=thickness+rackScrewWellDepth, r=rackScrewHoleRadius+thickness);
				}
			}
		}
		hole(rackScrewHoleRadius, thickness * 2 + rackScrewWellDepth, 0, [1,0,0], [0, rackPlateLength, (thickness+rackScrewWellDepth)/2]);
		hole(rackScrewHoleRadius, thickness * 2 + rackScrewWellDepth, 0, [1,0,0], [0, rackPlate2HolePos, (thickness+rackScrewWellDepth)/2]);
	}
}

module connector() {
	difference() {
		union() {
			translate([(rackPlateWidth / 2) - thickness, -overhangDepth, 0]) {
				wedge(thickness, wedgeDepth, overhangHeight + lightPlateWidth);
			}
			translate([-rackPlateWidth / 2, -overhangDepth, 0]) {
				wedge(thickness, wedgeDepth, overhangHeight + lightPlateWidth);
			}
			/*translate([0, 2*thickness, overhangHeight/2]) {
				rotate(a=90, v=[0,1,0]) {
					cylinder(r=thickness*2, h=rackPlateWidth, center=true);
				}
			}*/
		}
		translate([-(rackPlateWidth+2)/2,-(overhangDepth+1),-1]) {
			cube([rackPlateWidth+2, overhangDepth+1, overhangHeight-rackBarRadius+1]);
		}
		translate([-(rackPlateWidth+2)/2,-(overhangDepth+1),overhangHeight-(rackBarRadius+1)]) {
			cube([rackPlateWidth+2, overhangDepth-rackBarRadius+1,rackBarRadius+1]);
		}
		translate([0, -rackBarRadius, overhangHeight-rackBarRadius]) {
			rotate(a=90, v=[0,1,0]) {
				cylinder(r=rackBarRadius, h=rackPlateWidth+2, center=true);
			}
		}
	}
}

module lightPlate() {
	difference() {
		union() {
			translate([-lightPlateLength/2, -overhangDepth, overhangHeight]) {
				cube([lightPlateLength, thickness, lightPlateWidth]);
			}
			translate([-lightPlateLength/2, -overhangDepth, overhangHeight+lightPlateWidth/2]) {
				rotate(a=-90, v=[1,0,0]) {
					cylinder(r=lightPlateWidth/2, h=thickness);
				}
			}
			translate([lightPlateLength/2, -overhangDepth, overhangHeight+lightPlateWidth/2]) {
				rotate(a=-90, v=[1,0,0]) {
					cylinder(r=lightPlateWidth/2, h=thickness);
				}
			}
			if (lightScrewWellDepth > 0) {
				translate([-lightPlateLength/2, -overhangDepth, overhangHeight+lightPlateWidth/2]) {
					rotate(a=-90, v=[1,0,0]) {
						cylinder(h=thickness+lightScrewWellDepth, r=lightScrewHoleRadius+thickness);
					}
				}
				translate([lightPlateLength/2, -overhangDepth, overhangHeight+lightPlateWidth/2]) {
					rotate(a=-90, v=[1,0,0]) {
						cylinder(h=thickness+lightScrewWellDepth, r=lightScrewHoleRadius+thickness);
					}
				}
			}
		}
		hole(lightScrewHoleRadius, thickness * 2 + lightScrewWellDepth, 90, [1,0,0], [-lightPlateLength/2, -overhangDepth + (thickness+lightScrewWellDepth)/2, overhangHeight+lightPlateWidth/2]);
		hole(lightScrewHoleRadius, thickness * 2 + lightScrewWellDepth, 90, [1,0,0], [ lightPlateLength/2, -overhangDepth + (thickness+lightScrewWellDepth)/2, overhangHeight+lightPlateWidth/2]);
	}
}

union() {
	rackPlate();
	connector();
	lightPlate();
}
