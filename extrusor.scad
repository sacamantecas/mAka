/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// extrusor para mAka
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luiso gutierrez (sacamantecas)
//
//
// todas las piezas se fabrican con capas de .2
//

hacer_cuerpo = 1 ;
preparar_rosca_para_detector = 1 ;
hacer_presor = 1 ;
hacer_casquillo = 1 ;
hacer_pinion = 1 ;	tornillo_fuera = 0 ;
hacer_catalina = 1 ;
hacer_anclajes = 1 ;
hacer_detector = 1 ;



fabricar = 0 ;
afeitado = .25 * fabricar ;
hacer_soportes = fabricar ;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


use <utilidades.scad>
use <MCAD/involute_gears.scad>

ucm = .1 ; // un chorrito más para asegurar uniones. OjO, porque si es grande puede afectar negativamente
2_manifold = .001 ; // para evitar problemas de 2-manifold
rebose=.15 ; // cuánto rebosa el churrito
precision = 2 ; // se usa para calcular el nº de facetas de los cilindros
groplasop = 1 ; // grosor de las plataformas de soporte
gapplasop = .25 ; // separación entre las plataformas de soporte y lo soportado
sephsop = .7 ; // separación horizontal de las plataformas de soporte

refagj = [
	[  0   ,  0   ],
	[  1   ,  0.75],
	[  1.2 ,  0.9 ], 
	[  1.29,  0.95], 
	[  1.47,  1.2 ],
	[  1.63,  1.35],
	[  2   ,  1.8 ],
	[  2.2 ,  1.9 ],
	[  3   ,  2.9 ],
	[  3.2 ,  3.0 ],
	[  4.0 ,  3.91], 
	[  4.5 ,  4.25],
	[  4.65,  4.55], 
	[  5   ,  4.8 ],
	[  8   ,  7.9 ],
	[ 12   , 11.9 ],
	[ 15   , 14.9 ],
	[999999,999999] ];
	
function agj(radio, indice=0) =  
	(refagj[indice][1]>=radio) 
	? ( refagj[indice-1][0] + (radio-refagj[indice-1][1])*((refagj[indice][0]-refagj[indice-1][0])/(refagj[indice][1]-refagj[indice-1][1])) ) 
	: agj(radio, indice+1) ;
	
	
function fn(r) = floor(( precision *r*3.14+3)/4)*4; // nº de facetas según el radio, ajustado a múltiplo de 4


an17 = 42.3 ; // ancho del NEMA1
afm = 3.6/2 ; // agujero de fijación del motor
asm = 1 ; // arandela de separación del motor
rasm = 8/2 ; // radio de la arandela de separacion del motor
afme = 6.4/2 ; // apertura para la cabeza del tornillo de fijación del motor
pafme = 1 ; // del agujero del tornillo penetración
dam = 15.5 ; // distancia de los agujeros del motor a su eje
hbm = 12 ; // hueco para la boina del motor

m4ca_r = 3.6 ; // M4 (cabeza) cilíndrica (con) arandela
m4ca_h = 3.7 ; // M4 (cabeza) cilíndrica (con) arandela

de_hendiduras_a_tuerca = 26.6 ; // distancia de las hendiduras a la base de la tuerca
grosor_engranajes = 15 ; // 14 es el máximo (y no sé si incluso excesivo)
separa_engranajes_del_cuerpo = 4 ;

drg = 56.6 ; // diametro rueda grande
hvrg = 1 ; // holgura vertical rueda grande

dee = 35 ; // distancia entre ejes (forma parte del diseño de las ruedas)
defc = 54 ; // distancia entre las fijaciones del carro
cue_alto = 50 ;
cue_fondo = 28 ; // grosor del cuerpo
offset_eje = (7/2 + 3/2 - .2); // distancia del centro del agujero de filamento al eje del tornillo ranurado

// anclaje_dcha (y algo de izda)
X_eje_balanceo = offset_eje + dee - 6 ;// si <33.3 entonces el hueco del tornillo de anclaje se conecta con el del eje de balanceo
sobresale_cuerno_dcho = 4.5 ; // cuánto sobresale el cuerno más allá del eje de balanceo (3mm + radio del eje)
sobresale_cuerno_izq = 8 ; // cuánto salen los cuernos izquierdos más allá de la fijación al carro

// los anclajes van sobre una suela de zapatilla
alto_zapatilla = 0 * .6 ; // base que sólo sirve para fijar los anclajes
holgura_zapatilla = .3 ;
ejebalanceo = 3.6 ;
adgl = 6.3 + alto_zapatilla + holgura_zapatilla ; // grosor lengua
plusoreja = .6 ;
adrme = 15 ; // radio X de la elipse que envuelve al tornillo de amarre M4
adabl = 16 ; // radio Y de la elipse, y ancho bloque lengua
adhxl = .5 ; // holgura que deja la lengua del ancla con el cuerpo (en X)
adhyl = .4 ; // holgura que deja la lengua del ancla con el cuerpo (en Y) (se aplica en el ancho de la lengua, porque al imprimir en horizontal es más preciso
adhxc = 1 ; // holgura entre el ancla y el final del cuerno, en X
adlbl = X_eje_balanceo-defc/2 + sobresale_cuerno_dcho ; 
adwse = 10 ; // ancho del soporte del eje
adgo = 4 ; // grosor de las orejas donde va el eje de balanceo del extrusor (y las izquierdas)
ancho_anclaje = cue_fondo+(adgo+rebose+.15)*2 ; // le doy algo más de holgura


// constantes para distinguir funciones
cue_cuerpo = 0 ;
cue_presor = 1 ;
cue_detector_cuerpo = 2 ;
cue_detector_balancin = 3 ;
cue_detector_obturador = 4 ;
cue_ancla_i = 5 ;
cue_ancla_d = 6 ;
cue_ancla = 7 ;

module cilindro(r, h) cylinder(r=r, h=h, center=true, $fn=fn(r));


module cubor(v, esquinas=15, radio=1) {
	// cubo redondeado, indicando la máscara de esquinas (1=+X+Y; 2=+X-Y; 4=-X-Y; 8=-X+Y) y el radio de redondeo
	// Z no lo considero, porque esto está pensado para optimizar la impresión en el plano XY al eliminar esquinas
	w=v[0]/2 - radio;
	l=v[1]/2 - radio;	
	hull() {
		translate([w, l, 0]) if (esquinas%2 == 1) cilindro(radio, v[2]); else cube([radio*2,radio*2,v[2]], center=true);
		translate([w, -l, 0]) if (floor(esquinas/2)%2 == 1) cilindro(radio, v[2]); else cube([radio*2,radio*2,v[2]], center=true);
		translate([-w, -l, 0]) if (floor(esquinas/4)%2 == 1) cilindro(radio, v[2]); else cube([radio*2,radio*2,v[2]], center=true);
		translate([-w, l, 0]) if (esquinas/8 >= 1) cilindro(radio, v[2]); else cube([radio*2,radio*2,v[2]], center=true);
	}
}

module agujero_holgado(r1, r2, h, hol) {
	if (hol>0) {
		hull() {
			cilindro(r1, h*2);
			translate([hol,0,0]) cilindro(r1, h*2);
		}
		translate([0,0,h/2]) hull() {
			cilindro(r2, h);
			translate([hol,0,0]) cilindro(r2, h);
		}
	} else {
		cilindro(r1, h*2);
		translate([0,0,h/2]) cilindro(r2, h);
	}
}	

module eje_balanceo(raio) { // el eje ya está en el X del eje del motor (que será su posición final)
	translate([X_eje_balanceo, 0, 0]) rotate([90,0,0]) cylinder(r=raio, h=50, center=true, $fn=fn(raio));
}


module anclaje_dcha_lengua() {
	union() {
		scale([1, adabl/adrme, 1]) cilindro(adrme/2, adgl);
		translate([adlbl/2, 0, 0]) cube([adlbl, adabl, adgl], center=true);
	}
}

module anclaje_dcha() {
	sobresale = .8 ; // es lo que sobresale la cabeza del tornillo (es un ajuste de última hora, consecuencia de dejar 1mm de holgura hasta el motor)
	zapatilla=alto_zapatilla+holgura_zapatilla;
	escalaY = (adabl-adhyl*2)/adabl; // cada vez me van cabiendo menos chapuzas :(

	module oreja(lado) {
		translate([adlbl-adwse/2,sign(lado)*(ancho_anclaje-adgo)/2, (adgl+plusoreja)/2-zapatilla]) 
			cubor([adwse, adgo, adgl+plusoreja], esquinas=12);
	}		
	
	module hueco_cuerno(lado) {
		ancho = (ancho_anclaje-adabl*escalaY)/2-adgo ;
		translate([adlbl-adwse/2+adhxc,sign(lado)*((adabl*escalaY+ancho)/2), adgl/2-zapatilla]) 
			cubor([adwse, ancho, adgl+ucm], esquinas=3, radio=adhxc/2);
}			

	difference() 
	{
		union() {
			scale([1,escalaY,1]) translate([0, 0, adgl/2-zapatilla]) anclaje_dcha_lengua();
			oreja(1);
			oreja(-1);
			translate([adlbl+adgo/2+adhxc/2, 0, (adgl+plusoreja)/2-zapatilla])
				difference() {
					cubor([adgo+adhxc+ucm, ancho_anclaje, adgl+plusoreja], esquinas=3);
					translate([0,0,(adgl+ucm)/2])
						cube([adgo+adhxc+ucm+ucm, ancho_anclaje - 2*adgo, plusoreja+ucm], center=true);
				}
		}
		hueco_cuerno(1);
		hueco_cuerno(-1);
		translate([0, 0, adgl-(m4ca_h-ucm)/2 + sobresale]) cilindro(agj(m4ca_r), m4ca_h+ucm);
		cilindro(agj(4/2), 20); // agujero para el tornillo M4 (más vale que zozobre)
		translate([-defc/2,0,ejebalanceo]) { // retrocedo defc/2 porque el anclaje va directamente en al agujero de fijación
			// quiero holgado el agujero interior
			scale([1,.5,1]) eje_balanceo(3.4/2); 
			eje_balanceo(3.2/2); }

		// rebajar el lado izquierdo
		translate([-adrme/2, 0, adgl-zapatilla]) {
			plus = m4ca_r ;
			scale([1,1,((m4ca_h-zapatilla-sobresale)*2)/(adrme+plus*2)])
				rotate([90,0,0]) 
					cylinder(r=adrme/2+plus, h=adabl+ucm/5, center=true, $fn=fn(adrme/2));
		}
	}
}


/*##################################################################################################
####################################################################  ##############################
####################################################################################################
#########    ###     ####   #  #  #   ###    ###     ####    #######  ###    ####     ##############
########  ##  ##  ##  ##  ##  ###   #  #####  ##  ##  ######  ######  ##  ##  ##  ##################
########      ##  ##  ##  ##  ###  ##  ##     ##  ##  ###     ######  ##      ###    ###############
########  ######  ##  ###     ###  #####  ##  ##  ##  ##  ##  ##  ##  ##  ##########  ##############
#########    ###  ##  ######  ##    #####   #  #  ##  ###   #  #  ##  ###    ###     ###############
########################     ####################################    ###############################
##################################################################################################*/

