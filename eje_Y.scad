////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// piezas correspondientes al eje Y de mAka
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luis gutierrez (sacamantecas)
//
//

! /* soporte del motor de Y */	translate(fabricar?[-30,25,0]:[mY_soporte_x+mY_soporte_dx/2,0,0]) rotate(fabricar?[0,0,0]:[0,-90,0]) soporte_motor_Y();
  /* 2 patas 	 			*/	mirror([1,0,0]) translate(fabricar?[20,5,pata_dy/2]:[0,15,0]) rotate(fabricar?[-90,0,0]:[0,0,0]) pata();		
  /* las otras 2 patas 		*/	translate(fabricar?[20,5,pata_dy/2]:[0,-15,0]) rotate(fabricar?[-90,0,0]:[0,0,0]) pata();		
  /* herrajes de la pata 	*/	if (!fabricar) color([0,0,0, .2]) herrajes_pata();
  /* portacarro            	*/	portacarro(false);
  /* complemento portacarro	*/	portacarro(true);

fabricar = 0 ;
$alto_de_capa = .25 ;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


hacer_soportes = fabricar;
$afeitado = .2 * fabricar ;
$espesor = .63 ;
$fa = .25 ;
$fs = .25 ;
mp = .1 ;

use <basico.scad>
use <soportes.scad>
use <tangente.scad>


gapplasop = soportes($gap_v_soporte);
gaphsop = soportes($gap_h_soporte);


varillas_X_z = [10, 40] ;
varillas_X_d = correccion(8  +  .2) ; // no importa tenerla que limar un poco
varillas_X_arandela_d = 18 ;
varilla_Y_z = 25 ;
varilla_Y_d = correccion(10 + .2) ;
varilla_lisa_z = 50 ;
varilla_lisa_d = correccion(10  +  .3) ;  // tiene que entrar perfectamente la varilla

mY_z = 36 ;
mY_y = -31 ; // desde las varillas de X traseras
mY_alto_boina = correccion(2  +  .5);

// patas
excentricidad = 4 ;
pata_dx = 20+excentricidad ;
pata_excentricidad_X = excentricidad/2 ;
pata_dy = 20 ;
pata_dz = varilla_lisa_z + varilla_lisa_d/2 + 2 ;
// mini-microrruptor
mmr_dx = correccion( 5.8 + .3); // que sobresalga
mmr_dy = 6.5 ;
mmr_dz = correccion( 13 + .2 ) ;
//mmr_x = correccion(varilla_lisa_d/2 + mmr_dx/2   +   .4) ;
mmr_x = (pata_dx + pata_excentricidad_X - mmr_dx)/2 - 1;
mmr_y = -(pata_dy-mmr_dy)/2 ;
mmr_z = pata_dz - mmr_dz/2 - .8 ;
mmr_con_dx = mmr_dx - 2 ;
mmr_con_dy = 5 ;
mmr_con_dz = mmr_dz - 1 ;

conn_dx = correccion(2.55 + .25) ;
conn_dy = 7 ;
conn_dz = 6 ;
conn_x = mmr_x ;
conn_z = varillas_X_z[1] + -varillas_X_d/2 ;

paso_dx = 1 ;
paso_dy = 5 ;
paso_dz = mmr_z - conn_z ;
paso_x = mmr_x ;
paso_y = paso_dy/2 + 3 - pata_dy/2 ;
paso_z = (mmr_z+conn_z)/2 ;

// motor (variables de s'extrusor)
an17 = 42.3 ; // ancho del NEMA1
afm = 3.6/2 ; // agujero de fijaci+¦n del motor
asm = 1 ; // arandela de separaci+¦n del motor
rasm = 8/2 ; // radio de la arandela de separacion del motor
afme = 6.4/2 ; // apertura para la cabeza del tornillo de fijaci+¦n del motor
pafme = 1 ; // del agujero del tornillo penetraci+¦n
dam = 15.5 ; // distancia de los agujeros del motor a su eje
hbm = 12 ; // hueco para la boina del motor

hundimiento_tornillo_motor = 2 ; 
arandela_motor = correccion(7  +  .6); // (rasm es para fabricar un resalte formando parte del extrusor: va sobrado, y por cuestiones de churrito prefiero que sea menor

// soporte motor Y
mY_soporte_x = 4 ;
mY_soporte_dx = 8 ;
mY_soporte_dy = varillas_X_arandela_d/2 - mY_y + an17/2 ;
mY_soporte_zs = mY_z + an17/2;
mY_soporte_hueco_correa_dz = 20 ;
mY_soporte_hueco_correa_dx = 9.7 ;
mY_soporte_dx_para_tornillos_sup = 4 ;





