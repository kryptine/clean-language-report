implementation module clean_manual_lexical_syntax;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

separate_by :: ![Text] ![[Text]] -> [[Text]];
separate_by s l=:[e] = l;
separate_by s [e:l] = [e,s:separate_by s l];

concat_with_separator :: ![Text] ![[Text]] -> [Text];
concat_with_separator s l=:[e] = e;
concat_with_separator s [e:l] = e++s++concat_with_separator s l;

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
			[TS "Lexeme",		TS_E,	TS "ReservedKeywordOrSymbol",		TS "// " TAL "see Section B.4"],
			[[],				TS_B,	TS "ReservedChar",					TS "// " TAL "see Section B.3"],
			[[],				TS_B,	TS "Literal",						[]],
			[[],				TS_B,	TS "Identifier",					[]],
			[TS "Identifier",	TS_E,	TS "LowerCaseId",					TS "// " TAL "see A.9"],
			[[],				TS_B,	TS "UpperCaseId",					TS "// " TAL "see A.9"],
			[[],				TS_B,	TS "SymbolId",						TS "// " TAL "see A.9"],
			[TS "Literal",		TS_E,	TS "IntDenotation",					TS "// " TAL "see B.3"],
			[[],				TS_B,	TS "RealDenotation",				TS "// " TAL "see B.3"],
			[[],				TS_B,	TS "BoolDenotation",				TS "// " TAL "see B.3"],
			[[],				TS_B,	TS "CharDenotation",				TS "// " TAL "see B.3"],
			[[],				TS_B,	TS "CharsDenotation",				TS "// " TAL "see B.3"],
			[[],				TS_B,	TS "StringDenotation",				TS "// " TAL "see B.3"]
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
			[TS "AnyChar",			TS_E,	TS "IdChar",					TS "// " TAL "see A.9"],
			[[],					TS_B,	TS "ReservedChar",				[]],
			[[],					TS_B,	TS "SpecialChar",				[]]
		],H2
			"B.3" "Denotations"
		,ST2 [
			[TS "IntDenotation",	TS_E,TS "[Sign]{Digit}+",														TS "// decimal number"],
			[[],					TS_B,TS "[Sign]" TAT "0" TA "{OctDigit}+",										TS "// octal number"],
			[[],					TS_B,TS "[Sign]" TAT "0x" TA "{HexDigit}+",										TS "// hexadecimal number"],
			[TS "Sign",				TS_E,TST "+" TA " | " TAT "-",													[]],
			[TS "RealDenotation",	TS_E,TS "[Sign]{Digit}+" TAT "." TA "{Digit}+[" TAT "E" TA "[Sign]{Digit}+]",	TS ""],
			[TS "BoolDenotation",	TS_E,TST "True" TA " | " TAT "False",											[]],
			[TS "CharDenotation",	TS_E,TS "CharDel AnyChar/CharDel CharDel",										[]],
			[TS "StringDenotation",	TS_E,TS "StringDel{AnyChar/StringDel}StringDel",								[]],
			[TS "CharsDenotation",	TS_E,TS "CharDel {AnyChar/CharDel}+ CharDel",									[]]
		]
		];
	= make_page pdf_i pdf_shl;

page_b_2 :: !{!CharWidthAndKerns} -> Page;
page_b_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST (let {
			n_extra_columns = 6;
			} in [
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
				++[TS "// hexadecimal number "]++repeatn (6+n_extra_columns) [],
				[[],				TS_B,	TST "\\" TA "\IdChar"]++repeatn 9 []
				++[TS "// escape any other character "]++repeatn (6+n_extra_columns) []
		]),ST [
			[TS "Digit",	TS_E]++separate_by TS_B [TST (toString c) \\ c<-['0'..'9']],
			[TS "OctDigit",	TS_E]++separate_by TS_B [TST (toString c) \\ c<-['0'..'7']]++repeatn 4 [],
			[TS "HexDigit",	TS_E]++separate_by TS_B [TST (toString c) \\ c<-['0'..'9']],
			[[],			TS_B]++separate_by TS_B [TST (toString c) \\ c<-['A'..'F']]++repeatn 8 [],
			[[],			TS_B]++separate_by TS_B [TST (toString c) \\ c<-['a'..'f']]++repeatn 8 []
		 ],ST [
			[TS "CharDel",		TS_E,	TST "'"],
			[TS "StringDel",	TS_E,	TST "\""]
		],H2
			"B.4" "Reserved Keywords and Symbols"
		,P(
			TS ("Below the keywords and symbols are listed which have a special meaning in the language. Some symbols only have a "+++
				"special meaning in a certain context. Outside this context they can be freely used if they are not a reserved character (")
			TAL "see B.3" TA "). In the comment it is indicated for which context (name space) the symbol is predefined."
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
		])
	];
	= make_page pdf_i pdf_shl;

page_b_3 :: !{!CharWidthAndKerns} -> Page;
page_b_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST2 ([
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
			[TSBCr "special",					TS "// to create a specialized instance"],
			[TST "Bool",						TS "// type Boolean"],
			[TST "Char",						TS "// type character"],
			[TST "File",						TS "// type file"],
			[TST "Int",							TS "// type integer"],
			[TST "Real",						TS "// type real"],
			[TST "World",						TS "// type world"]
		]),ST2 [
			[TS "// in class  definitions:",	TS_B,	TSBCr "class",		TS "// begin of type class definition"],
			[[],								TS_B,	TSBCr "instance",	TS "// def of instance of a type class"],
			[[],								TS_B,	TSBCr "derive",		TS "// derive instance of generic function"]
		]
		];
	= make_page pdf_i pdf_shl;
