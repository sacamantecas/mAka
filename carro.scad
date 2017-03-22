///////////////////////////////////////////////////////////////////////////////////////////////////
//
// carro del eje X de mAka y sus accesorios
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luiso gutierrez (sacamantecas)
//
//
// capas de 1/3mm para el portataladro y de .2mm para el resto
//

fabricar = 0 ; // algunas partes se fabrican separadas
hacer_ventilador = 0 ;
hacer_carro = 0 ;
hacer_handler = 0 ;
hacer_ventila_fusor = 1 ;

hacer_portataladro = 0 ; // incompatible con el resto
	coger_volcan_hecho = 0 ;
hacer_suplemento_portalapiz = 0 ; 

hacer_anclaje = 0 ;	// anclaje del extrusor (reside en extrusor.scad)


completo=0 ; // para deshabilitar algunas cosas en depuración
	hacer_guias = 0 ; // guías visuales para ayudar al diseño
	hacer_bridas = 1 ;
	hacer_topes_rh = 1 ; // resaltes para fijar la posición de los rodamientos lineales
	hacer_soportes_complejos = fabricar ;
	
afeitado=0.25 * fabricar;
$alto_de_capa= hacer_portataladro ? .333 : .2 ;  // 1/3 para el suplemento de carro, .2 para el resto
$fa=1 ;
$fs=1 ;
	
use <extrusor.scad>
use <utilidades.scad>
module fantasma(rgb=[.8,.8,.8]) {color(rgb+[0,0,0,.3]) children();}


// coger variables de propósito general en el módulo de utilidades
voladizo=utilidades($angulo_voladizo);
gapplasop=utilidades($gap_v_soporte);
sephsop=utilidades($gap_h_soporte);
groplasop=utilidades($gro_pla_sop);
redondeo=utilidades($redondeo);
// el módulo de utilidades usará este espesor para los soportes (si no, aplica un defecto)
churrito_nominal = .5 ; 
$espesor=correccion(churrito_nominal  +  .09) ; // esto es para cálculos de los soportes, y es un valor experimental para que las paredes de un hilo queden bien

/*
                                                                          
                     #                       ##             ###           
                    ##                                       ##           
  ##  ##   ####    #####    ####  ## ###    ###    ####      ##           
  #######     ##    ##     ##  ##  ### ##    ##       ##     ##           
  #######  #####    ##     ######  ##  ##    ##    #####     ##           
  ## # ## ##  ##    ## #   ##      ##        ##   ##  ##     ##           
  ##   ##  ### ##    ##     ####  ####      ####   ### ##   ####          
                                                                        */

// parámetros del material:
vh_diametro = 10 ;
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
agj_M3_h = correccion(3 + .8) ; 
agj_M4_h = correccion(4 + .5) ; 
arandela_M3_d = 6 ;
arandela_M3_d_h = correccion(arandela_M3_d  +  .5);
tuerca_M3_d = 6.25 ;
tuerca_M3_h = 2.4 ;
tuerca_M3_h_h = correccion(tuerca_M3_h  +  .5) ;
tuerca_M3_d_h = correccion(tuerca_M3_d  +  .5) ;
function conector_modular(unidades) = correccion(unidades * 2.6 + .4);



// bridas: ancho, grueso, ancho cabeza (ya con algo de holgura)
brida48=[5, 1.5, 8];
brida35=[3.7, 1.5, 7];
brida25=[2.8, 1.3, 5];


// parametros globales de mAka
vh_hueco = 42 ;
angulo_motor = 10 ;
vh_distancia=vh_hueco + vh_diametro;
rh_hueco = vh_distancia - rh_diametro;

posicion_motor = [43,16,21.5] - [0,0,50] ; // 50 es el vh_z en el modulo X.scad, que aquí es 0
diametro_polea_con_correa = 14 ;
posicion_actual_polea = 12.5 ;
casquillo_correa_dx = 23 ;
casquillo_correa_diametro = 9.65 ;
casquillo_correa_plataforma_radio = 11.9 - casquillo_correa_diametro/2 ;
casquillo_correa_plataforma_ancho = 6.75 ;
anclajes_extrusor_dx = 54 ;
//borrar // contactos para el detector de sobrealimentacion
//borrar cds_contacto_x = -(anclajes_extrusor_dx/2 + 4) ; // 4mm más allá del agujero de anclaje y a 4mm del borde izquierdo
//borrar cds_contacto_y = 10.25 ; // a mitad del cuerno izquierdo del extrusor


// zócalo del fusor
zf_largo = 71 ;
zf_ancho = 28 ;
zf_redondeo = 6.5 ;
zf_semicirculo = 42 ;
zf_circulo = 40 ;
zf_circulo_alto = 3 ;
zf_placa_anclaje_dz = 6.3 ;
zf_altura_boquilla = -46.15 ;


// ventilador de capa (40x40mm)
vc_dy = 20 ;
vc_dx = 40 ;
vc_dz = 40 ;
vc_diametro = 38 ;
vc_se_mete_tornillo = 3.9 ;

// ventilador de cold-end (30x30mm)
ventilador_fusor_tamanio = [10,30,30];
ventilador_fusor_entre_tornillos = 24 ;
ventilador_fusor_hueco = 29 ;



/*                                                        
     ###     ##                                           
      ##                           #####                  
      ##    ###     #####   ####            ####          
   #####     ##    ##      ##  ##  #####   ##  ##         
  ##  ##     ##     ####   ######  ##  ##  ##  ##         
  ##  ##     ##        ##  ##      ##  ##  ##  ##         
   ### ##   ####   #####    ####   ##  ##   ####          
                                                        */


holganza_para_ver_mejor_el_motor = 20 ;



carro_xi = -47 ; // -47 es lo adecuado para que el carro accione el endstop mientras el fusor se acerca a 2mm del motor (hace falta 1mm para el detector de desorden)
carro_xf = 51 ; // 51 es lo necesario para que el motor casi-toque la varilla roscada mientras el carro casi-toque el X derecho
carro_dx = carro_xf - carro_xi ;
carro_x = (carro_xi + carro_xf) / 2 ; 
//carro_xi = carro_x - carro_dx/2 ;
//carro_xf = carro_x + carro_dx/2 ;


// plataforma principal
pp_dx=carro_dx;
pp_dy=vh_distancia + rh_diametro;
pp_dz=3 ;
pp_x = carro_x ;
pp_y = 0 ;
pp_z = corte_a_capa(rh_diametro / 2 + 6.5) ; // el corte a capa me facilita mucho las cosas más adelante (7 mm sobre el rodamiento maximiza el espacio: aprovechar los 5mm de hueco para los acoplamientos del motor en X, y bajar la cama 8mm)
pp_sobre = pp_z + pp_dz/2 ;
pp_bajos = pp_z - pp_dz/2 ;
pp_redondeo = 3 ;

// zocalos de los rodamientos
zr_abertura_brida = 5 ;
zr_brida = correccion(brida25  +  [.4, .4, .3]);
zr_alojamiento_cabeza_brida_dz = 6 ;
zr_alojamiento_cabeza_brida_z = pp_sobre -  zr_alojamiento_cabeza_brida_dz/2 - 1 ;
zr_alojamiento_cabeza_brida_dy = 4.5 ;
zr_agujero_filamento_desde = correccion( 4  +  .7 ) ;
zr_agujero_filamento_hasta = correccion( 3.6  +  .7 ) ;
zr_guia_accesorio_dz = 2.2 ; // altura de un canal que se hace para que entre el soporte del ventilador
zr_guia_accesorio_dx = 2 ; // profundidad de dicho canal
zr_guia_accesorio_holgura = .2 ;
zr_guia_accesorio_holgura_plus = .2 ;

// correa y handler
h_dx = casquillo_correa_dx +4 ;

correa_x = 0 *(carro_xi+rh_largo+h_dx/2 + .1 );
correa_y = posicion_motor[1] + posicion_actual_polea * cos(angulo_motor) - diametro_polea_con_correa/2 * sin(angulo_motor);
correa_z = posicion_motor[2] + posicion_actual_polea * sin(angulo_motor) + diametro_polea_con_correa/2 * cos(angulo_motor);

// handler (pieza que conecta el carro con la correa a través de una pieza de fijación)
h_x = correa_x;

hf_tornillo_z = correa_z + 10 ;
hf_margen_tornillo = 5 ;

h_dz = pp_bajos-correa_z + .8 ; // alargo un poco más allá de correa_z para que abrace mejor el casquillo
h_dy = (vh_diametro + rh_diametro) / 2 ;
h_agujero_de_vh = vh_diametro + 2 ; // hueco (en diámetro) que se deja para la varilla horizontal (sin que roce)
h_reborde_sujeta_casquillo = 2 ; // estrechamiento (en diametro) a los lados del alojamiento del casquillo, para que no se mueva
h_espesor_lengua_casquillo = $espesor*2 ; // el casquillo va arropado en el canto inferior por este grosor de filamento
h_plus_alto_brida=.8 ; // el recorrido de la brida es largo y retorcido, y prefiero que sea holgado para no tener que hacer fuerza
h_canal_brida=17 ; // diametro del hueco de la brida alrededor del casquillo
h_canal_manguera = 8 ; // canal central de las costillas, donde va la manguera de cables
h_bridas_manguera = [pp_bajos - 2 - zr_brida[0]/2, pp_bajos - h_dz + 11 + zr_brida[0]/2] ; // a cuánto quedan los agujeros de las bridas de los topes del costillar (arriba y abajo)
h_separa_tornillos = (pp_dx-rh_largo*2)/2;

h_enganche_dy = h_dy;
h_enganche_dx = correccion(zr_guia_accesorio_dx + zr_guia_accesorio_holgura); // es una profundidad: le añado la holgura
h_enganche_dz = zr_guia_accesorio_dz; // no hace falta quitar holgura, porque el bloque en sí ya la tiene descontada
h_enganche_tope_dy = 1 ;


// ventilador para el lado frío del fusor
sf_pared = 1 ;
sf_tornillo_dz = 5 ;
sf_circulo_dz = 6 ;
vf_orientacion = [0,30,0]; 
vf_posicion = [36,0,-10];
vf_tuercas_elec_x = carro_xf - 4.5 ;
vf_tuercas_elec_y = [0]; // Y de cada una de las tuercas que queramos
vf_tuercas_elec_dz = pp_dz - 1 ; // tiene que aguantar poca fuerza, con 1 mm es suficiente



// ventilador de capa con su soplador
sop_z_inferior = zf_altura_boquilla + 4 ;

// ventilador de capa
vc_x = pp_x ;
vc_y =-(vh_distancia+rh_diametro)/2 - vc_dy/2;
vc_z = sop_z_inferior + vc_dz/2;

// ventilador de capa con su soplador (continúa)
sop_piel_xy = 1 ;
sop_piel_z = 1.6 ;
sop_altura_tobera = 5.4 ;
sop_ovalo_conexion_y = -8 ;
sop_ovalo_conexion_yi = -vh_distancia/2 ;
sop_alargamiento = 13 ;
sop_ovalo_corte_tobera_dy = (sop_alargamiento + 3)*2 ;
sop_plus_abertura = 2 ; // para abrir más por debajo
sop_margen_dx_ovalo_corte_tobera = 4 ;
sop_canto_frontal_tobera = 1 ;
sop_aloja_rosca_abajo = 5 ; // arriba es más para dar una fuerza que abajo no es necesaria
sop_costilla_dz = 2 * $espesor ;
sop_costilla_dy = 4 * $espesor ;
sop_costilla_y = vc_y+vc_dy/2+sop_aloja_rosca_abajo + sop_costilla_dy/2 ;

