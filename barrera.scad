////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// barrera optica y su soporte para el endstop "traspasable" de Z
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luis gutierrez (sacamantecas)
//
//

fabricar = 0 ;

 afeita(.25 * fabricar) soporte_barrera();

 translate(fabricar?[0,sb_profundo_varilla +10,0]:[0, 0, 0])
	rotate(fabricar?[-90,0,-90]:[0,0,0])
		barrera();


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

use <basico.scad>
use <tangente.scad>

$fs = 1 ;
$fa = 1 ;


sobresale_churrito = .2 ;
tuerca_M3_d_h = 6.25 + .5 ;
agj_M3_h = 3 + .8 ; 

2_manifold = .001 ;
ucm = .1 ;


// datos de la barrera optica
bo_x = 42.3 ;
bo_grosor = 1 ;
bo_alzado = 8 ;
bo_longitud = 40 ;
bo_T_base = 6 ;
bo_T_grosor = 1 ;

// soporte de la barrera
sb_ancho = 60 ; // tomado del diseño original de mAka en blender coordenadas respecto a la esquina izquierda al fondo
sb_varilla_r = 10 ;
sb_varilla_dx = 11 ;
sb_varilla_dy = -39 + .3 ; // -39 según el diseño, pero la realidad es -38.7
sb_tornillo_r = 3 + .6 ;
sb_tornillo_dx = 51.3  +  .1 ;
sb_tornillo_dy = -9.5 - .5 ; // -9.5 en diseño, -10 en la realidad
sb_profundo_normal = -sb_tornillo_dy + 3 ;
sb_profundo_varilla = 37 ;
sb_profundo_agarre = bo_alzado + 1 + 2 * sobresale_churrito ;
sb_alto_normal = 4 ;
sb_alto_agarre = 15 ;




module barrera(plus=0) {	
	linear_extrude(bo_longitud)
		barrera_2D(plus);
}
module barrera_2D(plus = 0) {
	translate([bo_x, 0])
		polygon([
			[-bo_T_base/2-plus, 0+plus],
			[-bo_T_base/2-plus, -bo_T_grosor-plus],
			[-bo_grosor/2-plus, -bo_T_grosor-plus],
			[-bo_grosor/2-plus, -bo_alzado - plus],
			[+bo_grosor/2+plus, -bo_alzado - plus],
			[+bo_grosor/2+plus, -bo_T_grosor-plus],
			[+bo_T_base/2+plus, -bo_T_grosor-plus],
			[+bo_T_base/2+plus, 0+plus]
		] );
}


module soporte_barrera() {
	rect = [sb_ancho, sb_profundo_varilla];
	suaviza_izda_dx = sb_varilla_dx - sb_varilla_r/2 - 1;
	
	linear_extrude(sb_alto_normal)
		difference() {
			translate([0,-rect[1]])
				square(rect);
			translate([sb_varilla_dx * 2, -rect[1]-sb_profundo_normal])
				square(rect);		

			translate([suaviza_izda_dx - rect[0], -sb_profundo_normal-rect[1]]) 
				difference() {
					square(rect);
					translate(rect)
						resize(2 * [suaviza_izda_dx, sb_profundo_varilla-sb_profundo_normal])
							circle(r=suaviza_izda_dx);
				}
			translate([sb_varilla_dx, sb_varilla_dy])
				circle(d=sb_varilla_r + sobresale_churrito * 2);
			translate([sb_varilla_dx * 2, -sb_profundo_normal -  (sb_profundo_varilla-sb_profundo_normal)])
				resize(2 * [suaviza_izda_dx, sb_profundo_varilla-sb_profundo_normal])
					circle(r=suaviza_izda_dx);
			translate([sb_tornillo_dx, sb_tornillo_dy])
				circle(d=sb_tornillo_r);
			barrera_2D(2*sobresale_churrito);				
		}
	difference() {
		for (lado=[0,1])
			translate([bo_x,0,sb_alto_normal-2_manifold])
				mirror([lado,0,0])
					rotate([90,0,0])
						ladera([sb_ancho - bo_x, sb_alto_agarre, sb_profundo_agarre]);
		barrera(2*sobresale_churrito);				
		translate([sb_tornillo_dx, sb_tornillo_dy, sb_alto_normal-ucm])
			cylinder(d=tuerca_M3_d_h, h=sb_alto_agarre, $fn=6);
	}
				

}