module mi_engranaje(dientes, completo=true, h=grosor_engranajes) {
	module semiengranaje(dientes, alto) {		 
		// es importante un chorrito adicional mini-mini
		//	NOOOOOO; ESE CHORRITO METE CIENTOS O MILES DE PROBLEMAS!!!!!
			gear (number_of_teeth=dientes,
				circular_pitch = 54.1 * 2 * 3.1415926535897932384626433832795,
				pressure_angle = 30,
				clearance = .2,
				gear_thickness = alto / 2,
				rim_thickness = alto / 2,
				rim_width = 10,
				hub_thickness = 0,
				hub_diameter = 0,
				bore_diameter = 0,
				circles=0,
				twist= 200 / dientes * alto/grosor_engranajes); }

	if (completo)
		semiengranaje(dientes, h);
	mirror([0,0,1])
		semiengranaje(dientes, h);
}	


module engranaje_grande() {
	radio_sup_hub=10 ;
	radio_tuerca=15/2 ;
	radio_inf_hub=6 ;
	cono_llanta=grosor_engranajes/10 ;
	radio_int_llanta = 23 - cono_llanta ;
	base_tuerca_z = de_hendiduras_a_tuerca - cue_fondo/2 - grosor_engranajes/2 - separa_engranajes_del_cuerpo;
	h_tuerca = max(5, grosor_engranajes/2-base_tuerca_z) ;	
	alto_central_radios = grosor_engranajes; // hasta dónde llegan los radios en el eje
	h_cono_adapta = radio_sup_hub-radio_inf_hub ; // 45º	
	radio_esparrago=8.05 ;
	interseccion_radios = radio_inf_hub-agj(radio_esparrago/2) ; // interpenetración óvalo radios
	radio_final=56.626/2 ; // empírico, no sé cómo calcularlo a partir de los datos del engranaje :(

	// parámetros que hay que ajustar tanteando para que quede chulo
	radios=3 ;
	radio_ext_circulo = 0 ; // se corrige a un mínimo imprescindible
	grosor_radios=2 ; // grosor radios
	ratio_ovalo_radios = 1.7 ; // ratio óvalo radios
	
	
	rcre=max(radio_ext_circulo, (radio_int_llanta-radio_inf_hub)/2+interseccion_radios+cono_llanta);
	
	union() {
		// llanta dentada
		difference() {
			mi_engranaje(28);
			translate([0,0,grosor_engranajes-.4]) // matar las 2 capas de arriba porque arañan y van a juntarse con la rebaba del engranaje pequeño
				difference(){			
					cylinder(r=radio_final+ucm, h=grosor_engranajes, center=true, $fn=fn(radio_final));
					translate([0,0,.4]) cylinder(r=radio_final-.3, h=grosor_engranajes+1, center=true, $fn=fn(radio_final));
					translate([0,0,-grosor_engranajes+.2]) cylinder(r=radio_final-.1, h=grosor_engranajes, center=true, $fn=fn(radio_final));
				}
			cylinder(r1=radio_int_llanta+cono_llanta, r2=radio_int_llanta-cono_llanta, h=grosor_engranajes+ucm, center=true, $fn=fn(radio_int_llanta));
			cylinder(r1=radio_int_llanta-cono_llanta, r2=radio_int_llanta+cono_llanta, h=grosor_engranajes+ucm, center=true, $fn=fn(radio_int_llanta));
			}	

		// eje	
		difference() {
			union() {
				translate([0,0,-grosor_engranajes/2]) 
					cylinder(r=radio_inf_hub, h=grosor_engranajes/2+base_tuerca_z, $fn=fn(radio_inf_hub));

				translate([0,0, base_tuerca_z+h_tuerca-(h_tuerca/2+radio_sup_hub/2-radio_inf_hub/2)]) {
					difference() {
						intersection(){
							cylinder(r=radio_sup_hub, h=h_tuerca+radio_sup_hub-radio_inf_hub, center=true, $fn=fn(radio_sup_hub));
							cylinder(r1=radio_inf_hub-ucm, r2=radio_sup_hub+h_tuerca+ucm, h=radio_sup_hub-radio_inf_hub+h_tuerca+2*ucm, center=true, $fn=fn(radio_sup_hub));
						}
						translate([0,0,(radio_sup_hub-radio_inf_hub+ucm)/2])
							cylinder(r=agj(radio_tuerca), h=h_tuerca+ucm, center=true, $fn=6);
					}	
				}
			}
			cylinder(r=agj(radio_esparrago/2), h=grosor_engranajes*3, center=true, $fn=fn(radio_esparrago/2));
		}
		
		// radios
		difference() {
			raio_h = alto_central_radios - grosor_engranajes/2 + ucm  ;
			raio_r = radio_int_llanta-cono_llanta-radio_sup_hub ;
			for(i=[0:radios-1])	{
				rotate([0,0,i*360/radios])
					translate([0,0,(alto_central_radios-grosor_engranajes)/2])
						intersection() {
							translate([0,rcre+radio_inf_hub-interseccion_radios,0])
								difference() {
									scale([ratio_ovalo_radios,1,1]) 
										cylinder(r=rcre, h=alto_central_radios, center=true, $fn=fn(rcre));
									// el óvalo interior va escalado de forma que mantiene el grosor
									scale([(ratio_ovalo_radios*rcre-grosor_radios)/(rcre-grosor_radios),1,1]) 
										cylinder(r=rcre-grosor_radios, h=alto_central_radios+ucm+ucm, center=true, $fn=fn(rcre-grosor_radios));
								}
							cylinder(r=radio_int_llanta+2, h=alto_central_radios+ucm+ucm, center=true, $fn=fn(radio_int_llanta/2));
						}
			}
			
			// quitar los óvalos en el alojamiento de la tuerca
			translate([0,0,base_tuerca_z+(h_tuerca+ucm)/2])
				cylinder(r=agj(radio_tuerca), h=h_tuerca+ucm, center=true, $fn=6);
				
*			translate([0,0,raio_h]) 
				rotate_extrude($fn=fn(raio_r))
					translate([radio_sup_hub+raio_r,0,raio_h])
						scale([raio_r/raio_h,1,0])
							circle(r=raio_h, $fn=fn(raio_r));
		}		
	}
}


module engranaje_peque(tornillo_fuera = 1) {
	grueso_tuerca = 2.7 ;
	ancho_tuerca=5.9 ; // ojo cuidado: la profundidad sale bien siendo de 6.2, y la anchura sale bien con 5.9; habría que deformar
	alto_tuerca=6.2 ; // por cuestiones de fabricación, hay que considerar un diámetro vertical mayor ¡!
	radio_eje = 2.75 ; // ya corregido para imprimir
	penetracion=.6 ; // es la medida del rebaje del eje
	alto_cuello = 4.6 ;
	filete_cortesia=.2 ; // por los descuelgues del cuello sobre los dientes
	diente_con_tornillo = [0,0,tornillo_fuera ? 27 : 33] ;
	
	rotate(-diente_con_tornillo)
		difference() {
			union() {
				rotate(diente_con_tornillo) 
					mirror([0,tornillo_fuera,0]) 
						mi_engranaje(9, h=grosor_engranajes + 2*filete_cortesia); // reflejado para que encaje con el grande (no son simétricas)
				// añadir un filete más, por lo que pueda descolgar al hacer el cuello
				translate([0,0,alto_cuello/2+grosor_engranajes/2+filete_cortesia]) 
					cylinder(r=18/2, h=alto_cuello, center=true, $fn=fn(12));
			}

			// hueco para tuerca y tornillo prisionero		 
			translate([0, grueso_tuerca/2 + radio_eje - penetracion, grosor_engranajes/2 + alto_cuello - 6/2 + .5]) {
				rotate([90,30,0]) // hueco de la tuerca
					scale([1,alto_tuerca/ancho_tuerca,1])
						cylinder(d=ancho_tuerca/cos(30), h=grueso_tuerca, center=true, $fn=6);
				translate([0,0, ancho_tuerca/2]) // abertura por arriba, para que se puede colocar
					cube([ancho_tuerca, grueso_tuerca, ancho_tuerca], center=true);
				translate([0,-1/2, .5]) // evitar picos entre el eje y la cuerca
					cube([ancho_tuerca-2, grueso_tuerca+1, ancho_tuerca], center=true);
				rotate([90,0,0]) // agujero para el prisionero
					translate([0,0,-5])
					cylinder(r=1.6, h=10, center=true, $fn=fn(1.6));
			}
			cylinder(r=radio_eje, h=40, center=true, $fn=fn(2.7));
		}
}

/*##################################################################################################
####################################################################################################
####################################################################################################
#########    ###  ##  ###    ###  #   ##  #   ###    ###############################################
########  ##  ##  ##  ##  ##  ###   #  ##  ##  #  ##  ##############################################
########  ######  ##  ##      ###  ##  ##  ##  #  ##  ##############################################
########  ##  ##  ##  ##  #######  ######     ##  ##  ##############################################
#########    ####   #  ##    ###    #####  ######    ###############################################
########################################    ########################################################
##################################################################################################*/
				

module silueta_XY_cuerpo(holgura=0) {
	translate([-sobresale_cuerno_izq-defc/2, -cue_fondo/2])
		offset(holgura)
			square([sobresale_cuerno_izq + defc + sobresale_cuerno_dcho, cue_fondo]);
}
				
module cuerpo(elemento=cue_ancla) {
	cue_w = 24 ;
	cue_w_merma = .8 ; // un descuento en cue_w para darle respiración al motor
	povi = 1.5 ; // proporcion del óvalo que forma la vertiente izquierda
	puovi = .7 ; // proporción de cue_w usada por el óvalo anterior
	htrh = 4.2 ; // hueco del tornillo ranurado con holgura
	som_l = 4 ; // soporte del motor
	ser_h=cue_alto-an17-1; // soporte del eje de rotación del cuerpo
	ser_l = 6 ; 
	ser_wm = an17 ; // lado del motor
	ser_wo = X_eje_balanceo - offset_eje - dee + an17/2 + cue_w_merma + sobresale_cuerno_dcho ;
	
	rcs = 6 ; // redondeo entre el cuerpo y el soporte del eje y el motor
	vnt_w = 9 ; // ancho de la ventana por donde asoma el filamento y entra el detector de movimiento
	vnt_h = 12 ; // alto de esa misma ventana
	vnt_b = 4 ; // base mínima bajo la ventana
	vnt_d = 4.5 ; // desplazamiento del lateral de la ventana respecto al eje del agujero del filamento
	rehuefi = 2 ; // redondeo del hueco para ver el filamento
	pizd_h = 4 ; // altura de la playa izquierda, donde va el muelle (hay algo mal, y sólo funciona para valores entre 2 y 5.8)
	rcabtornillo = 7.4/2 ; // radio de la cabeza del tornillo de presión de filamento
	htornillo = cue_alto-4.5 ; // altura del tornillo de presión
	hcabtornillo = 3 ; // altura de la cabeza del tornillo de presión de filamento
	rtornillo = 2 ;  // radio del tornillo de presión de filamento
	h_sopo_rod_ext=10 - gapplasop ;
	h_sopo_rod_int=10.5 - gapplasop ;
	dx_al_borde_agujero_detector = 9 ;
	dy_entrada_filamento = agj(2)*2 ;

	holgura_ec = .2 ; // es para colocar la elipse que da forma al lado izquierdo del cuerpo

	li_ancho=12.2 ;
	li_alto=pizd_h - .3 ; // quiero que el sistema de presión no apoye sobre el anclaje, sino que descargue íntergramente sobre el cuerpo
	li_largo=sobresale_cuerno_izq + li_ancho/2 ;
	li_holgura=.4 ;
	
	vertical_filamento_dy = agj(2) ;
	vertical_filamento_dx = 1.2 * vertical_filamento_dy ;
	