// ventilador de capa: soporte
vcs_margen_vh = 1 ;
vcs_dy_min = sqrt(pow(vc_z+vc_dz/2,2)+pow(vc_y+vc_dy/2+vh_distancia/2,2))-vh_diametro/2-vcs_margen_vh ; 
vcs_enganche_dy = rh_diametro;
vcs_enganche_dx = correccion(zr_guia_accesorio_dx + zr_guia_accesorio_holgura); // es una profundidad: le añado la holgura
vcs_enganche_dz = zr_guia_accesorio_dz; // no hace falta quitar holgura, porque el bloque en sí ya la tiene descontada
vcx_enganche_tope_dy = 1 ;


// acoplamiento para el suplemento de carro
asc_x = carro_xi + 3/4 * rh_largo;
asc_dz = 4 ;


// variables importantes para el proceso, pero no para el afinado
mp= .1 ;
mmp=.001 ; // porque a veces mp resulta excesivo



/*                                                                                        
     ###                                                    ###     ###                   
      ##                                                     ##      ##                   
      ##    ####    #####  ####   ## ###  ## ###    ####     ##      ##     ####          
   #####   ##  ##  ##         ##   ### ##  ### ##  ##  ##    ##      ##    ##  ##         
  ##  ##   ######   ####   #####   ##  ##  ##  ##  ##  ##    ##      ##    ##  ##         
  ##  ##   ##          ## ##  ##   ##      ##      ##  ##    ##      ##    ##  ##         
   ### ##   ####   #####   ### ## ####    ####      ####    ####    ####    ####          
                                                                                        */

																						
																						
if (hacer_guias) 
	fantasma()
		render() 
			elementos_guia(); 
		
		
if (hacer_anclaje) 
	translate(fabricar?[0,60,0]:[0,0, pp_sobre])
		difference() {
			// no interesa afeitar, porque va pegado al cuerpo
			cuerpo(hacer_soportes=hacer_soportes_complejos);
			trama_anclaje();
		}
		


if (hacer_ventilador) {
	t = fabricar ? [4,75,vc_dz/2-vc_x]:[0,0,0] ;
	r = fabricar ? [0,-90,0]:[0,0,0] ;
	afeita(fabricar * afeitado)
		translate(t) 
			rotate(r) 
				ventilador_capa();
	// mini-apoyo puesto a ojo para un arco de filamento que se echaría en vacío si no estuviera (misma posicion, fuera de afeitado)
	if (fabricar)
		translate(t) 
			rotate(r) {
				ancho=vcs_enganche_dx - gapplasop ;
				cubo([ancho, vcs_enganche_dy/2-vcx_enganche_tope_dy-sephsop, $espesor], [vc_x-vc_dx/2+ancho/2,vc_y+vcx_enganche_tope_dy+sephsop+(vc_dy+vcs_enganche_dy/2-vcx_enganche_tope_dy)/2, correccion(pp_bajos-vcs_enganche_dz-vcs_enganche_dx/tan(voladizo)  -  1)]);
			}
}


if (hacer_carro)
	difference() {
		afeita(fabricar * afeitado)	
			translate(fabricar?[0,0,pp_sobre]:[0,0,0]) rotate(fabricar?[0,180,0]:[0,0,0])
				difference() {
					union() {
						cubo([pp_dx, pp_dy, pp_dz], t=[pp_x, pp_y, pp_z], $redondeo=pp_redondeo, esquinas=15);			
						
						render()
							union() {
								zocalos(poner=1);
								// hacer dos guías para el soporte del ventilador
								difference() {
									for (lado_y = [-1, 1] )
										for (lado_x = [ -1, 1 ] ) 
											difference() {
												mavaleuqzobre = zr_guia_accesorio_dz*10 ;
												largo = [h_dy,0,rh_diametro][lado_y+1] ;
												cubo([zr_guia_accesorio_dx+mp, largo-vcx_enganche_tope_dy, mavaleuqzobre],[pp_x+lado_x*(pp_dx/2-rh_largo-zr_guia_accesorio_dx/2), lado_y*(largo-pp_dy+vcx_enganche_tope_dy)/2, pp_bajos-2*zr_guia_accesorio_dz-zr_guia_accesorio_dz*sin(voladizo)+mavaleuqzobre/2]);
												translate([pp_x+lado_x*(pp_dx/2-rh_largo-zr_guia_accesorio_dx), lado_y * -vh_distancia/2, pp_bajos-zr_guia_accesorio_dz-zr_guia_accesorio_dz*sin(voladizo)])
													cubo(rh_largo, t=[-lado_x * rh_largo/2, 0, rh_largo/2], r=[0,lado_x*voladizo,0]);
											}
								}
							}
					}					

					// abertura para conexiones y tornillos de fijación del handler
					cubo([pp_dx - 2*rh_largo, (vh_hueco - zf_ancho)/2, pp_dz+mp], [pp_x,(vh_hueco + zf_ancho)/4,pp_z], esquinas=15);
					for ( lado = [-1, 1] )
						cilindro(d=agj_M3_h, h=pp_dz+mp, t=[pp_x + lado * h_separa_tornillos/2,vh_distancia/2,pp_z]);
					
					// el agujero para el filamento va a ser cónico, los otros agujeros no (2 para pernos y 3 de centrado
					translate([0,0,pp_z]) cylinder(d1=zr_agujero_filamento_hasta, d2=zr_agujero_filamento_desde, h=pp_dz+mp, $fn=fn(zr_agujero_filamento_desde), center=true);
					
					// agujeros para atornillar el fusor y el lado izquierdo del extrusor
					for (lado = [-1, 1]) 
						cilindro(d=agj_M4_h, h=pp_dz+mp, t=[lado * anclajes_extrusor_dx/2, 0, pp_z]);

					// agujeros para una tuerca a la que atornillar desde abajo el regulador del ventilador de capa
					for (y = vf_tuercas_elec_y) {
						translate([vf_tuercas_elec_x, y, pp_sobre - vf_tuercas_elec_dz]) {
							rotate([0,0,30])
								cylinder(d=tuerca_M3_d_h, h=vf_tuercas_elec_dz+mp, $fn=6);
							translate([0,0,-vf_tuercas_elec_dz])
								cylinder(d=agj_M3_h, h=pp_dz);
						}
					}					
					// agujeros para 2 tuercas a las que atornillar desde arriba el suplemento para la dremel
					for ( Y = [-1,1] * vh_distancia/2) {
						translate([asc_x, Y, 0]) {
							cylinder(d=tuerca_M3_d_h, h=rh_diametro/2 + asc_dz, $fn=6);
							cylinder(d=agj_M3_h, h=pp_sobre + mp);
						}
					}
					// parte de quitar dependiente de los zócalos
					render()
						zocalos(poner=0);
				}
		rotate(fabricar?[0,180,0]:[0,0,0]) trama_anclaje();
	}
			
			
if (hacer_handler) {
	t = fabricar?[-34,23,pp_dx/2-rh_largo-zr_guia_accesorio_holgura/2-pp_x]:[0,0,0] ;
	r = fabricar?[0,-90,0]:[0,0,0] ; 
	afeita(fabricar * afeitado)	
		translate(t) rotate(r)
			handler();
	if (fabricar)
		translate(t) rotate(r) {
			largo = h_dy-h_enganche_tope_dy-.5 ;
			cubo([h_enganche_dx-gapplasop,largo,$espesor], [carro_xi+rh_largo+zr_guia_accesorio_holgura/2+(h_enganche_dx-gapplasop)/2,correccion(pp_dy/2-largo/2-h_enganche_tope_dy  -  .6),correccion(pp_bajos+zr_guia_accesorio_holgura-$espesor/2-h_enganche_dz-h_enganche_dx/tan(voladizo)  -  .6)]);
	}	
}		
			
			
if (hacer_ventila_fusor)
	afeita(fabricar*afeitado)
		translate(fabricar?[-25,76,0]:[0,0,0])
			rotate(fabricar?([0,90,0]-vf_orientacion):[0,0,0])	
				translate(fabricar?(-vf_posicion-[0,0,10]):[0,0,0]) 
					ventila_fusor();


if (hacer_portataladro) {
	rotate(fabricar?[180,0,0]:[0,0,0])	
		translate(fabricar?[0,0,-bloque_dz]-mh_offset:[0,0,0])
			suplemento();
	afeita(fabricar * afeitado)
		rotate(fabricar?[0,90,0]:[0,0,0])	
			translate(fabricar?[-fijacion_dx-bloque_xi-mh_offset[0],0,-65]:[0,0,0])
				fijacion();
	}
	
if (hacer_suplemento_portalapiz) {
	// cuerpo
	translate(fabricar?[15,vh_hueco/2,mh_offset[2] - pl_grosor_placa_aluminio]:[0,0,0])
		rotate(fabricar?[0,180,0]:[0,0,0])
			portalapiz();
	// guía		
	translate(fabricar?[90,-22,0]:mh_offset + [0,0,-pl_grosor_placa_aluminio-pl_dz-gl_separacion_elastica_dz-gl_dz])
		rotate([0,0,0])
			guialapiz();			
	// super-arandela
	translate(fabricar?[-mh_offset[0],-20,0]:mh_offset)
		difference() {		
			cylinder(d=pl_pasalapiz_d + 4, h=9);
			translate([0,0,-mp/2])
				cylinder(d=pl_pasalapiz_d, h=9 + mp);
		}
	// cono que aprieta
	translate(fabricar?[50-mh_offset[0],20,0]:(mh_offset + [0,0,90])) 
		embudo_empuje();
		
	translate(fabricar?[50-mh_offset[0],-30,0]:(mh_offset + [0,0,130])) 
		rotate([fabricar?0:180,0,0])
		pastilla_empuje();
		
}
/*                                                                      
        @@@                        @@@    @@@                           
         @@                         @@     @@                           
         @@ @@   @@@@    @@@@@      @@     @@     @@@@  @@ @@@          
         @@@ @@     @@   @@  @@  @@@@@     @@    @@  @@  @@@ @@         
         @@  @@  @@@@@   @@  @@ @@  @@     @@    @@@@@@  @@  @@         
         @@  @@ @@  @@   @@  @@ @@  @@     @@    @@      @@             
        @@@  @@  @@@ @@  @@  @@  @@@ @@   @@@@    @@@@  @@@@            
                                                                      */


	
