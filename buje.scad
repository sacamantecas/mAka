//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// buje para el carrete de filamento
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luiso gutierrez (sacamantecas)
//
//

// agujero_carrete=32 -.2 ;
// agujero_carrete=39 -.2 ;
// agujero_carrete=52 -.3 ;
// agujero_carrete=38 - .3 ;
 agujero_carrete=61.2 - .3 ;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
alto_entra=8 ;
alto_cono = 3 ;

alto_de_capa = .4 ;
afeitado = .25 ;


// rodamiento de 12x28x8
rodato_diam = 28 +.4 ;
rodato_entra = 8 ;
rodato_agujero = 25 ;


$fa = 1 ;
$fs = 1 ;
mp = .1 ;

difference() {
	union() {
		cylinder(d=agujero_carrete - 2*afeitado, h=alto_de_capa + mp);	 // afeitado exterior (por dentro no hace falta)
		translate([0,0,alto_de_capa]) cylinder(d=agujero_carrete, h=alto_entra - alto_de_capa);	
		translate([0,0,alto_entra]) cylinder(d1=agujero_carrete, d2=agujero_carrete+alto_cono, h=alto_cono);
	}
	translate([0,0,alto_entra+alto_cono+.1/2 - rodato_entra/2]) cylinder(d=rodato_diam, h=rodato_entra+.1, center=true);
	cylinder(d=rodato_agujero, h=100, center=true);
}


