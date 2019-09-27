implementation module clean_manual_modules_scopes;

import StdEnv,pdf_main,pdf_text,pdf_graphics,clean_manual_styles,clean_manual_text;

pages_2 :: [{!CharWidthAndKerns} -> Page];
pages_2 = [page_2_1,page_2_2,page_2_3,page_2_4,page_2_5,page_2_6,page_2_7,page_2_8];

separate_by :: ![Text] ![[Text]] -> [[Text]];
separate_by s l=:[e] = l;
separate_by s [e:l] = [e,s:separate_by s l];

page_2_1 :: !{!CharWidthAndKerns} -> Page;
page_2_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 2" "Modules and Scopes"
		,P(
			TS ("A CLEAN program is composed out of modules. Each module is stored in a file that contains CLEAN source code. "+++
				"There are implementation modules and definition modules, in the spirit of Modula-2 (")++
			TSB "Wirth" TA ", 1982). This module system is used for several reasons."
		),N
		,MPW indent_width
		[("-",(
			TS "First of all, the module structure is used to "
			TAI "control the scope of definitions"
			TA (". The basic idea is that definitions only have a meaning in the implementation module they "+++
				"are defined in unless  they are exported by the corresponding definition module.")
		)),("-",(
			TS ("Having the exported definitions collected in a separate definition module has as advantage that one "+++
				"in addition obtains a ")
			TAI "self-contained interface document"
			TA (" one can reach out to others. The definition module is a document that "+++
				"defines which functions and data types can be used by others without revealing uninteresting implementation details.")
		)),("-",(
			TS "Furthermore, the module structure enables " TAI "separate compilation"
			TA (" that heavily reduces compilation time. If the "+++
				"definition module stays the same, a change in an implementation module only will cause the recompilation of that "+++
				"implementation module. When the definition module is changed as well, only those implementation modules that "+++
				"are affected by this change need to be recompiled.")
		))],P (
			TS ("In this Chapter we explain the module structure of CLEAN and the influence it has on the scope of definitions. "+++
				"New scopes can also be introduced inside modules. This is further explained in the ")
			TAL "Chapters 2" TA " and " TAL "3" TA "."
		),S
			"In the pictures in the subsections below nested boxes indicate nested scopes."
		,H2
			"2.1" "Identifiers, Scopes and Name Spaces"
		,H3
			"2.1.1" "Naming Conventions of Identifiers"
		,P (
			TS "In CLEAN we distinguish the following kind of " TAI "identifiers" TA "."
		),ST
			[
			[TSC "ModuleName",			TS_E,TS "LowerCaseId",TS_B, TS "UpperCaseId",TS_B,TS "ModuleDirectoryName " TAT "." TA " ModuleName"],
			[TSC "ModuleDirectoryName",	TS_E,TS "LowerCaseId",TS_B, TS "UpperCaseId",[],[]],
			[TSC "FunctionName",		TS_E,TS "LowerCaseId",TS_B, TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "ConstructorName",		TS_E,[],[],					TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "SelectorVariable",	TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "Variable",			TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "MacroName",			TS_E,TS "LowerCaseId",TS_B,	TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "FieldName",			TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "TypeName",			TS_E,[],[],					TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "TypeVariable",		TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "UniqueTypeVariable",	TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "ClassName",			TS_E,TS "LowerCaseId",TS_B,	TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "MemberName",			TS_E,TS "LowerCaseId",TS_B,	TS "UpperCaseId",TS_B,TS "SymbolId"]
		  	]
		,ST [
			[TS "LowerCaseId",	TS_E, TS "LowerCaseChar~{IdChar}"],
			[TS "UpperCaseId",	TS_E, TS "UpperCaseChar~{IdChar}"],
			[TS "SymbolId",		TS_E, TS "{SymbolChar}+"]
		],ST [
			[TS "LowerCaseChar",TS_E]++separate_by TS_B [TST (toString c) \\ c<-['a'..'m']],
			[[],                TS_B]++separate_by TS_B [TST (toString c) \\ c<-['n'..'z']],
			[TS "UpperCaseChar",TS_E]++separate_by TS_B [TST (toString c) \\ c<-['A'..'M']],
			[[],                TS_B]++separate_by TS_B [TST (toString c) \\ c<-['N'..'Z']],
			[TS "SymbolChar",	TS_E]++separate_by TS_B [TST (toString c) \\ c<-:"~@#$%^?!:"]++repeatn 8 [],
			[[],				TS_B]++separate_by TS_B [TST (toString c) \\ c<-:"+-*<>\\/|&="]++repeatn 6 [],
			[TS "IdChar",		TS_E,TS "LowerCaseChar"]++repeatn 24 [],
			[[],				TS_B,TS "UpperCaseChar"]++repeatn 24 [],
			[[],				TS_B,TS "Digit"]++repeatn 24 [],
			[[],				TS_B,TST "_",TS_B,TST "`"]++repeatn 22 []
		]
	];
	= make_page pdf_i pdf_shl;

