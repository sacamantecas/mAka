///////////////////////////////////////////////////////////////////////////////////////////////////
//
// extremos del eje X de mAka
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luiso gutierrez (sacamantecas)
//
//

derecha=1 ;  // lado que queremos (sólo uno cada vez, por no eternizar el proceso)
fabricar=0 ; // algunas partes se fabrican separadas

hacer_cursor = 1 ;
hacer_endstop_desorden = 1 ;
hacer_tensor_vertical = 1 ;

$alto_de_capa = .2 ;

///////////////////////////////////////////////////////////////////////////////////////////////////

completo=1 ; // para deshabilitar algunas cosas para ganar tiempo en depuración	
	hacer_bridas = 0 ;
	hacer_endstop_apoyo = 0 ;
	hacer_soportes_complejos = 0 ;
	hacer_cachas_vh = 0 ;
	hacer_polea = 1 ; // dcha	
	hacer_endstops_XZ = 0 ; // izda
	hacer_cacha_motor = 0 ; // izda
	
///////////////////////////////////////////////////////////////////////////////////////////////////

afeitado = .25 * fabricar;
$fa=1 ;
$fs=1 ;

use <utilidades.scad>


signo_lado=[1,-1][derecha];
// coger variables de propósito general en el módulo de utilidades
voladizo=utilidades($angulo_voladizo);
gapplasop=utilidades($gap_v_soporte);
sephsop=utilidades($gap_h_soporte);
groplasop=utilidades($gro_pla_sop);
redondeo=utilidades($redondeo);
// el módulo de utilidades usará este espesor para los soportes (si no, aplica un defecto)
$espesor=.59 ;


/* convenciones y abreviaturas usadas como prefijo:
- origen de coordenadas: X-Y en la varilla lisa vertical; Z en la base techo del cuerpo principal de la pieza (base de impresión)


vh: varillas horizontales sobre las que se mueve el carro portaherramientas
vv: varilla vertical por la que suben y bajan los soportes de X
vr: varilla roscada para el movimiento en Z
rh: rodamiento lineal horizontal
rv: rodamiento lineal vertical
n17: nema17
d?: diferencia o distancia entre coordenadas ? (dx de un cubo será el lado X)
se?: soporte del endstop de ?
*/


//                       #                       ##             ###           
//                      ##                                       ##           
//    ##  ##   ####    #####    ####  ## ###    ###    ####      ##           
//    #######     ##    ##     ##  ##  ### ##    ##       ##     ##           
//    #######  #####    ##     ######  ##  ##    ##    #####     ##           
//    ## # ## ##  ##    ## #   ##      ##        ##   ##  ##     ##           
//    ##   ##  ### ##    ##     ####  ####      ####   ### ##   ####          
                                                                            

// parámetros del material:
vh_diametro = 10 ;
vr_diametro = 5 ;
rh_largo = 29 ;
rh_diametro = 19 ;
rh_muesca_desplazato = 10.35 ; // desde la mitad longitudinal del rodamiento
rh_muesca_ancho = 1.3 ;
rh_muesca_profundo = .5 ;
n17_lado = 42.3 ;
n17_largo = 47 ;
n17_d_boina  = 24 ; // holgado porque no quiero que toque nada
n17_h_boina = 5 ; // muy holgado porque no quiero que toque nada
n17_diagonal = 54 ; // distancia entre chaflanes
n17_chaflan = ((n17_lado/(2*cos(45))-n17_diagonal/2)/cos(45));
n17_tornillo_desplazato = 15.5 ;
n17_tornillo_diametro = 3 ;
n17_tornillo_cabeza = 6 ;
agj_rosca_M3 = 2.5 ; // guía para hacer una rosca M3
agj_rosca_M3_h = correccion(agj_rosca_M3 + .2) ; // guía para hacer una rosca M3
agj_M3_h = correccion(3 + .3) ; 
arandela_M3_d = 6 ;
arandela_M3_endstop_h = 2 ;
tuerca_M3_d = 6.25 ;


// mini-microrruptor
mmr = [12.8, 6, 6.6] ; // largo x ancho x alto
mmr_hueco = correccion(mmr + [.2,.2,.2]);
mmr_accion = .6 ; // margen para accionarlo
mmr_conectores = [4, 4] ; // ancho x alto (con sitio para que entre el cable soldado)
mmr_pulsador = 4.8 ; // distancia del pulsador al extremo más próximo
mmr_agujero_descentre = 3.1 ; // distancia desde el centro a cada agujero
mmr_agujero_altura = 5 ; // distancia desde el lado del actuador al agujero
mmr_agujero_pincho = 1.4 ; // lado del pincho para enganchar el endstop
mmr_agujero_pincho_sale = 1.5 ; // cuánto sale, para remachar

// eje de la polea y sus rodamientos
eje_pasante = 7 ;
re_diametro = correccion(14 + .3) ;
re_peristoma = 10 ;
re_largo = 5 ;


// bridas: ancho, grueso, ancho cabeza (ya con algo de holgura)
brida48=[5, 1.5, 8];
brida35=[3.7, 1.5, 7];
brida25=[2.8, 1.3, 5];


// (dependientes)
vv_diametro = vh_diametro ;
rv_largo = rh_largo;
rv_diametro = rh_diametro;
rv_muesca_desplazato = rh_muesca_desplazato;
rv_muesca_ancho = rh_muesca_ancho;
rv_muesca_profundo = rh_muesca_profundo;


//     ###     ##                                           
//      ##                           #####                  
//      ##    ###     #####   ####            ####          
//   #####     ##    ##      ##  ##  #####   ##  ##         
//  ##  ##     ##     ####   ######  ##  ##  ##  ##         
//  ##  ##     ##        ##  ##      ##  ##  ##  ##         
//   ### ##   ####   #####    ####   ##  ##   ####          


// parametros globales de mAka
vr_desplazamiento = 16.5 ;
vh_hueco = 42 ;
vv_sobresale_cuerpo = 11 ;
angulo_motor = 10 ;


function ancho_soporte_brida(ancho) = $espesor; // que le den; un soporte de 2.3 a veces va bien porque sale empujando a golpes, pero ya he roto una pieza

hueco_cursor = [ [7.9, 19.2, 38] , [7.9, 19.2, 30] ] [derecha];
hueco_cursor_holgado = correccion(hueco_cursor + [1,1,0]);

ac_diametro = 12 ;
ac_profundidad = 5 ;

vrd_x = -vr_desplazamiento ; // X de la varilla roscada
vri_x =  vr_desplazamiento ;
vh_z= 50 ;
rv_separa = 0 ;
rv_holgura = .2 ;
rv_base = 1.8 ;


vr_pasante = vr_diametro + 1.5 ; // requiere holgura porque la varilla roscada no es recta y se bambolea
vr_pasante_corregido=correccion(vr_pasante + .3);


cuerpo_Xd =  vv_sobresale_cuerpo ; // X del lado exterior del cuerpo (me resulta más cómodo esto que referirme al centro)
cuerpo_Xi = -vv_sobresale_cuerpo ;
cuerpoi_dx = 47 ;
cuerpod_dxi = 43.2 ;  // el .2 es para lograr que los rodamientos de la polea queden perfectamente sujetos con 4 hilos contínuos de plástico
cuerpod_dxs = vv_sobresale_cuerpo+vr_desplazamiento+vr_pasante_corregido/2 + 7.7 ; // que quede algo de plástico en el lado exterior del agujero de la vr
cuerpo_dy = 36 ; // tendrá que estar entre vh_hueco y rv_diametro
cuerpo_dz = rv_largo*2 + rv_separa + rv_base + rv_holgura;
cuerpo_dzi = 32 ;
cuerpo_dzs = cuerpo_dz - cuerpo_dzi;


