/*
Pieza muy rara que se apoya en el canto superior derecho de la pieza derecha del carro X
Consta de 2 piezas pegadas entre si:
	- una vertical en forma de T cuyo brazo vertical encaja en el hueco de los rodamientos, y el horizonal tiene 3 agujeros: 2 para el ventilador y un tercero para un potenciómetro
	- una horizontal en C que se agarra a la varilla de Z y se pega a la T

El origen de coordenadas va a ser en X el lado derecho del carro X, para Y la posición de la varilla, y para Z el borde superior del carro X	
	
*/

$fa=1; $fs=1;
X=0; Y=1; Z=2;
mp=.1;
use <basico.scad>


fabricar=1;



vent_ancho = 60;
vent_agujeros_separa = 50;
vent_agujeros_d = correccion(4  +  .3); // ya holgado
vent_eje_Y = 3; // va descentrado respecto a la varilla, algo hacia detrás
vent_di = 57; // diámetro interior
vent_alzado = 2; // cuánto queda el borde inferior por encima de Z=0

pote_agj_d = 8; // ya holgado;
pote_separa = 1;
pote_d = 13;
pote_Z = vent_alzado + (vent_ancho - vent_agujeros_separa) / 2; // alineado con los agujeros del ventilador
pote_Y = vent_eje_Y - vent_ancho/2 - pote_d/2 - pote_separa;


varilla_d = correccion(10  + .1);
varilla_X = -11.5;
rodamiento_d = 19.2; //  ya holgado

Tv_dy = correccion(10.4  - .3);
Tv_dz = 30;
T_dx = 4;
Th_dz = (vent_ancho - vent_agujeros_separa) +vent_alzado + 1;
Th_dy = vent_ancho;
Th_hueco_tuerca_dx = 2;
Th_tuerca_d = 8.2;

C = correccion([20, 36, 2.5] + [0, -.1, 0]);
C_penetra = 2;
C_X = -T_dx -C[X] + C_penetra;
C_holgura_varilla = 1; // una holgura en el lado derecho para facilitar la colocación


// la T
//render()
rotate([0, fabricar?90:0,0])
difference() {
	translate([-T_dx, 0, 0]) rotate([0,90,0]) linear_extrude(T_dx) Tv_2D();
	translate([varilla_X, 0, -Tv_dz - mp]) cylinder(d=rodamiento_d, h=Tv_dz + mp);
	translate([-T_dx-mp, vent_eje_Y, vent_alzado + (vent_ancho - vent_agujeros_separa)/2])
		for (lado=[-1, 1])
			translate([0, lado * vent_agujeros_separa/2])
				rotate([0, 90])
					rotate([0,0,30])
						cylinder(d=Th_tuerca_d, h=Th_hueco_tuerca_dx + mp, $fn=6); 
	holgura_C = [0, .15, .15];
	translate([C_X, -(C[Y]+holgura_C[Y])/2, -mp]) cube(C + holgura_C + [0,0,mp]);
}

// la C
translate(fabricar?[-19,5]:[0,0])
rotate([0, 0, fabricar ? -90 : 0,0])
difference() {
	translate([C_X, -C[Y]/2]) cube(C);
	translate([varilla_X, 0, -mp]) cylinder(d=varilla_d, h=C[Z] +2*mp);
	translate([varilla_X, -varilla_d/2, -mp]) cube([C_holgura_varilla, C[Y]/2 + varilla_d/2+mp, C[Z] + 2*mp]);
	translate([varilla_X + C_holgura_varilla, 0, -mp]) cylinder(d=varilla_d, h=C[Z] +2*mp);
	translate([varilla_X-varilla_d/2, 0, -mp]) cube([varilla_d + C_holgura_varilla, C[Y]/2+mp, C[Z] + 2*mp]);
}


if (! fabricar) %guias();


module guias() {
	av = 15; // ancho del ventilador
	translate([av/2, vent_eje_Y, vent_alzado + vent_ancho/2])
		difference() {
			cube([av, vent_ancho, vent_ancho], center=true);
			rotate([0, 90, 0])cylinder(d=vent_di, h=av+1, center=true);
			pulopo = vent_agujeros_separa/2 * sqrt(2);
			for (angulo=[45, 135, 225, 315])
				translate([0, pulopo * cos(angulo), pulopo * sin(angulo)])
					rotate([0, 90,0]) cylinder(d=vent_agujeros_d, h=av+1, center=true);
		}
	translate([0, pote_Y, pote_Z])
		rotate([0, 90, 0]) 
		rotate([0, 0, -90]) 
			translate([0,0,-20]) {
				cylinder(d=pote_d, h=13);
				translate([-13/2, -13/2, 0])cube([8,13,13]);
				translate([0,0,13]) cylinder(d=7, h=13);
				translate([0,0,26]) cylinder(d=6, h=13);
			}
	
}
	
	

module Tv_2D() {
	translate([0, -Tv_dy/2]) square([Tv_dz, Tv_dy]);
	difference() {
		union() {
			translate([-Th_dz, vent_eje_Y - Th_dy/2]) square([Th_dz, Th_dy]);
			// soporte del potenciómetro unido como es debido
			translate([-pote_Z, pote_Y]) {
				intersection() { circle(d=pote_d); translate([-pote_d/2, -pote_d/2]) square([pote_d/2, pote_d]); }
				resize([pote_Z, 0]) intersection() { circle(d=pote_d); translate([0, -pote_d/2]) square(pote_d/2); }
				translate([pote_Z-Th_dz, 0]) square([Th_dz, vent_eje_Y - vent_ancho/2 - pote_Y]); }
		}
		// agujeros para el aire, el potenciómetro y los tornillos del ventilador
		translate([-vent_ancho/2 - vent_alzado, vent_eje_Y]) circle(d=vent_di);
		translate([-pote_Z, pote_Y]) circle(d=pote_agj_d);
		translate([-vent_alzado - (vent_ancho - vent_agujeros_separa)/2, vent_eje_Y])
			for (lado=[-1, 1])
				translate([0, lado * vent_agujeros_separa/2])
					circle(d=vent_agujeros_d); 
	}
}