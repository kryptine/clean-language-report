implementation module clean_manual_syntax;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

pages_a :: [{!CharWidthAndKerns} -> Page];
pages_a = [page_a_1,page_a_2,page_a_3,page_a_4,page_a_5,page_a_6,page_a_7,page_a_8];

separate_by :: ![Text] ![[Text]] -> [[Text]];
separate_by s l=:[e] = l;
separate_by s [e:l] = [e,s:separate_by s l];

concat_with_separator :: ![Text] ![[Text]] -> [Text];
concat_with_separator s l=:[e] = e;
concat_with_separator s [e:l] = e++s++concat_with_separator s l;

page_a_1 :: !{!CharWidthAndKerns} -> Page;
page_a_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Appendix A" "Context-Free Syntax Description"
		,MP [
			[],
			TS "In this appendix the context-free syntax of CLEAN is given. Notice that the layout rule (" TAL "see 2.3.3"
			TA ") permits the omission of the semi-colon (';') which ends a definition and of the braces ('{' and '}') which are used to group a list of definitions.",
			[],
			TS "The following notational conventions are used in the context-free syntax descriptions:"
		],T [
			[TS "[notion]",				TS "means that the presence of notion is optional"],
			[TS "{notion}",				TS "means that notion can occur zero or more times"],
			[TS "{notion}+",			TS "means that notion occurs at least once"],
			[TS "{notion}-" TAI "list",	TS "means one or more occurrences of notion separated by commas"],
			[TST "terminals",			TS "are printed in " TAT "9 pts courier bold brown"],
			[TSBCr "keywords",			TS "are printed in " TABCr "9 pts courier bold red"],
			[TSBCb "terminals",			TS "that can be left out in layout mode are printed in " TABCb "9 pts courier bold blue"],
			[TS "{notion}/ str",		TS "means the longest expression not containing the string str"]
		],H2
			"A.1" "Clean Program"
		,ST [
		// same as in 2.2
			[TS "CleanProgram",			TS_E,	TS "{Module}+"],
			[TS "Module",				TS_E,	TS "DefinitionModule"],
			[[],						TS_B,	TS "ImplementationModule"],
			[TS "DefinitionModule", 	TS_E,	TSBCr "definition module" TA " " TAC "ModuleName" TA " ;"],
			[[],						[],		TS "{DefDefinition}"],
			[[],						TS_B,	TSBCr "system module" TA " " TAC "ModuleName" TA " ;"],
			[[],						[],		TS "{DefDefinition}"],
			[TS "ImplementationModule",	TS_E,	TS "[" TABCr"implementation" TA "] " TABCr "module" TA " " TAC "ModuleName" TA " ;"], 
			[[],						[],		TS "{ImplDefinition}"]
		],ST2 [
			[TS "ImplDefinition",	TS_E,TS "ImportDef",		TS "// " TAL "see A.2"],
			[[],					TS_B,TS "FunctionDef",		TS "// " TAL "see A.3"],
			[[],					TS_B,TS "GraphDef",			TS "// " TAL "see A.3"],
			[[],					TS_B,TS "MacroDef",			TS "// " TAL "see A.4"],
			[[],					TS_B,TS "TypeDef",			TS "// " TAL "see A.5"],
			[[],					TS_B,TS "ClassDef",			TS "// " TAL "see A.6"],
			[[],					TS_B,TS "GenericsDef",		TS "// " TAL "see A.7"],
			[[],					TS_B,TS "ForeignExportDef",	TS "// " TAL "see A.7"]
  		],ST2 [
			[TS "DefDefinition",	TS_E,TS "ImportDef",					TS "// " TAL "see A.2"],
			[[],					TS_B,TS "FunctionTypeDef",				TS "// " TAL "see A.3"],
			[[],					TS_B,TS "MacroDef",						TS "// " TAL "see A.4"],
			[[],					TS_B,TS "TypeDef",						TS "// " TAL "see A.5"],
			[[],					TS_B,TS "ClassDef",						TS "// " TAL "see A.6"],
			[[],					TS_B,TS "GenericExportDef",				TS "// " TAL "see A.6"]
  		]
	  	];
	= make_page pdf_i pdf_shl;