// eje (sus datos son como los del motor en Y, Z y ángulo
posicion_motor = [43,16,21.5] ; 
posicion_eje = [vrd_x-(vr_pasante + eje_pasante)/2, posicion_motor[1], posicion_motor[2]] ; 
Z_canto_recorte_motor=posicion_motor[2]+cos(angulo_motor)*n17_lado/2 - tan(angulo_motor)*(posicion_motor[1]+(cuerpo_dy-n17_lado*sin(angulo_motor))/2);
proyeccion_del_motor_en_la_base=posicion_motor[2]*tan(angulo_motor)+posicion_motor[1];
Z_recorte_tornillo_sup_n17 = posicion_motor[2]+n17_tornillo_desplazato*cos(angulo_motor)+tan(angulo_motor)*(cuerpo_dy/2-posicion_motor[1]+n17_tornillo_desplazato*sin(angulo_motor));


// bridas (entre el rodamiento vertical y la varilla roscada la 0, y la 1 sobre el tornillo del motor)
vh_bridad_x = [(vrd_x+vr_pasante/2-rv_diametro/2)/2, ((vrd_x-vr_pasante/2)-(cuerpod_dxs-cuerpo_Xd))/2];
vh_bridai_x = [(vri_x-vr_pasante/2+rv_diametro/2)/2, posicion_motor[0]-n17_tornillo_desplazato];

vh_brida_dx = correccion([brida35[0], brida48[0]]  +  [.5,.5]); // la 0 no puede ser mayor, y la otra... puede ser más ancha, y ya las tengo
vh_brida_dz = correccion([brida35[1], brida48[1]]  +  [.3,.3]);
vh_brida_soporte = false;
vh_cacha_z_sup = vh_z+vh_diametro/2*sin(voladizo) ; // este cálculo no hay que entenderlo: solo aceptarlo
vh_cacha_z_inf = Z_canto_recorte_motor;
vh_cacha_chaflan = .5 ; // evitar un canto afilado
vh_brida_z = [vh_cacha_z_sup+vh_brida_dz[0]/2, vh_z-(vh_diametro+vh_brida_dz[1])/2];
vh_cacha_caida=min(45, voladizo) ; // ángulo de caida de la cacha (menor o igual a voladizo)


// bridas para coger los rodamientos verticales (van en las muescas superior, inferior, y entre rodamientos
vv_brida=correccion(brida25  +  [.2,.5,0]);
vv_brida_z = [cuerpo_dz-rv_largo/2+rh_muesca_desplazato, cuerpo_dz-rv_largo, cuerpo_dz-1.5*rv_largo-rh_muesca_desplazato];
vv_brida_x = 6 - vv_sobresale_cuerpo ; // por dónde sale la brida al exterior
rv_diametro_reducido=correccion(rv_diametro  -  1); // la brida acepta desviarse .5mm alrededor del rodamiento, así que considero un diámetro reducido 1mm menor
vv_diametro_trayectoria=2*sqrt(pow((rv_diametro_reducido+vv_brida[1])/2+vv_brida_x, 2)+cuerpo_dy*cuerpo_dy/4)/(2*sin(atan(2*((rv_diametro_reducido+vv_brida[1])/2+vv_brida_x)/cuerpo_dy)));

// la apertura del lateral de los rodamientos verticales se calcula de tal modo que la
// cuña por donde pasa la brida tenga un pico de .5mm, para que se construya bien
apertura_rv = 2*((vv_diametro_trayectoria+vv_brida[1])/2)*sin(acos(((vv_diametro_trayectoria-rv_diametro_reducido-vv_brida[1])/2+vv_sobresale_cuerpo-$espesor)/((vv_diametro_trayectoria+vv_brida[1])/2)));
vv_pasante = max(apertura_rv, correccion(vv_diametro  +  1));


// la cacha es un añadido al lado +Y del cuerpo, con la inclinación del motor, donde van los tornillos que lo sujetan
// es grande, y luego le voy haciendo recortes
cacha_dx = n17_lado + 15 ;
cacha_dy = 4 ;
cacha_angulo = angulo_motor ; // se puede poner hasta 25 para no alargar demasiado, pero no le veo sentido



// soporte del edstop de Z, consta de 3 elementos, resumibles en 2:
// seZ1) 2 agujeros en Y de ancho seZ1_dx para seZ1_brida a alturas seZ1_z[0..1], que cierra el bucle en un rebaje en el hueco del cursor, de 
//   	 una profundidad seZ1_dy
// seZ1) un apoyo vertical en seZ1_x (ancho de brida) y entre los agujeros anteriores, que sobresale seZ_dy, hasta seZ_y
// seZ2) un apoyo cilindrico en XZ de diametro seZ2_peristoma en seZ2_x, seZ2_z (truncado en z=0) con agujero de diametro agj_rosca_M3 y profundidad seZ2_penetra_tornillo
seZ1_brida = correccion(brida25  +  [.4,.3,0]);
seZ1_z = [2.6 - seZ1_brida[1]/2, 12.6 + seZ1_brida[1]/2];
seZ1_x = 13.75 ; // esta medida es crítica: depende del endstop, del hueco del cursor, de la brida... está afinada a la centésima para evitar quiebros en el STL
seZ1_dx = seZ1_brida[0];
seZ1_dy=3 ;
seZ_dy = 3 ; // distancia suficiente para que las soldaduras del endstop no tropiecen con el tornillo del motor
seZ_y = seZ_dy + proyeccion_del_motor_en_la_base + cacha_dy; 
seZ2_x = 47.3 ;
seZ2_peristoma = 6 ;
seZ2_z = 2.5 ;
seZ2_penetra_tornillo = cuerpo_dy ;


// soporte del endstop de X: 2 cilindros en (seX_x, seX_y[0..1]) con diametro seX_peristoma y sobresaliendo seX_dz
// con agujeros para roscar una M3 de profundidad seX_penetra_tornillo, unidos a plataforma de seX_dx x seX_dy
seX_y = [4.9, -14.1];
seX_x = cuerpoi_dx - vv_sobresale_cuerpo - 3.1 ; // metido 3.1 respecto al borde
seX_dx = 12 ;
seX_dy = 2.2 ;
seX_dz = 2 ;
seX_peristoma = 6 ;
seX_penetra_tornillo = 8 ;


// soportes para endstops de desorden mecanico en X
sedX_x = ([vh_bridai_x, vh_bridad_x][derecha])[0]-signo_lado*vh_brida_dx[0]/2;
sedX_guia_diametro = mmr_hueco[1] + 2 ; // sobresale tanto como el mmr + 1mm (por la brida)
sedX_guia_ancho = 3 ;
sedX_guia_agujero = 3.5 ;
sedX_guia_x = [[vh_bridai_x[0]+vh_brida_dx[0]/2+sedX_guia_ancho/2,cuerpoi_dx+cuerpo_Xi-sedX_guia_ancho/2-redondeo], [,]] ; // [lado][orden]
sedX_vastago = 3 ; // diametro del vastago
sedX_vastago_hueco=correccion(sedX_vastago + .6) ;
sedX_abrazo_mmr = 2 ; // en qué medida la base del mmr abraza a este
sedX_holgura_cacha = .3 ; // separacion de la pieza a la cacha de la varilla horizontal
sedX_hueco_tornillo_n17 = 3 ; // hueco que hay que dejar para el tornillo que sujeta al motor por arriba
sedX_pincho_aleja_motor=1.5 ; // impedir que el agujero para el pincho se abra al hueco del motor
sedX_pincho = [ 1.8, 4.5, 1.8 ] ; // ancho, profundo, alto
sedX_agujero = correccion(sedX_pincho + [.5, .5, .2]); // ancho, profundo, alto
sedX_brida = correccion(brida25 + [.3,.2,0]) ; // brida que sujeta la base de mmr+vastago
sedX_brida_chaflan = 1.8 ; // la brida sale entre el cuerpo y la cacha: para evitar un filo en la cacha se hace un chaflan de este dY


