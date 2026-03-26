$fn=80;

pressDiameter = 80;
pressHeight = 50;
wallThickness = 3;
imprintDepth = 8;

leafLength = 62;
leafWidth = 36;
leafBorderWidth = 1.5;

midribWidth = 2.5;
veinWidth = 1.5;
numVeinPairs = 18;
veinAngle = 50;

function leafHalfWidth(t) = (leafWidth / 2) * sin(pow(t, 0.7) * 180);

press();

module press(){
	difference(){
		body();
		translate([0,0,-0.01]){
			leafCutout();
		}
	}
}

module body(){
	difference(){
		cylinder(h=pressHeight, d=pressDiameter);
		translate([0,0,wallThickness+imprintDepth]){
			cylinder(h=pressHeight, d=pressDiameter-wallThickness*2);
		}
	}
}

module leafCutout(){
	intersection(){
		cylinder(h=imprintDepth+0.02, d=pressDiameter);
		difference(){
			linear_extrude(height=imprintDepth+0.02)
				leafOutline();
			linear_extrude(height=imprintDepth+0.04)
				leafBorder();
			allVeins();
		}
	}
}

module leafOutline(){
	n = 100;
	points = concat(
		[for (i = [0:n]) let(t = i/n)
			[leafHalfWidth(t), -leafLength/2 + t * leafLength]],
		[for (i = [n:-1:0]) let(t = i/n)
			[-leafHalfWidth(t), -leafLength/2 + t * leafLength]]
	);
	polygon(points);
}

module leafBorder(){
	difference(){
		leafOutline();
		offset(r=-leafBorderWidth)
			leafOutline();
	}
}

module allVeins(){
	// Central midrib
	linear_extrude(height=imprintDepth+0.04)
		translate([-midribWidth/2, -leafLength/2])
			square([midribWidth, leafLength]);

	// Side veins
	for (i = [1:numVeinPairs])
		let(
			t = 0.06 + (i - 1) * (0.88 / (numVeinPairs - 1)),
			yPos = -leafLength/2 + t * leafLength,
			halfW = leafHalfWidth(t),
			veinLen = halfW / sin(veinAngle) + 2
		)
		if (halfW > 1) {
			// Right vein
			translate([0, yPos, 0])
				rotate([0, 0, 90 - veinAngle])
					linear_extrude(height=imprintDepth+0.04)
						translate([0, -veinWidth/2])
							square([veinLen, veinWidth]);
			// Left vein
			translate([0, yPos, 0])
				rotate([0, 0, 90 + veinAngle])
					linear_extrude(height=imprintDepth+0.04)
						translate([0, -veinWidth/2])
							square([veinLen, veinWidth]);
		}
}