module handler() {
	// el handler tiene un alojamiento para el casquillo de unión de la correa, que tiene rebordes a los lados encargados de garantizar que no haya backslash
	agujero_casquillo_d = correccion(casquillo_correa_diametro  +  .3);
	agujero_casquillo_dx = correccion(casquillo_correa_dx  +  .4) ;
	agujero_casquillo_reborde = correccion(agujero_casquillo_d  -  h_reborde_sujeta_casquillo) ;
	Y = pp_dy/2 - h_dy/2 ;	
	Yv = vh_distancia/2 ;
	corte_lateral_desde_z = pp_bajos-2*h_enganche_dz-h_enganche_dx/tan(voladizo) - 1;
	corte_lateral_hasta_z = correa_z ;
	mucho=h_dx*2 ;
		
	
	module bloque() { 
		a1 = (Y+h_dy/2-(correa_y+agujero_casquillo_d/2+h_espesor_lengua_casquillo)) ; // semieje menor del óvalo de redondeo del bloque
		b1=(h_dz-pp_bajos) ; // excentricidad del óvalo anterior
		
		difference() {
			cubo([pp_dx-2*rh_largo-zr_guia_accesorio_holgura, h_dy, h_dz-(zr_guia_accesorio_holgura+zr_guia_accesorio_holgura_plus)], t=[pp_x, Y, pp_bajos - (h_dz + zr_guia_accesorio_holgura+zr_guia_accesorio_holgura_plus)/2]);
			// lado izquierdo (de apoyo)
			translate([0,Y,0]) {
				ancho = 2*((h_x-h_dx/2)-(carro_xi+rh_largo)) ;
				recortillo = 1 ;
				difference() {
					cilindro(d=ancho, h=h_dy+mp, t=[h_x-h_dx/2-ancho/2,0,corte_lateral_hasta_z], r=[90,0,0], s=[1,(corte_lateral_desde_z-corte_lateral_hasta_z)/(ancho/2),1]);
					if (completo + hacer_soportes_complejos)
						difference() {
							cilindro(d=ancho-2*gapplasop, h=h_dy+mp, t=[h_x-h_dx/2-ancho/2,0,corte_lateral_hasta_z], r=[90,0,0], s=[1,(corte_lateral_desde_z-corte_lateral_hasta_z-gapplasop)/((ancho-2*gapplasop)/2),1]);
							cubo([ancho,h_dy+mp,recortillo], t=[h_x-(h_dx+ancho)/2, 0, corte_lateral_desde_z-recortillo/2]);
						}
				}
			}
			// lado derecho
			translate([0,Y,0]) {		
				ancho = 2*((carro_xf-rh_largo)-(h_x+h_dx/2)) ;
				cilindro(d=ancho, h=h_dy+mp, t=[h_x+h_dx/2+ancho/2,0,corte_lateral_hasta_z], r=[90,0,0], s=[1,(corte_lateral_desde_z-corte_lateral_hasta_z)/(ancho/2),1]);
			}
			
			// remate inferior
			difference() {
				cubo([mucho, a1+mp, b1+mp], t=[h_x, Y+(h_dy-a1+mp)/2, -(b1+mp)/2]);
				cilindro(d=2*a1, h=mucho, t=[h_x,Y+h_dy/2-a1, 0], r=[0,90,0], s=[b1/a1,1,1]);
			}
			
			for ( lado=[-1,1] )	{
				mucho = h_dy + mp ;
				dZv = h_enganche_dx / tan(voladizo) ;
				Y = -(mucho/2+vc_y+vc_dy/2+vcx_enganche_tope_dy) ;
				difference() {		
					cubo([h_enganche_dx+mp, mucho, h_enganche_dz+dZv], [vc_x+lado*(vc_dx-h_enganche_dx+mp)/2,Y,pp_bajos-(h_enganche_dz+dZv)/2-h_enganche_dz]);
					translate([vc_x+lado*(vc_dx-zr_guia_accesorio_holgura)/2,Y,pp_bajos-h_enganche_dz])
						cubo(mucho, [-lado*mucho/2,0,mucho/2],r=[0,lado*(voladizo-90),0]);
				}			
			}
		}
	}

	
	module casquillo(vertical=0) {
		facetas = fn(agujero_casquillo_d);
		translate([h_x,correa_y, correa_z])
			rotate([0,90,0])
				cylinder(d=agujero_casquillo_reborde, h=h_dx + 10*mp, center=true, $fn=facetas);
		if (vertical)
			translate([h_x-agujero_casquillo_dx/2,correa_y, correa_z])
				rotate([0,90,0])
					intersection() {
						base = tan(voladizo)*2*agujero_casquillo_dx+agujero_casquillo_reborde ;
						cylinder(d1=base, d2=0, h=base/(2*tan(voladizo)), $fn=facetas);
						cylinder(d=agujero_casquillo_d, h=agujero_casquillo_dx, $fn=facetas);
					}
		else
			cilindro(d=agujero_casquillo_d, h=agujero_casquillo_dx+1, t=[h_x,correa_y, correa_z], r=[0,90,0]);

		// el agujero del casquillo estrecha muy ligeramente, y se nota si no lo arreglo con el siguiente cubo (para cuando una pieza coge más de medio casquillo)
		*cubo([casquillo_correa_dx, agujero_casquillo_d, agujero_casquillo_d], t=[h_x,correa_y, correa_z-agujero_casquillo_d/2]);
		// pieza de los tornillos (no hace falta con el diseño actual)
		*translate([correa_x,correa_y, correa_z])
			rotate([0,90,0]) 
				cubo([casquillo_correa_plataforma_radio, casquillo_correa_plataforma_ancho+hf_holgura, h_dx+mp], t=[casquillo_correa_plataforma_radio/2,0,0], r=[0,0,angulo_motor]);
	}
	
	difference() {
		// bloque principal, al que se le van descontando cosas
		bloque();

		// cilindro para la varilla horizontal
		excentricidad=1.7 ;
		difference() {
			cilindro(d=h_agujero_de_vh, h=mucho, t=[h_x,Yv,0], r=[0,90,0], s=[excentricidad,1,1]);
			cubo([mucho,h_agujero_de_vh+mp,pp_bajos], [h_x, Yv, (pp_bajos+mp)/2]);
		}
		// conexión en voladizo entre el agujero para la varilla y lo que envuelve el casquillo
		bvh = excentricidad * (h_agujero_de_vh/2) ; 
		dY = sqrt(1/(pow(bvh*tan(voladizo)/pow(h_agujero_de_vh/2,2),2)+1/pow(h_agujero_de_vh/2,2))) ;

		translate([h_x,Yv+dY, -bvh*sqrt(1-pow(dY/(h_agujero_de_vh/2),2))])
			cubo([mucho, h_dy, h_dz], t=[0,-h_dy/2, h_dz/2], r=[90-voladizo,0,0]);
		a = agujero_casquillo_d/2+h_espesor_lengua_casquillo ;
		h = -correa_z -(bvh*sqrt(1-pow(dY/(h_agujero_de_vh/2),2)) + (Yv-correa_y+agujero_casquillo_d/2+h_espesor_lengua_casquillo+dY)/tan(voladizo)) ;
		x = a*a/(a+h*tan(voladizo)) ;
		b = a*a*sqrt(1-x*x/(a*a))/(tan(voladizo)*x) ;
		difference() {
			cubo([mucho,a,b], t=[h_x,correa_y-a/2-x,correa_z+b/2]);
			cilindro(d=agujero_casquillo_d+2*h_espesor_lengua_casquillo, h=mucho, t=[h_x,correa_y, correa_z], r=[0,90,0], s=[b/a,1,1]);
		}
						
		// recorte interior para que no tropiece con el fusor (las dimensiones no importan mucho, la colocación si
		cubo([mucho, h_dy, h_dz], t=[h_x,correa_y-h_dy/2-agujero_casquillo_d/2 - h_espesor_lengua_casquillo,-h_dz/2]);
		
		casquillo(1);		
		
		// union a los bajos de la plataforma
		difference() {	
			ac = h_enganche_dy+h_agujero_de_vh ;
			cilindro(d=ac, h=mucho, t=[h_x,Yv-h_enganche_dy/2,0], r=[0,90,0], s=[((pp_bajos - h_enganche_dz - h_enganche_dx/tan(voladizo))*2)/ac,1,1]);
			cubo([mucho, h_dy, pp_bajos*2], t=[h_x,Y,-pp_bajos]);
		}

		// canales para las bridas de la manguera
		if (completo + hacer_bridas) {
			for ( altura = h_bridas_manguera)
				translate([h_x, Y+h_dy/2, altura])
					difference() {
						cilindro(d=h_canal_manguera, h=zr_brida[0], s=[1,.6*h_dy/(h_canal_manguera/2),1]);
						cilindro(d=h_canal_manguera - 2*zr_brida[1], h=zr_brida[0]+mp, s=[1,(.6*h_dy-zr_brida[1])/(h_canal_manguera/2-zr_brida[1]),1]);
					}
			// canal para la brida del casquillo
			translate([h_x, correa_y, correa_z])
				rotate([0,90,0])
					difference() {		
						cilindro(d=h_canal_brida, h=zr_brida[0], rr=[0,90,0]);
						cilindro(d=h_canal_brida-zr_brida[1]*2*h_plus_alto_brida, h=zr_brida[0]+mp, rr=[0,90,0]);
					}
			// agujeros pasantes y alojamiento para las tuercas de fijación (van sobre la varilla horizontal)
			for ( lado = [-1, 1] ) {
				mucho=rh_diametro ;
				cilindro(d=agj_M3_h, h=mucho, t=[pp_x+lado*h_separa_tornillos/2, Yv, pp_bajos]);
				translate([pp_x+lado*h_separa_tornillos/2, Yv, pp_bajos-mucho/2-h_enganche_dz])
					scale([1,tuerca_M3_d_h/tuerca_M3_d,1])
						cylinder(d=tuerca_M3_d, h=mucho, $fn=6, center=true);
			}
		}
	}
}


/*                                                                      
                                          @@@                           
                    @@@                    @@                           
         @@@@@@           @@@@   @@@@      @@     @@@@    @@@@@         
         @  @@    @@@@   @@  @@     @@     @@    @@  @@  @@             
           @@    @@  @@  @@      @@@@@     @@    @@  @@   @@@@          
          @@  @  @@  @@  @@  @@ @@  @@     @@    @@  @@      @@         
         @@@@@@   @@@@    @@@@   @@@ @@   @@@@    @@@@   @@@@@          
                                                                      */


module zocalos(poner=0) {
	rh_radio_corregido = correccion(rh_diametro  +  .3) / 2;

	// óvalo de la brida
	dih = rh_radio_corregido * 2; // diametro interior horizontal
	dev = correccion(pp_sobre  +  .2) * 2; // diametro exterior vertical; corrijo en .2 el radio para que el hueco superior quede de 1mm
	div = dev - 2*zr_brida[1];
	deh = dih + 2*zr_brida[1];

