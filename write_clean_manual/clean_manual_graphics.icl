implementation module clean_manual_graphics;

import StdEnv;
import pdf_graphics;

clean_logo_blue :== (63,135,175);
clean_logo_grey :== (140,150,160);

fill_rectangles_difference :: !Real !Real !Real !Real !Real !Real !Real !Real -> {#Char};
fill_rectangles_difference x1 y1 width1 height1 x2 y2 width2 height2
	= toString x1+++" "+++toString y1+++" "+++toString width1+++" "+++toString height1+++" re "+++
	  toString x2+++" "+++toString y2+++" "+++toString width2+++" "+++toString height2+++" re "+++
		"f ";

clean_logo :: !Real !Real -> {#Char};
clean_logo x_p y_p
 	# pi = 3.141592653589793238;

 	# angle = (108.0/360.0)*pi; // (100.0/360.0)*pi;

	# s = 0.75;

 	# r1 = s*24.0;
 	# r2 = s*37.0;
 	# r3 = s*41.0;
 	# r4 = s*55.0;

	# size_left = 52.0;
//	# size_right = 108.0;
	# size_right = 98.0;
//	# size_right = 88.0;
//	# size_vertical_border = 7.0;
	# size_vertical_border = 8.0;

	# g_s = "";

	# y0 = sin angle*r3/r4;
	# x0 = sqrt (1.0-y0*y0);
	# y3 = sin angle;
 	# x3 = cos angle;

	# (x1,y1,x2,y2) = bezier_arc x0 y0 x3 y3;

	# cc_top_y = y_p+r3*y3;
	# cc_bottom_y = y_p-r3*y3;
	# cc_right_x = x_p-r3*x3;
	# cc_left_x = x_p-r4*x0;

	# g_s=g_s+++rgb_RGB_8bit clean_logo_blue;

	# g_s=g_s+++fill_rectangles_difference
					(x_p-size_left) (cc_bottom_y-15.0) (size_right+size_left+size_vertical_border) (cc_top_y-cc_bottom_y+2.0*15.0)
					(x_p-size_left+size_vertical_border) cc_bottom_y (size_right+size_left-size_vertical_border) (cc_top_y-cc_bottom_y);
/*
	# g_s=g_s+++fill_rectangle (x_p-size_left) cc_bottom_y size_vertical_border (cc_top_y-cc_bottom_y);
	# g_s=g_s+++fill_rectangle (x_p+size_right) cc_bottom_y size_vertical_border (cc_top_y-cc_bottom_y);
	# g_s=g_s+++fill_rectangle (x_p-size_left) cc_top_y (size_right+size_left+size_vertical_border) 15.0;
	# g_s=g_s+++fill_rectangle (x_p-size_left) (cc_bottom_y-15.0) (size_right+size_left+size_vertical_border) 15.0;
*/
	# g_s=g_s+++rgb_RGB_8bit clean_logo_grey;

	# grey_width = 6.0;

	# g_s=g_s+++fill_rectangle (x_p-size_left+size_vertical_border) (cc_top_y-grey_width) (size_right+size_left-size_vertical_border) grey_width;
 	# g_s=g_s+++fill_rectangle (x_p-size_left+size_vertical_border) cc_bottom_y (size_right+size_left-size_vertical_border) grey_width;
 
 	# g_s=g_s+++rgb_RGB_8bit (255,255,255);

 	# g_s=g_s+++fill_rectangle (x_p-size_left+size_vertical_border) (cc_bottom_y+grey_width) (size_right+size_left-size_vertical_border) (cc_top_y-cc_bottom_y-2.0*grey_width);

	# g_s=g_s+++rgb_RGB_8bit clean_logo_grey;

 	# g_s=g_s+++path_move (x_p-r4*x3) (y_p+r4*y3);
 	# g_s=g_s+++path_curve (x_p-r4*x2) (y_p+r4*y2) (x_p-r4*x1) (y_p+r4*y1) (x_p-r4*x0) (y_p+r4*y0);
	# g_s=g_s+++path_line (x_p-r3*x3) (y_p+r3*y3);
 	# g_s=g_s+++path_close_and_fill;

	# g_s=g_s+++path_move (x_p-r4*x3) (y_p-r4*y3);
	# g_s=g_s+++path_curve (x_p-r4*x2) (y_p-r4*y2) (x_p-r4*x1) (y_p-r4*y1) (x_p-r4*x0) (y_p-r4*y0);
	# g_s=g_s+++path_line (x_p-r3*x3) (y_p-r3*y3);
 	# g_s=g_s+++path_close_and_fill;


	# g_s=g_s+++rgb_RGB_8bit clean_logo_grey;

	# x_p=x_p+2.0;
	# y_p=y_p-2.0;

	# (x0,y0,x1,y1,x2,y2,x3,y3) = bezier_arc_from_angle angle;

	# g_s=g_s+++path_move (x_p-r1*x0) (y_p+r1*y0);
	# g_s=g_s+++path_curve (x_p-r1*x1) (y_p+r1*y1) (x_p-r1*x2) (y_p+r1*y2) (x_p-r1*x3) (y_p+r1*y3);
	# g_s=g_s+++path_line (x_p-r2*x3) (y_p+r2*y3);
	# g_s=g_s+++path_curve (x_p-r2*x2) (y_p+r2*y2) (x_p-r2*x1) (y_p+r2*y1) (x_p-r2*x0) (y_p+r2*y0);
 	# g_s=g_s+++path_close_and_fill;

	# g_s=g_s+++path_move (x_p-r3*x0) (y_p+r3*y0);
	# g_s=g_s+++path_curve (x_p-r3*x1) (y_p+r3*y1) (x_p-r3*x2) (y_p+r3*y2) (x_p-r3*x3) (y_p+r3*y3);

//	# y0 = sin angle*r3/r4;
//	# x0 = sqrt (1.0-y0*y0);

//	# (x1,y1,x2,y2,x3,y3) = bezier_arc_from_point x0 y0;

 	# g_s=g_s+++path_line (x_p-r4*x3) (y_p+r4*y3);
 	# g_s=g_s+++path_curve (x_p-r4*x2) (y_p+r4*y2) (x_p-r4*x1) (y_p+r4*y1) (x_p-r4*x0) (y_p+r4*y0);
 	# g_s=g_s+++path_close_and_fill;

	# x_p=x_p-2.0;
	# y_p=y_p+2.0;


	# g_s=g_s+++rgb_RGB_8bit clean_logo_blue;

	# (x0,y0,x1,y1,x2,y2,x3,y3) = bezier_arc_from_angle angle;

	# g_s=g_s+++path_move (x_p-r1*x0) (y_p+r1*y0);
	# g_s=g_s+++path_curve (x_p-r1*x1) (y_p+r1*y1) (x_p-r1*x2) (y_p+r1*y2) (x_p-r1*x3) (y_p+r1*y3);
	# g_s=g_s+++path_line (x_p-r2*x3) (y_p+r2*y3);
	# g_s=g_s+++path_curve (x_p-r2*x2) (y_p+r2*y2) (x_p-r2*x1) (y_p+r2*y1) (x_p-r2*x0) (y_p+r2*y0);
 	# g_s=g_s+++path_close_and_fill;

	# g_s=g_s+++path_move (x_p-r3*x0) (y_p+r3*y0);
	# g_s=g_s+++path_curve (x_p-r3*x1) (y_p+r3*y1) (x_p-r3*x2) (y_p+r3*y2) (x_p-r3*x3) (y_p+r3*y3);

	# y0 = sin angle*r3/r4;
	# x0 = sqrt (1.0-y0*y0);

	# (x1,y1,x2,y2,x3,y3) = bezier_arc_from_point x0 y0;

 	# g_s=g_s+++path_line (x_p-r4*x3) (y_p+r4*y3);
 	# g_s=g_s+++path_curve (x_p-r4*x2) (y_p+r4*y2) (x_p-r4*x1) (y_p+r4*y1) (x_p-r4*x0) (y_p+r4*y0);
 	# g_s=g_s+++path_close_and_fill;

	= g_s;

clean_logo_text :: !Real !Real -> {#Char};
clean_logo_text x_p y_p
	=	"1 0 0 1 "+++toString (x_p+2.0)+++" "+++toString (y_p-12.0)+++" Tm "+++
		"/F3 "+++toString 32+++" Tf "+++
		
		"90 Tz "+++

		rgb_RGB_8bit clean_logo_grey+++

		"2.0 -2.0 Td "+++
		"(Clean) Tj "+++
		"-2.0 2.0 Td "+++

		"1.5 -1.5 Td "+++
		"(Clean) Tj "+++
		"-1.5 1.5 Td "+++

		"1.0 -1.0 Td "+++
		"(Clean) Tj "+++
		"-1.0 1.0 Td "+++

		"0.5 -0.5 Td "+++
		"(Clean) Tj "+++
		"-0.5 0.5 Td "+++

		rgb_RGB_8bit clean_logo_blue+++
		" (Clean) Tj "+++

		rgb_RGB_8bit (0,0,0)+++

		" 100 Tz ";

move_text_cursor_y :: !Int !Int !{#Char} -> (!Int,!{#Char});
move_text_cursor_y d_y y_pos t_s
	# t_s=t_s+++"0 "+++toString (~d_y)+++" Td ";
	  y_pos = y_pos + d_y;
	= (y_pos,t_s);

draw_string_at_relative_position :: !Real !Real !{#Char} -> {#Char};
draw_string_at_relative_position tx ty s
	= toString tx+++" "+++toString ty+++" Td "+++
	  "("+++s+++") Tj "+++
	  toString (~tx)+++" "+++toString (~ty)+++" Td ";

picture_elements_rounded_rectangle_with_strings x y top_s bottom_s
	= [
		picture_element_rounded_rectangle (x-10.0) (y+2.0-26.0) 96.0 26.0 6.0,
		StringAt (x,y-15.0) top_s,
		TextColor (255,0,0),
		StringAt (x,y+1.0) bottom_s,
		TextColor (0,0,0)
	  ];

picture_elements_file_with_file_extension x y ext_s
	= [
		FillRectangle (x-3.0,y+10.0-22.0) (22.0,22.0),
		StringAt (x,y) ext_s
	  ];

picture_elements_files_with_file_extension x y ext_s
	= [
		FillRectangle (x- 3.0,y+10.0-22.0) (22.0,22.0),
		FillRectangle (x- 2.0,y-13.0- 2.0) (24.0,2.0),
		FillRectangle (x+20.0,y+ 9.0-24.0) (2.0,24.0),
		FillRectangle (x+ 1.0,y-16.0- 2.0) (24.0,2.0),
		FillRectangle (x+23.0,y+ 6.0-24.0) (2.0,24.0),
		StringAt (x,y) ext_s
	  ];

picture_elements_fill_arrow_right x y
	# picture_element1 = FillRectangle (x,y-6.0) (12.0,6.0);
	# y = y - 3.0;
	# picture_element2 = FillPath (x+12.0,y+5.0) [PLine (x+16.0,y), PLine (x+12.0,y-5.0)];
	= [picture_element1,picture_element2];

fill_arrow_right x y g_s
	# g_s = g_s+++fill_rectangle x y 12.0 6.0;
	# y = y + 3.0;
	# g_s = g_s+++path_move (x+12.0) (y+5.0);
	# g_s = g_s+++path_line (x+16.0) y;
	# g_s = g_s+++path_line (x+12.0) (y-5.0);
	# g_s = g_s+++path_close_and_fill;
	= g_s;

picture_elements_fill_arrow_left x y
	# x = x+4.0;
	# picture_element1 = FillRectangle (x,y-6.0) (12.0,6.0);
	# y = y - 3.0;
	# picture_element2 = FillPath (x,y+5.0) [PLine (x-4.0,y), PLine (x,y-5.0)];
	= [picture_element1,picture_element2];

fill_arrow_left x y g_s
	# x = x+4.0;
	# g_s = g_s+++fill_rectangle x y 12.0 6.0;
	# y = y + 3.0;
	# g_s = g_s+++path_move x (y+5.0);
	# g_s = g_s+++path_line (x-4.0) y;
	# g_s = g_s+++path_line x (y-5.0);
	# g_s = g_s+++path_close_and_fill;
	= g_s;

picture_elements_fill_arrow_up x y
	# picture_element1 = FillRectangle (x,y-12.0) (6.0,12.0);
	# x = x + 3.0;
	# picture_element2 = FillPath (x+5.0,y-12.0) [PLine (x,y-16.0), PLine (x-5.0,y-12.0)];
	= [picture_element1,picture_element2];

fill_arrow_up x y g_s
	# g_s = g_s+++fill_rectangle x y 6.0 12.0;
	# x = x + 3.0;
	# g_s = g_s+++path_move (x+5.0) (y+12.0);
	# g_s = g_s+++path_line x (y+16.0);
	# g_s = g_s+++path_line (x-5.0) (y+12.0);
	# g_s = g_s+++path_close_and_fill;
	= g_s;

picture_elements_fill_arrow_down x y
	# y = y-4.0;
	# picture_element1 = FillRectangle (x,y-12.0) (6.0,12.0);
	# x = x + 3.0;
	# picture_element2 = FillPath (x+5.0,y) [PLine (x,y+4.0), PLine (x-5.0,y)];
	= [picture_element1,picture_element2];

fill_arrow_down x y g_s
	# y = y+4.0;
	# g_s = g_s+++fill_rectangle x y 6.0 12.0;
	# x = x + 3.0;
	# g_s = g_s+++path_move (x+5.0) y;
	# g_s = g_s+++path_line x (y-4.0);
	# g_s = g_s+++path_line (x-5.0) y;
	# g_s = g_s+++path_close_and_fill;
	= g_s;

picture_1 :: !Int -> [PictureElement];
picture_1 font_size
	=	TextFont 3 9:+
		FillColor (51,102,255):+
		picture_elements_rounded_rectangle_with_strings 220.0  46.0 "Clean Compiler"   "Clean"++
		picture_elements_rounded_rectangle_with_strings 220.0  78.0 "Code Generator"   "C"++
		picture_elements_rounded_rectangle_with_strings 100.0 110.0 "Your Application" "Clean"++
		picture_elements_rounded_rectangle_with_strings 220.0 110.0 "Static Linker"    "Clean"++
		FillColor (255,153,0):+
		picture_elements_files_with_file_extension 132.0 38.0 ".icl"++
		picture_elements_files_with_file_extension 336.0 52.0 ".abc"++
		picture_elements_files_with_file_extension 336.0 84.0 ".obj"++
		FillColor (153,255,153):+
		picture_elements_files_with_file_extension 162.0 38.0 ".dcl"++
		FillColor (255,0,255):+
		picture_elements_fill_arrow_left  192.0 102.0++
		picture_elements_fill_arrow_right 192.0 38.0++
		picture_elements_fill_arrow_left  312.0 92.0++
		picture_elements_fill_arrow_right 312.0 80.0++
		picture_elements_fill_arrow_left  312.0 60.0++
		picture_elements_fill_arrow_right 312.0 48.0++
		TextColor (0,0,0):+
		TextFont 1 font_size:+[];

(:+) infixr;
(:+) e l :== [e:l];

picture_2 :: !Int -> [PictureElement];
picture_2 font_size
	=	TextFont 3 9:+
		FillColor(51,102,255):+
		picture_elements_rounded_rectangle_with_strings 220.0  46.0 "Clean Compiler"   "Clean"++
		picture_elements_rounded_rectangle_with_strings 220.0  78.0 "Code Generator"   "C"++
		picture_elements_rounded_rectangle_with_strings 220.0 110.0 "Static Linker"    "Clean"++
		picture_elements_rounded_rectangle_with_strings 180.0 160.0 "Your Application" "Clean"++
		picture_element_rounded_rectangle (280.0-10.0) (144.0-10.0+2.0) 36.0 26.0 6.0:+
		StringAt (280.0-2.0,144.0) "Plug":+
		StringAt (280.0-2.0,160.0) "In":+
		picture_elements_rounded_rectangle_with_strings 342.0 160.0 "Dynamic Linker"   "Clean"++
		FillColor (255,153,0):+
		picture_elements_files_with_file_extension 132.0  38.0 ".icl"++
		picture_elements_files_with_file_extension 336.0  52.0 ".abc"++
		picture_elements_files_with_file_extension 336.0  85.0 ".obj"++
		picture_elements_file_with_file_extension  336.0 110.0 ".lib"++
		picture_elements_file_with_file_extension  366.0 110.0 ".typ"++
		FillColor (153,204,255):+
		picture_elements_file_with_file_extension  130.0 150.0 ".dyn"++
		picture_elements_file_with_file_extension  396.0 110.0 ".sysdyn"++
		FillColor (153,255,153):+
		picture_elements_files_with_file_extension 162.0  38.0 ".dcl"++
		FillColor (255,0,255):+
		picture_elements_fill_arrow_right 192.0 38.0++

		picture_elements_fill_arrow_right 312.0 112.0++
		picture_elements_fill_arrow_left  312.0 92.0++
		picture_elements_fill_arrow_right 312.0 80.0++
		picture_elements_fill_arrow_left  312.0 60.0++
		picture_elements_fill_arrow_right 312.0 48.0++

		picture_elements_fill_arrow_down  250.0 132.0++

	 	FillRectangle (406.0, 41.0-8.0) (8.0, 8.0):+
		FillColor (153,204,255):+
		FillRectangle (406.0, 61.0-8.0) (8.0, 8.0):+
		picture_elements_fill_arrow_left  312.0 152.0++

		picture_elements_fill_arrow_left  151.0 158.0++
		picture_elements_fill_arrow_right 151.0 146.0++

		picture_elements_fill_arrow_down  342.0 136.0++
		picture_elements_fill_arrow_down  372.0 136.0++
		picture_elements_fill_arrow_up    402.0 136.0++
		PenColor (0,0,0):+
		Rectangle (400.0, 44.0-14.0) (80.0, 14.0):+
		Rectangle (400.0, 64.0-14.0) (80.0, 14.0):+
		TextFont 1 font_size:+
		TextColor (0,0,0):+
		StringAt (420.0,40.0) "Compile Time":+
		StringAt (420.0,60.0) "Run Time":+[];

draw_down_right_up_arrow :: !Real !Real !Real !{#Char} -> {#Char};
draw_down_right_up_arrow x_0 x_1 y g_s
	# arrow_height = 8.0;
	# corner_size = 6.0;

	# g_s=g_s+++draw_line_to x_0 (y-2.0)
							x_0 (y-arrow_height-2.0);
 	# g_s=g_s+++draw_corner_first_y x_0 (y-arrow_height-2.0) corner_size (~corner_size);
	# g_s=g_s+++draw_line_to (x_0+corner_size) (y-arrow_height-corner_size-2.0)
							(x_1-corner_size) (y-arrow_height-corner_size-2.0);
 	# g_s=g_s+++draw_corner_first_y x_1 (y-arrow_height-2.0) (~corner_size) (~corner_size);
	# g_s=g_s+++draw_arrow	x_1 (y-arrow_height-2.0)
							x_1 (y-2.0);
	= g_s;

picture_elements_down_right_up_arrow :: !Real !Real !Real -> [PictureElement];
picture_elements_down_right_up_arrow x_0 x_1 y
	# arrow_height = 8.0;
	# corner_size = 6.0;
	= [Path (x_0,y) [
		PLine (x_0, y+arrow_height),
		path_element_corner_first_y x_0 (y+arrow_height) corner_size corner_size,
		PLine (x_1-corner_size,y+arrow_height+corner_size),
 		path_element_corner_first_x (x_1-corner_size) (y+arrow_height+corner_size) corner_size (~corner_size),
 		PLine (x_1,y+arrow_height)
	  ]]
	  ++picture_elements_arrow x_1 (y+arrow_height) x_1 y;

clean_svg_logo :: {#Char};
clean_svg_logo
	# x_p = 80.0;
//	# y_p = 56.0;
	# y_p = 44.0;

 	# pi = 3.141592653589793238;

 	# angle = (108.0/360.0)*pi; // (100.0/360.0)*pi;

	# s = 0.75;

 	# r1 = s*24.0;
 	# r2 = s*37.0;
 	# r3 = s*41.0;
 	# r4 = s*55.0;

	# size_left = 52.0;
	# size_right = 98.0;
	# size_vertical_border = 8.0;

	# y0 = sin angle*r3/r4;
	# x0 = sqrt (1.0-y0*y0);
	# y3 = sin angle;
 	# x3 = cos angle;

	# (x1,y1,x2,y2) = bezier_arc x0 y0 x3 y3;

	# cc_top_y = y_p+r3*y3;
	# cc_bottom_y = y_p-r3*y3;
	# cc_right_x = x_p-r3*x3;
	# cc_left_x = x_p-r4*x0;

	# s="<svg width=\""+++p_to_string 200.0+++"\" height=\""+++p_to_string 100.0+++"\">\n";

	# s=s+++fill_rectangles_difference 
			(x_p-size_left) (cc_bottom_y-15.0) (size_right+size_left+size_vertical_border) (cc_top_y-cc_bottom_y+2.0*15.0)
			(x_p-size_left+size_vertical_border) cc_bottom_y (size_right+size_left-size_vertical_border) (cc_top_y-cc_bottom_y)
			clean_logo_blue;

	# grey_width = 6.0;

	# s=s+++fill_rectangle (x_p-size_left+size_vertical_border) (cc_top_y-grey_width) (size_right+size_left-size_vertical_border) grey_width
			clean_logo_grey
		+++fill_rectangle (x_p-size_left+size_vertical_border) cc_bottom_y (size_right+size_left-size_vertical_border) grey_width
			clean_logo_grey
		+++fill_rectangle (x_p-size_left+size_vertical_border) (cc_bottom_y+grey_width) (size_right+size_left-size_vertical_border) (cc_top_y-cc_bottom_y-2.0*grey_width)
			(255,255,255);

	# path =
		path_move (x_p-r4*x3) (y_p+r4*y3)+++" "+++
 		path_curve (x_p-r4*x2) (y_p+r4*y2) (x_p-r4*x1) (y_p+r4*y1) (x_p-r4*x0) (y_p+r4*y0)+++" "+++
		path_line (x_p-r3*x3) (y_p+r3*y3)+++" Z";

	# s=s+++fill_path path clean_logo_grey;

	# path =
		path_move (x_p-r4*x3) (y_p-r4*y3)+++" "+++
 		path_curve (x_p-r4*x2) (y_p-r4*y2) (x_p-r4*x1) (y_p-r4*y1) (x_p-r4*x0) (y_p-r4*y0)+++" "+++
		path_line (x_p-r3*x3) (y_p-r3*y3)+++" Z";

	# s=s+++fill_path path clean_logo_grey;

	# x_p=x_p+2.0;
	# y_p=y_p-2.0;

	# (x0,y0,x1,y1,x2,y2,x3,y3) = bezier_arc_from_angle angle;

	# path =
		path_move (x_p-r1*x0) (y_p+r1*y0)+++" "+++
		path_curve (x_p-r1*x1) (y_p+r1*y1) (x_p-r1*x2) (y_p+r1*y2) (x_p-r1*x3) (y_p+r1*y3)+++" "+++
		path_line (x_p-r2*x3) (y_p+r2*y3)+++" "+++
		path_curve (x_p-r2*x2) (y_p+r2*y2) (x_p-r2*x1) (y_p+r2*y1) (x_p-r2*x0) (y_p+r2*y0)+++" Z";

	# s=s+++fill_path path clean_logo_grey;

	# path =
		path_move (x_p-r3*x0) (y_p+r3*y0)+++" "+++
		path_curve (x_p-r3*x1) (y_p+r3*y1) (x_p-r3*x2) (y_p+r3*y2) (x_p-r3*x3) (y_p+r3*y3)+++" "+++
		path_line (x_p-r4*x3) (y_p+r4*y3)+++" "+++
		path_curve (x_p-r4*x2) (y_p+r4*y2) (x_p-r4*x1) (y_p+r4*y1) (x_p-r4*x0) (y_p+r4*y0)+++" Z";

	# s=s+++fill_path path clean_logo_grey;

	# x_p=x_p-2.0;
	# y_p=y_p+2.0;

	# (x0,y0,x1,y1,x2,y2,x3,y3) = bezier_arc_from_angle angle;

	# path =
		path_move (x_p-r1*x0) (y_p+r1*y0)+++" "+++
		path_curve (x_p-r1*x1) (y_p+r1*y1) (x_p-r1*x2) (y_p+r1*y2) (x_p-r1*x3) (y_p+r1*y3)+++" "+++
		path_line (x_p-r2*x3) (y_p+r2*y3)+++" "+++
		path_curve (x_p-r2*x2) (y_p+r2*y2) (x_p-r2*x1) (y_p+r2*y1) (x_p-r2*x0) (y_p+r2*y0)+++" "+++" Z";

	# s=s+++fill_path path clean_logo_blue;

	# path =
		path_move (x_p-r3*x0) (y_p+r3*y0)+++" "+++
		path_curve (x_p-r3*x1) (y_p+r3*y1) (x_p-r3*x2) (y_p+r3*y2) (x_p-r3*x3) (y_p+r3*y3);

	# y0 = sin angle*r3/r4;
	# x0 = sqrt (1.0-y0*y0);

	# (x1,y1,x2,y2,x3,y3) = bezier_arc_from_point x0 y0;

	# path = path+++
 		path_line (x_p-r4*x3) (y_p+r4*y3)+++" "+++
 		path_curve (x_p-r4*x2) (y_p+r4*y2) (x_p-r4*x1) (y_p+r4*y1) (x_p-r4*x0) (y_p+r4*y0);

	# s=s+++fill_path path clean_logo_blue;

	# s=s+++clean_svg_logo_text;

	# s=s+++"</svg>\n";
	= s;
{
	fill_rectangles_difference :: !Real !Real !Real !Real !Real !Real !Real !Real !(Int,!Int,!Int) -> {#Char};
	fill_rectangles_difference x1 y1 width1 height1 x2 y2 width2 height2 rgb_fill_color
		= "<path d=\""+++
			path_move x1 y1+++" h"+++p_to_string width1+++" v"+++p_to_string height1+++" h"+++p_to_string (~width1)+++" Z "+++
			path_move x2 y2+++" h"+++p_to_string width2+++" v"+++p_to_string height2+++" h"+++p_to_string (~width2)+++" Z"+++
			"\" stroke=\"none\" fill=\"#"+++html_color rgb_fill_color+++"\" fill-rule=\"evenodd\"/>\n";
	
	fill_rectangle :: !Real !Real !Real !Real !(Int,!Int,!Int) -> {#Char};
	fill_rectangle x y width height rgb_fill_color
		= fill_path (path_move x y+++" h"+++p_to_string width+++" v"+++p_to_string height+++" h"+++p_to_string (~width)+++" Z") rgb_fill_color;
	
	fill_path :: !{#Char} !(Int,!Int,!Int) -> {#Char};
	fill_path path rgb_fill_color
		= "<path d=\""+++path+++"\" stroke=\"none\" fill=\"#"+++html_color rgb_fill_color+++"\"/>\n";
		
	path_move x y
		= "M"+++p_to_string x+++" "+++p_to_string y;
	
	path_line x y
		= "L"+++p_to_string x+++" "+++p_to_string y;
	
	path_curve x1 y1 x2 y2 x3 y3
		= "C"+++p_to_string x1+++" "+++p_to_string y1+++","+++p_to_string x2+++" "+++p_to_string y2+++","+++p_to_string x3+++" "+++p_to_string y3;
}

clean_svg_logo_text :: {#Char};
clean_svg_logo_text
	# x_p = 80.0;
//	# y_p = 56.0;
	# y_p = 44.0;

	# y_p = y_p+12.0;
//	# x_p = x_p+12.0;

	= clean_text (x_p+2.0) (y_p+2.0) clean_logo_grey+++
	  clean_text (x_p+1.5) (y_p+1.5) clean_logo_grey+++
	  clean_text (x_p+1.0) (y_p+1.0) clean_logo_grey+++
	  clean_text (x_p+0.5) (y_p+0.5) clean_logo_grey+++
	  clean_text x_p y_p clean_logo_blue;
{
	clean_text x_p y_p color
		= "<text font-family=\"Helvetica\" font-weight=\"bold\" font-size=\""+++p_to_string 32.0+++"px\""
//		= "<text font-family=\"Helvetica\" font-size=\""+++p_to_string 32.0+++"px\""
			+++" x=\""+++p_to_string x_p+++"\""
			+++" y=\""+++p_to_string y_p+++"\""
//			+++" transform=\"scale(0.9,1.0)\""
//			+++" transform=\"scale(0.95,1.0)\""
			+++" fill=\"#"+++html_color color+++"\""
			+++">"
			+++"Clean"
			+++"</text>\n";
}

p_to_string p
//	= toString (p*4.0/3.0);
//	= toString (p*1.5);
	= toString (p*16.0/9.0);
//	= toString p;

html_color :: !(Int,!Int,!Int) -> {#Char};
html_color (r,g,b)
	= {hex_char (r>>4),hex_char r,hex_char (g>>4),hex_char g,hex_char (b>>4),hex_char b};
{	
	hex_char i
		= "0123456789ABCDEF".[i bitand 15];
}

clean_svg_picture :: !Real !Real ![PictureElement] -> {#Char};
clean_svg_picture width height rectangles
	# s="<svg width=\""+++px_to_string width+++"\" height=\""+++py_to_string height+++"\">\n";
	# s=s+++draw_svg_picture rectangles;
	# s=s+++"</svg>\n";
	= s;

clean_svg_picture_absolute :: !Real ![PictureElement] -> {#Char};
clean_svg_picture_absolute height rectangles
	# s = "<div style=\"position: absolute;\">";
	# s=s+++"<svg width=\""+++px_to_string 400.0+++"\" height=\""+++py_to_string height+++"\">\n";
	# s=s+++draw_svg_picture rectangles;
	# s=s+++"</svg></div>\n";
	= s;

:: DrawSVGState = {
	dsgvs_text_color :: !(!Int,!Int,!Int),
	dsgvs_fill_color :: !(!Int,!Int,!Int),
	dsgvs_pen_color :: !(!Int,!Int,!Int),
	dsvgs_text_font :: !(!Int,!Int)
   };

draw_svg_picture rectangles
	# dsvgs = { dsgvs_text_color = (0,0,0), dsgvs_fill_color = (0,0,0), dsgvs_pen_color = (0,0,0), dsvgs_text_font = (1,9) };
	= draw_picture rectangles dsvgs;
{
	draw_picture [Rectangle (left_margin,y_pos) (width,height):picture_elements] dsgvs
		= draw_rectangle left_margin y_pos width height dsgvs.dsgvs_pen_color+++draw_picture picture_elements dsgvs;
	draw_picture [Path path_begin path_elements:picture_elements] dsgvs
		= draw_path path_begin path_elements dsgvs.dsgvs_pen_color+++draw_picture picture_elements dsgvs;
	draw_picture [ClosedPath path_begin path_elements:picture_elements] dsgvs
		= draw_closed_path path_begin path_elements dsgvs.dsgvs_pen_color+++draw_picture picture_elements dsgvs;
	draw_picture [FillRectangle (left_margin,y_pos) (width,height):picture_elements] dsgvs
		= fill_rectangle left_margin y_pos width height dsgvs.dsgvs_fill_color+++draw_picture picture_elements dsgvs;
	draw_picture [FillPath path_begin path_elements:picture_elements] dsgvs
		= fill_path path_begin path_elements dsgvs.dsgvs_fill_color+++draw_picture picture_elements dsgvs;
	draw_picture [StringAt (x,y) s:picture_elements] dsgvs
		= draw_string_at_relative_position x y s dsgvs.dsvgs_text_font dsgvs.dsgvs_text_color+++draw_picture picture_elements dsgvs;
	draw_picture [FillColor fill_color:picture_elements] dsgvs
		# dsgvs & dsgvs_fill_color=fill_color;
		= draw_picture picture_elements dsgvs;
	draw_picture [PenColor pen_color:picture_elements] dsgvs
		# dsgvs & dsgvs_fill_color=pen_color;
		= draw_picture picture_elements dsgvs;
	draw_picture [TextColor text_color:picture_elements] dsgvs
		# dsgvs & dsgvs_text_color=text_color;
		= draw_picture picture_elements dsgvs;
	draw_picture [TextFont font_n font_size:picture_elements] dsgvs
		# dsgvs & dsvgs_text_font=(font_n,font_size);
		= draw_picture picture_elements dsgvs;
	draw_picture [] dsgvs
		= "";

	draw_rectangle :: !Real !Real !Real !Real !(Int,!Int,!Int) -> {#Char};
	draw_rectangle x y width height rgb_fill_color
		= draw_svg_path (path_move x y+++" h"+++px_to_string width+++" v"+++py_to_string height+++" h"+++px_to_string (~width)+++" Z") rgb_fill_color;

	draw_path path_begin path_elements rgb_pen_color
		= draw_svg_path (make_path path_begin path_elements) rgb_pen_color;

	draw_closed_path path_begin path_elements rgb_pen_color
		= draw_svg_path (make_path path_begin path_elements+++" Z") rgb_pen_color;

	fill_rectangle :: !Real !Real !Real !Real !(Int,!Int,!Int) -> {#Char};
	fill_rectangle x y width height rgb_fill_color
		= fill_svg_path (path_move x y+++" h"+++px_to_string width+++" v"+++py_to_string height+++" h"+++px_to_string (~width)+++" Z") rgb_fill_color;

	fill_path path_begin path_elements rgb_pen_color
		= fill_svg_path (make_path path_begin path_elements+++" Z") rgb_pen_color;

	draw_string_at_relative_position x y s (font_n,font_size) text_color
		= "<text "
			+++if (font_n<=3) "font-family=\"Helvetica\"" "font-family=\"courier\""
			+++if (font_n==3 || font_n==5) " font-weight=\"bold\"" ""
			+++" font-size=\""+++p_to_string (toReal font_size)+++"px\""
			+++" x=\""+++px_to_string x+++"\""
			+++" y=\""+++py_to_string y+++"\""
			+++" fill=\"#"+++html_color text_color+++"\""
			+++">"+++s+++"</text>\n";

	draw_svg_path :: !{#Char} !(Int,!Int,!Int) -> {#Char};
	draw_svg_path path rgb_pen_color
		= "<path d=\""+++path+++"\" fill=\"none\" stroke=\"#"+++html_color rgb_pen_color+++"\"/>\n";

	fill_svg_path :: !{#Char} !(Int,!Int,!Int) -> {#Char};
	fill_svg_path path rgb_fill_color
		= "<path d=\""+++path+++"\" fill=\"#"+++html_color rgb_fill_color+++"\" stroke=\"none\"/>\n";

	make_path (x,y) path
		= path_move x y+++add_path_lines path;

	add_path_lines [PLine (x,y):path]
		= path_line x y+++add_path_lines path;
	add_path_lines [PCurve (x1,y1) (x2,y2) (x3,y3):path]
		= path_curve x1 y1 x2 y2 x3 y3+++add_path_lines path;
	add_path_lines []
		= "";

	path_move x y
		= "M"+++px_to_string x+++" "+++py_to_string y;
		
	path_line x y
		= "L"+++px_to_string x+++" "+++py_to_string y;

	path_curve x1 y1 x2 y2 x3 y3
		= "C"+++px_to_string x1+++" "+++py_to_string y1+++","+++px_to_string x2+++" "+++py_to_string y2+++","+++px_to_string x3+++" "+++py_to_string y3;
}

px_to_string p
//	= toString (p*4.0/3.0);
//	= toString (p*1.5);
	= toString (p*16.0/9.0);
//	= toString p;

py_to_string p
//	= toString (p*19.0/12.0-2.0);
	= toString (p*18.0/12.0);