// cursor
cursor_requerido_por_muelle = 9.8+7 ;
cursor_alto=[ 9.8 , cursor_requerido_por_muelle ] [derecha] ; // alto total
cursor_plataforma=2 ; // grosor sobre la tuerca
cursor_tuerca = correccion(9 + .6); // la tuerca es del 8, pero de punta a punta son 9mm
cursor_tuercas_dz = 12 ; // irrelevante en el cursor izquierdo, y en el derecho es el hueco total para las tuercas
cursor_lado_muelle_dy = hueco_cursor[1]/2-cursor_tuerca/2 + 1 ;

// soporte para los endstop de desorden mecánico en Z
sedZ_asa_ancho = 8 ; // el mmr lleva una brida que el en agujero alejado del pulsador, que sirve de tope y sujeta el cable
sedZ_asa_alto = 2.8 ;
sedZ_asa_deja_entrar = 9.2 ; // una vez metido el mmr, y con el asa apoyada en un resalte del agujero, sobresale esta distancia
sedZ_holgura = .8 ; // a cuánto queda el mmr de la varilla roscada
sedZ_techo=hueco_cursor[2] - cursor_alto - mmr_accion - .2 ; // pongo .2 y no gapplasop porque es si es .25 me desplaza .05 mm el agujero, y no quiero


// tensor vertical
tv_ancho = 6 ;
tv_ancho_agujero = correccion(tv_ancho  +  .2); // habrá que lijar un poco
tv_separa = .2 ; // es una separacion de la pared del hueco del cursor, para ganar calidad de fabricación cerca del alojamiento del rodamiento
tv_techo_d = sedZ_techo; // mismo techo que el agujero de los endstop de desorden en Z
tv_alto_d = mmr_hueco[2]+mmr_conectores[1]; // e igual de alto también
tv_muelle = correccion(2.2  +  .6); // me interesa un tamaño final de unos 2.4
tv_descentre= cursor_tuerca/2 + (hueco_cursor[1] - cursor_tuerca)/4 ; // centrar en lo que queda desde la punta de la tuerca al borde
tv_techo_i = sedZ_techo + cursor_alto - cursor_requerido_por_muelle - $alto_de_capa;
tv_alto_i = 5 ;
tv_izdo_angulo = 30 ; // angulo de la pieza de tensión del muelle vertical
tv_izdo_recorte_esquina = 1 ;


// roscas para atornillar la parte fija del autolevel
rosca_autolevel_altura = [6, 26]; // esto está en al.scad
rosca_autolevel_entra = 3 ;


// variables importantes para el proceso, pero no para el afinado
mucho = 100 ;
mp= .1 ;
mmp=.001 ; // porque a veces mp resulta excesivo


//     ###                                                    ###     ###                   
//      ##                                                     ##      ##                   
//      ##    ####    #####  ####   ## ###  ## ###    ####     ##      ##     ####          
//   #####   ##  ##  ##         ##   ### ##  ### ##  ##  ##    ##      ##    ##  ##         
//  ##  ##   ######   ####   #####   ##  ##  ##  ##  ##  ##    ##      ##    ##  ##         
//  ##  ##   ##          ## ##  ##   ##      ##      ##  ##    ##      ##    ##  ##         
//   ### ##   ####   #####   ### ## ####    ####      ####    ####    ####    ####          
                                                                                          

// un cuerpo al que se le hacen unos descuentos específicos, luego unos comunes, y finalmente unos añadidos 

afeita(afeitado)
render()
difference() {
	union() {
		if (derecha) {		
			difference() {
				cuerpo_derecho();
				// eje de la polea y sus rodamientos
				if (completo + hacer_polea)					
						translate(posicion_eje) 
							rotate([angulo_motor+90, 0, 0]) {		
								pulopo=re_largo*cos(angulo_motor)+(re_diametro/2)*sin(angulo_motor);
								H=(cuerpo_dy-2*pulopo)/cos(angulo_motor) + mp;
								T=[0,0,posicion_eje[1]/cos(angulo_motor)];
									if (fabricar)
										agujero_cilindrico_soportado(d=eje_pasante, h=H, t=T, cascara=$espesor, anticolapso=H);
									else
										cilindro(d=eje_pasante, h=H, t=T);
								for ( lado = [-1, 1] ) {
									mucho = pulopo + 2 ;
									T = [0,0, + lado*(mucho/2 + (cuerpo_dy/2-pulopo + lado*posicion_eje[1])/cos(angulo_motor))];
										if (fabricar)
											agujero_cilindrico_soportado(d=re_diametro, h=mucho, t=T, separa=sephsop, cascara=-sign(lado-1)*$espesor, anticolapso=0);
										else
											cilindro(d=re_diametro, h=mucho, t=T);
								}
							}

				// cursor
				cubo(c=hueco_cursor_holgado, t=[vrd_x, 0, hueco_cursor_holgado[2]/2]);
				if (hacer_tensor_vertical) {
					mucho= cuerpod_dxi - cuerpo_Xd + vrd_x +mp;
					// agujero del tensor vertical
					cubo([mucho, tv_ancho_agujero, tv_alto_d], t=[vrd_x-mucho/2, (tv_ancho_agujero-hueco_cursor_holgado[1])/2 + tv_separa, tv_techo_d-tv_alto_d/2]);
				}
				
				for (h = rosca_autolevel_altura) 
					translate([vrd_x, 0, h]) rotate([90,0,0]) {
						cylinder(d=agj_M3_h, h=cuerpo_dy/2+mp);
						resize([correccion( tuerca_M3_d  +  .2),0,0])
							rotate([0,0,30]) 
								cylinder(d=correccion(tuerca_M3_d  +  .1), h=hueco_cursor_holgado[1]/2 + rosca_autolevel_entra, $fn=6);
					}
			}
			// soportito del agujero del tensor vertical
			if (hacer_tensor_vertical * (completo + hacer_soportes_complejos) * fabricar) {
				largo_soporte = cuerpod_dxi+cuerpo_Xi+vrd_x-hueco_cursor_holgado[0]/2 ;
				ancho_soporte = tv_ancho-3 ;
				translate([largo_soporte/2-(cuerpo_Xi+cuerpod_dxi), (tv_ancho_agujero-hueco_cursor_holgado[1])/2 + tv_separa, tv_techo_d-tv_alto_d/2]) 
					rotate([0,0,-90]) 
						soporte_paralelo([ancho_soporte, largo_soporte, tv_alto_d - 2*gapplasop], sombrero=0);
			}
		} else 
			difference() {
				cuerpo_izquierdo();
			
				// motor y su tornillo superior
				motor();
				translate([0,cuerpo_dy/2-n17_tornillo_cabeza/2*sin(angulo_motor), Z_recorte_tornillo_sup_n17])
					rotate([angulo_motor-90,0,0]) {
						mucho = 5 ;
						cilindro(d=n17_tornillo_cabeza, h=mucho, t=[posicion_motor[0]-n17_tornillo_desplazato,0,mucho/2]);
					}
				
				// cursor (hay que abrir el hueco hacia el motor)
				{
					mucho=hueco_cursor_holgado[0] * 2;
					cubo(c=[mucho,hueco_cursor_holgado[1],hueco_cursor_holgado[2]+mp], t=[mucho/2+vri_x-hueco_cursor_holgado[0]/2, 0, (hueco_cursor_holgado[2]-mp)/2]);
					if (completo + hacer_endstops_XZ) {	
						seZ(poner=0);
						seX(poner=0);		
					}
				}
				if (hacer_tensor_vertical)
					difference() {
						apoyo_tv_izdo(1);
						if (completo + hacer_soportes_complejos)
							apoyo_tv_izdo(2);
					}
			}
	}
			
	descuentos_comunes();
	if (hacer_endstop_desorden)  
		sedX(poner=0);
	
}

