include<mbLib-0.1a.scad>;
include<hatchHandleVars.cfg>;
include<screwDims0.1.cfg>;



module thingPos(){
	qCyl(rad=pivotCylR,hei=pivotCylH,res=res,os=[0,0,0],rot=[0,0,0]);
	difference(){
		union(){
			qCyl(rad=pivotTopFlangeR,hei=pivotTopFlangeH,res=res,os=pivotTopFlangeOS,rot=[0,0,0]);
			qCone(rad1=pivotCylR,rad2=pivotTopFlangeR,hei=pivotTopFlangeTransitionH,res=res,os=pivotTopFlangeTransitionOS,rot=[0,0,0]);
		}
		for (a = [pivotTopFlangeTweakA,-pivotTopFlangeTweakA]){
			rotate([0,0,45]) qCube(dims=[big,big,big], os = [big/2 + pivotTopFlangeTweakX,0,0], rot = [0,0,a]);
		}
	}
}

module thingNeg(){
		qCyl(rad=pivotCoreR,hei=pivotCoreH,res=res,os=[0,0,-lil],rot=[0,0,0]);
		qCyl(rad=pivotTopCoreR,hei=pivotTopCoreH,res=res,os=[0,0,pivotTopCoreZOS],rot=[0,0,0]);
		intersection(){
			qCube(dims=pivotCubeDims, os = pivotCubeOS, rot = pivotCubeRot);
			qCyl(rad=pivotTopCoreR,hei=big,res=res,os=[0,0,0],rot=[0,0,0]);
		}

}

module thingMake(){
	difference(){
		thingPos();
		thingNeg();
	}
}

module spiralPos(){
	translate(spiralBaseCylOS) qCyl(rad=spiralBaseCylR,hei=spiralBaseCylH,res=res,os=[0,0,0],rot=[0,0,0]);
	translate(spiralOS) linear_extrude(height = 14, center = false, convexity = 10, twist = 35, slices = 70 * res, scale = 1.0, $fn = 16) {
		difference(){
			circle(r = spiralR, $fn = 10 * spiralR * res);
			translate([0,-big/2]) square(size = [big,big],center = true);
			translate([big/2,0]) square(size = [big,big],center = true);
		}
	}

}

module spiralNeg(){
	qCyl(rad=spiralNegR,hei=spiralNegH,res=res,os=[0,0,0],rot=[0,0,0]);
	qCube(dims=[big,big,big], os = [big/2,0,-lil], rot = [0,0,0]);
	translate([22,-12,-lil]) rotate([0,0,55]) cube(size=[big,big,big],center = false);
	qCube(dims=[big,big,big], os = [0,0,11.2], rot = [0,0,0]);
	qCube(dims=[big,big,big], os = [0,spiralOS[1] - big/2,-lil], rot = [0,0,0]);
	qCyl(rad=pivotCoreR,hei=pivotCoreH,res=res,os=[0,0,-lil],rot=[0,0,0]);

}

module leadingEdge(){
	difference(){
		qCyl(rad=leadEdgeR,hei=leadEdgeH,res=res,os=leadEdgeOS,rot=leadEdgeRot);
		qCube(dims=[big,big,big], os = [0,0,-big], rot = [0,0,0]);
		qCube(dims=[big,big,big], os = [big/2,0,-big/2], rot = [0,0,0]);
		

		}
}	
	
module spiralMake(){
	difference(){
		spiralPos();
		spiralNeg();
	}
} 

module handle(){
	hull(){
		qCube(dims=handle1Dims, os = handle1OS, rot = [0,0,0]);
		qCube(dims=handle2Dims, os = handle2OS, rot = [0,0,0]);
	}
	hull(){
		qCube(dims=handle2Dims, os = handle2OS, rot = [0,0,0]);
		qCube(dims=handle3Dims, os = handle3OS, rot = [0,0,0]);
	}
}
	
module makeEverything(){		

	thingMake();
	spiralMake();

	leadingEdge();
	difference(){
		minkowski(){
			rotate([0,0,45]) intersection(){
				handle();
				hull(){
					qCube(dims=handleHull1Dims, os = handle1Hull1OS, rot = [0,0,0]);
					qCube(dims=handleHull2Dims, os = handleHull2OS, rot = [0,0,0]);
				}
			}
			minkShape(bevel=handleMinkR,type=6,res=0.25);
		}
		thingNeg();
	}
}

mirror([1,0,0]) makeEverything();
//makeEverything();