implementation module clean_manual_predefined_types;

import StdEnv,pdf_main,pdf_text,pdf_graphics,clean_manual_styles,clean_manual_text;

courier_char_width = toReal font_size*0.6;

separate_by :: ![Text] ![[Text]] -> [[Text]];
separate_by s l=:[e] = l;
separate_by s [e:l] = [e,s:separate_by s l];

concat_with_separator :: ![Text] ![[Text]] -> [Text];
concat_with_separator s l=:[e] = e;
concat_with_separator s [e:l] = e++s++concat_with_separator s l;

pages_4 :: [{!CharWidthAndKerns} -> Page];
pages_4 = [page_4_1,page_4_2,page_4_3,page_4_4,page_4_5,page_4_6,page_4_7,page_4_8,page_4_9,page_4_10,page_4_11,page_4_12,page_4_13,page_4_14];

page_4_1 :: !{!CharWidthAndKerns} -> Page;
page_4_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 4" "Predefined Types"
		,P(
			TS "Certain types like " TAC "Int" TA "egers, "TAC "Bool" TA "eans, " TAC "Char" TA "acters, " TAC "Real"
					TA ("s, Lists, Tuples and Arrays are that frequently used that they "+++
						"have been predefined in CLEAN for reasons of efficiency and/or notational convenience. These types and the syntactic "+++
						"sugar that has been added to create and to inspect (via pattern matching) objects of these popular types are treated in "+++
						"this chapter.")
		),ST2 [
			[TS "PredefinedType",	TS_E,	TS "BasicType",		TS "// " TAL "see 4.1"],
			[[],					TS_B,	TS "ListType",		TS "// " TAL "see 4.2"],
			[[],					TS_B,	TS "TupleType",		TS "// " TAL "see 4.3"],
			[[],					TS_B,	TS "ArrayType",		TS "// " TAL "see 4.4"],
			[[],					TS_B,	TS "ArrowType",		TS "// " TAL "see 4.6"],
			[[],					TS_B,	TS "PredefType",	TS "// " TAL "see 4.7"]
		],S(
			"In Chapter 5 we will explain how new types can be defined."
		),H2
			"4.1" "Basic Types: Int, Real, Char and Bool"
		,MP [
			[],
			TSI "Basic types" TA " are " TAI "algebraic types" TA " (" TAL "see 5.1"
			TA ") which are predefined for reasons of efficiency and convenience: " TAC "Int"
			TA " (for 32 bits integer values), " TAC "Real" TA " (for 64 bit double precision floating point values), "
			TAC "Char" TA " (for 8 bits ASCII character values) and " TAC "Bool"
			TA ("(for 8 bits Boolean values). For programming convenience special syntax is introduced to denote constant values "+++
				"(data constructors) of these predefined types. Functions to create and manipulate objects of basic types can be found in "+++
				"the CLEAN ") TAC "StdEnv" TA " library (as indicated below).",
			[],
			TS "There is also a special notation to denote a string (an unboxed array of characters, " TAL "see 4.4"
			TA ") as well as to denote a list of characters (" TAL "see 4.2.1" TA ")."
		],ST2 [
			[TS "BasicType",	TS_E,	TST "Int",	TS "// see " TAC "StdInt.dcl"],
			[[],				TS_B,	TST "Real",	TS "// see " TAC "StdReal.dcl"],
			[[],				TS_B,	TST "Char",	TS "// see " TAC "StdChar.dcl"],
			[[],				TS_B,	TST "Bool",	TS "// see " TAC "StdBool.dcl"]
		],H3
			"4.1.1" "Creating Constant Values of Basic Type"
		,P(
			TS "In a graph expression a " TAI "constant value" TA "of basic type "
			TAC "Int" TA ", " TAC "Real" TA ", " TAC "Bool" TA " or " TAC "Char" TA " can be created."
		),ST [
			[TS "BasicValue",	TS_E,	TS "IntDenotation"], 
			[[],				TS_B,	TS "RealDenotation"],
			[[],				TS_B,	TS "BoolDenotation"],
			[[],				TS_B,	TS "CharDenotation"]
		],ST2 [
			[TS "IntDenotation",	TS_E,	TS "[Sign]{Digit}+",							TS "// decimal number"],
			[[],					TS_B,	TS "[Sign]0{OctDigit}+",						TS "// octal number"],
			[[],					TS_B,	TS "[Sign]0x{HexDigit}+",						TS "// hexadecimal number"],
			[TS "Sign",				TS_B,	TS "+ | -",										[]],
			[TS "RealDenotation",	TS_E,	TS "[Sign]{Digit}+.{Digit}+[E[Sign]{Digit}+]",	TS ""],
			[TS "BoolDenotation",	TS_E,	TS "True | False",								[]],
			[TS "CharDenotation",	TS_E,	TS "CharDel AnyChar/CharDel CharDel",			[]],
			[TS "CharsDenotation",	TS_E,	TS "CharDel {AnyChar/CharDel}+ CharDel",		[]]
		]
		];
	= make_page pdf_i pdf_shl;