page_2_2 :: !{!CharWidthAndKerns} -> Page;
page_2_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "Digit",TS_E]++separate_by (TS_B) [TST (toString c) \\ c<-['0'..'9']]
		  ]
		,P(
			TS ("The convention used is that variables always start with a lowercase character while constructors and types always start "+++
				"with an uppercase character. The other identifiers can either start with an uppercase or a lowercase character. Notice "+++
				"that for the identifiers names can be used consisting of a combination of lower and/or uppercase characters but one can "+++
				"also define identifiers constructed from special characters like ")
			TAC "+" TA ", " TAC "<" TA ", etc. (" TAL "see Appendix A"
			TA ("). These two kinds of identifiers "+++
				"cannot be mixed. This makes it possible to leave out white space in expressions like ")
			TAC "a+1" TA " (same as " TAC "a + 1" TA ")."
		),H3
			"2.1.2" "Scopes and Name Spaces"
		,P(
			TS "The " TAI "scope"
			TA (" is the program region in which definitions (e.g. function definition, class definition, macro definition, type definition)"+++
				" with the identifiers introduced (e.g. function name, class name, class variable, macro name, type constructor "+++
				"name, type variable name) have a meaning.")
		),P(
			TS ("It must be clear from the context to which definition an identifier is referring. If all identifiers in a scope have different "+++
				"names than it will always be clear which definition is meant. However, one generally wants to have a free choice in "+++
				"naming identifiers. If identifiers belong to different ")
			TAI "name spaces"
			TA " no conflict can arise even if the same name is used. In CLEAN the following name spaces exist:"
		),N
		,MBS [
			"ModuleNames form a name space;",
			"FunctionNames, ConstructorNames, SelectorVariables, Variables and MacroNames form a name space;",
			"FieldNames form a name space;",
			"TypeNames, TypeVariables and UniqueTypeVariables form a name space;",
			"ClassNames form a name space."
			]
		,S
			"So, it is allowed to use the same identifier name for different purposes as long as the identifier belongs to different name spaces."
		,N
		,SP (
			TS ("Identifiers belonging to the same name space must all have different names within the same scope. Under certain "+++
				"conditions it is allowed to use the same name for different functions and operators (overloading, ")
			TAL "see Chapter 6" TA ")."
		),H3
			"2.1.3" "Nesting of Scopes"
		,P(
			TS "Reusing identifier names is possible by introducing a new scope level. Scopes can be nested: within a scope a new "
			TAI "nested scope"
			TA (" can be defined. Within such a nested scope new definitions can be given, new names can be introduced. "+++
				"As usual it is allowed in a nested scope to redefine definitions or re-use names given in a surrounding scope: When a "+++
				"name is re-used the old name and definition is no longer in scope and cannot be used in the new scope. A definition "+++
				"given or a name introduced in a (nested) scope has no meaning in surrounding scopes. It has a meaning for all scopes "+++
				"nested within it (unless they are redefined within such a nested scope). ")
		),H2
			"2.2" "Modular Structure of Clean Programs"
		,P(
			TS "A CLEAN program consists of a collection of "
			TAI "definition modules" TA " and " TAI "implementation modules"
			TA ". An implementation module and a definition module " TAI "correspond"
			TA (" to each other if the names of the two modules are the same. The basic idea is that "+++
			 	 "the definitions given in an implementation module only have a meaning in the module in which they are "+++
			 	 "defined unless these definitions "+++
			 	 "are exported by putting them into the corresponding definition module. In that case the definitions also "+++
				 "have a meaning in those other modules in which the definitions are imported (")
			TAL "see 2.5" TA ")."
		)
		,ST [
			[TS "CleanProgram",			TS_E,	TS "{Module}+"],
			[TS "Module",				TS_E,	TS "DefinitionModule"],
			[[],						TS_B,	TS "ImplementationModule"],
			[TS "DefinitionModule", 	TS_E,	TSBCr "definition module" TA " " TAC "ModuleName" TA " ;"],
			[[],						[],		TS "{DefDefinition}"],
			[[],						TS_B,	TSBCr "system module" TA " " TAC "ModuleName" TA " ;"],
			[[],						[],		TS "{DefDefinition}"],
			[TS "ImplementationModule",	TS_E,	TS "[" TABCr "implementation" TA "] " TABCr "module" TA " " TAC "ModuleName" TA " ;"], 
			[[],						[],		TS "{ImplDefinition}"]
			]
		];
	= make_page pdf_i pdf_shl;