if (hacer_endstop_desorden)  
	afeita(afeitado) 
		sedX(poner=1);

// soportes que requieren un proceso solido + vaciado + soporte
if (fabricar && (completo + hacer_soportes_complejos) )
	if (derecha) {
	
		// soporte del hueco del cursor con la plataforma gorda para que salga de una pieza (hay dificultad para acceder)
		translate([vrd_x, 0, (hueco_cursor[2]-gapplasop)/2])
			soporte_paralelo(hueco_cursor-[2*sephsop, 2*sephsop, gapplasop], $gro_pla_sop=1.2);

		// esta parrafada es para colocar una tapa vertical en la parte baja del soporte del rodamiento de la polea, para que no se caigan las paredes
		if (completo + hacer_polea) {
			chorrico = 5 ;
			difference() {
				intersection() {
					cubo(c=[mucho, $espesor, mucho], t=[0, ($espesor-cuerpo_dy)/2, 0]);
					translate(posicion_eje) 
						rotate([angulo_motor+90, 0, 0]) 
							cilindro(re_diametro-mp, h=mucho, t=[0,0, mucho/2 + cuerpo_dy -chorrico]);
				}
				translate(posicion_eje) 
					rotate([angulo_motor+90, 0, 0]) 
						agujero_cilindrico_soportado(d=re_diametro, h=mucho, t=[0,0, mucho/2 + cuerpo_dy -chorrico], cascara=chorrico*2, anticolapso=0);
			}			
		}
			
		
	} else {
		render() difference() {
			// aquí hay mucha chorradita para tratar de tomar el control de los soportes, y en la nueva versión de kisslicer no lo consigo
			union() {
				agregado = posicion_motor[0]-n17_lado/2-vri_x-hueco_cursor[0]/2 ; // añadir el trocito que hay hasta llegar al hueco del motor
				translate([vri_x+sephsop/2+agregado/2, 0, (hueco_cursor[2]-gapplasop-groplasop)/2]) {
					mirror([0,1,0]) 
						translate([0,0,-mmp/2])
							soporte_paralelo(hueco_cursor-[sephsop-agregado+mmp, sephsop*2, gapplasop + groplasop+mmp], suela=true, sombrero=false);
					// esta plataforma es porque el hueco del cursor es enorme, interfiere con el recorte a 45º del motor y queda un "cielo" horizontal que requiere apoyo
					cubo([n17_chaflan + hueco_cursor[0]-(sephsop-agregado)+$espesor, hueco_cursor[1]-sephsop*2, groplasop], t=[(n17_chaflan+$espesor)/2,0,(hueco_cursor[2]-gapplasop)/2]);
				}
				soporte_hueco_motor();	
				cubo(c=[n17_chaflan+mp, 2+$espesor*2, hueco_cursor[2]-gapplasop -groplasop -mp], t=[posicion_motor[0]-n17_lado/2+n17_chaflan/2,0,(hueco_cursor[2]-gapplasop -groplasop -mp)/2 ]);
			}
			// va sobreelevado .2 para que quede una capa de zapatilla
			cubo(c=[n17_chaflan+$espesor*2+mp, 2, hueco_cursor[2]-gapplasop], t=[posicion_motor[0]-n17_lado/2+n17_chaflan/2,0, .2 +(hueco_cursor[2]-gapplasop)/2]);
		}


		// soporte del apoyo vertical para el endstop de Z		
		if (fabricar && (completo + hacer_endstops_XZ * hacer_soportes_complejos) )
			render() difference() {
				a=seZ1_z[0]+seZ1_brida[1]/2-gapplasop ;
				cubo(c=[seZ1_dx, mucho, a], t=[seZ1_x, seZ_y-mucho/2, a/2]);
				translate([0,proyeccion_del_motor_en_la_base+cacha_dy/cos(angulo_motor)+sephsop,0]) 
					cubo(mucho, t=[0,-mucho/2, 0], r=[angulo_motor,0,0]);
			}	

	}


// cursor: debe permitir presión fuerte hacia abajo (por el apoyo de X) y hacia arriba para que no se levante con el endstop si hay apoyo
// y lo que es más importante: el tensor vertical tira del soporte X derecho hacia abajo, empujando el cursor hacia arriba.
if (hacer_cursor) {
	vr_pasante_cursor = correccion(vr_diametro + .8) ;
	afeita(afeitado)
		translate([signo_lado * (fabricar ? -20 : vr_desplazamiento),0, fabricar ? 0 : hueco_cursor[2]]) 
			rotate(fabricar?[0,0,0]:[0,180,0]) {
				difference() {
					cubo([hueco_cursor[0], hueco_cursor[1], cursor_requerido_por_muelle], t=[0,0,cursor_requerido_por_muelle/2]);
					cilindro(d=vr_pasante_cursor, h=cursor_requerido_por_muelle+mp, t=[0,0,cursor_requerido_por_muelle/2]);
					// hueco para que entre la tuerca
					mucho = hueco_cursor[0];
					if (derecha)
						cubo([mucho, cursor_tuerca, cursor_tuercas_dz/3], t=[mucho/2,  0, cursor_plataforma+cursor_tuercas_dz*5/6]);
					else
						cubo([hueco_cursor[0]+mp, hueco_cursor[1], cursor_requerido_por_muelle], t=[0,  cursor_lado_muelle_dy, cursor_requerido_por_muelle/2+cursor_alto]);
					translate([0,0,cursor_tuercas_dz/2+cursor_plataforma])
						rotate([0,0,30])
							cylinder(d=cursor_tuerca, h=cursor_tuercas_dz, center=true, $fn=6);	
					// el agujerito del muelle
					cilindro(d=tv_muelle, h=cursor_requerido_por_muelle, t=[0,-tv_descentre, cursor_requerido_por_muelle/2+cursor_plataforma]);
				}
				if (derecha * fabricar) { // soporte para la parte de abajo (se fabrica al revés)
					soporte_dz = cursor_tuercas_dz - 2 * gapplasop ;
					translate([0,0,soporte_dz/2 + cursor_plataforma+gapplasop])
						difference() {
							union() {
								cilindro(d= correccion(vr_pasante_cursor + .25), h=soporte_dz*2/3, t=[0,0,-soporte_dz/6]);
								translate([0,0,soporte_dz/6-mp])
									rotate([0,0,30])
										cylinder(d1=correccion(vr_pasante_cursor + 1), d2=hueco_cursor[0]+1, h=soporte_dz/3+mp, $fn=6);
							}
							cilindro(d= correccion(vr_pasante_cursor + .25) - $espesor, h=soporte_dz+mp);
						}
				}
			}
}

