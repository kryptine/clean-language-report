implementation module clean_manual_styles;

import StdEnv,pdf_text,pdf_graphics,pdf_outline,pdf_fonts,clean_manual_graphics;
from pdf_main import ::Page;

HeaderColor :== (153,153,255);
SyntaxColor :== (255,204,153);
ProgramHeadingColor :== (255,255,69);
ProgramColor :== (255,255,153);
TerminalColor :== (153,51,0);
OrangeColor :== (255,102,0);
TableBorderColor :== (150,150,150);

font_size :== 9;

line_spacing :: Int;
line_spacing = 3;//4;

line_height_i:==12;//font_size+line_spacing;

top :== 842.0;
page_width :== 595.0;

left_margin :== 50.0;
right_margin :== 50.0;

indent_width :== 30.0;

TS :: !{#Char} -> [Text];
TS s = [TString s];

TSI :: !{#Char} -> [Text];
TSI s
	= [ TFont microsoft_sans_serif_n ("/F2 "+++toString font_size+++" Tf") FCNo,
		TString s,
		TFont microsoft_sans_serif_n ("/F1 "+++toString font_size+++" Tf") FCNo];

TSB :: !{#Char} -> [Text];
TSB s
	= [ TFont microsoft_sans_serif_n ("/F3 "+++toString font_size+++" Tf") FCNo,
		TString s,
		TFont microsoft_sans_serif_n ("/F1 "+++toString font_size+++" Tf") FCNo];

TSC :: !{#Char} -> [Text];
TSC s
	= [TFont courier_n ("/F4 "+++toString font_size+++" Tf") FCNo,
	   TString s,
	   TFont microsoft_sans_serif_n ("/F1 "+++toString font_size+++" Tf") FCNo];

TST :: !{#Char} -> [Text];
TST s
	= [TFont courier_bold_n ("/F5 "+++toString font_size+++" Tf") (FCRGB TerminalColor),
	   TString s,
	   TFont microsoft_sans_serif_n ("/F1 "+++toString font_size+++" Tf") FCBlack];

TSb :: !{#Char} -> [Text];
TSb s = [TFont -1 "" (FCRGB (0,0,255)), TString s, TFont -1 "" FCBlack];

TSL :: !{#Char} -> [Text];
TSL s = [TFont -1 "" (FCRGB (0,0,255)), TLink s, TFont -1 "" FCBlack];

TSCb :: !{#Char} -> [Text];
TSCb s
	= [TFont courier_n ("/F4 "+++toString font_size+++" Tf") (FCRGB (0,0,255)),
	   TString s,
	   TFont microsoft_sans_serif_n ("/F1 "+++toString font_size+++" Tf") FCBlack];

TSBCb :: !{#Char} -> [Text];
TSBCb s
	= [TFont courier_bold_n ("/F5 "+++toString font_size+++" Tf") (FCRGB (0,0,255)),
	   TString s,
	   TFont microsoft_sans_serif_n ("/F1 "+++toString font_size+++" Tf") FCBlack];

TSBCr :: !{#Char} -> [Text];
TSBCr s
	= [TFont courier_bold_n ("/F5 "+++toString font_size+++" Tf") (FCRGB (255,0,0)),
	   TString s,
	   TFont microsoft_sans_serif_n ("/F1 "+++toString font_size+++" Tf") FCBlack];

red_bold_s_in_courier :: !{#Char} -> [Text];
red_bold_s_in_courier s
	= [TFont courier_bold_n ("/F5 "+++toString font_size+++" Tf") (FCRGB (255,0,0)),
	   TString s,
	   TFont courier_n ("/F4 "+++toString font_size+++" Tf") FCBlack];

orange_bold_s :: !{#Char} -> [Text];
orange_bold_s s
	= [TFont microsoft_sans_serif_n ("/F3 "+++toString font_size+++" Tf") (FCRGB OrangeColor),
	   TString s,
	   TFont microsoft_sans_serif_n ("/F1 "+++toString font_size+++" Tf") FCBlack];

TS_E :: [Text];
TS_E = TS "=";
TS_B :: [Text];
TS_B = TS "|";

(TA) infixl :: ![Text] !{#Char} -> [Text];
(TA) t s = t++TS s;

(TAb) infixl :: ![Text] !{#Char} -> [Text];
(TAb) t s = t++TSb s;

(TAI) infixl :: ![Text] !{#Char} -> [Text];
(TAI) t s = t++TSI s;

(TAC) infixl :: ![Text] !{#Char} -> [Text];
(TAC) t s = t++TSC s;

(TACb) infixl :: ![Text] !{#Char} -> [Text];
(TACb) t s = t++TSCb s;

(TABCb) infixl :: ![Text] !{#Char} -> [Text];
(TABCb) t s = t++TSBCb s;

(TABCr) infixl :: ![Text] !{#Char} -> [Text];
(TABCr) t s = t++TSBCr s;

(TAL) infixl :: ![Text] !{#Char} -> [Text];
(TAL) t s = t++TSL s;

(TAT) infixl :: ![Text] !{#Char} -> [Text];
(TAT) t s = t++TST s;

:: PDFState = {
		y_pos :: !Int,
		t_s :: !{#Char},
		h_s :: !{#Char},
		link_l :: ![Link]
	};

:: PDFInfo = ! {
		char_width_and_kerns :: !{!CharWidthAndKerns},
		text_cwk :: !CharWidthAndKerns,
		text_font_n :: !Int,
		width :: !Real
	};

new_pdf_s :: PDFState;
new_pdf_s = {y_pos=0,t_s="",h_s="",link_l=[]};

syntax_t_min_widths_c0 = [114];
syntax_t_min_widths_c02 = [114,0,134];

make_pdf :: !PDFInfo !Headings !{#Char} !PDFState ![DI] -> (!Headings,!{#Char},!PDFState);
make_pdf pdf_i headings g_s pdf_s [P s:dis]
	# pdf_s = show_format_lines s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [S s:dis]
	# pdf_s = show_format_lines_s s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [CP s:dis]
	# pdf_s = a_show_format_lines s pdf_i.text_font_n pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [CS s:dis]
	# pdf_s = a_show_format_lines_s s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [MP lines:dis]
	# pdf_s = show_format_lines_list lines pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s [SP s:dis]
	# (g_s,pdf_s) = show_format_lines_with_square s g_s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [MSP s:dis]
	# (g_s,pdf_s) = show_format_lines_list_with_square s g_s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [CMSP s:dis]
	# (g_s,pdf_s) = a_show_format_lines_list_with_square s g_s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [BP s:dis]
	# pdf_s = show_format_lines_with_bullet s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [MBP lines:dis]
	# pdf_s = show_format_lines_list_with_bullet lines pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [MBS s:dis]
	# pdf_s = show_format_lines_s_list_with_bullet s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [PW s1 indent_width s:dis]
//	# pdf_s = show_format_text_with s1 s pdf_i pdf_s;
	# pdf_s = show_format_lines_with s1 s indent_width pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [PWP s1 indent_width_percentage s:dis]
	# pdf_s = show_format_lines_with_indent_percentage s1 s indent_width_percentage pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [MPW indent_width mhl:dis]
	# pdf_s = show_format_lines_list_with indent_width mhl pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [PWI s1 s:dis]
	# pdf_s = show_format_text_with_indented s1 s pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [MPWI mhl:dis]
	# pdf_s = show_format_text_with_list_indented mhl pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s [N:dis]
	# pdf_s = show_new_line_s line_height_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s [PC lines:dis]
	# (g_s,pdf_s) = program_code_only lines pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s=:{y_pos} [PCP lines rectangles:dis]
	# y_pos = if (y_pos<>0) (y_pos+font_size+line_spacing) y_pos;
	# pdf_s & h_s=pdf_s.h_s+++clean_svg_picture_absolute (toReal line_height_i*(1.0+toReal (length lines))) rectangles;
	# (g_s,pdf_s) = program_code_only_ lines pdf_i g_s pdf_s;
	# g_s=g_s+++pen_color_8bit 0 0 0;
	# (p_g_s,p_t_s) = draw_picture rectangles left_margin (top-toReal y_pos);
	# g_s=g_s+++p_g_s;
	# pdf_s & t_s=pdf_s.t_s+++p_t_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s [PCH heading lines:dis=:[CPCH heading2 lines2:_]]
	# (g_s,pdf_s) = program_code_ heading lines pdf_i g_s pdf_s;
	= make_pdf_c_pc pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [PCH heading lines:dis]
	# (g_s,pdf_s) = program_code heading lines pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [CPC lines:dis]
	# (g_s,pdf_s) = a_program_code_only lines pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s=:{y_pos} [CPCP lines rectangles:dis]
	# pdf_s & h_s=pdf_s.h_s+++clean_svg_picture_absolute (toReal line_height_i*(1.0+toReal (length lines))) rectangles;
	# (g_s,pdf_s) = a_program_code_only lines pdf_i g_s pdf_s;
	# g_s=g_s+++pen_color_8bit 0 0 0;
	# (p_g_s,p_t_s) = draw_picture rectangles left_margin (top-toReal y_pos-2.0);
	# g_s=g_s+++p_g_s;
	# pdf_s & t_s=pdf_s.t_s+++p_t_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s [CPCH heading lines:dis]
	# (g_s,pdf_s) = a_program_code heading lines pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s [PCMH program_headings lines:dis=:[CPCH heading2 lines2:_]]
	# (g_s,pdf_s) = program_headings_code_ program_headings lines pdf_i g_s pdf_s;
	= make_pdf_c_pc pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [PCMH program_headings lines:dis]
	# (g_s,pdf_s) = program_headings_code program_headings lines pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i=:{width} headings g_s pdf_s=:{y_pos,t_s} [PCNP lines height picture:dis]
	# indent = 0.5*width;
	# (p_g_s,p_t_s) = draw_picture_indent picture (left_margin+indent) indent (top-toReal y_pos);
	# g_s=g_s+++p_g_s;
	# t_s=t_s+++p_t_s;
//	# (y_pos,t_s) = move_text_cursor_y height y_pos t_s;
	# pdf_s & t_s=t_s,y_pos=y_pos;

	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\"><tr><td style=\"width:50%;\">";

	# (g_s,pdf_s) = program_code_only_ lines {pdf_i & width=0.5*width-20.0} g_s pdf_s;

	# pdf_s & h_s=pdf_s.h_s+++"</td><td style=\"width:50%;\">";

	# pdf_s & h_s=pdf_s.h_s+++clean_svg_picture 250.0 (toReal height) picture;

	# pdf_s & h_s=pdf_s.h_s+++"</td></tr></table>";

	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s [T table:dis]
	# pdf_s = show_table table 10 pdf_i pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s=:{y_pos} [TB table:dis]
	# old_y_pos=y_pos;
	# (column_widths,pdf_s=:{y_pos}) = show_table_min_widths_yield_widths table [] 10 pdf_i pdf_s;
	# g_s=g_s+++rgb_RGB_8bit ProgramColor+++background_color old_y_pos y_pos left_margin pdf_i.width top;
	# g_s=g_s+++rgb_RGB_8bit (150,150,150);
	# g_s=g_s+++draw_line_to left_margin (top-toReal (old_y_pos+line_height_i+3)) (left_margin+pdf_i.width) (top-toReal (old_y_pos+line_height_i+3));
	# g_s=g_s+++draw_table_lines_between_columns 0 column_widths 10 old_y_pos y_pos left_margin;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [ST table:dis]
	# (g_s,pdf_s) = show_syntax_table table syntax_t_min_widths_c0 pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [ST2 table:dis]
	# (g_s,pdf_s) = show_syntax_table table syntax_t_min_widths_c02 pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s [C s1 s2:dis]
	# (headings,g_s,pdf_s) = show_chapter s1 s2 pdf_i;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [C3S s1 s2 s3:dis]
	# (headings,g_s,pdf_s) = show_chapter_3s s1 s2 s3 pdf_i;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [H2 h_n h_s:dis]
	# (headings,g_s,pdf_s) = show_heading_2 h_n h_s pdf_i headings g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [H3 h_n h_s:dis]
	# (headings,g_s,pdf_s) = show_heading_3 h_n h_s pdf_i headings g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;
make_pdf pdf_i headings g_s pdf_s [H3T h_s:dis]
	# (g_s,pdf_s) = show_heading_3_without_number h_s pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s=:{y_pos,t_s} [PI height picture:dis]
	# pdf_s & h_s=pdf_s.h_s+++clean_svg_picture 500.0 (toReal height) picture;
	# (p_g_s,p_t_s) = draw_picture picture left_margin (top-toReal y_pos);
	# g_s=g_s+++p_g_s;
	# t_s=t_s+++p_t_s;
	# (y_pos,t_s) = move_text_cursor_y height y_pos t_s;
	# pdf_s & t_s=t_s,y_pos=y_pos;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf pdf_i headings g_s pdf_s []
	= (headings,g_s,pdf_s); // pdf_shl, pdf strings headings links

make_pdf_c_pc pdf_i headings g_s pdf_s [CPCH heading lines:dis=:[CPCH _ _:_]]
	# (g_s,pdf_s) = c_program_code_ heading lines pdf_i g_s pdf_s;
	= make_pdf_c_pc pdf_i headings g_s pdf_s dis;
make_pdf_c_pc pdf_i headings g_s pdf_s [CPCH heading lines:dis]
	# (g_s,pdf_s) = c_program_code heading lines pdf_i g_s pdf_s;
	= make_pdf pdf_i headings g_s pdf_s dis;

make_pdf_shl :: !PDFInfo ![DI] -> (!Headings,!{#Char},!PDFState);
make_pdf_shl pdf_i dis
	= make_pdf pdf_i [] "" new_pdf_s dis;

init_PDFInfo :: !{!CharWidthAndKerns} -> PDFInfo;
init_PDFInfo char_width_and_kerns
	# width = page_width - 2.0 - (left_margin+right_margin);
	= {	char_width_and_kerns=char_width_and_kerns,width=width,
		text_font_n=microsoft_sans_serif_n,
		text_cwk=char_width_and_kerns.[microsoft_sans_serif_n]};

background_color :: !Int !Int !Real !Real !Real -> {#Char};
background_color old_y_pos y_pos left_margin width top
	= toString left_margin+++" "+++toString (top-2.0-toReal y_pos)+++" "+++toString (width+2.0)+++" "+++toString (toReal (y_pos-old_y_pos-1))+++" re "+++
		"B ";

background_color_rectangle :: !Real !Real !Real !Real !Real -> {#Char};
background_color_rectangle y_pos height left_margin width top
	= toString left_margin+++" "+++toString (top-2.0-toReal y_pos)+++" "+++toString width+++" "+++toString height+++" re "+++
		"B ";

rectangle :: !Real !Real !Real !Real !Real -> {#Char};
rectangle y_pos height left_margin width top
	= toString left_margin+++" "+++toString (top-2.0-toReal y_pos)+++" "+++toString width+++" "+++toString height+++" re "+++
		"S ";

show_new_line :: !Int !Int !{#Char} -> (!Int,!{#Char});
show_new_line line_height_i y_pos t_s
	# t_s=t_s+++"T*\n";
	  y_pos = y_pos + line_height_i;
	= (y_pos,t_s);

show_new_line_s :: !Int !PDFState -> PDFState;
show_new_line_s line_height_i pdf_s=:{y_pos,t_s}
	# t_s=t_s+++"T*\n";
	  y_pos = y_pos + line_height_i;
	= {pdf_s & y_pos=y_pos,t_s=t_s};

print_indented_format_string :: !{#Char} !Real !CharWidthAndKerns -> {#Char};
print_indented_format_string s extra_margin font_cwk
	= toString extra_margin+++" 0 Td "+++
	  print_formatted_string s font_cwk+++
	  toString (~extra_margin)+++" 0 Td ";

print_new_indented_lines_with :: !{#Char} ![{#Char}] !Real !Real !CharWidthAndKerns -> {#Char};
print_new_indented_lines_with s lines extra_margin width char_width_and_kerns
	= "T*\n"+++print_formatted_string s char_width_and_kerns+++
	  toString extra_margin+++" 0 Td "+++
	  print_lines lines font_size width char_width_and_kerns+++
	  toString (~extra_margin)+++" 0 Td ";

print_heading_2 :: !{#Char} ![{#Char}] !Real !Real !CharWidthAndKerns -> {#Char};
print_heading_2 h_n h_s extra_margin width font_cwk
	= "/F1 "+++toString 10+++" Tf "+++
	  toString (10+line_spacing)+++" TL "+++

	  print_new_indented_lines_with h_n h_s extra_margin width font_cwk+++

	  toString line_height_i+++" TL "+++
	  "/F1 "+++toString 9+++" Tf ";

format_heading_2 :: !{#Char} !Int !{#Char} !Real !Real !Real !CharWidthAndKerns -> (![{#Char}],!Int,!{#Char});
format_heading_2 h_s y_pos g_s left_margin width top font_cwk
	# old_y_pos=y_pos;
	  (lines_s,n_lines_s) = format_lines h_s width 10 font_cwk;
	  h_size = (10+line_spacing) * n_lines_s;
	  y_pos = y_pos + h_size;
	  g_s=g_s+++rgb_RGB_8bit HeaderColor+++background_color old_y_pos y_pos left_margin width top;
	= (lines_s,y_pos,g_s);

format_heading_3 :: !{#Char} !Int !{#Char} !Real !Real !Real !CharWidthAndKerns -> (![{#Char}],!Int,!{#Char});
format_heading_3 h_s y_pos g_s left_margin width top font_cwk
	# old_y_pos=y_pos;
	  (lines_s,n_lines_s) = format_lines h_s width 9 font_cwk;
	  h_size = (9+line_spacing) * n_lines_s;
	  y_pos = y_pos + h_size;
	  g_s=g_s+++rgb_RGB_8bit HeaderColor+++background_color old_y_pos y_pos left_margin width top;
	= (lines_s,y_pos,g_s);

show_right_aligned_format_string :: !{#.Char} !Int !Int !CharWidthAndKerns !Real !Int !{#Char} -> (!Int,!{#Char});
show_right_aligned_format_string s font_size line_spacing font_cwk width y_pos t_s
	# s_x_pos = width-toReal (string_width s font_cwk*font_size)/1000.0;
	  t_s=t_s+++"T*\n"+++print_indented_format_string s s_x_pos font_cwk;
	  y_pos = y_pos + font_size+line_spacing;
	= (y_pos,t_s);

html_color :: !(Int,!Int,!Int) -> {#Char};
html_color (r,g,b)
	= {hex_char (r>>4),hex_char r,hex_char (g>>4),hex_char g,hex_char (b>>4),hex_char b};

hex_char i
	= "0123456789ABCDEF".[i bitand 15];
/*
spaces_to_underscores :: !{#Char} -> *{#Char};
spaces_to_underscores s = {if (c==' ') '_' c \\ c<-:s};
*/
remove_chapter_or_appendix :: !{#Char} -> {#Char};
remove_chapter_or_appendix s
	| s % (0,7)=="Chapter "
		= s % (8,size s-1);
	| s % (0,8)=="Appendix "
		= s % (9,size s-1);
	| s=="Preface"
		= "P";
		= s;

html_chapter :: !{#Char} !{#Char} -> {#Char};
html_chapter h_n h_s
//	= "<h1>"+++h_n+++" "+++h_s+++"</h1>\n";
//	= "<h1 style=\"background-color:#"+++html_color HeaderColor+++";\">"+++h_n+++" "+++h_s+++"</h1>\n";
	= "<!-- chapter:"+++h_n+++"-->\n"+++
	  "<div><div style=\"position: absolute;\">"+++clean_svg_logo+++"</div>"+++
//	  "<h1 style=\"text-align:right;background-color:#"+++html_color HeaderColor+++";\">"+++
	  "<h1 style=\"text-align:right;background-color:#"+++html_color HeaderColor+++";\"><a id=\"_"+++remove_chapter_or_appendix h_n+++"\">"+++
//	  "<br>"+++h_n+++"<br><br>"+++h_s+++"</h1>"+++
	  "<br>"+++h_n+++"<br><br>"+++h_s+++"</a></h1>"+++
	  "</div>\n";

show_chapter :: !{#Char} !{#Char} !PDFInfo -> (!Headings,!{#Char},!PDFState);
show_chapter h_n h_s {text_cwk,width}
	# y_pos = 0;
	  g_s = "";
	  t_s = "";

	# headings = [(1,h_n,h_s,y_pos)];

	# t_s=t_s+++"/F1 "+++toString 28+++" Tf "+++toString (28+line_spacing)+++" TL ";

	# old_y_pos=y_pos;
	# (y_pos,t_s) = show_new_line (28+line_spacing) y_pos t_s;
	# (y_pos,t_s) = show_right_aligned_format_string h_n 28 line_spacing text_cwk width y_pos t_s;
	# (y_pos,t_s) = show_new_line (28+line_spacing) y_pos t_s;
	# (y_pos,t_s) = show_right_aligned_format_string h_s 28 line_spacing text_cwk width y_pos t_s;
	# g_s=g_s+++rgb_RGB_8bit HeaderColor+++background_color (old_y_pos+4) (y_pos+4) left_margin width top;

	# g_s=g_s+++clean_logo 130.0 (top-56.0);
	# t_s=t_s+++clean_logo_text 130.0 (top-56.0);

	# t_s=t_s+++"1 0 0 1 "+++toString left_margin+++" "+++toString (top-toReal y_pos)+++" Tm ";

	# t_s=t_s+++"/F1 "+++toString font_size+++" Tf "+++toString (font_size+line_spacing)+++" TL ";

	# h_s = html_chapter h_n h_s;

	= (headings,g_s,{y_pos=y_pos,t_s=t_s,h_s=h_s,link_l=[]});

contains_spaces i s
	| i<size s
		= s.[i]==' ' || contains_spaces (i+1) s;
		= False;

html_chapter_3s :: !{#Char} !{#Char} !{#Char} -> {#Char};
html_chapter_3s s1 s2 s3
//	= "<h1>"+++s1+++" "+++s2+++" "+++s3+++"</h1>\n";
//	= "<h1 style=\"background-color:#"+++html_color HeaderColor+++";\">"+++s1+++" "+++s2+++" "+++s3+++"</h1>\n";
	= "<!-- chapter:"+++s3+++"-->\n"+++
	  "<div><div style=\"position: absolute;\">"+++clean_svg_logo+++"</div>"+++
	  "<div style=\"background-color:#"+++html_color HeaderColor+++";\">"+++
	  (if (contains_spaces 0 s3) "" ("<a id=\"_"+++remove_chapter_or_appendix s3+++"\">"))+++
	  "<h1 style=\"text-align:right;padding-top:0.6em;margin-bottom:0.6em;\">"+++s1+++"<br>"+++s2+++"</h1>\n"+++
	  "<h1 style=\"text-align:right;margin-top:0.6em;\">"+++s3+++"</h1></div>"+++
	  "</div>\n";

show_chapter_3s :: !{#Char} !{#Char} !{#Char} !PDFInfo -> (!Headings,!{#Char},!PDFState);
show_chapter_3s s1 s2 s3 {text_cwk,width}
	# y_pos = 0;
	  g_s = "";
	  t_s = "";

	# headings = [(1,s3,"",y_pos)];

	# t_s=t_s+++"/F1 "+++toString 28+++" Tf ";
	# t_s=t_s+++toString (28+line_spacing)+++" TL ";

	# old_y_pos=y_pos;
	# t_s=t_s+++toString (14+line_spacing/2)+++" TL ";
	# (y_pos,t_s) = show_new_line (14+line_spacing/2) y_pos t_s;
	# t_s=t_s+++toString (28+line_spacing)+++" TL ";
	# (y_pos,t_s) = show_right_aligned_format_string s1 28 line_spacing text_cwk width y_pos t_s;
	# (y_pos,t_s) = show_right_aligned_format_string s2 28 line_spacing text_cwk width y_pos t_s;
	# t_s=t_s+++toString (14+(line_spacing-line_spacing/2))+++" TL ";
	# (y_pos,t_s) = show_new_line (14+line_spacing/2) y_pos t_s;
	# t_s=t_s+++toString (28+line_spacing)+++" TL ";
	# (y_pos,t_s) = show_right_aligned_format_string s3 28 line_spacing text_cwk width y_pos t_s;

	# g_s=g_s+++rgb_RGB_8bit HeaderColor+++background_color (old_y_pos+4) (y_pos+4) left_margin width top;

	# g_s=g_s+++clean_logo 130.0 (top-56.0);
	# t_s=t_s+++clean_logo_text 130.0 (top-56.0);

	# t_s=t_s+++"1 0 0 1 "+++toString left_margin+++" "+++toString (top-toReal y_pos)+++" Tm ";

	# t_s=t_s+++"/F1 "+++toString font_size+++" Tf "+++toString (font_size+line_spacing)+++" TL ";

	# h_s = html_chapter_3s s1 s2 s3;

	= (headings,g_s,{y_pos=y_pos,t_s=t_s,h_s=h_s,link_l=[]});	

html_h2 h_n h_s
//	= "<h2>"+++h_n+++" "+++h_s+++"</h2>\n";
//	= "<h2 style=\"background-color:#"+++html_color HeaderColor+++";\">"+++h_n+++" "+++h_s+++"</h2>\n";
	= "<h2 style=\"background-color:#"+++html_color HeaderColor+++";\"><a id=\"_"+++remove_chapter_or_appendix h_n+++"\">"+++h_n+++" "+++h_s+++"</a></h2>\n";

show_heading_2 :: !{#Char} !{#Char} !PDFInfo !Headings !{#Char} !PDFState -> (!Headings,!{#Char},!PDFState);
show_heading_2 h_n h_s {text_cwk,width} headings g_s {y_pos,t_s,link_l,h_s=html_s}
	# (y_pos,t_s)
		= if (y_pos<>0)
			(show_new_line line_height_i y_pos t_s)
			(y_pos,t_s);
	# headings = [(2,h_n,h_s,y_pos):headings];
	# (lines_s,y_pos,g_s) = format_heading_2 h_s y_pos g_s left_margin width top text_cwk;
	# t_s=t_s+++print_heading_2 h_n lines_s indent_width width text_cwk;
	
	# html_s=html_s+++html_h2 h_n h_s;
	
	= (headings,g_s,{y_pos=y_pos,t_s=t_s,link_l=link_l,h_s=html_s});

html_h3 h_n h_s
//	= "<h3>"+++h_n+++" "+++h_s+++"</h3>\n";
//	= "<h3 style=\"background-color:#"+++html_color HeaderColor+++";\">"+++h_n+++" "+++h_s+++"</h3>\n";
	= "<h3 style=\"background-color:#"+++html_color HeaderColor+++";\"><a id=\"_"+++remove_chapter_or_appendix h_n+++"\">"+++h_n+++" "+++h_s+++"</a></h3>\n";

show_heading_3 :: !{#Char} !{#Char} !PDFInfo !Headings !{#Char} !PDFState -> (!Headings,!{#Char},!PDFState);
show_heading_3 h_n h_s {text_cwk,width} headings g_s {y_pos,t_s,link_l,h_s=html_s}
	# (y_pos,t_s)
		= if (y_pos<>0)
			(show_new_line line_height_i y_pos t_s)
			(y_pos,t_s);
	# headings = [(3,h_n,h_s,y_pos):headings];
	# (lines_s,y_pos,g_s) = format_heading_3 h_s y_pos g_s left_margin width top text_cwk;
	# t_s=t_s+++print_new_indented_lines_with h_n lines_s indent_width width text_cwk;

	# html_s=html_s+++html_h3 h_n h_s;

	= (headings,g_s,{y_pos=y_pos,t_s=t_s,link_l=link_l,h_s=html_s});

html_h3_without_number h_s
//	= "<h3>"+++"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+++h_s+++"</h3>\n";
	= "<h3 style=\"background-color:#"+++html_color HeaderColor+++";\">"+++"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp"+++h_s+++"</h3>\n";

show_heading_3_without_number :: !{#Char} !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
show_heading_3_without_number h_s {text_cwk,width} g_s {y_pos,t_s,link_l,h_s=html_s}
	# (lines_s,y_pos,g_s) = format_heading_3 h_s y_pos g_s left_margin width top text_cwk;
	# t_s=t_s+++print_new_indented_lines lines_s font_size indent_width width text_cwk;

	# html_s=html_s+++html_h3_without_number h_s;

	= (g_s,{y_pos=y_pos,t_s=t_s,link_l=link_l,h_s=html_s});

find_reserved_char i s
	| i<size s
		# c=s.[i]
		| c=='<' || c=='>' || c=='&'
			= i;
		| c>='\x80' && c<='\x86'
			= i;
		= find_reserved_char (i+1) s;
		= i;

convert_reserved_chars :: !Int !{#Char} -> {#Char};
convert_reserved_chars i s
	# r_i = find_reserved_char i s;
	| r_i>=size s
		| i==0
			= s;
			= s % (i,size s-1);
	# c=s.[r_i];
	| c=='<'
		= s % (i,r_i-1)+++"&lt;"+++convert_reserved_chars (r_i+1) s;
	| c=='>'
		= s % (i,r_i-1)+++"&gt;"+++convert_reserved_chars (r_i+1) s;
	| c=='&'
		= s % (i,r_i-1)+++"&amp;"+++convert_reserved_chars (r_i+1) s;
	| c=='\x80'
		= s % (i,r_i-1)+++"&le;"+++convert_reserved_chars (r_i+1) s;
	| c=='\x81'
		= s % (i,r_i-1)+++"&ge;"+++convert_reserved_chars (r_i+1) s;
	| c=='\x82'
		= s % (i,r_i-1)+++"&sigma;"+++convert_reserved_chars (r_i+1) s;
	| c=='\x83'
		= s % (i,r_i-1)+++"&tau;"+++convert_reserved_chars (r_i+1) s;
	| c=='\x84'
		= s % (i,r_i-1)+++"&Sigma;"+++convert_reserved_chars (r_i+1) s;
	| c=='\x85'
		= s % (i,r_i-1)+++"&Tau;"+++convert_reserved_chars (r_i+1) s;
	| c=='\x86'
		= s % (i,r_i-1)+++"&#x27c2;"+++convert_reserved_chars (r_i+1) s;		

find_reserved_char_or_space i s
	| i<size s
		# c=s.[i]
		| c==' ' || c=='<' || c=='>' || c=='&'
			= i;
		= find_reserved_char_or_space (i+1) s;
		= i;

convert_reserved_chars_with_spaces :: !Int !{#Char} -> {#Char};
convert_reserved_chars_with_spaces i s
	# r_i = find_reserved_char_or_space i s;
	| r_i>=size s
		| i==0
			= s;
			= s % (i,size s-1);
	# c=s.[r_i];
	| c==' '
		= s % (i,r_i-1)+++"&nbsp;"+++convert_reserved_chars_with_spaces (r_i+1) s;
	| c=='<'
		= s % (i,r_i-1)+++"&lt;"+++convert_reserved_chars_with_spaces (r_i+1) s;
	| c=='>'
		= s % (i,r_i-1)+++"&gt;"+++convert_reserved_chars_with_spaces (r_i+1) s;
	| c=='&'
		= s % (i,r_i-1)+++"&amp;"+++convert_reserved_chars_with_spaces (r_i+1) s;

html_p s
	# s = convert_reserved_chars 0 s;
//	= "<p>"+++s+++"</p>\n";
	= "<p style=\"text-align:justify;\">"+++s+++"</p>\n";

a_show_format_lines_s :: !{#Char} !PDFInfo !PDFState -> PDFState;
a_show_format_lines_s string {text_cwk,width} pdf_s=:{y_pos,t_s,h_s}
	# (lines,n_lines) = format_lines string width font_size text_cwk;
	  t_s=t_s+++print_new_lines lines font_size width text_cwk;
	  y_pos = y_pos + line_height_i * n_lines;
	  
	  h_s=h_s+++html_p string;

	= {pdf_s & y_pos=y_pos,t_s=t_s,h_s=h_s};

show_format_lines_s :: !{#Char} !PDFInfo !PDFState -> PDFState;
show_format_lines_s string pdf_i pdf_s=:{y_pos}
	| y_pos<>0
		# pdf_s = show_new_line_s (font_size+line_spacing) pdf_s;
		= a_show_format_lines_s string pdf_i pdf_s;
		= a_show_format_lines_s string pdf_i pdf_s;

print_new_format_lines :: !(![({#Char},Int,Int)],![Text]) !Int !Int !Real !{!CharWidthAndKerns} !PDFState -> (!{#Char},![Link]);
print_new_format_lines lines_slices_and_text font_size font_n width char_width_and_kerns {y_pos,t_s,link_l}
	# (f_s,new_link_l) = print_format_lines lines_slices_and_text font_size font_n width char_width_and_kerns;
	  line_height_i = font_size+line_spacing;
	  new_link_l = [{link & link_y_pos=y_pos+(1+link_y_pos)*line_height_i} \\ link=:{link_y_pos}<-new_link_l];
	= (t_s+++"T*\n"+++f_s,new_link_l++link_l);

span_color rgb s
	= "<span style=\"color:#"+++html_color rgb+++";\">"+++s+++"</span>";

span_blue s
	= "<span style=\"color:blue;\">"+++s+++"</span>";

span_blue_href href_s s
	= "<span style=\"color:blue;\"><a href=\"#_"+++href_s+++"\">"+++s+++"</a></span>";

get_section_number i begin_i s
	| i<size s && (isDigit s.[i] || s.[i]=='.')
		= get_section_number (i+1) begin_i s;
		= (begin_i,i);

find_section_number_indices :: !Int !{#Char} -> (!Int,!Int);
find_section_number_indices i s
	| i<size s
		| isDigit s.[i]
			= get_section_number (i+1) i s;
		| (s.[i]=='A' || s.[i]=='B') && (i+1==size s || s.[i+1]=='.')
			= get_section_number (i+2) i s;
			= find_section_number_indices (i+1) s;
		= (-1,-1);

find_section_number :: !{#Char} -> {#Char};
find_section_number s
	# (begin_section_number_i,end_section_number_i)	= find_section_number_indices 0 s;
	| begin_section_number_i<0
		= "";
		= s % (begin_section_number_i,end_section_number_i-1);

convert_reserved_chars_t [TString s]
	= convert_reserved_chars 0 s;
convert_reserved_chars_t [TLink s]
	# href_s = find_section_number s
	| size href_s==0
		= span_blue (convert_reserved_chars 0 s);
		= span_blue_href href_s (convert_reserved_chars 0 s);
convert_reserved_chars_t [_]
	= "";
convert_reserved_chars_t [TFont -1 "" (FCRGB rgb),TString s,TFont -1 "" FCBlack:text_l]
	= span_color rgb (convert_reserved_chars 0 s)+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TFont 0 "/F2 9 Tf" FCNo,TString s,TFont 0 "/F1 9 Tf" FCNo:text_l]
	= "<i>"+++convert_reserved_chars 0 s+++"</i>"+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TFont 0 "/F3 9 Tf" FCNo,TString s,TFont 0 "/F1 9 Tf" FCNo:text_l]
	= "<b>"+++convert_reserved_chars 0 s+++"</b>"+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TFont 0 "/F3 9 Tf" (FCRGB rgb),TString s,TFont 0 "/F1 9 Tf" FCBlack:text_l]
	= "<span style=\"color:#"+++html_color rgb+++";\"><b>"+++convert_reserved_chars 0 s+++"</b></span>"+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TFont 1 "/F4 9 Tf" FCNo,TString s,TFont 0 "/F1 9 Tf" FCNo:text_l]
	= "<span style=\"font-family:courier;\">"+++convert_reserved_chars 0 s+++"</span>"+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TFont 1 "/F4 9 Tf" (FCRGB rgb),TString s,TFont 0 "/F1 9 Tf" FCBlack:text_l]
	= "<span style=\"font-family:courier;color:#"+++html_color rgb+++";\">"+++convert_reserved_chars 0 s+++"</span>"+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TFont 1 "/F4 9 Tf" (FCRGB rgb),TString s,TFont 1 "/F4 9 Tf" FCBlack:text_l]
	= "<span style=\"font-family:courier;color:#"+++html_color rgb+++";\">"+++convert_reserved_chars 0 s+++"</span>"+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TFont 2 "/F5 9 Tf" (FCRGB rgb),TString s,TFont 0 "/F1 9 Tf" FCBlack:text_l]
	= "<span style=\"font-family:courier;color:#"+++html_color rgb+++";\"><b>"+++convert_reserved_chars 0 s+++"</b></span>"+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TFont 2 "/F5 9 Tf" (FCRGB rgb),TString s,TFont 1 "/F4 9 Tf" FCBlack:text_l]
	= "<span style=\"font-family:courier;color:#"+++html_color rgb+++";\"><b>"+++convert_reserved_chars 0 s+++"</b></span>"+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TString s:text_l]
	= convert_reserved_chars 0 s+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [TLink s:text_l]
	# href_s = find_section_number s
	| size href_s==0
		= span_blue (convert_reserved_chars 0 s)+++convert_reserved_chars_t text_l;
		= span_blue_href href_s (convert_reserved_chars 0 s)+++convert_reserved_chars_t text_l;
convert_reserved_chars_t [_:text_l]
	= convert_reserved_chars_t text_l;
convert_reserved_chars_t []
	= "";

html_p_t text_l
	# s = convert_reserved_chars_t text_l;
//	= "<p>"+++s+++"</p>\n";
	= "<p style=\"text-align:justify;\">"+++s+++"</p>\n";

convert_reserved_chars_with_spaces_t [TString s]
	= convert_reserved_chars_with_spaces 0 s;
convert_reserved_chars_with_spaces_t [TLink s]
	= convert_reserved_chars_with_spaces 0 s;
convert_reserved_chars_with_spaces_t [_]
	= "";
convert_reserved_chars_with_spaces_t [TFont -1 "" (FCRGB rgb),TString s,TFont -1 "" FCBlack:text_l]
	= span_color rgb (convert_reserved_chars_with_spaces 0 s)+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TFont 0 "/F2 9 Tf" FCNo,TString s,TFont 0 "/F1 9 Tf" FCNo:text_l]
	= "<i>"+++convert_reserved_chars_with_spaces 0 s+++"</i>"+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TFont 0 "/F3 9 Tf" FCNo,TString s,TFont 0 "/F1 9 Tf" FCNo:text_l]
	= "<b>"+++convert_reserved_chars_with_spaces 0 s+++"</b>"+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TFont 0 "/F3 9 Tf" (FCRGB rgb),TString s,TFont 0 "/F1 9 Tf" FCBlack:text_l]
	= "<span style=\"color:#"+++html_color rgb+++";\"><b>"+++convert_reserved_chars_with_spaces 0 s+++"</b></span>"+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TFont 1 "/F4 9 Tf" FCNo,TString s,TFont 0 "/F1 9 Tf" FCNo:text_l]
	= "<span style=\"font-family:courier;\">"+++convert_reserved_chars_with_spaces 0 s+++"</span>"+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TFont 1 "/F4 9 Tf" (FCRGB rgb),TString s,TFont 0 "/F1 9 Tf" FCBlack:text_l]
	= "<span style=\"font-family:courier;color:#"+++html_color rgb+++";\">"+++convert_reserved_chars_with_spaces 0 s+++"</span>"+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TFont 1 "/F4 9 Tf" (FCRGB rgb),TString s,TFont 1 "/F4 9 Tf" FCBlack:text_l]
	= "<span style=\"font-family:courier;color:#"+++html_color rgb+++";\">"+++convert_reserved_chars_with_spaces 0 s+++"</span>"+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TFont 2 "/F5 9 Tf" (FCRGB rgb),TString s,TFont 0 "/F1 9 Tf" FCBlack:text_l]
	= "<span style=\"font-family:courier;color:#"+++html_color rgb+++";\"><b>"+++convert_reserved_chars_with_spaces 0 s+++"</b></span>"+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TFont 2 "/F5 9 Tf" (FCRGB rgb),TString s,TFont 1 "/F4 9 Tf" FCBlack:text_l]
	= "<span style=\"font-family:courier;color:#"+++html_color rgb+++";\"><b>"+++convert_reserved_chars_with_spaces 0 s+++"</b></span>"+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TString s:text_l]
	= convert_reserved_chars_with_spaces 0 s+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [TLink s:text_l]
	= convert_reserved_chars_with_spaces 0 s+++convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t [_:text_l]
	= convert_reserved_chars_with_spaces_t text_l;
convert_reserved_chars_with_spaces_t []
	= "";

html_p_courier_t text_l
	# s = convert_reserved_chars_with_spaces_t text_l;
//	= "<p style=\"font-family:courier;margin:1px;\">"+++s+++"</p>\n";
//	= "<p style=\"font-family:courier;margin:0px;background-color:#"+++html_color ProgramColor+++";\">"+++s+++"</p>\n";
	= s;

html_ps_courier_t [text_l]
	= html_p_courier_t text_l+++"<br>";
html_ps_courier_t [text_l:text_ls]
	= html_p_courier_t text_l+++"<br>\n"+++html_ps_courier_t text_ls;
html_ps_courier_t []
	= "";

a_show_format_lines_pdf :: ![Text] !Int !PDFInfo !PDFState -> PDFState;
a_show_format_lines_pdf text_l font_n {char_width_and_kerns,width} pdf_s=:{y_pos,t_s,link_l}
	# (lines_slices_and_text,n_lines) = format_text text_l width font_size font_n char_width_and_kerns;
	  (t_s,link_l) = print_new_format_lines lines_slices_and_text font_size font_n width char_width_and_kerns pdf_s;
	  y_pos = y_pos + (font_size+line_spacing) * n_lines;	  
	= {pdf_s & y_pos=y_pos,t_s=t_s,link_l=link_l};

a_show_format_lines :: ![Text] !Int !PDFInfo !PDFState -> PDFState;
a_show_format_lines text_l font_n {char_width_and_kerns,width} pdf_s=:{y_pos,t_s,h_s,link_l}
	# (lines_slices_and_text,n_lines) = format_text text_l width font_size font_n char_width_and_kerns;
	  (t_s,link_l) = print_new_format_lines lines_slices_and_text font_size font_n width char_width_and_kerns pdf_s;
	  y_pos = y_pos + (font_size+line_spacing) * n_lines;
	  
	  h_s=h_s+++html_p_t text_l;
	  
	= {y_pos=y_pos,t_s=t_s,link_l=link_l,h_s=h_s};

show_format_lines :: ![Text] !PDFInfo !PDFState -> PDFState;
show_format_lines text_l pdf_i=:{text_font_n} pdf_s=:{y_pos}
	| y_pos<>0
		# pdf_s = show_new_line_s (font_size+line_spacing) pdf_s;
		= a_show_format_lines text_l text_font_n pdf_i pdf_s;
		= a_show_format_lines text_l text_font_n pdf_i pdf_s;

show_format_lines_list_f :: ![[Text]] !Int !Int !PDFInfo !PDFState -> PDFState;
show_format_lines_list_f [[]:lines] font_n line_height_i pdf_i pdf_s=:{y_pos,t_s}
	# (y_pos,t_s) = show_new_line line_height_i y_pos t_s;
	# pdf_s & y_pos=y_pos, t_s=t_s;
	= show_format_lines_list_f lines font_n line_height_i pdf_i pdf_s;
show_format_lines_list_f [line:lines] font_n line_height_i pdf_i pdf_s
	# pdf_s = a_show_format_lines line font_n pdf_i pdf_s;
	= show_format_lines_list_f lines font_n line_height_i pdf_i pdf_s;
show_format_lines_list_f [] font_n line_height_i pdf_i pdf_s
	= pdf_s;

show_format_lines_list_f_pdf :: ![[Text]] !Int !Int !PDFInfo !PDFState -> PDFState;
show_format_lines_list_f_pdf [[]:lines] font_n line_height_i pdf_i pdf_s=:{y_pos,t_s}
	# (y_pos,t_s) = show_new_line line_height_i y_pos t_s;
	# pdf_s & y_pos=y_pos, t_s=t_s;
	= show_format_lines_list_f_pdf lines font_n line_height_i pdf_i pdf_s;
show_format_lines_list_f_pdf [line:lines] font_n line_height_i pdf_i pdf_s
	# pdf_s = a_show_format_lines_pdf line font_n pdf_i pdf_s;
	= show_format_lines_list_f_pdf lines font_n line_height_i pdf_i pdf_s;
show_format_lines_list_f_pdf [] font_n line_height_i pdf_i pdf_s
	= pdf_s;

show_format_lines_list :: ![[Text]] !PDFInfo !PDFState -> PDFState;
show_format_lines_list lines pdf_i=:{text_font_n} pdf_s
	= show_format_lines_list_f lines text_font_n line_height_i pdf_i pdf_s;

// 183 in Adobe standard encoding
BulletChar = toChar 183; // \xB7
BulletString :== "\xB7";
EllipsisChar = toChar 188; // \xBC

print_lines_with_bullet :: ![{#Char}] !Real !Real !CharWidthAndKerns -> {#Char};
print_lines_with_bullet lines extra_margin width char_width_and_kerns
//	= print_new_indented_lines_with "*" lines extra_margin width char_width_and_kerns;
//	= print_new_indented_lines_with {toChar 183} lines extra_margin width char_width_and_kerns;
	= print_new_indented_lines_with BulletString lines extra_margin width char_width_and_kerns;
//	= print_new_indented_lines_with {toChar 1} lines extra_margin width char_width_and_kerns;

// •

show_format_lines_s_with_bullet_in_table :: !{#Char} !Real !CharWidthAndKerns !Int !Real !PDFState -> PDFState;
show_format_lines_s_with_bullet_in_table s extra_margin font_cwk line_height_i width pdf_s=:{y_pos,t_s,link_l,h_s}
	# (lines11,n_lines11) = format_lines s width font_size font_cwk;
	  t_s=t_s+++print_lines_with_bullet lines11 extra_margin width font_cwk;
	  y_pos = y_pos + line_height_i * n_lines11;

//	# h_s=h_s+++"<table style=\"width:100%\"><tr>";
	# h_s=h_s+++"<td style=\"vertical-align:top;width:"+++toString extra_margin+++"px;\">";
	# h_s=h_s+++"&bull;";
//	# h_s=h_s+++"</td><td>";
	# h_s=h_s+++"</td><td style=\"text-align:justify;\">";
	# h_s=h_s+++convert_reserved_chars 0 s;
	# h_s=h_s+++"</td></tr>\n";
	
	= {pdf_s & y_pos=y_pos,t_s=t_s,link_l=link_l,h_s=h_s};

show_format_lines_s_list_with_bullet_in_table :: ![{#Char}] !PDFInfo !PDFState -> PDFState;
show_format_lines_s_list_with_bullet_in_table [s:sl] pdf_i=:{text_cwk,width} pdf_s
	# pdf_s = show_format_lines_s_with_bullet_in_table s indent_width text_cwk line_height_i width pdf_s;
	= show_format_lines_s_list_with_bullet_in_table sl pdf_i pdf_s;
show_format_lines_s_list_with_bullet_in_table [] pdf_i pdf_s
	= pdf_s;

show_format_lines_s_list_with_bullet :: ![{#Char}] !PDFInfo !PDFState -> PDFState;
show_format_lines_s_list_with_bullet sl pdf_i pdf_s
//	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\">";
	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"border-spacing:-;width:100%;\">";
	# pdf_s = show_format_lines_s_list_with_bullet_in_table sl pdf_i pdf_s;
	# pdf_s & h_s=pdf_s.h_s+++"</table>\n";
	= pdf_s;

print_format_lines_with :: !{#Char} !(![({#Char},Int,Int)],![Text]) !Real !Int !Real !Int !{#Char} !{!CharWidthAndKerns} -> (!{#Char},![Link]);
print_format_lines_with s lines_slices_and_text extra_margin line_height_i width y_pos t_s char_width_and_kerns
	# (f_s,new_link_l) = print_indented_format_lines lines_slices_and_text extra_margin line_height_i width char_width_and_kerns y_pos;
	= (t_s+++"T*\n"+++print_formatted_string s char_width_and_kerns.[microsoft_sans_serif_n]+++f_s,new_link_l);

show_format_lines_with_bullet_in_table :: ![Text] !PDFInfo !PDFState -> PDFState;
show_format_lines_with_bullet_in_table text_l {char_width_and_kerns,width,text_font_n} pdf_s=:{y_pos,t_s,link_l,h_s}
	# (lines_slices_and_text,n_lines) = format_text text_l (width-indent_width) font_size text_font_n char_width_and_kerns;
	  (t_s,new_link_l) = print_format_lines_with BulletString lines_slices_and_text indent_width line_height_i width y_pos t_s char_width_and_kerns;
	  y_pos = y_pos + line_height_i * n_lines;

//	# h_s=h_s+++"<table style=\"width:100%;\">";
	# h_s=h_s+++"<tr><td style=\"vertical-align:top;width:"+++toString indent_width+++"px;\">";
	# h_s=h_s+++"&bull;";
//	# h_s=h_s+++"</td><td>";
	# h_s=h_s+++"</td><td style=\"text-align:justify;\">";
	# h_s=h_s+++convert_reserved_chars_t text_l;
	# h_s=h_s+++"</td></tr>";
//	# h_s=h_s+++"</table>\n";

	= {pdf_s & y_pos=y_pos,t_s=t_s,link_l=new_link_l++link_l,h_s=h_s};

show_format_lines_with_bullet :: ![Text] !PDFInfo !PDFState -> PDFState;
show_format_lines_with_bullet text_l pdf_i pdf_s
	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\">";
	# pdf_s = show_format_lines_with_bullet_in_table text_l pdf_i pdf_s;
	# pdf_s & h_s=pdf_s.h_s+++"</table>\n";
	= pdf_s;

show_format_lines_list_with_bullet_in_table :: ![[Text]] !PDFInfo !PDFState -> PDFState;
show_format_lines_list_with_bullet_in_table [text_l:text_ls] pdf_i pdf_s
	# pdf_s = show_format_lines_with_bullet_in_table text_l pdf_i pdf_s;
	= show_format_lines_list_with_bullet_in_table text_ls pdf_i pdf_s;
show_format_lines_list_with_bullet_in_table [] pdf_i pdf_s
	= pdf_s;

show_format_lines_list_with_bullet :: ![[Text]] !PDFInfo !PDFState -> PDFState;
show_format_lines_list_with_bullet text_ls pdf_i pdf_s
//	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\">";
	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"border-spacing:0;width:100%;\">";
	# pdf_s = show_format_lines_list_with_bullet_in_table text_ls pdf_i pdf_s;
	# pdf_s & h_s=pdf_s.h_s+++"</table>\n";
	= pdf_s;

print_indented_format_lines :: !(![({#Char},Int,Int)],![Text]) !Real !Int !Real !{!CharWidthAndKerns} !Int -> (!{#Char},![Link]);
print_indented_format_lines lines_slices_and_text extra_margin line_height_i width char_width_and_kerns y_pos
	# (f_s,new_link_l)
		= print_format_lines lines_slices_and_text font_size microsoft_sans_serif_n (width-extra_margin) char_width_and_kerns;
	  new_link_l = [{link & link_y_pos=y_pos+(1+link_y_pos)*line_height_i,
							link_begin_pos=link_begin_pos+extra_margin,
							link_extra_margin = extra_margin}
					\\ link=:{link_y_pos,link_begin_pos}<-new_link_l];
	= (toString extra_margin+++" 0 Td "+++f_s+++toString (~extra_margin)+++" 0 Td ",new_link_l);

print_format_lines_with_square :: !(![({#Char},Int,Int)],![Text]) !Real !Int !Real !Int !Real !{#Char} !{#Char} !{!CharWidthAndKerns} -> (!{#Char},!{#Char},![Link]);
print_format_lines_with_square lines_slices_and_text extra_margin line_height_i width y_pos top g_s t_s char_width_and_kerns
	# g = rgb_RGB_8bit SyntaxColor+++background_color_rectangle (toReal (y_pos+11)) 7.0 left_margin 7.0 top; 
	  (s,new_link_l) = print_indented_format_lines lines_slices_and_text extra_margin line_height_i width char_width_and_kerns y_pos;
	  t = "T*\n"+++s;
	= (g_s+++g,t_s+++t,new_link_l);

show_format_lines_with_square :: ![Text] !{#Char} !PDFInfo !PDFState -> (!{#Char},!PDFState);
show_format_lines_with_square text_l g_s pdf_i pdf_s
//	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\">";
	# pdf_s & h_s=pdf_s.h_s+++"<p></p><table style=\"width:100%;\">";
	# (g_s,pdf_s) = show_format_lines_with_square_in_table text_l g_s pdf_i pdf_s;
	# pdf_s & h_s=pdf_s.h_s+++"</table>\n";
	= (g_s,pdf_s);

show_format_lines_with_square_in_table :: ![Text] !{#Char} !PDFInfo !PDFState -> (!{#Char},!PDFState);
show_format_lines_with_square_in_table text_l g_s {char_width_and_kerns,width} pdf_s=:{y_pos,t_s,link_l,h_s}
	# (lines_slices_and_text,n_lines) = format_text text_l (width-indent_width) font_size microsoft_sans_serif_n char_width_and_kerns;
	  (g_s,t_s,new_link_l)
		= print_format_lines_with_square lines_slices_and_text indent_width line_height_i width y_pos top g_s t_s char_width_and_kerns;
	  y_pos = y_pos + line_height_i * n_lines;
	  
	# h_s=h_s+++"<tr><td style=\"vertical-align:top;width:"+++toString indent_width+++"px;\">";
	# h_s=h_s+++"<table style=\"border-top:7px solid white;border-bottom:1px solid white;border-left:0px solid white;border-right:8px solid white;width:16px;height:16px;background:#"+++html_color SyntaxColor+++";float:left\"></table>\n";
//	# h_s=h_s+++"</td><td>";
	# h_s=h_s+++"</td><td style=\"text-align:justify;\">";
	# h_s=h_s+++convert_reserved_chars_t text_l;
	# h_s=h_s+++"</td></tr>\n";

	= (g_s,{y_pos=y_pos,t_s=t_s,link_l=new_link_l++link_l,h_s=h_s});

a_show_format_lines_list_with_square :: ![[Text]] !{#Char} !PDFInfo !PDFState -> (!{#Char},!PDFState);
a_show_format_lines_list_with_square text_ls g_s pdf_i pdf_s
//	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\">";
	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"border-spacing:0;width:100%;\">";
	# (g_s,pdf_s) = a_show_format_lines_list_with_square text_ls g_s pdf_i pdf_s;
	# pdf_s & h_s=pdf_s.h_s+++"</table>\n";
	= (g_s,pdf_s);	
{
	a_show_format_lines_list_with_square :: ![[Text]] !{#Char} !PDFInfo !PDFState -> (!{#Char},!PDFState);
	a_show_format_lines_list_with_square [text_l:text_ls] g_s pdf_i pdf_s
		# (g_s,pdf_s) = show_format_lines_with_square_in_table text_l g_s pdf_i pdf_s;
		= a_show_format_lines_list_with_square text_ls g_s pdf_i pdf_s;
	a_show_format_lines_list_with_square [] g_s pdf_i pdf_s
		= (g_s,pdf_s);
}

show_format_lines_list_with_square :: ![[Text]] !{#Char} !PDFInfo !PDFState -> (!{#Char},!PDFState);
show_format_lines_list_with_square text_ls g_s pdf_i pdf_s=:{y_pos}
	| y_pos<>0
		# pdf_s = show_new_line_s (font_size+line_spacing) pdf_s;
		= a_show_format_lines_list_with_square text_ls g_s pdf_i pdf_s;
		= a_show_format_lines_list_with_square text_ls g_s pdf_i pdf_s;

print_new_indented_format_lines_with :: !{#Char} !(![({#Char},Int,Int)],![Text]) !Real !Real !{!CharWidthAndKerns} -> {#Char};
print_new_indented_format_lines_with s lines_slices_and_text extra_margin width char_width_and_kerns
	# (f_s,new_link_l)
		= print_format_lines lines_slices_and_text font_size microsoft_sans_serif_n (width-extra_margin) char_width_and_kerns;
	// to do: new_link_l
	= "T*\n"+++print_formatted_string s char_width_and_kerns.[microsoft_sans_serif_n]+++
	  toString extra_margin+++" 0 Td "+++f_s+++toString (~extra_margin)+++" 0 Td ";

show_format_text_with :: !{#Char} ![Text] !Real !PDFInfo !PDFState -> PDFState;
show_format_text_with s text_l extra_margin {char_width_and_kerns,width,text_font_n} pdf_s=:{y_pos,t_s,link_l}
	# (lines_slices_and_text,n_lines) = format_text text_l (width-extra_margin) font_size text_font_n char_width_and_kerns;
	  t_s=t_s+++print_new_indented_format_lines_with s lines_slices_and_text extra_margin width char_width_and_kerns;
	  y_pos = y_pos + line_height_i * n_lines;
	= {pdf_s & y_pos=y_pos,t_s=t_s,link_l=link_l};

// to do: compare with show_format_text_with
show_format_lines_with_in_table :: !{#Char} ![Text] !Real !PDFInfo !PDFState -> PDFState;
show_format_lines_with_in_table s text_l extra_margin {char_width_and_kerns,width,text_font_n} pdf_s=:{y_pos,t_s,link_l,h_s}
	# (lines_slices_and_text,n_lines) = format_text text_l (width-extra_margin) font_size text_font_n char_width_and_kerns;
	  (t_s,new_link_l) = print_format_lines_with s lines_slices_and_text extra_margin line_height_i width y_pos t_s char_width_and_kerns;
	  y_pos = y_pos + line_height_i * n_lines;

	# h_s=h_s+++"<table style=\"width:100%;\">";
	# h_s=h_s+++"<tr><td style=\"vertical-align:top;width:"+++toString extra_margin+++"px;\">";
	# h_s=h_s+++s;
	# h_s=h_s+++"</td><td style=\"text-align:justify;\">";
	# h_s=h_s+++convert_reserved_chars_t text_l;
	# h_s=h_s+++"</td></tr></table>\n";

	= {y_pos=y_pos,t_s=t_s,link_l=new_link_l++link_l,h_s=h_s};

show_format_lines_with_in_table_indent_percentage :: !{#Char} ![Text] !Int !PDFInfo !PDFState -> PDFState;
show_format_lines_with_in_table_indent_percentage s text_l indent_percentage {char_width_and_kerns,width,text_font_n} pdf_s=:{y_pos,t_s,link_l,h_s}
	# extra_margin = width*toReal indent_percentage/100.0;
	# (lines_slices_and_text,n_lines) = format_text text_l (width-extra_margin) font_size text_font_n char_width_and_kerns;
	  (t_s,new_link_l) = print_format_lines_with s lines_slices_and_text extra_margin line_height_i width y_pos t_s char_width_and_kerns;
	  y_pos = y_pos + line_height_i * n_lines;

	# h_s=h_s+++"<table style=\"width:100%;\">";
	# h_s=h_s+++"<tr><td style=\"vertical-align:top;width:"+++toString indent_percentage+++"%;\">";
	# h_s=h_s+++s;
	# h_s=h_s+++"</td><td style=\"text-align:justify;width:"+++toString (100-indent_percentage)+++"%;\">";
	# h_s=h_s+++convert_reserved_chars_t text_l;
	# h_s=h_s+++"</td></tr></table>\n";

	= {y_pos=y_pos,t_s=t_s,link_l=new_link_l++link_l,h_s=h_s};

show_format_lines_with :: !{#Char} ![Text] !Real !PDFInfo !PDFState -> PDFState;
show_format_lines_with s text_l extra_margin pdf_i pdf_s
	= show_format_lines_with_in_table s text_l extra_margin pdf_i pdf_s;

show_format_lines_with_indent_percentage :: !{#Char} ![Text] !Int !PDFInfo !PDFState -> PDFState;
show_format_lines_with_indent_percentage s text_l indent_percentage pdf_i pdf_s
	= show_format_lines_with_in_table_indent_percentage s text_l indent_percentage pdf_i pdf_s;

show_format_lines_list_with_in_table :: !Real ![({#Char},[Text])] !PDFInfo !PDFState -> PDFState;
show_format_lines_list_with_in_table extra_margin [(s,text_l):s_text_l_list] pdf_i pdf_s
	# pdf_s = show_format_lines_with_in_table s text_l extra_margin pdf_i pdf_s;
	= show_format_lines_list_with_in_table extra_margin s_text_l_list pdf_i pdf_s;
show_format_lines_list_with_in_table extra_margin [] pdf_i pdf_s
	= pdf_s;

show_format_lines_list_with :: !Real ![({#Char},[Text])] !PDFInfo !PDFState -> PDFState;
show_format_lines_list_with extra_margin s_text_l_list pdf_i pdf_s
	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\">";
	# pdf_s = show_format_lines_list_with_in_table extra_margin s_text_l_list pdf_i pdf_s;
	# pdf_s & h_s=pdf_s.h_s+++"</td></table>\n";
	= pdf_s;

print_new_indented_format_lines_with_indented :: !{#Char} !(![({#Char},Int,Int)],![Text]) !Real !Real !Real !{!CharWidthAndKerns} -> {#Char};
print_new_indented_format_lines_with_indented s lines_slices_and_text extra_margin1 extra_margin2 width char_width_and_kerns
	# (f_s,new_link_l)
		= print_format_lines lines_slices_and_text font_size microsoft_sans_serif_n (width-extra_margin2) char_width_and_kerns;
	// to do: new_link_l
	= "T*\n"+++
	  toString extra_margin1+++" 0 Td "+++
	  print_formatted_string s char_width_and_kerns.[microsoft_sans_serif_n]+++
	  toString (extra_margin2-extra_margin1)+++" 0 Td "+++f_s+++toString (~extra_margin2)+++" 0 Td ";

show_format_text_with_indented_in_table :: !{#Char} ![Text] !PDFInfo !PDFState -> PDFState;
show_format_text_with_indented_in_table s text_l {char_width_and_kerns,width,text_font_n} pdf_s=:{y_pos,t_s,link_l,h_s}
	# (lines_slices_and_text,n_lines2) = format_text text_l (width-2.0*indent_width) font_size text_font_n char_width_and_kerns;
	  t_s=t_s+++print_new_indented_format_lines_with_indented s lines_slices_and_text indent_width (2.0*indent_width) width char_width_and_kerns;
	  y_pos = y_pos + line_height_i * n_lines2;

	# h_s=h_s+++"<tr><td style=\"vertical-align:top;width:"+++toString indent_width+++"px;\"></td>";
	# h_s=h_s+++"<td style=\"vertical-align:top;width:"+++toString indent_width+++"px;\">";
	# h_s=h_s+++if (s=="\xB7" /*BulletString*/) "&bull;" s;
//	# h_s=h_s+++"</td><td>";
	# h_s=h_s+++"</td><td style=\"text-align:justify;\">";
	# h_s=h_s+++convert_reserved_chars_t text_l;
	# h_s=h_s+++"</td></tr>\n";

	= {pdf_s & y_pos=y_pos,t_s=t_s,link_l=link_l,h_s=h_s};

show_format_text_with_indented :: !{#Char} ![Text] !PDFInfo !PDFState -> PDFState;
show_format_text_with_indented s text_l pdf_i pdf_s
	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\">";
	# pdf_s = show_format_text_with_indented_in_table s text_l pdf_i pdf_s;
	# pdf_s & h_s=pdf_s.h_s+++"</table>";
	= pdf_s;

show_format_text_list_with_indented_in_table [(s,text_l):s_text_l] pdf_i pdf_s
	# pdf_s = show_format_text_with_indented_in_table s text_l pdf_i pdf_s;
	= show_format_text_list_with_indented_in_table s_text_l pdf_i pdf_s;
show_format_text_list_with_indented_in_table [] pdf_i pdf_s
	= pdf_s;

show_format_text_with_list_indented :: ![({#Char},[Text])] !PDFInfo !PDFState -> PDFState;
show_format_text_with_list_indented s_text_l pdf_i pdf_s
	# pdf_s & h_s=pdf_s.h_s+++"<table style=\"width:100%;\">";
	# pdf_s = show_format_text_list_with_indented_in_table s_text_l pdf_i pdf_s;
	# pdf_s & h_s=pdf_s.h_s+++"</table>";
	= pdf_s;

a_program_code_only_pdf :: ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
a_program_code_only_pdf [] pdf_i g_s pdf_s
	= (g_s,pdf_s);
a_program_code_only_pdf lines pdf_i g_s pdf_s=:{t_s,y_pos}
	# pdf_s & t_s=pdf_s.t_s+++"/F4 "+++toString font_size+++" Tf ";
	# old_y_pos=y_pos;
	# {y_pos,t_s,link_l} = show_format_lines_list_f lines courier_n line_height_i pdf_i pdf_s;
	# g_s=g_s+++rgb_RGB_8bit ProgramColor+++background_color old_y_pos y_pos left_margin pdf_i.width top;
	# t_s=t_s+++"/F1 "+++toString font_size+++" Tf ";
	= (g_s,{pdf_s & y_pos=y_pos,t_s=t_s,link_l=link_l});

// CPC, CPCP
a_program_code_only :: ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
a_program_code_only [] pdf_i g_s pdf_s
	= (g_s,pdf_s);
a_program_code_only lines pdf_i g_s pdf_s=:{t_s,y_pos,h_s}
	# pdf_s & t_s=pdf_s.t_s+++"/F4 "+++toString font_size+++" Tf ";
	# old_y_pos=y_pos;
	# {y_pos,t_s,link_l} = show_format_lines_list_f lines courier_n line_height_i pdf_i pdf_s;
	# g_s=g_s+++rgb_RGB_8bit ProgramColor+++background_color old_y_pos y_pos left_margin pdf_i.width top;
	# t_s=t_s+++"/F1 "+++toString font_size+++" Tf ";
	
//	# h_s=h_s+++"<p style=\"font-family:courier;margin:0px;background-color:#"+++html_color ProgramColor+++";\">";
	# h_s=h_s+++"<p style=\"font-family:courier;margin:0px;background-color:#"+++html_color ProgramColor+++";line-height:1.125;\">";
	# h_s=h_s+++html_ps_courier_t lines;
	# h_s=h_s+++"</p>\n";

	= (g_s,{y_pos=y_pos,t_s=t_s,link_l=link_l,h_s=h_s});

// PC
program_code_only :: ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_code_only lines char_width_and_kerns g_s pdf_s=:{y_pos}
	| y_pos<>0
		# pdf_s = show_new_line_s (font_size+line_spacing) pdf_s;
		# pdf_s & h_s = pdf_s.h_s+++"</p>";
		# (g_s,pdf_s) = a_program_code_only lines char_width_and_kerns g_s pdf_s;
		# pdf_s & h_s = pdf_s.h_s+++"</p>\n";
		= (g_s,pdf_s);
		= a_program_code_only lines char_width_and_kerns g_s pdf_s;

// PCP, PCNP
program_code_only_ :: ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_code_only_ lines char_width_and_kerns g_s pdf_s=:{y_pos}
	| y_pos<>0
		# pdf_s = show_new_line_s (font_size+line_spacing) pdf_s;
		= a_program_code_only lines char_width_and_kerns g_s pdf_s;
		= a_program_code_only lines char_width_and_kerns g_s pdf_s;

a_show_format_lines_heading :: ![Text] !Int !PDFInfo !PDFState -> PDFState;
a_show_format_lines_heading text_l font_n {char_width_and_kerns,width} pdf_s=:{y_pos,t_s,link_l}
	# (lines_slices_and_text,n_lines) = format_text text_l width font_size font_n char_width_and_kerns;
	  (t_s,link_l) = print_new_format_lines lines_slices_and_text font_size font_n width char_width_and_kerns pdf_s;
	  y_pos = y_pos + (font_size+line_spacing) * n_lines;
	= {pdf_s & y_pos=y_pos,t_s=t_s,link_l=link_l};

convert_reserved_chars_t_list [text_l]
	= convert_reserved_chars_t text_l+++"<br>";
convert_reserved_chars_t_list [text_l:text_ls]
	= convert_reserved_chars_t text_l+++"<br>"+++convert_reserved_chars_t_list text_ls;
convert_reserved_chars_t_list [] ="";

c_program_code_ :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
c_program_code_ heading lines pdf_i g_s pdf_s=:{y_pos}
	# old_y_pos=y_pos;
	# pdf_s=:{y_pos} = a_show_format_lines_heading heading microsoft_sans_serif_n pdf_i pdf_s;
	# g_s=g_s+++rgb_RGB_8bit ProgramHeadingColor+++background_color old_y_pos y_pos left_margin pdf_i.width top;
	# (g_s,pdf_s) = a_program_code_only_pdf lines pdf_i g_s pdf_s;

	# {h_s}=pdf_s;
//	  h_s=h_s+++html_p_t text_l;
	  h_s=h_s+++"<div style=\"background-color:#"+++html_color ProgramHeadingColor+++"\";>";
	  h_s=h_s+++convert_reserved_chars_t heading;
	  h_s=h_s+++"</div>\n";

	  h_s=h_s+++"<div style=\"font-family:courier;margin:0px;background-color:#"+++html_color ProgramColor+++";\">";
	  h_s=h_s+++html_ps_courier_t lines;
	  h_s=h_s+++"</div>\n";

	  pdf_s & h_s=h_s;
	= (g_s,pdf_s);

c_program_code :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
c_program_code heading lines pdf_i g_s pdf_s
	# (g_s,pdf_s) = c_program_code_ heading lines pdf_i g_s pdf_s;
	  pdf_s & h_s=pdf_s.h_s+++"</p>";
	= (g_s,pdf_s);

// CPCH
a_program_code :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
a_program_code heading [] pdf_i g_s pdf_s=:{y_pos}
	# old_y_pos=y_pos;
	# pdf_s=:{y_pos} = a_show_format_lines_heading heading microsoft_sans_serif_n pdf_i pdf_s;
	# g_s=g_s+++rgb_RGB_8bit ProgramHeadingColor+++background_color old_y_pos y_pos left_margin pdf_i.width top;

	# {h_s}=pdf_s;
	  h_s=h_s+++"<div style=\"background-color:#"+++html_color ProgramHeadingColor+++"\";>";
	  h_s=h_s+++convert_reserved_chars_t heading;
	  h_s=h_s+++"</div>\n";

	  pdf_s & h_s=h_s;
	= (g_s,pdf_s);
a_program_code heading lines pdf_i g_s pdf_s
	# pdf_s & h_s=pdf_s.h_s+++"<p>";
	  (g_s,pdf_s) = c_program_code_ heading lines pdf_i g_s pdf_s;
	  pdf_s & h_s=pdf_s.h_s+++"</p>";
	= (g_s,pdf_s);

// PCH
program_code :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_code heading lines pdf_i g_s pdf_s=:{y_pos}
	| y_pos<>0
		# pdf_s = show_new_line_s (font_size+line_spacing) pdf_s;
		= a_program_code heading lines pdf_i g_s pdf_s;
		= a_program_code heading lines pdf_i g_s pdf_s;

program_code_ :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_code_ heading lines pdf_i g_s pdf_s=:{y_pos}
	# pdf_s & h_s=pdf_s.h_s+++"<p>";
	| y_pos<>0
		# pdf_s = show_new_line_s (font_size+line_spacing) pdf_s;
		= c_program_code_ heading lines pdf_i g_s pdf_s;
		= c_program_code_ heading lines pdf_i g_s pdf_s;

program_headings_code_ :: ![[Text]] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_headings_code_ headings lines pdf_i g_s pdf_s=:{y_pos}
	# old_y_pos=y_pos;
	# pdf_s=:{y_pos} = show_format_lines_list_f_pdf headings microsoft_sans_serif_n line_height_i pdf_i pdf_s;
	# g_s=g_s+++rgb_RGB_8bit ProgramHeadingColor+++background_color old_y_pos y_pos left_margin pdf_i.width top;
	# (g_s,pdf_s)= a_program_code_only_pdf lines pdf_i g_s pdf_s;

	# {h_s}=pdf_s;
	  h_s=h_s+++"<p><div style=\"background-color:#"+++html_color ProgramHeadingColor+++"\";>";
	  h_s=h_s+++convert_reserved_chars_t_list headings;
	  h_s=h_s+++"</div>\n";

	  h_s=h_s+++"<div style=\"font-family:courier;margin:0px;background-color:#"+++html_color ProgramColor+++";\">";
	  h_s=h_s+++html_ps_courier_t lines;
	  h_s=h_s+++"</div>\n";

	  pdf_s & h_s=h_s;
	= (g_s,pdf_s);

// PCMH
program_headings_code :: ![[Text]] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_headings_code headings lines pdf_i g_s pdf_s
	# (g_s,pdf_s) = program_headings_code_ headings lines pdf_i g_s pdf_s;
	  pdf_s & h_s=pdf_s.h_s+++"</p>\n";
	= (g_s,pdf_s);

count_n_nil_elements_at_begining [[]:l] = 1+count_n_nil_elements_at_begining l;
count_n_nil_elements_at_begining _ = 0;

print_html_table [row:rows] column_widths
//	# table_width = 495.0 - toReal (10*(length row-1));
	# table_width = 495.0;
	# (r_s,sum_widths) = print_html_row row column_widths table_width 0.0;

	= "<tr>"+++r_s+++"</tr>\n"+++print_html_table rows column_widths;
print_html_table [] column_widths
	= "";

print_html_table_with_border [row:rows] is_first_row column_widths
	# table_width = 495.0;
	# (r_s,sum_widths) = print_html_row_with_border row column_widths True table_width 0.0;
	# s = r_s+++"</tr>\n"+++print_html_table_with_border rows False column_widths;
	| is_first_row
//		= "<tr style=\"border-bottom:1px solid black\">"+++s;
		= "<tr style=\"border-bottom:1px solid #"+++html_color TableBorderColor+++"\">"+++s;
		= "<tr>"+++s;
print_html_table_with_border [] is_first_row column_widths
	= "";

print_html_row [cell:cells=:[[]:cells2]] [column_width:column_widths] table_width sum_widths
	# n_cells = 1+count_n_nil_elements_at_begining cells2;
//	= "<td colspan=\""+++toString (1+n_cells)+++"\">"
//	= "<td style=\"width:"+++toString (toReal ((column_width+sum (take n_cells column_widths))*font_size)/1000.0*2.0)+++"px'\" colspan=\""+++toString (1+n_cells)+++"\">"
	# width = (100.0/table_width)*(toReal ((column_width+sum (take n_cells column_widths))*font_size)/1000.0);
	# sum_widths=sum_widths+width;

	# (r_s,sum_widths) = print_html_row (drop n_cells cells) (drop n_cells column_widths) table_width sum_widths;

	= ("<td style=\"width:"+++toString width+++"%px'\" colspan=\""+++toString (1+n_cells)+++"\">"
		+++convert_reserved_chars_t cell+++print_n_html_cells n_cells cells+++"</td>"
		+++r_s,sum_widths);
print_html_row [cell:cells] [column_width:column_widths] table_width sum_widths
//	= "<td>"+++convert_reserved_chars_t cell+++"</td>"+++print_html_row cells column_widths;
//	= "<td style=\"width:"+++toString (toReal (column_width*font_size)/1000.0*2.0)+++"px;\">"+++convert_reserved_chars_t cell+++"</td>"+++print_html_row cells column_widths;
	# width = (100.0/table_width)*(toReal (column_width*font_size)/1000.0);
	# sum_widths=sum_widths+width;

	# (r_s,sum_widths) = print_html_row cells column_widths table_width sum_widths;

	= ("<td style=\"width:"+++toString width+++"%;\">"+++convert_reserved_chars_t cell+++"</td>"
		+++r_s,sum_widths);
print_html_row [] [] table_width sum_widths
	= ("",sum_widths);

print_html_row_with_border [cell:cells=:[[]:cells2]] [column_width:column_widths] is_first_column table_width sum_widths
	# n_cells = 1+count_n_nil_elements_at_begining cells2;
	# width = (100.0/table_width)*(toReal ((column_width+sum (take n_cells column_widths))*font_size)/1000.0);
	# sum_widths=sum_widths+width;
	# (r_s,sum_widths)
		= print_html_row_with_border (drop n_cells cells) (drop n_cells column_widths) False table_width sum_widths;
	# s=convert_reserved_chars_t cell+++print_n_html_cells n_cells cells+++"</td>"+++r_s;
	| is_first_column
		= ("<td style=\"width:"+++toString width+++"%px'\" colspan=\""+++toString (1+n_cells)+++"\">"+++s,sum_widths);
//		= ("<td style=\"border-left:1px solid black;width:"+++toString width+++"%px'\" colspan=\""+++toString (1+n_cells)+++"\">"+++s,sum_widths);
		= ("<td style=\"border-left:1px solid #"+++html_color TableBorderColor+++";width:"+++toString width+++"%px'\" colspan=\""+++toString (1+n_cells)+++"\">"+++s,sum_widths);
print_html_row_with_border [cell:cells] [column_width:column_widths] is_first_column table_width sum_widths
	# width = (100.0/table_width)*(toReal (column_width*font_size)/1000.0);
	# sum_widths=sum_widths+width;
	# (r_s,sum_widths)
		= print_html_row_with_border cells column_widths False table_width sum_widths;
	# s=convert_reserved_chars_t cell+++"</td>"+++r_s;
	| is_first_column
		= ("<td style=\"width:"+++toString width+++"%;\">"+++s,sum_widths);
//		= ("<td style=\"border-left:1px solid black;width:"+++toString width+++"%;\">"+++s,sum_widths);
		= ("<td style=\"border-left:1px solid #"+++html_color TableBorderColor+++";width:"+++toString width+++"%;\">"+++s,sum_widths);
print_html_row_with_border [] [] is_first_column table_width sum_widths
	= ("",sum_widths);

print_n_html_cells 0 _ = "";
print_n_html_cells n [cell:cells] = convert_reserved_chars_t cell+++print_n_html_cells (n-1) cells;
print_n_html_cells _ [] ="";

adjust_last_column_width [] table_width
	= [];
adjust_last_column_width column_widths table_width
	# init_column_widths = init column_widths;
	# last_column_width = toInt (table_width*1000.0/toReal font_size) - sum init_column_widths;
	= init_column_widths++[last_column_width];

show_table_min_widths :: ![[[Text]]] ![Int] !Int !Int !Int !Int {!CharWidthAndKerns} !Int !{#Char} !{#Char} -> (!Int,!{#Char},!{#Char},![Link]);
show_table_min_widths table table_min_widths column_space font_size font_n line_spacing char_width_and_kerns y_pos t_s h_s
	# n_table_rows = length table;

//	  (table_s,new_link_l) = make_table_min_widths table table_min_widths column_space font_size font_n char_width_and_kerns;
	  max_column_widths = compute_table_widths_with_min_widths table table_min_widths column_space font_size font_n char_width_and_kerns;
	  (table_s,new_link_l) = print_table table max_column_widths column_space font_size font_n char_width_and_kerns;

	  table_width = 495.0;// - toReal (10*(n_table_rows-1));

	  max_column_widths = adjust_last_column_width max_column_widths table_width;

//	  h_s=h_s+++"<table>";
	  h_s=h_s+++"<table style=\"background-color:#"+++html_color SyntaxColor+++";\">";
//	  h_s=h_s+++"<table style=\"width:100%;table-layout:fixed;background-color:#"+++html_color SyntaxColor+++";\">";
//	  h_s=h_s+++"<table style=\"width:100%;border-spacing:10pt 0;background-color:#"+++html_color SyntaxColor+++";\">";
	  h_s=h_s+++print_html_table table max_column_widths;
	  h_s=h_s+++"</table><p></p>\n";
//	  h_s=h_s+++"</table>\n";
//
	  line_height_i = font_size+line_spacing;
	  new_link_l = [{link & link_y_pos=y_pos+(1+link_y_pos)*line_height_i}
					\\ link=:{link_y_pos,link_begin_pos}<-new_link_l];
	  t_s=t_s+++table_s;
	  y_pos = y_pos + (font_size+line_spacing)*n_table_rows;
	= (y_pos,t_s,h_s,new_link_l);

show_table :: ![[[Text]]] !Int !PDFInfo !PDFState -> PDFState;
show_table table column_space {char_width_and_kerns,text_font_n} pdf_s=:{y_pos,t_s,link_l,h_s}
	# n_table_rows = length table;

//	  (table_s,new_link_l) = make_table table column_space font_size text_font_n char_width_and_kerns;
	# table_widths = [[text_words_width text_l text_font_n char_width_and_kerns\\text_l<-row]\\row<-table];
	# max_column_widths = compute_max_column_widths table_widths (column_space *1000/font_size) table;
	# (table_s,new_link_l) = print_table table max_column_widths column_space font_size text_font_n char_width_and_kerns;

	  t_s=t_s+++table_s;
	  y_pos = y_pos + (font_size+line_spacing)*n_table_rows;

	  h_s=h_s+++"<p></p><table style=\"width:100%;\">";
	  h_s=h_s+++print_html_table table max_column_widths;
	  h_s=h_s+++"</table><p></p>\n";
//	  h_s=h_s+++"</table>\n";

	= {pdf_s & y_pos=y_pos,t_s=t_s,link_l=new_link_l++link_l,h_s=h_s};

a_show_syntax_table :: ![[[Text]]] ![Int] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
a_show_syntax_table table table_min_widths {char_width_and_kerns,width,text_font_n} g_s pdf_s=:{y_pos,t_s,h_s,link_l}
	# old_y_pos=y_pos;
//	# (y_pos,t_s,link_l_t)
	# (y_pos,t_s,h_s,link_l_t)
//		= show_table_min_widths table table_min_widths 10 font_size text_font_n line_spacing char_width_and_kerns y_pos t_s;
		= show_table_min_widths table table_min_widths 10 font_size text_font_n line_spacing char_width_and_kerns y_pos t_s h_s;
	# g_s=g_s+++rgb_RGB_8bit SyntaxColor+++background_color old_y_pos y_pos left_margin width top;
	= (g_s,{pdf_s & y_pos=y_pos,t_s=t_s,link_l=link_l_t++link_l,h_s=h_s});

show_syntax_table :: ![[[Text]]] ![Int] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
show_syntax_table table table_min_widths pdf_i g_s pdf_s=:{y_pos}
	| y_pos<>0
		# pdf_s = show_new_line_s (font_size+line_spacing) pdf_s;
		= a_show_syntax_table table table_min_widths pdf_i g_s pdf_s;
		= a_show_syntax_table table table_min_widths pdf_i g_s pdf_s;

show_table_min_widths_yield_widths :: ![[[Text]]] ![Int] !Int !PDFInfo !PDFState -> (![Int],!PDFState);
show_table_min_widths_yield_widths table table_min_widths column_space {char_width_and_kerns,text_font_n} pdf_s=:{y_pos,t_s,link_l,h_s}
	# n_table_rows = length table;
//	  t_s=t_s+++make_table_min_widths table table_min_widths column_space font_size text_font_n char_width_and_kerns;
	  max_column_widths = compute_table_widths_with_min_widths table table_min_widths column_space font_size text_font_n char_width_and_kerns;
	  (table_s,link_l_t) = print_table table max_column_widths column_space font_size text_font_n char_width_and_kerns;
	  t_s=t_s+++table_s;
	  y_pos = y_pos + (font_size+line_spacing)*n_table_rows;

//	  h_s=h_s+++"<p></p><table style=\"width:100%;\">";
//	  h_s=h_s+++"<p></p><table style=\"width:100%;background-color:#"+++html_color ProgramColor+++";\">";
	  h_s=h_s+++"<p></p><table style=\"border-collapse:collapse;width:100%;background-color:#"+++html_color ProgramColor+++";\">";
//	  h_s=h_s+++print_html_table table max_column_widths;
	  h_s=h_s+++print_html_table_with_border table True max_column_widths;
	  h_s=h_s+++"</table><p></p>\n";

	= (max_column_widths,{pdf_s & y_pos=y_pos,t_s=t_s,link_l=link_l_t++link_l,h_s=h_s});

draw_table_lines_between_columns :: !Int ![Int] !Int !Int !Int !Real -> {#Char};
draw_table_lines_between_columns x [_] column_space old_y_pos y_pos left_margin
	= "";
draw_table_lines_between_columns x [column_width:column_widths] column_space old_y_pos y_pos left_margin
	# x = x + (font_size*column_width)/1000;
	# column_x = x + column_space/2;
	= draw_line_to (left_margin+toReal column_x) (top-toReal line_spacing-toReal old_y_pos)
				   (left_margin+toReal column_x) (top-toReal line_spacing-toReal y_pos)+++
	  draw_table_lines_between_columns (x+column_space) column_widths column_space old_y_pos y_pos left_margin;

import StdDebug;

underline_links :: !{!CharWidthAndKerns} !{#Char} !PDFState -> (!{#Char},!PDFState);
underline_links char_width_and_kerns g_s pdf_s=:{link_l=[]}
	= (g_s,pdf_s);
underline_links char_width_and_kerns g_s pdf_s=:{link_l}
	# g_s = g_s+++pen_color_8bit 0 0 255;
	# (link_l,g_s) = underline_links link_l g_s
	= (g_s,{pdf_s & link_l=link_l});
{
	underline_links [link=:{link_y_pos,link_begin_pos,link_s,link_font_n,link_line_word_spacing,link_extra_margin}:link_l] g_s
		# link_begin_pos = left_margin+link_begin_pos;
		# link_line_word_spacing
			= if (link_line_word_spacing<>0.0)
				(link_line_word_spacing*toReal (count_spaces 0 0 link_s))
				0.0;
		# link_width = toReal (string_width link_s char_width_and_kerns.[link_font_n]*font_size)/1000.0 + link_line_word_spacing;
		# y_pos = top-2.0-toReal link_y_pos;

		| link_begin_pos+link_width <= page_width-right_margin
			# g_s = g_s+++draw_line_to link_begin_pos y_pos (link_begin_pos+link_width) y_pos;
			# (link_l,g_s) = underline_links link_l g_s;
			= ([link:link_l],g_s);

			# g_s = g_s+++draw_line_to link_begin_pos y_pos (page_width-right_margin) y_pos;
			# overflow_width = link_begin_pos+link_width-(page_width-right_margin);
			# next_line_y_pos = y_pos-toReal line_height_i;
			# g_s = g_s+++draw_line_to (left_margin+link_extra_margin) next_line_y_pos (left_margin+link_extra_margin+overflow_width) next_line_y_pos;
			# (link_l,g_s) = underline_links link_l g_s;
			
			# link1 = {link & link_line_word_spacing = ~ (page_width-right_margin-link_begin_pos)};
			# link2 = {link & link_y_pos = link_y_pos+line_height_i, link_begin_pos = link_extra_margin, link_line_word_spacing = ~ overflow_width};
			
			= ([link1,link2:link_l],g_s);
	underline_links [] g_s
		= ([],g_s);

	count_spaces :: !Int !Int !{#Char} -> Int;
	count_spaces i n s
		| i<size s
			| s.[i]==' '
				= count_spaces (i+1) (n+1) s;
				= count_spaces (i+1) n s;
			= n;
}

make_stream s
	= "<< /Length "+++toString (size s)+++" >>\nstream\n"+++s+++"\nendstream";

make_page_stream :: !{#Char} !{#Char} -> {#Char};
make_page_stream g_s t_s
	= make_stream (	
	g_s+++

	"BT /F1 "+++toString font_size+++" Tf "+++
	toString left_margin+++" "+++toString top+++" Td "+++toString (font_size+line_spacing)+++" TL "+++

	fill_color_8bit 0 0 0+++
	
	t_s+++

	"ET");

make_page :: !PDFInfo !(!Headings,!{#Char},!PDFState) -> Page;
make_page {char_width_and_kerns} (headings,g_s,pdf_s)
	# (g_s,{t_s,h_s,link_l}) = underline_links char_width_and_kerns g_s pdf_s;
	# page_s = make_page_stream g_s t_s;
	= (page_s,h_s,headings,link_l);