page_2_3 :: !{!CharWidthAndKerns} -> Page;
page_2_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MSP [
			TS "An executable CLEAN program consists at least of one implementation module, the "
			TAI "main" TA " or " TAI "start module" TA ", which is the top-most module ("
			TAI "root module" TA ") of a CLEAN program.",
			TS "Each CLEAN module has to be put in a separate file.",
			TS ("The name of a module (i.e. the module name) should be the same as the name of the file (minus the suffix) in "+++
			     "which the module is stored."),
			TS "A " TAI "definition" TA " module should have ." TAI "dcl" TA " as suffix; an "
			TAI "implementation" TA " module should have " TAI ".icl " TA "as suffix.",
			TS "A definition module can have at most one corresponding implementation module.",
			TS "Every implementation module (except the main module, " TAL "see 2.3.1"
			TA ") must have a corresponding definition module."
		],H2
			"2.3" "Implementation Modules"
		,H3
			"2.3.1" "The Main or Start Module"
		,MSP [
			TS "In the main module a " TAC "Start" TA " rule has to be defined (" TAL "see Chapter 1" TA ").",
			TS "Only in the main module one can leave out the keyword implementation in the module header. In that case the "
			TAC "implementation module"
			TA " does not need to have a corresponding definition module (which makes sense for a topmost module)."
		],PCH
			(TS "A very tiny but complete CLEAN program consisting of one implementation module.")
			(map color_keywords [
			[],
			TS "module hello",
			[],
			TS "Start = \"Hello World!\""
		]),P(
			TSI "Evaluation of a" TA " CLEAN " TAI "program"
			TA " consists of the evaluation of the application defined in the right-hand side of the " TAC "Start "
			TAI "rule" TA " to normal form (" TAL "see Chapter 1" TA "). The right-hand side of the " TAC "Start"
			TA " rule is regarded to be the " TAI "initial expression" TA " to be computed."
		),P(
			TS "It is allowed to have a " TAC "Start"
			TA (" rule in other implementation modules as well. This can be handy for testing functions "+++
				"defined in such a module: to evaluate such a ") TAC "Start"
			TA (" rule simply generate an application with the module as root and "+++
				"execute it. In the CLEAN IDE one can specify which module has to be regarded as being the root module.")
		),P(
			TS "The definition of the left-hand side of the Start rule consists of the "
			TAI "symbol " TAC "Start" TA " with one optional argument (of type "
			TAC "*World" TA "), which is the environment parameter, which is necessary to write interactive applications."
		),S
			"A CLEAN program can run in two modes."
		,N
		,H3T
			"I/O Using the Console"
		,P(
			TS "The first mode is a " TAI "console mode" TA ". It is chosen when the Start rule is defined as a "
			TAI "nullary" TA " function."
		),PC (map comment_blue [
			TS "Start:: TypeOfStartFunction",
			TS "Start = ...                       // initial expression"
		]),P(
			TS "In the console mode, that part of the "
			TAI "initial expression"
			TA " (indicated by the right-hand side of the Start rule), which is in "
			TAI "root normal form"
			TA (" (also called the head normal form or root stable form), is printed as soon as possible. The console "+++
				"mode can be used for instance to test or debug functions.")
		),P(
			TS "In the CLEAN IDE one can choose to print the result of a " TAC "Start" TA " expression "
			TAI "with" TA " or " TAI "without" TA " the data constructors."
		),PCH
			(TS "For example, the initial expression")
			[
			[],
			TS "Start:: String",
			TS "Start = \"Hello World!\"",
			[]
		],CPCH
			(TS "in mode \"show data constructors\" will print: " TAC "\"Hello World!\""
			 TA ", in mode \"don't show data constructors\" it will print: " TAC "Hello World!")
			[
		]
		];
	= make_page pdf_i pdf_shl;

