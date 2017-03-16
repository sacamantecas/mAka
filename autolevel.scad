
  /* rotor (2 piezas) */ 						rotor();
  /* cuerpo */									cuerpo();
  /* lanza (son 3 piezas) */					afeita(afeitado) lanza();
  /* mecanismo de sacar y meter la lanceta */	{ pulopo(); portapulopo(); ajuste_pulopo(); }
  /* plantilla de montaje de la lanceta */ 		if (fabricar) translate([-20,-47,0]) lanza(true);

fabricar = 0 ;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
$alto_de_capa = .2 ;


use <utilidades.scad>
function ajuste_manual(p) = p;
function cac(cuanto, exceso=false) = floor((cuanto+(exceso?($alto_de_capa-.0001):0))/$alto_de_capa)*$alto_de_capa;
module local() { children(); }

$fs = .5 ;
$fa = 1 ;
mp = .1 ;

$espesor = .59 ;
hacer_soportes = fabricar ;
afeitado = .25 * fabricar * 0 ;


angulo_voladizo = utilidades($angulo_voladizo) ;
sephsop = .75 ; // utilidades($gap_h_soporte) ;
gapplasop = utilidades($gap_v_soporte) ;
holgura_rotor = .3 ;
holgura_lanceta = .2 ;


// diámetro de agujeros en horizontal (churrito anular), vertical (capas) y lateral (fin de churrito)
agujero_clip = [ajuste_manual(1 + .7), 1, ajuste_manual(1 + .2)];
agujero_M3 = [ ajuste_manual(3 + .5)/2, , ] ;
// medidas de X.scad
rosca_autolevel_altura = [6, 26];
 

cuerpo_dx = 29 ;
cuerpo_zi = -41.4 + 1 ;
ancho_cavidad = 13.5 ;
techo_cavidad = cuerpo_zi + 19.8 ;
rotor_x = -3.2 ;
rotor_z = cuerpo_zi + 7.2 ;
rotor_dy = 8.4 ;
rotor_r = 9 ; 
recorte_encaje_rotor_dejando = 1 ;
recorte_encaje_rotor_profundo = 1.2 ;
canal_forro_dx = 4 ;
lanza_dz = 3 ;	
punta_zr = -30 ;
punta_xr = 22 ;

// el pulopo se mide a partir de: X de la varilla roscada, Y de la cara proximal del soporte del eje X
// y el Z medio de los tornillos que van en el hueco del cursor
pulopo_z = 5 ;
pulopo_x = 20 ;
portapulopo_dy = 3 ;


// coordenadas de la oreja respecto al eje del rotor, en posición de medición
// x_reposo = -z_medicion; z_reposo = x_medicion
oreja_x = 5.8 ;
oreja_z = oreja_x ; // 45º hacia la izda en reposo, 45 a dcha en medición
merma_interior_inferior = 2.5 ; // la parte trasera de la caja lleva este recorte
cuerpo_yi = -merma_interior_inferior/2 ;
abertura_lanceta_z = ajuste_manual(rotor_z + oreja_z  -  .2) ;



module ajuste_pulopo() {
	ap_dy = 6 ;

	module ajuste_pulopo_2D(merma = 0) {
		cir = 4 ;
		cis = 3.5 ;
		excentricidad = 4 ;
		
		difference() {
			hull() {
				circle(cir - merma);
				translate([0, excentricidad]) circle(cis-merma);
			}
			circle(agujero_M3[0]+merma);
		}		
	}
	
	translate(let(tuerca_y_arandela = 2.9) fabricar?[35,6,0]:[26.8,8 - tuerca_y_arandela - portapulopo_dy, -34-(rosca_autolevel_altura[1] - rosca_autolevel_altura[0])/2]) rotate(fabricar?[0,0,90]:[90,0,0]) {
		union() {
			preliminar = afeitado ? $alto_de_capa : 0 ;
			linear_extrude(preliminar) ajuste_pulopo_2D(afeitado);
			translate([0,0,preliminar])
				rotate([0,0,(fabricar?0:-47)]) // una rotación estética para dar la impresión de que el pulopo apoya en la leva
					linear_extrude(ap_dy - preliminar) ajuste_pulopo_2D();
		}
	}
	
}


module pulopo() { // lanza que tira y empuja la lanza que actúa sobre el rotor
	pulopo_dy = 6.4 ;
	eje_r = 4 ;
	rx = -22 ;
	rz = -1.5 ;
	corte_vs_x = rx + 2.5 ;
	
	// un clip pegado es gancho que agarra el tornillo de la puntera
	canal_clip_dx = 11 ;
	canal_clip_dy = 1 ;
	canal_clip_dz = ajuste_manual( 1 + .3 );
	canal_clip_z = eje_r - 1.7 ;
	
	module pulopo_2D(merma=0) {
		// origen de coordenadas: eje de rotación del pulopo
		// un anillo es la base para construir la punta del pulopo
		re = 8 ;
		ri = 4 ;
		corte_vi_x = rx - 2 ; 
		angulo_corte_inferior = 20 ;
		muesca_ix = -2.3 ;
		muesca_iz = .5-(re+ri)/2 ;
		arco_conexion_r = 10 ;
	
		a=re + arco_conexion_r;
		b=eje_r + arco_conexion_r;
		c=sqrt(pow(rx,2)+pow(rz,2));
		alfa=acos((pow(b,2)+pow(c,2)-pow(a,2))/(2*b*c));
		beta=acos((pow(a,2)+pow(c,2)-pow(b,2))/(2*a*c));
		epsilon = atan(rz/rx);
		xtd = rx + re*cos(beta-epsilon);
		xti = -eje_r*cos(alfa+epsilon);

		mucho = re * 2 ;		