page_4_2 :: !{!CharWidthAndKerns} -> Page;
page_4_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[let {
			n_extra_columns = 6;
		} in ST [
			[TS "AnyChar",		TS_E,concat_with_separator (TS " | ") [TS "IdChar",TS "ReservedChar",TS "SpecialChar"]]++repeatn (16+n_extra_columns) [],
			[TS "ReservedChar",	TS_E]++separate_by TS_B (map TST ["(",")","{","}","[","]",";",",","."])++repeatn n_extra_columns [],
			[TS "SpecialChar",	TS_E]++separate_by TS_B (map TST ["\\n","\\r","\\f","\\b"])++repeatn 3 []
			++[TS "// newline,return,formf,backspace"]++repeatn (6+n_extra_columns) [],
			[[],				TS_B]++separate_by TS_B [TST "\\t",TST "\\\\",TST "\\" TA "CharDel"]++repeatn 5 []
			++[TS "// tab,backslash,character delimiter"]++repeatn (6+n_extra_columns) [],
			[[],				TS_B,	TST "\\" TA "StringDel"]++repeatn 9 []
			++[TS "// string delimiter"]++repeatn (6+n_extra_columns) [],
			[[],				TS_B,	TST "\\" TA "{OctDigit}+"]++repeatn 9 []
			++[TS "// octal number "]++repeatn (6+n_extra_columns) [],
			[[],				TS_B,	TST "\\x" TA "{HexDigit}+"]++repeatn 9 []
			++[TS "// hexadecimal number "]++repeatn (6+n_extra_columns) []
		],ST [
			[TS "Digit",	TS_E]++separate_by TS_B [TST (toString c) \\ c<-['0'..'9']],
			[TS "OctDigit",	TS_E]++separate_by TS_B [TST (toString c) \\ c<-['0'..'7']]++repeatn 4 [],
			[TS "HexDigit",	TS_E]++separate_by TS_B [TST (toString c) \\ c<-['0'..'9']],
			[[],			TS_B]++separate_by TS_B [TST (toString c) \\ c<-['A'..'F']]++repeatn 8 [],
			[[],			TS_B]++separate_by TS_B [TST (toString c) \\ c<-['a'..'f']]++repeatn 8 []
		],ST [
			[TS "CharDel",		TS_E,	TS "'"],
			[TS "StringDel",	TS_E,	TS "\""]
		],PCH
			(TS "Example of denotations.")
			[
			[],
			TS "Integer (decimal):        0|1|2|...|8|9|10| ... |-1|-2| ...",
			TS "Integer (octal):          00|01|02|...|07|010| ... |-01|-02| ...",
			TS "Integer (hexadecimal):    0x0|0x1|0x2|...|0x8|0x9|0xA|0xB ... |-0x1|-0x2| ...",
			TS "Real:                     0.0|1.5|0.314E10| ...",
			TS "Boolean:                  True | False",
			TS "Character:                'a'|'b'|...|'A'|'B'|...",
			TS "String:                   \"\" | \"Rinus\"|\"Marko\"|...",
			TS "List of characters:       ['Rinus']|['Marko']|..."
		],H3
			"4.1.2" "Patterns of Basic Type"
		,P(
			TS "A " TAI "constant value" TA " of predefined " TAI "basic type" TA " " TAC "Int" TA ", " TAC "Real" TA ", " TAC "Bool" TA " or " TAC "Char"
			TA " (" TAL "see 4.1" TA ") can be specified as pattern."
		)
		,N
		,SP(
			TS "The denotation of such a value must obey the syntactic description given in above."
		),PCH
			(TS "Use of Integer values in a pattern.")
			[
			[],
			TS "nfib:: Int -> Int",
			TS "nfib 0 = 1",
			TS "nfib 1 = 1",
			TS "nfib n = 1 + nfib (n-1) * nfib (n-2)"
		],H2
			"4.2" "Lists"
		,MP [
			[],
			TS "A " TAI "list" TA "is an algebraic data type predefined just for programming convenience. A list can contain an "
			TAI "infinite number" TA " of elements. All elements must be of the " TAI "same type"
			TA (". Lists are very often used in functional languages and therefore the "+++
				"usual syntactic sugar is provided for the creation and manipulation of lists (dot-dot expressions, list comprehensions) "+++
				"while there is also special syntax for a ")
			TAI "list of characters" TA ".",
			[],
			TS ("Lists can be lazy (default), and optionally be defined as head strict, spine strict, strict (both head and spine strict), head "+++
				"strict unboxed, and strict unboxed. Lazy, strict and unboxed lists are all objects of ")
			TAI "different:" TA " type. All these different types of lists have different time and space properties ( "
			TAL "see 10.1.3"
			TA ("). Because these lists are of different type, conversion "+++
				"functions are needed to change e.g. a lazy list to a strict list. Functions defined on one type of a list cannot be applied to "+++
				"another type of list. However, one can define overloaded functions that can be used on any list: lazy, strict as well as on "+++
				"unboxed lists.")
		],ST2 [
			[TS "ListType",			TS_E,	TST "[" TA "[ListKind] Type [SpineStrictness]" TAT "]",	[]],
			[TS "ListKind",			TS_E,	TST "!",														TS "// head strict list"],
			[[],					TS_B,	TST "#",														TS "// head strict, unboxed list"],
			[TS "SpineStrictness",	TS_E,	TST "!",														TS "// tail (spine) strict list"]
		]
		,N
		,SP(
			TS "All elements of a list must be of the " TAI "same type" TA "."
		)]; 
	= make_page pdf_i pdf_shl;

page_4_3 :: !{!CharWidthAndKerns} -> Page;
page_4_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3
			"4.2.1" "Creating Lists"
		,P(
			TS "Because lists are very convenient and very frequently used data structures, there are several syntactical constructs in CLEAN for creating lists, including "
			TAI "dot-dot expressions" TA " and " TAI "ZF-expressions" TA ". Since CLEAN is a lazy functional language, the default list in CLEAN is a "
			TAI "lazy" TA " list. However, in some cases " TAI "strict lists" TA ", " TAI "spine strict lists" TA " and " TAI "unboxed"
			TA " lists can be more convenient and more efficient."
		),ST [
			[TS "List",	TS_E,	TS "ListDenotation"],
			[[],		TS_B,	TS "DotDotExpression"],
			[[],		TS_B,	TS "ZF-expression"]
		],N
		,SP(
			TS "All elements of a list must be of the same type" TA "."
		),N
		,H3T "Lazy Lists"
		,ST [
			[TS "ListDenotation",	TS_E,	TST "[" TA "[ListKind] [{LGraphExpr}-list [" TAT ":" TA " GraphExpr]] [SpineStrictness] " TAT "]"],
			[TS "LGraphExpr",		TS_E,	TS "GraphExpr"],
			[[],					TS_B,	TS "CharsDenotation"]
		],ST [
			[TS "CharsDenotation",	TS_E,	TS "CharDel {AnyChar/CharDel}+ CharDel"],
			[TS "CharDel",			TS_E,	TS "'"]
		],S(
			"One way to create a list is by explicit enumeration of the list elements. Lists are constructed by adding one or more elements to an existing list."
		),PCH
			(TS "Various ways to define a lazy list with the integer elements " TAC "1" TA "," TAC "3" TA "," TAC "5" TA "," TAC "7" TA "," TAC "9" TA ".")
			[
			[],
			TS "[1:[3:[5:[7:[9:[]]]]]]",
			TS "[1:3:5:7:9:[]]",
			TS "[1,3,5,7,9]",
			TS "[1:[3,5,7,9]]",
			TS "[1,3,5:[7,9]]"
		],P(
			TS "A special notation is provided for the frequently used " TAI "list of characters" TA "."
		),PCH
			(TS "Various ways to define a lazy list with the characters '" TAC "a" TA "', '" TAC "b" TA "' and '" TAC "c" TA "'.")
			[
			[],
			TS "['a':['b':['c':[]]]]",
			TS "['a','b','c']",
			TS "['abc']",
			TS "['ab','c']"
		],N
		,H3T "Strict , Unboxed and Overloaded Lists"
		,ST2 [
			[TS "ListKind",			TS_E,	TST "!",	TS "// head strict list"],
			[[],					TS_B,	TST "#",	TS "// unboxed list"],
			[[],					TS_B,	TST "|",	TS "// overloaded list"],
			[TS "SpineStrictness",	TS_E,	TST "!",	TS "// spine strict list"]
		],MP [
			[],
			TS "In CLEAN " TAI "any" TA " data structure can be made (partially) strict or unboxed (" TAL "see 10.1"
			TA "). This has consequences for the time and space behavior of the data structure.",
			[],
			TS "For instance, " TAI "lazy lists"
			TA (" are very convenient (nothing is evaluated unless it is really needed for the computation, one can "+++
				"deal with infinite data structures), but they can be inefficient as well if actually always all lists elements are evaluated "+++
				"sooner or later. ")
			TAI "Strict lists"
			TA " are often more efficient, but one has to be certain not to trigger a not used infinite computation. "
			TAI "Spine strict lists"
			TA (" can be more efficient as well, but one cannot handle infinite lists in this way. Unboxed lists are head "+++
				"strict. The difference with a strict list is that the representation of an ")
			TAI "unboxed list"
			TA (" is more compact: instead of a pointer to "+++
				"the lists element the list element itself is stored in the list. However, unboxed lists have as disadvantage that they can "+++
				"only be used in certain cases: they can only contain elements of basic type, records and tuples. It does not make sense "+++
				"to offer unboxing for arbitrary types: boxing saves space, but not if Cons nodes are copied often: the lists elements are "+++
				"copied as well while otherwise the contents could remain shared using the element pointer instead.")
		]
		];
	= make_page pdf_i pdf_shl;