	function posicion_tornillo(lado) = sign(lado)*6.5 ;
	
	module vertical_filamento(completo=false) { 
		intersection() {
			translate([0,0,cue_alto/2]) scale([1,vertical_filamento_dy/vertical_filamento_dx,1]) cylinder(r=vertical_filamento_dx, cue_alto+ucm, center=true, $fn=fn(vertical_filamento_dx)); 
			if (completo)
				translate([0,0,50-ucm])
					cylinder(r1=agj(3.4/2), r2=8, 100, center=true, $fn=fn(4));
		}
	}
	
	module tornillo_presion_filamento(lado, masancho=false) {
	// los soportes verticales tienden a dejar la capa de arriba 1 fila descolgada, así que hago el agujero y el soporte
	// 1 capa más alto (añadiendo medio gapplasop al radio) y luego subo el conjunto gapplasop/2
	// en otros agujeros no se nota el efecto o se arregla con un lijadito, pero en este caso prefiero agrandar
	translate([cue_w-offset_eje-30/2-hcabtornillo,posicion_tornillo(lado)+gapplasop/2,htornillo])
		rotate([0,90,0])  
			union() {
				scale([1,(rcabtornillo+gapplasop*(masancho ? 2 : 1)/2)/rcabtornillo,1])				
					translate([0,0,30/2+(hcabtornillo-cue_w_merma)/2]) 
						difference() { // un recorte del agujero que obliga a tallar el tornillo y así no podrá girar
							cylinder(r=rcabtornillo, h=hcabtornillo-cue_w_merma+ucm, $fn=fn(rcabtornillo), center=true);
							translate([1.2-2*rcabtornillo,0,0])
								cube([rcabtornillo*2, rcabtornillo*2, hcabtornillo+ucm], center=true);
						}
				scale([1,(rtornillo+gapplasop*(masancho ? 2 : 1)/2)/rtornillo,1]) {
					cylinder(r=rtornillo, h=30+ucm, $fn=fn(rtornillo), center=true);
					ancho = cue_alto-htornillo+1 ;
					translate([-ancho/2,0,-10]) 
						cube([ancho, 2*rtornillo, 20], center=true);
				}
			} 
	}
	
	module soporte_tornillo_presion_filamento(lado, masancho=false) {
		largo_tor=29.85 ;
		
		module recorte_longitudinal(signo) { 
			translate([signo*(2*rtornillo-.5*rtornillo),0,-ucm/2]) cube([2*rtornillo, 2*rtornillo, largo_tor+ucm], center=true); 
		}
		
		module recorte_cabeza(signo) {
			translate([signo*(2*rcabtornillo-.45*rcabtornillo),0,0]) cube([2*rcabtornillo, 2*rcabtornillo, hcabtornillo], center=true);
		}
		
		// ver comentarios sobre el tamaño del agujero en el module tornillo_presion_filamento()
		translate([cue_w-offset_eje-largo_tor/2-hcabtornillo-cue_w_merma/2,posicion_tornillo(lado)+gapplasop/2,htornillo])
			rotate([0,90,0])  
				union() {
					translate([0,0,largo_tor/2+hcabtornillo/2]) difference() {
						scale([1,rcabtornillo/(rcabtornillo-gapplasop*(masancho ? 2 : 1)/2),1]) 
							cylinder(r=rcabtornillo-gapplasop, h=hcabtornillo-cue_w_merma-sephsop+ucm, $fn=fn(rcabtornillo), center=true);
						recorte_cabeza(1);
						recorte_cabeza(-1);
					}
					translate([0,0,sephsop]) difference() {
						scale([1,rtornillo/(rtornillo-gapplasop*(masancho ? 2 : 1)/2),1]) 
							cylinder(r=rtornillo-gapplasop, h=largo_tor+ucm, $fn=fn(rtornillo), center=true);
						recorte_longitudinal(1);
						recorte_longitudinal(-1);
					}
					translate([-3*rtornillo/2,0,-6.8]) cube([3*rtornillo, 2*(rtornillo-gapplasop)+gapplasop*(masancho ? 2 : 1), largo_tor/2], center=true);
				} 
	}
		
	module redondeo(r) {
		 scale([1,1,2]) difference() {
			translate([0,0,3*r/2]) cube([3*r+ucm,cue_fondo+ucm,3*r+ucm], center=true);
			translate([0,0,-r/2]) rotate([90,0,0]) cylinder(r=r, h=cue_fondo+ucm, center=true,$fn=fn(r)*4);
		}
	}

	module redondeo_rotacion() {
		translate([X_eje_balanceo,0,ser_h/2]) 
			rotate([90,0,0]) 
				scale([2+0*1.42,1,1]) 
					difference() { 
						ajuste = 1.1 ;
						translate([ser_h/4, -ser_h/4-ajuste/2, 0]) 
							cube([ser_h/2+ucm,ser_h/2+ucm-ajuste,cue_fondo+ucm], center=true); 
						cylinder(d=ser_h,h=cue_fondo+ucm+ucm, center=true, $fn=fn(ser_h/2*1.4));
					}
	}		

	module recorte_soporte_rodamiento() {
		cylinder(r=agj(4-.1), h=cue_fondo+ucm, $fn=fn(8/2), center=true);					
		translate([15.39, -7.98, 0]) cylinder(r=13.3, h=cue_fondo+ucm, center=true, $fn=fn(13.3));
		translate([10.015, 4.63, 0]) cylinder(r=7, h=cue_fondo+ucm, center=true, $fn=fn(13.3));
		translate([5, 0, 0]) cube([10,6,cue_fondo+ucm], center=true);
	}

	module agujeros_motor(poner_arandelas=false) {
		ajuste = .2 ; // este ajuste corrige la posición del motor, y eso afecta al funcionamiento de los engranajes, así que mejor no lo toco porque van bien
		translate([dee - ajuste, som_l/2-cue_fondo/2,0])
			rotate([90,0,0]) // taladros para los tornillos del motor
				for (v = [[-1, 1], [-1, -1], [1,-1]] ) 
					if (poner_arandelas)
						translate([dam*v[0], dam*v[1], -(som_l+asm-ucm)/2])
							cilindro(rasm, asm+ucm);
					else	
						translate([dam*v[0], dam*v[1], 0]) {
							cilindro(afm, som_l+asm*2+ucm);
							translate([0,0,(som_l+ucm-afme)/2]) cylinder(r1=0, r2=afme+ucm, h=afme+ucm, center=true, $fn=fn(afme));
						}
	}
	
/*##################################################################################################
#################################   ################  ##############################################
##################################  ################################################################
#########    ###     ####    #####  #####    #######  ###    ####     ##############################
############  ##  ##  ##  ##  ####  ########  ######  ##  ##  ##  ##################################
#########     ##  ##  ##  ########  #####     ######  ##      ###    ###############################
########  ##  ##  ##  ##  ##  ####  ####  ##  ##  ##  ##  ##########  ##############################
#########   #  #  ##  ###    ####    ####   #  #  ##  ###    ###     ###############################
#################################################    ###############################################
##################################################################################################*/
	
	module lengua_izquierda() {
		union() {
			cylinder(r=li_ancho/2, h=li_alto, center=true, $fn=fn(li_ancho/2));
			translate([-(li_largo-li_ancho/2)/2,0,0]) cube([li_largo-li_ancho/2, li_ancho, li_alto], center=true);
		}
	}	
	
	module anclaje(pieza=cue_ancla_i) {
		redondeo = 1 ;
		

		module agujeros_i() {
			cylinder(r=agj(4/2), h=20, center=true, $fn=fn(4/2));
		}
		

		if (pieza == cue_ancla) {
			difference() {
				union() {
					if (alto_zapatilla>0) {
						difference() {
							izquierda = defc/2+sobresale_cuerno_izq ;
							derecha = X_eje_balanceo ; // el cálculo de derecha no es fino, pero da igual porque hay que añadir más suela
							translate([derecha/2-izquierda/2,0,alto_zapatilla/2])
								cubor([izquierda+derecha, cue_fondo, alto_zapatilla], esquinas=12);
							translate([-defc/2,0,alto_zapatilla+holgura_zapatilla])
								agujeros_i();
							cylinder(r=3, h=10, center=true, $fn=fn(3));
							}				

						translate([defc/2+adlbl-adwse,0,alto_zapatilla/2])
							difference() {
								dx = adwse+adhxc+redondeo+ucm ;
								translate([dx/2-redondeo,0,0])
									cube([dx+ucm,ancho_anclaje-adgo/2,alto_zapatilla], center=true);
								for (lado = [-1, 1])
									translate([-redondeo, sign(lado)*(cue_fondo/2+redondeo), 0]) {
										cylinder(r=redondeo, h=alto_zapatilla+ucm, center=true, $fn=fn(redondeo));
										cubito = 5 ;
										translate([redondeo-cubito/2,sign(lado)*cubito/2,0])
											cube(cubito, center=true);
									}
							}
					} else if (hacer_soportes) {
						union() {
							alto = pizd_h-1 ;
							ancho = 2 ;
							separa = 1 ;
							hull() 
								for (lado=[-1,1])
									translate([-defc/2 - 4, lado * (li_ancho/2+ancho/2+separa), (alto-1)/2+1])
										cilindro(ancho/2, h=alto-1);
							for (lado=[-1,1]) {
								hull() {
									translate([-defc/2 - 4, lado * (li_ancho/2+ancho/2+separa), alto/2])
										cilindro(ancho/2, h=alto);
									translate([defc/2 - 1, lado * (ancho_anclaje+cue_fondo)/4, alto/2])
										cilindro(ancho/2, h=alto);
								}
								translate([defc/2 - 1+3/2,lado * (ancho_anclaje+cue_fondo)/4,(alto-1)/2+1])
									cube([3, ancho, alto - 1], center=true);
							}
						}
					}
					afeita(afeitado * fabricar) {
						translate([defc/2, 0, alto_zapatilla+holgura_zapatilla]) 
							anclaje(cue_ancla_d);				
						translate([-defc/2, 0, alto_zapatilla+holgura_zapatilla])
							anclaje(cue_ancla_i);
					}
				}
				if (alto_zapatilla>0) 
					translate([defc/2, 0, 0]) 
						cilindro(agj(4/2), 20); // agujero para el tornillo M4 del anclaje derecho (más vale que zozobre)
			}
				
		} else if (pieza==cue_ancla_d) { // el anclaje derecho
		
			anclaje_dcha();
			
		} else if (pieza==cue_ancla_i) { // el anclaje izquierdo propiamente dicho
			arandela_h = 1.7 ;
			translate([0,0,li_alto/2]) 
				difference() {
					union() {
						cuello_h = corte_a_capa(pizd_h+arandela_h-li_alto-.3) ;
						cuello_r = 4 ;
						translate([0,0,-(alto_zapatilla+holgura_zapatilla)/2])
							cylinder(r=li_ancho/2, h=li_alto+(alto_zapatilla+holgura_zapatilla), center=true, $fn=fn(li_ancho/2));
						translate([0,0,(li_alto+cuello_h-ucm)/2])
							cylinder(r=cuello_r, h=cuello_h+ucm, center=true, $fn=fn(4));
						translate([-sobresale_cuerno_izq/2,0,-(alto_zapatilla+holgura_zapatilla)/2]) 						
							cubor([sobresale_cuerno_izq, li_ancho, li_alto+alto_zapatilla+(holgura_zapatilla)], esquinas=12);
					}
					translate([0,0,-li_alto/2]) 
						agujeros_i();
				}
*%			translate([0,0,li_alto+arandela_h/2]) 
				difference() {
					cylinder(r=17.7/2, h=arandela_h, center=true, $fn=fn(17.7/2));
					cylinder(r=8.5/2, h=arandela_h+ucm, center=true, $fn=fn(8.5/2));
				}
		}
	}

/*##################################################################################################
###########################   ############# ########################################################
############################  ############  ########################################################
#########    ###     #######  ###     ###     ###    ###  #   ######################################
########  ##  ##  ##  ###     ##  ########  ####  ##  ###  ##  #####################################
########      ##  ##  ##  ##  ###    #####  ####  ##  ###  ##  #####################################
########  ######  ##  ##  ##  ######  ####  # ##  ##  ###     ######################################
#########    ###  ##  ###   #  #     ######  ####    ####  #########################################
########################################################    ########################################
##################################################################################################*/


