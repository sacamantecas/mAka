/////////////////////////////////////////////////////////////////////////////////
//
// soporte para ventilador del minitaladro (el proceso de esta forma es lentísimo)
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luis gutierrez (sacamantecas)
//
//


hacer_cuerpo = 1 ;
hacer_tapa_inf = 1 ;
hacer_tapa_sup = 1 ;

fabricar = 0 ; // algunas partes se fabrican separadas
$alto_de_capa= .334 ;

/////////////////////////////////////////////////////////////////////////////////

afeitado=0.25 * fabricar;
$fa=1 ;
$fs=1 ;
mp = .1 ;

use <basico.scad>
use <soportes.scad>

gap_h_soporte = soportes($gap_h_soporte);
gap_v_soporte = soportes($gap_v_soporte);
angulo_voladizo = soportes($angulo_voladizo);
espesor = soportes($espesor_defecto);

// ventilador
vnt_dx = correccion(70  +  .2);
vnt_dy = 15 ;
vnt_dz = vnt_dx;
vnt_entra_dy = 1 ;
vnt_dia = 67 ;
vnt_trn_gap = 61.2 ;
vnt_trn_d = 4 ;
vnt_trn_tue_d = 7 ;
vnt_trn_tue_prof = 12 ; // para tornillo M3 de cabeza cilindrica de 25mm

// bloque exterior
ble_pared = 2 ;
ble_dx = vnt_dx + ble_pared * 2 ;
ble_dy = 68 ;
ble_dz = vnt_dx ; 

// tornillos tapas
ttp_dist = [ble_dx/2, -ble_dy/2] - [7,-7];
ttp_prox = [ble_dx/2, ble_dy/2] - [10, 6];
ttp_d = correccion(3  +  .6);
ttp_h = ble_dz/2 ;
ttp_tue_prof = 9 ;
ttp_tue_dz = 3 ;
ttp_cil_d = 6.2 ;
ttp_agarre = 5 ; // distancia entre el cilindro de la cabeza del tornillo de la tapa y la superficie de contacto

// conexión con el soporte de la multiherramienta (parametros de carro.scad)
mh_D = 48 ; 
ancho_canto_crater = 4 ;

// tapas superior e inferior
ts_raja = .3 ;
ts_dz = 25 ;
ts_cupula_dz = 2 ;
ts_reborde_cupula = 3 ;
ti_dz = 20 ;
ts_agujero_dx = 29 ;
ts_agujero_dy = 28.2 ;
// parámetros para los tornillos horizontales de la tapa superior
ttph_dy=((ble_dy-ts_agujero_dx)/2+ts_agujero_dx)/2 - 4 ; // posición en Y a ojo, tomando como referencia el punto medio entre el borde del agujero y el borde exterior
ttph_z= ts_dz-ttp_d/2  - 3 ; // posición en Z a ojo, tomando como referencia el borde superior de la tapa
ttph_agarre=13.3 ; // para usar tornillos M3x30cil y que me queden 3mm holgados para la tuerca