module soporte_motor_Y() {

	module soporte_motor_Y_2D() {
		merma=$afeitado;
		difference() {
			union() {
				difference() {
					translate([mY_z - an17/2+merma, mY_y - an17/2 + (an17/2-dam)])
						square([an17-2*merma, mY_soporte_dy-(an17/2-dam)-merma]);
					translate([varillas_X_z[1], mY_y+dam+mp])
						difference() {
							r = mY_z+an17/2-varillas_X_z[1] -merma;
							square([r+mp, -mY_y-dam+varillas_X_arandela_d/2+mp-merma]);
							resize([r*2,2*(-mY_y-dam+varillas_X_arandela_d/2-merma)]) 
								circle(r);
							}
				}
				translate([mY_z-dam, mY_y-an17/2+merma])
					square([dam*2, an17/2-dam+mp-merma]);
				for (l=[-1, 1])
					translate([mY_z+l*dam, mY_y-dam])
						circle(r=an17/2-dam-merma);
				translate([varillas_X_z[0], 0])
					circle(d=varillas_X_arandela_d - 2*merma);
				translate([varillas_X_z[0]+mp, -varillas_X_arandela_d/2+merma])
					square([mY_z-an17/2-varillas_X_z[0]+mp+merma, varillas_X_arandela_d-2*merma]);
				translate([mY_z-an17/2+merma, 0])
					rotate([0, 180, 90])
						ladera_2D([-mY_y, mY_z-an17/2-varillas_X_z[0]+varillas_X_arandela_d/2]);
			}
		for (h=varillas_X_z)	
			translate([h, 0])
				circle(d=varillas_X_d+2*merma);
		translate([mY_z, mY_y])
			for (a=[0:90:360-1])
				rotate([0,0,a])
					translate([dam,dam])
						circle(r=afm+merma);
		}
	}


	difference() {
		afeitado_extrude(mY_soporte_dx) 
			soporte_motor_Y_2D();
		if ($afeitado)
			translate([mY_z, mY_y, -mp])
				cylinder(r=hbm+$afeitado, h=$alto_de_capa+mp);
		translate([mY_z, mY_y, -mp])
			cylinder(r=hbm, h=mY_alto_boina+mp);
		translate([mY_z, mY_y, -mp/2]) 
			cylinder(d=mY_soporte_hueco_correa_dz, h=mY_soporte_dx+mp);
		translate([mY_z-mY_soporte_hueco_correa_dz/2,mY_y-(an17/2+mp),mY_soporte_x+mY_soporte_dx/2-mY_soporte_hueco_correa_dx/2])
			cube([mY_soporte_hueco_correa_dz, an17/2+mp, mY_soporte_hueco_correa_dx+mp]);
		for (l=[-1,1])
			translate([mY_z-dam, mY_y+l*dam, mY_soporte_dx-hundimiento_tornillo_motor])
				cylinder(d=arandela_motor, h=hundimiento_tornillo_motor+mp);
		difference() {
			union() {
				translate([mY_z + mY_soporte_hueco_correa_dz/2, varillas_X_arandela_d/2-mY_soporte_dy-mp/2, mY_soporte_dx_para_tornillos_sup]) 
					cube([mY_soporte_zs-(mY_z + mY_soporte_hueco_correa_dz/2)+mp, mY_soporte_dy + mp, mY_soporte_dx - mY_soporte_dx_para_tornillos_sup + mp]);
				translate([mY_z+mY_soporte_hueco_correa_dz/2,(varillas_X_arandela_d+mp)/2, mY_soporte_dx])
					rotate([-90,0,180])
						ladera([mY_z+mY_soporte_hueco_correa_dz/2-varillas_X_z[1], mY_soporte_dx - mY_soporte_dx_para_tornillos_sup, mY_soporte_dy+mp], sobrado=true);
				}		
			translate([varillas_X_z[1], 0, 0]) 
				cylinder(d=varillas_X_arandela_d, h=mY_soporte_dx);
		}
	}

	if (hacer_soportes)
		translate([mY_z , mY_y, 0])
			difference() {
				cylinder(r=hbm - .6, h=mY_alto_boina-$alto_de_capa);
				translate([0,0,-mp])
					cylinder(d=mY_soporte_hueco_correa_dz, h=mY_alto_boina);
			}
}


module afeitado_extrude(alto)  {
	pulopo = ($afeitado?$alto_de_capa:0);
	if ($afeitado) 
		linear_extrude($alto_de_capa)
			children();

	translate([0,0,pulopo])
		linear_extrude(alto-pulopo) {
			$afeitado=0;		
			children();
		}
}


module pata() {