if (hacer_tensor_vertical)
	// pieza de apoyo para el muelle tensor vertical
	afeita(afeitado)
		if (derecha) 
			translate(fabricar ? [25,0,tv_techo_d] : [vrd_x,0,0]) rotate(fabricar ? [0,180,90] : [0,0,0])
				difference() {	
					tope_x = hueco_cursor_holgado[0]/2 ;
					dx = cuerpod_dxi-cuerpo_Xd+vrd_x+hueco_cursor_holgado[0]/2 ;
					cubo([dx, tv_ancho, tv_alto_d], t=[tope_x - dx/2, (tv_ancho_agujero-hueco_cursor_holgado[1])/2 + tv_separa, tv_techo_d-tv_alto_d/2]);
					// corte para ofrecer un relieve que permita meter una herramienta para empujar la pieza hacia fuera
					cubo(mucho, t=[mucho/2, 0, ac_profundidad-mucho/2]);
					// recorte para hacer hueco al acoplamiento del motor de Z
					cilindro(d=ac_diametro, h=mucho, t=[0,0,ac_profundidad-mucho/2]);
			}
		else 
			translate(fabricar?[35,-10,tv_techo_i - $alto_de_capa/2]:[0,0,0])  // el apoyo en $alto_de_capa menor que tv_alto_i
				rotate(fabricar?[180,0,0]:[0,0,0])
					apoyo_tv_izdo(0);
	

		
/////////////////////////////////////////////////
// guías visuales
%for (lado = [ -1, 1 ])
	cilindro(d=vh_diametro, h=mucho, t=[signo_lado*(mucho/2-vv_sobresale_cuerpo), lado * (vh_hueco+vh_diametro)/2, vh_z], r=[0,90,00]);
%if (hacer_endstop_desorden) {
	pulsador_ancho = .6 ;
	pulsador_alto = .7 ;
	pulsador_largo = 2.9 ;
	translate([sedX_x-signo_lado*(mmr_hueco[2]-mmr[2])/2, (vh_hueco+vh_diametro)/2, vh_z-vh_diametro/2-mmr_hueco[0]/2]) {
		difference() {
			cubo([mmr[2], mmr[1], mmr[0]], t=[-signo_lado*mmr[2]/2,0,0]);
			agujero = 2.1 ;
			for ( lado = [-1, 1] )
				translate([-signo_lado*mmr_agujero_altura,0,lado*mmr_agujero_descentre])
					cilindro(d=agujero, h=mmr[1]+mp, r=[90,0,0]);
		}			
		translate([0,0,mmr_hueco[0]/2-mmr_pulsador])
			cilindro(d=pulsador_alto*2, h=pulsador_largo, r=[90,0,0], s=[1, pulsador_ancho/(pulsador_alto*2),1], $fs=.01);
			
		vastago_l = cuerpoi_dx+cuerpo_Xi-sedX_x ;
		translate([signo_lado * (vastago_l/2+pulsador_alto),0,mmr_hueco[0]/2-mmr_pulsador])
			cilindro(d=sedX_vastago, h=vastago_l, r=[0,90,0]);
	}	
}
		
//                            ###                  
//   ####    ####  ##  ##           #####          
//  ##  ##  ##  ## ####### ##  ##   ##  ##         
//  ##      ##  ## ####### ##  ##   ##  ##         
//  ##  ##  ##  ## ## # ## ##  ##   ##  ##         
//   ####    ####  ##   ##  ######  ##  ##         


module descuentos_comunes() {
	// varillas y rodamientos
	{
		H = rv_largo * 2 + rv_separa + rv_holgura ; 
		cilindro(d=correccion(rv_diametro + .3), h=H+mp, t=[0,0,H/2+mp/2+rv_base] );
	}
	// no procede hacer una corrección a vv_pasante porque su valor puede coincidir con apertura_rv y quedaría mal un ensanche adicional
	cilindro(d=vv_pasante, h=mucho, t=[0,0,cuerpo_dz/2]);
	cilindro(d=vr_pasante_corregido, h=mucho, t=[signo_lado * vr_desplazamiento,0,cuerpo_dz/2]);
	cubo(t=[-signo_lado*(vv_sobresale_cuerpo/2+mp), 0, cuerpo_dz/2], c=[vv_sobresale_cuerpo, apertura_rv, cuerpo_dz+mp]);
	alojamiento_acoplamiento(ac_profundidad);

	// agujeros pasantes para las bridas de las varillas horizontales
	if (completo + hacer_bridas) 
		for ( brida =[ 0, 1 ] ) {
			lado_brida = [vh_bridai_x,vh_bridad_x][derecha] ;
			for ( altura = [0, 1] ) 
				translate([lado_brida[brida],0,vh_brida_z[altura]]) 
					difference() {				
						cubo(c=[vh_brida_dx[brida], mucho, vh_brida_dz[brida]]);
						if (vh_brida_soporte) 
							cubo(c=[ancho_soporte_brida(vh_brida_dx[brida]), vh_hueco, vh_brida_dz[brida]-gapplasop*2]);
						else if ( (brida == 0) * fabricar)
							cubo(c=[vh_brida_dx[brida]-2*sephsop, 4, vh_brida_dz[brida]-gapplasop*2]);
					}
			for ( lado = [-1, 1] )
				cubo([vh_brida_dx[brida], mucho, vh_diametro/2], t=[lado_brida[brida],lado*(mucho+vh_hueco)/2,vh_brida_z[1]+vh_brida_dz[1]/2+vh_diametro/4]);
		}
	
	
	// y para las bridas de los rodamientos verticales
	if (completo + hacer_bridas)
		for ( Z = vv_brida_z ) {
			translate([signo_lado*(vv_diametro_trayectoria-rv_diametro_reducido-vv_brida[1])/2, 0, Z])
				difference() {
					cilindro(d=vv_diametro_trayectoria+vv_brida[1], h=vv_brida[0]);
					cubo(mucho, t=[signo_lado*mucho/2, 0, 0]);
					cilindro(d=vv_diametro_trayectoria-vv_brida[1], h=vv_brida[0]+mp);
				}
		}

	if (completo + hacer_endstop_apoyo)
		translate([signo_lado*vr_desplazamiento, mucho/2, 0])
			difference(){
				union(){
					cubo([mmr_hueco[1], mucho, mmr_hueco[2]], t=[0,0, sedZ_techo - mmr_hueco[2]/2]);
					cubo([mmr_conectores[0], mucho, mmr_conectores[1]+mp], t=[0, 0, sedZ_techo-mmr_hueco[2]-mmr_conectores[1]/2+mp/2]);
					// un rebaje para que entre una brida que se pone a modo de asa en el agujero exterior del mmr
					// el rebaje lo hago quitando un cubo de alto doble al que le quito la parte superior con un ángulo de voladizo
					translate([0,vr_diametro/2+sedZ_holgura+sedZ_asa_deja_entrar,sedZ_techo-mmr_agujero_altura+sedZ_asa_alto/2])
						difference() {
							cubo([sedZ_asa_ancho, mucho, sedZ_asa_alto*2]);
							for ( lado = [-1, 1 ] ) 
								translate([lado * sedZ_asa_ancho/2,0,0]) 
									cubo([mucho,mucho+mp,mucho], r=[0,lado * -voladizo,0], t=[lado * mucho/2,0,0]);
						}
				}
				if (fabricar) {
					altosoporte = mmr_hueco[2]+mmr_conectores[1]-2*gapplasop ;
					cubo([2, mucho+mp, altosoporte], t=[0, 0, sedZ_techo-altosoporte/2-gapplasop]);
				}
			}				
		
}