	module incision_antigiro() {
		translate([5.6/2 - ucm, 0,0])
			rotate([0,90,0]) 
				rotate([0,0,30]) 
					cylinder(d=1, h=dx_al_borde_agujero_detector+ucm, $fn=6);
	}
	

	module rosca_detector_filamento(a) {
		// hueco para embutir una rosca en la que atornillar el detector de filamento
		if (preparar_rosca_para_detector) 
			translate([offset_eje+dee-an17/2-cue_w_merma+holgura_ec-dx_al_borde_agujero_detector,0,cue_alto]) {
				mirror([0,0,1])
					rosca_embutir(profundidad=7, soportada=hacer_soportes);
				incision_antigiro();
			}
			
	}
	
	
	module detector(que) {
		TCST = [12, 6.3, 11];
		TCST_escote_dx = 3 ;
		TCST_escote_dz = TCST[2] - 3.1 ;
		TCST_optica_z = TCST[2] - 2.6 ;

		module tcst_silueta(plus = [0,0,0]) {
			difference() {
				translate([0,0,TCST[2]/2]) cube(TCST + 2*plus, center=true);
				translate([-TCST[0]/2-plus[0],0,TCST[2]-1.2])
					rotate([0,-45,0]) {
						mucho=TCST[1] + 2*plus[1] + ucm;
						translate([mucho/2,0,mucho/2])
							cube(mucho, center=true);
					}
			}
		}
		
		module tcst() {
			rajita = [4.4, 1, 3.5] ;
			difference() {
				tcst_silueta();
				translate([0,0,3*TCST[2]/2-TCST_escote_dz]) cube([TCST_escote_dx, TCST[1]+ucm, TCST[2]], center=true);
				translate([0,0,TCST[2]-(rajita[2]-ucm)/2]) cube(rajita+[0,0,ucm], center=true);
			}	
			for (lx = [-1,1])
				for (ly = [-1, 1])				
					translate([lx * 7.6/2, ly * 2.54/2, -7.8/2])
						cube([.4, .45, 7.8], center=true);
			color([1,0,0,.3])
				translate([0,0,TCST_optica_z])
					rotate([0,90,0])
						cylinder(r=rajita[1]/2-2_manifold, h=rajita[0], center=true, $fn=8);
		}
		
		/* planteamiento mirando a mAka de frente
			- plataforma rectangular con origen en la esquina posterior derecha del bloque central del extrusor
			- la plataforma tendrá agujero para atornillarla al bloque, entre la entrada de filamento y el motor
			- en el lado trasero habrá una cajita con una apertura trasera por donde entra el TCST
			- a los lados de la plataforma habrá un soporte para un eje de .6mm paralelo a X por encima de la cajita
		*/

		detector_xi = offset_eje+dee-an17/2-cue_w_merma+holgura_ec;
		esquina_referencia = [detector_xi,cue_fondo/2,0] ;
		tabique = 2 ;
		techo = 1 ;
		holgura = .25 ;
		
		plataforma = [23, cue_fondo/2 + 4, 2];
		cajita = [TCST[0]+2*(holgura + tabique), TCST[2], TCST[1]+2*holgura + techo];
		holgura_filamento = .5 ;
		alto_detector = plataforma[2] + cajita[2];
		
		cabeza_diametro = correccion( 5.5  +  .3 );
		cabeza_alto = cabeza_diametro/2 ;
		
		eje_zr = 2 ;
		eje_yr = 1.5 ;
		eje_radio = correccion(.6  +  .2) / 2 ;
		soporte_eje_dx = 2 ;
		soporte_eje_dy = cajita[1] + .8 ;
		soporte_eje_dz = 3 ;
		soporte_eje_cil_corte_dz = 6 ;
		soporte_eje_cil_corte_dy = cajita[1]-2.5 ;
		
		balancin_gap_z = .5 ;
		balancin_gap_y = .4 ;
		balancin_gap_x = .3 ;
		balancin_envoltura_eje = 1 ;
		balancin_dx = plataforma[0] - 2*(soporte_eje_dx + balancin_gap_x) ;
		balancin_dy = 1 ;
		balancin_dz_i = alto_detector - plataforma[2] - balancin_gap_z ;
		balancin_dz = balancin_dz_i + eje_zr + eje_radio + balancin_envoltura_eje ;
		balancin_angulo_obturador = 40 ;
		balancin_angulo_piton = 40 ;

		obturador_dx = 2 ;
		obturador_dz = TCST[1] - 2 * balancin_gap_z ;
		obturador_holgura = .2 ;
		obturador_puente = 1.15 ;
		obturador_piton = 2 ; // donde va el contrapeso

		module hueco(a,b) {
			mucho=2*a+ucm;
			difference() {
				scale([(b-plataforma[2])/(a-plataforma[2]),1,1])
					cylinder(r=a-plataforma[2], h=plataforma[1]+ucm*3, center=true, $fn=fn(a));
				translate([0,mucho/2-techo,0])
					cube(mucho, center=true);
				translate([mucho/2,0,0])
					cube(mucho, center=true);
			}
		}

		
		if (! (fabricar+hacer_soportes) )
			translate(esquina_referencia+[-cajita[0]/2,0,cue_alto+plataforma[2]+(cajita[2]-techo)/2])
				rotate([90,0,0])
					%tcst();
					
		if (que == cue_detector_balancin) 
			// balancin
			translate(fabricar?[-45,-70,0]:(esquina_referencia+[(soporte_eje_dx + balancin_gap_x)-plataforma[0],-(cajita[1]+balancin_dy+ balancin_gap_y),cue_alto + plataforma[2] + balancin_gap_z])) 
				rotate(fabricar?[90,0,0]:[0,0,0]) 
					difference() {
						union() {
							translate([0,0,0]) {
								cube([balancin_dx, balancin_dy, balancin_dz]);
								dz = 2*(eje_radio + balancin_envoltura_eje) ;
								dy = balancin_gap_y + eje_yr + eje_radio ;
								// estructura que envuelve el eje
								difference()  {
									translate([0,balancin_dy-ucm,balancin_dz-dz]) 
										cube([balancin_dx, dy + ucm , dz]);
									translate([-ucm/2,balancin_dy+dy-eje_radio*2,balancin_dz-dz/2-eje_radio]) 
										cube([balancin_dx + ucm, eje_radio * 4, eje_radio * 2]);
									}
							}
							difference() {
								translate([0,balancin_dy/2,0])
								scale([1,1,balancin_dz_i/(soporte_eje_dx + balancin_gap_x)])
									rotate([90,0,0])
										cylinder(r=(soporte_eje_dx + balancin_gap_x), h=balancin_dy, center=true, $fn=fn(balancin_dz_i));
								translate([0, balancin_dy/2,-balancin_dz_i/2])
									cube([2*(soporte_eje_dx + balancin_gap_x) + ucm, balancin_dy+ucm, balancin_dz_i], center=true);
							}						
						}
						// forma para que encaje el obturador con contrapeso
						translate([plataforma[0]-(soporte_eje_dx + balancin_gap_x)-cajita[0]/2, (balancin_dy+ucm/2)/2, obturador_dz/2])
							cube([obturador_dx + obturador_holgura, balancin_dy + ucm, obturador_dz + obturador_holgura], center=true);
						translate([plataforma[0]-(soporte_eje_dx + balancin_gap_x)-cajita[0]/2, 0, balancin_dz-2_manifold])
							cube([obturador_dx + obturador_holgura, cajita[1], balancin_envoltura_eje*2], center=true);
					}
					
		if (que == cue_detector_obturador)
			// obturador con pitón
			translate(fabricar?[-55,-75,obturador_dx/2]:(esquina_referencia+[-cajita[0]/2, eje_yr - cajita[1],cue_alto+alto_detector+eje_zr])) 
				rotate(fabricar?[0,90,0]:[0,0,0]) 
					union() {
						raio = alto_detector + eje_zr - plataforma[2] - balancin_gap_z ;
						difference() {
							rotate([0,90,0])
								cylinder(r=raio, h=obturador_dx, center=true, $fn=fn(raio));
							rotate([0,90,0])
								cylinder(r=raio-(TCST[1]-2*balancin_gap_z), h=obturador_dx+ucm, center=true, $fn=fn(raio));
							// corte del cilindro en la vertical del eje de rotación
							translate([0,-raio,0])
								cube([obturador_dx+ucm,raio*2,2*(raio+ucm)], center=true);
							// evitar que llegue a tocar con el fondo del TCST (si el obturador entra con ángulo >40 tocaría)
							translate([0,raio/2-eje_yr+TCST_escote_dz-balancin_gap_y,-raio/2])
								cube([obturador_dx+ucm,raio,raio], center=true);
							// evitar que toque con el techo de la cajita
							alto = (alto_detector + eje_zr - plataforma[2]) * 2 ;
							translate([0,0,cajita[2]-techo-balancin_gap_z])
								cube([obturador_dx+ucm,2*raio,alto], center=true);
							// corte del ángulo de giro que me interesa conservar
							rotate([balancin_angulo_obturador,0,0])
								translate([0,raio/2,-(raio+ucm)/2])
									cube([obturador_dx+ucm,raio,raio+ucm], center=true);
							}
						// union del arco de obturación con el puente que va hacia el pitón del contrapeso
						{	dy = balancin_dy + balancin_gap_y + eje_yr + obturador_puente;
							translate([0,-(dy-ucm/10)/2,balancin_gap_z-alto_detector-eje_zr+plataforma[2]+obturador_dz/2])
								cube([obturador_dx, dy+ucm/10, obturador_dz], center=true);
						}
						// puente entre el obturador y el pitón del contrapes
						{	dz = raio + obturador_piton + eje_radio + obturador_holgura ;
							translate([0,-(eje_yr+balancin_gap_y+balancin_dy+obturador_puente/2),dz/2-raio])
								cube([obturador_dx, obturador_puente, dz], center=true);
						}
						// pitón para el contrapeso
						{	dy = obturador_puente + balancin_dy + balancin_gap_y + eje_yr + eje_radio;
							translate([0,eje_radio-dy/2,obturador_piton/2+eje_radio + obturador_holgura])
								cube([obturador_dx, dy, obturador_piton], center=true);
						}
						{	dy = cajita[1] - eje_yr - eje_radio + 2 ;
							translate([0,eje_radio,eje_radio + obturador_holgura])
								rotate([balancin_angulo_piton,0,0])
									translate([0,dy/2,obturador_piton/2])
										cube([obturador_dx, dy, obturador_piton], center=true);
							}
					}