	module pata_2D() {
		merma = $afeitado;
		difference() {
			union() {
				translate([merma, merma])
					square([pata_dx-2*merma, varilla_lisa_z-merma]);
				translate([(pata_dx-pata_excentricidad_X)/2, varilla_lisa_z])
					resize([0, (pata_dz-varilla_lisa_z-merma)*2])
						circle(d=pata_dx-pata_excentricidad_X-2*merma);
				translate([(pata_dx-pata_excentricidad_X)/2, varilla_lisa_z])
					square([(pata_dx+pata_excentricidad_X)/2-merma, pata_dz-varilla_lisa_z-merma]);
			}
		translate([(pata_dx-pata_excentricidad_X)/2, varilla_Y_z])
			circle(d=varilla_Y_d+2*merma);
		translate([(pata_dx-pata_excentricidad_X)/2, varilla_lisa_z])
			circle(d=varilla_lisa_d+2*merma);
		}
	}

	
	difference() {
		translate([-(pata_dx-pata_excentricidad_X)/2,pata_dy/2,0]) rotate([90,0,0]) afeitado_extrude(pata_dy) pata_2D();

		for (z = varillas_X_z)		
			translate([pata_excentricidad_X/2,0,z])
				rotate([90,-90,90])
					if (hacer_soportes) 
						agujero_cilindrico_soportado(varillas_X_d, pata_dx, en_X=1);
					else
						cylinder(d=varillas_X_d, h=pata_dx+mp, center=true);
			
		translate([mmr_x, mmr_y, mmr_z]) {
			cube([mmr_dx+mp, mmr_dy+mp, mmr_dz], center=true);
			translate([0, (mmr_dy+mmr_con_dy)/2,0])
				cube([mmr_con_dx, mmr_con_dy+mp, mmr_con_dz], center=true);
		}

		difference() { // le quito un trozo para no dañar el soporte del agujero de la varilla X
			union() {
				translate([conn_x, (conn_dy-pata_dy)/2, conn_z])
					cube([conn_dx, conn_dy+mp, conn_dz], center=true);
				translate([paso_x, paso_y, paso_z])
					cube([paso_dx, paso_dy, paso_dz], center=true);	
			}
			translate([0, 0, varillas_X_z[1]])
				rotate([0,90,0])
				cylinder(d=varillas_X_d-gapplasop, h=pata_dx);
		}
	}
}

