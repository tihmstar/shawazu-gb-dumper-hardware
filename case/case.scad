

board_height = 90;
board_width  = 70;
case_border = 1.5;
pin_height = 6;

case_height = 14;
cart_wall_corners = 5;
usb_cutout_width = 12;


top_walls = 3;
top_wall_factor = 0.70;
top_side_wall_offset = 10;

indent_factor = 0.5;

module bottom(x = 0, y = 0, z = 0){
    pin_radius_small = 2;
    pin_radius_large = 4;
    
    translate([x-(board_width+case_border*2)/2,y-(board_height+case_border*2)/2,z]){
        cube([board_width+case_border*2,board_height+case_border*2,2]);
        color("blue"){
            translate([case_border,case_border])
                cube([board_width,board_height,2]);
        }
        color("red"){
            translate([3.5+case_border,case_border+board_height-15.5-7,0]){
                cylinder(pin_height+case_border, pin_radius_small, pin_radius_small);
            }

            translate([3.5+case_border,case_border+board_height-15.5,0]){
                cylinder(pin_height+case_border, pin_radius_small, pin_radius_small);
            }
            translate([case_border+board_width-3.5,case_border+board_height-15.5,0]){
                cylinder(pin_height+case_border, pin_radius_small, pin_radius_small);
            }


            translate([case_border+board_width-6,case_border+5.5,0]){
                cylinder(pin_height+case_border, pin_radius_large, pin_radius_large);
            }
        }
        
        /*
            Sidewalls
        */
        translate([0,0,0]){
            difference(){
                cube([1,board_height+case_border*2,case_height]); //left
                
                translate([-1,case_border+9,case_border*2]){
                    cube([3,usb_cutout_width,8+10]);
                }


                translate([0.5,indent_pos,case_height-top_walls+1/2])
                    cube([1.5,board_height*top_wall_factor*indent_factor+4,1]);
            }
        }
        
        indent_pos = case_border+(board_height*(1-top_wall_factor)/2)+top_side_wall_offset + 15;
    
        translate([board_width+case_border*2-1,0,0]){
            difference(){
                cube([1,board_height+case_border*2,case_height]); //right
                
                translate([-1,indent_pos,case_height-top_walls+1/2])
                    cube([1.5,board_height*top_wall_factor*indent_factor+4,1]);
            }
        }


        translate([0,0,0])
            cube([board_width+case_border*2,1,case_height]); //bottom

        translate([0,case_border*2+board_height-1,0]){
            difference(){
                cube([board_width+case_border*2,1,case_height]); //top
                
                
                translate([case_border+cart_wall_corners,-1,case_border*2]){
                    cube([board_width-cart_wall_corners*2,3,case_height]);
                }
            }
        }
    }
}


module top(x = 0, y = 0, z = 0){
    switch_cutout_width = 7;
    switch_cutout_height = 15;

    translate([x-(board_width+case_border*2)/2,y-(board_height+case_border*2)/2,z+case_height]){
        difference(){
            color("purple")
            cube([board_width+case_border*2,board_height+case_border*2,2]);

            //power selector
            translate([case_border+0.5,case_border+37-switch_cutout_height/2+2,-5])
                cube([switch_cutout_width,switch_cutout_height,10]);
            
            //bootsel
            translate([case_border+10,case_border+9,-5]){
                cube([5,5,10]);                
            }
        }

        
        /*
            Sidewalls
        */
        translate([1,case_border+(board_height*(1-top_wall_factor)/2)+top_side_wall_offset,-top_walls]){
            color("green")
            cube([1,board_height*top_wall_factor,case_border+top_walls]); //left                
            translate([0.25,board_height*top_wall_factor-(1-indent_factor)*board_height*top_wall_factor/2,1]){
                rotate([0,180,0])
                rotate([90,0,0])
                color("blue")
                cylinder(board_height*top_wall_factor*indent_factor,1,1,$fn=3);
            }
        }

        translate([board_width+case_border-0.5,case_border+(board_height*(1-top_wall_factor)/2)+top_side_wall_offset,-top_walls]){
            color("green")
            cube([1,board_height*top_wall_factor,case_border+top_walls]); //right
            translate([0.75,board_height*top_wall_factor-(1-indent_factor)*board_height*top_wall_factor/2,1]){
                rotate([90,0,0])
                color("blue")
                cylinder(board_height*top_wall_factor*indent_factor,1,1,$fn=3);
            }
        }

        color("grey")
        translate([case_border+(board_width*(1-top_wall_factor))/2,1,-top_walls])
            cube([board_width*top_wall_factor,1,case_border+top_walls]); //bottom

        color("grey")
        translate([case_border/2,board_height+case_border-0.5,-top_walls]){
            difference(){
                cube([board_width+case_border,1,case_border+top_walls]); //top
                
                translate([case_border/2+cart_wall_corners,-1,-1])
                    cube([board_width-cart_wall_corners*2,3,case_border+top_walls+3]);
            }
        }
    }
}




bottom(0,0,0);
top(0,0,0);