page_4_4 :: !{!CharWidthAndKerns} -> Page;
page_4_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS ("In terms of efficiency it can make quite a difference (e.g. strict lists can sometimes be 6 times faster) which kind of list is "+++
				"actually used. But, it is in general not decidable which kind of list is best to use. This depends on how a list is used in a "+++
				"program. A wrong choice might turn a program from useful to useless (too inefficient), from terminating to non-terminating."),
			[],
			TS ("Because lists are so frequently used, special syntax is provided to make it easier for a programmer to change from one "+++
				"type of list to another, just by changing the kind of brackets used. One can define a list of which the ") TAI "head"
			TA "element is strict but the spine is lazy (indicated by " TAC "[! ]" TA "), a list of which the " TAI "spine"
			TA " is strict but the head element is lazy (indicated by " TAC "[ !]"
			TA ") and a completely evaluated list (indicated by " TAC "[! !]"
			TA "). One can have an unboxed list with a strict head element (indicated by "TAC "[# ]"
			TA ") and a completely evaluated unboxed list of which in addition the spine is strict as well (indicated by " TAI "[# !]",
			[],
			TS ("Note that all these different lists are of different type and consequently these lists cannot be mixed and unified with each "+++
				"other. With conversion functions offered in the CLEAN libraries it is possible to convert one list type into another. It is also "+++
				"possible to define an overloaded list and overloaded functions that work on ")
			TAI "any" TA " list (see hereafter)."
		],PCH
			(TS "Various types of lists.")
			(map comment_blue [
			TS "[  fac 10 : expression  ]                   // lazy list",
			TS "[! fac 10 : expression  ]                   // head strict list",
			TS "[! fac 10 : expression !]                   // head strict and tail strict list",
			TS "[# fac 10 : expression  ]                   // head strict list, unboxed",
			TS "[# fac 10 : expression !]                   // head strict and tail strict list, unboxed"
		]),N
		,SP(
			TS "Unboxed data structures can only contain elements of basic type, records and arrays."
		),P(
			TS "One can create an " TAI "overloaded" TA " list that will fit on any type of list (lazy, strict or unboxed)"
		),PCH
			(TS "Example of an overloaded list.")
			(map comment_blue [
			[],
			TS "[| fac 10 : expression ]                    // overloaded list"
		]),S(
			"Other ways to create lists are via dot-dot expressions and list comprehensions."
		),N
		,H3T "DotDot Expressions"
		,ST [
			[TS "DotDotExpression",	TS_E,	TST "[" TA "[ListKind] GraphExpr [" TAT "," TA "GraphExpr]" TAT ".." TA "[GraphExpr] [SpineStrictness] " ++ TST "]"]
		],P(
			TS "With a dot-dot expression the list elements can be enumerated by giving the first element (" TAC "n1"
			TA "), an optional second element (" TAC "n2" TA ") and an optional last element (" TAC "e" TA ")."
		),PCH
			(TS "Alternative ways to define a list a dot dot expression.")
			(map comment_blue [
			[],
			TS "[1,3..9]                                        // [1,3,5,7,9]",
			TS "[1..9]                                          // [1,2,3,4,5,6,7,8,9]",
			TS "[1..]                                           // [1,2,3,4,5 and so on ...",
			TS "['a'..'c']                                      // ['abc']"
		]),S(
			"The generated list is in general calculated as follows:"
		),PC (map color_keywords [
			TS "from_then_to:: !a !a !a -> .[a] | Enum a",
			TS "from_then_to n1 n2 e",
			TS "| n1 <= n2   = _from_by_to n1 (n2-n1) e",
			TS "             = _from_by_down_to n1 (n2-n1) e",
			TS "where",
			TS "    from_by_to n s e",
			TS "    | n<=e   = [n : _from_by_to (n+s) s e]",
			TS "             = []",
			[],
			TS "    from_by_down_to n s e",
			TS "    | n>=e   = [n : _from_by_down_to (n+s) s e]",
			TS "             = []"
		])
		];
	= make_page pdf_i pdf_shl;

page_4_5 :: !{!CharWidthAndKerns} -> Page;
page_4_5 char_width_and_kerns
	# line_height = toReal line_height_i;
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "The step size is " TAI "one" TA " by default. If no last element is specified an infinite list is generated.",
			[],
			TS "With a dot-dot expression one can also define a lazy list, a strict list, an unboxed list or an overloaded list.",
			[]
		],CPCH
			(TS "Different types of lists (lazy, strict, unboxed and overloaded can be defined with a dot dot expression as well.")
			(map comment_blue [
			[],
			TS "[  1,3..9  ]                            // a lazy list",
			TS "[! 1,3..9  ]                            // a head strict list",
			TS "[! 1,3..9 !]                            // a strict list (head and spine)",
			TS "[# 1,3..9  ]                            // a head strict list, unboxed",
			TS "[# 1,3..9 !]                            // a strict list (head and spine), unboxed",
			TS "[| 1,3..9  ]                            // an overloaded list"
		]),MSP [
			TS "Dot-dot expression can only be used if one imports " TAC "StdEnum" TAC " from the standard library.",
			TS "Dot-dot expressions are predefined on objects of type " TAC "Int" TA ", " TAC "Real" TA " and " TAC "Char"
			TA (", but dot-dots can also be applied to any user defined data structure for which the class enumeration type has been instantiated "+++
				"(see CLEANs Standard Environment).")
		],N
		,H3T "List Comprehensions"
		,ST2 [
			[TS "ZF-expression",	TS_E,	TST "[" TA "[ListKind] GraphExpr " TAT "\\" TA "{Qualifier}-list [SpineStrictness]" TAT "]",
																						[]],
			[TS "Qualifier",		TS_E,	TS "Generators { " TAT "," TA " " TABCr "let" TA " " TABCb "{" TA " {LocalDef}+ " TABCb "}" TA " } {" TAT "|" TA "Guard}",
																						[]],
			[TS "Generators",		TS_E,	TS "{Generator}-list",						[]],
			[[],					TS_B,	TS "Generator {" TAT "&" TA " Generator}",	[]],
			[TS "Generator",		TS_E,	TS "Selector " TAT "<-" TA " ListExpr",		TS "// select from a lazy list"],
			[[],					TS_B,	TS "Selector " TAT "<|-" TA " ListExpr",	TS "// select from an overloaded list"],
			[[],					TS_B,	TS "Selector " TAT "<-:" TA " ArrayExpr",	TS "// select from an array"],
			[TS "Selector",			TS_E,	TS "BrackPattern",							TS "// for brack patterns " TAL "see 3.2"],
			[TS "ListExpr",			TS_E,	TS "GraphExpr",								[]],
			[TS "ArrayExpr",		TS_E,	TS "GraphExpr",								[]],
			[TS "Guard",			TS_E,	TS "BooleanExpr",							[]],
			[TS "BooleanExpr",		TS_E,	TS "GraphExpr",								[]],
			[TS "ListKind",			TS_E,	TST "!",									TS "// head strict list"],
			[[],					TS_B,	TST "#",									TS "// unboxed list"],
			[[],					TS_B,	TST "|",									TS "// overloaded list"],
			[TS "SpineStrictness",	TS_E,	TST "!",									TS "// spine strict list"]
		],MP [
			[],
			TS "With a list generator called a ZF-expression one can construct a list composed from elements drawn from other lists or arrays. With a "
			TAI "list generator" TA "one can draw elements from lazy list. The symbol '" TAC "<-"
			TA "' is used to draw elements from a lazy list, the symbol '"
			TAC "<|-"TA "' can be used to draw elements from any (lazy, strict, unboxed) list. With an "
			TAI "array generator" TA " (use symbol  '" TAC "<-:"
			TA ("') one can draw elements from any array. One can define several generators in a row separated by a "+++
				"comma. The last generator in such a sequence will vary first. One can also define several generators in a row separated by a '")
			TAC "&"
			TA ("'. All generators in such a sequence will vary at the same time but the drawing of elements will stop as soon of one "+++
				"the generators is exhausted. This construct can be used instead of the zip-functions that are commonly used. ")
			TAI "Selectors" TA " are simple patterns to identify parts of a graph expression. They are explained in "
			TAL "Section 3.6"
			TA (". Only those lists produced by a generator that match the specified selector are taken into account. "+++
				"Guards can be used as filter in the usual way."),
			[],
			TS ("The scope of the selector variables introduced on the left-hand side of a generator is such that the variables can be used "+++
				"in the guards and other generators that follow. All variables introduced in this way can be used in the expression before the ")
			TAC "\\\\" TA " (see the picture below)."
		],PCP [
			TS "[ expression \\\\  selector  <- expression",
			TS "             |   guard",
			TS "             ,   selector  <- expression",
			TS "             |   guard",
			TS "]"
		] [
			ClosedPath (2.0*courier_char_width-4.0, 4.0*line_height+4.0)
			[PLine ( 2.0*courier_char_width-4.0, 0.0*line_height+2.0),
			 PLine (30.0*courier_char_width-2.0, 0.0*line_height+2.0),
			 PLine (30.0*courier_char_width-2.0, 1.0*line_height+2.0),
			 PLine (40.0*courier_char_width,     1.0*line_height+2.0),
			 PLine (40.0*courier_char_width,     4.0*line_height+4.0)
			],
			ClosedPath (2.0*courier_char_width-2.0, 4.0*line_height+2.0)
			[PLine	( 2.0*courier_char_width-2.0, 0.0*line_height+4.0),
			 PLine (12.0*courier_char_width+2.0, 0.0*line_height+4.0),
			 PLine (12.0*courier_char_width+2.0, 2.0*line_height+2.0),
			 PLine (30.0*courier_char_width-2.0, 2.0*line_height+2.0),
			 PLine (30.0*courier_char_width-2.0, 3.0*line_height+2.0),
			 PLine (40.0*courier_char_width-2.0, 3.0*line_height+2.0),
			 PLine (40.0*courier_char_width-2.0, 4.0*line_height+2.0)
			]
		]];
	= make_page pdf_i pdf_shl;