		difference() {
			union() {
				circle(eje_r - merma);
				translate([corte_vs_x, 0]) square([0 - corte_vs_x, eje_r - merma]);
				translate([xtd,-re]) square([xti-xtd, re]);
				difference() { 
					translate([rx, rz])	circle(re-merma); 
					translate([rx-mucho/2,eje_r-merma]) square(mucho);
				}
			}
			translate( -(eje_r+arco_conexion_r) * [cos(epsilon+alfa), sin(epsilon+alfa)]) circle(arco_conexion_r+merma);
			translate([rx-mucho, rz]) square(mucho);
			translate([rx+merma,rz]) rotate([0,0,180-angulo_corte_inferior]) square(mucho);
			translate([corte_vs_x-mucho,rz]) square(mucho);
			translate([rx, rz])	circle(ri+merma); 
			circle(agujero_M3[0]+merma);
			// muesca en el canto inferior izquierdo del pulopo para que coja la lanza
			translate([rx + muesca_ix, rz + muesca_iz]) rotate([0,0,-30]) circle(r=(re-ri)/2 + merma, $fn=3);
		}
	}

	translate(let(tuerca_y_arandela = 3) fabricar?[40,-5,0]:[26.8+pulopo_x,8 - tuerca_y_arandela - portapulopo_dy, pulopo_z-34]) rotate(fabricar?[0,0,0]:[90,-1,0]) 
		difference() {
			union() {
				preliminar = afeitado ? $alto_de_capa : 0 ;
				linear_extrude(preliminar) pulopo_2D(afeitado);
				translate([0,0,preliminar])
					linear_extrude(pulopo_dy - preliminar) pulopo_2D();
			}
			for (lado = [-1, 1])
				translate([corte_vs_x + (canal_clip_dx-mp)/2, canal_clip_z, pulopo_dy/2 + lado * (pulopo_dy - canal_clip_dy + mp)/2])
					cube([canal_clip_dx+mp, canal_clip_dz, canal_clip_dy], center=true);
		}
}


module portapulopo() { // se construye a partir del centro de los dos tornillos que van en el hueco del cursor del soporte dcho del eje X
	polea_x = -6.75 ; // posicion_eje[0] - vrd_x de X.scad
	fijacion_r = 4.5 ;
	fijacion_dz = (rosca_autolevel_altura[1] - rosca_autolevel_altura[0])/2 ;
	cabeza_tornillo = ajuste_manual( 5.5  +  1) ;
	escotadura_dy = 1 ;
	
	module portapulopo_2D(merma=0) {
		pulopo_r = fijacion_r;			
		angulo = atan(fijacion_dz/-polea_x);
		
		cpr = -polea_x/cos(angulo)-fijacion_r;
		csr = sqrt(pow(pulopo_x,2)+pow(fijacion_dz-pulopo_z,2))/(2*cos(angulo)) - pulopo_r;
		cir = sqrt(pow(pulopo_x,2)+pow(fijacion_dz+pulopo_z,2))/(2*cos(angulo)) - pulopo_r;
		cs = rota_2D([pulopo_x, pulopo_z] + [-(csr+pulopo_r)*cos(angulo), (csr+pulopo_r)*sin(angulo)], [pulopo_x, pulopo_z], -atan((fijacion_dz-pulopo_z)/pulopo_x));
		ci = rota_2D([pulopo_x,pulopo_z] + [-(cir+pulopo_r)*cos(angulo), -(cir+pulopo_r)*sin(angulo)], [pulopo_x, pulopo_z],  atan((fijacion_dz+pulopo_z)/pulopo_x));
		difference() {
			union() {
				translate([0, fijacion_dz]) circle(fijacion_r - merma);
				translate([0, -fijacion_dz]) circle(fijacion_r - merma);
				translate([pulopo_x, pulopo_z]) circle(pulopo_r - merma); 
				polygon([[0,fijacion_dz], cs, [pulopo_x, pulopo_z], ci, [0,-fijacion_dz], [polea_x, 0]]);
			}
			translate([polea_x, 0]) circle(cpr + merma);
			translate(cs) circle(csr + merma);
			translate(ci) circle(cir + merma);			
			translate([0, fijacion_dz]) circle(agujero_M3[0] + merma);
			translate([0,-fijacion_dz]) circle(agujero_M3[0] + merma);
			translate([pulopo_x, pulopo_z]) circle(agujero_M3[0] + merma);
		}

	}
	translate(fabricar?[0,0,0]:[26.8,8,-34]) rotate(fabricar?[0,0,0]:[90,0,0]) {
		preliminar = afeitado ? $alto_de_capa : 0 ;

		difference() {
			union() {
				if (afeitado)
					linear_extrude($alto_de_capa) portapulopo_2D(afeitado);
				translate([0,0,preliminar])
					linear_extrude(portapulopo_dy - preliminar) portapulopo_2D();
			}
			translate([pulopo_x, pulopo_z, -mp])
				intersection() {
					cylinder(d1=cabeza_tornillo, d2=0, h=cabeza_tornillo/2);
					cube([cabeza_tornillo+mp, agujero_M3[0]*2, cabeza_tornillo+mp], center=true);
				}
			// un escote para evitar el roce de la puntera (otra opción es limar la puntera un poco
			translate([-3, 3.5, portapulopo_dy - escotadura_dy]) 
				resize([10,0,0]) 
					cylinder(r=3, h=escotadura_dy+mp);
		}
	}
	
	
}
 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function rota_2D(punto, eje, angulo) = // rotar un punto un ángulo determinado con respecto a un eje
	let( H=sqrt(pow(punto[0]-eje[0],2)+pow(punto[1]-eje[1],2))
	, 	 g = (punto[0]==eje[0]) ? (90*sign(punto[1]-eje[1])) : atan((punto[1]-eje[1])/(punto[0]-eje[0])) 
	,	 gg = (punto[0]>eje[0]) ? g : (g+180) 
	)	 [ eje[0] + H * cos(angulo + gg), eje[1] + H * sin(angulo + gg) ] ;

	
module lanza(plantilla_montaje = false) {	
	// punta: un punto que está en la vertical del gancho de agarre. me interesa su x y z en reposo, y lo que baja la x en medición
	punta_diferencial = 4 ; // cuánto baja la punta en medición
	punta_angulo = -30 ;
	punta_angulo_dz_sobre_puntera = 1 ; // altura del eje de rotación de punta_angulo sobre la superficie de la puntera
	// coordenadas del eje de la oreja
	Xr = rotor_x - oreja_z;
	Xm = rotor_x + oreja_x;
	Zo = rotor_z + oreja_x;
	Za = abertura_lanceta_z;
	