if (hacer_cuerpo) {
	union() {

		// soporte del soporte del arco del ojo del ventilador para que no se tummbe	
		if (fabricar) {
			soposopo=[5,10,30];		
			soposopo_angulo=-30 ;	
			intersection() {
				translate([0,-vnt_entra_dy-mp,soposopo[2]/2])
					cube([soposopo[0]+mp, ble_dy, soposopo[2]], center=true);
				translate([0, ble_dy/2-soposopo[2]*cos(90+soposopo_angulo)-vnt_entra_dy, 0])
					rotate([soposopo_angulo,0,0])
						translate([-soposopo[0]/2, 0, 0])
							cube(soposopo);
			}
		}

		afeita(afeitado)
			difference() {
				translate([0,0,ble_dz/2])
					cube([ble_dx, ble_dy, ble_dz], center=true);
				translate([0,0,-mp/2])
					resize([0,ble_dy - ble_pared *2])
						cylinder(d=ble_dx - ble_pared * 2, h=ble_dz+mp);	
				translate([0, ble_dy/4-vnt_entra_dy+mp, ble_dz/2]) 
					rotate([90,0,0])
						difference() {
							cylinder(d=vnt_dia, ble_dy/2, center=true);
							if (fabricar)
								intersection() {
									cylinder(d=vnt_dia-2*gap_v_soporte, h=ble_dy/2+mp, center=true);
									cube([vnt_dia*cos(angulo_voladizo),vnt_dia, ble_dy/2+mp*2], center=true);
								}

						}
				translate([0, (ble_dy+vnt_dy)/2 - vnt_entra_dy, (ble_dz-mp/2)/2]) 
					cube([vnt_dx, vnt_dy, vnt_dz+mp], center=true);
				translate([0,ble_dy/2, ble_dz/2])
					rotate([90,0,0])
						for ( lado_y=[-1,1] )
							for ( lado_x=[-1,1] )
								translate([lado_x*vnt_trn_gap/2, lado_y*vnt_trn_gap/2, 0]) {
									cylinder(d=vnt_trn_d, h=ble_dy/2);
									translate([0,0,vnt_trn_tue_prof+vnt_entra_dy])
										cylinder(d=vnt_trn_tue_d, h=ble_dy/2-vnt_trn_tue_prof, $fn=6);
								}

				translate([0,0,ble_dz/2]) 
					for (rot=[0,180]) // directo abajo, rotado arriba
						rotate([0,rot,0])
							translate([0,0,-ble_dz/2])
								for (lado_x=[-1,1]) {
									// alojamiento vertical para las tuercas proximales
									translate([ttp_prox[0]*lado_x, ttp_prox[1], ttp_tue_prof])
										cylinder(d=vnt_trn_tue_d, h=ttp_h-ttp_tue_prof, $fn=6);
									// ... y horizontal para las distales
									translate([ttp_dist[0]*lado_x, ttp_dist[1], ttp_tue_prof+ttp_tue_dz/2]) {
										difference() {
											dy_tunel = ttp_dist[1]+ble_dy/2;
											pos_cubo_entrada = [0,-(dy_tunel+mp)/2, ttp_tue_dz/2];
											union() {
												cylinder(d=vnt_trn_tue_d, h=ttp_tue_dz, $fn=6);
												translate(pos_cubo_entrada)
													cube([vnt_trn_tue_d, dy_tunel+mp, ttp_tue_dz], center=true);
											}
											if (fabricar) {
												gap_h_soporte = 3 ; // un gran gap porque de lo contrario no hay forma de sacarlo
												translate(pos_cubo_entrada)
													cube([max(vnt_trn_tue_d-2 * gap_h_soporte, espesor*2), dy_tunel+2*mp, ttp_tue_dz-2*gap_v_soporte], center=true);
											}
										}
									}

									// agujeros verticales para los tornillos: el proximal entero
									translate([ttp_prox[0]*lado_x, ttp_prox[1], -mp]) 
										cylinder(d=ttp_d, h=ttp_h);
									// y el distal
									translate([ttp_dist[0]*lado_x, ttp_dist[1], -mp]) 
										cylinder(d=ttp_d, h=ttp_h);
								}
				
			}	
	}
}

if (hacer_tapa_inf) 
	afeita(afeitado)
		rotate(fabricar?[0,180,0]:[0,0,0])
			difference() {
				// forma externa (el tarugo con reducción hacia el borde externo del cráter
				intersection() {
					translate([0,0,-ti_dz/2])
						cube([ble_dx, ble_dy, ti_dz], center=true);
					hull(){
						translate([-$alto_de_capa/2])
							cube([ble_dx, ble_dy, $alto_de_capa], center=true);
						translate([0,0,-ti_dz])
							cylinder(d=mh_D+2*ancho_canto_crater, h=$alto_de_capa+mp);
					}					
				}
				// menos el conoide interior
				hull() {
					translate([0,0, -$alto_de_capa])
						resize([0,ble_dy-2*ble_pared,0])
							cylinder(d=ble_dx-2*ble_pared, h=$alto_de_capa+mp);
					translate([0,0, -ti_dz-mp])
						cylinder(d=mh_D, h=$alto_de_capa+mp);
				}
				
				for (lado_x=[-1,1]) 
					for (lado_ttp=[ttp_prox, ttp_dist]) { 
						// agujeros verticales para los tornillos
						translate([lado_ttp[0]*lado_x, lado_ttp[1], mp-ti_dz]) 
							cylinder(d=ttp_d, h=ti_dz);
						translate([lado_ttp[0]*lado_x, lado_ttp[1], mp-ti_dz-ttp_agarre]) 
							cylinder(d=ttp_cil_d, h=ti_dz);
					}
			}