page_2_4 :: !{!CharWidthAndKerns} -> Page;
page_2_4 char_width_and_kerns
	# line_height = toReal line_height_i;

	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3T "I/O on the Unique World"
		,P(
			TS "The second mode is the " TAI "world mode"
			TA ". It is chosen when the optional additional parameter (which is of type " TAC "*World"
			TA ") is added to the " TAC "Start" TA " rule and delivered as result."
		),PC (map comment_blue [
			TS "Start:: *World -> *World",
			TS "Start = ...                       // initial expression returning a changed world"
		]),MP [
			[],
			TS "The world which is given to the initial expression is an "
			TAI "abstract data structure" TA ", an " TAI "abstract world" TA " of type *World which models "
			TAI "the concrete physical world" TA " as seen from the program. The abstract world can in principle contain "
			TAI "anything" TA " what a functional program needs to interact during execution with the concrete world. The world can be seen as a "
			TAI "state" TA " and modifications of the world can be realized via " TAI "state transition functions"
			TA " defined on the world or a part of the world. By requiring that these state transition functions work on a "
			TAI "unique" TA (" world the modifications of the abstract world can directly be realized in the "+++
				"real physical world, without loss of efficiency and without losing referential transparency (")
			TAL "see Chapter 9" TA ")",
			[],
			TS ("The concrete way in which the world can be handled in CLEAN is determined by the system programmer. One way to "+++
				"handle the world is by using the predefined CLEAN I/O library, which can be regarded as a platform independent mini "+++
				"operating system. It makes it possible to do file I/O, window based I/O, dynamic process creation and process "+++
				"communication in a pure functional language in an efficient way. The definition of the I/O library is treated in a separate "+++
				"document (")++TSb "Object IO tutorial" TA ", Achten " TAI "et al." TA ", 1997)."
		],H3
			"2.3.2" "Scope of Global Definitions in Implementation Modules"
		,P(
			TS "In an implementation module the following global definitions can be specified in " TAI "any" TA " order."
		),ST2 [
			[TS "ImplDefinition",	TS_E,TS "ImportDef",	TS "// " TAL "see 2.5"],
			[[],					TS_B,TS "FunctionDef",	TS "// " TAL "see Chapter 3"],
			[[],					TS_B,TS "GraphDef",		TS "// " TAL "see 3.6"],
			[[],					TS_B,TS "MacroDef",		TS "// " TAL "see 10.3"],
			[[],					TS_B,TS "TypeDef",		TS "// " TAL "see Chapter 5"],
			[[],					TS_B,TS "ClassDef",		TS "// " TAL "see Chapter 6"],
			[[],					TS_B,TS "GenericsDef",	TS "// " TAL "see Chapter 7"]
  		],MP [
			[],
			TSI "Definitions" TA " on the " TAI "global"
			TA (" level (= outermost level in the module,) have in principle the whole implementation module as "+++
				"scope (see Figure 2.1).")
		],PCH
			(TSB "Figure 2.1" TA " (Scope of global definitions inside an implementation module).")
			[]
		,CPCP
			(map syntax_color [
			[],
			TS "implementation module XXX",
			[],
			TS ":: TypeName typevars = type_expression           // definition of a new type",
			[],
			TS "functionName:: type_of_args -> type_of_result    // definition of the type of a function",
			TS "functionName args = expression                   // definition of a function",
			[],
			TS "selector = expression                            // definition of a constant graph",
			[],
			TS "class className = expression                     // definition of a class",
			[],
			TS "macroName args :==  expression                   // definition of a macro",
			[]
		])(let {
			char_width = toReal font_size*0.6; // for courier
		} in
			[Rectangle (0.0,                  1.0*line_height-1.0) (       46.0*char_width,    12.0*line_height+4.0)
			,Rectangle (12.0*char_width-2.0,  3.0*line_height+1.0) ((46.0-12.0)*char_width-2.0,     line_height-2.0)
			,Rectangle (15.0*char_width-2.0,  5.0*line_height+1.0) ((46.0-15.0)*char_width-2.0,     line_height-2.0)
			,Rectangle (13.0*char_width-2.0,  6.0*line_height+1.0) ((46.0-13.0)*char_width-2.0,     line_height-2.0)
			,Rectangle (11.0*char_width-2.0,  8.0*line_height+1.0) ((46.0-11.0)*char_width-2.0,     line_height-2.0)
			,Rectangle ( 6.0*char_width-2.0, 10.0*line_height+1.0) ((46.0- 6.0)*char_width-2.0,     line_height-2.0)
			,Rectangle (10.0*char_width-2.0, 12.0*line_height+1.0) ((46.0-10.0)*char_width-2.0,     line_height-2.0)
		]),MP [
			[],
			TS "Types can only be defined globally (" TAL "see Chapter 5"
			TA (") and therefore always have a meaning in the whole implementation "+++
				"module.  Type  variables  introduced  on  the  left-hand  side  of  a  (algebraic,  record,  synonym,  overload,  class,  instance, "+++
				"function, graph) type definition have the right-hand side of the type definition as scope."),
			[],
			TS "Functions, the type of these functions, constants (selectors) and macro's can be defined on the "
			TAI "global" TA " level as well as on a " TAI "local"
			TA (" level in nested scopes. When defined globally they have a meaning in the whole implementation module. "+++
				"Arguments introduced on the left-hand side of a definition (formal arguments) only have a meaning in the corresponding "+++
				"right-hand side."),
			[],
			TS ("Functions, the type of these functions, constants (selectors) and macro's can also be defined locally in a new scope. "+++
				"However, new scopes can only be introduced at certain points. In functional languages local definitions are by tradition "+++
				"defined by using ") TAI "let" TA "-expressions (definitions given " TAI "before"
			TA " they are used in a certain expression, nice for a bottom-up style of programming) and "
			TAI "where" TA "-blocks (definitions given " TAI "afterwards"
			TA ", nice for a top-down style of programming). These constructs are explained in detail in Chapter 3."
			]
		];
	= make_page pdf_i pdf_shl;