	// trunque del zócalo para evitar el filo
	// el trunque para afinar se hace desde abajo, así que hay que redondear al alza (con 10% de redondeo para no truncar por centésimas)
	tz_dx=$espesor * 2 ; 
	tz_dz = corte_a_capa($alto_de_capa*.9 + rh_radio_corregido*sin(acos(1-tz_dx/rh_radio_corregido)) );
	// trunques de la brida para evitar el filo 
	// el cálculo para saber dónde el óvalo de la brida está a tz_dx del rodamiento con el óvalo con un es una ecuación de 2º grado
	// con esa ecuación calculo la coordenada X, para lo que me interesa la solución de "menos raiz de". A partir de ahí saco la Y
	// A=((pow(rh_radio_corregido,2)/pow(div/2,2))-1);
	// B=(-2*tz_dx);
	// C=(-pow(tz_dx,2)-pow(rh_radio_corregido,4)/pow(div/2,2)+pow(rh_radio_corregido,2));
	tbi_dz = corte_a_capa($alto_de_capa*.9 + rh_radio_corregido*cos(asin(((-(-2*tz_dx)-sqrt(pow((-2*tz_dx),2)-4*((pow(rh_radio_corregido,2)/pow(div/2,2))-1)*(-pow(tz_dx,2)-pow(rh_radio_corregido,4)/pow(div/2,2)+pow(rh_radio_corregido,2))))/(2*((pow(rh_radio_corregido,2)/pow(div/2,2))-1)))/rh_radio_corregido)) );
	tbe_dz = corte_a_capa($alto_de_capa*.9 + sqrt(pow(dev/2,2)*(1-pow(rh_radio_corregido-tz_dx,2)/pow(deh/2,2))) );
	zocalo_dz = pp_bajos - tz_dz ;
	
	for (lado_Y = [-1, 1])
		for (X = [carro_xi+rh_largo/2, carro_xf-rh_largo/2])
			translate([X, lado_Y*vh_distancia/2,0])
				if (poner)
					union() {	
						difference() {
							cubo([rh_largo, rh_diametro, zocalo_dz+mp], t=[0,0, pp_bajos-(zocalo_dz-mp)/2], $redondeo=pp_redondeo, esquinas=(lado_Y>0?(X<0?8:1):(X<0?4:2)));
							cilindro(2*rh_radio_corregido, h=rh_largo+mp, r=[0,90,0], t=[0,0,0]);
						}
						if (completo + hacer_topes_rh)
							for (lado=[-1,1])
								cubo([correccion(rh_muesca_ancho - .3), rh_diametro-mp, corte_a_capa(rh_muesca_profundo) + mp], t=[rh_muesca_desplazato*lado,0,(rh_diametro-correccion(rh_muesca_profundo - .1)+mp)/2]);
					}
						
				else if (completo + hacer_bridas) 
					translate([0*14.3,0,0]) { // este translate es para que el hueco se vea en el borde del zócalo, para depuración
						rotate([0,0,0]) 
							difference() {
								union() { // cilindro exterior + recorte para operar con la brida + otro recorte para la cabeza de la brida
									cilindro(d=deh, h=zr_brida[0], s=[dev/deh,1,1], r=[0,90,0]);
									cubo([zr_brida[0],2*zr_abertura_brida,rh_diametro], t=[0,0,pp_sobre-(rh_diametro-mp)/2]);
									// agujero para alojar la cabeza de la brida: he probado varias soluciones, y esta es la mejor con diferencia
									difference() {
										union() {
											cubo([zr_brida[2], zr_alojamiento_cabeza_brida_dy+mp, zr_alojamiento_cabeza_brida_dz], t=[0, lado_Y * (rh_diametro-zr_alojamiento_cabeza_brida_dy+mp)/2, zr_alojamiento_cabeza_brida_z]);
											// completar la abertura de todo el lateral, porque no tiene sentido dejar un hilito que impida maniobrar con la brida
											cubo([zr_brida[0], rh_diametro/2+mp, pp_bajos], t=[0, lado_Y * (rh_diametro/2+mp)/2, pp_bajos/2]);										
										}
										cilindro(d=dih, h=zr_brida[2]+mp, s=[div/dih,1,1], r=[0,90,0]);
									}
								}
								cilindro(d=dih, h=zr_brida[0]+mp, s=[div/dih,1,1], r=[0,90,0]);
							}

						
						for( lado = [-1, 1] ) {
							alto=10 ; 
							ancho=10 ;
							cubo([zr_brida[0], ancho, alto], t=[0,lado*(rh_radio_corregido-tz_dx),tbi_dz-alto/2]);
							difference() { 
								cubo([zr_brida[0], ancho, alto], t=[0,lado*(rh_radio_corregido-ancho/2+mp),tbe_dz-alto/2]);
								cilindro(d=deh, h=zr_brida[0]+mp, s=[(dev-mp)/deh,1,1], r=[0,90,0]);
							}
						}
					}
}

/*                                                                                        
                                                             ##                           
                                                                                          
   ####     ####    ####    ####    #####   ####  ## ###    ###     ####    #####         
      ##   ##  ##  ##  ##  ##  ##  ##      ##  ##  ### ##    ##    ##  ##  ##             
   #####   ##      ##      ######   ####   ##  ##  ##  ##    ##    ##  ##   ####          
  ##  ##   ##  ##  ##  ##  ##          ##  ##  ##  ##        ##    ##  ##      ##         
   ### ##   ####    ####    ####   #####    ####  ####      ####    ####   #####          
                                                                                        */				

module elementos_guia() {

	altura_sobre_plano_extrusion = pp_bajos ; // altura de la varilla sobre la superficie de extrusion
	dz_de_boquilla_a_plano_apoyo_fusor = 53.3 ;
	largo_eje_motor = 20 ;
	largo_polea_util = 8 ;
	X_minimo_motor = -84 ;

	module motor() {
		translate(posicion_motor)		
			rotate([angulo_motor - 90,0,0]) {
				intersection() {
					cubo([n17_lado, n17_lado, n17_largo], t=[0,0,-n17_largo/2]);
					cubo(c=[n17_diagonal, n17_diagonal, n17_largo+mp], t=[0,0,-n17_largo/2], r=[0,0,45]);
				}
				cilindro(d=n17_d_boina, h=n17_h_boina + mp, t=[0, 0, n17_h_boina / 2 - mp/2]);
				cilindro(d=5, h=largo_eje_motor, t=[0, 0, largo_eje_motor/2]);
				cilindro(d=diametro_polea_con_correa, h=largo_polea_util, t=[0,0,posicion_actual_polea]);
			}
	}
	
	module ventilador_fusor() {
		difference() {
			cubo(ventilador_fusor_tamanio);
			cilindro(d=ventilador_fusor_tamanio[1]*.94, h=ventilador_fusor_tamanio[2]+mp, r=[0,90,0]);
			rotate([0,90,0])			
				for (esquina=[90,180,270])
					rotate([0,0,esquina])
						cilindro(d=3, h=ventilador_fusor_tamanio[2]+mp, t=[12,12,0]);
		}
	}
			
	translate([0,0,altura_sobre_plano_extrusion]) import("fusor.stl");
	translate([X_minimo_motor - holganza_para_ver_mejor_el_motor ,0,0]) motor();
	translate(vf_posicion) rotate(vf_orientacion) ventilador_fusor();

	// casquillo que cierra la correa
	translate([correa_x,correa_y, correa_z])
		rotate([0,90,0]) {
			cilindro(d=casquillo_correa_diametro, h=casquillo_correa_dx);
			cubo([casquillo_correa_plataforma_radio, casquillo_correa_plataforma_ancho, casquillo_correa_dx], t=[casquillo_correa_plataforma_radio/2,0,0], r=[0,0,angulo_motor]);
		}
	// varillas horizontales con sus rodamientos
	for (lado_Y=[-1,1]) 
		translate([0,lado_Y * vh_distancia/2,0]) {
			cilindro(vh_diametro, h=pp_dx*2, r=[0,90,0]);
			for (lado_X=[-1,1]) 
				translate([[carro_xi,0,carro_xf][lado_X+1] - lado_X*rh_largo/2, 0, 0])
					rotate([0,90,0])		
						difference() {
							cilindro(d=rh_diametro, h=rh_largo);
							for (lado_Xr=[-1,1])
								translate([0,0,lado_Xr * rh_muesca_desplazato])
									difference() {
										cilindro(d=rh_diametro+mp, h=rh_muesca_ancho);
										cilindro(d=rh_diametro - rh_muesca_profundo, h=rh_muesca_ancho+mp);
									}
						}
		}	
}


/*                                                                                      
                                   #       ##     ###              ###                  
                                  ##               ##               ##                  
         ##  ##   ####   #####   #####    ###      ##    ####       ##    ####  ## ###  
         ##  ##  ##  ##  ##  ##   ##       ##      ##       ##   #####   ##  ##  ### ## 
         ##  ##  ######  ##  ##   ##       ##      ##    #####  ##  ##   ##  ##  ##  ## 
          ####   ##      ##  ##   ## #     ##      ##   ##  ##  ##  ##   ##  ##  ##     
           ##     ####   ##  ##    ##     ####    ####   ### ##  ### ##   ####  ####    
                                                                                       */

																					   

module rosca_embutir(profundidad=5) {
	H = 4;
	translate([0,0,(H-mp)/2]) cylinder(d1=5.6, d2=5.2, h=H+mp, center=true);
	translate([0,0,profundidad/2]) cylinder(d=3.2, h=profundidad, center=true);
}


module ventilador_capa() {

	ovalo_corte_tobera_dx = (vc_dx/2-vc_x - sop_margen_dx_ovalo_corte_tobera) * 2 ;
	excentricidad_tobera = [1,sop_ovalo_corte_tobera_dy/ovalo_corte_tobera_dx,1] ;	
	
	
	module cortes_laterales(merma_h, merma_v) {
		translate([0,0,sop_z_inferior+sop_altura_tobera/2]) {
			mucho_v = sop_altura_tobera*2 ;
			mucho_h = sop_alargamiento*2 ;
			translate([(vc_dx/2-vc_x - sop_margen_dx_ovalo_corte_tobera), sop_ovalo_conexion_y+sop_alargamiento-sop_ovalo_corte_tobera_dy/2, 0])
				difference() {
					cubo([mucho_h,mucho_h,mucho_v], t=[mucho_h/2, mucho_h/2, 0]);
					cilindro(d=sop_ovalo_corte_tobera_dy-2*merma_h, h=mucho_v+mp, s=[(vc_dx/2+vc_x-ovalo_corte_tobera_dx/2-merma_h) *2 / (sop_ovalo_corte_tobera_dy-merma_h*2),1,1]);
				}	
			translate([-(vc_dx/2-vc_x - sop_margen_dx_ovalo_corte_tobera), sop_ovalo_conexion_y+sop_alargamiento-sop_margen_dx_ovalo_corte_tobera, 0])
				difference() {
					cubo([mucho_h,mucho_h,mucho_v], t=[-mucho_h/2, mucho_h/2, 0]);
					cilindro(d=(sop_margen_dx_ovalo_corte_tobera-merma_h)*2, h=mucho_v+mp);
				}	
		}
	}
	
	module agarre() {
		mucho=sop_ovalo_conexion_yi-vc_y;
		difference() {
			union() {
				cubo([vc_dx, mucho, vc_dz/2], [vc_x, vc_y+(vc_dy+mucho)/2, vc_z+vc_dz/4]);
				cubo([vc_dx, sop_aloja_rosca_abajo+mp, vc_dz/2], [vc_x, vc_y+(vc_dy+sop_aloja_rosca_abajo-mp)/2, vc_z-vc_dz/4]);
			}
			cilindro(d=vc_diametro, h=mucho, t=[vc_x, vc_y+vc_dy/2+mucho/2-mp, vc_z], r=[90,0,0]);
		}
	}
	