		if (que == cue_detector_cuerpo)
			translate(fabricar?[-20,-80,0]:[0,0,cue_alto]) 
				translate(esquina_referencia) {
					difference() {
						union() {
							translate([-plataforma[0], -plataforma[1], 0])
								cube(plataforma);
							translate([-plataforma[0],-cajita[1],plataforma[2]])
								cube([plataforma[0]-cajita[0]+ucm, cajita[1], cajita[2]]);
							for (lado=[-1,1]) {
								translate([(lado*(plataforma[0]-soporte_eje_dx)-plataforma[0])/2, -soporte_eje_dy/2, alto_detector+(soporte_eje_dz-techo-ucm)/2])
									difference() {								
										cube([soporte_eje_dx, soporte_eje_dy, soporte_eje_dz+techo+ucm], center=true);
										translate([-soporte_eje_dz/2,soporte_eje_dy/2-cajita[1],-(soporte_eje_dz+techo)/2]) 
											rotate([130,0,0]) 
												translate([0,-1,0])
													cube(soporte_eje_dz);
									}
							}

						}
						{ // quitar un filete elíptico (lo de abajo queda como soporte)
							a = alto_detector;
							b = plataforma[0] - esquina_referencia[0] + (vertical_filamento_dx + holgura_filamento);
							mucho=a*2+ucm;				
							
							translate([(vertical_filamento_dx + holgura_filamento)-esquina_referencia[0], -plataforma[1]/2, esquina_referencia[2]+a])
								rotate([90,0,0])
									difference() {
										union(){								
											mucho=plataforma[1]+ucm;
											scale([(b+gapplasop)/(a+gapplasop),1,1])
												cylinder(r=a+gapplasop + (hacer_soportes ? 0 : mucho), h=plataforma[1]+ucm, center=true, $fn=fn(a));
											// acotar el soporte de la parte baja del voladizo izquierdo
											if (hacer_soportes)
												translate([-sqrt(1/pow((a*tan(utilidades($angulo_voladizo)))/pow(b,2),2)+1/pow(b,2))-mucho/2, -mucho/2, 0]) 
													cube(mucho, center=true);
											}
										difference() {										
											scale([b/a,1,1])
												cylinder(r=a, h=plataforma[1]+ucm*2, center=true, $fn=fn(a));
												
											difference() {											
												dx_soporte=hacer_soportes ? (2/tabique) : 0 ;
												hueco(a,b);
												intersection() {
													translate([(dx_soporte-b)/2,(-cajita[2]-techo)/2,(cajita[1]-plataforma[1])/2])
														cube([dx_soporte, a-plataforma[2]-techo-2*gapplasop, cajita[1]+ucm], center=true);
													hueco(a-.3, b-.3);
												}
											}
										}
										translate([mucho/2,0,0]) cube(mucho, center=true);
										translate([0,mucho/2,0]) cube(mucho, center=true);
									}
						}
						// alojamiento del tornillo de cabeza cónica
						translate([-dx_al_borde_agujero_detector, -cue_fondo/2, -ucm/2]) {
							cylinder(r=agj(3/2), h=plataforma[2]+ucm, $fn=fn(agj(3/2)));
							incision_antigiro();
						}
						{ 	raio = correccion(cabeza_diametro  +  .5) / 2 + ucm;
							translate([-dx_al_borde_agujero_detector, -cue_fondo/2, plataforma[2] - (raio - ucm)/2]) 
								cylinder(r1=correccion(0  +  .2), r2=raio, h=raio, center=true, $fn=fn(raio));
						}
						// corte alrededor de la entrada de filamento
						translate(-esquina_referencia) {
							agrandamiento_x = (vertical_filamento_dx + holgura_filamento) / vertical_filamento_dx;
							agrandamiento_y = (cue_fondo/2 - cajita[1]) / vertical_filamento_dy;
							mucho = vertical_filamento_dx * 4 ;
							scale([agrandamiento_x, agrandamiento_y, 1])
								vertical_filamento();
							translate([vertical_filamento_dx*agrandamiento_x - mucho/2,-mucho/2,plataforma[2]/2])
								cube([mucho, mucho, plataforma[2]+ucm], center=true);
							translate([-mucho/2,vertical_filamento_dy*agrandamiento_y - mucho/2,plataforma[2]/2])
								cube([mucho, mucho, plataforma[2]+ucm], center=true);
						}
						// remate en glacis del soporte del eje
						translate([-plataforma[0]/2, 0, alto_detector+soporte_eje_cil_corte_dz])
							rotate([0,90,0])
								scale([soporte_eje_cil_corte_dz/soporte_eje_cil_corte_dy,1,1])
									cylinder(r=soporte_eje_cil_corte_dy, h=plataforma[0]+ucm, center=true, $fn=fn(soporte_eje_cil_corte_dy));
						// rajita para el eje
						translate([-plataforma[0]/2,eje_yr-cajita[1], alto_detector+soporte_eje_dz])
							cube([plataforma[0]+ucm, correccion(eje_radio*2  +  .5), (soporte_eje_dz-eje_zr+eje_radio) * 2], center=true);
					}
					translate([-cajita[0]/2,-cajita[1]/2,alto_detector - (cajita[2]+ucm)/2]) {
						difference() {
							cube(cajita+[0,0,ucm], center=true);
							translate([0,TCST[2]-cajita[1]/2,-techo/2-ucm])
								rotate([90,0,0])
									tcst_silueta([holgura, holgura+ucm, holgura]);
						}
						if (hacer_soportes)
							translate([0,TCST[2]-cajita[1]/2,-techo/2]) {
								intersection() {
									rotate([90,0,0])
										tcst_silueta([holgura-sephsop, holgura-gapplasop, 0]);
									translate([0,-TCST[2]/2,0])
										mirror([0,1,0])
											soporte_paralelo([TCST[0], TCST[2], TCST[1]]+2*[holgura-sephsop, 0, holgura-gapplasop]);
								}
							}
					}
				}
	}
	

	module redondeo_inf_izdo_rodatos() {
		translate([-2.19, 0, 17.78])  // CHAPUZA DESCOMUNAL, PERO HACERLO BIEN SUPONE UNA ECUACIÓN QUE NO ME APETECE ABORDAR
			rotate([0,-25,0])
				difference() {
					translate([0, 0, 2.2]) cube([1, cue_fondo+ucm, 4], center=true); 
					rotate([90,0,0]) cylinder(r=.5, h=cue_fondo+ucm, center=true, $fn=20); 		
				}
	}
	
/*##################################################################################################
##################################################################  ################################
####################################################################################################
#########    ####    ####    ####    ####     ###    ###  #   ###   #####    ####     ##############
############  ##  ##  ##  ##  ##  ##  ##  ######  ##  ###   #  ###  ####  ##  ##  ##################
#########     ##  ######  ######      ###    ###  ##  ###  ##  ###  ####  ##  ###    ###############
########  ##  ##  ##  ##  ##  ##  ##########  ##  ##  ###  #######  ####  ##  ######  ##############
#########   #  ##    ####    ####    ###     ####    ###    #####    ####    ###     ###############
####################################################################################################
##################################################################################################*/
	
	
	holgura_fulcro = .2 ;
	pfulcro = [offset_eje  +  dee-an17/2+ holgura_ec -cue_w  -  3.73 ,0,  ser_l+2.91];
	prodato = [offset_eje - 22/2 - (8-1)/2  -  3  + .2,0,drg/2 + hvrg];


