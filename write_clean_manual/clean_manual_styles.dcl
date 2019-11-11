definition module clean_manual_styles;

from pdf_main import ::Page;
from pdf_text import ::CharWidthAndKerns,::Link,::Text;
from pdf_graphics import ::PictureElement;
from pdf_outline import :: Headings;

font_size :== 9;
line_spacing::Int;

line_height_i:==12;//font_size+line_spacing;

top :== 842.0;
page_width :== 595.0;

left_margin :== 50.0;
right_margin :== 50.0;

indent_width :== 30.0;

:: DI =
	P ![Text] |							// paragraph
	S !{#Char} |						// string (paragraph)
	CP ![Text] |						// paragraph, continue without empty lines
	CS !{#Char} |						// string (paragraph), continue without empty lines
	MP ![[Text]] |						// multiple paragraphs
	
	SP ![Text] |						// paragraph with square
	MSP ![[Text]] |						// multiple paragraphs with square
	CMSP ![[Text]] |					// multiple paragraphs with square, continue without empty lines
	BP ![Text] |						// paragraph with bullet
	MBP ![[Text]] |						// multiple paragraphs with bullet
	MBS ![{#Char}] |					// multiple strings (paragraphs) with bullet
	PW !{#Char} !Real ![Text] |
	PWP !{#Char} !Int ![Text] |
	MPW !Real ![({#Char},[Text])] |
	PWI !{#Char} ![Text] |
	MPWI ![({#Char},[Text])] |

	N |									// newline

	PC ![[Text]] |						// program code
	PCH ![Text] ![[Text]] |				// program code with heading
	PCP ![[Text]] !Picture |
	CPC ![[Text]] |						// program code, continue without empty lines
	CPCH ![Text] ![[Text]] |			// program code with heading, continue without empty lines
	CPCP ![[Text]] !Picture |
	PCMH ![[Text]] ![[Text]] |			// program code with multiple headings
	PCNP ![[Text]] !Int !Picture |

	T ![[[Text]]] |						// table
	TB ![[[Text]]] |					// table with borders
	ST ![[[Text]]] |					// syntax table
	ST2 ![[[Text]]] |					// syntax table with additonal row 

	C !{#Char} !{#Char} |				// chapter
	C3S !{#Char} !{#Char} !{#Char} |	// chapter, 3 strings, last string in table of contents
	H2 !{#Char} !{#Char} |				// heading 2
	H3 !{#Char} !{#Char}|				// heading 3
	H3T !{#Char} |						// heading 3, title only, not in table of contents

	PI !Int !Picture;					// picture

:: Picture :== [PictureElement];

TS :: !{#Char} -> [Text];						// text start
TSI :: !{#Char} -> [Text];						// text start italic
TSB :: !{#Char} -> [Text];						// text start bold
TSC :: !{#Char} -> [Text];						// text start courier
TST :: !{#Char} -> [Text];						// text start terminal (bold courier brown)
TSb :: !{#Char} -> [Text];						// text start blue
TSL :: !{#Char} -> [Text];						// text start link
TSCb :: !{#Char} -> [Text];						// text start courier blue
TSBCb :: !{#Char} -> [Text];					// text start bold courier blue
TSBCbC :: !{#Char} -> [Text];					// text start bold blue in courier
TSBCr :: !{#Char} -> [Text];					// text start bold courier red
red_bold_s_in_courier :: !{#Char} -> [Text];
orange_bold_s :: !{#Char} -> [Text];

TS_E :: [Text];									// text start =
TS_B :: [Text];									// text start |

(TA) infixl :: ![Text] !{#Char} -> [Text];		// text append
(TAb) infixl :: ![Text] !{#Char} -> [Text];		// text append blue
(TAI) infixl :: ![Text] !{#Char} -> [Text];		// text append italic
(TAC) infixl :: ![Text] !{#Char} -> [Text];		// text append courier
(TACb) infixl :: ![Text] !{#Char} -> [Text];	// text append courier blue
(TABCb) infixl :: ![Text] !{#Char} -> [Text];	// text append bold courier blue
(TABCbC) infixl :: ![Text] !{#Char} -> [Text];	// text append bold blue in courier
(TABCr) infixl :: ![Text] !{#Char} -> [Text];	// text append bold courier red
(TAL) infixl :: ![Text] !{#Char} -> [Text];		// text append link
(TAT) infixl :: ![Text] !{#Char} -> [Text];		// text append terminal (bold courier brown)

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
make_pdf :: !PDFInfo !Headings !{#Char} !PDFState ![DI] -> (!Headings,!{#Char},!PDFState);

make_pdf_shl :: !PDFInfo ![DI] -> (!Headings,!{#Char},!PDFState);

init_PDFInfo :: !{!CharWidthAndKerns} -> PDFInfo;

show_chapter :: !{#Char} !{#Char} !PDFInfo -> (!Headings,!{#Char},!PDFState);
show_chapter_3s :: !{#Char} !{#Char} !{#Char} !PDFInfo -> (!Headings,!{#Char},!PDFState);
show_heading_2 :: !{#Char} !{#Char} !PDFInfo !Headings !{#Char} !PDFState -> (!Headings,!{#Char},!PDFState);
show_heading_3 :: !{#Char} !{#Char} !PDFInfo !Headings !{#Char} !PDFState -> (!Headings,!{#Char},!PDFState);
show_heading_3_without_number :: !{#Char} !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);

show_new_line_s :: !Int !PDFState -> PDFState;

a_show_format_lines_s :: !{#Char} !PDFInfo !PDFState -> PDFState;
show_format_lines_s :: !{#Char} !PDFInfo !PDFState -> PDFState;
a_show_format_lines :: ![Text] !Int !PDFInfo !PDFState -> PDFState;
show_format_lines :: ![Text] !PDFInfo !PDFState -> PDFState;
show_format_lines_list :: ![[Text]] !PDFInfo !PDFState -> PDFState;

show_format_lines_s_list_with_bullet :: ![{#Char}] !PDFInfo !PDFState -> PDFState;
show_format_lines_with_bullet :: ![Text] !PDFInfo !PDFState -> PDFState;
show_format_lines_list_with_bullet :: ![[Text]] !PDFInfo !PDFState -> PDFState;
show_format_lines_with_square :: ![Text] !{#Char} !PDFInfo !PDFState -> (!{#Char},!PDFState);
a_show_format_lines_list_with_square :: ![[Text]] !{#Char} !PDFInfo !PDFState -> (!{#Char},!PDFState);
show_format_lines_list_with_square :: ![[Text]] !{#Char} !PDFInfo !PDFState -> (!{#Char},!PDFState);
show_format_text_with :: !{#Char} ![Text] !Real !PDFInfo !PDFState -> PDFState;
show_format_lines_with :: !{#Char} ![Text] !Real !PDFInfo !PDFState -> PDFState;
show_format_lines_with_indent_percentage :: !{#Char} ![Text] !Int !PDFInfo !PDFState -> PDFState;
show_format_lines_list_with :: !Real ![({#Char},[Text])] !PDFInfo !PDFState -> PDFState;
show_format_text_with_indented :: !{#Char} ![Text] !PDFInfo !PDFState -> PDFState;
show_format_text_with_list_indented :: ![({#Char},[Text])] !PDFInfo !PDFState -> PDFState;

a_program_code_only :: ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_code_only :: ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
a_program_code :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
c_program_code :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
c_program_code_ :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_code :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_code_ :: ![Text] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
program_headings_code :: ![[Text]] ![[Text]] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);

show_table :: ![[[Text]]] !Int !PDFInfo !PDFState -> PDFState;
a_show_syntax_table :: ![[[Text]]] ![Int] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
show_syntax_table :: ![[[Text]]] ![Int] !PDFInfo !{#Char} !PDFState -> (!{#Char},!PDFState);
show_table_min_widths_yield_widths :: ![[[Text]]] ![Int] !Int !PDFInfo !PDFState -> (![Int],!PDFState);
draw_table_lines_between_columns :: !Int ![Int] !Int !Int !Int !Real -> {#Char};

underline_links :: !{!CharWidthAndKerns} !{#Char} !PDFState -> (!{#Char},!PDFState);

make_page :: !PDFInfo !(!Headings,!{#Char},!PDFState) -> Page;

html_chapter_3s :: !{#Char} !{#Char} !{#Char} -> {#Char};