page_4_6 :: !{!CharWidthAndKerns} -> Page;
page_4_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCMH [
			TS "ZF-expression:",
			TS "expr1 yields [(0,0), (0,1), (0,2), (1,0), (1,1), (1,2), (2,0), (2,1), (2,2), (3,0), (3,1), (3,2)]",
			TS "expr2 yields [(0,0), (1,1), (2,2)].",
			TS "expr3 yields [(0,0), (1,0), (1,1), (2,0), (2,1), (2,2), (3,0), (3,1), (3,2), (3,3)])"
		][
			[],
			TS "expr1 = [(x,y) \\\\ x <- [0..3] , y <- [0..2]]",
			TS "expr2 = [(x,y) \\\\ x <- [0..3] & y <- [0..2]]",
			TS "expr3 = [(x,y) \\\\ x <- [0..3] , y <- [0..x]]"
		]
		,PCH
			(TS "ZF-expression: a well-know sort.")
			[
			[],
			TS "sort:: [a] -> [a] | Ord a",
			TS "sort []      = []",
			TS "sort [p:ps]  = sort [x \\\\ x<-ps | x<=p] ++ [p] ++ sort [x \\\\ x<-ps | x>p]"
		],PCH
			(TS "ZF-expression sorting a strict (head and tail strict) list.")
			[
			[],
			TS "ssort:: [!a!] -> [!a!] | Ord a",
			TS "ssort [!!]       = [!!]",
			TS "ssort [!p:ps!]   = ssort [!x \\\\ x<|-ps |x<=p!] ++ [!p!] ++ ssort [!x \\\\ x <|-ps | x>p!]"
		],PCH
			(TS "Overloaded ZF-expression sorting any list (lazy, strict or unboxed).")
			[
			[],
			TS "gsort:: (l a) -> (l a) | Ord a & List l a",
			TS "gsort [|]        = [|]",
			TS "gsort [|p:ps]    = gsort [|x \\\\ x<|-ps | x<=p] ++ [|p] ++ gsort [|x \\\\ x <|-ps | x>p]"
		],PCH
			(TS "ZF-expression: converting an array into a list.")
			[
			[],
			TS "ArrayA = {1,2,3,4,5}",
			[],
			TS "ListA:: [a]",
			TS "ListA = [a \\\\ a <-: ArrayA]"
		],P(
			TS "Local definitions can be introduced in a ZF expression after generator(s) using " TAT "," TA " " TABCr "let" TA ":"
		),ST [
			[TS "Qualifier",		TS_E,	TS "Generators { " TAT "," TA " " TABCr "let" TA " " TABCb "{" TA " {LocalDef}+ " TABCb "}" TA " } {" TAT "|" TA "Guard}"]
		],P(
			TS "The variables introduced in this way can be used in the guard and local definitions, other qualifiers that follow, and the expression before the "
			TAC "\\\\" TA "."
		),H3
			"4.2.2" "List Patterns"
		,P(
			TS "An object of the predefined algebraic type " TAI "list"
			TA " can be specified as pattern in a function, case expression or list generator."
		),ST2 [
			[TS "ListPattern",		TS_E,	TST "[" TA "[ListKind][{LGraphPattern}-list [" TAT ":" TA " GraphPattern]] [SpineStrictness]" TAT "]",
																	[]],
			[TS "LGraphPattern",	TS_E,	TS "GraphPattern",		[]],
			[[],					TS_B,	TS "CharsDenotation",	[]],
			[TS "ListKind",			TS_E,	TST "!",				TS "// head strict list"],
			[[],					TS_B,	TST "#",				TS "// unboxed head strict list"],
			[[],					TS_B,	TST "|",				TS "// overloaded list"],
			[TS "SpineStrictness",	TS_E,	TST "!",				TS "// spine strict list"]
		],S(
			"Notice that only simple list patterns can be specified (one cannot use a dot-dot expression or list comprehension to define a list pattern)."
		)];
	= make_page pdf_i pdf_shl;