	if (elemento==cue_detector_cuerpo || elemento==cue_detector_balancin || elemento==cue_detector_obturador) { // detector de filamento
		detector(elemento);
		
		
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	} else if (elemento==cue_ancla_i) { // anclaje izquierdo
		translate([-defc/2, 0, li_alto/2]) 
			anclaje(cue_ancla_i);
			
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	} else if (elemento==cue_ancla_d) { // anclaje derecho
		 translate([defc/2,0,0])
			anclaje(cue_ancla_d);
			
	//////////////////////////////////////////////////////////////////////////////////////////////////////////

	} else if (elemento==cue_ancla) { // anclaje completo
		anclaje(cue_ancla);
			
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	} else if (elemento==cue_presor) { // inicio del presor
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
/*##################################################################################################
####################################################################################################
####################################################################################################
########  #   ##  #   ###    ####     ###    ###  #   ##############################################
#########  ##  ##   #  #  ##  ##  ######  ##  ###   #  #############################################
#########  ##  ##  ##  #      ###    ###  ##  ###  ##  #############################################
#########     ###  #####  ##########  ##  ##  ###  #################################################
#########  #####    #####    ###     ####    ###    ################################################
########    ########################################################################################		
##################################################################################################*/
	*	color("grey") { // guías para orientarme
			translate([offset_eje,0,drg/2 + hvrg]) rotate([90,0,0])	cylinder(d=8, h=cue_fondo, center=true, $fn=fn(8/2));
			translate([offset_eje-7/2-3/2,0,drg/2]) cylinder(d=3, h=100, center=true, $fn=fn(3/2)); 
		}

		
		ancho_hueco = 8 ;
		difference() {
			// principal
			union() {	
				translate(pfulcro) {
					// fulcro
					union() {				
						rotate([90,64,0])
							scale([5.2/7.9, 1, 1])
								cylinder(r=7.9/2-holgura_fulcro, h=cue_fondo, $fn=fn(7.9/2 * 2), center=true);	

						// añadir una curva de acuerdo convexa
						translate([1.05, 0, .82]) rotate([90,0,0]) 
							difference() {
								cylinder(r=2.5, h=cue_fondo, center=true, $fn=fn(2.5));
								translate([0,-6/2,0]) cube([6,6,cue_fondo+ucm], center=true); 
							}
					}
				}
				translate(prodato) 
					difference() {
						union(){	
							rotate([90,0,0]) cylinder(d=26, h=cue_fondo, center=true, $fn=fn(22/2));
							translate([3.5,0,-8.35]) cube([6, cue_fondo, 22],center=true);
							translate([-10,-cue_fondo/2,-17.54]) cube([12, cue_fondo, 7.4]);
							translate([6, 0, 10.7]) cube([8, cue_fondo, 4], center=true);
						}	
						rotate([90,0,0]) translate([0,0,-(cue_fondo+ucm)/2]) linear_extrude(height=cue_fondo+ucm) polygon([[-10.7,-8], [-10,-18], [.765,-17.54]]);
						
						translate(pfulcro-prodato+[-3.7, -0.0, 1.6]+[.015,0,.25])
							rotate([90,0,0]) cylinder(r=1.3, h=cue_fondo+ucm, center=true, $fn=fn(2));
						translate([15.39, 0, -7.98]) rotate([90,0,0]) cylinder(r=13.3, h=cue_fondo+ucm, center=true, $fn=fn(13.3));
						translate([10.015, 0, 4.63]) rotate([90,0,0]) cylinder(r=7, h=cue_fondo+ucm, center=true, $fn=fn(13.3));
						translate([5, 0, 0]) cube([10,cue_fondo+ucm,4], center=true);
						translate([2.99,0,2.92]) rotate([0,150,0]) redondeo(.3);
						translate([2.72,0,-3.17]) rotate([0,35,0]) redondeo(.3);
					}

				difference() {
					union () {
						intersection() {
							translate([-(offset_eje + dee - an17 / 2 + holgura_ec - (1-puovi)*cue_w) - .2 * 2, 0,  cue_alto -cue_w * povi]) scale([puovi,1,povi]) rotate([90, 0, 0]) cilindro(cue_w, cue_fondo+ucm);
							translate([-12+10.25/2,0,cue_alto-8.08/2]) cube([10.25, cue_fondo, 8.08], center=true);
						}
						translate([-12-1/2+ucm/2,0,cue_alto-8.08/2-1/2]) cube([1+ucm, cue_fondo, 8.08-1], center=true);
						translate([-2.6, 0, cue_alto-8.08]) rotate([90, 0, 0]) cylinder(r=1, h=cue_fondo, center=true, $fn=fn(1));
						translate([-12, 0, cue_alto-1]) rotate([90, 0, 0]) cylinder(r=1, h=cue_fondo, center=true, $fn=fn(1));
						difference() {
							translate([-14+1,0,cue_alto-6.8-1]) cube([2, cue_fondo, 2], center=true);
							translate([-14, 0, cue_alto-6.8]) rotate([90, 0, 0]) cylinder(r=1, h=cue_fondo*2, center=true, $fn=fn(1));
						}			
					}
					translate([0,0,-.5]) { // dar una ligera hogura en el hueco del tornillo, que visto en mano parece que la necesita
						tornillo_presion_filamento(-1, masancho=true);
						tornillo_presion_filamento( 1, masancho=true);
					}					
				}

				// soporte de los agujeros de los tornillos
				if (hacer_soportes)
					intersection() {
						difference() {
							translate([0,0,-.5])
								union() {
									soporte_tornillo_presion_filamento(-1, masancho=true);
									soporte_tornillo_presion_filamento( 1, masancho=true);
								}
							difference() {
								translate([-13,0,cue_alto]) cube([2,cue_fondo+ucm,2], center=true);
								translate([-12, 0, cue_alto-1]) rotate([90, 0, 0]) cylinder(r=1, h=cue_fondo, center=true, $fn=fn(1));						
							}
						}
						translate([-(offset_eje + dee - an17 / 2 + .2 - (1-puovi)*cue_w) - .2 * 2, 0,  cue_alto -cue_w * povi]) scale([puovi,1,povi]) rotate([90, 0, 0]) cilindro(cue_w, cue_fondo+ucm);
					}				
			}

			translate([-1,0,0]) vertical_filamento();

			translate(prodato)
				rotate([90,0,0]) {
					difference() {
						scale([1.06,1.06,1]) cylinder(d=22, h=ancho_hueco, center=true, $fn=fn(22/2));
						// apoyo para el aro interior del rodamiento (sólo hago el apoyo en un lado, en el otro ya pondré arandela)
						translate([0,0,ancho_hueco/2-.4/2]) cylinder(r=7, h=.4+ucm, center=true, $fn=fn(7/2));
					}
					cylinder(r=agj(7.8/2), h=cue_fondo+ucm, $fn=fn(7.8/2), center=true);
				}
		}
			
			// soporte del hueco del rodamiento
		if (hacer_soportes)
			translate(prodato)
				rotate([90,0,0])
					difference() {
						union() {
							intersection() {
								difference() {
									cylinder(r=22 / 2 * 1.06 - sephsop*2, h=ancho_hueco-gapplasop*2, center=true);
									scale([1,1,1.1]) recorte_soporte_rodamiento(); 
									cylinder(r=4.8, h=cue_fondo+ucm, $fn=fn(8/2), center=true);
								}
								translate([-.6,0,0])recorte_soporte_rodamiento();	
							}

							difference() {
								mirror([0,0,1])							
									soporte_circular(r=22 / 2 * 1.06 - sephsop*2, h=ancho_hueco-gapplasop*2, center=true, sombrero=true, hueco=2);
								recorte_soporte_rodamiento();
								// subir el soporte sobre el aro interior del rodamiento
							}
						}
						translate([0,0,ancho_hueco/2-(.4+gapplasop)/2]) cylinder(r=7+sephsop, h=.4+gapplasop, center=true, $fn=fn(ancho_hueco/2));
					}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////
	} else { // aquí empieza la descripción del cuerpo
	//////////////////////////////////////////////////////////////////////////////////////////////////////////

/*##################################################################################################
#################################   ################################################################
##################################  ################################################################
########     ###  ##  ###    #####  #####    ####    ###############################################
########  ##  ##  ##  ##  ##  ####  ####  ##  ##  ##  ##############################################
########  ##  ##  ##  ##  ########  ####      ##  ##  ##############################################
########  ##  ##  ##  ##  ##  ####  ####  ######  ##  ##############################################
########  ##  ###   #  ##    ####    ####    ####    ###############################################
####################################################################################################
##################################################################################################*/


		// voltear hasta la posición de fabricación para afeitar sin tocar el soporte del rodamiento, y devolver a su posición de dibujo
		translate([0,-cue_fondo/2,0]) rotate([-90,0,0]) afeita(afeitado * fabricar) rotate([90,0,0]) translate([0,cue_fondo/2,0])
			difference() {	// sobre el cuerpo del extrusor ya colocado en posición, le quito el hueco del anclaje	
				translate([offset_eje, 0, drg/2 + hvrg]) {  // colocar la base en 0
					difference() {
						// X para que el tornillo (a 14mm del lado X dcho) esté en X=0, con 0.2 de holgura		
						// Z para que el eje sea Z=0 (determinado por el radio de la rueda dentada () */	
						translate([dee - an17 / 2 + holgura_ec - cue_w/2, 0, cue_alto/2 - (drg/2 + hvrg)])	{	
							union() { // unir el cuerpo con los laterales
								intersection() { // esta intersección hace la vertiente curva de la izda de X
								  // cuerpo del extrusor
									// nueva chapuza: todo el extrusor está organizado alrededor del prisma [cue_w,cue_fondo,cue_alto] y
									// ahora he decidido dejar un hueco para que el motor respire, y el caso es que me da pereza
									// revisar el uso de cue_w, así que dejaré cue_w como está, y el prisma lo haré restando cue_w_merma
									translate([-cue_w_merma/2,0,0])							  
										cube([cue_w-cue_w_merma,cue_fondo,cue_alto], center=true);
									translate([cue_w/2-(1-puovi)*cue_w,0,-cue_w*povi+cue_alto/2])  
										scale([puovi,1,povi]) 
											rotate([90, 0, 0]) { // recorte principal del cuerpo
												union() 
												{ 
													cilindro(cue_w, cue_fondo+ucm);
													translate([cue_w/2,0,0]) 
														cube([cue_w+ucm, cue_fondo*2, cue_fondo+ucm], center=true);
													translate([0, -(cue_w+ucm)/2, 0]) 
														cube([cue_w*2+ucm, cue_w+ucm, cue_fondo+ucm], center=true);
												}
											}
								}
								
								// en este momento, el punto [0,0,0] está en el centro del cuerpo, y voy a hacer el lado izquierdo
								// aquí los cilindros tienen doble de precisión en cuanto a facetas; las medidas vienen de blender, están hechas a ojo y son injustificables
								translate([-cue_w/2, -cue_fondo/2,-cue_alto/2]) {
									altura_magica = ser_l+3.41 ;
									raio_tobogan = altura_magica-pizd_h ;
									escala_tobogan = 2.5 ;
									difference() {
										union() {
											// este primer bloque es para formar tobogan_apoyo_tensor al quitarle un cilindro que está más adelante
											translate([-(10.43+raio_tobogan*escala_tobogan+1), 0, 0]) cube([10.43+raio_tobogan*escala_tobogan+1+ucm, cue_fondo, ser_l]);

											// esta es la playa que se extiende desde la caida del soporte del presor hacia la izquierda
											// como es lógico, me defeco en todo por haber tenido que llegar a hacer estas cuentas para posicionarme respecto al agujero del carro
											translate([-offset_eje - dee + an17 / 2 - holgura_ec + cue_w - (defc/2+sobresale_cuerno_izq)/2, cue_fondo/2, pizd_h/2]) 
												rotate([90,0,0]) 
												cubor([defc/2+sobresale_cuerno_izq,pizd_h,cue_fondo],esquinas=12);
															
											translate([-15.813,0,ser_l-ucm]) cube([15.813+ucm, cue_fondo, 3.43+ucm]);
											translate([-8.66,0,ser_l-ucm]) cube([2, cue_fondo, 4.5+ucm]);
											hull() { // apoyo_prensor: tiene 2 cilindros unidos. El izquierdo forma un tobogán hacia la playa izquierda
												translate([-10.43,cue_fondo, altura_magica]) rotate([90,0,0]) cylinder(h=cue_fondo, r=1, $fn=fn(1*2));
												translate([-7.43,cue_fondo, altura_magica + 1.1]) rotate([90,0,0]) cylinder(h=cue_fondo, r=1, $fn=fn(1*2));
											}
										}
										// alojamiento del apoyo inferior de la pieza de presión del filamento
										translate([-3.73,cue_fondo+ucm/2, altura_magica - .5]) rotate([90,64,0]) scale([5.2/7.9, 1, 1]) cylinder(h=cue_fondo+ucm, r=7.9/2, $fn=fn(7.9/2 * 2));	
										// tobogan_apoyo_prensor: su posición y tamaño depende de la posición y tamaño del cilindro izquierdo de apoyo_tensor
										translate([-10.43-raio_tobogan*escala_tobogan-1,cue_fondo+ucm/2, altura_magica]) 
											scale([escala_tobogan,1,1])
												rotate([90,0,0]) 
													cylinder(h=cue_fondo+ucm, r=raio_tobogan, $fn=fn(raio_tobogan*2));
										// abrir hueco para la arandela del anclaje izquierdo, en un ángulo de 45º aplicable sólo en el plano YZ
										raio=9 ; alto=4 ;
										translate([ -defc/2 - offset_eje - dee + an17 / 2 - holgura_ec + cue_w, cue_fondo/2, pizd_h+alto/2 ]) // salvo el 1er sumando de X, todo es para compensar translates; Y también
											hull() {
												translate([0,0,(alto+ucm)/2]) 
													scale([1,(raio+alto)/raio,1]) 
														cylinder(r=raio, h=ucm, center=true, $fn=fn(raio));
												translate([0,0,(ucm-alto)/2])  
													cylinder(r=raio, h=ucm, center=true, $fn=fn(raio));
											}
									}
								}
								
								
								// ahora los soportes para el motor (es mi primera chapucilla, así que no está hecha con finura)
								translate([(cue_w + an17)/2-cue_w_merma, som_l/2-cue_fondo/2, (cue_alto-an17)/2]) rotate([90,0,0]) { // soporte motor ya colocado en su posición
									difference() 
									{ // soporte motor con agujero
										union()	{
											// soporte para el motor
											ayh = 1.8 ; azh = .1 ; axd = 2.3 ;
											hull() 
											{ // agujero superior izquierdo
												translate([-dam, dam, 0]) 
													cilindro(an17/2-dam, som_l); 
												union() {											
													translate([-an17/2-ucm/2, ayh, -som_l/2]) 
														cube([ an17/2-hbm+ucm +azh, an17/4+ucm, som_l]);
													translate([-an17/2-ucm/2, an17/4, -som_l/2]) 
														cube([(an17/2-hbm)/2+ucm, an17/4, som_l]);
												}											
											}
											// una piececita para suavizar
											translate([-an17/2-ucm/2, ayh-ayh+ucm/2, -som_l/2]) cube([ an17/2-hbm+ucm +azh, ayh+ucm, som_l ]);
											// ahora los agujeros de abajo
											union() { // agujero inferior derecho								
												holgura = .8 ; bajaunpoco = 2 ; redondeo = 1 ;
												hull() {
													translate([dam, holgura/2-dam, 0]) cilindro(an17/2-dam-holgura/2, som_l);
													translate([ser_wo-an17/2 +axd, holgura-an17/2, -som_l/2]) cube([ucm, an17/2-hbm-holgura, som_l]);
												}
												translate([ser_wo-an17/2 +redondeo/2 , holgura-an17/2, -som_l/2])
													cube([axd,an17/2-hbm-holgura+ucm, som_l]);
												difference() {
													translate([-an17/2, -bajaunpoco-an17/2, -som_l/2]) 
														cube([ser_wo+redondeo, (an17/2-dam)*2+bajaunpoco, som_l]);
													translate([ser_wo+redondeo-an17/2,holgura-redondeo-an17/2,-som_l/2-ucm/2]) {
														cylinder(r=redondeo, h=som_l+ucm, $fn=fn(1));
														translate([-redondeo,-bajaunpoco-ucm,0]) 
															cube([redondeo*2, bajaunpoco+ucm, som_l+ucm]);
													}
												}
											}
											// rectángulo inferior izquierdo
											recorte = 2 ; // el recorte es para evitar un pico que sale cuando el eje de balanceo está muy hacia el centro
											translate([(an17/2-recorte)/2-an17/2, ucm/2-an17/4, 0]) cube([an17/2+ucm-recorte, an17/2+ucm, som_l], center=true);												
												
										}
										// hacer el agujero para la boina del motor
										cilindro(hbm, som_l+ucm);
									}
									// ahora los cuernos que se agarran al eje de rotación del cuerpo (para que pueda bascular con sobrepresiones)
									// los hago uniendo unas piezas de base, y luego quitando el hueco del tornillo y el voladizo del soporte motor
									union () 
									{ // bloque de base				
										translate([-an17/2-ucm/2+ser_wo/2, an17/2 - cue_alto + ser_h/2, som_l/2-cue_fondo/2]) 
											cubor([ser_wo+ucm, ser_h, cue_fondo], esquinas=1);
										difference() 
										{ // redondeo en el rincón que forma el cuerpo con la base
											translate([-an17/2-ucm, an17/2-cue_alto+ser_h-ucm, som_l/2-cue_fondo]) cube([rcs+ucm, rcs+ucm, cue_fondo]);
											translate([-an17/2-ucm+rcs, an17/2-cue_alto+ser_h-ucm+rcs, som_l/2-cue_fondo/2]) cilindro(rcs+ucm, cue_fondo+ucm);
										}
									}
								}
								
								// unas arandelas para separar el motor y que corra el aire
								translate(-[dee - an17 / 2 + holgura_ec - cue_w/2, 0, cue_alto/2 - (drg/2 + hvrg)])								
									agujeros_motor(true);
							}
						}
						
/*##################################################################################################
####################################  ##############################################################
####################################################################################################
#########    ####   #  #  ##  ######  ###    ###  #   ###    ####     ##############################
############  ##  ##  ##  ##  ######  ##  ##  ###   #  #  ##  ##  ##################################
#########     ##  ##  ##  ##  ######  ##      ###  ##  #  ##  ###    ###############################
########  ##  ###     ##  ##  ##  ##  ##  #######  #####  ##  ######  ##############################
#########   #  #####  ###   #  #  ##  ###    ###    #####    ###     ###############################
################     ############    ###############################################################
##################################################################################################*/
						
						agujeros_motor();
						
						rotate([90,0,0]) { // alojamiento para los rodamientos 608zz con cono de entrada y rebaje para que no roce el aro interior
							cilindro(htrh, cue_fondo+ucm); // hueco para el tornillo ranurado
							translate([0,0, 4  ]) cylinder(r1=agj(7), r2=agj(8), h=1, center=true, $fn=fn(agj(7)));
							translate([0,0,-4  ]) cylinder(r2=agj(7), r1=agj(8), h=1, center=true, $fn=fn(agj(7)));
							translate([0,0, 7.5]) cilindro(agj(11), 7);
							translate([0,0,-7.5]) cilindro(agj(11), 7);
							// abrir algo los agujeros de los rodamientos al exterior
							translate([0,0,-14-ucm/2 ]) cylinder(r1=agj(11)+1, r2=agj(11), h=8+ucm, center=true, $fn=fn(agj(11)));
							translate([0,0, 14+ucm/2 ]) cylinder(r1=agj(11), r2=agj(11)+1, h=8+ucm, center=true, $fn=fn(agj(11)));
							translate([-11-offset_eje,0,0]) cilindro(11+2, 8+ucm);			
						}
						
						// redondeo del extremo inferior de la apertura del rodamiento (versión reducida)
						translate(-[dee - an17 / 2 + .2 - cue_w/2+offset_eje, 0, cue_alto / 2]) // le quito los translates, actuales
							redondeo_inf_izdo_rodatos();
							
						// abrir bien el hueco para el rodamiento de presión (hasta mitad de tornillo + 3,5mm)
						translate([-cue_alto/2-(1-puovi)*cue_w/2, 0, cue_alto/2-3.5]) cube(cue_alto, cue_alto, cue_alto, center=true);
						// agujero filamento: desplazar radio tornillo moleteado + radio filamento - incisión, y agrandar un poco en X
						translate([-offset_eje, 0, -(drg/2+hvrg)]) vertical_filamento(true);
						// hueco para la pieza de enganche izquierda
						translate([-defc/2-offset_eje,0,li_alto/2-(drg/2 + hvrg)]) {
							escala = (li_ancho+li_holgura*2)/li_ancho ;
							scale([escala, escala, 2])
								lengua_izquierda();	
						}
					}				
				}

			
				// permitir algo de giro del extrusor sobre el pivote
				redondeo_rotacion();
			
				// ventana 
				minkowski() {  
					difference() {
					  translate([vnt_w/2+vnt_d, 0, vnt_h/2+vnt_b]) rotate([90,0,0]) 
						 cube([vnt_w-rehuefi,vnt_h-rehuefi,cue_fondo+ucm], center=true);
					  translate([offset_eje, 0, drg/2 + hvrg]) 
						 rotate([90,0,0]) cilindro(11+4+rehuefi, cue_fondo+ucm+ucm); 
					}
					rotate([90,0,0]) cylinder(r=rehuefi, h=1, $fn=fn(rehuefi), center=true);
				}
				
				// conducto de ventilación del motor
				{ amh = 5 ; aml = 14 ; ama = 40 ; largo = 15 ; desplazamiento = 5.5 ;
				translate([cue_w/2+offset_eje,0,vnt_h/2+vnt_b+desplazamiento]) 
					rotate([0,ama,0])
						difference() {
							hull()
								for (lado = [-1, 1] )
									translate([0, lado*(aml-amh)/2, 0]) cylinder(r=amh/2, h=largo, center=true, $fn=fn(amh/2));
							if (hacer_soportes) 
								difference() {
									hull()
										for (lado = [-1, 1] )
											translate([0, lado*(aml-amh)/2, 0]) cylinder(r=amh/2-gapplasop, h=largo+ucm, center=true, $fn=fn(amh/2));							
									for ( flanco = [-1,1] )
										translate([flanco*(5+.65*(amh/2-gapplasop)),0,0]) // .6 es la fracción de un círculo que requiere soporte (cos(55) aprox)
											cube([10,largo, largo+ucm*2], center=true);
								}
						}
				}
				
				// hueco para el anclaje derecho; el cálculo de posición en Z también es complicado, pero como se trata de hacer un agujero, hago la lengua muy gorda y resuelto
				translate([defc/2, 0, adgl/2]) scale([(adabl+adhxl)/adabl,1,2]) anclaje_dcha_lengua();
				translate([0,0,ejebalanceo]) eje_balanceo(3.6/2);

				
				// huecos para los tornillos de presión de filamento (uno a cada lado)
				difference() { // al tornillo delantero hay que darle una lijadita porque de lo contrario habría que rebajar el soporte del motor
					tornillo_presion_filamento(-1);
					translate([cue_w-10,-10-cue_fondo/2+som_l,htornillo])
						cube(20, center=true);
				}
				tornillo_presion_filamento( 1);
				
				rosca_detector_filamento();
			}	
		
		
		
		// estructura guia-filamento con sus soportes	
		// hay muchos parámetros puestos al tun-tun porque a estas alturas habría que rehacer todo el s'extrusor para darle coherencia (y no me apetece)
				X_jiji = (1-puovi)*cue_w ; // parte plana desde el lado del motor hasta que empieza la bajada (el largo deseado lo mido
										   // desde el lado del motor, pero la estructura empieza en X_jiji para no afectar a los huecos de los tornillos)
				largo = 24 - X_jiji ;
				x_lado_motor = offset_eje + dee - an17 / 2 + holgura_ec;
				alto = 9 ;
				ancho = posicion_tornillo(1)-posicion_tornillo(-1)+gapplasop+rtornillo ;
				ajuste_encaje_presor = -9.4 ;
				extender_recorte_tornillo = 11 ; // extender el recorte del tornillo del presor para que me haga el recorte de la guía
				difference() {

					union() {
						translate([x_lado_motor - largo/2 - X_jiji ,gapplasop/2,cue_alto-alto/2])
							cube([largo, ancho, alto], center=true);
							
						redondeo = .59 ;
						translate([-5.15,0,cue_alto-redondeo])
							rotate([90,30,0])
								cylinder(r=redondeo, h=ancho, center=true, $fn=6);
					}
					rosca_detector_filamento();
					translate([ajuste_encaje_presor,0,cue_alto-cue_w*povi])  
						scale([puovi,1,povi]) 
							rotate([90, 0, 0])
								cilindro(cue_w, cue_fondo+ucm);
					scale([.9,1,1])
						translate([x_lado_motor - largo/2 - X_jiji -4.5 ,0,cue_alto-alto/2]) {
							redondeo = 4 ;
							translate([0,posicion_tornillo(1)+rtornillo,0])
								cylinder(r=redondeo, h=10, center=true, $fn=fn(redondeo));
							translate([0,posicion_tornillo(-1)-rtornillo+.25,0])
								cylinder(r=redondeo, h=10, center=true, $fn=fn(redondeo));
						}
					translate([extender_recorte_tornillo,0,0]) {
						tornillo_presion_filamento(-1);
						tornillo_presion_filamento( 1);
					}
					difference() {
						union() {
							vertical_filamento();
							translate([-10/2, 0, 0]) 
								cube([10, dy_entrada_filamento, 200], center=true);
						}
						if (hacer_soportes) {
							difference() {
								escala = (agj(2)-gapplasop)/agj(2) ;
								scale([escala, escala, 1.01])
									vertical_filamento();
								translate([10/2+1.7, 0, 0])
									cube([10,10,200+ucm], center=true);
							}
							translate([-10/2, 0, 0])
								cube([10, agj(2)*2-gapplasop*2, 200+ucm], center=true);
						}							
					}
				}
				// ahora el soporte externo del guia-filamento
				if (hacer_soportes)
					difference() {					
						ancho_s = cue_fondo/2-posicion_tornillo(1)+agj(rtornillo)+gapplasop/2-gapplasop-.05 ;
						Y = (ancho_s-cue_fondo)/2 ;
						union() {
							translate([x_lado_motor - largo/2 - X_jiji, Y ,cue_alto-alto/2])
								cube([largo, ancho_s, alto], center=true);
							redondeo = .59 ;
							translate([-5.15,Y,cue_alto-redondeo])
								rotate([90,30,0])
									cylinder(r=redondeo, h=ancho_s, center=true, $fn=6);
						}
						translate([ajuste_encaje_presor,0,cue_alto-cue_w*povi])  
							scale([puovi,1,povi]) 
								rotate([90, 0, 0])
									cilindro(cue_w, cue_fondo+ucm);
						translate([cue_w/2,0,cue_alto-cue_w*povi])  
							scale([puovi*1.055,1,povi*1.022]) 
								rotate([90, 0, 0])
									cilindro(cue_w, cue_fondo+ucm);
						difference() {
							cubito = 10 ;
							translate([x_lado_motor - largo/2 - X_jiji -4.5+cubito/2,-4-gapplasop,cue_alto-cubito/2-alto+4.5])
								cube(cubito, center=true);
							scale([.9,1,1]) {
								redondeo = 4 ;
								translate([x_lado_motor - largo/2 - X_jiji -4.5 ,posicion_tornillo(-1)-rtornillo+.15+gapplasop/2-gapplasop,cue_alto-alto/2]) 
									cylinder(r=redondeo, h=10, center=true, $fn=fn(redondeo));
							}
						}
					}
			}


/*##################################################################################################
################################################### ################################################
##################################################  ################################################
#########     ###    ###  #   ###    ###  #   ###     ###    ####     ##############################
########  ######  ##  ###  ##  #  ##  ###   #  ###  ####  ##  ##  ##################################
#########    ###  ##  ###  ##  #  ##  ###  ##  ###  ####      ###    ###############################
############  ##  ##  ###     ##  ##  ###  #######  # ##  ##########  ##############################
########     ####    ####  ######    ###    #######  ####    ###     ###############################
########################    ########################################################################
##################################################################################################*/