	module embudo(merma_h, merma_v) {
		difference() {	
			union() {
				dY = sop_ovalo_conexion_y-(vc_y+vc_dy/2) ;
				cubo([vc_dx-merma_h*2, dY, vc_dz-merma_v*2], t=[vc_x, vc_y+(vc_dy+dY)/2, vc_z]);	
				cubo([vc_dx-merma_h*2, sop_alargamiento+mp-merma_h, sop_altura_tobera-merma_v*2], [vc_x, sop_ovalo_conexion_y+(sop_alargamiento-mp-merma_h)/2, sop_z_inferior+sop_altura_tobera/2]);
			}
			cilindro(d=(vc_dz-sop_altura_tobera+merma_v)*2, h=vc_dx+mp, t=[vc_x, sop_ovalo_conexion_y, vc_z+vc_dz/2], r=[0,90,0], s=[1,(sop_ovalo_conexion_y-sop_ovalo_conexion_yi+merma_h)/(vc_dz-sop_altura_tobera),1]);
			cilindro(d=vh_diametro+(vcs_margen_vh+merma_h)*2, h=vc_dx+mp, t=[vc_x, -vh_distancia/2, 0], r=[0,90,0], s=[(vh_diametro+(vcs_margen_vh+merma_v)*2)/(vh_diametro+(vcs_margen_vh+merma_h)*2),1,1]);
			cilindro(d=ovalo_corte_tobera_dx+merma_h*2, h=2*sop_altura_tobera, t=[0,sop_ovalo_conexion_y+sop_alargamiento,sop_z_inferior+sop_altura_tobera-mp], s=excentricidad_tobera);
			cortes_laterales(merma_h, merma_v);
		}
	}


	module bloque_apoyo_exterior(s=[1,1,1], sp=0) {
		dX = vc_dx-2*(sop_piel_xy + gapplasop);
		dYi = sop_aloja_rosca_abajo;
		// tengo interés en dejar menos de 45º de voladizo para proteger el hueco de la rosca de embutir
		dZ = sin(90-min(40,voladizo)) * vc_diametro ;
		dZs = dZ/2 ;
		dZi = dZ - dZs - sephsop ; 

		// dimensiones del ovalo de corte
		separa_un_poco = 1.3 ; // no me salen las cuentas: la piel_xy efectiva es 1.8 en la tobera, y paso de buscar
		altoo = correccion(vc_dz-sop_altura_tobera+sop_piel_z  +  separa_un_poco);
		anchoo = correccion(sop_ovalo_conexion_y-sop_ovalo_conexion_yi+sop_piel_xy  +  separa_un_poco);

		dYsr = sop_ovalo_conexion_yi-vc_y-vc_dy/2 -sop_piel_xy - separa_un_poco; // dY superior reducido (a nivel del máximo corte del óvalo)
		dYs = correccion(dYsr  +  5) ;  // no me apetece calcular la Y del óvalo en la posición correspondiente, y con un chorrito que luego se recorta ya va bien

		intersection() {
			union() {
					difference() {
						translate([vc_x, vc_y+(vc_dy+dYs)/2, vc_z+(dZ-dZs)/2])
							if (sp) 
								union() {
									translate([0,(dYsr-dYs)/2,0])
										rotate([90,0,90]) soporte_paralelo([dYsr, dZs, dX], sombrero=0, hueco=2.5); 
									cubo([dX, dYs-dYsr-mp, dZs], t=[0,(dYsr+mp)/2,0], s=s);
								}
							else 
								cubo([dX, dYs, dZs], s=s);
						scale(1/s) cilindro(d=altoo*2, h=vc_dx+mp, t=[vc_x, sop_ovalo_conexion_y, vc_z+vc_dz/2], r=[0,90,0], s=[1,anchoo/altoo,1]);
					}
				// no es tacañería: es que no hay apoyo para el soporte en este lado, así que hay que recortar Y
				translate([vc_x, vc_y+(vc_dy+dYi)/2, vc_z-(dZ-dZi)/2])
					if (sp) mirror([0,0,1]) rotate([90,0,90]) soporte_paralelo([dYi, dZi, dX], sombrero=0, hueco=1.5); else cubo([dX, dYi, dZi], s=s);
			}
			cilindro(d=vc_diametro -2*gapplasop, h=dYs+mp, r=[90,0,0], t=[vc_x, vc_y+(vc_dy+dYs)/2, vc_z]);
		}
	}

	
	if (!fabricar) %cubo([vc_dx, vc_dy, vc_dz], [vc_x, vc_y, vc_z]);


	// enganche al carro
	difference() {
	
		mucho=rh_diametro+mp*2 ;
		// tarugo principal
		union() {
			// la holgura entre la pieza y el carro es doble tiene un plus porque lo necesito
			alto = pp_bajos-(vc_z+vc_dz/2) - (zr_guia_accesorio_holgura + zr_guia_accesorio_holgura_plus) ;
			cubo([vc_dx, vcs_enganche_dy, alto+mp], t=[vc_x, vc_y+vc_dy/2+vcs_enganche_dy/2, vc_z+(vc_dz+alto-mp-(zr_guia_accesorio_holgura + zr_guia_accesorio_holgura_plus))/2]);
			// esto es un saliente por el lado del ventilador para engrosar la pieza a la altura de la varilla, para darle rigidez (sale o no, dependiendo de los parámetros)
			difference() { 
				cilindro(d=vh_diametro+(vcs_dy_min+zr_guia_accesorio_holgura)*2, h=vc_dx, r=[0,90,0], t=[vc_x, -vh_distancia/2, 0]);
				cubo(vc_dx+mp, [vc_x,-vh_distancia/2,vc_z+vc_dz/2-vc_dx/2]);
				cubo(vc_dx+mp, [vc_x,(vc_dx-vh_distancia)/2,0]);
			}
		}
		// quitar los railes para las guias
		for ( lado=[-1,1] )	
			difference() {		
				dZv = vcs_enganche_dx/tan(voladizo) ;
				Y = mucho/2+vc_y+vc_dy/2+vcx_enganche_tope_dy ;
				cubo([vcs_enganche_dx+mp, mucho, vcs_enganche_dz+dZv], [vc_x+lado*(vc_dx-vcs_enganche_dx+mp)/2,Y,pp_bajos-vcs_enganche_dz-dZv-zr_guia_accesorio_holgura]);
				translate([vc_x+lado*vc_dx/2,Y,pp_bajos-vcs_enganche_dz])
					cubo(mucho, [-lado*mucho/2,0,mucho/2],r=[0,lado*(voladizo-90),0]);
			}
			
		cubo([vc_dx+mp,mucho,mucho], [vc_x,(mucho-vh_distancia)/2,mp-mucho/2]); 
		cilindro(d=vh_diametro+vcs_margen_vh*2, h=vc_dx+mp, r=[0,90,0], t=[vc_x,-vh_distancia/2,0]);		
		
		
		difference() {
			ovalo_y = vc_y+vc_dy/2+vcs_enganche_dy ; 
			ovalo_dy = 2*(((vh_distancia+vh_diametro)/2+vcs_margen_vh)+ovalo_y) ;
			cilindro(d=ovalo_dy, h=vc_dx+mp, r=[0,90,0], t=[vc_x,ovalo_y,0], s=[(pp_bajos-vcs_enganche_dz)*2/ovalo_dy,1,1]);
			cubo([vc_dx+mp+mp,ovalo_dy+mp,mucho], [vc_x,ovalo_y,-mucho/2]);
		}
		cilindro(d=correccion(zf_semicirculo  +  1), h=zf_placa_anclaje_dz, t=[0,0,pp_bajos-zf_placa_anclaje_dz/2]);
	}

	// cuerpo principal
	difference() {
		embudo(0, 0);
		// agujeros para las roscas de embutir
		translate([vc_x, vc_y+vc_dy/2,vc_z]) 			
			for (lado_x = [-1, 1] )
				for (lado_z= [-1, 1])
					translate([lado_x*(vc_dx/2-vc_se_mete_tornillo),0,lado_z*(vc_dz/2-vc_se_mete_tornillo)])
						scale([1,1,correccion(  5.2/5.4  )])
							rotate([-90,0,0]) 
								rosca_embutir(lado_z > 0 ? correccion( 4.5 ) : (sop_aloja_rosca_abajo+mp));


		// quitar un filete para evitar líos con el embudo de quitar
		translate([vc_x, vc_y+vc_dy/2, vc_z])
			intersection() { 
				cilindro(d=vc_diametro, h=mp, r=[90,0,0]);
				cubo([vc_dx-sop_piel_xy*2, mp, vc_dz-sop_piel_z*2]);
		}
		// quitar el embudo mermado
		difference() {
			embudo(sop_piel_xy, sop_piel_z);
			agarre();
		}
		// y finalmente quitar la abertura de salida de aire
		difference() {
			or = ovalo_corte_tobera_dx+sop_piel_xy*2 ;
			mucho = sop_alargamiento ; 				
			cilindro(d=or+sop_plus_abertura*2, h=sop_altura_tobera, t=[0,sop_ovalo_conexion_y+sop_alargamiento, sop_z_inferior + sop_altura_tobera/2-sop_piel_z - sop_canto_frontal_tobera], s=excentricidad_tobera);
			cubo(mucho, [(mucho+or)/2, 0,sop_z_inferior + sop_altura_tobera/2]);
			cubo(mucho, [-(mucho+or)/2, 0,sop_z_inferior + sop_altura_tobera/2]);
		}
		// marcar unas líneas en lo que queda arriba, para optimizar el recorrido del fusor
		if (completo + hacer_soportes_complejos) { 
			aleja_de_la_rampa = .2 ;
			translate([0,-aleja_de_la_rampa,0])
				intersection() {
					embudo(sop_piel_xy-$alto_de_capa, sop_piel_z+$alto_de_capa);
					difference() {
						mp = mp/10 ;
						dY = sop_ovalo_conexion_y - (vc_y+vc_dy/2) + sop_alargamiento-sop_aloja_rosca_abajo - sop_ovalo_corte_tobera_dy/2 - sop_piel_xy - $alto_de_capa ;
						dZ = vc_dz ;
						translate([vc_x+vc_dx/2-sop_piel_xy+($alto_de_capa-mp)/2, vc_y+vc_dy/2 +sop_aloja_rosca_abajo+ dY/2+aleja_de_la_rampa, vc_z-vc_dz/2+dZ/2])
							rotate([90,0,90]) 
								soporte_paralelo([dY, dZ, $alto_de_capa+mp], sombrero=false, hueco=4.5);
						agarre();
					}
				}
		}
	}
#	cubo([vc_dx - 2*(sop_piel_xy -mp), sop_costilla_dy, sop_costilla_dz+mp], [vc_x, sop_costilla_y, vc_z-vc_dz/2+sop_piel_z+(sop_costilla_dz-mp)/2]);
	