page_4_7 :: !{!CharWidthAndKerns} -> Page;
page_4_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS ("Use of list patterns, use of guards, use of variables to identify patterns and sub-patterns; merge merges two (sorted) "+++
						  "lazy lists into one (sorted) list."))
			(map color_keywords [
			[],
			TS "merge:: [Int] [Int] -> [Int]",
			TS "merge f []   = f",
			TS "merge [] s   = s",
			TS "merge f=:[x:xs] s=:[y:ys]",
			TS "| x<y        = [x:merge xs s]",
			TS "| x==y       = merge f ys",
			TS "| otherwise  = [y:merge f ys]"
		]),PCH
			(TSC "merge_u" TA " merges two (sorted) head strict unboxed lists into one strict unboxed (sorted) list.")
			(map color_keywords [
			[],
			TS "merge_u:: [#Int] [#Int] -> [#Int]",
			TS "merge_u f [#] = f",
			TS "merge_u [#] s = s",
			TS "merge_u f=:[#x:xs] s=:[#y:ys]",
			TS "| x<y         = [#x:merge_u xs s]",
			TS "| x==y        = merge_u f ys",
			TS "| otherwise   = [#y:merge_u f ys]"
		]),PCH
			(TSC "merge_l" TA (" merges two (sorted) lists into one (sorted) list. Any list (lazy, strict or unboxed) can be merged, but both lists "+++
										"have to be the same (both lazy, strict, head strict, tail strict or unboxed)"))
			(map color_keywords [
			[],
			TS "merge_l:: (l a)(l a) -> (l a) | List l a",
			TS "merge_l f [|] = f",
			TS "merge_l [|] s = s",
			TS "merge_l f=:[|x:xs] s=:[|y:ys]",
			TS "| x<y         = [|x:merge_l xs s]",
			TS "| x==y        = merge_l f ys",
			TS "| otherwise   = [|y:merge_l f ys]"
		]),H2
			"4.3" "Tuples"
		,P(
			TS "A " TAI "tuple"
			TA (" is an algebraic data type predefined for reasons of programming convenience and efficiency. Tuples have as "+++
				"advantage that they allow bundling a ")
			TAI "finite number" TA " of objects of " TAI "arbitrary type"
			TA (" into a new object without being forced to define a new algebraic type for such a new object. "+++
				"This is in particular handy for functions that return several values.")
		),H3
			"4.3.1" "Creating Tuples"
		,P(
			TSI "Tuples" TA (" can be created that can be used to combine different (sub-)graphs into one data structure without being forced to "+++
				"define a new type for this combination. The elements of a tuple need ") TAI "not"
			TA " be of the same type. Tuples are in particular handy for functions that return multiple results."
		),ST [
			[TS "Tuple",	TS_E,	TST "(" TA "GraphExpr" TAT "," TA "{GraphExpr}-list" TAT ")"]
		],PCH
			(TS "Example of a Tuple of type " TAC "(String,Int,[Char])" TA ".")
			[
				[],
				TS "(\"this is a tuple with\",3,['elements'])"
		],MP [
			[],
			TS ("One can turn a lazy tuple element into a strict one by putting strictness annotations in the corresponding type instance on "+++
				"the tuple elements that one would like to make strict. When the corresponding tuple is put into a strict context the tuple "+++
				"and the strict annotated tuple elements will be evaluated. As usual one has to take care that these elements do not "+++
				"represent an infinite computation."),
			[],
			TS "Strict and lazy tuples are regarded to be of different type. "
			TAI "However, unlike is the case with any other data structure, the compiler will automatically convert strict tuples into lazy ones, and the other way around."
			TA (" This is done for programming "+++
				"convenience. Due to the complexity of this automatic transformation, the conversion is done for tuples only! For the "+++
				"programmer it means that he can freely mix tuples with strict and lazy tuple elements. The type system will not complain "+++
				"when a strict tuple is offered while a lazy tuple is required. The compiler will automatically insert code to convert non-"+++
				"strict tuple elements into a strict version and backwards whenever this is needed.")
		]
		];
	= make_page pdf_i pdf_shl;

page_4_8 :: !{!CharWidthAndKerns} -> Page;
page_4_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of a complex number as tuple type with strict components.")
			(map color_keywords [
			[],
			TS "::Complex :== (!Real,!Real)",
			[],
			TS "(+) infixl 6:: !Complex !Complex -> Complex",
			TS "(+) (r1,i1) (r2,i2) = (r1+r2,i1+i2)",
			[]
		]),CPCH
			(TS "which is equivalent to")
			(map color_keywords [
			[],
			TS "(+) infixl 6:: !(!Real,!Real) !(!Real,!Real) -> (!Real,!Real)",
			TS "(+) (r1,i1) (r2,i2) = (r1+r2,i1+i2)",
			[]
		]),CPCH
			(TS "when for instance G is defined as")
			[
			[],
			TS "G:: Int -> (Real,Real)",
			[]
		],CPCH
			(TS "than the following application is approved by the type system:")
			[
			[],
			TS "Start = G 1 + G",
			[]
		],H3
			"4.3.2" "Tuple Patterns"
		,P(
			TS "An object of the predefined algebraic type " TAI "tuple"
			TA " can be specified as pattern in a function, case expression or list generator."
		),ST [
			[TS "TuplePattern",	TS_E,	TS "(GraphPattern,{GraphPattern}-list)"]
		],PCH
			(TS "Example of the use of a pattern match on Tuples to access components of a Complex number.")
			(map syntax_color [
					[],
					TS ":: complex :== (Real,Real)         // complex is defined as type synonym for (real,Real)",
					[],
					TS "realpart:: Complex -> Real",
					TS "realpart (re,_) = re               // selecting the real part of a Complex number",
					[],
					TS "imagpart:: Complex -> Real",
					TS "imagpart (_,im) = im               // selecting the imaginary part of a Complex number"
		]),H2
			"4.4" "Arrays"
		,MP [
			[],
			TS "An " TAI "array" TA " is an algebraic data type predefined for reasons of efficiency. Arrays contain a "
			TAI "finite number" TA " of elements that all have to be of the " TAI "same type"
			TA ". An array has as property that its elements can be accessed via " TAI "indexing" TA " in "
			TAI "constant time" TA ". An " TAI "array index" TA " must be an integer value between "
			TAC "0" TA " and the number of elements of the array-" TAC "1"
			TA (". Destructive update of array elements is possible thanks to uniqueness typing. For programming convenience special syntax is provided for "+++
				"the creation, selection and updating of array elements (array comprehensions) while there is also special syntax for ")
			TAI "strings"
			TA (" (i.e. unboxed arrays of characters). Arrays have as disadvantage that their use increases the possibility of a runtime error "+++
				"(indices that might get out-of-range)."),
			[],
			TS ("To obtain optimal efficiency in time and space, arrays are implemented different depending on the concrete type of the "+++
				"array elements. By default an array is implemented as a ") TAI "lazy array" TA " (type " TAC "{a}"
			TA ("), i.e. an array consists of a contiguous block of memory containing pointers to the array elements. "+++
				"The same representation is chosen if ") TAI "strict arrays" TA " (define its type as " TAC "{!a})"
			TA " are being used. The difference is that " TAI "all"
			TA (" elements of a strict array will be evaluated if the array is evaluated. It makes no sense to make a distinction between "+++
				"head strictness and tail strictness for arrays as is the case for lists. As usual one has to take care that the strict "+++
				"elements do not represent an infinite computation."),
			[],
			TS "For elements of basic type, record type and tuple type an " TAI "unboxed array" TA " (define its type as " TAC "{#a}"
			TA (") can be used. In that latter case the pointers are replaced by the array elements themselves. "+++
				"Lazy, strict and unboxed arrays are considered  to be objects of different type. However, most predefined "+++
				"operations on arrays are overloaded such that they can be used on lazy, on strict as well as on unboxed arrays.")
		],ST2 [
			[TS "ArrayType",	TS_E,	TST "{" TA "[ArrayKind] Type" TAT "}",	[]],
			[TS "ArrayKind",	TS_E,	TST "!",								TS "// strict array"],
			[[],				TS_B,	TST "#",								TS "// unboxed array"]
		]
		];
 	= make_page pdf_i pdf_shl;