page_2_5 :: !{!CharWidthAndKerns} -> Page;
page_2_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3 "2.3.3" "Begin and End of a Definition: the Layout Rule"
		,MP [
			[],
			TS ("CLEAN programs can be written in two modes: layout sensitive mode 'on' and 'off'. The layout sensitive mode is switched "+++
				"off when a semi-colon is specified after the module name. In that case each definition has to be ended with a semicolon '")
			TACb ";" TA "'. A new scope has to begin with '"
			TACb "{" TA "' and ends with a :"
			TACb "}" TA "'. This mode is handy if CLEAN code is generated automatically (e.g. by a compiler)."
		],PCH
			(TS "Example of a CLEAN program " TAI "not" TA " using the layout rule.")
			(map color_keywords [
			[],
			TS "module primes"++TSb ";",
			[],
			TS "import StdEnv"++TSb ";",
			[],
			TS "primes:: [Int]"++TSb ";",
			TS "primes = sieve [2..]"++TSb ";",
			TS "where",
			TSb "{" TA "   sieve:: [Int] -> [Int]"++TSb ";" TA " sieve [pr:r] = [pr:sieve (filter pr r)]"++TSb ";",
			[],
			TS "    filter:: Int [Int] -> [Int]"++TSb ";",
			TS "    filter pr [n:r] | n mod pr == 0 = filter pr r"++TSb ";",
			TS "    | otherwise    = [n:filter pr r]"++TSb ";",
			TSb "}"
		]),MP [
			[],
			TS ("Programs look a little bit old fashion C-like in this way. Functional programmers generally prefer a more mathematical "+++
				"style. Hence, as is common in modern functional languages, there is a layout rule in CLEAN. When a semicolon does not "+++
				"end the header of a module, a CLEAN program has become layout sensitive. The ")
			TAI "layout rule" TA " assumes the omission of the semi-colon ('"
			TACb "'" TA "') that ends a definition and of the braces ('"
			TACb "{" TA "' and '" TACb "}"
			TA "') that are used to group a list of definitions. These symbols are automatically added according to the following rules:",
			[],
			TS "In " TAI "layout sensitive mode" TA " the indentation of the first lexeme after the keywords "++
			TSBCr "let" TA ", " TAC "#" TA ", " TAC "#!" TA ", " TABCr "of" TA ", "++
			TSBCr "where" TA ", or " TABCr "with"
			TA (" determines the indentation that the group of definitions following the keyword has to obey. Depending on the indentation of "+++
				"the first lexeme on a subsequent line the following happens. A new definition is assumed if the lexeme starts on the "+++
				"same indentation (and a semicolon is inserted). A previous definition is assumed to be continued if the lexeme is indented "+++
				"more. The group of definitions ends (and a close brace is inserted) if the lexeme is indented less. Global "+++
				"definitions are assumed to start in column 0."),
			[],
			TS "We strongly advise to write programs in layout sensitive mode. "
			TAI "For reasons of portability it is assumed that a tab space is set to 4 white spaces and that a non-proportional font is used."
		],PCH
			(TS "Same program using the layout sensitive mode.")
			(map color_keywords [
			[],
			TS "module primes",
			[],
			TS "import StdEnv",
			[],
			TS "primes:: [Int]",
			TS "primes = sieve [2..]",
			TS "where",
			TS "    sieve:: [Int] -> [Int]",
			TS "    sieve [pr:r] = [pr:sieve (filter pr r)]",
			[],
			TS "    filter:: Int [Int] -> [Int]",
			TS "    filter pr [n:r] | n mod pr == 0 = filter pr r",
			TS "    | otherwise    = [n:filter pr r]"
		]),H2
			"2.4" "Definition Modules"
		,P(
			TS "The definitions given in an implementation module only have a meaning in the module in which they are defined. If you want to "
			TAI "export"
			TA (" a definition, you have to specify the definition in the corresponding definition module. Some definitions "+++
				"can only appear in implementation modules, not in definition modules. The idea is to hide the actual implementation from "+++
				"the outside world. The is good for software engineering reasons while another advantage is that an implementation "+++
				"module can be recompiled separately without a need to recompile other modules. Recompilation of other modules is "+++
				"only necessary when a definition module is changed. All modules depending on the changed module will have to be "+++
				"recompiled as well. Implementations of functions, graphs and class sinstances are therefore only allowed in ")
			TAI "implementation"
			TA (" modules. They are exported by only specifying their type definition in the definition module. Also the "+++
				"right-hand side of any type definition can remain hidden. In this way an abstract data type is created (")
			TAL "see 5.4"
			TA ")."
		)];
	= make_page pdf_i pdf_shl;