	if (completo + hacer_soportes_complejos) {
		// soporte para el cuerno derecho
		difference() {
			oX = ovalo_corte_tobera_dx +2*sop_plus_abertura +2*sop_piel_xy - 2*gapplasop ;
			translate([0,sop_ovalo_conexion_y+sop_alargamiento,sop_z_inferior + sop_altura_tobera/2]) 
				scale(excentricidad_tobera)
					union() {
						cilindro(d=ovalo_corte_tobera_dx - 2*gapplasop, h=sop_altura_tobera);
						intersection() {
							Z = sop_altura_tobera - (sop_piel_z+sop_canto_frontal_tobera+sephsop/2) ;
							cilindro(d=oX, h=Z, t=[0,0,(Z-sop_altura_tobera)/2]);
							cubo([oX-2*sop_plus_abertura, oX, sop_altura_tobera+mp]);
						}
					}
			cubo(vc_dx, [vc_x,vc_dx/2+sop_ovalo_conexion_y+sop_alargamiento, sop_z_inferior]);
			cubo(vc_dx, [vc_x,sop_ovalo_conexion_y+sop_alargamiento-oX/2*cos(voladizo-5)-vc_dx/2,sop_z_inferior]); // este calculo es incorrecto porque estamos con una elipse, pero para pueblo ya vale
		}
		// zona de contacto con el ventilador
		difference() {
			bloque_apoyo_exterior();
			translate([-groplasop,0,0]) {
				quitafiletes = mp/10 ;
				bloque_apoyo_exterior([1,1+quitafiletes,1+quitafiletes]);
			}
		}
		intersection() {
			bloque_apoyo_exterior(sp=1);
			translate([-groplasop-mp,0,0]) bloque_apoyo_exterior();			
		}
		
		// y finalmente el interior
		intersection() {
			dZ = vc_dz/2 - sop_piel_z - sop_costilla_dz - sephsop ;
			Yi = vc_y+vc_dy/2+sop_aloja_rosca_abajo+sephsop ;
			dY = sop_ovalo_conexion_y-Yi ;
			translate([vc_x, Yi+(dY-sephsop)/2,vc_z-vc_dz/2+sephsop/2+sop_piel_xy + sop_costilla_dz + dZ/2])
				rotate([90,90,90])
					soporte_paralelo([dZ,dY,vc_dx-2*(sop_piel_xy+gapplasop)], sombrero=0);
			translate([0,-sephsop/2,0])
				embudo(sop_piel_xy-$alto_de_capa, sop_piel_z);
		}
	}
}



module ventila_fusor() {
	circulo_de_base_parcial = false ;
	
	module forma(merma = [0,0,0]) {
		bdx = ventilador_fusor_tamanio[2];
		bdy = ventilador_fusor_tamanio[1];
		bdz = vf_posicion[0] / cos(vf_orientacion[1]); // sobredimensionado
		mermita = ((merma[0]>0)?mp:0);
		// unas asignaciones para recortar el soplador a ojo
		dia = 14+merma[0]*2 ;
		x = 17 ;
		z = -26 ;
		miaja = 10 ;
		difference() {
			union() {		
				translate(vf_posicion)
					cubo([bdx, bdy, bdz]-merma*2, t=[0, 0, (bdz+ventilador_fusor_tamanio[0])/2], r=vf_orientacion-[0,90,0]);
				cubo([bdx/2, bdy-2*merma[1], miaja], t=[bdx/4,0,z+((dia-merma[0]*2)+merma[0])+miaja/2]);
				
			}			
			cubo([bdz*2,bdy+mp,bdx], t=[vf_posicion[0]/2, 0, pp_bajos-zf_placa_anclaje_dz+bdx/2-merma[0]]);
			alto = correccion(zf_circulo_alto + .3 ) ;
			cilindro(d=zf_circulo-mermita, h=alto-mermita, t=[0,0,pp_bajos-zf_placa_anclaje_dz-alto/2+mp/2]);
			cilindro(d=dia, h=vh_hueco, r=[90,0,0], t=[x,0,z], s=[1,(2*(dia-merma[0]*2)+merma[0]*2)/dia,1]);
			cubo([bdz,bdy+mp,miaja], t=[x-bdz/2,0,z+((dia-merma[0]*2)+merma[0])-miaja/2]);
			cubo([bdx, bdy-merma[0]*2+mp, bdx ], t=[3-bdx/2, 0, 0]);				
			hull() 
				for( a=[0, 120, 240])
					rotate([0,0,a]) translate([0,-15, 0]) cylinder(d=7-mermita, h=bdx, center=true);
			cilindro(d=26-mermita, h=bdx);
			hull() 
				for( lado=[-1, 1] )
					cilindro(d=5-mermita, h=bdx-mermita, t=[anclajes_extrusor_dx/2 + lado,0,0]);
		}
	
	
	
	}


	module hueco_tuerca(merma=[0,0,0]) {
		hueco_tuerca_dz=2.4 ;
		apoyo_tuerca_dz=1 ;
		
		translate(-[ventilador_fusor_entre_tornillos/2, ventilador_fusor_entre_tornillos/2, -(ventilador_fusor_tamanio[0]+hueco_tuerca_dz)/2-apoyo_tuerca_dz]) {
			cubo([tuerca_M3_d_h*cos(30)+1, tuerca_M3_d, hueco_tuerca_dz]-merma, [-.5,-tuerca_M3_d/2,0]);
			rotate([0,0,30])
				cylinder(d=correccion(tuerca_M3_d_h-merma[0]  +  .2), h=hueco_tuerca_dz-merma[2], $fn=6, center=true);
		}
	}

	difference() {
		union() {
			difference()
			{
				forma();
				forma([sf_pared, sf_pared, -mp]);
			}

			intersection() {
				forma();
					difference() {
						translate(vf_posicion)
							rotate(vf_orientacion)
								translate([-(ventilador_fusor_tamanio[0]+sf_circulo_dz)/2,0,0])
									difference() {
										cubo([sf_circulo_dz, ventilador_fusor_tamanio[1], ventilador_fusor_tamanio[2]]);
										if (circulo_de_base_parcial)
											cubo([sf_circulo_dz+mp, ventilador_fusor_tamanio[1]/sqrt(2), ventilador_fusor_tamanio[1]*2], r=[45,0,0]);
										cilindro(d=ventilador_fusor_hueco, h=10, r=[0,90,0]);
									}
					}
			}				
		}
		translate(vf_posicion)
			rotate(vf_orientacion-[0,90,0])
				for (r=[0,180])
					rotate([0,0,r]) 
						union() {
							difference() {
								hueco_tuerca();
								if (fabricar)
									translate([-1,-1,0]) 
										hueco_tuerca([-mp,-mp,gapplasop]);
							}
						translate(-[ventilador_fusor_entre_tornillos/2, ventilador_fusor_entre_tornillos/2, -(ventilador_fusor_tamanio[0]+sf_tornillo_dz-mp)/2]) 
							cilindro(d=agj_M3_h, h=sf_tornillo_dz+mp);								
						}
	}
	
	
}


/*                                                                                      
                                                                        
                                  ###                ##                 
                                   ##                                   
         ####    #####    ####     ##    ####        ##   ####          
            ##   ##  ##  ##  ##    ##       ##       ##  ##  ##         
         #####   ##  ##  ##        ##    #####       ##  ######         
        ##  ##   ##  ##  ##  ##    ##   ##  ##   ##  ##  ##             
         ### ##  ##  ##   ####    ####   ### ##  ##  ##   ####          
                                                  ####                  
												                    */

module trama_anclaje () {
	profundidad = 2 * $alto_de_capa ; 
	grueso = 2 * profundidad ; // me resulta más cómodo doblar el grosor
	penetra = .5 ;
	separa_ranuras = 2 ;
	ancho_ranuras = 2 ;
	offset = .5 ; // ir tocando a mano para que quede mono

	translate(fabricar?[0,0,0]:[0,0,pp_sobre])
		difference() {		
			translate([0,0,-grueso/2])
				cuerpo(hacer_soportes=0, fabricar=0);
			cubo([pp_dx,pp_dy,10], [-pp_x,0,(10+grueso)/2]);
			minkowski() {
				difference() {
					cubo([pp_dx,pp_dy,grueso+mp]);
					translate([0,0,-(grueso+mp)/2-mp])
						cuerpo(hacer_soportes=0, fabricar=0);
				}
				cilindro(r=penetra, h=profundidad + mp, $fn=4);
			}
			for (x = [carro_xi+offset:separa_ranuras + ancho_ranuras:carro_xf] )
				cubo([separa_ranuras, pp_dy, grueso + mp], t=[x, 0, 0]);
		}
}		

/*                                                                                
                          ###                                      #            
                           ##                                     ##            
  ##### ##  ##  ## ###     ##     ####  ##  ##    ####   #####   #####    ####  
 ##     ##  ##   ##  ##    ##    ##  ## #######  ##  ##  ##  ##   ##     ##  ## 
  ####  ##  ##   ##  ##    ##    ###### #######  ######  ##  ##   ##     ##  ## 
     ## ##  ##   #####     ##    ##     ## # ##  ##      ##  ##   ## #   ##  ## 
 #####   ### ##  ##       ####    ####  ##   ##   ####   ##  ##    ##     ####  
                ####                                                            
                                                                                */

caras_volcan = 120 ; // 120 queda bien
ancho_canto_crater = 4 ;

patin_alto = 1 ; // el patín es un realce que hace contacto con la varilla
patin_ancho = 3 ;
fijacion_dx = 6 ; // la fijación es una pieza que se atornilla a la izquierda e impide que el suplemento se levante (lo fija a la parte inferior de la varilla)
fijacion_angulo = voladizo ;
fijacion_tornillo_holgura = 1 ;
fijacion_tornillo_z = 0 ;
fijacion_tornillo_entra = 16 - fijacion_dx + fijacion_tornillo_holgura ; // tornillo de 16, 1mm de holgura al fondo


// el origen va a ser el eje de la mh para X e Y, y la superficie de apoyo de la mh para Z
bloque_dx = 93 ;
bloque_dy = pp_dy ;
bloque_dz = 80 ;
bloque_xi = -45 ;

mh_offset = [-67.5, 0, -12] ;
motor_holgura = 1 ;
motor_desde_suplemento_x = bloque_xi - (/*X.cuerpoi_dx*/47 -/*X.vv_sobresale_cuerpo*/11) + mh_offset[0];

mh_D = 48 ;
mh_d = 22 ;
mh_excentricidad_tornillo = vh_hueco/2 -2 ;
mh_altura_tuerca = 16 ; // es función de mh_excentricidad_tornillo, agj_M3_d_h y del ángulo del cono de la multiherramienta... se puede calcular pero no compensa

// parametros del portalapiz
pl_dx = 40 ; 
pl_dy = vh_hueco - 2 * patin_alto; 
pl_dz = 30 ; 
pl_grosor_placa_aluminio = 1 ;
pl_zi = mh_offset[2] - pl_grosor_placa_aluminio - pl_dz ; 
pl_xi =  posicion_motor[0] + motor_desde_suplemento_x + n17_lado/2 + motor_holgura ; 
pl_pasalapiz_d = correccion(16.9  +  .15);
pl_pilar_tornillo_dy = 8 ;
pl_base_dz = 4 ; 

pl_gancho_x =  pl_xi + pl_dx / 2 ;
pl_gancho_y = -pl_dy/2 + 3 ;
pl_gancho_d = correccion(1  +  .3);
pl_gancho_dx = 10 ;
pl_gancho_hueco_dx = 2 ;