page_4_9 :: !{!CharWidthAndKerns} -> Page;
page_4_9 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3
			"4.4.1" "Creating Arrays and Selection of field Elements"
		,MP [
			[],
			TS "An " TAI "array" TA " is a tuple/record-like data structure in which " TAI "all" TA " elements are of the "
			TAI "same type" TA ". Instead of selection by position or field name the elements of an array can be selected very efficiently in "
			TAI "constant time" TA " by indexing. The update of arrays is done destructively in CLEAN and therefore arrays have to be unique ("
			TAL "see Chapter 9"
			TA (") if one wants to use this feature. Arrays are very useful if time and space consumption is becoming very critical "+++
				"(CLEAN arrays are implemented very efficiently). If efficiency is not a big issue we recommend ")
			TAI "not"
			TA (" to use arrays but to use lists instead: lists induce a much "+++
				"better programming style. Lists are more flexible and less error prone: array elements can only be accessed via indices "+++
				"and if you make a calculation error, indices may point outside the array bounds. This is detected, but only at run-time. In "+++
				"CLEAN, array indices always start with 0. More dimensional arrays (e.g. a matrix) can be defined as an array of arrays."),
			[],
			TS "For efficiency reasons, arrays are available of several types: there are "TAI "lazy arrays" TA " (type " TAC "{a}" TA "), "
			TAI "strict arrays" TA " (type " TAC "{!a}" TA ") and " TAI "unboxed arrays" TA " (e.g. type" TAC "{#Int}"
			TA "). All these arrays are considered to be of " TAI "different"
			TA " type. By using the overloading mechanism (type constructor classes) one can still define (overloaded) functions that work on any of these arrays."
		],ST [
			[TS "Array",	TS_E,	TS "ArrayDenotation"],
			[[],			TS_B,	TS "ArrayUpdate"],
			[[],			TS_B,	TS "ArrayComprehension"]
		],N
		,SP(
			TS "All elements of an array need to be of same type."
		),N
		,H3T "Simple Array"
		,P(
			TS "A new array can be created in a number of ways. A direct way is to simply " TAI "list" TA " the "
			TAI "array elements" TA "."
		),ST [
			[TS "ArrayDenotation",	TS_E,	TST "{" TA "[ArrayKind] {GraphExpr}-list" TAT "}"],
			[[],					TS_B,	TS "StringDenotation"]
		],ST [
			[TS "StringDenotation",	TS_E,	TS "StringDel{AnyChar/StringDel}StringDel"],
			[TS "StrignDel",		TS_E,	TST "\""]
		],MP [
			[],
			TS ("By default this array denotation is overloaded. The type determines "+++
				"whether a lazy, strict or unboxed array is created. The created array is ")
			TAI "unique" TA " (the " TAC "*" TA" or " TAC "."
			TA " attribute in front of the type, " TAL "see Chapter 9" TA ") to make destructive updates possible.",
			[],
			TS ("A lazy array is a box with pointers pointing to the array elements. One can also create a strict array "+++
				"by adding a ") TAC "!" TA " after " TAC "{" TA " (or explicitly define its type as " TAC "{!Int}"
			TA ("), which will have the property that the elements to which the array box points will always be evaluated. "+++
				"One can furthermore create an unboxed array by adding a ") TAC "#" TA " (or explicitly define its type as "
			TAC "{#Int}"
			TA ("), which will have the property that the evaluated elements (which have to be of basic value) are stored directly "+++
				"in the array box itself. Clearly the last one is the most efficient representation (")
			TAL "see also Chapter 10" TA ")."
		],PCH
			(TS "Creating a lazy array, strict and unboxed unique array of integers with elements 1,3,5,7,9.")
			(map comment_blue [
			[], 
			TS "MyLazyArray:: .{Int}",
			TS "MyLazyArray = {1,3,5,7,9}   // overloaded array denotation",
			[],
			TS "MyStrictArray:: .{!Int}",
			TS "MyStrictArray = {!1,3,5,7,9}",
			[],
			TS "MyUnboxedArray:: .{#Int}",
			TS "MyUnboxedArray = {#1,3,5,7,9}"
		]),PCH
			(TS "Creating a two dimensional array, in this case a unique array of unique arrays of unboxed integers.")
			[
			[],
			TS "MatrixA:: {.{#Int}}",
			TS "MatrixA = {{1,2,3,4},{5,6,7,8}}"
		],P(
			TS ("To make it possible to use operators such as array selection on any of these arrays (of actually "+++
				"different type) a multi parameter type constructor class has been defined (in ") TAC "StdArray"
			TA (") which expresses that \"some kind of array structure is "+++
				"created\". The compiler will therefore deduce the following general type:")
		),PC [
			TS "Array :: .(a Int)| Array a Int",
			TS "Array = {1,3,5,7,9}"
		]
		];
	= make_page pdf_i pdf_shl;

page_4_10 :: !{!CharWidthAndKerns} -> Page;
page_4_10 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS "A " TAI "string" TA " is predefined type which equivalent to an "
			TAI "unboxed array of characters" TA " " TAC "{#Char}" TA ". Notice that this array is "
			TAI "not" TA " unique, such that a destructive update of a string is " TAI "not"
			TA " allowed. There is special syntax to denote strings."
		),PCH
			(TS "Some ways to define a string, i.e. an unboxed array of character.")
			[
			[],
			TS "\"abc\"",
			TS "{'a','b','c'}"
		],P(
			TS ("There are a number of handy functions for the creation and manipulation of arrays predefined in CLEAN 's Standard "+++
				"Environment. These functions are overloaded to be able to deal with any type of array. The class restrictions for these "+++
				"functions express that \"an array structure is required\" containing \"an array element\".")
		),PCH
			(TS "Type of some predefined functions on " TAC "Arrays" TA ".")
			(map comment_blue [
			[],
			TS "createArray  :: !Int e ->.(a e) | Array a e             // size arg1, a.[i] = arg2",
			TS "size         :: (a e) -> Int | Array a                  // number of elements in array"
		]),N
		,H3T
			"Array Update and Array Comprehensions"
		,P(
			TS "It is also possible to construct a new array out of an existing one (a "
			TAI "functional array update" TA ")."
		),ST [
			[TS "ArrayUpdate",			TS_E,	TST "{" TA " ArrayExpr " TAT "&" TA " {ArrayIndex {Selection} " TAT "=" TA " GraphExpr}-list [" TAT "\\\\" TA " {Qualifier}-list]" TAT "}"],
			[TS "ArrayComprehension",	TS_E,	TST "{" TA "[ArrayKind] GraphExpr " TAT "\\\\" TA " {Qualifier}-list" TAT "}"],
			[TS "Selection",			TS_E,	TST "." TAC "FieldName"],
			[[],						TS_B,	TST "." TA "ArrayIndex"],
			[TS "ArrayExpr",			TS_E,	TS "GraphExpr"]
		],P(
			TS "Left from the " TAC "& (a & [i] = v" TA " is pronounced as: array " TAC "a"
			TA " with for " TAC "a.[i]" TA " the value " TAC "v"
			TA (". The old array has to be specified which has to be of unique type to make destructive updating possible. "+++
				"On the right from the ")
			TAC "&" TA (" those array elements are listed in which the new array differs from the old one. "+++
						"One can change any element of the array or any field or array element of a record or array "+++
						"stored in the array. The ") TAC "&" TA "-operator is strict in its arguments."
		),MSP [
			TS "An array expression must be of type array.",
			TS "The array expression to the left of the update operator '" TAC "&" TA "' should yield an object of type unique array.",
			TS "An array index must be an integer value between " TAC "0" TA " and the number of elements of the array-" TAC "1"
			TA ". An index out of this range will result in a " TAI "run-time" TA " error.",
			TS "Unboxed arrays can only be of basic type, record type or array type.",
			TSI "A unique array of any type created by an overloaded function cannot be converted to a non-unique array."
		],P(
			TSI "Important" TA ": For reasons of efficiency we have defined the updates only on arrays which are of "
			TAI "unique" TA " type (" TAC "*{..}" TA "), such that the update can always be done " TAI "destructively"
			TA " (!) which is semantically sound because the original unique array is known not to be used anymore."
		),PCH
			(TS "Creating an array with the integer elements 1,3,5,7,9 using the update operator.")
			[
			[],
			TS "{CreateArray 5 0 & [0] = 1, [1] = 3, [2] = 5, [3] = 7, [4] = 9}",
			TS "{CreateArray 5 0 & [1] = 3, [0] = 1, [3] = 7, [4] = 9, [2] = 5}"
		],MP [
			[],
			TS "One can use an " TAI "array comprehension"
			TA " to list these elements compactly in the same spirit as with a list comprehension (" TAL "see 4.2.1" TA ").",
			[],
			TS ("Array comprehensions can be used in combination with the update operator. Used in combination with the update "+++
				"operator the original uniquely typed array is updated destructively. The combination of array comprehensions and update "+++
				"operator makes it possible to selectively update array elements on a high level of abstraction.")
		],PCH
			(TS "Creating an array with the integer elements 1,3,5,7,9 using the update operator in combination with array and list comprehensions.")
			[
			[],
			TS "{CreateArray 5 0 & [i] = 2*i+1 \\\\ i <- [0..4]}",
			TS "{CreateArray 5 0 & [i] = elem \\\\ elem <-: {1,3,5,7,9} & i <- [0..4]}",
			TS "{CreateArray 5 0 & elem \\\\ elem <-: {1,3,5,7,9}}"
		]
		];
	= make_page pdf_i pdf_shl;