module alojamiento_acoplamiento(penetracion) {
	alto_cono=(ac_diametro/2)/tan(voladizo);
	alto_total=alto_cono + ac_profundidad;
	alto_cascoporro=alto_cono + mucho;
	
	translate([signo_lado*vr_desplazamiento, 0, 0])
		intersection() {
			translate([0,0,alto_cono - alto_cascoporro/2 + penetracion])
				cylinder(d1=2*alto_cascoporro*tan(voladizo), d2=0, h=alto_cascoporro, center=true, $fn=fn(ac_diametro));
			cilindro(d=ac_diametro, h=mucho, t=[0,0,(mucho-mp)/2]);
		}
}


module sedX(poner) {
	// detector de desorden mecánico: un apoyo para el mmr con agujero para brida, y 2 guías para un taqué
	dY = (vh_hueco + vh_diametro - cuerpo_dy - mmr_hueco[1])/2 ;
	dZ = mmr_hueco[0]+(dY+mp)*tan(vh_cacha_caida);
	
	hasta_el_borde = redondeo;
	aisla_agujeros = 1 ; // distancia entre agujeros para evitar interferencias
	
	base_y0 = cuerpo_dy/2 ;
	base_y1 = (vh_hueco + vh_diametro - mmr_hueco[1]) / 2 + sedX_abrazo_mmr;
	base_y = (base_y0+base_y1)/2 ;
	base_dy = base_y1 - base_y0; 
	base_dz = mmr_agujero_descentre *2 + mmr_agujero_pincho;
	base_z =  vh_z - vh_diametro/2 - mmr_hueco[0]/2 - mmr_agujero_descentre - mmr_agujero_pincho/2;
	base_x0 = derecha ? (hasta_el_borde - cuerpod_dxs - cuerpo_Xi) : (sedX_x - mmr_hueco[2] - sedX_abrazo_mmr);
	base_x1 = derecha ? (sedX_x + mmr_hueco[2] + sedX_abrazo_mmr) : (cuerpoi_dx + cuerpo_Xi - hasta_el_borde);
	base_dx = base_x1 - base_x0;
	base_x = (base_x1+base_x0)/2 ;
	pos_mmr = [signo_lado * (sedX_abrazo_mmr+(mmr_hueco[2]-base_dx)/2),(base_dy+mmr_hueco[1])/2-sedX_abrazo_mmr,base_dz/2];
	vastago_z = base_dz/2+mmr[0]/2-mmr_pulsador;
	vastago_dx = base_x1-base_x0-(sedX_abrazo_mmr+mmr_hueco[2]);
	loquesemete = derecha ? 0 : (n17_tornillo_desplazato - (posicion_motor[0]-(cuerpoi_dx+cuerpo_Xi)) - hasta_el_borde + n17_tornillo_cabeza/2);
	brida_x = ([vh_bridai_x,vh_bridad_x][derecha])[0] + signo_lado * ((vh_brida_dx[0] + sedX_brida[0])/2 + aisla_agujeros) - base_x;
	pincho_x = [signo_lado * (sedX_abrazo_mmr+mmr_hueco[2]-mmr_agujero_altura-base_dx/2) , derecha ? (hasta_el_borde + (sedX_agujero[0] - base_dx)/2) : (posicion_motor[0]-n17_lado/2 - (sedX_agujero[0]/2+sedX_pincho_aleja_motor) -base_x)];

	
	if (poner) {
		translate(fabricar ? [base_x,35,0]:[base_x, base_y, base_z])
			difference() {
				union() {
					// paralelepipedo que forma la base, con descuentos para el mmr y una brida que lo sujeta al cuerpo
					difference() {
						cubo([base_dx-loquesemete, base_dy, base_dz], t=[-loquesemete/2,0, base_dz/2]);
						difference() {
							translate([0,(vh_hueco+vh_diametro-cuerpo_dy-base_dy)/2,(base_dz+mmr_hueco[0])/2 - sedX_holgura_cacha/sin(vh_cacha_caida)])
								cubo(mucho, t=[0,-mucho/2,-mucho/2], r=[-vh_cacha_caida,0,0]);
							cubo([mmr[2], mucho, mucho], t=[pos_mmr[0],base_dy/2-sedX_abrazo_mmr+mmr_hueco[1]/2-vh_diametro/2+sedX_holgura_cacha+mucho/2,mucho/2]);
						}
						cubo([mmr_hueco[2], mmr_hueco[1], mmr_hueco[0]], t=pos_mmr);
						cubo([sedX_brida[0], mucho, mucho], t=[brida_x,0,(vh_cacha_z_inf-base_z-mucho)/2], r=[-asin((vh_cacha_z_inf-base_z)/base_dy),0,0]);
						cubo([sedX_brida[0], mucho, mucho], t=[brida_x,(sedX_brida[1]-base_dy-mucho)/2,0]);
					}
					// dos pinchos para el mmr, con su soporte
					{	pos_pincho = [signo_lado * (mmr_hueco[2]/2-mmr_agujero_altura),mmr_agujero_pincho_sale/2,0]+pos_mmr ;
						for ( lado = [-1,1] )																											   
							cubo([mmr_agujero_pincho, mmr_hueco[1]+mmr_agujero_pincho_sale+mp, mmr_agujero_pincho], t=pos_pincho-[0,mp/2,mmr_agujero_descentre * lado]);
						if (fabricar)
							cubo([mmr_agujero_pincho, mmr_hueco[1]+mmr_agujero_pincho_sale-sephsop, (mmr_agujero_descentre-gapplasop)*2-mmr_agujero_pincho], t=pos_pincho+[0,sephsop/2,0]);
					}
					// una vaina para el vastago, que no sea muy fea (aunque no se verá)
					difference() {
						translate([signo_lado * (sedX_abrazo_mmr+mmr_hueco[2])/2,base_dy/2,vastago_z]) 
							intersection() {
								achatamiento_ovalo_guia = 1.15 ;
								desplazamiento_ovalo_recorte = 2 ;
								cilindro(d=vastago_z * 2, h=vastago_dx, r=[0,90,0], s=[achatamiento_ovalo_guia,(mmr_hueco[1]-sedX_abrazo_mmr)/vastago_z,1]);
								cilindro(d=vastago_z * 2, h=vastago_dx, r=[0,90,0], s=[achatamiento_ovalo_guia,(mmr_hueco[1]-sedX_abrazo_mmr)/vastago_z,1], t=[0,desplazamiento_ovalo_recorte,0]);
							}						
						cubo(mucho, t=[0,0,-mucho/2]);
						cubo(mucho, t=[0,0,base_dz+mucho/2]);
					}
						
					// dos pinchos que entran en el cuerpo
					{	un_poco_mas =  1 ; // hace falta más pincho, por la interferencia con el "tejado" de la base (si sedX_pincho[2]>1.8)
						translate([0,-(sedX_pincho[1]+base_dy-un_poco_mas)/2,sedX_pincho[2]/2]) 
							for (indice = [ 0, 1 ] )
								cubo(correccion( sedX_pincho + [0, un_poco_mas, 0] ), t=[pincho_x[indice],0,0]);
					}
					
				}
				// agujero para el vastago, abierto por arriba
				cilindro(d=sedX_vastago_hueco, h=vastago_dx+mp, r=[0,90,0], t=[signo_lado * (sedX_abrazo_mmr+mmr_hueco[2])/2,base_dy/2-sedX_abrazo_mmr+mmr_hueco[1]/2,vastago_z]);
				cubo([vastago_dx+mp, sedX_vastago_hueco/2, sedX_vastago_hueco], t=[signo_lado * (sedX_abrazo_mmr+mmr_hueco[2])/2,base_dy/2-sedX_abrazo_mmr+mmr_hueco[1]/2,vastago_z+sedX_vastago_hueco/2]);
			}
	} else {
		cubo([mmr_hueco[2], mucho, mmr_hueco[0]*2], t=[sedX_x-signo_lado*(mmr_hueco[2]/2-mmp), (mucho+vh_hueco)/2, vh_z-mmr_hueco[0]]);
		cubo([sedX_brida[0], sedX_brida[1], mucho], t=[brida_x + base_x, (cuerpo_dy + sedX_brida[1])/2, mucho/2 + vh_cacha_z_inf - mp]);
		recorte = (sedX_brida[1]+sedX_brida_chaflan)/tan(vh_cacha_caida) ;
		cubo([sedX_brida[0], mucho, recorte], t=[brida_x + base_x, (cuerpo_dy+mucho+sedX_brida[1])/2, vh_cacha_z_inf-recorte/2 + recorte]);
		translate([base_x,(cuerpo_dy-sedX_agujero[1]+mmp)/2,base_z + sedX_pincho[2]/2])
			for ( indice = [0, 1] )
				cubo(sedX_agujero, t=[pincho_x[indice],0,0]);
	}
}