if (hacer_tapa_sup) {
	afeita(afeitado)
		translate(fabricar?[0,0,ts_dz/2]:[0,0,ble_dz+ts_dz/2])
			difference() {
				intersection() {
					hipotenusa = sqrt(pow(ble_dx,2)+pow(ble_dy,2));
					cube([ble_dx, ble_dy, ts_dz], center=true);
					translate([0,0,-ts_dz/2])
						resize([0,0,2*ts_dz/sqrt(1-pow((ts_agujero_dx/2+ts_reborde_cupula)/(hipotenusa/2),2))])
							sphere(d=hipotenusa);
				}
					
				cupula_interior();
				cuello_multiherramienta();
				
				cube([ts_raja, ble_dy+mp, ts_dz+mp], center=true);
				
				for (lado_x=[-1,1]) 
					for (lado_ttp=[ttp_prox, ttp_dist]) { 
						// agujeros verticales para los tornillos
						translate([lado_ttp[0]*lado_x, lado_ttp[1], -mp-ts_dz/2]) 
							cylinder(d=ttp_d, h=ts_dz);
						translate([lado_ttp[0]*lado_x, lado_ttp[1], ttp_agarre-ts_dz/2]) 
							cylinder(d=ttp_cil_d, h=ts_dz);
					}
				for (lado_y=[-1, 1]) {
					translate([0,ttph_dy*lado_y, ttph_z-ts_dz/2])
						rotate([0,90,0])
							cylinder(d=ttp_d, h=ttph_agarre*2+10, center=true);
					translate([ -(ble_dx/4+ttph_agarre), ttph_dy*lado_y, ttph_z-ts_dz/2])
						rotate([0,90,0])
							cylinder(d=ttp_cil_d, h=ble_dx/2, center=true);
					translate([ ttph_agarre+ttp_tue_dz/2, ttph_dy*lado_y, ttph_z-ts_dz/2]) {
						at_dy = correccion(ttp_cil_d*cos(30)  +  .6);
						at_dx = correccion(ttp_tue_dz  +  .2);
						at_dz = 10 ;
						rotate([0,90,0])
							cylinder(d=at_dy/cos(30), h=at_dx, center=true, $fn=6);
						translate([-at_dx/2,-at_dy/2,0])
							cube([at_dx, at_dy, at_dz]);
					}
							
				}
				
				
			}
	if (fabricar)
		translate([0,0,ts_dz/2])
			difference() {
				intersection() {
					cupula_interior($alto_de_capa);
					// la cúpula es un elipsoide de 3 ejes: para hacer el soporte a partir de angulo_voladizo necesitaré intersectar la cúpula
					// con un prisma de base elíptica cuyos semiejes hay que calcular
					resize([0,2*radio_soporte(ble_dy),0])
						cylinder(r=radio_soporte(ble_dx), h=ts_dz+mp, center=true);
				}
				cuello_multiherramienta();
			}

}


// altura de la cúpula de la tapa superior
function alto_cupula(merma) = ((ts_dz-ts_cupula_dz)/sqrt(1-pow((ts_agujero_dx/2)/(ble_dx/2-ble_pared),2))-merma*2);
// calcular el radio del soporte de la cúpula de la tapa superior, dado el tamaño total de la pieza (en X o en Y)
function radio_soporte(total) = sqrt(1/(pow(alto_cupula($alto_de_capa)*tan(angulo_voladizo)/pow((total-2*ble_pared)/2,2),2)+1/pow((total-2*ble_pared)/2,2)));


module cupula_interior(merma=0) {
	// sea una elipse de semiejes a=(ble_dx-2*ble_pared) y b; quiero que encaje con el agujero de diámetro ts_agujero_dx dejando una cúpula de espesor ts_cupula_dz
	// así que necesito calcular b=y/sqrt(1-pow(x/a,2)) (ver página de tangente a un óvalo)
	// (luego resulta que al deformar en Y, el espesor de la cúpula delante y detras es .3mm mayor, pero a derecha e izda queda bien, y tampoco hay que ser demasiado exigentes)
	translate([0,0,-ts_dz/2])
		resize([0,ble_dy-2*ble_pared-merma*2, 2*alto_cupula(merma)])
			sphere(d=ble_dx-2*ble_pared);
}
module cuello_multiherramienta() {
	translate([0,0,-mp/4])
		resize([0,ts_agujero_dy,0])
			cylinder(d=ts_agujero_dx, h=ts_dz+mp, center=true);
}
		