page_4_11 :: !{!CharWidthAndKerns} -> Page;
page_4_11 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[S(
			"Array comprehensions used without update operator automatically generate a whole new array. The size of this new "+++
			"array will be equal to the size of the first array or list generator from which elements are drawn. Drawn elements that are "+++
			"rejected by a corresponding guard result in an undefined array element on the corresponding position."
		),PCH
			(TS "Creating an array with the integer elements 1,3,5,7,9 using array and list comprehensions.")
			[
			[],
			TS "{elem \\\\ elem <-: {1,3,5,7,9}}",
			TS "{elem \\\\ elem <-  [1,3,5,7,9]}"
		]
		,PCH
			(TS ("Array creation, selection, update). The most general types have been defined. One can of course always "+++
							  "restrict to a more specific type."))
			[
			[],
			TS "MkArray:: !Int (Int -> e) ->.(a e) | Array a e",
			TS "MkArray i f = {f j \\\\ j <- [0..i-1]}",
			[],
			TS "SetArray:: *(a e) Int e ->.(a e) | Array a e",
			TS "SetArray a i v = {a & [i] = v}",
			[],
			TS "CA:: Int e ->.(a e) | Array a e",
			TS "CA i e = createArray i e",
			[],
			TS "InvPerm:: {Int} ->.{Int}",
			TS "InvPerm a = {CA (size a) 0 & [a.[i]] = i \\\\ i <- [0..maxindex a]}",
			[],
			TS "ScaleArray:: e (a e) ->.(a e) | Array a e & Arith e",
			TS "ScaleArray x a = {x * e \\\\ e <-: a}",
			[],
			TS "MapArray:: (a -> b) (ar a) ->.(ar b) | Array ar a & Array ar b",
			TS "MapArray f a = {f e \\\\ e <-: a}",
			[],
			TS "inner:: (a e) (a e) ->.(a e) | Array a e & Arith e",
			TS "inner v w",
			TS "| size v == size w    = {vi * wi \\\\ vi <-: v & wi <-: w}",
			TS "| otherwise           = abort \"cannot take inner product\"",
			[],
			TS "ToArray:: [e] ->.(a e) | Array a e",
			TS "ToArray list = {e \\\\ e <- list}",
			[],
			TS "ToList:: (a e) ->.[e] | Array a e",
			TS "ToList array = [e \\\\ e <-: array]"
		],PCH
			(TS "Example of operations on 2 dimensional arrays generating new arrays.")
			(map color_keywords [
			[],
			TS "maxindex n :== size n - 1",
			[],
			TS "Adj:: {{#Int}} ->.{.{#Int}}",
			TS "Adj ma = {{ma.[i,j] \\\\ i <- rowindex} \\\\ j <- colindex}",
			TS "    where",
			TS "    rowindex = [0..maxindex ma]",
			TS "    colindex = [0..maxindex ma.[0]]",
			[],
			TS "    Multiply:: {{#Int}} {{#Int}} ->.{.{#Int}}",
			TS "    Multiply a b =   {  {sum [a.[i,j]*b.[j,k] \\\\ j <- colindex] \\\\ k <- rowindex}",
			TS "                     \\\\ i <- rowindex",
			TS "                     }",
			TS "    where",
			TS "        rowindex = [0..maxindex a]",
			TS "        colindex = [0..maxindex a.[0]]"
		])
		];
	= make_page pdf_i pdf_shl;

page_4_12 :: !{!CharWidthAndKerns} -> Page;
page_4_12 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Updating unique arrays using a unique array selection.")
			[
			[],
			TS "MyArray:: .{#Real}",
			TS "MyArray = {1.5,2.3,3.4}",
			[],
			TS "ScaleArrayElem:: *{#Real} Int Real -> .{#Real}",
			TS "ScaleArrayElem ar i factor",
			TS "# (elem,ar) = ar![i]",
			TS "= {ar & [i] = elem*factor}",
			[],
			TS "Scale2DArrayElem:: {*{#Real}} (Int,Int) Real -> {.{#Real}}",
			TS "Scale2DArrayElem ar (i,j) factor",
			TS "# (elem,ar)       = ar![i].[j]",
			TS "= {ar & [i].[j]   = elem*factor}",
			[],
			TS "Scale2DArrayElem2:: {*{#Real}} (Int,Int) Real -> {.{#Real}}",
			TS "Scale2DArrayElem2 ar (i,j) factor",
			TS "# (elem,ar)       = ar![i,j]",
			TS "= {ar & [i,j]     = elem*factor}"
		],N
		,H3T "# with Array Update"
		,P (TSC "variable = {variable & " TA "updates" TAC "}" TA " after " TAC "#" TA " or " TAC "#!" TA " can be abbreviated to "
			TAC "variable & " TA "updates, by omitting " TAC "= {variable" TA " and " TAC "}" TA ".")
		,ST [
			[[],						TS_B,	TS "Variable " TAT "&" TA " {ArrayIndex {Selection} " TAT "=" TA " GraphExpr}-list [" TAT "\\\\" TA " {Qualifier}-list] " TABCb ";"]
		],S "For example"
		,PC [TS "# a & [i] = x"]
		,CPCH
			(TS "instead of")
			[TS "# a = {a & [i] = x}"]
		,P (TS "Multiple indices and fields are also possible, for example: (for record updates " TAL "see 5.2.1 below" TA ")")
		,PC [TS "# r & a.[i].x = y"]
		,CPCH
			(TS "instead of")
			[TS "# r = {r & a.[i].x = y}"]
		,N

		,H3T
			"Selection of an Array Element"
		,ST [
			[TS "ArraySelection",	TS_E,	TS " ArrayExpr" TAT "." TA "ArrayIndex {Selection}"],
			[[],					TS_B,	TS "[ArrayExpr" TAT "!" TA "ArrayIndex {Selection}"],
			[TS "ArrayIndex",		TS_E,	TST "[" TA "{IntegerExpr}-list" TAT "]"],
			[TS "IntegerExpr",		TS_E,	TS "GraphExpr"],
			[TS "Selection",		TS_E,	TST "." TAC "FieldName"],
			[[],					TS_B,	TST "." TA "ArrayIndex"]
		],P(
			TS "With an " TAI "array selection" TA " (using the '" TAC "." 
			TA "' symbol) one can select an array element. When an object " TAC "a" TA " is of type " TAC "Array"
			TA ", the " TAC "i" TA "th"
			TA " element can be selected (computed) via " TAC "a.[i]" TA ". Array selection is left-associative: "
			TAC "a.[i,j,k]" TA " means " TAC "((a.[i]).[j]).[k]"
			TA ". A \"unique\" selection using the '" TAC "!"
			TA ("' symbol returns a tuple containing the demanded array element and "+++
				"the original array. This type of array selection can be very handy for destructively updating of uniquely typed arrays "+++
				"with values that depend on the current contents of the array. Array selection binds more tightly (priority ")
			TAC "11" TA ") than application (priority " TAC "10" TA ")."
		),N
		,H3
			"4.4.2" "Array Patterns"
		,P(
			TS "An object of type " TAI "array"
			TA (" can be specified as pattern. Notice that only simple array patterns can be specified on the left-hand "+++
				"side (one cannot use array comprehensions). Only those array elements which contents one would like to use "+++
				"in the right-hand side need to be mentioned in the pattern.")
		),MSP [
			TS "All array elements of an array need to be of same type.",
			TS "An array index must be an integer value between " TAC "0" TA " and the number of elements of the array-" TAC "1"
			TA ". Accessing an array with an index out of this range will result in a " TAI "run-time" TA " error."
		]
		];
	= make_page pdf_i pdf_shl;

