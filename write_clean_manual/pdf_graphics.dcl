definition module pdf_graphics;

path_move :: !Real !Real -> {#Char};
path_line :: !Real !Real -> {#Char};
path_curve :: !Real !Real !Real !Real !Real !Real -> {#Char};
path_corner_first_x :: !Real !Real !Real !Real -> {#Char};
path_corner_first_y :: !Real !Real !Real !Real -> {#Char};
path_close_and_fill :: {#Char};

path_element_corner_first_x :: !Real !Real !Real !Real -> PathElement;
path_element_corner_first_y :: !Real !Real !Real !Real -> PathElement;

draw_line_to :: !Real !Real !Real !Real -> {#Char};
draw_rectangle :: !Real !Real !Real !Real -> {#Char};
fill_rectangle :: !Real !Real !Real !Real -> {#Char};
fill_rounded_rectangle :: !Real !Real !Real !Real !Real -> {#Char};

draw_corner_first_x :: !Real !Real !Real !Real -> {#Char};
draw_corner_first_y :: !Real !Real !Real !Real -> {#Char};

bezier_arc :: !Real !Real !Real !Real -> (!Real,!Real,!Real,!Real);
bezier_arc_from_angle :: !Real -> (!Real,!Real,!Real,!Real,!Real,!Real,!Real,!Real);
bezier_arc_from_point :: !Real !Real -> (!Real,!Real,!Real,!Real,!Real,!Real);

draw_arrow :: !Real !Real !Real !Real -> {#Char};
picture_elements_arrow :: !Real !Real !Real !Real -> [PictureElement];

rgb_RGB_8bit :: !(!Int,!Int,!Int) -> {#Char};
pen_color_8bit :: !Int !Int !Int -> {#Char};
fill_color_8bit :: !Int !Int !Int -> {#Char};

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

picture_element_rounded_rectangle :: !Real !Real !Real !Real !Real -> PictureElement;

draw_picture :: ![PictureElement] !Real !Real -> (!{#Char},!{#Char});
draw_picture_indent :: ![PictureElement] !Real !Real !Real -> (!{#Char},!{#Char});
