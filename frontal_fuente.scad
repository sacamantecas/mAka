//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// frontal para la fuente de alimentación innobo i650
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2018 by luis gutierrez (sacamantecas)
//
//

use <basico.scad>

$fa = 5 ;
$fs = 1 ;
// constantes de uso interno;
X = 0 ;
Y = 1 ;
Z = 2 ;
mp = .1 ;
fabricar = true ;



bloque = [150, 27, 85];
fila_z = [20, 60];
columna_x = [20, 45, 70, 95];
interruptor_x = bloque[X] - columna_x[0];
interruptor_pasante_d = 6.8 ;
interruptor_pasante_e = 6 ;
interruptor_bloque = [12.2, bloque[Y],14];


bloque_USB = [32.1, bloque[Y], 8.2 ];
USB_x = interruptor_x + interruptor_pasante_d/2 - bloque_USB[X]/2;

LED1_x = interruptor_x ;
LED2_x = USB_x - (LED1_x - USB_x);
LED1_z = (fila_z[0]+fila_z[1])/2 - 3 ;
LED2_z = LED1_z;
LED_pasante_d = 8.4 ;
LED_pasante_e = 9 ;
LED_holgante_d = 18 ;


conector_pasante = 8.2 ;
conector_holgante = correccion(14 + .3) ;
conector_pasante_e = 3.5 ;

esparrago_d = correccion( 4 + .8 ) ;
esparrago_largo = bloque[Y] - 5 ;
esparrago_margen_x = 9 ;
esparrago_margen_z = esparrago_margen_x;

salida_cables_prot_dy = 3 ;
salida_cables_prot_d = 30 ;
salida_cables_d = 22 ;
salida_cables_dy = bloque[Y] - LED_pasante_e ;
salida_cables_x = bloque[X] - 14 ;
salida_cables_z = bloque[Z] / 2 ;

rebaje_trasero = bloque[Y] - 10 ;


// apaño para quitar holgura al bloque USB y facilitar el pegado
!rotate([90,0,0])
	difference() {
		cube(bloque_USB, center=true);		
		cube(bloque_USB - [1.2,-1,1.2], center=true);
	}


// patitas
for (x = [40, 60, 80, 100])
	translate([x, -30, 0])
		 difference() {
			diametro = 15 ;
			altura = 10 ;
			corte_desde_tornillo = 5 ; 
			cylinder(d=diametro, h=altura);
			cylinder(d=3.6, h=altura); // vastago tornillo
			translate([0,0,7])
				cylinder(d=6, h=altura); // cabeza tornillo
			translate([diametro/2 + corte_desde_tornillo, 0, altura/2])	
				cube([diametro, diametro, altura], center = true);
		}


// plantilla para hacer los agujeros a la fuente
rotate([(fabricar ? 90 : 0),0,0])
	 difference() {
		cube(bloque - [0, bloque[Y] - 1, 0]);
		translate([esparrago_margen_x+5, 0, esparrago_margen_z+5])
			cube(bloque - [(esparrago_margen_x+5)*2, bloque[Y] - 1, (esparrago_margen_z+5)*2]);
		for (lado = [-1, 1])
			for (altura = [-1, 1])
				translate([bloque[X]/2 + lado * (bloque[X]/2 - esparrago_margen_x), 0, bloque[Z]/2 + altura * (bloque[Z]/2 - esparrago_margen_z)])
					rotate([-90,0,0])
						cylinder(d=2, h=10);
	}


// frontal de la fuente
!
rotate([(fabricar ? 90 : 0),0,0])
	difference() {
		cube(bloque);
		// agujeros conectores arriba
		for (i=columna_x)
			translate([i, -mp, fila_z[1]]) {
				rotate([-90, 0, 0]) 
					cylinder(d=conector_pasante, h=bloque[Y]);
				translate([0, conector_pasante_e, 0])
					rotate([-90, 0, 0]) 
						cylinder(d=conector_holgante, h=bloque[Y]);
			}
		// interruptor
		translate([interruptor_x, 0, fila_z[1]]) {
			translate([0,interruptor_pasante_e + interruptor_bloque[Y]/2 ,0])
				cube(interruptor_bloque, center=true);
			translate([0,-mp,0])
				rotate([-90,0,0])
					cylinder(d=interruptor_pasante_d, h=bloque[Y]);
		}

		// fila de abajo
		for (i=[columna_x[0], columna_x[1], columna_x[2]] )
			translate([i, -mp, fila_z[0]]) {
				rotate([-90, 0, 0]) 
					cylinder(d=conector_pasante, h=bloque[Y]);
				translate([0, conector_pasante_e, 0])
					rotate([-90, 0, 0]) 
						cylinder(d=conector_holgante, h=bloque[Y]);
			}
		// conector USB
		translate([USB_x,-mp,fila_z[0]])
			bloque_USB();
		
		// LEDS
		translate([LED1_x, 0, LED1_z])
			LED();
		translate([LED2_x, 0, LED2_z])
			LED();

		// esparragos
		for (lado = [-1, 1])
			for (altura = [-1, 1])
				translate([bloque[X]/2 + lado * (bloque[X]/2 - esparrago_margen_x), 0, bloque[Z]/2 + altura * (bloque[Z]/2 - esparrago_margen_z)])
					esparrago();

		// rebajes
		difference() {
			translate([16, bloque[Y] - rebaje_trasero + mp, -mp])
				cube([118, bloque[Y], 75+mp]);
			translate([USB_x, 0, fila_z[0]])
				bloque_USB(envolvente=true);
		}

		// salida de cables
		difference() {
			translate([salida_cables_x, bloque[Y] - salida_cables_prot_dy, salida_cables_z])
				rotate([-90, 0, 0])		
					cylinder(d=salida_cables_prot_d, h = salida_cables_prot_dy + mp);
			// no quiero que asome el protector de cables por el lateral, así que dejo una parede de 1,5mm y ya veremos cómo se apaña
			translate([bloque[X] - 1.6, 0, 0])
				cube(bloque);
		}
		translate([salida_cables_x, bloque[Y] - salida_cables_dy, salida_cables_z])	
			rotate([-90, 0, 0])		
				cylinder(d = salida_cables_d, h=salida_cables_dy + mp);			

	}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module bloque_USB(envolvente=false) {
	grosor = 6 ;
	hueco_trasero_envolvente = 10 ;
	bloque_p = [15.5, 10, bloque_USB[Z]];
	
	if (envolvente) {
		translate([0, bloque_p[Y] + bloque_USB[Y]/2 - hueco_trasero_envolvente - bloque_p[Y], 0])
			cube(bloque_USB + [2*grosor, 0, 2*grosor], center=true);
	} else {
		for (lado = [-1, 1])
			translate([lado * 8.3, bloque_p[Y]/2, 0])
				cube(bloque_p+[0,mp,0], center=true);
		translate([0, bloque_p[Y] + bloque_USB[Y]/2, 0])
			cube(bloque_USB, center=true);
	}
}

module LED() {
	translate([0,-mp,0])
		rotate([-90,0,0])
			cylinder(d=LED_pasante_d, h=bloque[Y]);
	translate([0, LED_pasante_e, 0])
		rotate([-90,0,0])
			cylinder(d=LED_holgante_d, h=bloque[Y]);
}

module esparrago() {
	translate([0, bloque[Y] - esparrago_largo, 0])
		rotate([-90,0,0])
			cylinder(d=esparrago_d, h=esparrago_largo + mp);
}		
