implementation module pdf_graphics;

import StdEnv;

path_move :: !Real !Real -> {#Char};
path_move x y
	= toString x+++" "+++toString y+++" m ";

path_element_line :: !Real !Real -> PathElement;
path_element_line x y
	= PLine (x, y);

path_line :: !Real !Real -> {#Char};
path_line x y
	= toString x+++" "+++toString y+++" l ";

path_curve :: !Real !Real !Real !Real !Real !Real -> {#Char};
path_curve x1 y1 x2 y2 x3 y3
	= toString x1+++" "+++toString y1+++" "+++toString x2+++" "+++toString y2+++" "+++toString x3+++" "+++toString y3+++" c ";

path_close_and_fill :: {#Char};
path_close_and_fill = "h f ";

bezier_arc_v :== 0.5522847498; // (sqrt 2.0-1.0)*4.0/3.0

path_element_corner_first_x :: !Real !Real !Real !Real -> PathElement;
path_element_corner_first_x x y d_x d_y
	= PCurve (x+bezier_arc_v*d_x, y)
 			 (x+d_x, y+bezier_arc_v*d_y)
 			 (x+d_x, y+d_y);

path_corner_first_x :: !Real !Real !Real !Real -> {#Char};
path_corner_first_x x y d_x d_y
	= path_curve	(x+bezier_arc_v*d_x) y
 					(x+d_x) (y+bezier_arc_v*d_y)
 					(x+d_x) (y+d_y);

path_element_corner_first_y :: !Real !Real !Real !Real -> PathElement;
path_element_corner_first_y x y d_x d_y
	= PCurve (x, y+bezier_arc_v*d_y)
 			 (x+bezier_arc_v*d_x, y+d_y)
 			 (x+d_x, y+d_y);

path_corner_first_y :: !Real !Real !Real !Real -> {#Char};
path_corner_first_y x y d_x d_y
	= path_curve	x (y+bezier_arc_v*d_y)
 					(x+bezier_arc_v*d_x) (y+d_y)
 					(x+d_x) (y+d_y);

draw_line_to :: !Real !Real !Real !Real -> {#Char};
draw_line_to x_0 y_0 x_1 y_1
	= path_move x_0 y_0+++path_line x_1 y_1+++"h S ";

draw_rectangle :: !Real !Real !Real !Real -> {#Char};
draw_rectangle x y width height
	= toString x+++" "+++toString y+++" "+++toString width+++" "+++toString height+++" re S ";

fill_rectangle :: !Real !Real !Real !Real -> {#Char};
fill_rectangle x y width height
	= toString x+++" "+++toString y+++" "+++toString width+++" "+++toString height+++" re f ";

picture_element_rounded_rectangle :: !Real !Real !Real !Real !Real -> PictureElement;
picture_element_rounded_rectangle x y width height corner_size
	# y = y + height - corner_size;
	# width = width-2.0*corner_size;
	# height = height-2.0*corner_size;
	# begin_path = (x,y);

	# pe1 = path_element_corner_first_y x y corner_size corner_size;
	  x = x+corner_size;
	  y = y+corner_size;

	# nx = x+width;
	  pe2 = path_element_line nx y;
	  x = nx;

	# pe3 = path_element_corner_first_x x y corner_size (~corner_size);
	  x = x+corner_size;
	  y = y-corner_size;

	# ny = y-height;
	  pe4 = path_element_line x ny;
	  y = ny;

	# pe5 = path_element_corner_first_y x y (~corner_size) (~corner_size);
	  x = x-corner_size;
	  y = y-corner_size;

	# nx = x-width;
	  pe6 = path_element_line nx y;
	  x = nx;

	# pe7 = path_element_corner_first_x x y (~corner_size) corner_size;
	  x = x-corner_size;
	  y = y+corner_size;

	# ny = y+height;
	  pe8 = path_element_line x ny;
	  y = ny;
	
	= FillPath begin_path [pe1,pe2,pe3,pe4,pe5,pe6,pe7,pe8];

fill_rounded_rectangle :: !Real !Real !Real !Real !Real -> {#Char};
fill_rounded_rectangle x y width height corner_size
	# y = y + height - corner_size;
	# width = width-2.0*corner_size;
	# height = height-2.0*corner_size;
	# g_s=path_move x y;

	# g_s=g_s+++path_corner_first_y x y corner_size corner_size;
	  x = x+corner_size;
	  y = y+corner_size;

	# nx = x+width;
	  g_s=g_s+++path_line nx y;
	  x = nx;

	# g_s=g_s+++path_corner_first_x x y corner_size (~corner_size);
	  x = x+corner_size;
	  y = y-corner_size;

	# ny = y-height;
	  g_s=g_s+++path_line x ny;
	  y = ny;

	# g_s=g_s+++path_corner_first_y x y (~corner_size) (~corner_size);
	  x = x-corner_size;
	  y = y-corner_size;

	# nx = x-width;
	  g_s=g_s+++path_line nx y;
	  x = nx;

	# g_s=g_s+++path_corner_first_x x y (~corner_size) corner_size;
	  x = x-corner_size;
	  y = y+corner_size;

	# ny = y+height;
	  g_s=g_s+++path_line x ny;
	  y = ny;
	
	= g_s+++path_close_and_fill;

draw_curve :: !Real !Real !Real !Real !Real !Real !Real !Real -> {#Char};
draw_curve x_0 y_0 x_1 y_1 x_2 y_2 x_3 y_3
 	= path_move x_0 y_0+++path_curve x_1 y_1 x_2 y_2 x_3 y_3+++"S ";

draw_corner_first_x :: !Real !Real !Real !Real -> {#Char};
draw_corner_first_x x y d_x d_y
	= draw_curve	x y
 					(x+bezier_arc_v*d_x) y
 					(x+d_x) (y+bezier_arc_v*d_y)
 					(x+d_x) (y+d_y);

draw_corner_first_y :: !Real !Real !Real !Real -> {#Char};
draw_corner_first_y x y d_x d_y
	= draw_curve	x y
 					x (y+bezier_arc_v*d_y)
 					(x+bezier_arc_v*d_x) (y+d_y)
 					(x+d_x) (y+d_y);

bezier_arc :: !Real !Real !Real !Real -> (!Real,!Real,!Real,!Real);
bezier_arc x0 y0 x3 y3
	# q2 = 1.0 + x0*x3 + y0*y3;
	// (sqrt 2.0-1.0)*4.0/3.0 = 0.5522847498
	# k2 = 4.0*(sqrt (2.0*q2)-q2)/(3.0*(x0*y3-y0*x3));
	# x1 = x0 - k2*y0;
	# y1 = y0 + k2*x0;
	# x2 = x3 + k2*y3;
	# y2 = y3 - k2*x3;
	= (x1,y1,x2,y2);

bezier_arc_from_angle :: !Real -> (!Real,!Real,!Real,!Real,!Real,!Real,!Real,!Real);
bezier_arc_from_angle angle
 	# x0 = cos angle;
	# y0 = sin angle;
	# x1 = (4.0-x0)/3.0;
	# y1 = ((1.0-x0)*(3.0-x0))/(3.0*y0);
	= (x0,y0,x1,y1,x1,~y1,x0,~y0);

bezier_arc_from_point :: !Real !Real -> (!Real,!Real,!Real,!Real,!Real,!Real);
bezier_arc_from_point x0 y0
	# x1 = (4.0-x0)/3.0;
	# y1 = ((1.0-x0)*(3.0-x0))/(3.0*y0);
	= (x1,y1,x1,~y1,x0,~y0);

draw_arrow :: !Real !Real !Real !Real -> {#Char};
draw_arrow x_0 y_0 x_1 y_1
	# d_x = x_0-x_1;
	# d_y = y_0-y_1;
	# length = sqrt (d_x*d_x+d_y*d_y);
	# v_x = d_x / length;
	# v_y = d_y / length;
 	# pi = 3.141592653589793238;
 	# a1 = 20.0*pi/180.0;
 	# c_a1 = cos a1;
 	# s_a1 = sin a1;
 	# c_a2 = c_a1;
 	# s_a2 = ~s_a1;
 	# v_x_a1 = v_x * c_a1 - v_y * s_a1;
 	# v_y_a1 = v_x * s_a1 + v_y * c_a1;
 	# v_x_a2 = v_x * c_a2 - v_y * s_a2;
 	# v_y_a2 = v_x * s_a2 + v_y * c_a2;
 	# arrow_head_length_1=4.0;
 	# arrow_head_length_2=2.0;
	= draw_line_to x_0 y_0 x_1 y_1+++
	  path_move x_1 y_1+++
	  path_line (x_1+arrow_head_length_1*v_x_a1) (y_1+arrow_head_length_1*v_y_a1)+++
	  path_line (x_1+arrow_head_length_2*v_x) (y_1+arrow_head_length_2*v_y)+++
	  path_line (x_1+arrow_head_length_1*v_x_a2) (y_1+arrow_head_length_1*v_y_a2)+++"h B ";

picture_elements_arrow :: !Real !Real !Real !Real -> [PictureElement];
picture_elements_arrow x_0 y_0 x_1 y_1
	# d_x = x_0-x_1;
	# d_y = y_0-y_1;
	# length = sqrt (d_x*d_x+d_y*d_y);
	# v_x = d_x / length;
	# v_y = d_y / length;
 	# pi = 3.141592653589793238;
 	# a1 = 20.0*pi/180.0;
 	# c_a1 = cos a1;
 	# s_a1 = sin a1;
 	# c_a2 = c_a1;
 	# s_a2 = ~s_a1;
 	# v_x_a1 = v_x * c_a1 - v_y * s_a1;
 	# v_y_a1 = v_x * s_a1 + v_y * c_a1;
 	# v_x_a2 = v_x * c_a2 - v_y * s_a2;
 	# v_y_a2 = v_x * s_a2 + v_y * c_a2;
 	# arrow_head_length_1=4.0;
 	# arrow_head_length_2=2.0;
	= [Path (x_0,y_0) [PLine (x_1,y_1)],
	   ClosedPath (x_1,y_1) [
	   	PLine (x_1+arrow_head_length_1*v_x_a1, y_1+arrow_head_length_1*v_y_a1),
		PLine (x_1+arrow_head_length_2*v_x,    y_1+arrow_head_length_2*v_y),
		PLine (x_1+arrow_head_length_1*v_x_a2, y_1+arrow_head_length_1*v_y_a2)
	   ]];

rgb_RGB_8bit :: !(!Int,!Int,!Int) -> {#Char};
rgb_RGB_8bit (r,g,b)
	# r_s = toString (toReal r/255.0)+++" ";
	# g_s = toString (toReal g/255.0)+++" ";
	# b_s = toString (toReal b/255.0)+++" ";
	= r_s+++g_s+++b_s+++"rg "+++r_s+++g_s+++b_s+++"RG ";

pen_color_8bit :: !Int !Int !Int -> {#Char};
pen_color_8bit r g b
	# r_s = toString (toReal r/255.0)+++" ";
	# g_s = toString (toReal g/255.0)+++" ";
	# b_s = toString (toReal b/255.0)+++" ";
	= r_s+++g_s+++b_s+++"RG ";

fill_color_8bit :: !Int !Int !Int -> {#Char};
fill_color_8bit r g b
	# r_s = toString (toReal r/255.0)+++" ";
	# g_s = toString (toReal g/255.0)+++" ";
	# b_s = toString (toReal b/255.0)+++" ";
	= r_s+++g_s+++b_s+++"rg ";

:: PictureElement
	= Rectangle !(!Real,!Real) !(!Real,!Real)
	| Path !(!Real,!Real) ![PathElement]
	| ClosedPath !(!Real,!Real) ![PathElement]
	| FillRectangle !(!Real,!Real) !(!Real,!Real)
	| FillPath !(!Real,!Real) ![PathElement]
	| StringAt !(!Real,!Real) !{#Char}
	| TextColor !(!Int,!Int,!Int)
	| FillColor !(!Int,!Int,!Int)
	| PenColor !(!Int,!Int,!Int)
	| TextFont !Int !Int;

:: PathElement
	= PLine !(!Real,!Real)
	| PCurve !(!Real,!Real) !(!Real,!Real) !(!Real,!Real);

draw_path :: !(!Real,!Real) [PathElement] !Real !Real -> {#Char};
draw_path (x,y) ps left_margin top
	= path_move (left_margin+x) (top-1.0-y)+++add_path_lines ps left_margin top+++"S ";

draw_closed_path :: !(!Real,!Real) [PathElement] !Real !Real -> {#Char};
draw_closed_path (x,y) ps left_margin top
	= path_move (left_margin+x) (top-1.0-y)+++add_path_lines ps left_margin top+++"h S ";

fill_path :: !(!Real,!Real) [PathElement] !Real !Real -> {#Char};
fill_path (x,y) ps left_margin top
	= path_move (left_margin+x) (top-1.0-y)+++add_path_lines ps left_margin top+++path_close_and_fill;

add_path_lines :: ![PathElement] !Real !Real -> {#Char};
add_path_lines [PLine (x,y):ps] left_margin top
	= path_line (left_margin+x) (top-1.0-y)+++add_path_lines ps left_margin top;
add_path_lines [PCurve (x1,y1) (x2,y2) (x3,y3):ps] left_margin top
	= path_curve (left_margin+x1) (top-1.0-y1) (left_margin+x2) (top-1.0-y2) (left_margin+x3) (top-1.0-y3)+++
		add_path_lines ps left_margin top;
add_path_lines [] left_margin top
	= "";

rectangle :: !Real !Real !Real !Real !Real -> {#Char};
rectangle y_pos height left_margin width top
	= toString left_margin+++" "+++toString (top-1.0-toReal y_pos)+++" "+++toString width+++" "+++toString height+++" re S ";

fill_rectangle_ :: !Real !Real !Real !Real !Real -> {#Char};
fill_rectangle_ y_pos height left_margin width top
	= toString left_margin+++" "+++toString (top-1.0-toReal y_pos)+++" "+++toString width+++" "+++toString height+++" re f ";

draw_string_at_relative_position :: !Real !Real !{#Char} -> {#Char};
draw_string_at_relative_position tx ty s
	= toString tx+++" "+++toString ty+++" Td "+++
	  "("+++s+++") Tj "+++
	  toString (~tx)+++" "+++toString (~ty)+++" Td ";

draw_picture :: ![PictureElement] !Real !Real -> (!{#Char},!{#Char});
draw_picture [Rectangle (x_pos,y_pos) (width,height):picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (rectangle y_pos (~height) (left_margin+x_pos) width top+++g_s,t_s); 
draw_picture [Path path_begin path_elements:picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (draw_path path_begin path_elements left_margin top+++g_s,t_s);
draw_picture [ClosedPath path_begin path_elements:picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (draw_closed_path path_begin path_elements left_margin top+++g_s,t_s);
draw_picture [FillRectangle (x_pos,y_pos) (width,height):picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (fill_rectangle_ y_pos (~height) (left_margin+x_pos) width top+++g_s,t_s);
draw_picture [FillPath path_begin path_elements:picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (fill_path path_begin path_elements left_margin top+++g_s,t_s);
draw_picture [StringAt (x,y) s:picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (g_s,draw_string_at_relative_position x (~y) s+++t_s);
draw_picture [TextColor (r,g,b):picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (g_s,fill_color_8bit r g b+++t_s);
draw_picture [FillColor (r,g,b):picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (fill_color_8bit r g b+++g_s,t_s);
draw_picture [PenColor (r,g,b):picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (pen_color_8bit r g b+++g_s,t_s);
draw_picture [TextFont font_n font_size:picture_elements] left_margin top
	# (g_s,t_s) = draw_picture picture_elements left_margin top;
	= (g_s,"/F"+++toString font_n+++" "+++toString font_size+++" Tf "+++t_s);
draw_picture [] left_margin top
	= ("","");

draw_picture_indent :: ![PictureElement] !Real !Real !Real -> (!{#Char},!{#Char});
draw_picture_indent [Rectangle (x_pos,y_pos) (width,height):picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (rectangle y_pos (~height) (left_margin+x_pos) width top+++g_s,t_s); 
draw_picture_indent [Path path_begin path_elements:picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (draw_path path_begin path_elements left_margin top+++g_s,t_s);
draw_picture_indent [ClosedPath path_begin path_elements:picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (draw_closed_path path_begin path_elements left_margin top+++g_s,t_s);
draw_picture_indent [FillRectangle (x_pos,y_pos) (width,height):picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (fill_rectangle_ y_pos (~height) (left_margin+x_pos) width top+++g_s,t_s);
draw_picture_indent [FillPath path_begin path_elements:picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (fill_path path_begin path_elements left_margin top+++g_s,t_s);
draw_picture_indent [StringAt (x,y) s:picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (g_s,draw_string_at_relative_position (x+text_indent) (~y) s+++t_s);
draw_picture_indent [TextColor (r,g,b):picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (g_s,fill_color_8bit r g b+++t_s);
draw_picture_indent [FillColor (r,g,b):picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (fill_color_8bit r g b+++g_s,t_s);
draw_picture_indent [PenColor (r,g,b):picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (pen_color_8bit r g b+++g_s,t_s);
draw_picture_indent [TextFont font_n font_size:picture_elements] left_margin text_indent top
	# (g_s,t_s) = draw_picture_indent picture_elements left_margin text_indent top;
	= (g_s,"/F"+++toString font_n+++" "+++toString font_size+++" Tf "+++t_s);
draw_picture_indent [] left_margin text_indent top
	= ("","");
