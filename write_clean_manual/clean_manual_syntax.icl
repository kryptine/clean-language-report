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
			[[],					TS_B,TS "FunctionExportTypeDef",		TS "// " TAL "see A.3"],
			[[],					TS_B,TS "MacroDef",						TS "// " TAL "see A.4"],
			[[],					TS_B,TS "TypeDef",						TS "// " TAL "see A.5"],
			[[],					TS_B,TS "ClassDef",						TS "// " TAL "see A.6"],
			[[],					TS_B,TS "GenericExportDef",				TS "// " TAL "see A.6"]
		],H2 "A.2" "Import Definition"
		,ST [
			[TS "ImportDef",TS_E,TS "ImplicitImportDef"],
			[[],			TS_B,TS "ExplicitImportDef"]
		],ST [
			[TS "ImplicitImportDef",	TS_E,	TSBCr "import" TA " [" TAT "qualified" TA "] {" TAC "ModuleName" TA"}-list " TACb ";"]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_2 :: !{!CharWidthAndKerns} -> Page;
page_a_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "ExplicitImportDef",	TS_E,	TSBCr "from" TAC " ModuleName " TABCr "import" TA " [" TAT "qualified" TA "] {Imports}-list " TACb ";"],
			[TS "Imports",				TS_E,	TSC "FunctionName"],
			[[],						TS_B,	TST "::" TAC "TypeName" TA " [ConstructorsOrFields]"],
			[[],						TS_B,	TSBCr "class" TA " " TAC "ClassName" TA " [Members]"],
			[[],						TS_B,	TSBCr "instance" TA " " TAC "ClassName" TA " {SimpleType}+"],
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
			[[],					[],		TS "{GuardAlt} {LetBeforeExpression} FunctionResult"],
			[[],					[],		TS "[LocalFunctionAltDefs]"],
			[TS "FunctionResult",	TS_E,	TST "=" TA "[" TAT ">" TA "] FunctionBody"],
			[[],					TS_B,	TST "|" TA " Guard GuardRhs"],
			[TS "GuardAlt",			TS_E,	TS "{LetBeforeExpression} " TAT "|" TA " BooleanExpr GuardRhs"],
			[TS "GuardRhs",			TS_E,	TS "{GuardAlt} {LetBeforeExpression} " TAT "=" TA " [" TAT ">" TA "] FunctionBody"],
			[[],					TS_B,	TS "{GuardAlt} {LetBeforeExpression} " TAT "|" TA " " TABCr "otherwise" TA " GuardRhs"]
		],ST [
			[TS "Function",			TS_E,	TSC "FunctionName"],
			[[],					TS_B,	TST "(" TAC "FunctionName" TAT ")"]
		],ST [
			[TS "LetBeforeExpression",	TS_E,	TST "# " TA "{GraphDefOrUpdate}+"],
			[[],						TS_B,	TST "#!" TA "{GraphDefOrUpdate}+"],
			[TS "GraphDefOrUpdate",		TS_E,	TS "GraphDef"],
			[[],						TS_B,	TSC "Variable" TA " " TAT "&" TA " {" TAC "FieldName" TA " {Selection} " TAT "=" TA" GraphExpr}-list " TABCb ";"],
			[[],						TS_B,	TSC "Variable" TA " " TAT "&" TA " {ArrayIndex {Selection} " TAT "=" TA " GraphExpr}-list [" TAT "\\\\" TA " {Qualifier}-list] " TABCb ";"]
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
			[[],						TS_B,	TST "(" TAC "FunctionName" TAT ")" TA " [FixPrec] [" TAT "::" TA" FunctionType] " TABCb ";"],
			[TS "FunctionType",			TS_E,	TS "[{ArgType}+ " TAT "->" TA "] Type [ClassContext] [UnqTypeUnEqualities]"],
			[TS "ClassContext",			TS_E,	TST "|" TA " ClassConstraints {" TAT "&" TA " ClassConstraints}"],
			[TS "ClassConstraints",		TS_E,	TS "ClassOrGenericName-list {SimpleType}+"],
			[TS "UnqTypeUnEqualities",	TS_E,	TS "{{" TAC "UniqueTypeVariable" TA "}+ " TAT "<=" TA " " TAC "UniqueTypeVariable" TA "}-list"],
			[TS "ClassOrGenericName",	TS_E,	TSC "ClassName"],
			[[],						TS_B,	TSC "FunctionName" TA " " TAT "{|" TA "TypeKind" TAT "|}"]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_3 :: !{!CharWidthAndKerns} -> Page;
page_a_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "FunctionExportTypeDef",TS_E,	TSC "FunctionName" TA " " TAT "::" TA " FunctionType [Special] " TABCb ";"],
			[[],						TS_B,	TST "(" TAC "FunctionName" TAT ")" TA " [FixPrec] " TAT "::" TA" FunctionType [Special] " TABCb ";"]
		],H3 "A.3.2" "Patterns"
		,ST [
			[TS "Pattern",			TS_E,	TS "[" TAC "Variable" TA " " TAT "=:" TA "] BrackPattern"],
			[TS "BrackPattern",		TS_E,	TS "PatternVariable"],
			[[],					TS_B,	TS "Constructor"],
			[[],					TS_B,	TST "(" TA "GraphPattern" TAT ")"], 
			[[],					TS_B,	TS "SpecialPattern"], 
			[[],					TS_B,	TS "DynamicPattern"]
		],ST [
			[TS "PatternVariable",	TS_E,	TSC "Variable"],
			[[],					TS_B,	TST "_"]
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
			[[],					TS_B,	TS "RecordPattern"],
			[[],					TS_B,	TS "UnitPattern"]
		],ST2 [
			[TS "BasicValuePattern",	TS_E,	TS "BasicValue",		[]],
			[TS "BasicValue",			TS_E,	TS "IntDenotation",		TS "// " TAL "see B.3"], 
			[[],						TS_B,	TS "RealDenotation",	TS "// " TAL "see B.3"],
			[[],						TS_B,	TS "BoolDenotation",	TS "// " TAL "see B.3"],
			[[],						TS_B,	TS "CharDenotation",	TS "// " TAL "see B.3"]
		],ST2 [
			[TS "ListPattern",		TS_E,	TST "[" TA "[ListKind][{LGraphPattern}-list [" TAT ":" TA " GraphPattern]] [SpineStrictness]" TAT "]",
																	[]],
			[TS "LGraphPattern",	TS_E,	TS "GraphPattern",		[]],
			[[],					TS_B,	TS "CharsDenotation",	TS "// " TAL "see B.3"]
		],ST [
			[TS "TuplePattern",	TS_E,	TST "(" TA "GraphPattern" TAT "," TA "{GraphPattern}-list" TAT ")"]
		],ST [
			[TS "RecordPattern",	TS_E,	TST "{" TA "[TypeName " TAT "|" TA "] {" TAC "FieldName" TA " [" TAT "=" TA " GraphPattern]}-list" TAT "}"]
		],ST [
			[TS "ArrayPattern",	TS_E,	TST "{" TA "{GraphPattern}-list" TAT "}"],
			[[],				TS_B,	TST "{" TA "{ArrayIndex " TAT "=" TA " " TAC "Variable" TA "}-list"++TST "}"],
			[[],				TS_B,	TS "StringDenotation"]
		],ST [
			[TS "UnitPattern",	TS_E,	TST "()"]
		],ST [
			[TS "DynamicPattern",			TS_E,	TST "(" TA "GraphPattern " TAT "::" TA " DynamicType" TAT ")"],
			[TS "DynamicType",				TS_E,	TS "[UnivQuantVariables] {DynPatternType}+ [ClassContext]"],
			[TS "DynPatternType",			TS_E,	TS "Type"],
			[[],							TS_B,	TS "TypePatternVariable"],
			[[],							TS_B,	TS "OverloadedTypePatternVariable"],
			[TS "TypePatternVariable",		TS_E,	TSC "Variable"],
			[TS "OverloadedTypeVariable",	TS_E,	TSC "Variable" TABCr "^"]
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
			table_alt "Constructor",
			table_alt "Function",
			table_alt "(GraphExpr)",
			table_alt "LambdaAbstr",
			table_alt "CaseExpr",
			table_alt "LetExpr",
			table_alt "SpecialExpression",
			table_alt "DynamicExpression",
			table_alt "MatchesPatternExpr"
		],ST2 [
			[TS "GraphVariable",TS_E,	TSC "Variable",			TS "// " TAL "see A.8"],
			[[],				TS_B,	TSC "SelectorVariable",	TS "// " TAL "see A.8"]
		],ST [
			[TS "LambdaAbstr",		TS_E,	TST "\\" TA " {Pattern}+ {LambdaGuardAlt} {LetBeforeExpression} LambdaResult"],
			[TS "LambdaResult",		TS_E,	TST "= " TA " GraphExpr"],
			[[],					TS_B,	TST "->" TA " GraphExpr"],
			[[],					TS_B,	TST "|" TA " Guard LambdaGuardRhs"],
			[TS "LambdaGuardAlt",	TS_E,	TS "{LetBeforeExpression} " TAT "|" TA " BooleanExpr LambdaGuardRhs"],
			[TS "LambdaGuardRhs",	TS_E,	TS "{LambdaGuardAlt} {LetBeforeExpression} LambdaGuardResult"],
			[TS "LambdaGuardResult",TS_E,	TST "= " TA " GraphExpr"],
			[[],					TS_B,	TST "->" TA " GraphExpr"],
			[[],					TS_B,	TST "|" TA " " TABCr "otherwise" TA " LambdaGuardRhs"]
		],ST [
			[TS "CaseExpr",			TS_E,	TSBCr "case" TA " GraphExpr " TABCr "of"],
			[[],					[],		TSBCb "{" TA " {CaseAltDef}+ " TABCb "}"],
			[[],					TS_B,	TSBCr "if" TA " BrackGraph BrackGraph BrackGraph"],
			[TS "CaseAltDef",		TS_E,	TS "{Pattern}"],
			[[],					[],		TS "{CaseGuardAlt} {LetBeforeExpression} CaseResult"],
			[[],					[],		TS "[LocalFunctionAltDefs]"],
			[TS "CaseResult",		TS_E,	TST "=" TA " [" TAT ">" TA "] FunctionBody"],
			[[],					TS_B,	TST "->" TA " FunctionBody"],
			[[],					TS_B,	TST "|" TA " Guard CaseGuardRhs"],
			[TS "CaseGuardAlt",		TS_E,	TS "{LetBeforeExpression} " TAT "|" TA " BooleanExpr CaseGuardRhs"],
			[TS "CaseGuardRhs",		TS_E,	TS "{CaseGuardAlt} {LetBeforeExpression} CaseGuardResult"],
			[TS "CaseGuardResult",	TS_E,	TST "=" TA " [" TAT ">" TA "] FunctionBody"],
			[[],					TS_B,	TST "->" TA " FunctionBody"],
			[[],					TS_B,	TST "|" TA " " TABCr "otherwise" TA " CaseGuardRhs"]
		],ST [
			[TS "LetExpression",	TS_E,	TSBCr "let" TA " " TABCb "{" TA " {LocalDef}+ " TABCb "}" TA " " TABCr "in" TA " GraphExpr"]
		], ST [
			[TS "SpecialExpression",	TS_E,	TS "BasicValue"],
			table_alt "List",
			table_alt "Tuple",
			table_alt "Array",
			table_alt "ArraySelection",
			table_alt "Record",
			table_alt "RecordSelection",
			table_alt "UnitConstructor"
		],ST2 [
			[TS "List",				TS_E,	TS "ListDenotation",						[]],
			[[],					TS_B,	TS "DotDotExpression",						[]],
			[[],					TS_B,	TS "ZF-expression",							[]],
			[TS "ListDenotation",	TS_E,	TST "[" TA "[ListKind] [{LGraphExpr}-list [" TAT ":" TA " GraphExpr]] [SpineStrictness] " TAT "]",
																						[]],
			[TS "LGraphExpr",		TS_E,	TS "GraphExpr",								[]],
			[[],					TS_B,	TS "CharsDenotation",						TS "// " TAL "see B.3"],
			[TS "DotDotExpression",	TS_E,	TST "[" TA "[ListKind] GraphExpr [" TAT "," TA "GraphExpr]" TAT ".." TA "[GraphExpr] [SpineStrictness] " ++ TST "]",
																						[]],
			[TS "ZF-expression",	TS_E,	TST "[" TA "[ListKind] GraphExpr " TAT "\\\\" TA " {Qualifier}-list [SpineStrictness]" TAT "]",
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
		]
		];
	= make_page pdf_i pdf_shl;

