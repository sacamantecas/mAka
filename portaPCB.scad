////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// piezas para completar la cama de hacer PCBs
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luiso gutierrez (sacamantecas)
//
//

fabricar = 1 ;

hacer_inferior = 1 ;
hacer_superior = 1 ;
hacer_accesorios = 1 ;
$alto_de_capa = .33 ;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

mp=.1 ;
$fs = 1 ;

agarre_dx = 12 ;
agarre_dy = 13 ;
cama_dy = 214 ;
ala_dx = 10 ;
angulo_agarre = 15 ;
inferior_dz = 4 ;
superior_dz = 4 ;
holgura_agarre = .7 ;
desfase = 1.1 ;
taladros = 6 ;
taladro_d = 3 + .5 ;
tuerca_d = 6.25  +  .5 ; 
tuerca_h = 2 ;
cabeza_M3_d = 5.35 + .75 ;

acc_canal = taladro_d ;
acc_ancho = acc_canal + 2 * 4 ;
acc_brazos_a = 6 ;
acc_brazos_l = 20 ;

frontal_largo = 150 ;
cadencia_agujeros = 40 ;
primer_agujero_frontal = 15 ;


module silueta(ancho, alto, simetrico=false) {
        polygon([[0,0]
        , [ancho-holgura_agarre/2, 0]
        , [ancho-holgura_agarre/2+alto*tan(angulo_agarre), alto]
        , [(simetrico?-1:0)*alto*tan(angulo_agarre), alto]     ]);
}

if (hacer_inferior) { 
	rotate(fabricar?[0,0,45]:[180,0,0]) translate(fabricar?[-agarre_dx/2,0,0]:[0,0,0])
	
		translate([0, cama_dy/2+agarre_dy, 0]) 
			difference() {
				union() {
					// una vez hecho, descubro que la cama está mal puesta, y hay un desfase que corrijo definiendo un poliedro al tun-tun
					*rotate([90,0,0])
						linear_extrude(cama_dy+2*agarre_dy)
							silueta(ala_dx, inferior_dz);
					polyhedron( [ // 8 vértices
						[0, 0, 0], [0, 0, inferior_dz],
						[ala_dx+inferior_dz*tan(angulo_agarre)-desfase, 0, inferior_dz], [ala_dx-desfase, 0, 0],
						[0, -(cama_dy+2*agarre_dy), 0], [0, -(cama_dy+2*agarre_dy), inferior_dz],
						[ala_dx+inferior_dz*tan(angulo_agarre), -(cama_dy+2*agarre_dy), inferior_dz], [ala_dx, -(cama_dy+2*agarre_dy), 0],
					], [ // y 6 caras (12 triángulos)
						[0, 2, 1], [2, 0, 3], [4, 5, 6], [6, 7, 4], [0, 1, 4], [5, 4, 1], [7, 2, 3], [6, 2, 7], [5, 1, 6], [1, 2, 6], [0, 4, 7], [3, 0, 7]
					] );

					mirror([0,1,0])
						rotate([90,0,90])
							linear_extrude(ala_dx+agarre_dx)
								silueta(agarre_dy, inferior_dz);
					translate([0,-2*agarre_dy-cama_dy,0])
						rotate([90,0,90])
							linear_extrude(ala_dx+agarre_dx)
								silueta(agarre_dy, inferior_dz);
				}
				for (y = [0:(cama_dy+agarre_dy)/(taladros-1):cama_dy+agarre_dy+mp] )
					translate([ala_dx/2, -y-agarre_dy/2, 0]) {
						translate([0,0,-mp/2])
							cylinder(d=taladro_d, h=inferior_dz+mp);
						translate([0,0,inferior_dz - tuerca_h])
							rotate([0,0,30])
								cylinder(d=tuerca_d, h=tuerca_h+mp, $fn=6);
					}
				translate([ala_dx + 3 -desfase,-agarre_dy - 3, -mp/2.]) // a 3 un círculo de 7 para evitar la arandela
					cylinder(d=8, h=inferior_dz+mp);
			}
}