	// para cálculos con la lanza tomo las medidas de un segmento que va de la oreja a la vertical de la punta de arrastre
	lanza_holgura = .15 ; // holgura por el ancho extra del churrito
	lanza_oreja_r = 2.9 ;
	lanza_dx = sqrt(pow(punta_xr-Xr,2)+pow(punta_zr-Zo, 2)) ;
	// un plus de anchura, que sea lo que roce con los laterales del cuerpo
	lanza_oreja_cojin_r = lanza_oreja_r - .4 ;
	lanza_oreja_cojin_h = $alto_de_capa * 0 ;
	

	lanza_dy = cac((ancho_cavidad - rotor_dy - 4*holgura_lanceta) / 2) ;
	lanza_puntera_dz = 1.5 ; // cuerno de la lanza que facilita colocar la puntera para pegarla
	alfa = asin((punta_zr-Zo)/lanza_dx); // angulo que se levanta la lanza en posición de reposo
	beta = asin((punta_zr-punta_diferencial-Zo)/lanza_dx); // angulo que baja la lanza en posición de medición
	// puntera	
	puntera_dx = 6 ;	
	puntera_cunna_dx = 2 ;
	puntera_angulo = 0 ; // angulo de la puntera respecto a la horizontal
	puntera_dy = rotor_dy + 2 * (lanza_dy + holgura_lanceta); // la holgura que queda al pegar la puntera a la conexión es la misma que habrá entre la lanza y el rotor
	puntera_dz = 3 ;
	puntera_r = agujero_clip[0]/2 ; // agujero para el gancho
	lanza_conexion_puntera_r = puntera_dz/2 ;

	
	if (plantilla_montaje) {
		dx = 30 ;
		dy = ancho_cavidad + 6 ;
		dz = 10 ;
		suelo = 2 ;
		eje_x = lanza_oreja_r + 1 ;
		eje_z = lanza_oreja_r + 1 + suelo ;

		difference() {
			translate([0,-dy/2,0])
				cube([dx, dy, dz]);
			for (lado =  [-1,1]) {
				translate([dx/2, lado * (rotor_dy/2+lanza_dy/2+holgura_lanceta), dz/2 + suelo])
					cube([dx+mp, lanza_dy, dz], center=true);
				// la zona del eje lleva una holgura adicional de $alto_de_capa para facilitar la manipulación al meter el eje
				translate([eje_x, lado * (rotor_dy/2+lanza_dy/2+holgura_lanceta + lanza_oreja_cojin_h/2 + $alto_de_capa/2), dz/2 + suelo])
					cube([lanza_oreja_r * 2, lanza_dy + lanza_oreja_cojin_h + $alto_de_capa, dz], center=true);
				translate([eje_x, 0, eje_z])
					rotate([90,0,0])
						resize([agujero_clip[2],agujero_clip[1],0])
							cylinder(r=1, h=dy+mp, center=true);
				}
		}
		translate([26, 0, (3.4 + suelo)/2+mp])
			cube([2, dy-mp, 3.4 + suelo-mp], center=true);
		
	} else {			
		for (lado=[-1,1]) 
			translate(fabricar?[lado*21-33,-25,(lado+1)*lanza_dy/2]:[0,lado * (rotor_dy/2 + lanza_dy/2 + holgura_lanceta) + cuerpo_yi + lanza_dy/2, 0])
				rotate(fabricar?[(lado+1)*90,0,90]:[90,0,0]) {
					lateral();
					// poner un plus como cojín
					translate([Xr,Zo,lado>0?0:lanza_dy]) 
						difference() {
							cylinder(r = lanza_oreja_cojin_r, h=lanza_oreja_cojin_h, center=true);
							translate([0,0,-lanza_oreja_cojin_h]) cylinder(d=agujero_clip[0], h=lanza_dy, center=true);
						}
				}

					
		translate(fabricar?[-33,5,puntera_dz/2]:[punta_xr, cuerpo_yi, punta_zr])
			rotate(fabricar?[180,0,90]:[0, puntera_angulo, 0])
				puntera();
	}
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	module puntera() {	
		difference() {
			union() {
				translate([puntera_cunna_dx/2,0, (puntera_dz - cac(puntera_dz - lanza_puntera_dz))/2])
					cube([puntera_dx+puntera_cunna_dx, puntera_dy, cac(puntera_dz - lanza_puntera_dz)], center=true);
				translate([puntera_cunna_dx/2,0, (cac(lanza_puntera_dz, true) - puntera_dz)/2])
					cube([puntera_dx+puntera_cunna_dx, ajuste_manual(puntera_dy - 2*lanza_dy   -  .2), cac(lanza_puntera_dz, true)], center=true);
			}
			translate([0,0,punta_angulo_dz_sobre_puntera+puntera_dz/2]) rotate([0, 180+punta_angulo-puntera_angulo,0]) cylinder(r=puntera_r, h=puntera_dz*2);
			mucho = 5 ;
			translate([puntera_dx/2,-(puntera_dy+mp)/2,puntera_dz/2]) rotate([0,atan(puntera_dz/puntera_cunna_dx),0]) cube([mucho, puntera_dy+mp, mucho]);
		}
	}
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	module lateral() {
		/* Hay 5 puntos fundamentales que definen la lanza que conecta el rotor con el gancho de accionamiento (siempre en posición de reposo):
			OR: oreja del rotor en reposo (de ahí para arriba va la lanza, no por abajo porque puede interferir con el borde derecho del cuerpo)
			AM: punto de apoyo para medición (quesito con el pico abajo si es cóncavo)
			AR: punto de apoyo para reposo (quesito con el arco abajo si es cóncavo)
			IP: inicio de la puntera (círculo centrado en IP)
			PU: centro de la puntera 
		Sobre esos 5 puntos se construye la lanceta, teniendo en cuenta que los de apoyo pueden ser cóncavos o convexos
		*/
		
		OR = [Xr,Zo] ;
		AM = rota_2D([cuerpo_dx/2, abertura_lanceta_z + lanza_holgura], [Xm, Zo], alfa-beta)-[Xm-Xr,0] ;
		AR = [cuerpo_dx/2, abertura_lanceta_z + lanza_holgura] ;
		IP = rota_2D([punta_xr-puntera_dx/2, punta_zr],[punta_xr, punta_zr], -puntera_angulo) ;
		PU = [punta_xr, punta_zr];
		
		module OR() { translate(OR + [0,lanza_dz/2]) circle(d=lanza_dz); }
		module AM() { codo(OR,AM,AR); }
		module AR() { codo(AM,AR,IP-[0,lanza_conexion_puntera_r]); }
		module IP() { translate(IP) 
			rotate([0,0,-puntera_angulo])
			difference() { 
				circle(r=lanza_conexion_puntera_r, $fn=fn(lanza_conexion_puntera_r*2)); 
				translate([0,-lanza_conexion_puntera_r]) 
					square(lanza_conexion_puntera_r*2); 
			} 
		}
		module codo(A,B,C) { // A[0]<=B[0]<=C[0]
			translate(B)
				if ( atan((B[1]-A[1])/(B[0]-A[0])) > atan((C[1]-A[1])/(C[0]-A[0]))) { // concavo
					difference() {
						circle(r=lanza_dz);
						rotate([0,0,90-atan((B[1]-C[1])/(C[0]-B[0]))]) 
							translate([-lanza_dz, -lanza_dz*2]) 
								square(lanza_dz*2);
						rotate([0,0,atan((B[1]-A[1])/(B[0]-A[0]))-90]) 
							translate([-lanza_dz, -lanza_dz*2]) 
								square(lanza_dz*2);
				}
				} else {
					translate([0,lanza_dz]) 
						difference() {
							circle(r=lanza_dz);
							rotate([0,0,-atan((B[1]-C[1])/(C[0]-B[0]))-90]) 
								translate([-lanza_dz,0]) square(lanza_dz*2);
							rotate([0,0,90+atan((B[1]-A[1])/(B[0]-A[0]))]) 
								translate([-lanza_dz,0]) square(lanza_dz*2);
						}
				}
		}
				
				
		linear_extrude(lanza_dy) 
			difference() {
				union() {
					translate(OR) circle(lanza_oreja_r);
					hull() { OR(); AM(); }
					hull() { AM(); AR(); }
					hull() { AR(); IP(); }
					translate(PU) 
						rotate([0,0,-puntera_angulo]) 
							translate([puntera_cunna_dx/2,lanza_puntera_dz/2-lanza_conexion_puntera_r])
								difference() {
									mucho=5 ;
									square([puntera_dx+puntera_cunna_dx, lanza_puntera_dz], center=true);
									 translate([(puntera_dx+puntera_cunna_dx)/2,-lanza_puntera_dz/2]) rotate([0,0,90-atan(puntera_dz/puntera_cunna_dx)]) square(mucho);
								}
				}
				translate(OR) circle(d=agujero_clip[0]);
			}
	}
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module cuerpo() {

// origen: x central, y y z centrados en el rodamiento
	cuerpo_dys = 19 ;
	cuerpo_dyi = 16.5 ;
	cuerpo_zie = -14.8 ; // z del inicio del estrechamiento (tiene relación con el soporte derecho del eje X)
	rodamiento_r = ajuste_manual(19 + .3) / 2 ;
	canto_superior_dy = 1.5 ;
	canto_superior_brida_dy = 1 ;
	// datos del hueco para la brida radios interior y exterior, y proporción vertical de ambos
	brida_alto_canal = 2 ;
	brida_ri = rodamiento_r ;
	brida_pi = 14 / brida_ri ;
	brida_dx = 3.2 ;
	brida_re = rodamiento_r + brida_alto_canal ;
	brida_pe = (brida_pi*brida_ri+brida_alto_canal) / brida_re ;
	// raja de salida de cable del endstop
	raja_dx = 1 ;
	raja_zi = -11.4 ;
	// endstop: coordenadas del centro y dimensiones con la holgura puesta
	endstop_x = -5.8 ;
	endstop_z = cuerpo_zi + 19.9 ;
	endstop_dx = ajuste_manual( 13 + .2 ) ;
	endstop_dy = ajuste_manual( 6 + .15) ;
	endstop_dz = 6.5 ;
	endstop_agujero_r = 2.1 / 2 ;
	endstop_agujero_ox = 3.17 ; // offset respecto a endstop_x (a cada lado)
	endstop_agujero_oz = 1.55 ;
	endstop_holgura_meter = .1 ;
	// cavidad interior
	canal_actuador_xi = -10.5 ;
	pared_derecha_dx = 1.01 ;
	// relacionado con el rotor
	rotor_hueco_izd_r = rotor_x + cuerpo_dx/2 - .6 ; // mínima a la izquierda: .6
	rotor_hueco_dch_r = rotor_r + .8 ;
	espacio_para_orejas_r = 3.5 ; // tanto espacio es más bien por el actuador	
	// presor
	presor_hueco_dy = ajuste_manual(8.8+.2  + .3) ;
	presor_eje_dy = ajuste_manual(14.1 + .3) ;
	presor_eje_dx = ajuste_manual( 2 + .3 );
	presor_eje_dz = ajuste_manual( 2 + .4 );
	presor_eje_x = 9 ;
	presor_eje_z =  cuerpo_zi + 5.4 ;
	presor_canal_x = 6 ;
	presor_claraboya_dx = 8 ;
	presor_claraboya_dy = endstop_dy + 2 * endstop_holgura_meter ;
	presor_claraboya_pared_dx = 1.5 ;
	// sosten del muelle del presor
	sosten_dx = 2 ;
	sosten_dy = 5 ;
	sosten_solapa_dz = 1 ;
	sosten_apoyo_inf_z = abertura_lanceta_z - .8 ;
	sosten_alojamiento_dx = 1 ; // confío en la rebaba de la 1ª capa para que sostenga el muelle (y si no, se pega algo)
	sosten_alojamiento_r = ajuste_manual(3/2  +  .2);
	sosten_no_alojamiento_r = sosten_alojamiento_r - .4 ;
	sosten_alojamiento_z = cuerpo_zi + 17.35 ;
	// agarre para el sosten del muelle del presor
	agarre_holgura_dx = .2 ;
	agarre_holgura_dy = .4 ;
	agarre_holgura_dz = .2 ;
	agarre_dy = sosten_dy + 2*agarre_holgura_dy + 2 ;
	agarre_dx = sosten_dx + agarre_holgura_dx + 1 ;
	agarre_dz = 1 ;
	agarre_inf_suelo = .2 ;
	// sistema que empuja la lanceta, porque no cae por su propio peso
	empujador_lanceta_dx = 2 ;
	empujador_lanceta_x = cuerpo_dx/2 - 4.5 ;
	empujador_lanceta_holgura_dx = .6 ;
	empujador_lanceta_holgura_dy = 1 ;
	empujador_lanceta_hueco_inf_dy = 8 ;
	empujador_lanceta_muelle_ext = ajuste_manual( 4.5 + .4 );
	empujador_lanceta_muelle_int = ajuste_manual( 3 - .4 );
	empujador_lanceta_muelle_apoyo_dz = 1.3 ;
	// otras
	recorte_encaje_motor_dista_pared_dcha = 1.5 ;
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	translate(fabricar?[0,-25,-cuerpo_zi]:[0,0,0]) {
		difference() {
		
			exterior();
			
			translate([endstop_x, -mp, raja_zi])
				cube([raja_dx, rodamiento_r, 0 - raja_zi]);
			// alojamiento para el endstop
			local() {
				cq = [endstop_dx + 2* endstop_holgura_meter, endstop_dy + 2 * endstop_holgura_meter, 0 - (endstop_z + endstop_dz/2)];
				translate([endstop_x-cq[0]/2, cuerpo_yi - cq[1]/2, -cq[2]]) cube(cq);
			}
			local() {
				cq = [endstop_dx, endstop_dy, 0 - (endstop_z - endstop_dz/2)];
				translate([endstop_x-cq[0]/2, cuerpo_yi - cq[1]/2, -cq[2]]) cube(cq);
			}
			// alojamiento para travesaños que sujetan el endstop: entrada grande, y salida ciega igual que el agujero del endstop
			for ( lado = [-1,1] ) {
				translate([endstop_x+lado*endstop_agujero_ox, cuerpo_yi+cuerpo_dyi/4+mp, endstop_z+endstop_agujero_oz])
					cube([endstop_agujero_r*2, cuerpo_dyi/2, cac(endstop_agujero_r*2, true)], center=true);
				translate([endstop_x+lado*endstop_agujero_ox, cuerpo_yi-cuerpo_dyi/4+(cuerpo_dyi-ancho_cavidad)/2, endstop_z+endstop_agujero_oz])
					rotate([90,0,0]) {
						cylinder(r=endstop_agujero_r, h=cuerpo_dyi/2, center=true);
						resize([agujero_clip[2],agujero_clip[1],0]) 
							cylinder(r=1, h=cuerpo_dyi+mp, center=true);
					}
			}
			// canal para el actuador (sale al exterior y respeta un apoyo para el endstop
			translate([canal_actuador_xi , cuerpo_yi - ancho_cavidad/2, abertura_lanceta_z])
				cube([cuerpo_dx, ancho_cavidad, techo_cavidad - abertura_lanceta_z]);
			// rotor
			translate([rotor_x, cuerpo_yi, rotor_z]) {
				rotate([90,0,0]) {
					resize([agujero_clip[2],agujero_clip[1],0]) cylinder(r=1, h=cuerpo_dyi+mp, center=true);
					difference() {
						cylinder(r=rotor_hueco_izd_r, h=ancho_cavidad, center=true);
						difference() {
							translate([presor_canal_x-rotor_x+(rotor_hueco_izd_r+mp)/2,0,0]) cube([rotor_hueco_izd_r+mp, (rotor_hueco_izd_r+mp)*2, ancho_cavidad+mp], center=true);
							cylinder(r=rotor_hueco_dch_r, h=ancho_cavidad + mp, center=true);
						}
					}
					// quitar unos flecos que pueden quedar
					translate([presor_canal_x-rotor_x-(rotor_hueco_izd_r+mp)/2,0,0]) cube([rotor_hueco_izd_r+mp, (rotor_hueco_izd_r+mp)*2, ancho_cavidad], center=true);
				}
				// hueco para las orejas del actuador
				translate([-oreja_z, 0, oreja_x]) // [-z,0,x] representa un giro de -90º en Y respecto a [x,0,z]
					rotate([90,0,0])					
						cylinder(r=espacio_para_orejas_r, h=ancho_cavidad, center=true);						
				// abrir camino para introducir la lanceta ya montada con puntera y rotor
				local() {
					dx = cuerpo_dx/2-rotor_x - pared_derecha_dx;
					dy = ancho_cavidad;
					dz = abertura_lanceta_z-cuerpo_zi;
					translate([dx,-dy/2,-rotor_z+abertura_lanceta_z]) 
						difference() {
							rotate([0,-32,0]) 
								translate([-dx,0,0])
									cube([dx, dy, dz]);
							translate([mp-dx,-mp/2,mp])
								cube([dx, dy+mp, 0-abertura_lanceta_z]);
						}
				}						
			}

			// presor
			translate([0, cuerpo_yi - presor_hueco_dy/2, cuerpo_zi-mp]) {
				cube([cuerpo_dx/2 - pared_derecha_dx, presor_hueco_dy, techo_cavidad - cuerpo_zi]);
				// recorte para que se aloje el rotor bien aún cuando baile debido a holguras exageradas 
				intersection() { 			
					dx = cuerpo_dx/2 - pared_derecha_dx - recorte_encaje_motor_dista_pared_dcha;
					dy = presor_hueco_dy + 2*recorte_encaje_rotor_profundo;
					translate([0, -recorte_encaje_rotor_profundo, 0]) 
						cube([dx, dy, canal_forro_dx - recorte_encaje_rotor_dejando + mp]);
					translate([0,presor_hueco_dy/2,dy/2-2*cuerpo_dyi*cos(45) +canal_forro_dx - recorte_encaje_rotor_dejando - recorte_encaje_rotor_profundo + mp ]) 
						rotate([45,0,0]) 
							cube([dx+mp, cuerpo_dyi, cuerpo_dyi]);
				}
			}
			// vertical canal eje
			local() {
				alto = presor_eje_z - cuerpo_zi + presor_eje_dz/2;
				translate([presor_canal_x, cuerpo_yi, cuerpo_zi + (alto-mp)/2])
					cube([presor_eje_dx, presor_eje_dy, alto+mp], center=true);
			}
			// horizontal canal eje
			local() {
				profundo = ajuste_manual(presor_eje_x - presor_canal_x  +  .2 );
				translate([presor_canal_x + profundo/2, cuerpo_yi, presor_eje_z]) {
					cube([profundo, presor_eje_dy, presor_eje_dz], center=true);
					translate([profundo / 2, 0, 0])	
						rotate([90,30,0])
							cylinder(d=presor_eje_dz, h=presor_eje_dy, center=true, $fn=6);
				}
			}
			// ventana para colocar el muelle del presor
			translate([cuerpo_dx/2 - presor_claraboya_pared_dx - presor_claraboya_dx, cuerpo_yi - presor_claraboya_dy/2, techo_cavidad - mp])
				cube([presor_claraboya_dx, presor_claraboya_dy, 0-techo_cavidad]);
			// guía para el empujador de la lanceta (que no cae por su propio peso)
			local() {
				dx = empujador_lanceta_dx + empujador_lanceta_holgura_dx;
				translate([empujador_lanceta_x-dx/2, cuerpo_yi - ancho_cavidad/2, techo_cavidad - mp])
					cube([dx, ancho_cavidad, 0-techo_cavidad]);
			}
			// recorte para evitar dobleces de la brida, con transición que no requiere soporte
			local() {
				zi = - brida_pi * sqrt(pow(rodamiento_r,2) - pow(  endstop_dy/2+endstop_holgura_meter  + cuerpo_yi, 2));
				zs = - brida_pi * sqrt(pow(rodamiento_r,2) - pow(-(endstop_dy/2+endstop_holgura_meter) + cuerpo_yi, 2));
				dz = zs + rodamiento_r * brida_pi ;
				sporte = brida_dx/tan(angulo_voladizo);

				translate([brida_dx/2, cuerpo_yi - (endstop_dy + 2*endstop_holgura_meter)/2, zs]) 
				difference() {
					translate([-brida_dx, 0, - dz - mp]) 
						cube([brida_dx, endstop_dy + 2*endstop_holgura_meter, sporte + dz + mp]);
					lado=brida_dx * 2;			
					translate([0,-mp/2,0])
						rotate([0,-angulo_voladizo,0])	
							cube([lado, endstop_dy + 2*endstop_holgura_meter + mp, lado]);		
				}
			}
		}

		if (hacer_soportes) {
			// soporte lado presor
			local() {
				cubo = [cuerpo_dx/2-presor_canal_x-pared_derecha_dx-sephsop, presor_hueco_dy - sephsop*2, abertura_lanceta_z - cuerpo_zi];
				translate([cuerpo_dx/2 - pared_derecha_dx - sephsop - cubo[0], cuerpo_yi - cubo[1]/2, cuerpo_zi])
					soporte_paralelo(ajuste_manual(cubo  -  [.2,0,0]), center=false); // Kisslicer mariconea con ese soporte si el tabique derecho está cerca de lo otro
			}
			translate([canal_actuador_xi + sephsop, cuerpo_yi - ancho_cavidad/2 + sephsop, cuerpo_zi])
				soporte_paralelo([presor_canal_x - canal_actuador_xi - sephsop * 2, ancho_cavidad - 2 * sephsop, techo_cavidad - cuerpo_zi - gapplasop], center=false);
			translate([presor_canal_x, cuerpo_yi - ancho_cavidad/2 + sephsop, abertura_lanceta_z + gapplasop])
				soporte_paralelo([cuerpo_dx/2 - presor_canal_x, ancho_cavidad - 2 * sephsop, techo_cavidad - abertura_lanceta_z - gapplasop * 2], center=false);
			// soportillo del hueco del eje del presor
			local() {
				sephsop = ajuste_manual(sephsop  +  .2);
				gapplasop = $alto_de_capa; // la asignación normal de .25 me está fallando :(
				entra_en_cul_de_sac = .3 ;
				dxph = presor_eje_x - presor_canal_x + entra_en_cul_de_sac;
				dyph = (presor_eje_dy - presor_hueco_dy)/2 - ajuste_manual(sephsop - .2);
				translate([presor_canal_x, cuerpo_yi - presor_eje_dy/2 + sephsop, cuerpo_zi])
					cube([$espesor, presor_eje_dy - 2 * sephsop, presor_eje_z - cuerpo_zi]);
				for (lado = [-1, 1])				
					translate([presor_canal_x + dxph/2, cuerpo_yi + lado * (presor_hueco_dy + dyph)/2, presor_eje_z ])					
						cube([dxph, dyph , presor_eje_dz - 2 * gapplasop], center=true);
			}
			translate([cuerpo_dx/2 + sephsop, cuerpo_yi - agarre_dy/2, sosten_apoyo_inf_z + gapplasop])
				difference() {
					cube([agarre_dx - sephsop, agarre_dy, techo_cavidad - sosten_apoyo_inf_z - 2*gapplasop]);
					translate([-mp, (agarre_dy - (sosten_dy+2*agarre_holgura_dy))/2,-mp/2])
						cube([sosten_dx + agarre_holgura_dx- sephsop +mp, sosten_dy+2*agarre_holgura_dy, techo_cavidad - sosten_apoyo_inf_z - 2*gapplasop + mp]);					
				}
		}
	}
	
	translate(fabricar?[22,-35,0]:[cuerpo_dx/2 + agarre_holgura_dx/2 + sosten_dx, cuerpo_yi, (techo_cavidad + sosten_apoyo_inf_z)/2])
		rotate(fabricar?[0,0,0]:[0,90,180])
			sosten();

	afeita(afeitado)
		translate(fabricar?[16,-22,empujador_lanceta_dx/2]:[empujador_lanceta_x, cuerpo_yi, techo_cavidad])
			rotate(fabricar?[0,90,0]:[0,0,0])
				empujador_lanceta();
			
			
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
	module empujador_lanceta() {
		dz = 0 - techo_cavidad - rodamiento_r;
		dzh = ajuste_manual(techo_cavidad - abertura_lanceta_z - lanza_dz  - .25);
		difference() {
			translate([0,0,dz/2]) 
				cube([empujador_lanceta_dx, ancho_cavidad - empujador_lanceta_holgura_dy, dz], center=true);
			translate([0,0,(dzh-mp)/2])
				cube([empujador_lanceta_dx + mp, empujador_lanceta_hueco_inf_dy, dzh+mp], center=true);
			translate([0,0,dzh + empujador_lanceta_muelle_apoyo_dz])
				difference() {
					cylinder(d=empujador_lanceta_muelle_ext, h=dz);
					translate([0,0,-mp/2]) 
						cylinder(d=empujador_lanceta_muelle_int, h=dz+mp);
				}
		}
	}
			
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
	module sosten() {
		za = afeitado ? $alto_de_capa : 0 ;
		if (afeitado)
			linear_extrude($alto_de_capa) sosten_2D(0, afeitado);
		translate([0,0,za])
			linear_extrude(sosten_alojamiento_dx - za)
				sosten_2D(0);
		translate([0,0,sosten_alojamiento_dx])
			linear_extrude(sosten_dx - sosten_alojamiento_dx)
				sosten_2D(1);
				
		module sosten_2D(modelo, merma=0) {
			difference() {
				square([techo_cavidad - sosten_apoyo_inf_z +  + sosten_solapa_dz * 2 - 2*merma, sosten_dy - 2*merma], center=true);
				translate([(techo_cavidad + sosten_apoyo_inf_z)/2 - sosten_alojamiento_z,0])
					circle((modelo==0 ? sosten_no_alojamiento_r : sosten_alojamiento_r) - merma);
			}
		}
	}
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	module exterior() {
		
		render() {
			translate([-cuerpo_dx/2,-cuerpo_dys/2, 0])
				rotate([0,90,0]) {
					linear_extrude(afeitado) corte_X(0);
					translate([0, 0, afeitado]) linear_extrude((cuerpo_dx - brida_dx)/2 - afeitado) corte_X(1);
					translate([0, 0, (cuerpo_dx - brida_dx)/2]) linear_extrude(brida_dx) corte_X(2);
					translate([0, 0, (cuerpo_dx + brida_dx)/2]) linear_extrude((cuerpo_dx - brida_dx)/2 - afeitado) corte_X(1);
					translate([0, 0, cuerpo_dx - afeitado]) linear_extrude(afeitado) corte_X(0);
				}		
			difference() {
				translate([ cuerpo_dx/2, cuerpo_yi+agarre_dy/2, sosten_apoyo_inf_z])					
					rotate([90,0,0])
						linear_extrude(agarre_dy) {
							polygon([[0,0], [agarre_dx,0], [agarre_dx, -agarre_dz - agarre_inf_suelo - agarre_holgura_dz], [0,-(agarre_dx/tan(angulo_voladizo)+agarre_dz+agarre_inf_suelo+agarre_holgura_dz)]]);
							translate([0,techo_cavidad-sosten_apoyo_inf_z])
								square([agarre_dx, agarre_dz]);
						}
				translate([cuerpo_dx/2, cuerpo_yi - sosten_dy/2 -agarre_holgura_dy, sosten_apoyo_inf_z - sosten_solapa_dz - agarre_holgura_dz]) 
					cube([sosten_dx+agarre_holgura_dx, sosten_dy + agarre_holgura_dy*2, (techo_cavidad - sosten_apoyo_inf_z) + sosten_solapa_dz * 2 + agarre_holgura_dz + mp]);
			}
		}

		module corte_X(modelo) {
			difference() {
				union() {
					square([0 - cuerpo_zie, cuerpo_dys]);
					translate([0-cuerpo_zie,0])
						square([cuerpo_zie - cuerpo_zi - $alto_de_capa, cuerpo_dyi]);
					if (modelo>0)
						translate([-$alto_de_capa - cuerpo_zi, afeitado])
							square([$alto_de_capa, cuerpo_dyi - 2 * afeitado]);
					// transición de la parte inferior a la superior
					ancho = (cuerpo_dys-cuerpo_dyi)/tan(angulo_voladizo);
					largo = sqrt(pow(cuerpo_dys-cuerpo_dyi, 2)+pow(ancho, 2));
					translate([ancho-cuerpo_zie, cuerpo_dyi])
						rotate(180-angulo_voladizo)
							square(largo);
				}
				translate([sqrt(2*canto_superior_dy*rodamiento_r-pow(canto_superior_dy, 2)) - cuerpo_dys, 0]) square(cuerpo_dys);
				translate([0, cuerpo_dys/2]) circle(r=rodamiento_r);
				if (modelo==2) {
					translate([0, cuerpo_dys/2])
						difference() {
							scale([brida_pe,1]) circle(brida_re);
							scale([brida_pi,1]) circle(brida_ri);
						}
					recorte = sqrt(2*canto_superior_brida_dy*rodamiento_r-pow(canto_superior_brida_dy, 2));
					square([recorte, canto_superior_brida_dy]);
					
					Y = brida_pe * sqrt(pow(brida_re,2)-pow(cuerpo_dys/2,2));
					Yc = brida_pe * sqrt(pow(brida_re,2)-pow(cuerpo_dys/2-canto_superior_brida_dy,2));
					for (lado = [0,1])
						translate([Y - mp, lado * (cuerpo_dys-canto_superior_brida_dy) - mp/2])
							square([Yc-Y + mp, canto_superior_brida_dy + mp]);
				}
			}
			
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module separador_rotor() {
	buje_r = 3 ;
	buje_dy = (ancho_cavidad - rotor_dy) / 2 - holgura_rotor;
	
	difference() {
		cylinder(r=buje_r, h=buje_dy);
		translate([0,0,-mp/2])
			cylinder(d=agujero_clip[0], h=buje_dy + mp);			
	}
}

module rotor() {
	// origen: el eje de rotación, orientado en posición de medición
	principal_dz = 14.8 ;
	oreja_dy = 1 ;
	oreja_r = agujero_clip[0]/2 + .9 ;
	canal_dx = ajuste_manual( .85 + .3 );
	canal_x = -5 ;
	canal_dy = ajuste_manual( 2.5 + .1 );
	canal_dz = 20 ;
	
	presor_eje = [12.17, -1.77] ;
	presor_brazo = 6 ;
	presor_angulo_medicion = -17 ;
	presor_angulo_reposo = -25 ;
	presor_rueda_r = ajuste_manual(4 + .1);
	recorte_para_presor = 2 * ([1.95, 1] + [.5, .5]);
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	translate(fabricar?[-15,0,0]:[rotor_x, cuerpo_yi, rotor_z])
		rotate(fabricar?[0,0,0]:[90,-90,0])
			translate(fabricar?[0,0,0]:[0,0,-rotor_dy/2]) { 
				difference() {			
					union() { // cuerpo del rotor
						// capa afeitada si procede
						if (afeitado) 
							linear_extrude($alto_de_capa) en_2D(oreja=1, merma=afeitado); 
						// oreja inferior
						translate([0,0,afeitado?$alto_de_capa:0]) 
							linear_extrude(oreja_dy - $alto_de_capa * (afeitado?1:0)) en_2D(oreja=1);
						// gap de separación para el soporte de la oreja superior
						translate([0,0,oreja_dy]) 
							linear_extrude(gapplasop) en_2D(oreja=0);
						// soporte de la oreja superior (con el canal)
						difference() {
							translate([0,0,oreja_dy+gapplasop]) 
								linear_extrude(rotor_dy-2*(oreja_dy + gapplasop)) en_2D(oreja=2);
							translate([canal_x, oreja_z-canal_dz/2, rotor_dy/2])
								cube([canal_dx, canal_dz + mp, canal_dy], center=true);
						}
						// gap de separación para la oreja superior
						translate([0,0,rotor_dy-(oreja_dy + gapplasop)]) 
							linear_extrude(gapplasop) en_2D(oreja=0);
						// oreja superior
						translate([0,0,rotor_dy-oreja_dy]) 
							linear_extrude(oreja_dy) en_2D(oreja=1);	
					}
					// recortar más por cuestiones prácticas que teóricas (holgura y falta de precisión al montar)
					for (lado=[0,1]) translate([0,0,lado * rotor_dy]) recorte_de_encaje(lado==0);
				}				
				translate([0,0,rotor_dy-.001]) // .001 para forzar la unión de volúmenes
					separador_rotor();
					
				translate(fabricar?[4,-10,0]:[0,0,0]) rotate(fabricar?[0,0,0]:[180,0,0]) separador_rotor(); // no necesita afeitado
			}
		
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	module recorte_de_encaje(abajo) {
		mirror([0,0,abajo ? 0 : 1])
			translate([canal_x-canal_forro_dx/2 + recorte_encaje_rotor_dejando,oreja_z-canal_dz-mp,0])
			difference() {
				taquito = [canal_forro_dx,canal_dz-oreja_z-rotor_r+mp,recorte_encaje_rotor_profundo];
				translate([0,0,-mp]) cube(taquito+[0,0,mp]);
				translate([0,0,0]) rotate([0,-45,0]) cube(taquito);
				if (abajo && hacer_soportes) 
					translate([recorte_encaje_rotor_profundo,-sephsop,-gapplasop]) cube(taquito+[0,mp,0]);
			}
	}					

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	module en_2D(oreja, merma=0) {
		po = [oreja_x, oreja_z];
		difference() {
			union() {
				difference() {
					union() {
						circle(rotor_r - merma);
						e = -canal_forro_dx/2 - canal_x + merma*2;
						translate([merma-e,-rotor_r+merma]) square([e, rotor_r*2 - merma*2]);
					}
					// limite superior
					translate([-rotor_r, oreja_z-merma]) square(rotor_r*2);
					// limite izquierdo 
					translate([canal_x-rotor_r*2+canal_forro_dx/2-merma, -rotor_r]) square(rotor_r*2);
					// eje
					circle(d=agujero_clip[0] + merma);
					// escote de medición
					translate(presor_eje + presor_brazo * [sin(presor_angulo_medicion), cos(presor_angulo_medicion)])
						circle(presor_rueda_r + merma);
					// escote de reposo
					rotate([0,0,-90])
						translate(presor_eje + presor_brazo * [sin(presor_angulo_reposo), cos(presor_angulo_reposo)])
							circle(presor_rueda_r + merma);
				}
				if (oreja==1)
					translate(po)
						circle(oreja_r - merma);
				else if (oreja==2 && hacer_soportes)
					difference() {
						translate(po)
							circle(oreja_r);
						en_2D(oreja=0, merma=-.5);
					}
				
				difference() {
					translate([canal_x-canal_forro_dx/2 + merma , oreja_z-canal_dz+merma ]) square([canal_forro_dx-2*merma, canal_dz-2*merma]);
					rotate([0,0,-90])
						translate(presor_eje) 
							rotate([0,0,-presor_angulo_reposo]) {
								recortillo = recorte_para_presor + [1,1] * merma * 2 ;
								translate(-recortillo/2) 
									square(recortillo);
							}
				}
			}
			translate(po)
				circle(d=agujero_clip[0] + merma);
		}
	}
}
