////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// portacarretes para servir filamento en el eje Y, para colocar sobre el marco de mAka
// It is licensed under the Creative Commons - GNU LGPL 2.1 license.
// © 2014-2017 by luiso gutierrez (sacamantecas)
//
//

use <utilidades.scad>

$alto_de_capa=.25;

dx=10 ;
rulo_z = 110 ;
rulo_y = 90 ;

mp=.1;
rot=[0,90,0];





afeita()
	rotate([0,0,45])
	{
		translate([46,0,dx/2]) rotate([0,90,64.4]) uno();
		translate([-46,0,dx/2]) rotate([0,-90,-64.4]) uno();
	}

module uno() {		
	difference() {
		union() {
			hull() {
				cilindro(d=25,h=dx, s=[.6,1,1], r=rot, t=[0,6,2]);
				cilindro(d=21,h=dx,r=rot,t=[0,rulo_y,rulo_z]);
			}
			hull() {
				cilindro(d=20, h=dx, s=[.6,1,1], r=rot, t=[0,10,-60]);
				cilindro(d=21,h=dx,r=rot,t=[0,rulo_y,rulo_z]);
			}
			cubo([dx,15,60], t=[0,15/2+10,-6]);
		}
		cilindro(d=10.5, h=dx+mp, r=rot, t=[0,rulo_y,rulo_z]);
		cubo([dx+mp, 10, 60+.4], [0,5,-30]);
		cilindro(d=10, h=dx+mp, s=[2,1,1], r=rot, t=[0,10,-30]);

		dY=rulo_y+20;
		dZ=rulo_z+60+40;
		difference() {
			cubo([dx, dY, dZ], t=[0,dY/2, dZ/2-80]);
			minkowski() {
				difference() {
					cubo([dx+mp, dY, dZ], t=[0,dY/2, dZ/2-80]);
					difference(){
						hull() {
							cilindro(d=25,h=dx+mp*2, s=[.8,1,1], r=rot, t=[0,6,2]);
							cilindro(d=21,h=dx+mp*2,r=rot,t=[0,rulo_y,rulo_z]);
							cilindro(d=20, h=dx+mp*2, s=[.6,1,1], r=rot, t=[0,10,-60]);
						}
						cubo([dx+mp*3,100,100], [0,-40,-20]);
					}
				}
				cilindro(d=26, h=.1, r=rot);
			}
		}		
	}
}