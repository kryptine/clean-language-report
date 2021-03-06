implementation module clean_manual_compiler_extensions;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

pages_d :: [{!CharWidthAndKerns} -> Page];
pages_d = [page_d_1,page_d_2,page_d_3,page_d_4];

page_d_1 :: !{!CharWidthAndKerns} -> Page;
page_d_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i [
		C "Appendix D" "Compiler Extensions"

		,S ("This appendix lists extensions and modifications to Clean that are supported by "+++
			"a compiler. Unfortunately they are not yet described in the previous chapters and "+++
			"appendices of this manual.")

		,H2	"D.1" "Clean 3.0 Compiler Extensions"
		,N

		,H3 "D.1.1" "New imports"
		,N

		,SP (TS "Identifiers can be imported qualified by adding "
			 TAC "qualified" TA " after " TAC "import"
			 TA " in the import statement. For example:")
		,PC (map syntax_color [
			TS "import qualified StdList;",
			[],
			TS "from StdList import qualified drop,++;"
		])

		,P (TS (
			"Identifiers imported in this way can be used by prefixing the "+++
			"identifier with the module name between single quotes and a dot. "+++
			"If an identifier consists of special characters (for example ") TAC "++"
			TA ") an additional single space is required between the dot and the identifier."
			)

		,PCH (TS "For example:")[
			[],
			TS "f l = 'StdList'.drop 1 (l 'StdList'. ++ [2]);"
		],P (TS (
			"Currently field names of records are not imported by an implicit "+++
			"qualified import, but can be imported with an explicit qualified "+++
			"import."))

		,P (TS (
			"Qualified names may only be used if a qualified import is used, "+++
			"not if the identifier is only imported by a normal (unqualified) "+++
			"import. An identifier may be imported both unqualified and "+++
			"qualified."))

		,P (TS (
			"Qualified imports may be used in definition modules, but qualified "+++
			"identifiers cannot be imported from a (definition) module."))

	  ];
	= make_page pdf_i pdf_shl;

page_d_2 :: !{!CharWidthAndKerns} -> Page;
page_d_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i [
		H3 "D.1.2" "Uniqueness typing additions"
		,N

		,SP (TS "Updates of unique array elements:")

		,P (TS (
			"A unique array element of a (unique) array of unique elements "+++
			"can be selected and updated, if the selection (using ") TAC "![ ]"
			TA (") and update (with the same index) occur in the same function and the "+++
			"array is not used in between (only the selected element is used)."))

		,P (TS "For example, below a unique row is selected, updated by " TAC "inc_a"
			TA " and finally the row of the array is updated."
		)

		,PC (map syntax_color [
			TS "inc_row :: !*{#*{#Int}} !Int -> *{#*{#Int}};",
			TS "inc_row a row_i",
			TS "    # (row,a) = a![row_i];",
			TS "      row = inc_a 0 row;",
			TS "    = {a & [row_i]=row};",
			[],
			TS "inc_a :: !Int !*{#Int} -> *{#Int};",
			TS "inc_a i a",
			TS "    | i<size a",
			TS "        # (n,a) = a![i];",
			TS "          a & [i]=n+1;",
			TS "        = inc_a (i+1) a;",
			TS "        = a;"
		])

		,H3 "D.1.3" "Hierarchical modules"
		
		,P (TS ("The module name can be used to specify the directory containing the "+++
				"module. In that case the module name is the list of folder names of "+++
				"the directory, separated by ") TAC "." TA "'s, followed by a " TAC "."
			TA " and the file name. For example the implementation module " TAC "X.Y.Z"
			TA " is stored in file " TAC "X/Y/Z.icl" TA " (file " TAC "Z.icl" TA " in subfolder "
			TAC "Y" TA " of folder " TAC "Z" TA "). The path containing the first folder ("
			TAC "X" TA " in this case) should be a module search path for the compiler."
		)];
	= make_page pdf_i pdf_shl;

page_d_3 :: !{!CharWidthAndKerns} -> Page;
page_d_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i [
		H3 "D.1.4" "Generics additions"
		,N

		,SP (
			TS "Instances of generic functions for the generic representation types ("
			TAC "UNIT" TA "," TAC "PAIR" TA "," TAC "EITHER" TA "," TAC "OBJECT" TA ","
			TAC "CONS" TA "," TAC "RECORD" TA "," TAC "FIELD"
			TA (") may be defined in definition modules (instead of a derive) using the "+++
				"same syntax as used in implementation modules. This makes it possible "+++
				"for the compiler to optimise derived generic functions in other modules."))

		,N
		,SP (
			TS ("In definition modules unused generic function dependencies for generic instances "+++
				"can be specified by adding: ") TAC "with"
			TA " followed by the list of dependencies, but an " TAC "_"
			TA " for unused dependencies. The compiler uses this to optimize the generated code.")

		,P (TS "For example for:")

		,PC (map syntax_color [
			TS "generic h a | g1 a, g2 a :: a -> Int;",
			TS "h {|OBJECT of {gtd_name}|} _ g1_a _ (OBJECT a) = g1_a gtd_name a;"
		])

		,P (TS "Add: " TAC "with _ g1 _" TA " in the definition module:")
		
		,PC (map syntax_color [
			TS "derive h OBJECT of {gtd_name} with _ g1 _;"
		])

		,P (
			TSC "h" TA " for " TAC "OBJECT" TA " will be called without a function argument for "
			TAC "h" TA " (for a of " TAC "OBJECT" TA "), with " TAC "g1" TA " and without " TAC "g2"
			TA ", because " TAC "h" TA " and " TAC "g2" TA " are not used by the implementation.")
	  ];
	= make_page pdf_i pdf_shl;

page_d_4 :: !{!CharWidthAndKerns} -> Page;
page_d_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i [
		H2	"D.2" "Clean Development Compiler Extensions"
		,MSP [
			TS "type GenericInfo (in module StdGeneric) changed.",
			TS "generic instances of generic representation types (e.g. CONS) may occur in definition modules."
		]

		,H2	"D.3" "Clean ITask Compiler Extensions"
		,MSP [
			TS "Function arguments may have contexts with universally quantified type variables.",
			TS "Constructors may have contexts (for normal and universally quantified type variables).",
			TS "dynamic types may have contexts."
		]
	  ];
	= make_page pdf_i pdf_shl;