page_2_6 :: !{!CharWidthAndKerns} -> Page;
page_2_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS "In a definition module the following global definitions can be given in " TAI "any" TA " order."
		),ST2 [
			[TS "DefDefinition",	TS_E,TS "ImportDef",					TS "// " TAL "see 2.5"],
			[[],					TS_B,TS "FunctionExportTypeDef",		TS "// " TAL "see 3.7"],
			[[],					TS_B,TS "MacroDef",						TS "// " TAL "see 10.3"],
			[[],					TS_B,TS "TypeDef",						TS "// " TAL "see Chapter 5"],
			[[],					TS_B,TS "ClassDef",						TS "// " TAL "see Chapter 6"],
			[[],					TS_B,TS "TypeClassInstanceExportDef",	TS "// " TAL "see 6.10"],
			[[],					TS_B,TS "GenericExportDef",				TS "// " TAL "see Chapter 7"]
		],MSP [
			TS "The definitions given in an implementation module only have a meaning in the module in which they are defined ("
			TAL "see 2.3"
			TA (") unless these definitions are exported by putting them into the corresponding definition module. In  that "+++
				"case they also have a meaning in those other modules in which the definitions are imported (")
			TAL "see 2.5" TA ").",
			TS ("In the corresponding implementation module all exported definitions have to get an appropriate implementation "+++
				"(this holds for functions, abstract data types, class instances)."),
			TS "An " TAI "abstract data type"
			TA (" is exported by specifying the left-hand side of a type rule in the definition module. "+++
				"In the corresponding implementation module the abstract type ")
			TAI "has to be defined again" TA " but then right-hand side has to be "
			TA "defined as well. For such an abstract data type only the name of the type is exported but not its definition.",
			TS "A " TAI "function" TA ",  global " TAI "graph" TA " or " TAI "class instance"
			TA (" is exported by defining the type header in the definition module. For optimal efficiency it is recommended also "+++
				"to specify strictness annotations (") TAL "see 10.1"
			TA "). For library functions it is recommended also to specify the uniqueness type attributes ("
			TAL "see Chapter 9"
			TA "). The implementation of a function, a graph, a class instance has to be given in the corresponding implementation module.",
			TS ("Although it is not required anymore to repeat an exported definition in the corresponding implementation module, it "+++
				"is a good habit to do so to keep the implementation module readable. If a definition is repeated, the definition given "+++
				"in the definition module and in the implementation module should be the same (modulo variable names).")
		],PCH
			(TS "Definition module.")
			(map syntax_color [
			[],
			TS "definition module ListOperations",
			[],
			TS "::complex                          // abstract type definition",
			[],
			TS "re:: complex -> Real               // function taking the real part of complex number",
			TS "im:: complex -> Real               // function taking the imaginary part of complex",
			[],
			TS "mkcomplex:: Real Real -> Complex   // function creating a complex number"
		]),PCH
			(TS "corresponding implementation module:")
			(map color_keywords [
			[],
			TS "implementation module ListOperations",
			[],
			TS "::complex :== (!Real,!Real)        "++TSb "// a type synonym",
			[],
			TS "re:: complex -> Real               "++TSb "// type of function followed by its implementation",
			TS "re (frst,_) = frst",
			[],
			TS "im:: complex -> Real",
			TS "im (_,scnd) = scnd",
			[],
			TS "mkcomplex:: Real Real -> Complex",
			TS "mkcomplex frst scnd = (frst,scnd)"
		]),H2
			"2.5" "Importing Definitions"
		,P(
			TS "Via an " TAI "import statement" TA " a definition " TAI "exported"
			TA " by a definition module (" TAL "see 2.4" TA ") can be " TAI "imported"
			TA " into any other (definition or implementation) module. There are two kinds of import statements, "
			TAI "explicit" TA " imports and " TAI "implicit" TA " imports."
		),ST [
			[TS "ImportDef",TS_E,TS "ImplicitImportDef"],
			[[],			TS_B,TS "ExplicitImportDef"]
		],P(
			TS "A module " TAI "depends"
			TA (" on another module if it imports something from that other module. "+++
				"In CLEAN 2.x cyclic dependencies are allowed.")
		),H3
			"2.5.1" "Explicit Imports of Definitions"
		,P(
			TSI "Explicit imports"
			TA (" are import statements in which the modules to import from as well as the identifiers indicating the "+++
				"definitions to import are explicitly specified. All identifiers explicitly being imported in a definition or implementation "+++
				"module will be included in the global scope level (= outermost scope, ")
			TAL "see 2.3.2" TA ") of the module that does the import."
		)];
	= make_page pdf_i pdf_shl;