if (hacer_superior) {
	rotate(fabricar?[0,0,45]:[0,0,0]) translate(fabricar?[-15-agarre_dx/2,0,0]:[0,0,10])
	
		translate([0, cama_dy/2+agarre_dy, 0]) 
			difference() {
				rotate([90,0,0])
					linear_extrude(cama_dy+2*agarre_dy)
						silueta(ala_dx, superior_dz);
				for (y = [0:(cama_dy+agarre_dy)/(taladros-1):cama_dy+agarre_dy+mp] )
					translate([ala_dx/2, -y-agarre_dy/2, 0]) {
						translate([0,0,-mp/2])
							cylinder(d=taladro_d, h=superior_dz+mp);
						translate([0,0,superior_dz-cabeza_M3_d/2])
							cylinder(d1=0, d2=cabeza_M3_d+mp, h=(cabeza_M3_d+mp)/2);
					}
			}
}
rotate(fabricar?[0,0,-45]:[0,0,0]) translate(fabricar?[-60,30,0]:[0,0,0])
if (hacer_accesorios) {
	// recto y largo
	translate([0,-10,0])
	difference() {
		rotate([90,0,0]) linear_extrude( acc_ancho ) silueta(100, superior_dz, true);
		translate([27,-acc_ancho/2,-mp/2])			
			hull() {
				translate([-17,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
				translate([ 17,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
			}
		translate([73,-acc_ancho/2,-mp/2])			
			hull() {
				translate([-17,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
				translate([ 17,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
			}
	}
	
	// recto y corto
	translate([0,20,0])
	difference() {
		rotate([90,0,0]) linear_extrude( acc_ancho ) silueta(60, superior_dz, true);
		translate([30,-acc_ancho/2,-mp/2])			
			hull() {
				translate([-22,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
				translate([ 22,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
			}
	}

	// en T
	translate([15,40,0])
	difference() {
		rotate([90,0,0])
			union() {
				linear_extrude( acc_ancho ) silueta(60, superior_dz, true);
				translate([60-acc_brazos_a,0,-acc_brazos_l])
					linear_extrude( acc_brazos_l * 2 + acc_ancho) silueta(acc_brazos_a, superior_dz);
			}
		translate([30,-acc_ancho/2,-mp/2])			
			hull() {
				translate([-22,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
				translate([ 22,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
			}
	}

	// en C
	translate([0,75,0])
	difference() {
		rotate([90,0,0])
			union() {
				linear_extrude( acc_ancho ) silueta(60, superior_dz, true);
				translate([60-acc_brazos_a,0,acc_ancho])
					linear_extrude( acc_brazos_l ) silueta(acc_brazos_a, superior_dz);
					mirror([1,0,0])
				translate([holgura_agarre/2-acc_brazos_a,0,acc_ancho])
						linear_extrude( acc_brazos_l ) silueta(acc_brazos_a, superior_dz);
			}
		translate([30,-acc_ancho/2,-mp/2])			
			hull() {
				translate([-22,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
				translate([ 22,0,0]) cylinder(d=taladro_d, h=superior_dz+mp);
			}
	}

	// frontal
	translate([0,-5,0])
	difference() {
		rotate([90,0,90]) 
			linear_extrude(frontal_largo) silueta(ala_dx, superior_dz, true);		
			for ( i=[primer_agujero_frontal: cadencia_agujeros: frontal_largo] ) 
				translate([i,ala_dx/2,0]) {
					translate([0,0,-mp/2])				
						cylinder(d=taladro_d, h=superior_dz+mp);
					translate([0,0,superior_dz-cabeza_M3_d/2])
						cylinder(d1=0, d2=cabeza_M3_d+mp, h=(cabeza_M3_d+mp)/2);
			}
	}	
}
