$fn=80;

hullDiameter = 80;
wallThickness = 10;
innerDiameter = hullDiameter - (wallThickness*2);
innerRadius = innerDiameter/2;

leafLength = 55;
leafWidth = 32;
leafBorderWidth = 2;

midribWidth = 3;
veinWidth = 2;
numVeinPairs = 16;
veinAngle = 50;

function leafHalfWidth(t) = (leafWidth / 2) * sin(pow(t, 0.7) * 180);

press();

module press(){
	difference(){
		outerShell();
		translate([0,0,-wallThickness]){
			innerShell();
		}
		translate([0,0,-0.01]){
			leafCutout();
		}
	}
}

module leafCutout(){
	difference(){
		linear_extrude(height=hullDiameter)
			leafOutline();
		linear_extrude(height=hullDiameter)
			leafBorder();
		allVeins();
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
	linear_extrude(height=hullDiameter)
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
					linear_extrude(height=hullDiameter)
						translate([0, -veinWidth/2])
							square([veinLen, veinWidth]);
			// Left vein
			translate([0, yPos, 0])
				rotate([0, 0, 90 + veinAngle])
					linear_extrude(height=hullDiameter)
						translate([0, -veinWidth/2])
							square([veinLen, veinWidth]);
		}
}

module innerShell(){
	scale([0.8,0.8,0.8]){
		outerShell();
	}
}

module outerShell(){
	difference(){
		sphere(hullDiameter/2);
		translate([0,0,-hullDiameter/4]){
			cube([hullDiameter,hullDiameter,hullDiameter/2],true);
		}
	}
}