module herrajes_pata() {
	va = 200 ;
	// varilla lisa y rodamiento
	translate([0, pata_dy/2+.5, varilla_lisa_z]) rotate([90,0,0]) cylinder(d=varilla_lisa_d, h=va);
	translate([0, -pata_dy/2, varilla_lisa_z]) rotate([90,0,0]) cylinder(d=19, h=29);
	// varilla de Y
	translate([0, pata_dy+3, varilla_Y_z]) rotate([90,0,0]) cylinder(d=varilla_Y_d, h=va);
	for (l=[-1, 1]) {
		translate([0, l*(pata_dy/2+2+9.7/2), varilla_Y_z]) rotate([90,0,0]) cylinder(d=19.6, h=9.7, $fn=6, center=true);
		translate([0, l*(pata_dy/2+2/2), varilla_Y_z]) rotate([90,0,0]) cylinder(d=19.8, h=2, center=true);
	}
	// varillas de X
	for (z = varillas_X_z) {
		translate([-pata_dx/2-10, 0, z]) rotate([0,90,0]) cylinder(d=varillas_X_d, h=va);
		for (l=[-1, 1]) {
			translate([l*(pata_dx/2+1.5+6/2)-pata_excentricidad_X/2, 0, z]) rotate([0,90,0]) cylinder(d=14.6, h=6, $fn=6, center=true);
			translate([l*(pata_dx/2+1.5/2) -pata_excentricidad_X/2, 0, z]) rotate([0,90,0]) cylinder(d=17.8, h=1.5, center=true);
		}
	}	
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module portacarro(complemento) {
	rodamiento_d = 19 ;
	rodamiento_l = correccion(29  +  .2) ;
	zapatilla = $alto_de_capa * 2 ;
	canto = 1 ;
	alto_estructura = 3 ;
	separa_travesanios = 101 ;
	ancho_travesanio = 25 ;
	hueco_cursor = 35 ;
	puente_cursor = 10 ;
	sujeta_rodamiento = 2 ;
	rodamientos_dx = 160 ;
	rodamientos_dy = separa_travesanios - 2 ;
	zocalo_dx = rodamiento_d ;
	zocalo_dy = rodamiento_l + sujeta_rodamiento * 2 ;
	zocalo_dz = rodamiento_d/2*(1- sin(acos((zocalo_dx/2 - canto)/(rodamiento_d/2)))) + zapatilla;
	holgura_con_pata = .6 ;
	
	tarugo_dx = 10 ;
	tarugo_dy = 5 ;
	tarugo_dz = 12 ;
	tarugo_x = rodamientos_dx/2 -23 ;
	tarugo_agujero_z = 8.5 + zapatilla ;
	tarugo_agujero_d = 2.5 ;
	
	holgura_complemento = 1 ;
	grosor_pletina = 3 ;
	
	module portacama_2D() {
		for (lado_x = [-1, 1])
			translate([0, lado_x * separa_travesanios/2, 0])
				square([rodamientos_dx, ancho_travesanio], center=true);
		difference() {		
			polygon([[-96.70,-63.00], [-35.25,63.00], [35.25,63.00], [96.70,-63.00]]);
			polygon([[-56.70,-38.00], [-19.63,38.00], [19.63,38.00], [56.70,-38.00]]);
			for (lado_x = [-1, 1])
				translate([lado_x * (rodamientos_dx + ancho_travesanio + zocalo_dx)/2, -rodamientos_dy/2])
					square([ancho_travesanio, zocalo_dy], center=true);
		}
	}

	if (complemento) 
		union() {
			afeitado_extrude(grosor_pletina) 
				intersection() {
					portacama_2D();
					square([rodamientos_dx+rodamiento_d, separa_travesanios-ancho_travesanio-holgura_complemento*2], center=true);
				}
			for (lado=[-1,1]) {
				translate([0, lado*30, (grosor_pletina-2*$alto_de_capa)/2])
					cube([73-lado*29, 3, grosor_pletina-2*$alto_de_capa], center=true);
				translate([0, lado*30, grosor_pletina/2])
					cube([73+6-lado*29, 3, grosor_pletina-4*$alto_de_capa], center=true);
			}					
		}
	else
		difference() {
			union() {
				afeitado_extrude(alto_estructura) portacama_2D();
				for (lado_x=[-1,1])
					for (lado_y=[-1,1])
						translate([lado_x*rodamientos_dx/2 - zocalo_dx/2, lado_y*rodamientos_dy/2 - zocalo_dy/2, 0])
							difference() {
								cube([zocalo_dx, zocalo_dy, zocalo_dz]);
								// hacer un recorte al zócalo, porque pega con la pata
								translate([zocalo_dx/2, zocalo_dy/2+lado_y*(rodamiento_l+(zocalo_dy-rodamiento_l)/2+mp/2)/2, zocalo_dz/2 + rodamiento_d/2 + zapatilla - (pata_dz-varilla_lisa_z+holgura_con_pata)])
									cube([zocalo_dx+mp, (zocalo_dy-rodamiento_l)/2+mp, zocalo_dz], center=true);
							}
				translate([-(hueco_cursor+mp)/2, (ancho_travesanio-separa_travesanios)/2, 0])
					cube([hueco_cursor+mp, puente_cursor, alto_estructura]);
				for (lado=[-1,1])
					translate([lado * hueco_cursor/2, (ancho_travesanio-separa_travesanios)/2, 0])
						mirror([sign(lado-1),0,0])
							ladera([rodamientos_dx/4, puente_cursor, alto_estructura]);

				translate([tarugo_x-tarugo_dx/2, (separa_travesanios-ancho_travesanio)/2, alto_estructura-mp])
					cube([tarugo_dx, tarugo_dy, tarugo_dz]);
			}
			
			for (lado_x=[-1,1])
				for (lado_y=[-1,1])
					translate([lado_x * rodamientos_dx/2, lado_y * rodamientos_dy/2 -rodamiento_l/2,  rodamiento_d/2 + zapatilla])
						rotate([-90,0,0])
							cylinder(d=rodamiento_d, h=rodamiento_l);
							
			for (lado_x = [-1, 1])
				for (lado_y = [-1, 1])
					for (ladito_x = [-1, 1])
						translate([lado_x * 80 + ladito_x*5, lado_y * separa_travesanios/2, -mp])
							rotate([0,ladito_x*35,0])
								translate([0,0,-3])
								cylinder(d=3, h=zocalo_dz*2);
			
			translate([0, -separa_travesanios/2, alto_estructura/2])
				cube([hueco_cursor, ancho_travesanio+mp, alto_estructura+mp], center=true);
				
			translate([tarugo_x,  (separa_travesanios-ancho_travesanio)/2, tarugo_agujero_z])
				rotate([90,0,0])
					cylinder(d=tarugo_agujero_d, h=tarugo_dy*2+mp, center=true);
		}
}