page_a_2 :: !{!CharWidthAndKerns} -> Page;
page_a_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2 "A.2" "Import Definition"
		,ST [
			[TS "ImportDef",TS_E,TS "ImplicitImportDef"],
			[[],			TS_B,TS "ExplicitImportDef"]
  		],ST [
			[TS "ImplicitImportDef",	TS_E,	TSBCr "import" TA " {" TAC "ModuleName" TA"}-list " TACb ";"]
  		],ST [
			[TS "ExplicitImportDef",	TS_E,	TSBCr "from" TAC " ModuleName " TABCr "import" TA " {Imports}-list " TACb ";"],
			[TS "Imports",				TS_E,	TSC "FunctionName"],
			[[],						TS_B,	TST "::" TAC "TypeName" TA " [ConstructorsOrFields]"],
			[[],						TS_B,	TSBCr "class" TAC " ClassName" TA " [Members]"],
			[[],						TS_B,	TSBCr "instance" TAC " ClassName" TA " {TypeName}+"],
			[[],						TS_B,	TSBCr "generic" TA " " TAC "FunctionName"],
			[TS "ConstructorsOrFields",	TS_E,	TST "(..)"],
			[[],						TS_B,	TST "(" TA "{" TAC "ConstructorName" TA "}-list" TAT ")"],
			[[],						TS_B,	TST "{..}"],
			[[],						TS_B,	TST "{" TA "{" TAC "FieldName" TA"}-list"  TAT "}"],
			[TS "Members",				TS_E,	TST "(..)"],
			[[],						TS_B,	TST "(" TA "{" TAC "MemberName" TA "}-list" TAT ")"]
  		],H2
			"A.3" "Function Definition"
		,ST [
			[TS "FunctionDef",		TS_E,	TS "[FunctionTypeDef]"],
		 	[[],					[],		TS "DefOfFunction"]
		 ],ST [
		 	[TS "DefOfFunction",	TS_E,	TS "{FunctionAltDef "++TSb ";" TA "}+"],
		 	[[],					TS_B,	TS "ABCCodeFunctionDef"],
			[TS "FunctionAltDef", 	TS_E,	TS "Function {Pattern}"],
			[[],					[],		TS "{LetBeforeExpression}"],
			[[],					[],		TS "{{" TAT "|" TA " Guard} " TAT "=" TA "[" TAT ">" TA "] FunctionBody}+"],
			[[],					[],		TS "[LocalFunctionAltDefs]"]
		],ST [
			[TS "Function",			TS_E,	TSC "FunctionName"],
			[[],					TS_B,	TS "(" TAC "FunctionName" TA ")"]
		],ST [
			[TS "LetBeforeExpression",	TS_E,	TST "# " TA "{GraphDef}+"],
			[[],						TS_B,	TST "#!" TA "{GraphDef}+"]
		],ST [
			[TS "GraphDef",	TS_E,	TS "Selector " TAT "=" TA "[" TAT ":" TA "] GraphExpr " TABCb ";"],
			[TS "Selector",	TS_E,	TS "BrackPattern"]
		],ST [
			[TS "Guard",		TS_E,	TS "BooleanExpr"],
			[[],				TS_B,	TSBCr "otherwise"],
			[TS "BooleanExpr",	TS_E,	TS "GraphExpr"]
		],ST [
			[TS "FunctionBody",		TS_E,	TS "RootExpression "++TSb ";"],
			[[],					[],		TS "[LocalFunctionDefs]"]
  		],ST [
			[TS "RootExpression",	TS_E,	TS "GraphExpr"] 
		],ST [
			[TS "LocalFunctionAltDefs",	TS_E,	TS "[" TABCr "where" TA "] " TABCb "{" TA " {LocalDef}+ " TABCb "}"],
			[TS "LocalDef",				TS_E,	TS "GraphDef"],
			[[],						TS_B,	TS "FunctionDef"],
			[TS "LocalFunctionDefs",	TS_E,	TS "[" TABCr "with" TA "] " TABCb "{" TA " {LocalDef}+ " TABCb "}"]
		],ST [
			[TS "ABCCodeFunctionDef",	TS_E,	TS "Function {Pattern} " TAT "=" TA " " TABCr "code" TA " ["
			  TABCr "inline" TA "] " TABCb "{" TA " ABCInstructions " TABCb "}"]
		],H3
			"A.3.1" "Types of Functions"
		,ST [
			[TS "FunctionTypeDef",		TS_E,	TSC "FunctionName" TA " " TAT "::" TA " FunctionType " TABCb ";"],
			[[],						TS_B,	TST "(" TAC "FunctionName" TAT ")" TA " [Fix][Prec] [" TAT "::" TA" FunctionType] " TABCb ";"],
			[TS "FunctionType",			TS_E,	TS "[Type " TAT "->" TA "] Type [ClassContext] [UnqTypeUnEqualities]"],
			[TS "ClassContext",			TS_E,	TST "|" TA " ClassOrGenericName-list TypeVariable {" TAT "&" TA " ClassName-list TypeVariable }"],
			[TS "UnqTypeUnEqualities",	TS_E,	TS "{{UniqueTypeVariable}+ " TAT "<=" TA " UniqueTypeVariable}-list"],
			[TS "ClassOrGenericName",	TS_E,	TSC "ClassName"],
			[[],						TS_B,	TSC "FunctionName" TA " TypeKind"]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_3 :: !{!CharWidthAndKerns} -> Page;
page_a_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3 "A.3.2" "Patterns"
		,ST [
			[TS "Pattern",			TS_E,	TS "[Variable " TAT "=:" TA "] BrackPattern"],
			[TS "BrackPattern",		TS_E,	TS "PatternVariable"],
			[[],					TS_B,	TS "Constructor"],
			[[],					TS_B,	TST "(" TA "GraphPattern" TAT ")"], 
			[[],					TS_B,	TS "SpecialPattern"], 
			[[],					TS_B,	TS "DynamicPattern"]
		],ST [
			[TS "PatternVariable",	TS_E,	TS "Variable"],
			[[],					TS_B,	TS "_ "]
		],ST [
			[TS "Constructor",	TS_E,	TSC "ConstructorName"],
			[[],				TS_B,	TST "(" TAC "ConstructorName" TAT ")"]
		],ST [
			[TS "Constructor",	TS_E,	TSC "ConstructorName"],
			[[],				TS_B,	TST "(" TAC "ConstructorName" TAT ")"]
		],ST [
			[TS "GraphPattern",		TS_E,	TS "Constructor {Pattern}"],
			[[],					TS_B,	TS "GraphPattern " TAC "ConstructorName" TA " GraphPattern "],
			[[],					TS_B,	TS "Pattern "]
		],ST [
			[TS "SpecialPattern",	TS_E,	TS "BasicValuePattern"],
			[[],					TS_B,	TS "ListPattern"],
			[[],					TS_B,	TS "TuplePattern"],
			[[],					TS_B,	TS "ArrayPattern"],
			[[],					TS_B,	TS "RecordPattern"]
		],ST2 [
			[TS "BasicValuePattern",	TS_E,	TS "BasicValue",		[]],
			[TS "BasicValue",			TS_E,	TS "IntDenotation",		TS "// " TAL "see A.9"], 
			[[],						TS_B,	TS "RealDenotation",	TS "// " TAL "see A.9"],
			[[],						TS_B,	TS "BoolDenotation",	TS "// " TAL "see A.9"],
			[[],						TS_B,	TS "CharDenotation",	TS "// " TAL "see A.9"]
		],ST2 [
			[TS "ListPattern",		TS_E,	TST "[" TA "[ListKind][{LGraphPattern}-list [" TAT ":" TA " GraphPattern]] [SpineStrictness]" TAT "]",
																	[]],
			[TS "LGraphPattern",	TS_E,	TS "GraphPattern",		[]],
			[[],					TS_B,	TS "CharsDenotation",	TS "// " TAL "see A.9"]
		],ST [
			[TS "TuplePattern",	TS_E,	TS "(GraphPattern,{GraphPattern}-list)"]
		],ST [
			[TS "RecordPattern",	TS_E,	TST "{" TA "[TypeName " TAT "|" TA "] {" TAC "FieldName" TA " [" TAT "=" TA " GraphPattern]}-list" TAT "}"]
		],ST [
			[TS "ArrayPattern",	TS_E,	TST "{" TA "{GraphPattern}-list" TAT "}"],
			[[],				TS_B,	TST "{" TA "{ArrayIndex " TAT "=" TA " Variable}-list"++TST "}"],
			[[],				TS_B,	TS "StringDenotation"]
		],ST [
			[TS "DynamicPattern",			TS_E,	TST "(" TA "GraphPattern " TAT "::" TA " DynamicType" TAT ")"],
			[TS "DynamicType",				TS_B,	TS "{ DynPatternType}+"],
			[TS "DynPatternType",			TS_E,	TS "Type"],
			[[],							TS_B,	TS "TypePatternVariable"],
			[[],							TS_B,	TS "OverloadedTypePatternVariable"],
			[TS "TypePatternVariable",		TS_E,	TS "Variable"],
			[TS "OverloadedTypeVariable",	TS_E,	TS "Variable" TABCr "^"]
		],H3
			"A.3.3" "Graph Expressions"
		,ST [
			[TS "GraphExpr",	TS_E,	TS "Application"]
		],ST2 [
			[TS "Application",	TS_E,	TS "{BrackGraph}+",					[]],
			[[],				TS_B,	TS "GraphExpr Operator GraphExpr",	[]],
			[[],				TS_B,	TS "GenericAppExpr",				[]],
			[TS "Operator",		TS_E,	TSC "FunctionName",					TS "// " TAL "see A.8"],
			[[],				TS_B,	TSC "ConstructorName",				TS "// " TAL "see A.8"]
		]
		];
	= make_page pdf_i pdf_shl;