		if (hacer_soportes && (elemento==cue_cuerpo)) {
			// para los tornillos de presión del filamento
			intersection() {
				union() {
					translate([offset_eje + dee - an17 / 2 + holgura_ec -(1-puovi)*cue_w, 0, cue_alto-cue_w*povi-.15]) // el .15 es empírico e ignoro a qué se debe, pero lo necesito :-(  
						scale([puovi,1,povi]) 
							rotate([90, 0, 0]) 			
								cilindro(cue_w, cue_fondo+ucm);
					translate([offset_eje + dee - an17 / 2 + holgura_ec -(1-puovi)*cue_w + cue_w/2, 0, cue_alto/2])
						cube([cue_w, cue_fondo, cue_alto], center=true);
				}
				union() {		
					difference() { // al tornillo delantero hay que darle una lijadita porque de lo contrario habría que rebajar el soporte del motor
						soporte_tornillo_presion_filamento(-1);
						translate([cue_w-10,-10-cue_fondo/2+som_l+gapplasop,htornillo])
							cube(20, center=true);
					}
					soporte_tornillo_presion_filamento(1);
				}
			}	

			// soporte para la pata trasera del motor
			difference() {
				zapatilla = alto_zapatilla+holgura_zapatilla ;
				translate([defc/2, 0, zapatilla]) 
					intersection() {
						dX_soporte = adlbl+adrme/2*cos(45) ;
						union() {
							intersection() {
								rotate([90,0,0]) 								
									translate([adlbl-dX_soporte/2,ser_h/2-zapatilla,0]) 
										// mirror([0,1,0]) // el reflejo en Y es para que el soporte no tenga un lado plano sobre el redondeo de los cuernos (no saldría bien)
											// el espesor=1 es la única forma que he encontrado de hacer un recorrido óptimo, sin cortes
										soporte_paralelo([dX_soporte, ser_h, adabl], espesor=.63, hueco=3.5, sombrero=false);
								translate([0,0,ser_h/2-zapatilla])
									scale([1,(adabl-gapplasop*2)/adabl,ser_h/adgl]) 
										anclaje_dcha_lengua(); 
										
								translate([.3,-groplasop+ucm/10,ser_h/2-zapatilla])	
									scale([1,(adabl-gapplasop*2)/adabl,ser_h/adgl]) 
										anclaje_dcha_lengua(); 
										
							}
							// plataforma de soporte sobre el soporte paralelo
							translate([.3,+ucm/10,ser_h/2-zapatilla])	
								scale([1,(adabl-gapplasop*2)/adabl,ser_h/adgl]) 
									difference() { 
										anclaje_dcha_lengua();
										scale([1,1,2]) translate([.3,-groplasop,-ucm]) anclaje_dcha_lengua(); }
						}
						translate([adlbl-dX_soporte/2,0,ser_h/2-zapatilla]) cube([dX_soporte, 1+adabl, ser_h+ucm], center=true);
					}
				redondeo_rotacion();
			}

			// agujero del filamento	
			intersection() {
				scale([1,(agj(2)-gapplasop)/agj(2),1]) 
					vertical_filamento(true);
				translate([0,0,11-ucm]) 
					cube([2.4,5, 22], center=true);
			}
		
			// soporte del rodamiento
			difference() {
				translate([offset_eje, -cue_fondo/2, drg/2 + hvrg])
					rotate([-90,0,0]) {
						translate([0,0,h_sopo_rod_ext])
							difference() {
								cylinder(r=6.75, h_sopo_rod_int-h_sopo_rod_ext, true);
								translate([0,0,-1]) cylinder(r=4, 2, true); 
							}

						translate([0,0,h_sopo_rod_ext/2])
							soporte_circular(r=10.5, h=h_sopo_rod_ext, center=true, sombrero=true, hueco=2.3);
					}	   
				translate([offset_eje, 0, drg/2 + hvrg]) rotate([90,0,0]) cylinder(r=3.6, h=cue_fondo+ucm, center=true, $fn=6);
				translate([offset_eje-11-2-3,0,drg/2 + hvrg]) {
					rotate([90,0,0]) cilindro(11+2, cue_alto);
					translate([11+2,0,0]) cube([5,cue_fondo+ucm,5], center=true);
				}

				translate([offset_eje-cue_alto/2-(1-puovi)*cue_w/2,0,cue_alto/2+drg/2 + hvrg]) cube(cue_alto, center=true);
			}

			// soporte del hueco para el rodamiento del presor
			difference() {
				intersection() {
					translate([-4,0,20.6]) cube([3,7.7,4.7], center=true);                          
					translate([ offset_eje + dee - an17 / 2 +.2 -(1-puovi)*cue_w, 0, cue_alto-cue_w*povi-.15]) // el .15 es empírico e ignoro a qué se debe, pero lo necesito :-(  
						scale([puovi,1,povi]) 
							rotate([90, 0, 0]) 
								cilindro(cue_w, cue_fondo+ucm);
					translate([-11, 0, drg/2 + hvrg]) rotate([90,0,0]) cilindro(11+2-sephsop, 8);
				}
				translate([offset_eje,0,drg/2 + hvrg]) rotate([90,0,0]) cilindro(agj(11), 8+ucm);			
				cube([2,cue_fondo,2], center=true);
				translate([-2.05,0,4.3]) // si, me avergüenzo de esto :(
					redondeo_inf_izdo_rodatos();
			}

			// soporte del hueco para el anclaje izquierdo
			translate([-defc/2, 0, pizd_h/2]) 
				union() {
					sin_soporte=1.7 ;
					translate([0,li_holgura-gapplasop,0])
						difference() {
							scale([1,1,pizd_h/li_alto])						
								lengua_izquierda();
							translate([-ucm,-groplasop,0])
								scale([1,1,2])
									lengua_izquierda();
							translate([10/2+li_ancho/2-sin_soporte,0,0]) 
								cube([10, li_ancho+ucm, pizd_h+ucm], center=true);
						}
					intersection() {
						scale([1, (li_ancho + li_holgura*2 - gapplasop*2)/li_ancho, 1.1])
							lengua_izquierda();
						rotate([90,0,0]) {
							ancho = li_ancho +li_holgura * 2 - 2*gapplasop - groplasop;
							translate([li_ancho/2-li_largo/2-sin_soporte/2,0,groplasop/2-ucm/2])
								soporte_paralelo([li_largo-sin_soporte, pizd_h, ancho+ucm], sombrero=false, espesor=.6);
						}
					}
				}
		}
	}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// cuerpo (el afeitado respeta soportes, y se hace in-situ)
