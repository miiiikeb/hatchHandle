//Changelog

// 04/07/22: 0.1a: Added profileCylinder and misc constants.

// Constants
big = 200;
lil = 0.0001;
pi = 3.14159;


// Cylinder with variable radius defined by a list of (heightradius) pairs
module profileCylinder(pointList, maxRadius = 10, res = 0.25, showCS = false, showDoc = false){
	if (showDoc == true){
        echo("
        \nprofileCylinder(pointList, maxRadius = 10, res = 0.25, showCS = false, showDoc = false)\n");
    }
	difference(){
		for(i = [0:len(pointList)-2]){
			radius1 = pointList[i][1];
			height1 = pointList[i][0];
			radius2 = pointList[i+1][1];
			height2 = pointList[i+1][0];
			
			translate([0,0,height1]) cylinder(r1=radius1,r2=radius2,h=height2 - height1,$fn = 10 * maxRadius * res);
		}
		if (showCS == true){
			translate([0,-big/2,0]) cube(size = big, center = true);
		}
	}
}

//two stacked cylinders to form a screw blockout
module screw(dims, type = "nil",os = [0,0,0], rot = [0,0,0], res = 0.25,showDoc=false){
    if (showDoc == true){
        echo("
        \nscrew(dims = [shaft diameter, shaft length, head diameter, head length],type = Not Used, res = 0.25,showDoc=false)\n");
    }

    else if (showDoc == false){
        translate(os) rotate(rot) {
            cylinder(d = dims[0], h = dims[1], $fn = 10 * dims[2] * res);
            translate([0,0,dims[1]]) cylinder(d = dims[2], h = dims[3], $fn = 10 * dims[2] * res);
        }
    }
}

module nut(nut_dia, nut_height = 20,os = [0,0,0], rot = [0,0,0], showDoc = false){ // set nut_dia to actual nut dim + 0.5mm
    if (showDoc == true){
        echo("
        \nmodule nut(nut_dia, nut_height = 20,os = [0,0,0], rot = [0,0,0], showDoc = false){  set nut_dia to actual nut dim + 0.5mm\n");
    }
    translate(os) rotate(rot) {
		translate ([0,0,nut_height/2]) for(j=[0,120,240]){     //NUT
            rotate([0,0,j]) cube(size = [nut_dia,nut_dia*tan(30),nut_height],center=true);
		}
    }
}

// Build a base with bevelled edges
module base(dims,bevel=1,mink = false){
    //dims: [x,y,z]
	//bevel: bevel dimension or minkR size.
	//mink: false for bevel, true for mink
    
    dimsBev = dims - [bevel * 2,bevel * 2,bevel];
    
    minkowski(){
        translate([0,0,dimsBev[2]/2]) cube(size = dimsBev, center = true);
        if (mink == false){
            scale([0.707,0.707,0.707]) rotate([0,0,45]) hull(){
                cube(size = [bevel * 2, bevel * 2, 0.0001], center = true);
                translate([0,0,bevel]) cube(size = 0.0001, center = true);
            }
        }
        else if (mink == true){
            difference(){
                sphere(r = bevel, $fn = 60);
                translate([0,0,-500]) cube(size = 1000, center = true);
            }
        }
    }
}

module qCube(dims = [10,10,10], os = [0,0,0], rot = [0,0,0], showDoc = false){
    //build a cube centered on the Z-axis with it's base on the X/Y plane
    if (showDoc == true){
		echo("\nqCube(dims = [10,10,10], os = [0,0,0], rot = [0,0,0], showDoc = false)\n");
	}
	else if (showDoc == false){
        translate(os) rotate(rot) translate([0,0,dims[2]/2]) cube(size = dims, center = true);
	}
}

// Quick Cylinder
module qCyl(rad=1,hei=1,res=0.25,os=[0,0,0],rot=[0,0,0],showDoc = false){
    if (showDoc == true){
        echo("
        \nqCyl(rad=1,hei=1,res=0.25,os=[0,0,0],rot=[0,0,0],showDoc = false)\n");
    }
    else if (showDoc == false){
        translate(os) rotate(rot) cylinder(r = rad, h = hei, $fn = 10 * rad * res);
    }
}

// Quick Cone
module qCone(rad1=1,rad2=1,hei=1,res=0.25,os=[0,0,0],rot=[0,0,0],showDoc = false){
    if (showDoc == true){
        echo("
        \nqCone(rad1=1,rad2=1,hei=1,res=0.25,os=[0,0,0],rot=[0,0,0],showDoc = false)\n");
    }
    else if (showDoc == false){
        translate(os) rotate(rot) cylinder(r1 = rad1, r2 = rad2, h = hei, $fn = 10 * max([rad1,rad2]) * res);
    }
}

// Quick Sphere
module qSphere(rad=1,res=0.25,os=[0,0,0],showDoc = false){
    if (showDoc == true){
        echo("
        \nqSphere(rad=1,res=0.25,os=[0,0,0],showDoc = false)\n");
    }
    else if (showDoc == false){
        translate(os) sphere(r = rad, $fn = 10 * rad * res);
    }
}

module minkShape(bevel=1,type=0,res=0.25,showDoc = false){
	
	if (showDoc == true){
		echo(
			"\nminkShape(bevel=1,type=0,res=0.25,showDoc = false)\n
			\n***minkShape TYPE List*** \n
            0: pyramid (scaled and with 45deg rotation)\n
            1: vertical cone\n
            2: back-to-back horizontal cones\n
            3: hemisphere\n
            4: sphere\n
			5: half cylinder\n
            6: back-to-back vertical cones.\n
			7: vertical cylinder (z = 0.0001).\n");
		
	}
    if (showDoc == false){
		if (type == 0){
			scale([0.707,0.707,0.707]) rotate([0,0,45]) hull(){
					cube(size = [bevel * 2, bevel * 2, 0.0001], center = true);
					translate([0,0,bevel]) cube(size = 0.0001, center = true);
			}
		}
		   
		else if (type == 1){
			cylinder(r1 = bevel, r2 = 0.0001, h = bevel,$fn = res * 32);
		}
		else if (type == 2){
			difference(){
				rotate([90,0,0]) union(){
					cylinder(r1 = bevel, r2 = 0.0001, h = bevel, $fn = res * 32);
					mirror ([0,0,1]) cylinder(r1 = bevel, r2 = 0.0001, h = bevel,$fn = res * 32);
				}
				translate([0,0,-10000/2]) cube(size = 10000, center = true);
			}
		}
		else if (type == 3){
			difference(){
					sphere(r = bevel, $fn = res * 32);
					translate([0,0,-500]) cube(size = 1000, center = true);
			}
		}
		else if (type == 4){
			sphere(r = bevel, $fn = res * 32);
		}
		else if (type == 5){
			difference(){
			    rotate([0,90,0]) cylinder(r = bevel, $fn = bevel * 64 * res);
				translate([0,0,-500]) cube(size = 1000, center = true);
		    }
		}
		else if (type == 6){
			cylinder(r1 = bevel, r2 = 0.0001, h = bevel, $fn = res * 32);
			rotate([180,0,0]) cylinder(r1 = bevel, r2 = 0.0001, h = bevel, $fn = res * 32);
		}
        else if (type == 7){
			cylinder(r1 = bevel, r2 = bevel, h = 0.0001, $fn = res * 32);
			rotate([180,0,0]) cylinder(r1 = bevel, r2 = 0.0001, h = bevel, $fn = res * 32);
		}
        else if (type == 8){
			cylinder(r1 = bevel, r2 = bevel, h = 0.0001, $fn = res * 32);
            
		}
    }
	

}
/*
module base(count){
    
    module basePos(count=1,skin = 0){
        hull(){
            for (i = [0,count-1]){
                qCyl(rad = pipeDia/2 + skin, hei = baseZ, os = [i * headOS,0,0],res = res);
                qSphere(rad = pipeDia/2 + skin,os = [i * headOS,0,0], res = res);
            }
        }
    }
    module baseNeg(count=1){
        for (i = [0:count-1]){
            qCyl(rad = pipeDia/2, hei = baseZ, os = [i * headOS,0,0],res = res);
        }
        hull(){
            for (i = [0,count-1]){
                translate([i * headOS,0,0]) rotate([45,0,0]) cube(size = pipeDia/2, center = true);
            }
        }
    }
    rotate([180,0,0]) difference(){
        basePos(count = count, skin = baseSkin);
        baseNeg(count = count);
    }
    
}
*/
module minkCube(dims=[10,10,10],bevel=1,type=0,res=0.25){
    // 'type' list
    // 0: pyramid (scaled and with 45deg rotation)
    // 1: vertical cone
    // 2: 2 x horizontal cone
    // 3: hemisphere
    // 4: sphere
	function dimShrink(dims,shrink = 1) = dims - [2*shrink,2*shrink,shrink];
	minkowski(){
		qCube(dimShrink(dims,bevel));
		minkShape(bevel,type,res);
	}

}

module roundedBox(dims=[10,10,10],rad = 1, res = 0.25, os = [0,0,0],showDoc = false){
    //Added 11th June, 2020
    if (showDoc == true){
        echo("
        \nmodule roundedBox(dims=[10,10,10],rad = 1, res = 0.25, os = [0,0,0])\n");
    }
    
    xDim = dims[0]/2 - rad;
    yDim = dims[1]/2 - rad;
    zDim = dims[2];
    
    translate(os){
        for(x = [-xDim,xDim]){
            for(y = [-yDim,yDim]){
                translate([x,y,0]) cylinder(r = rad, h = zDim, $fn = 16 * rad * res);
            }
        }
        translate([0,0,zDim/2]) cube(size = [2 * xDim,2 * yDim + 2 * rad,zDim], center = true);
        translate([0,0,zDim/2]) cube(size = [2 * xDim + 2 * rad, 2 * yDim,zDim], center = true);
    }
}

module hex(r1 = 10, r2 = 10, h = 10){
    
    
    x00 = [r1 * sin(30),r1 * cos(30),0];
    x01 = [r1 * sin(90),r1 * cos(90),0];
    x02 = [r1 * sin(150),r1 * cos(150),0];
    x03 = [r1 * sin(210),r1 * cos(210),0];
    x04 = [r1 * sin(270),r1 * cos(270),0];
    x05 = [r1 * sin(330),r1 * cos(330),0];
        
    
    x10 = [r2 * sin(30),r2 * cos(30),h];
    x11 = [r2 * sin(90),r2 * cos(90),h];
    x12 = [r2 * sin(150),r2 * cos(150),h];
    x13 = [r2 * sin(210),r2 * cos(210),h];
    x14 = [r2 * sin(270),r2 * cos(270),h];
    x15 = [r2 * sin(330),r2 * cos(330),h];


    polyhedron( points = [x00,x01,x02,x03,x04,x05,x10,x11,x12,x13,x14,x15 ], faces = [ [5,4,3,2,1,0],[0,1,7,6],[1,2,8,7],[2,3,9,8],[3,4,10,9],[4,5,11,10],[5,0,6,11],[6,7,8,9,10,11]], convexity = 2);
    
}