table_alt s = [[], TS_B, TS s];

page_a_4 :: !{!CharWidthAndKerns} -> Page;
page_a_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST2 [
			[TS "BrackGraph",	TS_E,	TS "GraphVariable"],
			table_alt "GraphVariable",
			table_alt "Constructor",
			table_alt "Function",
			table_alt "(GraphExpr)",
			table_alt "LambdaAbstr",
			table_alt "CaseExpr",
			table_alt "LetExpr",
			table_alt "SpecialExpression",
			table_alt "DynamicExpression"
		],ST2 [
			[TS "GraphVariable",TS_E,	TS "Variable",			TS "// " TAL "see A.8"],
			[[],				TS_B,	TS "SelectorVariable",	TS "// " TAL "see A.8"]
		],ST [
			[TS "LambdaAbstr",	TS_E,	TST "\\" TA " {Pattern} " TAT "= " TA " GraphExpr"],
			[[],				TS_B,	TST "\\" TA " {Pattern} " TAT "->" TA " GraphExpr"]
		],ST [
			[TS "CaseExpr",		TS_E,	TSBCr "case" TA " GraphExpr " TABCr "of"],
			[[],				[],		TSBCb "{" TA " {CaseAltDef}+ " TABCb "}"],
			[[],				TS_B,	TSBCr "if" TA " BrackGraph BrackGraph BrackGraph"],
			[TS "CaseAltDef",	TS_E,	TS "{Pattern}"],
			[[],				[],		TS "{{LetBeforeExpression}"], // double {{ ?
			[[],				[],		TS "{" TAT "|" TA " Guard} " TAT "=" TA " [" TAT ">" TA "] FunctionBody}+"],
			[[],				[],		TS "[LocalFunctionAltDefs]"],
			[[],				TS_B,	TS "{Pattern}"],
			[[],				[],		TS "{{LetBeforeExpression}"], // double {{ ?
			[[],				[],		TS "{" TAT "|" TA " Guard} " TAT "->" TA " FunctionBody}+"],
			[[],				[],		TS "[LocalFunctionAltDefs]"]
		],ST [
			[TS "LetExpression",	TS_E,	TSBCr "let" TA " " TABCb "{" TA " {LocalDef}+ " TABCb "}" TA " " TABCr "in" TA " GraphExpr"]
		], ST [
			[TS "SpecialExpression",	TS_E,	TS "BasicValue"],
			table_alt "List",
			table_alt "Tuple",
			table_alt "Array",
			table_alt "ArraySelection",
			table_alt "Record",
			table_alt "RecordSelection"
		],ST2 [
			[TS "List",				TS_E,	TS "ListDenotation",						[]],
			[[],					TS_B,	TS "DotDotExpression",						[]],
			[[],					TS_B,	TS "ZF-expression",							[]],
			[TS "ListDenotation",	TS_E,	TST "[" TA "[ListKind] [{LGraphExpr}-list [" TAT ":" TA " GraphExpr]] [SpineStrictness] " TAT "]",
																						[]],
			[TS "LGraphExpr",		TS_E,	TS "GraphExpr",								[]],
			[[],					TS_B,	TS "CharsDenotation",						TS "// " TAL "see A.9"],
			[TS "DotDotExpression",	TS_E,	TST "[" TA "[ListKind] GraphExpr [" TAT "," TA "GraphExpr]" TAT ".." TA "[GraphExpr] [SpineStrictness] " ++ TST "]",
																						[]],
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
			[TS "ArrayExpr",		TS_E,	TS "GraphExpr",								[]]
		],ST [
			[TS "Tuple",	TS_E,	TST "(" TA "GraphExpr" TAT "," TA "{GraphExpr}-list" TAT ")"]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_5 :: !{!CharWidthAndKerns} -> Page;
page_a_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST2 [
			[TS "Array",			TS_E,	TS "ArrayDenotation",									[]],
			[[],					TS_B,	TS "ArrayUpdate",										[]],
			[[],					TS_B,	TS "ArrayComprehension",								[]],
			[[],					TS_B,	TS "ArraySelection",									[]],
			[TS "ArrayDenotation",	TS_E,	TST "{" TA "[ArrayKind] {GraphExpr}-list" TAT "}",		[]],
			[[],					TS_B,	TS "StringDenotation",									TS "// " TAL "see A.9"],
			[TS "ArrayUpdate",		TS_E,	TST "{" TA " ArrayExpr " TAT "&" TA " {ArrayIndex {Selection} " TAT "=" TA " GraphExpr}-list [" TAT "\\\\" TA " {Qualifier}-list]" TAT "}",
																									[]],
			[TS "ArrayComprehension",TS_E,	TST "{" TA "[ArrayKind] GraphExpr " TAT "\\\\" TA " {Qualifier}-list" TAT "}",
																									[]],
			[TS "ArraySelection",	TS_E,	TS " ArrayExpr" TAT "." TA "ArrayIndex {Selection}",	[]],
			[[],					TS_B,	TS " ArrayExpr" TAT "!" TA "ArrayIndex {Selection}",	[]],
			[TS "Selection",		TS_E,	TST "." TAC "FieldName",								[]],
			[[],					TS_B,	TST "." TA "ArrayIndex",								[]],
			[TS "ArrayExpr",		TS_E,	TS "GraphExpr",											[]],
			[TS "ArrayIndex",		TS_E,	TST "[" TA "{IntegerExpr}-list" TAT "]",				[]],
			[TS "IntegerExpr",		TS_E,	TS "GraphExpr",											[]]
		],ST [
			[TS "Record",			TS_E,	TS "RecordDenotation"],
			[[],					TS_B,	TS "RecordUpdate"],
			[TS "RecordDenotation",	TS_E,	TST "{" TA "[TypeName" TAT "|" TA "] {" TAC "FieldName" TA " " TAT "=" TA " GraphExpr}-list]" TAT "}"],
			[TS "RecordUpdate",		TS_E,	TST "{" TA "[TypeName" TAT "|" TA "][RecordExpr " TAT "&" TA "][{" TAC "FieldName" TA " {Selection} = GraphExpr}-list]" TAT "}"],
			[TS "RecordExpr",		TS_E,	TS "GraphExpr"],
			[TS "RecordSelection",	TS_E,	TS "RecordExpr [" TAT "." TA "TypeName]" TAT "." TAC "FieldName" TA " {Selection}"],
			[[],					TS_B,	TS "RecordExpr [" TAT "." TA "TypeName]" TAT "!" TAC "FieldName" TA " {Selection}"]
		],ST [
			[TS "DynamicExpression"	,	TS_E,	TSBCr "dynamic" TA " GraphExpr [" TAT "::" TA " Type]"]
		],H2
			"A.4" "Macro Definition"
		,ST [
			[TS "MacroDef",			TS_E,	TS "[MacroFixityDef]"],
			[[],					[],	    TS "DefOfMacro"],
			[TS "MacroFixityDef",	TS_E,	TST "(" TAC "FunctionName" TAT ")" TA " [Fix][Prec] " TABCb ";"],
			[TS "DefOfMacro",		TS_E,	TS "Function {Variable} " TAT ":==" TA " FunctionBody " TABCb ";"],
			[[],					[],		TS "[LocalFunctionAltDefs]"]
		],H2
			"A.5" "Type Definition"
		,ST [
			[TS "TypeDef",	TS_E,	TS "AlgebraicTypeDef"],
			[[],			TS_B,	TS "RecordTypeDef"],
			[[],			TS_B,	TS "SynonymTypeDef"],
			[[],			TS_B,	TS "AbstractTypeDef"],
			[[],			TS_B,	TS "AbstractSynonymTypeDef"]
		],ST (let {
				dummy_columns = repeatn 6 [];
			} in [
			[TS "AlgebraicTypeDef",			TS_E,	TST "::" TA "TypeLhs",
			 TST "=" TA " ConstructorDef"]++dummy_columns,
			[[],							[],		[],
			 TS "{" TAT "|" TA " ConstructorDef} " TABCb ";"]
			 ++dummy_columns,
			[TS "ConstructorDef",			TS_E,	TS "[ExistentalQuantVariables] " TAC "ConstructorName" TA " {BrackType}",
			 []]++dummy_columns,
			[[],							TS_B,	TS "[ExistentalQuantVariables] (" TAC "ConstructorName" TA ") [Fix][Prec] {BrackType}",
			 []]++dummy_columns
		]),ST [
			[TS "TypeLhs",	TS_E,	TS "[" TAT "*" TA "] TypeConstructor",	TS "// " TAL "see A.8"],
			[[],			[],		TS "{TypeVariable}",					[]]
		],ST [
			[TS "ExistentalQuantVariables",	TS_E,	TST "E." TA "{TypeVariable }+" TAT ":"]
		],ST [
			[TS "Fix",	TS_E,	TSBCr "infixl"],
			[[],		TS_B,	TSBCr "infixr"],
			[[],		TS_B,	TSBCr "infix"]
		],ST [
			[TS "Prec",	TS_E,	TS "Digit",	TS "// " TAL "see A.8"]
		],ST [
			// [TS "BrackType",	TS_E,	TS "[UniversalQuantVariables] [Strict] [UnqTypeAttrib] SimpleType"]
			[TS "BrackType",	TS_E,	TS "[UniversalQuantVariables] [Strict] [UnqTypeAttrib] TypeExpression"]
		],ST [
			[TS "UniversalQuantVariables",	TS_E,	TST "A." TA "{TypeVariable }+" TAT ":"]
		],ST [
			[TS "Strict",	TS_E,	TST "!"]
		],ST [
			[TS "UnqTypeAttrib",	TS_E,	TST "*",							[]],
			[[],					TS_B,	TS "UniqueTypeVariable" TAT ":",	TS "// " TAL "see A.8"],
			[[],					TS_B,	TST ".",							[]]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_6 :: !{!CharWidthAndKerns} -> Page;
page_a_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "RecordTypeDef",	TS_E,
			 TST "::" TA "TypeLhs " TAT "=" TA " [ExistentalQuantVariables] [Strict] " TAT "{" TA "{" TAC "FieldName" TA " " TAT "::" TA "[Strict] Type}-list" TAT "}" TA " " TABCb ";"]
		],ST [
			[TS "Type",						TS_E,	TS "{BrackType}+"]
		],ST [
			[TS "SynonymTypeDef",	TS_E,	TST "::" TA "TypeLhs " TAT ":==" TA " [UniversalQuantVariables]Type " TABCb ";"]
		],ST [
			[TS "AbstractTypeDef",	TS_E,	TST "::" TA "TypeLhs " TABCb ";"]
		],ST [
			[TS "AbstractSynonymTypeDef",	TS_E,	TST "::" TA "TypeLhs " TAT "(:==" TA " [UniversalQuantVariables]Type " TAT ")" TA " " TABCb ";"]
		],H3
			"A.5.1" "Types Expression"
		,ST2 [
			// SimpleType ? not in manual ?
			[TS "TypeExpression",	TS_E,	TS "TypeVariable",				TS "// " TAL "see A.8"],
			[[],					TS_B,	TS "TypeConstructorName",		[]],
			[[],					TS_B,	TST "(" TA "Type" TAT ")",		[]],
			[[],					TS_B,	TS "PredefinedType",			[]],
			[[],					TS_B,	TS "PredefinedTypeConstructor",	[]]
		],ST [
			[TS "PredefinedType",	TS_E,	TS "BasicType"],
			[[],					TS_B,	TS "ListType"],
			[[],					TS_B,	TS "TupleType"],
			[[],					TS_B,	TS "ArrayType"],
			[[],					TS_B,	TS "ArrowType"],
			[[],					TS_B,	TS "PredefType"]
		],ST [
			[TS "BasicType",	TS_E,	TST "Int"],
			[[],				TS_B,	TST "Real"],
			[[],				TS_B,	TST "Char"],
			[[],				TS_B,	TST "Bool"]
		],ST2 [
			[TS "ListType",			TS_E,	TST "[" TA "[ListKind] Type [SpineStrictness]" TAT "]",	[]],
			[TS "ListKind",			TS_E,	TST "!",												TS "// head strict list"],
			[[],					TS_B,	TST "#",												TS "// head strict, unboxed list"],
			[TS "SpineStrictness",	TS_E,	TST "!",												TS "// tail (spine) strict list"]
		],ST [
			[TS "TupleType",	TS_E,	TST "(" TA "[Strict] Type" TAT "," TA "{[Strict] Type}-list" TAT ")"]
		],ST2 [
			[TS "ArrayType",	TS_E,	TST "{" TA "[ArrayKind] Type" TAT "}",	[]],
			[TS "ArrayKind",	TS_E,	TST "!",								TS "// strict array"],
			[[],				TS_B,	TST "#",								TS "// unboxed array"]
		],ST2 [
			[TS "PredefType",					TS_E,	TST "World",	TS "// see " TAC "StdWorld.dcl"],
			[[],								TS_E,	TST "File",		TS "// see " TAC "StdFileIO.dcl"],
			[[],								TS_B,	TST "String",	TS "// synonym for {#Char}"],
			[TS "PredefinedTypeConstructor",	TS_E,	TST "[]",		TS "// list type constructor"],
			[[],								TS_B,	TST "[! ]",		TS "// head strict list type constructor"],
			[[],								TS_B,	TST "[ !]",		TS "// tail strict list type constructor"],
			[[],								TS_B,	TST "[!!]",		TS "// strict list type constructor"],
			[[],								TS_B,	TST "[#]",		TS "// unboxed head strict list type"],
			[[],								TS_B,	TST "[#!]",		TS "// unboxed strict list type"],
			[[],								TS_B,	TST "(" TA "{" TAT "," TA "}+" TAT ")",	TS "// tuple type constructor (arity >= 2)"],
			[[],								TS_B,	TST "{}",		TS "// lazy array type constructor"],
			[[],								TS_B,	TST "{!}",		TS "// strict array type constructor"],
			[[],								TS_B,	TST "{#}",		TS "// unboxed array type constructor"],
			[[],								TS_B,	TST "(->)",		TS "// arrow type constructor"]
		],H2
			"A.6" "Class and Generic Definitions"
		,ST [
			[TS "ClassDef",	TS_E,	TS "TypeClassDef"],
			[[],			TS_B,	TS "TypeClassInstanceDef"]
		],ST [
			[TS "TypeClassDef",	TS_E,	TSBCr "class" TA " ClassName TypeVariable+ [ClassContext]"],
		    [[],				[],		TS "[[" TABCr "where" TA "] " TAT "{" TA " {ClassMemberDef}+ " TAT "}" TA "]"],
			[[],				TS_B,	TSBCr "class" TA " FunctionName TypeVariable+ " TAT "::" TA " FunctionType" TABCb ";"],
			[[],				TS_B,	TSBCr "class" TA " (FunctionName) [Fix][Prec] TypeVariable+ " TAT "::" TA " FunctionType" TABCb ";"]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_7 :: !{!CharWidthAndKerns} -> Page;
page_a_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "ClassMemberDef",	TS_E,	TS "FunctionTypeDef"],
			[[],					[],		TS "[MacroDef]"]
		],ST2 [
			[TS "TypeClassInstanceDef",	TS_E,	TSBCr "instance" TA " ClassName Type+ [ClassContext]",
			 []],
			[[],						[],		TS "[[" TABCr "where" TA "] " TAT "{" TA "{DefOfFunction}+ " TAT "}" TA "]",
			 TS "// in implementation modules"],
			[[],						[],		TS "[" TABCr "special" TA " {TypeVariable = Type}+]",
			 TS "// in definition modules"]
		],ST [
			[TS "GenericsDef",	TS_E,	TS "GenericDef ;"],
			[[],				TS_B,	TS "GenericCase;"],
			[[],				TS_B,	TS "DeriveDef ;"]
		],ST [
			[TS "GenericDef",		TS_E,	TSBCr "generic" TA " " TAC "FunctionName" TA " " TAC "TypeVariable" TA "+ " TAT "::" TA " FunctionType"],
			[TS "GenericCase",		TS_E,	TSC "FunctionName" TA " " TAT "{|" TA "GenericTypeArg" TAT "|}" TA " {Pattern}+ " TAT "=" TA " FunctionBody"],
			[TS "GenericTypeArg",	TS_E,	TS "GenericMarkerType [" TABCr "of" TA " Pattern]"],
			[[],					TS_B,	TSC "TypeConstructorName"],
			[[],					TS_B,	TSC "TypeVariable"],
			[TS "GenericMarkerType",TS_E,	TSBCr "CONS"],
			[[],					TS_B,	TSBCr "OBJECT"],
			[[],					TS_B,	TSBCr "RECORD"],
			[[],					TS_B,	TSBCr "FIELD"]
		],ST [
			[TS "DeriveDef",	TS_E,	TSBCr "derive" TA " "TAC "FunctionName" TA " " TAC "TypeConstructorName" TA "+"]
		],ST [
			[TS "GenericAppExpression",	TS_E,	TSC "FunctionName" TA "TypeKind GraphExpr"],
			[TS "TypeKind",				TS_E,	TST "{|* " TA "{" TAT "-> *" TA "} " TAT "|}"]
		],ST [
			[TS "GenericExportDef",	TS_E,	TS "GenericDef " TABCb ";"],
			[[],					TS_B,	TS "DeriveDef " TABCb ";"]
		],H2
			"A.7" "Foreign Export Definition"
		,ST [
			[TS "ForeignExportDef",	TS_E,	TSBCr "foreign export" TA " [ " TABCr "ccall" TA " | " TABCr "stdcall" TA " ] " TAC "FunctionName" TA " " TABCb";"]
		],H2
			"A.8" "Names"
		,ST [
			[TSC "ModuleName",			TS_E,TS "LowerCaseId",TS_B, TS "UpperCaseId",TS_B,TS "ModuleDirectoryName " TAT "." TA " ModuleName"],
			[TSC "ModuleDirectoryName",	TS_E,TS "LowerCaseId",TS_B, TS "UpperCaseId",[],[]],
			[TSC "FunctionName",		TS_E,TS "LowerCaseId",TS_B, TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "ConstructorName",		TS_E,[],[],					TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "SelectorVariable",	TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "Variable",			TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "MacroName",			TS_E,TS "LowerCaseId",TS_B,	TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "FieldName",			TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "TypeConstructorName",	TS_E,[],[],					TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "TypeVariable",		TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "UniqueTypeVariable",	TS_E,TS "LowerCaseId",TS "",[],[],[]],
			[TSC "ClassName",			TS_E,TS "LowerCaseId",TS_B,	TS "UpperCaseId",TS_B,TS "SymbolId"],
			[TSC "MemberName",			TS_E,TS "LowerCaseId",TS_B,	TS "UpperCaseId",TS_B,TS "SymbolId"]
		  ],ST [
			[TS "LowerCaseId",	TS_E, TS "LowerCaseChar~{IdChar}"],
			[TS "UpperCaseId",	TS_E, TS "UpperCaseChar~{IdChar}"],
			[TS "SymbolId",		TS_E, TS "{SymbolChar}+"]
		  ],ST [
			[TS "LowerCaseChar",TS_E]++separate_by TS_B [TST (toString c) \\ c<-['a'..'j']],
			[[],                TS_B]++separate_by TS_B [TST (toString c) \\ c<-['k'..'t']],
			[[],                TS_B]++separate_by TS_B [TST (toString c) \\ c<-['u'..'z']]++repeatn 8 [],
			[TS "UpperCaseChar",TS_E]++separate_by TS_B [TST (toString c) \\ c<-['A'..'J']],
			[[],                TS_B]++separate_by TS_B [TST (toString c) \\ c<-['K'..'T']],
			[[],                TS_B]++separate_by TS_B [TST (toString c) \\ c<-['U'..'Z']]++repeatn 8 [],
			[TS "SymbolChar",	TS_E,TST "~",TS_B,TST "@",TS_B,TST "#",TS_B,TST "$",TS_B,TST "%",TS_B,TST "^",TS_B,TST "?",TS_B,TST "!",[],[],[],[]],
			[[],				TS_B,TST "+",TS_B,TST "-",TS_B,TST "*",TS_B,TST "<",TS_B,TST ">",TS_B,TST"\\",TS_B,TST "/",TS_B,TST "|",TS_B,TST "&",TS_B,TST "="],
			[[],				TS_B,TST ":",[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
			[TS "IdChar",		TS_E,TS "LowerCaseChar",[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
			[[],				TS_B,TS "UpperCaseChar",[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]],
			[[],				TS_B,TS "Digit",[],[],[],[],[],[],[],[],[],[],[],[],TST "// " TAL "see A.9",[],[],[],[],[]],
			[[],				TS_B,TST "_",TS_B,TST "`",[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_8 :: !{!CharWidthAndKerns} -> Page;
page_a_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2
			"A.9" "Denotations"
		,ST2 [
			[TS "IntDenotation",	TS_E,	TS "[Sign]{Digit}+",							TS "// decimal number"],
			[[],					TS_B,	TS "[Sign]0{OctDigit}+",						TS "// octal number"],
			[[],					TS_B,	TS "[Sign]0x{HexDigit}+",						TS "// hexadecimal number"],
			[TS "Sign",				TS_B,	TS "+ | -",										[]],
			[TS "RealDenotation",	TS_E,	TS "[Sign]{Digit}+.{Digit}+[E[Sign]{Digit}+]",	TS ""],
			[TS "BoolDenotation",	TS_E,	TS "True | False",								[]],
			[TS "CharDenotation",	TS_E,	TS "CharDel AnyChar/CharDel CharDel",			[]],
			[TS "CharsDenotation",	TS_E,	TS "CharDel {AnyChar/CharDel}+ CharDel",		[]]
		],ST (let {
			n_extra_columns = 6;
			} in [
				[TS "AnyChar",		TS_E,concat_with_separator (TS " | ") [TS "IdChar",TS "ReservedChar",TS "Special"]]++repeatn (16+n_extra_columns) [],
				[TS "ReservedChar",	TS_E]++separate_by TS_B (map TST ["(",")","{","}","[","]",";",",","."])++repeatn n_extra_columns [],
				[TS "Special",		TS_E]++separate_by TS_B (map TST ["\\n","\\r","\\f","\\b"])++repeatn 3 []
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
			[TS "CharDel",		TS_E,	TS "'"],
			[TS "StringDel",	TS_E,	TS "\""]
		]
		];
	= make_page pdf_i pdf_shl;
