implementation module clean_manual_lexical_syntax;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

pages_b :: [{!CharWidthAndKerns} -> Page];
pages_b = [page_b_1,page_b_2,page_b_3];

page_b_1 :: !{!CharWidthAndKerns} -> Page;
page_b_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Appendix B" "Lexical Structure"
		,S (
			"In this appendix the lexical structure of CLEAN is given. It describes the kind of tokens recognised by the scanner/parser. "+++
			"In particular it summarizes the keywords, symbols and characters which have a special meaning in the language."
		),H2
			"B.1" "Lexical Program Structure"
		,S(
			"In this Section the lexical structure of CLEAN is given. It describes the kind of tokens recognised by the scanner/parser. In "+++
			"particular it summarizes the keywords, symbols and characters which have a special meaning in the language."
		),ST2 [
			[TS "LexProgram",	TS_E,	TS "{ Lexeme | {Whitespace}+ }",	[]],
			[TS "Lexeme",		TS_E,	TS "ReservedKeywordOrSymbol",		TS "// " TAL "see Section B.3"],
			[[],				TS_B,	TS "ReservedChar",					TS "// " TAL "see Section A.9"],
			[[],				TS_B,	TS "Literal",						[]],
			[[],				TS_B,	TS "Identifier",					[]],
			[TS "Identifier",	TS_E,	TS "LowerCaseId",					TS "// " TAL "see A.8"],
			[[],				TS_B,	TS "UpperCaseId",					TS "// " TAL "see A.8"],
			[[],				TS_B,	TS "FunnyId",						TS "// " TAL "see A.8"],
			[TS "Literal",		TS_E,	TS "IntDenotation",					TS "// " TAL "see A.9"],
			[[],				TS_B,	TS "RealDenotation",				TS "// " TAL "see A.9"],
			[[],				TS_B,	TS "BoolDenotation",				TS "// " TAL "see A.9"],
			[[],				TS_B,	TS "CharDenotation",				TS "// " TAL "see A.9"],
			[[],				TS_B,	TS "CharsDenotation",				TS "// " TAL "see A.9"],
			[[],				TS_B,	TS "StringDenotation",				TS "// " TAL "see A.9"]
		],ST2[
			[TS "Whitespace",	TS_E,	TS "space",		TS "// a space character"],
			[[],				TS_B,	TS "tab",		TS "// a horizontal tab"],
			[[],				TS_B,	TS "newline",	TS "// a newline char"],
			[[],				TS_B,	TS "formfeed",	TS "// a formfeed"],
			[[],				TS_B,	TS "verttab",	TS "// a vertical tab"],
			[[],				TS_B,	TS "Comment",	TS "// " TAL "see Section B.2"]
		],H2
			"B.2" "Comments"
		,ST2 [
			[TS "Comment",			TS_E,	TS "// AnythingTillNL newline",	[]],
			[[],					TS_B,	TS "/* AnythingTill/* Comment",	TS "// comments may be nested"],
			[[],					[],		TS "AnythingTill*/ */",			[]],
			[[],					TS_B,	TS "/* AnythingTill*/ */",		[]],
			[TS "AnythingTillNL",	TS_E,	TS "{AnyChar/ newline}",		TS "// no newline"],
			[TS "AnythingTill/*",	TS_E,	TS "{AnyChar/ /*}",				TS "// no \"/*\""],
			[TS "AnythingTill*/",	TS_E,	TS "{AnyChar/ */}",				TS "// no \"*/\""],
			[TS "AnyChar",			TS_E,	TS "IdChar",					TS "// " TAL "see A.8"],
			[[],					TS_B,	TS "ReservedChar",				[]],
			[[],					TS_B,	TS "Special",					[]]
  		]
		];
	= make_page pdf_i pdf_shl;