//   ##                              ##                      ###                  
//                                                            ##                  
//  ###    ######  ### ## ##  ##    ###     ####  ## ###      ##   ####           
//   ##    #  ##  ##  ##  ##  ##     ##    ##  ##  ### ##  #####      ##          
//   ##      ##   ##  ##  ##  ##     ##    ######  ##  ## ##  ##   #####          
//   ##     ##  #  #####  ##  ##     ##    ##      ##     ##  ##  ##  ##          
//  ####   ######     ##   ### ##   ####    ####  ####     ### ##  ### ##         
//                   ####                                                         

module cuerpo_izquierdo() {
	cubo(t=[cuerpoi_dx/2+cuerpo_Xi,0,cuerpo_dz/2], c=[cuerpoi_dx,cuerpo_dy,cuerpo_dz], esquinas=15);
	if (completo + hacer_cacha_motor)
		difference() {
			saliente_dz = posicion_motor[2]-n17_d_boina/2*cos(angulo_motor) ;
			// la cacha está hecha en 2 partes para lograr que quede bien el redondeo del canto donde se une la cacha con el cuerpo
			translate([posicion_motor[0] + n17_lado/2 - cacha_dx/2, proyeccion_del_motor_en_la_base+cacha_dy, 0])
				union(){
					dxcs = cuerpoi_dx+cuerpo_Xi-(posicion_motor[0]+n17_lado/2-cacha_dx) ;
					cubo(c=[dxcs, cacha_dy*2, cuerpo_dz], r=[angulo_motor,0,0], t=[(dxcs-cacha_dx)/2,-cacha_dy,cuerpo_dz/2], esquinas=9);
					cubo(c=[cacha_dx, cacha_dy*2, n17_lado/2], r=[angulo_motor,0,0], t=[0,-cacha_dy,n17_lado/2/2], esquinas=9);
				}
			// rematar la cacha por debajo
			cubo(c=mucho, t=[mucho/2,0,-mucho/2]);
			// quitar lo que sobra en Z del saliente
			cubo(mucho, t=[posicion_motor[0]+mucho/2, 0, mucho/2 + saliente_dz]);
			// quitar un pico feo
			cilindro(d=n17_d_boina, h=mucho, r=[90,0,0], t=[posicion_motor[0], 0, saliente_dz + n17_d_boina/2]);
		}

		// endstops
		if (completo + hacer_endstops_XZ) {
			seZ();
			seX();
		}
	
	// cachas para situar las varillas horizontales
	if (completo + hacer_cachas_vh)
		difference() {
			cubo(c=[cuerpoi_dx-redondeo*2,vh_hueco+2*vh_diametro,vh_z], t=[cuerpoi_dx/2+cuerpo_Xi,0, vh_cacha_z_sup-vh_z/2]);
			for ( lado = [-1, 1] ) {
				translate([0, lado*cuerpo_dy/2, vh_cacha_z_inf]) cubo(c=mucho, t=[0,lado*mucho/2,0], r=[-lado*vh_cacha_caida, 0, 0]);
				cilindro(d=vh_diametro, h=mucho, t=[cuerpoi_dx/2+cuerpo_Xi, lado * (vh_hueco+vh_diametro)/2, vh_z], r=[0,90,00]);
				// achaflanar los cantos (si estos chaflanes se quitan, hay un error por  "2-manifold" de un resto que queda de un cubo anterior tras hacerle recortes)
				cubo(mucho, t=[0, lado*((mucho+vh_hueco+vh_diametro)/2-vh_cacha_chaflan), mucho/2]);
				cubo(mucho, t=[0,lado*((mucho+vh_hueco+vh_diametro)/2- (vh_diametro/2*cos(asin((vh_cacha_z_sup-vh_z)/(vh_diametro/2)))) -vh_cacha_chaflan),vh_z+mucho/2]);

			}
		}
}

module motor() {
	translate(posicion_motor)
		rotate([angulo_motor - 90,0,0]) {
			intersection() {
				cubo([n17_lado, n17_lado, n17_largo], t=[0,0,-n17_largo/2]);
				cubo(c=[n17_diagonal, n17_diagonal, mucho], r=[0,0,45]);
			}
			cubo([mucho, mucho, n17_largo], t=[(mucho-n17_lado)/2,mucho/2,-n17_largo/2]);
			cilindro(d=n17_d_boina, h=n17_h_boina + mp, t=[0, 0, n17_h_boina / 2 - mp/2]);
			for (i = [0, 90, 180])
				rotate([0,0,i]) 
					cilindro(d=n17_tornillo_diametro, h=mucho, t=[n17_tornillo_desplazato,n17_tornillo_desplazato,mucho/2-mp]);
		}
}

module soporte_hueco_motor() {
	dx = cuerpoi_dx-(posicion_motor[0]-n17_lado/2)+cuerpo_Xi  -  ((voladizo<45) ? sephsop/2 : n17_chaflan );
	dy = cuerpo_dy/2+posicion_motor[1]-(n17_lado/2)*sin(angulo_motor)-sephsop/3 ;
	dz = mucho;
	
	module prisma(lleno=1) {
		translate([cuerpoi_dx+cuerpo_Xi-dx/2,dy/2-cuerpo_dy/2,dz/2])
			if (lleno)
				cubo(c=[dx, dy, dz]);
			else	
				soporte_paralelo([dx, dy, dz], suela=true, sombrero=false);
	}
	
	intersection() {
		translate([0,0,-gapplasop]) 
			difference() {
				motor();
				translate([0,0,-groplasop])
					motor();
			}
		prisma();
	}	
	intersection() {
		translate([0,0,-groplasop]) 
			motor();
		prisma(lleno=0);
	}
	
