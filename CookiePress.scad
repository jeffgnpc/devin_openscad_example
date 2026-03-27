$fn=80;

hullDiameter = 80;
wallThickness = 10;
imprintDepth = 5;

leafLength = 55;
leafWidth = 32;
leafBorderWidth = 2;

midribWidth = 3;
midribArc = 6;
veinWidth = 2;
veinAngle = 50;

// Vein count: gap between veins equals vein width
numVeinPairs = round(leafLength * 0.88 * sin(veinAngle) / (2 * veinWidth) + 1);

// Scale factors for dome shells
innerScale = 0.8;
carvingScale = innerScale + imprintDepth / (hullDiameter / 2);

function leafHalfWidth(t) = (leafWidth / 2) * sin(pow(t, 0.7) * 180);
function midribOffset(t) = midribArc * sin(t * 180);

press();

module press(){
	difference(){
		outerShell();
		translate([0,0,-wallThickness+0.1]){
			innerShell();
		}
		leafCarving();
	}
}

module leafCarving(){
	intersection(){
		// 5mm shell layer just beyond the inner surface
		translate([0,0,-wallThickness]){
			carvingShell();
		}
		// Leaf shape minus veins and border
		difference(){
			linear_extrude(height=hullDiameter)
				leafOutline();
			linear_extrude(height=hullDiameter)
				leafBorder();
			allVeins();
		}
	}
}

module carvingShell(){
	difference(){
		scale([carvingScale, carvingScale, carvingScale])
			outerShell();
		scale([innerScale, innerScale, innerScale])
			outerShell();
	}
}

module leafOutline(){
	n = 100;
	points = concat(
		[for (i = [0:n]) let(t = i/n, xOff = midribOffset(t))
			[xOff + leafHalfWidth(t), -leafLength/2 + t * leafLength]],
		[for (i = [n:-1:0]) let(t = i/n, xOff = midribOffset(t))
			[xOff - leafHalfWidth(t), -leafLength/2 + t * leafLength]]
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
	// Curved central midrib
	linear_extrude(height=hullDiameter)
		curvedMidrib();

	// Side veins originating from curved midrib
	for (i = [1:numVeinPairs])
		let(
			t = 0.06 + (i - 1) * (0.88 / max(numVeinPairs - 1, 1)),
			yPos = -leafLength/2 + t * leafLength,
			xOff = midribOffset(t),
			halfW = leafHalfWidth(t),
			veinLen = halfW / sin(veinAngle) + 2
		)
		if (halfW > 1) {
			// Right vein
			translate([xOff, yPos, 0])
				rotate([0, 0, 90 - veinAngle])
					linear_extrude(height=hullDiameter)
						translate([0, -veinWidth/2])
							square([veinLen, veinWidth]);
			// Left vein
			translate([xOff, yPos, 0])
				rotate([0, 0, 90 + veinAngle])
					linear_extrude(height=hullDiameter)
						translate([0, -veinWidth/2])
							square([veinLen, veinWidth]);
		}
}

module curvedMidrib(){
	n = 100;
	points = concat(
		[for (i = [0:n]) let(t = i/n)
			[midribOffset(t) + midribWidth/2, -leafLength/2 + t * leafLength]],
		[for (i = [n:-1:0]) let(t = i/n)
			[midribOffset(t) - midribWidth/2, -leafLength/2 + t * leafLength]]
	);
	polygon(points);
}

module innerShell(){
	scale([innerScale, innerScale, innerScale]){
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