page_a_5 :: !{!CharWidthAndKerns} -> Page;
page_a_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "Tuple",	TS_E,	TST "(" TA "GraphExpr" TAT "," TA "{GraphExpr}-list" TAT ")"]
		],ST2 [
			[TS "Array",			TS_E,	TS "ArrayDenotation",									[]],
			[[],					TS_B,	TS "ArrayUpdate",										[]],
			[[],					TS_B,	TS "ArrayComprehension",								[]],
			[[],					TS_B,	TS "ArraySelection",									[]],
			[TS "ArrayDenotation",	TS_E,	TST "{" TA "[ArrayKind] {GraphExpr}-list" TAT "}",		[]],
			[[],					TS_B,	TS "StringDenotation",									TS "// " TAL "see B.3"],
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
			[TS "RecordUpdate",		TS_E,	TST "{" TA "[TypeName" TAT "|" TA "][RecordExpr " TAT "&" TA "][{" TAC "FieldName" TA " {Selection} " TAT "=" TA " GraphExpr}-list]" TAT "}"],
			[TS "RecordExpr",		TS_E,	TS "GraphExpr"],
			[TS "RecordSelection",	TS_E,	TS "RecordExpr [" TAT "." TA "TypeName]" TAT "." TAC "FieldName" TA " {Selection}"],
			[[],					TS_B,	TS "RecordExpr [" TAT "." TA "TypeName]" TAT "!" TAC "FieldName" TA " {Selection}"]
		],ST [
			[TS "UnitConstructor",	TS_E,	TST "()"]
		],ST [
			[TS "DynamicExpression",TS_E,	TSBCr "dynamic" TA " GraphExpr [" TAT "::" TA " [UnivQuantVariables] Type [ClassContext]]"]
		],ST [
			[TS "MatchesPatternExpr",	TS_E,	TS "GraphExpr" TA " " TAT "=:" TA " " TAC "ConstructorName" TA " { " TAT "_" TA " }"],
			[[],						TS_B,	TS "GraphExpr" TA " " TAT "=:" TA " BrackPattern"]
		],H2
			"A.4" "Macro Definition"
		,ST [
			[TS "MacroDef",			TS_E,	TS "[MacroFixityDef]"],
			[[],					[],	    TS "DefOfMacro"],
			[TS "MacroFixityDef",	TS_E,	TST "(" TAC "FunctionName" TAT ")" TA " [FixPrec] " TABCb ";"],
			[TS "DefOfMacro",		TS_E,	TS "Function {" TAC "Variable" TA "} " TAT ":==" TA " FunctionBody " TABCb ";"],
			[[],					[],		TS "[LocalFunctionAltDefs]"]
		],H2
			"A.5" "Type Definition"
		,ST [
			[TS "TypeDef",	TS_E,	TS "AlgebraicTypeDef"],
			[[],			TS_B,	TS "RecordTypeDef"],
			[[],			TS_B,	TS "SynonymTypeDef"],
			[[],			TS_B,	TS "AbstractTypeDef"],
			[[],			TS_B,	TS "AbstractSynonymTypeDef"],
			[[],			TS_B,	TS "ExtensibleAlgebraicTypeDef"],
			[[],			TS_B,	TS "AlgebraicTypeDefExtension"]
		],ST (let {
				dummy_columns = repeatn 6 [];
			} in [
			[TS "AlgebraicTypeDef",		TS_E,	TST "::" TA "TypeLhs",
			 TST "=" TA " ConstructorDef"]++dummy_columns,
			[[],						[],		[],
			 TS "{" TAT "|" TA " ConstructorDef} " TABCb ";"]
			 ++dummy_columns,
			[TS "ConstructorDef",		TS_E,	TS "[ExistQuantVariables] " TAC "ConstructorName" TA " {ArgType} {" TAT "&" TA " ClassConstraints}",
			 []]++dummy_columns,
			[[],						TS_B,	TS "[ExistQuantVariables] " TAT "(" TAC "ConstructorName" TAT ")" TA " [FixPrec] {ArgType} {" TAT "&" TA " ClassConstraints}",
			 []]++dummy_columns
		]),ST [
			[TS "TypeLhs",	TS_E,	TS "[" TAT "*" TA "] TypeConstructor",	TS "// " TAL "see A.8"],
			[[],			[],		TS "{" TAC "TypeVariable" TA "}",		[]]
		],ST [
			[TS "ExistQuantVariables",	TS_E,	TST "E." TA "{" TAC "TypeVariable" TA " }+" TAT ":"]
		],ST [
			[TS "FixPrec",	TS_E,	TSBCr "infixl" TA " [Prec]"],
			[[],			TS_B,	TSBCr "infixr" TA " [Prec]"],
			[[],			TS_B,	TSBCr "infix" TA " [Prec]"]
		],ST [
			[TS "Prec",	TS_E,	TS "Digit",	TS "// " TAL "see A.8"]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_6 :: !{!CharWidthAndKerns} -> Page;
page_a_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "BrackType",	TS_E,	TS "[Strict] [UnqTypeAttrib] SimpleType"]
		],ST [
			[TS "Strict",	TS_E,	TST "!"]
		],ST [
			[TS "UnqTypeAttrib",	TS_E,	TST "*",							[]],
			[[],					TS_B,	TSC "UniqueTypeVariable" TAT ":",	TS "// " TAL "see A.8"],
			[[],					TS_B,	TST ".",							[]]
		],ST [
			[TS "Type",				TS_E,	TS "{BrackType}+"],
			[TS "ArgType",			TS_E,	TS "BrackType"],
			[[],					TS_B,	TS "[Strict] [UnqTypeAttrib] " TAT "(" TA "UnivQuantVariables Type [ClassContext]" TAT ")"]
		],ST [
			[TS "UnivQuantVariables",	TS_E,	TST "A." TA "{" TAC "TypeVariable" TA " }+" TAT ":"]
		],ST [
			[TS "RecordTypeDef",	TS_E,
			 TST "::" TA "TypeLhs " TAT "=" TA " [ExistQuantVariables] [Strict] " TAT "{" TA "{" TAC "FieldName" TA " " TAT "::" TA " FieldType}-list" TAT "}" TA " " TABCb ";"],
			[TS "FieldType",		TS_E,	TS "[Strict] Type"],
			[[],					TS_B,	TS "UnivQuantVariables [Strict] Type"],
			[[],					TS_B,	TS "[Strict] [UnqTypeAttrib] " TAT "(" TA "UnivQuantVariables Type" TA ")"]
		],ST [
			[TS "SynonymTypeDef",	TS_E,	TST "::" TA "TypeLhs " TAT ":==" TA " Type " TABCb ";"]
		],ST [
			[TS "AbstractTypeDef",	TS_E,	TST "::" TA "TypeLhs " TABCb ";"]
		],ST [
			[TS "AbstractSynonymTypeDef",	TS_E,	TST "::" TA "TypeLhs " TAT "(:==" TA " Type " TAT ")" TA " " TABCb ";"]
		],ST [
			[TS "ExtensibleAlgebraicTypeDef",	TS_E,	TST "::" TA "TypeLhs " TAT "=" TA " {ConstructorDef " TAT "|" TA "} " TAT ".." TABCb ";"]
		],ST [
			[TS "AlgebraicTypeDefExtension",	TS_E,	TST "::" TA "TypeLhs " TAT "|" TA " ConstructorDef " TA " {" TAT "|" TA " ConstructorDef} " TABCb ";"]
		],H3
			"A.5.1" "Types Expression"
		,ST2 [
			[TS "SimpleType",		TS_E,	TSC "TypeVariable",				TS "// " TAL "see A.8"],
			[[],					TS_B,	TSC "TypeName",					[]],
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
			[[],								TS_B,	TST "File",		TS "// see " TAC "StdFileIO.dcl"],
			[[],								TS_B,	TST "String",	TS "// synonym for {#Char}"]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_7 :: !{!CharWidthAndKerns} -> Page;
page_a_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST2 [
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
			[[],								TS_B,	TST "(->)",		TS "// arrow type constructor"],
			[[],								TS_B,	TST "()",		TS "// unit type constructor"]
		],H2
			"A.6" "Class and Generic Definitions"
		,ST [
			[TS "ClassDef",	TS_E,	TS "TypeClassDef"],
			[[],			TS_B,	TS "TypeClassInstanceDef"]
		],ST [
			[TS "TypeClassDef",	TS_E,	TSBCr "class" TA " " TAC "ClassName" TA " " TAC "TypeVariable" TA "+ [ClassContext]"],
		    [[],				[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA " {ClassMemberDef}+ " TABCb "}" TA "] " TABCb ";"],
			[[],				TS_B,	TSBCr "class" TA " " TAC "FunctionName" TA " " TAC "TypeVariable" TA "+ " TAT "::" TA " FunctionType" TABCb ";"],
			[[],				TS_B,	TSBCr "class" TA " (" TAC "FunctionName" TA ") [FixPrec] " TAC "TypeVariable" TA "+ " TAT "::" TA " FunctionType" TABCb ";"]
		],ST [
			[TS "ClassMemberDef",	TS_E,	TS "FunctionTypeDef"],
			[[],					[],		TS "[MacroDef]"]
		],ST2 [
			[TS "TypeClassInstanceDef",	TS_E,	TSBCr "instance" TA " " TAC "ClassName" TA " Type+ [ClassContext]",
			 []],
			[[],						[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA "{FunctionDef}+ " TABCb "}" TA "] " TABCb ";",
			 TS "// in implementation modules"],
			[[],						[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA "{FunctionTypeDef}+ " TABCb "}" TA "] [Special] " TABCb ";",
			 TS "// in definition modules"],
			[TS "Special",				TS_E,	TSBCr "special" TA " " TABCb "{" TA "{" TAC "TypeVariable" TA " " TAT "=" TA " Type}-list" TA " { " TABCb ";" TA " {" TAC "TypeVariable" TA " " TAT "=" TA " Type}-list }" TABCb "}",
			 []]
		],ST [
			[TS "GenericsDef",	TS_E,	TS "GenericDef ;"],
			[[],				TS_B,	TS "GenericCase;"],
			[[],				TS_B,	TS "DeriveDef ;"]
		],ST [
			[TS "GenericDef",		TS_E,	TSBCr "generic" TA " " TAC "FunctionName" TA " " TAC "TypeVariable" TA "+ [GenericDependencies] " TAT "::" TA " FunctionType"],
			[TS "GenericDependencies",TS_E,	TST "|" TA " {" TAC "FunctionName" TA " " TAC "TypeVariable" TA "+ }-list"],
			[TS "GenericCase",		TS_E,	TSC "FunctionName" TA " " TAT "{|" TA "GenericTypeArg" TAT "|}" TA " {Pattern}+ " TAT "=" TA " FunctionBody"],
			[TS "GenericTypeArg",	TS_E,	TS "GenericMarkerType [" TABCr "of" TA " Pattern]"],
			[[],					TS_B,	TSC "TypeName"],
			[[],					TS_B,	TSC "TypeVariable"],
			[TS "GenericMarkerType",TS_E,	TSBCr "CONS"],
			[[],					TS_B,	TSBCr "OBJECT"],
			[[],					TS_B,	TSBCr "RECORD"],
			[[],					TS_B,	TSBCr "FIELD"]
		],ST [
			[TS "DeriveDef",	TS_E,	TSBCr "derive" TA " " TAC "FunctionName" TA " {DerivableType}-list"],
			[[],				TS_B,	TSBCr "derive" TA " " TABCr "class" TA " " TAC "ClassName" TA " {DerivableType}-list"],
			[TS "DerivableType",TS_E,	TSC "TypeName"],
			[[],				TS_B,	TS "PredefinedTypeConstructor"]
		],ST [
			[TS "GenericAppExpression",	TS_E,	TSC "FunctionName" TA " " TAT "{|" TA "TypeKind" TAT "|}" TA " GraphExpr"],
			[TS "TypeKind",				TS_E,	TST "*"],
			[[],						TS_B,	TS "TypeKind " TAT "->" TA " TypeKind"],
			[[],						TS_B,	TS "IntDenotation"],
			[[],						TS_B,	TST "(" TA "TypeKind" TAT ")"],
			[[],						TS_B,	TST "{|" TA "TypeKind" TAT "|}"]
		],ST [
			[TS "GenericExportDef",		TS_E,	TS "GenericDef " TABCb ";"],
			[[],						TS_B,	TSBCr "derive" TA " " TAC "FunctionName" TA " {DeriveExportType [UsedGenericDependencies]}-list " TABCb ";"],
			[[],						TS_B,	TSBCr "derive" TA " " TABCr "class" TA " " TAC "ClassName" TA " {DerivableType}-list " TABCb ";"],
			[TS "DeriveExportType",		TS_E,	TSC "TypeName"],
			[[],						TS_B,	TS "GenericMarkerType [" TABCr "of" TA " UsedGenericInfoFields]"],
			[[],						TS_B,	TS "PredefinedTypeConstructor"],
			[[],						TS_B,	TSC "TypeVariable"],
			[TS "UsedGenericInfoFields",TS_E,	TST "{" TA "[{" TAC "FieldName" TA "}-list]"  TAT "}"],
			[[],						TS_B,	TSC "Variable"]
		]
		];
	= make_page pdf_i pdf_shl;

page_a_8 :: !{!CharWidthAndKerns} -> Page;
page_a_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "UsedGenericDependencies",TS_E,	TSBCr "with" TA " {UsedGenericDependency}"],
			[TS "UsedGenericDependency",TS_E,	TSC "Variable"],
			[[],						TS_B,	TST "_"]
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
			[[],				TS_B,TS "Digit"]++repeatn 10 []++[TS "// " TAL "see B.3"]++repeatn 13 [],
			[[],				TS_B,TST "_",TS_B,TST "`"]++repeatn 22 []
		]
		];
	= make_page pdf_i pdf_shl;