page_b_2 :: !{!CharWidthAndKerns} -> Page;
page_b_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2
			"B.3" "Reserved Keywords and Symbols "
		,P(
			TS ("Below the keywords and symbols are listed which have a special meaning in the language. Some symbols only have a "+++
				"special meaning in a certain context. Outside this context they can be freely used if they are not a reserved character (")
			TAL "see A.9" TA "). In the comment it is indicated for which context (name space) the symbol is predefined."
		),ST2 ([
			[TS "ReservedKeywordOrSymbol",	TS_E,	[],					[]],
			[TS "// in all contexts:",		TS "",	TST "/*",			TS "// begin of comment block"]
			]++map (\ [def,comment] -> [[],TS_B,def,comment])[
													[TST "*/",			TS "// end of comment block"],
													[TST "//",			TS "// rest of line is comment"],
													[TST "::",			TS "// begin of a type definition"],
													[TST ":==",			TS "// in a type synonym or macro definition"],
													[TST "=",			TS "// in a function, graph, alg type, rec field, case, lambda"],
													[TST "=:",			TS "// labeling a graph definition"],
													[TST "=>",			TS "// in a function definition"],
													[TST ";",			TS "// end of a definition (if no layout rule)"],
													[TSBCr "foreign",	TS "// begin of foreign export"]
		]),ST2 ([
			[TS "// in global definitions:",	TS_B,	TSBCr "from",			TS "// begin of symbol list for imports"]
			]++map (\ [def,comment] -> [[],TS_B,def,comment])[
														[TSBCr "definition",	TS "// begin of definition module,"],
														[TSBCr "implementation",TS "// begin of implementation module"],
														[TSBCr "import",		TS "// begin of import list"],
														[TSBCr "module",		TS "// in module header"],
														[TSBCr "system",		TS "// begin of system module"]
		]),ST2 ([
			[TS "// in function definitions:",	TS_B,	TST "->",	TS "// in a case expression, lambda abstraction"]
			]++map (\ [def,comment] -> [[],TS_B,def,comment])[
											[TST "[",				TS "// begin of a list"],
											[TST ":",				TS "// cons node"],
											[TST  "]",				TS "// end of a list"],
											[TST "\\\\",			TS "// begin of list or array comprehension"],
											[TST "<-",				TS "// list gen. in list or array comprehension"],
											[TST "<-:",				TS "// array gen. in list or array comprehension"],
											[TST "{",				TS "// begin of a record or array, begin of a scope"],
											[TST "}",				TS "// end of a record or array, end of a scope"],
											[TST ".",				TS "// a record or array selector"],
											[TST "!",				TS "// a record or array selector (for unique objects)"],
											[TST "&",				TS "// an update of a record or array, zipping gener."],
											[TSBCr "case",			TS "// begin of case expression"],
											[TSBCr "code",			TS "// begin code block in a syst impl. module"],
											[TSBCr "if",			TS "// begin of a conditional expression"],
											[TSBCr "in",			TS "// end of (strict) let expression"],
											[TSBCr "let",			TS "// begin of let expression"],
											[TST "#",				TS "// begin of let expression (for a guard)"],
											[TST "#!",				TS "// begin of strict let expression (for a guard)"],
											[TSBCr "of",			TS "// in case expression"],
											[TSBCr "where",			TS "// begin of local def of a function alternative"],
											[TSBCr "with",			TS "// begin of local def in a rule alternative"]
		]),ST2 ([
			[TS "// in type specifications:",	TS_B,	TST "!",	TS "// strict type"]
			]++map (\ [def,comment] -> [[],TS_B,def,comment])[
			[TST ".",							TS "// uniqueness type variable"],
			[TST "#",							TS "// unboxed type"],
			[TST "*",							TS "// unique type"],
			[TST ":",							TS "// in a uniqueness type variable definition"],
			[TST "->",							TS "// function type constructor"],
			[TST "[],[!],[!!],[#],[#!]",		TS "// lazy list, head strict, strict, unboxed, unboxed strict"],
			[TST "[|]",							TS "// overloaded list"],
			[TST "(,),(,,),(,,,),...",			TS "// tuple type constructors"],
			[TST "{},{!},{#}",					TS "// lazy, strict, unboxed array type constr."],
			[TSBCr "infix",						TS "// infix indication in operator definition"],
			[TSBCr "infixl",					TS "// infix left indication in operator definition"],
			[TSBCr "infixr",					TS "// infix right indication in operator definition"],
			[TST "Bool",						TS "// type Boolean"],
			[TST "Char",						TS "// type character"],
			[TST "File",						TS "// type file"],
			[TST "Int",							TS "// type integer"],
			[TST "Real",						TS "// type real"],
			[TST "World",						TS "// type world"]
		])
	];
	= make_page pdf_i pdf_shl;

page_b_3 :: !{!CharWidthAndKerns} -> Page;
page_b_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST2 [
			[TS "// in class  definitions:",	TS_B,	TSBCr "export",	TS "// to reveal which class instances there are"],
			[[],								TS_B,	TSBCr "class",		TS "// begin of type class definition"]
		],ST2 [
			[[],	TS_B,	TSBCr "derive",		TS "// derive instance of generic function"]
		],ST2 [
			[[],	TS_B,	TSBCr "special",	TS "// to create a specialized instance"],
			[[],	TS_B,	TSBCr "instance",	TS "// def of instance of a type class"]
		]
		];
	= make_page pdf_i pdf_shl;