	// dos tirantes interiores arriba, porque el fusor tiende a romper el soporte cuando empieza a hacer la parte horizontal
	for ( semete = [ 1, 6 ] )
		difference() {
			ppp = [4,1.5,5] ; 
			cubo(c=ppp, t=[cuerpoi_dx+cuerpo_Xi-dx - ppp[0]/2+mp,-cuerpo_dy/2+ppp[1]/2+semete,Z_canto_recorte_motor-gapplasop-groplasop-ppp[2]/2]);
			translate([cuerpoi_dx+cuerpo_Xi-dx, 0, Z_canto_recorte_motor-gapplasop-groplasop - (gapplasop+groplasop+.4)/tan(voladizo) - (semete+ppp[1])*sin(angulo_motor)])
				cubo(mucho, t=[-mucho/2,0,0], r=[0,-voladizo,0]);
		}
	
}

module seZ(poner=1) { // soporte endstop
	altobrida=seZ1_brida[1];

	if (poner) { // parte de poner
		dY = seZ_dy+cacha_dy-mp ;
		// este cubo necesita un soporte que se lo voy a poner al final, porque es más cómodo y fácil que hacerlo aqui
		cubo(c=[seZ1_dx, dY, seZ1_z[1]-seZ1_z[0]-seZ1_brida[1]], t=[seZ1_x, seZ_y-dY/2, (seZ1_z[0]+seZ1_z[1])/2]);
		difference() {
			cilindro(d=seZ2_peristoma, h=dY, t=[seZ2_x, seZ_y-dY/2, seZ2_z], r=[90,0,0]);
			cubo(mucho, t=[0,0,-mucho/2]);
		}		
	} else { // parte de quitar
		for( Z = seZ1_z )
			cubo(c=[seZ1_dx, mucho, seZ1_brida[1]], t=[seZ1_x, mucho/2, Z]);
		cubo(c=[seZ1_dx, seZ1_dy+mp, abs(seZ1_z[0]-seZ1_z[1])-seZ1_brida[1]+mp], t=[seZ1_x, hueco_cursor[1]/2+(seZ1_dy-mp)/2, (seZ1_z[0]+seZ1_z[1])/2]);
		cilindro(d=agj_rosca_M3, h=seZ2_penetra_tornillo+mp, t=[seZ2_x, seZ_y-(seZ2_penetra_tornillo-mp)/2, seZ2_z], r=[90,0,0]);
	}
}

module seX(poner=1) {
	for (Y = seX_y) 
		if (poner) {
				ppp=[seX_dx-agj_M3_h/2, seX_dy, seX_dz] ;
				cubo(c=ppp+[0,0,mp], t=[seX_x-seX_dx/2-agj_M3_h/4, Y, cuerpo_dz+(seX_dz-mp)/2]);
				translate([seX_x, Y, cuerpo_dz+(seX_dz-mp)/2])
					difference() { // si el agujero es estrecho al hacer ha rosca se despega el peristoma, así que renuncio a rosca en este tramo
						cilindro(d=seX_peristoma, h=seX_dz+mp);
						cilindro(d=agj_M3_h, h=seX_dz+2*mp);
					}
		} else
			cilindro(d=agj_rosca_M3_h, h=seX_penetra_tornillo+mp, t=[seX_x, Y, cuerpo_dz+seX_dz-(seX_penetra_tornillo-mp)/2]);
}


module apoyo_tv_izdo(modelo) {
	// modelo: 0-pieza (rebaje vertical para que quepa; 1-hueco (ensanchamiento horizontal para que quepa); 2-soporte (gap vertical suave y horizontal fuerte)
	plus = [0,.3,-2][modelo];
	alto = tv_alto_i - [$alto_de_capa, 0, 2*gapplasop][modelo];
	
	dy = cuerpo_dy/2 - hueco_cursor[1]/2 + cursor_lado_muelle_dy;
	dx = hueco_cursor[0] - tv_izdo_recorte_esquina + dy * tan(tv_izdo_angulo);
	translate([vri_x - dx/2 + hueco_cursor[0]/2, -(cuerpo_dy-dy)/2, tv_techo_i - tv_alto_i/2])
		difference() {
			mucho=(dy+5)/cos(tv_izdo_angulo) + mp;
			cubo([dx+2*plus, dy + (plus>0?mp:0), alto]);
			translate([dx/2-hueco_cursor[0]+tv_izdo_recorte_esquina-plus, dy/2, 0])	
				rotate([0,0,-tv_izdo_angulo]) 
					translate([-mucho,-mucho, -(tv_alto_i+mp)/2])
						cube([mucho, mucho, tv_alto_i+mp]);
			translate([dx/2-tv_izdo_recorte_esquina+plus, dy/2-cursor_lado_muelle_dy, 0])
				rotate([0,0,-tv_izdo_angulo]) 			
					translate([0,cursor_lado_muelle_dy-mucho, -(tv_alto_i+mp)/2])
						cube([mucho, mucho, tv_alto_i+mp]);
	}
}


//	     ###                                  ###                     
//	      ##                                   ##                     
//	      ##    ####  ## ###    ####    ####   ## ##   ####           
//	   #####   ##  ##  ### ##  ##  ##  ##  ##  ### ##     ##          
//	  ##  ##   ######  ##  ##  ######  ##      ##  ##  #####          
//	  ##  ##   ##      ##      ##      ##  ##  ##  ## ##  ##          
//	   ### ##   ####  ####      ####    ####  ###  ##  ### ##         


module cuerpo_derecho() {
	cubo(c=[cuerpod_dxs,cuerpo_dy,cuerpo_dzs+mp], t=[-cuerpod_dxs/2+cuerpo_Xd,0,cuerpo_dz - cuerpo_dzs/2-mp/2], esquinas=15);
	cubo(c=[cuerpod_dxi,cuerpo_dy,cuerpo_dzi], t=[-cuerpod_dxi/2+cuerpo_Xd,0,cuerpo_dzi/2], esquinas=15);
	
	// cachas para situar las varillas horizontales
	if (completo + hacer_cachas_vh)
		difference() {
			cubo(c=[cuerpod_dxs-redondeo,vh_hueco+2*vh_diametro,vh_z], t=[-cuerpod_dxs/2+cuerpo_Xd-redondeo/2,0, vh_cacha_z_sup-vh_z/2]);
			for ( lado = [-1, 1] ) {
				translate([0, lado*cuerpo_dy/2, vh_cacha_z_inf]) cubo(c=mucho, t=[0,lado*mucho/2,0], r=[-lado*vh_cacha_caida, 0, 0]);
				cilindro(d=vh_diametro, h=mucho, t=[-cuerpod_dxs/2+cuerpo_Xd, lado * (vh_hueco+vh_diametro)/2, vh_z], r=[0,90,00]);
				// achaflanar los cantos (si estos chaflanes se quitan, hay un error por  "2-manifold" de un resto que queda de un cubo anterior tras hacerle recortes)
				cubo(mucho, t=[0, lado*((mucho+vh_hueco+vh_diametro)/2-vh_cacha_chaflan), mucho/2]);
				cubo(mucho, t=[0,lado*((mucho+vh_hueco+vh_diametro)/2- (vh_diametro/2*cos(asin((vh_cacha_z_sup-vh_z)/(vh_diametro/2)))) -vh_cacha_chaflan),vh_z+mucho/2]);
			}
		}
	
}