// parametros del guialapiz
gl_separacion_elastica_dz = 1 ;
gl_dz = 4 ;
gl_ancho_brazo = 6 ;
gl_agujero = 4 ;
gl_peristoma = 12 ;



module mh(merma=0, alto=bloque_dz, paraquitar=true) {
	mh_boton_h = 21 ;
	mh_boton_d = 13 ;
	mh_quiebro_z = 45 ;	
	mh_abertura_bloqueador = 16 ;
	angulo = atan((mh_D-mh_d)/mh_quiebro_z);
	translate([0,0,-mp]) {
		intersection() {
			cylinder(d=mh_D-2*merma, h=alto+2*mp, $fn=caras_volcan);
			cylinder(d1=mh_d - mp*tan(angulo) - 2*merma, d2=mh_d + (alto+mp)*tan(angulo) - 2*merma, h=alto+2*mp, $fn=caras_volcan);
		}
		if (paraquitar) {
			difference() {
				mucho = bloque_dx ;
				union() {
					cylinder(r=mh_boton_h, h=bloque_dz+2*mp);
					cylinder(r=mucho, h=pp_sobre - mh_offset[2] + mp);
				}

				for (lado = [-1,1])
					rotate([0,0,lado*mh_abertura_bloqueador])
						translate([-(mh_boton_h+mp),lado * (mh_boton_d/2 + mucho/2) - mucho/2,-mp])
							cube([mucho,mucho,bloque_dz+4*mp]);
				translate([-mucho,-mucho/2,-mp])
					cube([mucho,mucho,bloque_dz+4*mp]);
			}
		}
	}
}



// suplemento para colocar una multiherramienta (mh)
module suplemento() {

	anclaje_dz = 4 ;
	anclaje_holgura = .2 ;
	anclaje_hueco_extrusor = 29 ; // sextrusor(cue_fondo) + 1
	
	module toro(de, di, h) {
		ds = (de-di)/2;
		rotate_extrude()
			translate([(di+ds)/2,0,0])
				scale([1,h/ds])
					circle(d=ds);
	}
	
	
	module volcan(para_soporte = false) {
		contorno_volcan = 2*sqrt(pow(max(abs(bloque_xi), bloque_dx-abs(bloque_xi)), 2) + pow(bloque_dy/2, 2));
		translate([0,0,bloque_dz] + mh_offset)
			difference() {
				de = contorno_volcan + (contorno_volcan -(mh_D+ancho_canto_crater * 2)); 
				di = mh_D + ancho_canto_crater * 2 ;
				h = (bloque_dz+mh_offset[2] - pp_sobre - anclaje_dz) * 2 ;
				toro(de, di, h);
				if (para_soporte) {
					a = (de - di)/4 ;
					cylinder(r=di/2 + a - sqrt(1/(pow((h/2) * tan(voladizo)/pow(a,2), 2) + 1/pow(a,2))), h=h, center=true);
				}
			}
	}
	
	module hueco_varillero(diametro, lado) {
		rotate([0,90,0])
			cylinder(d=diametro, h=bloque_dx+mp, center=true);
		translate([0,lado * (vh_distancia/2-diametro+mp)/2, (mh_offset[2]-mp)/2])
			cube([bloque_dx+mp, vh_distancia/2+mp, mp-mh_offset[2]], center=true);
		translate([0,lado * ((vh_distancia-diametro)/2+mp)/2, (mh_offset[2]-mp+diametro)/2])
			cube([bloque_dx+mp, (vh_distancia-diametro)/2+mp, mp-mh_offset[2]], center=true);
	}
	
	module soporte_tornillos_2D (merma=0) {
		itsmo_largo = 3.5 ;
		itsmo_ancho = 3 ;
		union() {
			square(2 * mh_excentricidad_tornillo * sin(45) -agj_M3_h/2 -itsmo_largo/2 - merma, center=true);
			for (angulo = [45, 135, 225, 315])
				rotate([0,0,angulo]) 
					translate([0, mh_excentricidad_tornillo]) {
						circle(d = agj_M3_h + 2 *  $espesor - merma, $fn=6);
						translate([0, -itsmo_largo])
							square([itsmo_ancho-merma, itsmo_largo], center=true);
					}
		}
	}

	if (coger_volcan_hecho)
		import("carro_sup.stl");	
	else {
		difference() {
			// un cubo al que iremos descontando
			translate([bloque_xi, -bloque_dy/2, 0] + mh_offset)
				cube([bloque_dx, bloque_dy, bloque_dz]);

			// volcan
			if (caras_volcan >= 8)
				volcan($fn=caras_volcan);

			// recorte del carro
			translate([carro_xi-anclaje_holgura,-(pp_dy+mp)/2, pp_sobre-bloque_dz])
				cube([carro_dx, pp_dy+mp, bloque_dz]);
			// recorte del extrusor			
			linear_extrude(bloque_dz) 
				silueta_XY_cuerpo(holgura=.5);
				
			for (lado=[-1,1]) 
				translate([0,lado * vh_distancia/2,0]) {
					// agujero y asiento para los tornillos del carro
					translate([asc_x, 0,pp_sobre+anclaje_dz]) {
						cylinder(d=arandela_M3_d_h, h=10);
						cylinder(d=agj_M3_h, h=bloque_dz, center=true);
					}
					// hueco de varillas
					translate([bloque_xi+mh_offset[0]+bloque_dx/2,0,0]) {
						hueco_varillero(vh_diametro, lado);
						difference() {
							hueco_varillero(vh_diametro + patin_alto*2, lado);
							cube([bloque_dx+mp, patin_ancho, vh_diametro + patin_alto*2], center=true);
							cube([bloque_dx+mp, vh_diametro + patin_alto*2, patin_ancho], center=true);
							// soporte del patÝn horizontal
							translate([0,-lado * (patin_alto + vh_diametro/2*cos(asin(patin_ancho/vh_diametro))),vh_diametro/4])
								cube([bloque_dx+mp, patin_alto*2, vh_diametro/2], center=true);
						}
					}
				}
			
			// alojamiento para motor
			motor(motor_holgura);		

			// alojamiento para la estructura de fijación
			translate([bloque_xi + mh_offset[0]+fijacion_dx + .2, 0, 0]) {
				// tornillo de fijación
				translate([-mp/2,0,0])		
					rotate([0,90,0])		
						cylinder(d = agj_M3_h, h=fijacion_tornillo_entra+mp);
						
				// alojamiento para la tuerca
				translate([fijacion_tornillo_entra - tuerca_M3_h_h/2 - fijacion_tornillo_holgura - 1,0,0]) {
					translate([0, 0, fijacion_tornillo_z])
						rotate([0,90,0])
							cylinder(d=tuerca_M3_d_h, h=tuerca_M3_h_h, $fn=6, center=true);
					// canal para colocar la tuerca
					translate([0, 0, (fijacion_tornillo_z+mh_offset[2])/2])
						cube([tuerca_M3_h_h, (tuerca_M3_d_h * 2 * cos(30)) / (2 * sin(30) + 1), fijacion_tornillo_z-mh_offset[2]], center=true);
				}
				
				// silueta que agarra las varillas horizontales: se acopla y atornilla
				rotate([0,-90,0])
					linear_extrude(fijacion_dx + .2 + mp) {
						silueta_fijacion([.15, .3]);
						translate([mh_offset[2]-mp, -vh_distancia/2]) {
							// esto de la H es para recortar a la altura en la que empieza el soporte del patín horizontal
							H = vh_diametro*cos(asin(patin_ancho/vh_diametro));
							square([correccion(abs(mh_offset[2])+H*tan(acos(H/(vh_diametro+patin_alto*2)))/2 +mp), vh_distancia]);
						}
					}
			}
			
			// multiherramienta con su tornillería
			translate(mh_offset) {	
				mh_ventilacion_z = [33.2, 38.0] ;
				mh_ventilacion_x = [-5.6, 5.6] ; // desplazamiento en X a partir del eje de la multiherramienta
				mh_ventilacion_dx = [14.6, 16.1] ; // las de abajo son más cortas
				mh_ventilacion_dz = 3 ;
				gap_horizontal = 2.4 ;
				
				for (Z=[0,1])
					for (X=[0,1]) 
						difference() {
							hull() {
								for (lado=[0,1]) 
									translate([mh_ventilacion_x[X] + lado * sign(X-.5) * (mh_ventilacion_dx[Z]-mh_ventilacion_dz),0,mh_ventilacion_z[Z]]) 
										rotate([90,0,0])
											cylinder(d=mh_ventilacion_dz, h=bloque_dy+mp, center=true);
							}
							if (hacer_soportes_complejos)
								for (lado=[-1,1]) {
									trozo = (mh_ventilacion_dx[1/*1 y no Z porque queda mejor la interseccion con los agujeros de los tornillos*/]-gap_horizontal*3)/2 ;
									translate([(mh_ventilacion_x[X]+sign(X-.5)*(mh_ventilacion_dx[Z]-mh_ventilacion_dz)/2) + lado * (trozo+gap_horizontal)/2,0,mh_ventilacion_z[Z]])
										difference() { // soporte paralelo simple
											cube([trozo, bloque_dy+2, mh_ventilacion_dz - 2*gapplasop], center=true);
											cube([trozo-2*$espesor, bloque_dy-2*$espesor, mh_ventilacion_dz - 2*gapplasop + mp], center=true);
										}								
								}
						}
										
				mh() ;
				for (angulo = [45, 135, 225, 315])
					rotate([0,0,angulo]) {
						lado_tuerca = tuerca_M3_d_h/(2*cos(60)+1);

						translate([0,-lado_tuerca/2,mh_altura_tuerca])
							cube([mh_excentricidad_tornillo, lado_tuerca, bloque_dz/2]);
						translate([0, mh_excentricidad_tornillo, -mp/2]) {
							cylinder(d = agj_M3_h, h = bloque_dz + mp);
							translate([0,0,mh_altura_tuerca])
								cylinder(d = tuerca_M3_d_h, h=bloque_dz, $fn=6); // rebaje hexagonal para que sujete la tuerca
						}
					}
			}
		}
		
		// soportes
		if (hacer_soportes_complejos) {
			// apoyo de los tornillos de la multiherramienta
			translate(mh_offset + [0,0, mh_altura_tuerca + gapplasop])
				linear_extrude(bloque_dz -mh_altura_tuerca - gapplasop)
					difference() {
						soporte_tornillos_2D();
						soporte_tornillos_2D($espesor);
						translate([mh_excentricidad_tornillo, 0])
							square(2 * mh_excentricidad_tornillo * sin(45) -agj_M3_h - 2, center = true);
					}

			
			// laderas del volcan
			translate([0,0,gapplasop]) 
				union() {
					intersection() {
						translate([bloque_xi, -bloque_dy/2, -gapplasop] + mh_offset)
							cube([bloque_dx, bloque_dy, bloque_dz]);
						difference() {
							volcan(true, $fn=caras_volcan);
							linear_extrude(bloque_dz) 
								silueta_XY_cuerpo(holgura=.5);
						}
					}
					for (lado = [-1,1])
						translate([asc_x,lado * vh_distancia/2, pp_sobre + anclaje_dz])
							difference() {
								cylinder(d=agj_M3_h + 2*$espesor, h=10);
								translate([0,0,-mp/2])
								cylinder(d=agj_M3_h , h=10+mp);
							}
				}
		}
	}
}