page_2_7 :: !{!CharWidthAndKerns} -> Page;
page_2_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "ExplicitImportDef",	TS_E,	TSBCr "from" TAC " ModuleName " TABCr "import" TA " [" TAT "qualified" TA "] {Imports}-list " TACb ";"],
			[TS "Imports",				TS_E,	TSC "FunctionName"],
			[[],						TS_B,	TST "::" TAC "TypeName" TA " [ConstructorsOrFields]"],
			[[],						TS_B,	TSBCr "class" TAC " ClassName" TA " [Members]"],
			[[],						TS_B,	TSBCr "instance" TAC " ClassName" TA " {SimpleType}+"],
			[[],						TS_B,	TSBCr "generic" TA " " TAC "FunctionName"],
			[TS "ConstructorsOrFields",	TS_E,	TST "(..)"],
			[[],						TS_B,	TST "(" TA "{" TAC "ConstructorName" TA "}-list" TAT ")"],
			[[],						TS_B,	TST "{..}"],
			[[],						TS_B,	TST "{" TA "{" TAC "FieldName" TA"}-list"  TAT "}"],
			[TS "Members",				TS_E,	TST "(..)"],
			[[],						TS_B,	TST "(" TA "{" TAC "MemberName" TA "}-list" TAT ")"]
		],P(
			TS ("One can import functions or macro's, types with optionally their corresponding constructors, record types "+++
				"with optionally their corresponding fieldnames, classes, instances of classes and generic functions. "+++
				"The syntax makes it possible to discriminate between the different namespaces that exist in CLEAN (")
			TAL "see 2.1.2" TA ")"
		),PCH
			(TS "Example of an explicit import.")
			(map syntax_color [
			[],
			TS "implementation module XXX",
			[],
			TS "from m import    F,",
			TS "                 :: T1, :: T2(..), :: T3(C1, C2), :: T4{..}, :: T5{field1, field2},",
			TS "                 class C1, class C2(..), class C3(mem1, mem2),",
			TS "                 instance C4 Int, generic g",
			[]
		]),CPCH
			(TS "With the import statement the following definition exported by module " TAC "m" TA " are imported in module "
			 TAC "XXX" TA ": the " TAI "function" TA " or " TAI "macro" TA " " TAC "F" TA ", the " TAI "type" TA " "
			 TAC "T1" TA ", the " TAI "algebraic" TA " type " TAC "T2" TA " with " TAI "all"
			 TA " it's constructors that are exported by m, the " TAI "algebraic type " TAC "T3" TA " with it's constructors "
			 TAC "C1" TA " and " TAC "C2" TA ", the " TAI "record type" TA " " TAC "T4" TA " with " TAI "all"
			 TA " it's fields that are exported by m, the " TAI "record type" TA " " TAC "T5" TA " with it's fields "
			 TAC "field1" TA " and " TAC "field2" TA ", the " TAI "class" TA " " TAC "C1" TA ", the " TAI "class" TA " "
			 TAC "C2" TA " with all it's members that are exported by " TAC "m" TA ", the " TAI "class" TA " " TAC "C3"
			 TA " with it's members " TAC "mem1" TA " and " TAC "mem2" TA ", the instance of " TAI "class" TA " " TAC "C4"
			 TA " defined on integers, the generic function " TAC "g" TA ".")
			[
		],P(
			TS ("Importing identifiers can cause error messages because the imported identifiers may be in conflict with other "+++
				"identifiers in this scope (remember that identifiers belonging to the same name space must all have different names "+++
				"within the same scope, ")
			TAL "see 2.1"
			TA ("). This problem can be solved by renaming the internally defined identifiers or by "+++
				"renaming the imported identifiers (eg by adding an additional module layer just to rename things).")
		),H3
			"2.5.2" "Implicit Imports of Definitions"
		,ST [
			[TS "ImplicitImportDef",	TS_E,	TSBCr "import" TA " [" TAT "qualified" TA "] {" TAC "ModuleName" TA"}-list " TACb ";"]
		],P(
			TSI "Implicit imports" TA " are import statements in which only the module name to import from is mentioned. In this case "
			TAI "all" TA " definitions that are " TAI "exported" TA " from that module are imported as well as " TAI "all"
			TA " definitions that on their turn are " TAI "imported"++
			TS (" in the indicated definition module, and so on. So, all related definitions from various modules can be imported "+++
				"with one single import. This opens the possibility for definition modules to serve as a kind of ")
			TAI "'pass-through'"
			TA (" module. Hence, it is meaningful to have definition modules with import statements but without "+++
				"any definitions and without a corresponding implementation module.")
		),PCH
			(TS "Example of an implicit import: all (arithmetic) rules which are predefined can be imported easily with one import statement.")
			(map syntax_color [
			[],
			TS "import MyStdEnv"
		]),P(
			TS "importing implicitly all definitions imported by the definition module '" TAC "MyStdEnv"
			TA "' which is defined below (note that definition module '" TAC "MyStdEnv"
			TA "' does not require a corresponding implementation module) :"
		),PC (map syntax_color [
			TS "definition module MyStdEnv",
			[],
			TS "import " TAC "StdBool" TA ", " TAC "StdChar" TA ", " TAC "StdInt" TA ", " TAC "StdReal" TA ", " TAC "StdString"
		]),P(
			TS ("All identifiers implicitly being imported in a definition or implementation module will be included "+++
				"in the global scope level (= outermost scope, ") TAL "see 2.3.2"
			TA ") of the module that does the import."
		),N
		,SP (
			TS ("Importing identifiers can cause error messages because the imported identifiers may be in conflict with other "+++
				"identifiers in this scope (remember that identifiers belonging to the same name space must all have different names "+++
				"within the same scope, ") TAL "see 2.1"
			TA ("). This problem can be solved by renaming the internally defined identifiers or by "+++
				"renaming the imported identifiers (eg by adding an additional module layer just to rename identifiers).")
		)];
	= make_page pdf_i pdf_shl;

