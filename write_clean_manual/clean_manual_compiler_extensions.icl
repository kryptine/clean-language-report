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

		,H3 "D.1.1" "New expressions"
		,N

		,SP (
			TSC "v =: " TA "PATTERN in an expression yields " TAC "True"
			TA " if the expression matches the PATTERN and " TAC "False"
			TA " otherwise. Variable names are not allowed in the PATTERN, but " TAC "_"
			TA ("'s may be used. The compiler optimizes the case where the pattern "+++
				"consists of just a constructor, optionally followed by ") TAC "_"
				TA "'s. Otherwise it is transformed to a case expression.")

		,P (TS "The parser accepts additional " TAC "_"
			TA "'s at the end of the pattern, so " TAC "x=:(Constructor _ _)"
			TA " may be written without parenthesis as " TAC "x=:Constructor _ _" TA ".")

		,PCH (TS "For example:")[
			[],
			TS ":: T = X Int | Y Int Int | Z;",
			[],
			TS "is_X_or_Y :: T -> Bool;",
			TS "is_X_or_Y t = t=:X _ || t=:Y _ _;"
		]

		,H3 "D.1.2" "New imports"
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
		]
	  ];
	= make_page pdf_i pdf_shl;

page_d_2 :: !{!CharWidthAndKerns} -> Page;
page_d_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i [
		P (TS (
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

		,H3 "D.1.3" "Uniqueness typing additions"
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
		]),
		H3 "D.1.4" "New strictness annotations"
		,N

		,SP (TS "Strictness annotations in types of class instance members")
		
		,S "Types of class instance members may contain additional strictness annotations. For example:"

		,PC (map syntax_color [
			TS "class next a where",
			TS "    next :: a -> a",
			[],
			TS "instance next Int where",
			TS "    next :: !Int -> Int",
			TS "    next x = x+1"
		])
		
		,S ("If such an instance is exported, the type of the instance member must be "+++
			"included in the definition module:")

		,PC (map syntax_color [
			TS "instance next Int where",
			TS "    next :: !Int -> Int"
		])

		,S ("If no additional strictness annotations are specified, it can still "+++
			"be exported without the type by:")

		,PC (map syntax_color [
			TS "instance next Int"
		])
	  ];
	= make_page pdf_i pdf_shl;

page_d_3 :: !{!CharWidthAndKerns} -> Page;
page_d_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i [
		H3 "D.1.5" "Hierarchical modules"
		
		,P (TS ("The module name can be used to specify the directory containing the "+++
				"module. In that case the module name is the list of folder names of "+++
				"the directory, separated by ") TAC "." TA "'s, followed by a " TAC "."
			TA " and the file name. For example the implementation module " TAC "X.Y.Z"
			TA " is stored in file " TAC "X/Y/Z.icl" TA " (file " TAC "Z.icl" TA " in subfolder "
			TAC "Y" TA " of folder " TAC "Z" TA "). The path containing the first folder ("
			TAC "X" TA " in this case) should be a module search path for the compiler."
		)

		,H3 "D.1.6" "New types"
		,N

		,SP (
			TS "The predefined unit type.")

		,PC [
			TS ":: () = ()"
		]
		,N

		,SP (
			TS "Extensible algebraic types can be defined by adding " TAC "| .."
			TA " to the algebraic type definition (or just " TAC ".."
			TA (" without constructors). In other modules additional constructors may be added "+++
				"(once per module) by using ") TAC "|" TA " in the definition instead of " TAC "=" TA ".")

		,PCH (TS "For example, to define extensible type " TAC "T" TA " with constructor " TAC "A" TA ":")[
			[],
			TS ":: T = A Int | .."
		]

		,PCH (TS "To extended " TAC "T" TA " with constructor " TAC "B" TA " in another module:")[
			[],
			TS ":: T | B Int Int"
		]

		,H3 "D.1.7" "Generics additions"
		,N

		,SP (
			TS "Instances of generic functions for the generic representation types ("
			TAC "UNIT" TA "," TAC "PAIR" TA "," TAC "EITHER" TA "," TAC "OBJECT" TA ","
			TAC "CONS" TA "," TAC "RECORD" TA "," TAC "FIELD"
			TA (") may be defined in definition modules (instead of a derive) using the "+++
				"same syntax as used in implementation modules. This makes it possible "+++
				"for the compiler to optimise derived generic functions in other modules."))

		,SP (
			TS "In definition modules the used generic info fields for generic instances of "
			TAC "OBJECT" TA ", " TAC "CONS" TA ", " TAC "RECORD" TA " and " TAC "FIELD"
			TA " can be specified by adding: " TAC "of" TA (" and the pattern, at the end of "+++
				"the derive statement. The compiler uses this to optimize the generated code."))

		,PCH (TS "For example if " TAC "g2" TA " is defined as:")
			(map syntax_color [
				[],
				TS "generic g2 a :: a -> Int;",
				TS "g2{|CONS of {gcd_name}|} _ _ = size gcd_name;"
		])

		,P (TS "add: " TAC "of {gcd_name}" TA " in the definition module:")

		,PC [TS "derive g2 CONS of {gcd_name};"]
      
		,P (TSC "g2" TA " for " TAC "CONS" TA " will be called with just a " TAC "gcd_name"
			TA ", instead of a " TAC "GenericConsDescriptor" TA " record.")
		,N

		,SP (
			TS ("In definition modules unused generic function dependencies for generic instances "+++
				"can be specified by adding: ") TAC "with"
			TA " followed by the list of dependencies, but an " TAC "_"
			TA " for unused dependencies. The compiler uses this to optimize the generated code.")
		
	  ];
	= make_page pdf_i pdf_shl;

page_d_4 :: !{!CharWidthAndKerns} -> Page;
page_d_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i [
		S "For example if the implementation module defines:"
		
		,PC (map syntax_color [
			TS "generic g1 a :: a -> Int;",
			TS "generic g2 a :: a -> Int;",
 			TS "generic h a | g1 a, g2 a :: a -> Int;",
 			[],
			TS "h{|OBJECT of {gtd_name}|} _ g1 _ (OBJECT a)",
			TS "    = g1 a+size (gtd_name);"
		])

		,P (TS "add: " TAC "with _ g1 _" TA " in the definition module:")
		
		,PC (map syntax_color [
			TS "derive h OBJECT of {gtd_name} with _ g1 _;"
		])

		,P (
			TSC "h" TA " for " TAC "OBJECT" TA " will be called without a function argument for "
			TAC "h" TA " (for a of " TAC "OBJECT" TA "), with " TAC "g1" TA " and without " TAC "g2"
			TA ", because " TAC "h" TA " and " TAC "g2" TA " are not used by the implementation.")


		,H2	"D.2" "Clean Development Compiler Extensions"
		,MSP [
			TS "types of instance members in definition modules.",
			TS "generic functions can have dependent generic functions (also in Clean 3.0).",
			TS "type GenericInfo (in module StdGeneric) changed.",
			TS "generic instances of generic representation types (e.g. CONS) may occur in definition modules."
		]

		,H2	"D.3" "Clean ITask Compiler Extensions"
		,MSP [
			TS "Function arguments may have contexts with universally quantified type variables.",
			TS "Constructors may have contexts (for normal and universally quantified type variables).",
			TS "dynamic types may have contexts.",
			TS "derive class."
		]
	  ];
	= make_page pdf_i pdf_shl;