module motor(plus) {
	translate(posicion_motor + [motor_desde_suplemento_x,0,0])
		rotate([90+angulo_motor,0,0])
			translate([0,0,-plus])
				linear_extrude(n17_largo+2*plus)
					intersection() {
						square(n17_lado+2*plus, center=true);
						rotate([0,0,45])
							square(n17_diagonal+2*plus, center=true);
					}
}


module fijacion() {
	difference() {
		translate([mh_offset[0]+bloque_xi+fijacion_dx, 0, 0])
			rotate([0,-90,0])
				difference() {
					linear_extrude(fijacion_dx) 
						union() {
							silueta_fijacion([correccion(-.15), correccion(-.15)]);
							for (lado = [-1, 1])								
								translate([0, lado * vh_distancia/2])
									difference() {
										circle(d=vh_diametro + patin_alto*2 + 1);
										difference() {
											circle(d=vh_diametro + patin_alto*2);
											square([rh_diametro, patin_ancho], center=true);
											square([patin_ancho, rh_diametro], center=true);
										}										
										square(correccion(vh_diametro  +  .3), center=true); // cortar los patines en redondo es bonito en el dibujo, pero malo en la práctica
										translate([(rh_diametro+patin_ancho)/2, 0])
											square(rh_diametro, center=true);
									}
						}
				translate([fijacion_tornillo_z,0,-mp/2])						
					cylinder(d=agj_M3_h, h=fijacion_dx+mp);
				cono_r = arandela_M3_d_h / 2 ;
				translate([fijacion_tornillo_z,0,fijacion_dx - cono_r + mp])
					cylinder(r1=0, r2 = cono_r, h=cono_r);
				}
		motor(motor_holgura);
	}
}

module silueta_fijacion(plus=[0,0]) { // el plus es para agrandar la parte de arriba cuando la silueta se usa para crear un hueco en el portaherramienta (la parte de abajo no varía)
	superior_dy = vh_distancia + plus[1] * 2;
	superior_dz = vh_diametro + 6 + plus[0];
	difference() {
		union() {
			baja = abs(mh_offset[2]);
			translate([0, -superior_dy/2])
				square([superior_dz, superior_dy]);
			translate([-baja, -vh_distancia/2])
				square([baja + patin_ancho/2, vh_distancia]);
			for( lado = [-1,1] )
				translate([0, lado * vh_distancia/2])
					difference() {
						resize([baja * 2, rh_diametro])					
							circle(d=rh_diametro);
						translate([baja + patin_ancho/2, 0])
							square(baja*2, center=true);
					}
		}
		for (lado=[-1,1] ) {
			radio = vh_diametro/2 + patin_alto - plus[1];
			translate([0, lado * vh_distancia/2]) {
				hull() {
					circle(radio);
					translate([vh_diametro/2 + patin_ancho/2, 0])
						circle(radio);
				}
				translate([vh_diametro/2 + patin_ancho/2 + radio*sin(fijacion_angulo), -lado * radio * cos(fijacion_angulo)])
					rotate([0,0,-lado * (90-fijacion_angulo)])
						translate([-radio/2, lado*radio/2])				
							square(radio, center=true);				
			}
		}
	}
}


use <tangente.scad>

module portalapiz() {
	pl_pared_dx = 4 ;
	pl_guia_tornillo_dz = 25 ;
	pl_tuerca_z = corte_a_capa(pl_zi - gl_separacion_elastica_dz - gl_dz + pl_guia_tornillo_dz - tuerca_M3_h); 
		
	difference() {
		translate([pl_xi, -pl_dy/2, pl_zi])
			difference() {
				cube([pl_dx, pl_dy, pl_dz]);
				difference() {
					translate([pl_pared_dx, 0, -mp])
						cube([pl_dx - 2* pl_pared_dx, pl_dy-pl_pared_dx, pl_dz - pl_base_dz+mp]);
					for (lado=[-1, 1]) 
						translate([pl_dx/2 + lado * (pl_dx - pl_pilar_tornillo_dy)/2, pl_dy - pl_pilar_tornillo_dy/2,0]) {
							logordo = corte_a_capa(pl_zi + pl_dz - pl_tuerca_z + tuerca_M3_h /2 + $alto_de_capa - .05);
							translate([0,0,pl_dz - logordo])
								cylinder(d=pl_pilar_tornillo_dy*2, h=logordo);
								cylinder(d1=pl_pilar_tornillo_dy, d2=pl_pilar_tornillo_dy*2, h=pl_dz - logordo);
						}
				}
				for (lado=[-1, 1]) {
					translate([pl_dx/2 + lado * (pl_dx - pl_pilar_tornillo_dy)/2, pl_dy - pl_pilar_tornillo_dy/2, 0]) {
						alto = corte_a_capa(tuerca_M3_h + $alto_de_capa -.05);
						ancho = 2*cos(30)*tuerca_M3_d_h/(2*cos(60)+1) ;
						translate([0,0,-mp/2])
							cylinder(d=agj_M3_h, h=pl_dz+mp);
							
						difference() {
							translate([0, 0, pl_tuerca_z-pl_zi]) 
								union() {
									rotate([0,0,-lado*15])							
										cylinder(d=tuerca_M3_d_h, h=alto, $fn=6);
									rotate([0,0,90-lado*45])
										translate([0,-ancho/2,0])
											cube([pl_pilar_tornillo_dy, ancho, alto]);
								}

							if (fabricar)
								translate([0, 0, pl_tuerca_z-pl_zi + $alto_de_capa]) 
									union() {
										rotate([0,0,-lado*15])							
											cylinder(d=correccion(tuerca_M3_d_h  -  2), h=alto - 2*$alto_de_capa);
										rotate([0,0,90-lado*45])
											translate([0,correccion(-ancho/2  +  .6),0])
												cube([pl_pilar_tornillo_dy-2, correccion(ancho  -  2*.6), alto-2*$alto_de_capa]);
									}
						}
					}
				}
				translate([pl_dx, 0, 0])
					rotate([0,-90,0])
						ladera([pl_dz, pl_dy-pl_pilar_tornillo_dy, pl_dx], sobrado=true);
			}
		translate(mh_offset + [0,0,-pl_base_dz - pl_grosor_placa_aluminio - mp/2])
			cylinder(d=pl_pasalapiz_d, h=pl_base_dz+mp);

		translate([0,0,pl_zi + pl_dz - pl_gancho_d/2])			
			fijacion_muelle();
	}
}

module fijacion_muelle() {
	translate([pl_gancho_x, pl_gancho_y, 0]) {		
			difference() {
				cube([pl_gancho_dx, pl_gancho_d, pl_gancho_d * 2], center=true);
				cube([pl_gancho_hueco_dx, pl_gancho_d + mp, pl_gancho_d * 2 + mp], center=true);
			}
		for ( lado=[-1, 1] )
			translate([lado * (pl_gancho_hueco_dx + pl_gancho_d)/2, 0, 0])
				cylinder(d=pl_gancho_d, h=pl_base_dz*2, center=true);
	}
}


module guialapiz() {
	difference() {
		union() {
			for (lado=[-1, 1]) 
				translate([pl_xi - mh_offset[0] + pl_dx/2 + lado * (pl_dx - pl_pilar_tornillo_dy)/2, (pl_dy - pl_pilar_tornillo_dy)/2,0]) {
					cylinder(d=pl_pilar_tornillo_dy, h=gl_dz);
				}

			cylinder(d=gl_peristoma, h=gl_dz);
			
			translate([pl_gancho_x - mh_offset[0], 0, 0])
				difference() {
					translate([0, pl_gancho_y, 0])
						cylinder(d=pl_gancho_dx, h=gl_dz);
					translate([0, -(pl_dy+pl_gancho_dx)/2, 0])
						cube([pl_gancho_dx, pl_gancho_dx, gl_dz*3], center=true);
				}
			// uniones	
			for (lado=[-1, 1]) 
				hull() {
					cylinder(d=gl_ancho_brazo, h=gl_dz);
					translate([pl_xi - mh_offset[0] + pl_dx/2 + lado * (pl_dx - pl_pilar_tornillo_dy)/2, (pl_dy - pl_pilar_tornillo_dy)/2,0]) 
						cylinder(d=gl_ancho_brazo, h=gl_dz);
				}
			hull() {
				cylinder(d=gl_ancho_brazo, h=gl_dz);
				translate([pl_gancho_x - mh_offset[0], pl_gancho_y, 0])
					cylinder(d=gl_ancho_brazo, h=gl_dz);
			}
		}
		
		translate([-mh_offset[0],0,0])
			fijacion_muelle();
		translate([0,0,-mp/2]) {
			cylinder(d1=gl_agujero, d2=gl_agujero+gl_dz, h=gl_dz+mp);
			
			for (lado=[-1, 1]) 
				translate([pl_xi - mh_offset[0] + pl_dx/2 + lado * (pl_dx - pl_pilar_tornillo_dy)/2, (pl_dy - pl_pilar_tornillo_dy)/2,0]) {
					cylinder(d1=arandela_M3_d_h, d2=0, h=arandela_M3_d_h/2);
					cylinder(d=agj_M3_h, h=gl_dz+mp);
				}			
		}
	}	
}

module embudo_empuje(alto_suplemento=0) {
	ee_d = 18 ;
	ee_canto = 1 ;
	ee_embudo_fondo_d = 5 ;
	ee_embudo_hondo = 8 ;
	ee_muelle_dz = 13 ;
	ee_muelle_d = 8 ;
	ee_dz = ee_embudo_hondo + ee_muelle_dz + 2 ;
	
	if (alto_suplemento==0)
		difference() {
			cylinder(d=ee_d, h=ee_dz);
			translate([0,0,-mp])
				cylinder(d1=ee_d - ee_canto * 2, d2=ee_embudo_fondo_d, h=ee_embudo_hondo+mp);
			translate([0, 0, ee_muelle_dz])
				cylinder(d=ee_muelle_d, h=ee_muelle_dz+mp);
		}
	else
		union() {
			difference() {
				cylinder(d=ee_d, h=alto_suplemento);
				translate([0,0,-mp])
					cylinder(d1=ee_d - ee_canto * 2, d2=ee_embudo_fondo_d, h=ee_embudo_hondo+mp);
			}
			translate([0,0,alto_suplemento - mp])
				cylinder(d1=ee_d - ee_canto * 2, d2=ee_embudo_fondo_d, h=ee_embudo_hondo+mp);
		}	
}

module pastilla_empuje(suplemento=false) {
	pastilla_d = 28 ;
	pastilla_dz = 10 ;
	pastilla_reborde = 2 ;
	pastilla_base_dz = 4 ;
	muelle_dz = 2 ;
	muelle_d = correccion( 7.2  +  .2 );
	difference(){
		cylinder(d=pastilla_d, h=pastilla_dz);
		translate([0, 0, pastilla_base_dz])
			cylinder(d=pastilla_d - pastilla_reborde * 2, h=pastilla_dz - pastilla_base_dz + mp);
		translate([0, 0, pastilla_base_dz - muelle_dz])
			cylinder(d=muelle_d, muelle_dz+mp);
	}
}