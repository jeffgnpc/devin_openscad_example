$fn=40;

hullDiameter = 80;
wallThickness = 10;
innerDiameter = hullDiameter - (wallThickness*2);
innerRadius = innerDiameter/2;
spineThickness = 3;

press();

module press(){
	difference(){
		outerShell();
		translate([0,0,-wallThickness]){
			innerShell();
		}
		translate([0,0,-0.001]){
			spine();
		}
	}
}

module spine(){
	difference(){
		rotate([90,0,0]){
			cylinder(spineThickness,innerRadius,innerRadius,true);
		}
		translate([0,0,-innerRadius/2]){
			cube([innerDiameter,innerDiameter,innerRadius],true);
		}
	}
	for(i = [2:1:8]){
		translate([-innerDiameter/2 + (i*innerDiameter/8) -innerDiameter/8,0,0]){
			ridge(sin(i*18)*innerRadius);
		}
	}
}

module ridge(radius){
	difference(){
		rotate([90,0,90]){
			cylinder(spineThickness,radius,radius,true);
		}
		translate([0,0,-radius/2]){
			cube([radius*2,radius*2,radius],true);
		}	
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