page_2_8 :: !{!CharWidthAndKerns} -> Page;
page_2_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2 "2.6" "System Definition and Implementation Modules"
		,P(
			TS "System modules are special modules. A " TAI "system definition module"
			TA " indicates that the corresponding implementation module is a " TAI "system implementation module"
			TA " which does not contain ordinary CLEAN rules. In system implementation modules it is allowed to define "
			TAI "foreign functions"
			TA (": the bodies of these foreign functions are written in another language than CLEAN. "+++
				"System implementation modules make it possible to create interfaces to operating systems, to file systems "+++
				"or to increase execution speed of heavily used functions or complex data structures. Typically, predefined function and "+++
				"operators for arithmetic and File I/O are implemented as system modules.")
		),P(
			TS ("System implementation modules may use machine code, C-code, abstract machine code (PABC-code) or code written "+++
				"in any other language. What exactly is allowed depends on the CLEAN compiler used and the platform for which code is "+++
				"generated. The keyword ") TABCr "code"
			TA " is reserved to make it possible to write CLEAN programs in a foreign language. This is not treated in this reference manual."
		),S(
			"When one writes system implementation modules one has to be very careful because the correctness of the functions "+++
			"can no longer be checked by the CLEAN compiler. Therefore, the programmer is now responsible for the following:"
		),MPW indent_width
		[("!",(
			TS "The function must be correctly typed."
		)),("!",(
			TS ("When a function destructively updates one of its (sub-)arguments, the corresponding type of the arguments should "+++
				"have the uniqueness type attribute. Furthermore, those arguments must be strict.")
		))]];
	= make_page pdf_i pdf_shl;
