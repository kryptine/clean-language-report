module write_clean_manual;

import StdEnv;
import pdf_main,pdf_text,pdf_graphics,pdf_fonts;
import clean_manual_styles,clean_manual_graphics,clean_manual_text;
import split_html2;

import
	clean_manual_preface,
	clean_manual_semantics,
	clean_manual_modules_scopes,
	clean_manual_functions,
	clean_manual_predefined_types,
	clean_manual_defining_types,
	clean_manual_overloading,
	clean_manual_generics,
	clean_manual_dynamics,
	clean_manual_uniqueness_typing,
	clean_manual_strictness_macros,
	clean_manual_foreign_interface,
	clean_manual_syntax,
	clean_manual_lexical_syntax,
	clean_manual_bibliography,
	clean_manual_compiler_extensions;

pages = pages_p++pages_1++pages_2++pages_3++pages_4++pages_5++pages_6++pages_7++pages_8++pages_9++pages_10++pages_11++
		pages_a++pages_b++pages_c++pages_d;

Start world
	# file_name = "CleanLanguageReport";
	# (ok,world) = write_pdf file_name pages left_margin top world;
	= split_html_chapters file_name world;