page_4_13 :: !{!CharWidthAndKerns} -> Page;
page_4_13 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "ArrayPattern",	TS_E,	TST "{" TA "{GraphPattern}-list" TAT "}"],
			[[],				TS_B,	TST "{" TA "{ArrayIndex " TAT "=" TA " Variable}-list"++TST "}"],
			[[],				TS_B,	TS "StringDenotation"]
		]
		,P(
			TS "It is allowed in the pattern to use an index expression in terms of the other formal arguments (of type "
			TAC "Int" TA ") passed to the function to make a flexible array access possible."
		),PCH
			(TS "Use of array patterns.")
			[
			[],
			TS "Swap:: !Int !Int !*(a e) ->.(a e) | Array a e",
			TS "Swap i j a=:{[i]=ai,[j]=aj} = {a & [i]=aj,[j]=ai}"
		],H2
			"4.5" "Predefined Type Constructors"
		,P(
			TS ("Predefined types can also be used in curried way. "+++
				"To make this possible a type constructor has been predefined for all predefined types of higher order kind (")
			TAL "see also 5.1.2" TA "). The kind " TAC "X" TA " stands for any so-called " TAI "first-order" 
			TA " type: a type expecting no further arguments ((" TAC "Int" TA ", " TAC "Bool" TA ", " TAC "[Int]"
			TA ", etcetera). All function arguments are of kind " TAC "X" TAC ". The kind " TAC "X -> X"
			TA "stands for a type that can be applied to a (first-order) type, which then yields another first-order type, "
			TAC "X -> X -> X" TA " expects two type arguments, and so on."
		),PC [
			TS "Int, Bool, [Int], Tree [Int]   :: X",
			TS "[], Tree, (,) Int, (->) a, {}  :: X -> X",
			TS "(,), (->)                      :: X -> X -> X",
			TS "(,,)                           :: X -> X -> X -> X"
		],ST2 [
			[TS "PredefinedTypeConstructor",	TS_E,	TST "[]",	TS "// list type constructor"],
			[[],								TS_B,	TST "[! ]",	TS "// head strict list type constructor"],
			[[],								TS_B,	TST "[ !]",	TS "// tail strict list type constructor"],
			[[],								TS_B,	TST "[!!]",	TS "// strict list type constructor"],
			[[],								TS_B,	TST "[#]",	TS "// unboxed head strict list type"],
			[[],								TS_B,	TST "[#!]",	TS "// unboxed strict list type"],
			[[],								TS_B,	TST "(" TA "{" TAT "," TA "}+" TAT ")",	TS "// tuple type constructor (arity >= 2)"],
			[[],								TS_B,	TST "{}",	TS "// lazy array type constructor"],
			[[],								TS_B,	TST "{!}",	TS "// strict array type constructor"],
			[[],								TS_B,	TST "{#}",	TS "// unboxed array type constructor"],
			[[],								TS_B,	TST "(->)",	TS "// arrow type constructor"]
		],PCH
			(TS "So, all predefined types can be written down in prefix notation as well, as follows:")
			[
			TS "[] a         is equivalent with [a]",
			TS "[! ] a       is equivalent with [!a]",
			TS "[ !] a       is equivalent with [a!]",
			TS "[!!] a       is equivalent with [!a!]",
			TS "[# ] a       is equivalent with [#a]",
			TS "[#!] a       is equivalent with [#a!]",
			TS "(,) a b      is equivalent with (a,b)",
			TS "(,,) a b c   is equivalent with (a,b,c) and so on for n-tuples",
			TS "{} a         is equivalent with {a}",
			TS "{!} a        is equivalent with {!a}",
			TS "{#} a        is equivalent with {#a}",
			TS "(->) a b     is equivalent with (a -> b)"
		],H2
			"4.6" "Arrow Types"
		,P(
			TS "The " TAI "arrow type" TA " is a predefined type constructor used to indicate " TAI "function objects"  
			TA "(these functions have at least arity one). One can use the Cartesian product (uncurried version) to denote the function type ("
			TAL "see 3.7"
			TA ") to obtain a compact notation. Curried functions applications and types are automatically converted to their uncurried equivalent versions."
		),ST [
			[TS "ArrowType",	TS_E,	TST "(" TA "Type " TAT "->" TA " Type" TAT ")"]
		],PCH
			(TS "Example of an arrow type.")
			[
			[],
			TS "((a b -> c) [a] [b] -> [c])",
			[]
		],CPCH
			(TS "being equivalent with:")
			[
			[],
			TS "((a -> b -> c) -> [a] -> [b] -> [c])"
		]
		];
	= make_page pdf_i pdf_shl;

page_4_14 :: !{!CharWidthAndKerns} -> Page;
page_4_14 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2
			"4.7" "Predefined Abstract Types"
		,MP [
			[],
			TSI "Abstract data types" TA " are types of which the actual definition is hidden (" TAL "see 5.4" 
			TA "). In CLEAN the types " TAC "World" TA " and " TAC "File" TA " are " TAI "predefined abstract data types"
			TA (". They are recognised by the compiler and treated specially, either for efficiency or "+++
				"because they play a special role in the language. Since the actual definition is hidden it is not possible to denotate "+++
				"constant values of these predefined abstract types. There are functions predefined in the CLEAN library for the creation "+++
				"and manipulation of these predefined abstract data types. Some functions work (only) on unique objects."),
			[],
			TS "An object of type " TAC "*World" TA" (" TAC "*"
			TA " indicates that the world is unique) is automatically created when a program is started. This object is optionally given as argument to the "
			TAC "Start" TA " function  (" TAL "see 2.3"
			TA "). With this object efficient interfacing with the outside world (which is indeed unique) is possible.",
			[],
			TS "An object of type " TAC "File" TA " or " TAC "*File" TA " (unique " TAC "File"
			TA ") can be created by means of the functions defined in " TAC "StdFileIO"
			TA " (see CLEANs Standard Library). It makes direct manipulation of persistent data possible. The type "
			TAC "File" TA " is predefined for reasons of efficiency: CLEAN "
			TAC "Files" TA " are directly coupled to concrete files."	
		],P(
			TS ("The type String is a predefined synonym type that is predefined for convenience. "+++
			 "The type is synonym for an unboxed array of characters ") TAC "{#Char}" TA "."
		),ST2 [
				[TS "PredefType",	TS_E,	TST "World",	TS "// see " TAC "StdWorld.dcl"],
				[[],				TS_B,	TST "File",		TS "// see " TAC "StdFileIO.dcl"],
				[[],				TS_B,	TST "String",	TS "// synonym for {#Char}"]
		]
		];
	= make_page pdf_i pdf_shl;