if (hacer_cuerpo) translate(fabricar?[0,0,14]:[0,0,0]) rotate(fabricar?[90,0,0]:[0,0,0]) /*render()*/ cuerpo(cue_cuerpo); 

// presor: OjO porque no es simétrico. Los canales para los tornillos están desplazados en cuerpo y presor, y deben ir hacia el mismo lado
// además el hueco tiene una arandela impresa en un lado, y el soporte debe llevar el sombrero sólo en las capas superiores
if (hacer_presor) afeita(afeitado * fabricar) translate(fabricar?[75,-22,cue_fondo/2]:[0,0,0]) rotate(fabricar?[90,0,-45]:[0,0,0]) cuerpo(cue_presor); 
	
// casquillo separador del engranaje
if (hacer_casquillo) {
	radio = 6 ;
	alto = 2.6 + separa_engranajes_del_cuerpo ;
	
	agujero = agj(correccion(8/2  +  .3)) ; 
	translate(fabricar?[14,-70,alto/2]:[offset_eje,alto/2-cue_fondo/2-separa_engranajes_del_cuerpo,drg/2+hvrg]) 
		rotate(fabricar?[0,0,0]:[90,0,0]) 				
			difference() { 
				cylinder(r=radio, h=alto, center=true, $fn=fn(radio)); 
				cylinder(r=agujero, h=alto+ucm, center=true, $fn=fn(agujero)); 
			}
}


// engranajes: catalina
if (hacer_catalina)	
	translate(fabricar?[-32,-36,0]:[offset_eje,-(cue_fondo/2+separa_engranajes_del_cuerpo),drg/2+hvrg]) 
		rotate(fabricar?[0,0,0]:[90,0,0]) 
			afeita(sign(afeitado) * .3 * fabricar)
				translate([0,0,grosor_engranajes/2])
					engranaje_grande();

// engranajes: piñon
if (hacer_pinion) {
	translate(fabricar?[34,-70,0]:[offset_eje + dee,-(cue_fondo/2 + separa_engranajes_del_cuerpo + (tornillo_fuera ? -.2 : .2+grosor_engranajes)),drg/2+hvrg])
		rotate(fabricar?[0,0,0]:[tornillo_fuera? 90 : -90,0,0])
			afeita(sign(afeitado) * .3 * fabricar)
				translate([0,0,grosor_engranajes/2+.2]) // el piñon es .4 más ancho que grosor_engranajes
					engranaje_peque(tornillo_fuera);
	}

// anclaje completo (el afeitado respeta soportes, así que se hace in-situ
if (hacer_anclajes)
	translate(fabricar?[27,-70,0]:[0,0,-holgura_zapatilla]) 
		cuerpo(cue_ancla);

if (hacer_detector) {
	afeita(afeitado * fabricar) 
		cuerpo(cue_detector_cuerpo);
	
	if ( fabricar && ! (hacer_cuerpo + hacer_presor + hacer_pinion + hacer_catalina) )
		// una estructura para hacerle perder tiempo cuando no hay otra cosa que fabricar (debe extruir a una velocidad razonable, pero con un tiempo por capa suficiente
		translate([0,-60,0])
			rotate([0,0,90])
				soporte_paralelo([3.8, 20, 12.8], $gro_pla_sop=3, center=false);
			
	afeita(afeitado * fabricar) 
		cuerpo(cue_detector_balancin);
				
	afeita(afeitado * fabricar) 
		cuerpo(cue_detector_obturador);
}
