implementation module clean_manual_functions;

import StdEnv,pdf_main,pdf_text,pdf_graphics,pdf_fonts,clean_manual_styles,clean_manual_text;

courier_char_width = toReal font_size*0.6;

pages_3 :: [{!CharWidthAndKerns} -> Page];
pages_3 = [page_3_1,page_3_2,page_3_3,page_3_4,page_3_5,page_3_6,page_3_7,page_3_8,page_3_9,page_3_10,page_3_11,page_3_12,page_3_13,page_3_14,page_3_15];

page_3_1 :: !{!CharWidthAndKerns} -> Page;
page_3_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 3" "Defining Functions and Constants"
		,P(
			TS "In this Chapter we explain how functions (actually: " TAI "graph rewrite rules"
			TA (") and constants (actually: graph expressions) are defined in CLEAN. The body of a "+++
				"function consists of an (root) expression (")
			TAL "see 3.4" TA "). With help of patterns (" TAL "see 3.2" TA ") and guards  (" TAL "see 3.3"
			TA (") a distinction can be made between several alternative definitions for a function. Functions and "+++
				"constants can be defined locally in a function definition. For programming convenience (forcing evaluation, observation "+++
				"of unique objects and threading of sequencial operations) a special let construction is provided (")
			TAL "see 3.5.1" TA "). The typing of functions is discussed in " TAL "Section 3.7" TA ". For overloaded functions see "
			TAL "Chapter 6" TA ". For functions working on unique datatypes "TAL "see Chapter 9" TA "."
		),H2
			"3.1" "Functions"
		,ST2 [
			[TS "FunctionDef",		TS_E,	TS "[FunctionTypeDef]",
											TS "// " TAL "see Chapter 4 for typing functions"],
			[[],					[],		TS "DefOfFunction",
											[]],
			[TS "DefOfFunction",	TS_E,	TS "{FunctionAltDef "++TSb ";" TA "}+",
											[]],
			[TS "FunctionAltDef", 	TS_E,	TS "Function {Pattern}",
										 	TS "// " TAL "see 3.2 for patterns"],
			[[],					[],		TS "{LetBeforeExpression}",
											TS "// " TAL "see 3.5.4"],
			[[],					[],		TS "{{" TAT "|" TA " Guard} " TAT "=" TA "[" TAT ">" TA "] FunctionBody}+",
											TS "// " TAL "see 3.3 for guards"],
			[[],					[],		TS "[LocalFunctionAltDefs]",
											TS "// " TAL "see 3.5"],
			[TS "Function",			TS_E,	TSC "FunctionName",
											TS "// ordinary function"],
			[[],					TS_B,	TS "(" TAC "FunctionName" TA ")",
											TS "// operator function used prefix"],
			[TS "FunctionBody",		TS_E,	TS "RootExpression "++TSb ";",
											TS "// " TAL "see 3.4"],
			[[],					[],		TS "[LocalFunctionDefs]",
											TS "// " TAL "see 3.5"]
  		],P(
			TS "A " TAI "function definition" TA " consists of one or more definition of a " TAI "function alternative"
			TA " (rewrite rule). On the left-hand side of such a function alternative a " TAI "pattern"
			TA " can be specified which can serve a whole sequence of " TAI "guarded function bodies"
			TA " (called the " TAI "rule alternatives" TA ") The root expression (" TAL "see 3.4"
			TA ") of a particular rule alternative is chosen for evaluation when"
		),MBP [
			TS ("the patterns specified in the formal arguments are matching the corresponding actual arguments of the "+++
				"function application (") TAL "see 3.2" TA ") " TAI "and",
			TS "the optional " TAI "guard" TA " (" TAL "see 3.3"
			TA ") specified on the right-hand side evaluates to " TAC "True" TA "."
		],CP(
			TS " The alternatives are tried in textual order. A function can be preceded by a definition of its type ("
			TAL "Section 3.7" TA ")."
		),MSP [
			TS "Function definitions are only allowed in implementation modules (" TAL "see 2.3" TA ").",
			TS ("It is required that the function alternatives of a function are textually grouped together "+++
				"(separated by semi-colons when the layout sensitive mode is not chosen)."),
			TS "Each alternative of a function must start with the same function symbol.",
			TS ("A function has a fixed arity, so in each rule the same number of formal arguments must be specified. Functions "+++
				"can be used curried and applied to any number of arguments though, as usual in higher order functional languages."),
			TS "The function name must in principle be different from other names in the same name space and same scope ("
			TAL "see 2.1" TA "). However, it is possible to overload functions and operators ("
			TAL "see Chapter 6" TA ")." 
			]
		];
 	= make_page pdf_i pdf_shl;

page_3_2 :: !{!CharWidthAndKerns} -> Page;
page_3_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of function definitions in a CLEAN module.")
			(map syntax_color [
			[],
			TS "module example                                  // module header",
			[],
			TS "import StdInt                                   // implicit import",
			[],
			TS "map:: (a -> b) [a] -> [b]                       // type of map",
			TS "map f list = [f e \\\\ e <- list]                 // definition of the function map",
			[],
			TS "Start:: [Int]                                   // type of Start rule",
			TS "Start = map square [1..1000]                    // definition of the Start rule"
		]),P(
			TS "An " TAI "operator" TA " is a " TAI "function with arity two"
			TA (" that can be used as infix operator (brackets are left out) or as ordinary prefix "+++
				"function (the operator name preceding its arguments has to be surrounded by brackets). The ")
			TAI "precedence" TA " (" TAC "0" TA " through " TAC "9" TA ") and "
			TAI "fixity" TA " (" TABCr "infixl" TA "eft, " TABCr "infixr" TA "ight, " TABCr "infix"
			TA ") that can be defined in the type definition (" TAL "see 3.7.1"++ 
			TS (") of the operators determine the priority of the operator application in an expression. A higher precedence binds more tightly. "+++
				"When operators have equal precedence, the fixity determines the priority.")
		),N
		,SP (
			TS "When an operator is used in infix position " TAI "both"
			TA " arguments have to be present. Operators can be used in a curried way, but then they have to be used as ordinary prefix functions."
		),PCH
			(TS "Operator definition.")
			(map syntax_color [
			[],
			TS "(++) infixr 0:: [a] [a] -> [a]",
			TS "(++) []      ly  = ly",
			TS "(++) [x:xs]  ly  = [x:xs ++ ly]",
			[],
			TS "(o) infixr 9:: (a -> b) (c -> a) -> (c -> b)",
			TS "(o) f g = \\x = f (g x)"
		]),H2
			"3.2" "Patterns"
		,P(
			TS "A " TAI "pattern"
			TA (" specified on the left-hand side of a function definition specifies the formal arguments of a function. A function "+++
				"alternative is chosen only if the actual arguments of the function application match the formal arguments. A formal "+++
				"argument is either a constant (some ")
			TAI "data constructor"
			TA " with its optional arguments that can consist of sub-patterns) or it is a variable."
		),ST2 [
			[TS "Pattern",			TS_E,	TS "[Variable " TAT "=:" TA "] BrackPattern",	[]],
			[TS "BrackPattern",		TS_E,	TST "(" TA "GraphPattern" TAT ")",				[]],
			[[],					TS_B,	TS "Constructor",								[]],
			[[],					TS_B,	TS "PatternVariable",							[]], 
			[[],					TS_B,	TS "SpecialPattern",							[]], 
			[[],					TS_B,	TS "DynamicPattern",							TS "// " TAL "see Chapter 8"],
			[[],					[],		[],												[]],
			[TS "GraphPattern",		TS_E,	TS "Constructor {Pattern}",						TSCb "// Ordinary data constructor"],
			[[],					TS_B,	TS "GraphPattern " TAC "ConstructorName",		TSCb "// Infix data constructor"],
			[[],					TS_B,	TS "GraphPattern ",								[]],
			[[],					TS_B,	TS "Pattern ",									[]],
			[[],					[],		[],												[]],
			[TS "PatternVariable",	TS_E,	TS "Variable",									[]],
			[[],					TS_B,	TS "_ ",										[]]
		],P(
			TS "A " TAI "pattern variable" TA " can be a (node) " TAI "variable" TA " or a "
			TAI "wildcard" TA ". A " TAI "variable" TA " is a formal argument of a function that matches on "
			TAI "any" TA " concrete value of the corresponding actual argument and therefore it does "
			TAI "not" TA " force evaluation of this argument. A " TAI "wildcard" TA " is an " TAI "anonymous" 
			TA " variable (\"_\") one can use to indicate that the corresponding argument is not used in the right-hand side of the function. A "
			TAI "variable" TA " can be attached to a pattern (using the symbol '" TAC "=:"
			TA "') that makes it possible to identify (" TAI "label"
			TA (") the whole pattern as well as its contents. When a constant (data constructor) is specified as formal argument, the "+++
				"actual argument must contain the same constant in order to have a successful match.")
		)];
 	= make_page pdf_i pdf_shl;

page_3_3 :: !{!CharWidthAndKerns} -> Page;
page_3_3 char_width_and_kerns
	# line_height = toReal line_height_i;
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of an algebraic data type definition and its use in a pattern match in a function definition.")
			[
				[],
				TS "::Tree a = Node a (Tree a) (Tree a)",
				TS "         | Nil",
				[],
				TS "Mirror:: (Tree a) -> Tree a",
				TS "Mirror (Node e left right) = Node e (Mirror right) (Mirror left)",
				TS "Mirror Nil                 = Nil"
		],PCH
			(TS "Use of anonymous variables.")
			[
				[],
				comment_blue (TS ":: Complex :== (!Real,!Real)                         // synonym type def"),
				[],
							  TS "realpart:: Complex -> Real",
				comment_blue (TS "realpart (re,_) = re                                 // re and _ are pattern variables")
		],PCH
			(TS ("Use of list patterns, use of guards, use of variables to identify patterns and sub-patterns; merge merges two (sorted) "+++
						  "lazy lists into one (sorted) list."))
			[
				[],
				TS "merge:: [Int] [Int] -> [Int]",
				TS "merge f []   = f",
				TS "merge [] s   = s",
				TS "merge f=:[x:xs] s=:[y:ys]",
				TS "| x<y        = [x:merge xs s]",
				TS "| x==y       = merge f ys",
				TS "| otherwise  = [y:merge f ys]"
		],N
		,SP(
			TS "It is possible that the specified patterns turn a function into a partial function (" TAL "see 3.7.3" 
					TA "). When a partial function is applied outside the domain for which the function is defined it will result into a "
					TAI "run-time" TA " error. A compile time " TAI "warning" TA " is generated that such a situation might arise."
		),S(
			"The formal arguments of a function and the function body are contained in a new local scope."
		),PCP [
			TS "functionName args = expression"
		][Rectangle  (13.0*courier_char_width-2.0,1.0) ((46.0-13.0)*courier_char_width,line_height-1.0)]
		,N
		,SP(
			TS "All variable symbols introduced at the left-hand side of a function definition must have different names."
		),S(
			"For convenience and efficiency special syntax is provided to express pattern match on data structures of predefined type "+++
			 "and record type. They are treated elsewhere (see below)."
		),ST2 [
			[TS "SpecialPattern",	TS_E,	TS "BasicValuePattern",		TS "// " TAL "see 4.1.2"],
			[[],					TS_B,	TS "ListPattern",			TS "// " TAL "see 4.2.2"],
			[[],					TS_B,	TS "TuplePattern",			TS "// " TAL "see 4.3.2"],
			[[],					TS_B,	TS "ArrayPattern",			TS "// " TAL "see 4.4.2"],
			[[],					TS_B,	TS "RecordPattern",			TS "// " TAL "see 5.2.2"]
		],H2
			"3.3" "Guards"
		,ST [
			[TS "Guard",	TS_E,	TS "BooleanExpr"],
			[[],			TS_B,	TSBCr "otherwise"]
		],MP [
			[],
			TS "A " TAI "guard"
			TA (" is a Boolean expression attached to a rule alternative that can be regarded as generalisation of the pattern "+++
				"matching mechanism: the alternative only matches when the patterns defined on the left hand-side match ")
			TAI "and" TA " its (optional) guard evaluates to " TAC "True" TA " (" TAL "see 3.1" TA "). Otherwise the " TAI "next"
			TA " alternative of the function is tried. Pattern matching always takes place " TAI "before"
			TA " the guards are evaluated.",
			[],
			TS "The guards are tried in " TAI "textual order"
			TA ". The alternative corresponding to the first guard that yields " TAC "True"
			TA " will be evaluated. A right-hand side without a guard can be regarded to have a guard that always evaluates to "
			TAC "True" TA "(the 'otherwise' or 'default' case). In " TAC "keyword" TA " " TABCr "otherwise"
			TA " is synonym for " TAC "True" TA " for people who like to emphasize the default option."
		],MSP [
			TS "Only the last rule alternative of a function can have otherwise as guard or can have no guard.",
			TS "It is possible that the guards turn the function into a partial function ("
			TAL "see 3.7.3"
			TA "). When a partial function is applied outside the domain for which the function is defined it will result into a "
			TAI "run-time" TA " error. At compile time this cannot be detected."				
		]
		];
 	= make_page pdf_i pdf_shl;

page_3_4 :: !{!CharWidthAndKerns} -> Page;
page_3_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Function definition with guards.")
			(map syntax_color [
				[],
				TS "filter:: Int [Int] -> [Int]",
				TS "filter pr [n:str]",
				TS "| n mod pr == 0   = filter pr str",
				TS "| otherwise       = [n:filter pr str]"
		]),PCH
			(TS "Equivalent definition of previous " TAC "filter" TA ".")
			[
				[],
				TS "filter:: Int [Int] -> [Int]",
				TS "filter pr [n:str]",
				TS "| n mod pr == 0   = filter pr str",
				TS "                  = [n:filter pr str]"
		],P(
			TS "Guards can be nested. When a guard on one level evaluates to " TAC "True" TA ", the guards on a next level are tried."
		),N
		,SP(
			TS ("To ensure that at least one of the alternatives of a nested guard will be successful, a nested guarded alternative "+++
						"must always have a 'default case' as last alternative.")
		),PCH
			(TS "Example of a nested guard. ")
			(map syntax_color [
				[],
				TS "example arg1 arg2",
				TS "| predicate11 arg1                                   // if predicate11 arg1",
				TS "    | predicate21 arg2 = calculate1 arg1 arg2        //  then (if predicate21 arg2",
				TS "    | predicate22 arg2 = calculate2 arg1 arg2        //  elseif predicate22 arg2 then",
				TS "    | otherwise        = calculate3 arg1 arg2        //  else ...)",
				TS "| predicate12 arg1     = calculate4 arg1 arg2        // elseif predicate12 arg1 then ..."
		]),H2
			"3.4" "Expressions"
		,P(
			TS "The main body of a function is called the " TAI "root expression" TA ". The root expression is a graph expression."
		),ST [
			[TS "RootExpression",	TS_E,	TS "GraphExpr"] 
		],let {
			table_alt s = [[], TS_B, TS s, []];
			table_alt_link s c = [[], TS_B, TS s, TS "// " TAL c];
		} in ST2 [
			[TS "GraphExpr",	TS_E,	TS "Application",	[]],
			[TS "Application",	TS_E,	TS "{BrackGraph}+",	[]],
			table_alt "GraphExpr Operator GraphExpr",
			table_alt "GenericAppExpr",
			[TS "BrackGraph",	TS_E,	TS "GraphVariable",	[]],
			table_alt "GraphVariable",
			table_alt "Constructor",
			table_alt "Function",
			table_alt "(GraphExpr)",
			table_alt_link "LambdaAbstr" "see 3.4.1",
			table_alt_link "CaseExpr" "see 3.4.2",
			table_alt_link "LetExpr" "see 3.5.1",
			table_alt "SpecialExpression",
			table_alt "DynamicExpression"
		],ST [
			[TS "Function",		TS_E,	TSC "FunctionName"],
			[[],				TS_B,	TST "(" TAC "FunctionName" TAT ")"],
			[TS "Constructor",	TS_E,	TSC "ConstructorName"],
			[[],				TS_B,	TST "(" TAC "ConstructorName" TAT ")"],
			[TS "Operator",		TS_E,	TSC "FunctionName"],
			[[],				TS_B,	TSC "ConstructorName"],
			[TS "GraphVariable",TS_E,	TS "Variable"],
			[[],				TS_B,	TS "SelectorVariable"]
		],P(
			TS ("An expression generally expresses an application of a function to its actual arguments or the (automatic) creation of a "+++
				"data structure simply by applying a data constructor to its arguments. Each function or data constructor can be used in a ")
			TAI "curried"
			TA (" way and can therefore be applied to any number (zero or more) of arguments. A function will only be rewritten if it "+++
				"is applied to a number of arguments equal to the arity of the function (")
			TAL "see 3.1"
			TA ("). Function and constructors applied on "+++
				"zero arguments just form a syntactic unit (for non-operators no brackets are needed in this case).")
		),MSP [
			TS "All expressions have to be of correct type (" TAL "see Chapter 5" TA ").",
			TS "All symbols that appear in an expression must have been defined somewhere within the scope in which the expression appears ("
			TAL "see 2.1" TA ").",
			TS "There has to be a definition for each node variable and selector variable within in the scope of the graph expression."
		]
		];

 	= make_page pdf_i pdf_shl;

page_3_5 :: !{!CharWidthAndKerns} -> Page;
page_3_5 char_width_and_kerns
	# line_height = toReal line_height_i;
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TSI "Operators"
			TA " are special functions or data constructors defined with arity two which can be applied in infix position  The "
			TAI "precedence" TA " ("  TAC "0" TA " through " TAC "9" TA ") and " TAI "fixity" TA " ("
			 TABCr "infixl" TA "eft, " TABCr "infixr" TA "ight, " TABCr "infix"
			TA (") which can be defined in the type definition of the operators determine the priority of the operator application in "+++
				"an expression. A higher precedence binds more tightly. When operators have equal precedence, the fixity determines the "+++
				"priority. In an expression an ordinary function application has a very high priority (")
			TAC "10" TA "). Only selection of record elements (" TAL "see 5.2.1" TA ") and array elements ("
			TAL "see 4.4.1" TA ") binds more tightly (" TAC "11"
			TA "). Besides that, due to the priority, brackets can sometimes be omitted; operator applications behave just like other applications."
		),MSP [
			TS "It is not allowed to apply operators with equal precedence in an expression in such a way tha  their fixity conflict. So, when in "
			TAC	"a1 op1 a2 op2 a3" TA " the operators " TAC "op1" TA " and " TAC "op2"
			TA " have the same precedence a conflict arises when " TAC "op1"
			TA " is defined as infixr implying that the expression must be read as " TAC "a1" TA " " TAC "op1" TA " " TAC "(a2" TA " " TAC "op2" TA " " TAC "a3)"
			TA " while " TAC "op2" TA " is defined as " TAC "infixl" TA " implying that the expression must be read as "
			TAC "(a1" TA " " TAC "op1" TA " " TAC "a2)" TA " " TAC "op2" TA " " TAC "a3" TA ".",
			TS "When an operator is used in infix position " TAI "both"
			TA " arguments have to be present. Operators can be used in a " TAI "curried"
			TA " way (applied to less than two arguments), but then they have to be used as ordinary " TAI "prefix"
			TA " functions / constructors. When an operator is used as prefix function c.q. constructor, it has to be surrounded by brackets."
		],P(
			TS "There are two kinds of variables that can appear in a graph expression: " TAI "variables"
					TA " introduced as " TAI "formal argument" TA " of a function (" TAL "see 3.1" TA " and "
					TAL "3.2" TA ") and " TAI "selector variables" TA " (defined in a " TAI "selector"
					TA " to identify parts of a graph expression, " TAL "see 3.6" TA ")."
		),PCH
			(TS ("Example of a cyclic root expression. y is the root expression referring to a cyclic graph. "+++
							  "The multiplication operator * is used prefix here in a curried way."))
			(map syntax_color [
					[],
					TS "ham:: [Int]",
					TS "ham = y",
					TS "where y = [1:merge (map ((*) 2) y) (merge (map ((*) 3) y) (map ((*) 5) y))]"
		]),S(
			("For convenience and efficiency special syntax is provided to create expressions of data structures of predefined type "+++
					 "and of record type that is considered as a special kind of algebraic type. They are treated in elsewhere.")
		),let {
			table_alt_link s c = [[], TS_B, TS s, TS "// " TAL c];
		} in ST2 [
				[TS "SpecialExpression",	TS_E,	TS "BasicValue", TS "// " TAL "see 4.1.1"],
				table_alt_link "List" "see 4.2.1",
				table_alt_link "Tuple" "see 4.3.1",
				table_alt_link "Array" "see 4.4.1",
				table_alt_link "ArraySelection" "see 4.4.1",
				table_alt_link "Record" "see 5.2.1",
				table_alt_link "RecordSelection" "see 5.2.1"
		],H3
			"3.4.1" "Lambda Abstraction"
		,MP [
			[],
			TS "Sometimes it can be convenient to define a tiny function in an expression \"right on the spot\". For this purpose one can use a "
			TAI "lambda abstraction"
			TA ". An anonymous function is defined which can have several formal arguments that can be patterns as common in ordinary function definitions ("
			TAL "see Chapter 3"
			TA "). However, only simple functions can be defined in this way: no rule alternatives, and no local function definitions.",
			[],
			TS "It is also allowed to use the arrow ('" TAC "->"
			TA "') to separate  the  formal  arguments from the function body:"
		],ST [
			[TS "LambdaAbstr",		TS_E,	TST "\\" TA " {Pattern}+ {LambdaGuardAlt} {LetBeforeExpression} LambdaResult"],
			[TS "LambdaResult",		TS_E,	TST "= " TA " GraphExpr"],
			[[],					TS_B,	TST "->" TA " GraphExpr"],
			[[],					TS_B,	TST "|" TA " Guard LambdaGuardRhs"]
		],PCH
			(TS "Example of a Lambda expression.")
			[
			[],
			TS "AddTupleList:: [(Int,Int)] -> [Int]",
			TS "AddTupleList list = map (\(x,y) = x+y) list"
		],P(
			TS "A lambda expression introduces a new scope (" TAL "see 2.1" TA ")."
		),PCH
			(TS "The arguments of the anonymous function being defined have the only a meaning in the corresponding function body.")
			[]
		,CPCP
			[	
			[],
			TS "\\ arg1 arg2 ... argn = function_body"
		] [Rectangle (2.0*courier_char_width-2.0,line_height) ((37.0-2.0)*courier_char_width,line_height-1.0)]
		,S "Let-before expressions and guards can be used in lambda abstractions:"
		];
 	= make_page pdf_i pdf_shl;

page_3_6 :: !{!CharWidthAndKerns} -> Page;
page_3_6 char_width_and_kerns
	# line_height = toReal line_height_i;
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
			[TS "LambdaGuardAlt",	TS_E,	TS "{LetBeforeExpression} " TAT "|" TA " BooleanExpr LambdaGuardRhs"],
			[TS "LambdaGuardRhs",	TS_E,	TS "{LambdaGuardAlt} {LetBeforeExpression} LambdaGuardResult"],
			[TS "LambdaGuardResult",TS_E,	TST "= " TA " GraphExpr"],
			[[],					TS_B,	TST "->" TA " GraphExpr"],
			[[],					TS_B,	TST "|" TA " " TABCr "otherwise" TA " LambdaGuardRhs"]
		],H3
			"3.4.2" "Case Expression and Conditional Expression"
		,P(
			TS "For programming convenience a " TAI "case expression" TA " and " TAI "conditional expression" TA " are added."
		),ST [
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
		],MP [
			[],
			TS "In a " TAI "case expression"
			TA (" first the discriminating expression is evaluated after which the case alternatives are tried in textual "+++
				"order. Case alternatives are similar to function alternatives. This is not so strange because a case expression is "+++
				"internally translated to a function definition (see the example below). Each alternative contains a left-hand side pattern (")
			TAL "see 3.2" TA ") that is optionally followed by a " TAI "let-before" TA " (" TAL "see 3.5.4"
			TA ") and a guard (" TAL "see 3.3" TA "). When a pattern matches and the optional guard evaluates to "
			TAC "True" TA " the corresponding alternative is chosen. A new block structure (scope) is created for each case alternative ("
			TAL "see 2.1" TA ").",
			[],
			TS "For compatibility with CLEAN 1.3.x it is also allowed to use the arrow ('" TAC "->" TA "') to separate the case alternatives"
		],PCH
			(TS "The variables defined in the patterns have the only a meaning in the corresponding alternative.")
			[]
		,CPCP
			(map syntax_color [
						TS "case expression of",
						TS "    pattern1 = alternative1",
						TS "    pattern2 = alternative2",
						TS "    ...",
						TS "    patternn = alternativen"
		]) [
			Rectangle (4.0*courier_char_width-2.0,     line_height-1.0) ((30.0-4.0)*courier_char_width,line_height-1.0),
			Rectangle (4.0*courier_char_width-2.0, 2.0*line_height)     ((30.0-4.0)*courier_char_width,line_height-2.0),
			Rectangle (4.0*courier_char_width-2.0, 4.0*line_height)     ((30.0-4.0)*courier_char_width,line_height-1.0)
		]
		,MSP [
			TS "All alternatives in the case expression must be of the same type.",
			TS "When none of the patterns matches a " TAI "run-time" TA " error is generated."
		],PCH
			(TS "The case expression")
			(map color_keywords [
			[],
			TS "h x =    case g x of",
			TS "         [hd:_]  = hd",
			TS "         []      = abort \"result of call g x in h is empty\"",
      		[]
		]),CPCH
			(TS "is semantically equivalent to:")
			(map color_keywords [
			[],
			TS "h x = mycase (g x)",
			TS "where",
			TS "    mycase  [hd:_]  = hd",
			TS "    mycase  []      = abort \"result of call g x in h is empty\""
		]),P(
			TS "In a " TAI "conditional expression"
			TA (" first the Boolean expression is evaluated after which either the then- or the else-part is "+++
				"chosen. The conditional expression can be seen as a simple kind of case expression.")
		),MSP [
			TS "The then- and else-part in the conditional expression must be of the same type.",
			TS "The discriminating expression must be of type " TAC "Bool" TA "."
		],H2
			"3.5" "Local Definitions"
		,MP [
			[],
			TS ("Sometimes it is convenient to introduce definitions that have a limited scope and are not visible throughout the whole "+++
				"module. One can define ") TAI "functions"
			TA " that have a local scope, i.e. which have only a meaning in a certain program region.",
			[],
			TS ("Outside the scope the functions are unknown. This locality can be used to get a better program structure: functions that "+++
				"are only used in a certain program area can remain hidden outside that area.")
		]
		];
 	= make_page pdf_i pdf_shl;

page_3_7 :: !{!CharWidthAndKerns} -> Page;
page_3_7 char_width_and_kerns
	# line_height = toReal line_height_i;
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "Besides functions one can also define constant selectors. Constants are named graph expressions ("
			TAL "see 3.6" TA ").",
			[]
		],ST [
			[TS "LocalDef",	TS_E,	TS "GraphDef"],
			[[],			TS_B,	TS "FunctionDef"]
		],H3
			"3.5.1" "Let Expression: Local Definitions in Expressions"
		,P(
			TS "A " TAI "let" TA " expression is an expression that enables to introduce a new scope (" TAL "see 2.1"
			TA (")  in an expression in which local functions and constants can be defined. Such local "+++
				"definitions can be introduced anywhere in an expression using a let expression with the following syntax.")
		),ST [
			[TS "LetExpression",	TS_E,	TSBCr "let" TA " " TABCb "{" TA " {LocalDef}+ " TABCb "}" TA " " TABCr "in" TA " GraphExpr"]
		],PCH
			(TS "The function and selectors defined in the let block only have a meaning within the " TAI "expression" TA ".")
			[]
		,CPCP
			(map color_keywords [
			[],
			TS "let",
			TS "    function arguments = function_body",
			TS "    selector = expr",
			TS "    ...",
			TS "in  expression"
		]) [
			Rectangle (                        0.0,     line_height) (       39.0*courier_char_width,5.0*line_height-1.0),
			Rectangle (13.0*courier_char_width-2.0, 2.0*line_height) ((39.0-13.0)*courier_char_width,    line_height-1.0)
		],PCH
			(TS "Example of a let expression used within a list comprehension.")
			(map color_keywords [
			[],
			TS "doublefibs n = [let a = fib i in (a, a) \\ i <- [0..n]]"
		]),H3
			"3.5.2" "Where Block: Local Definitions in a Function Alternative"
		,P(
			TS "At the end of each function alternative one can locally define functions and constant graphs in a " TAI "where block" TA "."
		),ST [
			[TS "LocalFunctionAltDefs",	TS_E,	TS "[" TABCr "where" TA "] " TABCb "{" TA " {LocalDef}+ " TABCb "}"]
		],P(
			TS "Functions and graphs defined in a " TAI "where"
			TA (" block can be used anywhere in the corresponding function alternative (i.e. in all "+++
				"guards and rule alternatives following a pattern, ")
			TAL "see 3.1" TA ") as indicated in the following picture showing the scope of a " TAI "where" TA " block."
		),PCH
			(TS "The function and selectors defined in the where block can be used locally in the whole function definition.")
			[]
		,CPCP
			(map color_keywords [
			[],
			TS "function formal_arguments",
			TS "         | guard1    = function_alternative1",
			TS "         | guard2    = function_alternative2",
			TS "         | otherwise  = default_alternative",
			TS "         where",
			TS "             selector = expr",
			TS "             local_function args = function_body",
			[]
		]) [
			Rectangle ( 9.0*courier_char_width-2.0,    line_height)      ((50.0- 9.0)*courier_char_width,8.0*line_height-1.0),
			Rectangle (11.0*courier_char_width-2.0, 2.0*line_height-1.0) ((45.0-11.0)*courier_char_width,    line_height-1.0),
			Rectangle (11.0*courier_char_width-2.0, 3.0*line_height)     ((45.0-11.0)*courier_char_width,    line_height-1.0),
			Rectangle (28.0*courier_char_width-2.0, 7.0*line_height)     ((49.0-28.0)*courier_char_width,    line_height-1.0)
		]];
	= make_page pdf_i pdf_shl;

page_3_8 :: !{!CharWidthAndKerns} -> Page;
page_3_8 char_width_and_kerns
	# line_height = toReal line_height_i;
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS ("sieve and filter are local functions defined in a where block. They have only a meaning inside primes. "+++
							  "At the global level the functions are unknown."))
			(map syntax_color [
			[],
			TS "primes::[Int]",
			TS "primes = sieve [2..]",
			TS "where",
			TS "    sieve::[Int] -> [Int]                            // local function of primes",
			TS "    sieve [pr:r]  = [pr:sieve (filter pr r)]",
			[],
			TS "    filter::Int [Int] -> [Int]                       // local function of primes",
			TS "    filter pr [n:r]",
			TS "    | n mod pr == 0   = filter pr r",
			TS "    | otherwise       = [n:filter pr r]"
		]),P(
			TS ("Notice that the scope rules are such that the formal arguments of the surrounding function alternative are visible to the "+++
						"locally defined functions and graphs. The arguments can therefore directly be addressed in the local definitions. Such "+++
						"local definitions cannot always be typed explicitly (")
					TAL "see 3.7" TA ")."
		),PCH
			(TS "Alternative definition of " TAC "primes" TA ". The function filter is locally defined for "
						  TAC "sieve" TA "." TAC "filter" TA " can directly access arguments " TAC "pr" TA " of " TAC "sieve" TA ".")
			(map syntax_color [
			[],
			TS "primes::[Int]",
			TS "primes = sieve [2..]",
			TS "where",
			TS "    sieve::[Int] -> [Int]                            // local function of primes",
			TS "    sieve [pr:r]  = [pr:sieve (filter pr r)]",
			TS "    where",
			TS "        filter::Int [Int] -> [Int]                   // local function of sieve",
			TS "        filter pr [n:r]",
			TS "        | n mod pr == 0   = filter pr r",
			TS "        | otherwise       = [n:filter pr r]"
		]),H3
			"3.5.3" "With Block: Local Definitions in a Guarded Alternative"
		,P(
			TS "One can also locally define functions and graphs at the end of each guarded rule alternative using a "
			TAI "with block" TA "."
		),ST [
			[TS "LocalFunctionDefs",	TS_E,	TS "[" TABCr "with" TA "] " TABCb "{" TA " {LocalDef}+ " TABCb "}"],
			[TS "LocalDef",				TS_E,	TS "GraphDef"],
			[[],						TS_B,	TS "FunctionDef"]
		],P(
			TS "Functions and graphs defined in a " TAI "with"
			TA " block can only be used in the corresponding rule alternative as indicated in the following picture showing the scope of a "
			TAI "with" TA " block."
		),PCH
			(TS "The function and selectors defined in the " TAI "with"
						  TA " block can be locally only be used in the corresponding function alternative.")
			[]
		,CPCP
			(map color_keywords [
			[],
			TS "function formal arguments",
			TS "         | guard1     =   function_alternative1",
			TS "                          with",
			TS "                               selector = expr",
			TS "                               local_function args = function_body",
			[],
			TS "         | guard2     =   function_alternative2",
			TS "                          with",
			TS "                               selector = expr",
			TS "                               local_function args = function_body",
			[]
		]) [
			Rectangle ( 9.0*courier_char_width-2.0,  1.0*line_height+2.0) ((68.0- 9.0)*courier_char_width,    10.0*line_height+7.0),
			Rectangle (26.0*courier_char_width-2.0,  2.0*line_height+1.0) ((67.0-26.0)*courier_char_width+3.0, 4.0*line_height+2.0),
			Rectangle (46.0*courier_char_width-2.0,  5.0*line_height+1.0) ((67.0-46.0)*courier_char_width,         line_height-1.0),
			Rectangle (26.0*courier_char_width-2.0,  7.0*line_height+1.0) ((67.0-26.0)*courier_char_width+3.0, 4.0*line_height+2.0),
			Rectangle (46.0*courier_char_width-2.0, 10.0*line_height+1.0) ((67.0-46.0)*courier_char_width,         line_height-1.0)
		],P(
			TS ("Notice that the scope rules are such that the arguments of the surrounding guarded rule alternative are visible to the "+++
				"locally defined functions and graphs. The arguments can therefore directly be addressed in the local definitions. Such "+++
				"local definitions cannot always be typed explicitly (") TAL "see 3.7" TA ")."
		)
		];
	= make_page pdf_i pdf_shl;

page_3_9 :: !{!CharWidthAndKerns} -> Page;
page_3_9 char_width_and_kerns
	# line_height = toReal line_height_i;
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3
			"3.5.4" "Let-Before Expression: Local Constants defined between Guards"
		,P(
			TS ("Many of the functions for input and output in the CLEAN I/O library are state transition functions. Such a state is often "+++
				"passed from one function to another in a single threaded way (")
			TAL "see Chapter 9"
			TA (") to force a specific order of evaluation. This is certainly the case when the state is of unique type. "+++
				"The threading parameter has to be renamed to distinguish its different versions. The following example shows a typical example:")
		),PCH
			(TS ("Use of state transition functions. The uniquely typed state file is passed from one function to another "+++
							  "involving a number of renamings: file, file1, file2)"))
			(map color_keywords [
			[],
			TS "readchars:: *File -> ([Char], *File)",
			TS "readchars file",
			TS "| not ok     = ([],file1)",
			TS "| otherwise  = ([char:chars], file2)",
			TS "where",
			TS "    (ok,char,file1)   = freadc file",
			TS "    (chars,file2)     = readchars file1"
		]),MP [
			[],
			TS ("This explicit renaming of threaded parameters not only looks very ugly, these kind of definitions are sometimes also hard "+++
				"to read as well (in which order do things happen? which state is passed in which situation?). We have to admit: an "+++
				"imperative style of programming is much easier to read when things have to happen in a certain order such as is the "+++
				"case when doing I/O. That is why we have introduced ") TAI "let-before" TA " expressions.",
			[],
			TSI "Let-before" TA (" expressions are special let expressions that can be defined before a guard or function body. "+++
				"In this way one can specify sequential actions in the order in which they suppose to happen. ") TAI "Let-before"
			TA " expressions have the following syntax:"
		],ST2 [
			[TS "LetBeforeExpression",	TS_E,	TST "# " TA "{GraphDefOrUpdate}+",[]],
			[[],						TS_B,	TST "#!" TA "{GraphDefOrUpdate}+",[]],
			[TS "GraphDefOrUpdate",		TS_E,	TS "GraphDef",[]],
			[[],						TS_B,	TS "Variable " TAT "&" TA " {" TAC "FieldName" TA " {Selection} " TAT "=" TA" GraphExpr}-list " TABCb ";",
			 TS "// "TAL "see 5.2.1"],
			[[],						TS_B,	TS "Variable " TAT "&" TA " {ArrayIndex {Selection} " TAT "=" TA " GraphExpr}-list [" TAT "\\\\" TA " {Qualifier}-list] " TABCb ";",
			 TS "// "TAL "see 4.4.1"]
		],MP [
			[],
			TS "The form with the exclamation mark (" TAC "#!"
			TA (") forces the evaluation of the node-ids that appear in the left-hand sides of the definitions. Notice that one "+++
				"can only define constant selectors (GraphDef) in a Let-before expression. One cannot define functions."),
			[],
			TSI "Let-before"
			TA (" expressions have a special scope rule to obtain an imperative programming look. The variables in the left-"+++
				"hand side of these definitions do not appear in the scope of the right-hand side of that definition, but they do appear in "+++
				"the scope of the other definitions that follow (including the root expression, excluding local definitions in where blocks.")
		],PCH
			(TS "This is shown in the following picture:")
			[]
		,CPCP
			(map syntax_color [
			[],
			TS "Function args",
			TS "         # selector1  = expression1",
			TS "         | guard1     = expression2",
			TS "         # selector2  = expression3",
			TS "         | guard2     = expression4",
			TS "         where",
			TS "             local_definitions"
		])[
			Rectangle (9.0*courier_char_width-4.0,line_height) ((37.0-9.0)*courier_char_width+1.0,7.0*line_height-1.0),
			ClosedPath (9.0*courier_char_width-2.0, 6.0*line_height+2.0)
			[PLine ( 9.0*courier_char_width-2.0, 2.0*line_height+2.0),
			 PLine (21.0*courier_char_width-2.0, 2.0*line_height+2.0),
			 PLine (21.0*courier_char_width-2.0, 3.0*line_height+2.0),
			 PLine (36.0*courier_char_width,     3.0*line_height+2.0),
			 PLine (36.0*courier_char_width,     6.0*line_height+2.0)
			],
			ClosedPath ( 9.0*courier_char_width,     6.0*line_height+0.0)
			[PLine ( 9.0*courier_char_width,     4.0*line_height+2.0),
			 PLine (21.0*courier_char_width,     4.0*line_height+2.0),
			 PLine (21.0*courier_char_width,     5.0*line_height+2.0),
			 PLine (36.0*courier_char_width-2.0, 5.0*line_height+2.0),
			 PLine (36.0*courier_char_width-2.0, 6.0*line_height+0.0)
			]
		]
		,S(
			"Notice that a variable defined in a let-before expression cannot be used in a where expression. The reverse is true "+++
			"however: definitions in the where expression can be used in the let before expression."
		),PCH
			(TS "Use of let before expressions, short notation, re-using names taking use of the special scope of the let before)")
			[
			[],
			TS "readchars:: *File -> ([Char], *File)",
			TS "readchars file",
			TS "#   (ok,char,file)    = freadc file",
			TS "|   not ok            = ([],file)",
			TS "#   (chars,file)      = readchars file",
			TS "=   ([char:chars], file)"
		]
		];
	= make_page pdf_i pdf_shl;

page_3_10 :: !{!CharWidthAndKerns} -> Page;
page_3_10 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Equivalent definition renaming threaded parameters")
			[
			[],
			TS "readchars:: *File -> ([Char], *File)",
			TS "readchars file",
			TS "#   (ok,char,file1)   = freadc file",
			TS "|   not ok            = ([],file1)",
			TS "#   (chars, file2)    = readchars file1",
			TS "=   ([char:chars], file2)"
		],S(
			"The notation can also be dangerous: the same name is used on different spots while the meaning of the name is not "+++
					"always  the  same  (one has to  take  the  scope  into account which  changes  from  definition  to  definition).  However,  the "+++
					"notation  is  rather  safe  when  it  is  used  to  thread  parameters  of  unique  type.  The  type  system  will  spot  it  when  such "+++
					"parameters are not used in a correct single threaded manner. We do not recommend the use of let before expressions to "+++
					"adopt an imperative programming style for other cases."
		),PCH
			(TS "Abuse of let before expression.")
			[
			[],
			TS "exchange:: (a, b) -> (b, a)",
			TS "exchange (x, y)",
			TS "#   temp = x",
			TS "    x    = y",
			TS "    y    = temp",
			TS "=   (x, y)"
		],H2
			"3.6" "Defining Constants"
		,S(
			"One can give a name to a constant expression (actually a graph), such that the expression can be used in (and shared "+++
					"by) other expressions. One can also identify certain parts of a constant via a projection function called a selector (see "+++
					"below)."
		),ST [
			[TS "GraphDef",	TS_E,	TS "Selector " TAT "=" TA "[" TAT ":" TA "] GraphExpr " TABCb ";"]
		],PCH
			(TS "Graph locally defined in a function: the graph labeled " TAC "last" TA " is shared in the function "
						  TAC "StripNewline" TA " and computed only once.")
			(map syntax_color [
			[],
			TS "StripNewline:: String -> String",
			TS "StripNewline \"\" = \"\"", 
			TS "StripNewline string",
			TS "| string !! last<>'\\n' = string",
			TS "| otherwise            = string%(0,last-1)",
			TS "where",  
			TS "    last = maxindex string"
		]),MP [
			[],
			TS "When a " TAI "graph" TA " is " TAI "defined"
			TA " actually a name is given to (part) of an expression. The definition of a graph can be compared with a definition of a "
			TAI "constant" 
			TA "(data) or a" TAI "constant" TA " (" TAI "projection" TA ") " TAI "function"
			TA ". However, notice that graphs are constructed according to the basic semantics of CLEAN ("
			TAL "see Chapter 1" TA ") that means that multiple references to the same graph will result in "
			TAI "sharing" TA " of that graph. Recursive references will result in " TAI "cyclic graph structures"
			TA ". Graphs have the property that they " TAI "are computed only once" TA " and that their value is "
			TAI "remembered" TA "within the scope they are defined in.",
			[],
			TS "Graph definitions differ from constant function definitions. A " TAI "constant function definition"
			TA " is just a function defined with arity zero (" TAL "see 3.1"
			TA ("). A constant function defines an ordinary graph rewriting rule: multiple references to a function just "+++
				"means that the same definition is used such that a (constant) function ")
			TAI "will be recomputed again" TA " for each occurrence of " TAI "the function symbol made"
			TA ". This difference can have consequences for the time and space behavior of function definitions ("
			TAL "see 10.2" TA ")."
		],PCH
			(TS ("The Hamming numbers defined using a locally defined cyclic constant graph and defined by using a globally defined "+++
							  "recursive constant function. The first definition (ham1) is efficient because already computed numbers are reused via "+++
							  "sharing. The second definition (ham2 ) is much more inefficient because the recursive function recomputes everything."))
			(map syntax_color [
			[],
			TS "ham1:: [Int]",
			TS "ham1 = y",
			TS "where y = [1:merge (map ((*) 2) y) (merge (map ((*) 3) y) (map ((*) 5) y))]",
			[],
			TS "ham2:: [Int]",
			TS "ham2 = [1:merge (map ((*) 2) ham2) (merge (map ((*) 3) ham2) (map ((*) 5) ham2 ))]"
		])
		];
	= make_page pdf_i pdf_shl;

page_3_11 :: !{!CharWidthAndKerns} -> Page;
page_3_11 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS ("Syntactically the definition of a graph is distinguished from the definition of a function by the symbol "+++
				"which separates the left-hand side from the right-hand side: \"")
			TAC "=" TA "\" or \"" TAC "=>" TA "\" is used for functions, while \""
			TAC "=" TA "\" is used for local graphs and \"" TAC "=:"
			TA "\" for global graphs. However, in general \"" TAC "="
			TA ("\" is used both for functions and local graphs. Generally it is clear from the context which is meant (functions "+++
				"have parameters, selectors are also easy recognisible). However, when a simple constant is defined the syntax is "+++
				"ambiguous (it can be a constant function definition as well as a constant graph definition)."),
			[],
			TS "To allow the use of the \"" TAC "="
			TA "\" whenever possible, the following rule is followed. Local constant definitions are " TAI "by default"
			TA " taken to be " TAI "graph" TA " definitions and therefore shared, globally they are " TAI "by default"
			TA " taken to be " TAI "function" TA " definitions (" TAL "see 3.1"
			TA (") and therefore recomputed. If one wants to obtain a different behavior one has to explicit state the nature of the constant "+++
				"definition (has it to be shared or has it to be recomputed) by using \"")
			TAC "=:" TA "\" (on the global level, meaning it is a constant graph which is shared) or \"" TAC "=>"
			TA "\" (on the local level, meaning it is a constant function and has to be recomputed)."
		],PCH
			(TS "Local constant graph versus local constant function definition: "TAC "biglist1" TA " and " TAC "biglist2"
						  TA " is a " TAI "graph" TA " which is computed only once, " TAC "biglist3" TA " is a constant "
						  TAI "function" TA " which is computed every time it is applied. ")
			(map comment_blue [
						[],
						TS "biglist1 =   [1..10000]                 // a graph (if defined locally)",
						TS "biglist1 =   [1..10000]                 // a constant function (if defined globally)",
						TS "biglist2 =:  [1..10000]                 // a graph (if defined globally)",
						TS "biglist3 =>  [1..10000]                 // a constant function (always)"
		]),P(
			TS "The garbage collector will collect locally defined graphs when they are no longer connected to the root of the program graph ("
			TAL "see Chapter 1" TA ")."
		),H3
			"3.6.1" "Selectors"
		,MP [
			[],
			TS "The left-hand side of a graph definition can be a simple name, but is can also be a more complicated pattern called a selector. A "
			TAI "selector" TA " is a pattern which introduces one or more new "
			TAI "selector variables" TA " implicitly defining " TAI "projection functions"
			TA (" to identify (parts of) a constant graph being defined One can identify the sub-graph as a whole or one can "+++
				"identify its components. A selector can contain constants (also user defined constants introduced by algebraic type "+++
				"definitions), variables and wildcards. With a ")
			TAI "wildcard" TA " one can indicate that one is not interested in certain components.",
			[],
			TS "Selectors cannot be defined globally. They can only locally be defined in a let ("
			TAL "see 3.5.1" TA "), a let-before (" TAL "see 3.5.4" TA "), a where-block ("
			TAL "see 3.5.2" TA "), and a with-block (" TAL "see 3.5.3"
			TA "). Selectors can furthermore appear on the left-hand side of generators in list comprehensions ("
			TAL "see 4.2.1" TA ") and array comprehensions (" TAL "see 4.4.1" TA ")."
		],ST2 [
			[TS "Selector",	TS_E,	TS "BrackPattern",	TS "// " TAL "for bracket patterns see 3.2"]
		],PCH
			(TS "Use of a selector to locally select tuple elements.")
			(map color_keywords [
			[],
			TS "unzip::[(a,b)] -> ([a],[b])",
			TS "unzip []          = ([],[])",
			TS "unzip [(x,y):xys] = ([x:xs],[y:ys])",
			TS "where",
			TS "    (xs,ys) = unzip xys"
		]),MSP [
			TS "When a selector on the left-hand side of a graph definition is not matching the graph on the right-hand side it will result in a "
			TAI "run-time" TA " error.",
			TS ("The selector variables introduced in the selector must be different from each other and not already be used in the "+++
				"same scope and name space (") TAL "see 1.2" TA ").",
			TS ("To avoid the specification of patterns that may fail at run-time, it is not allowed to test on zero arity constructors. For "+++
				"instance, list used in a selector pattern need to be of form ")
			TAC "[a:_]" TA ". " TAC "[a]" TA " cannot be used because it stands for " TAC "[a:[]]"
			TA " implying a test on the zero arity constructor " TAC "[]"
			TA ". If the pattern is a record only those fields which contents one is interested in need to be indicated in the pattern",
			TS "Arrays cannot be used as pattern in a selector.",
			TS "Selectors cannot be defined globally."
		]
		];
	= make_page pdf_i pdf_shl;

page_3_12 :: !{!CharWidthAndKerns} -> Page;
page_3_12 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
	[H2
		"3.7" "Typing Functions"
	,P(
		TS "Although one is in general not obligated to explicitly specify the type of a function (the CLEAN compiler can in general "
		TAC "infer" TA " the type) the explicit specification of the type is " TAC "highly recommended"
		TA " to increase the readability of the program."
	),ST [
			[TS "FunctionDef",				TS_E,	TS "[FunctionTypeDef]"],
			[[],							[],		TS "DefOfFunction"],
			[[],							[],		[]],
			[TS "FunctionTypeDef",			TS_E,	TSC "FunctionName" TA " " TAT "::" TA " FunctionType " TABCb ";"],
			[[],							TS_B,	TST "(" TAC "FunctionName" TAT ")" TA " [Fix][Prec] [" TAT "::" TA" FunctionType] " TABCb ";"],
			[TS "Fix",						TS_E,	TSBCr "infixl"],
			[[],							TS_B,	TSBCr "infixr"],
			[[],							TS_B,	TSBCr "infix"],
			[TS "Prec",						TS_E,	TS "Digit"],
			[TS "FunctionType",				TS_E,	TS "Type " TAT "->" TA " Type [ClassContext] [UnqTypeUnEqualities]"],
			[TS "Type",						TS_E,	TS "{BrackType}+"],
			[TS "BrackType",				TS_E,	TS "[UniversalQuantVariables] [Strict] [UnqTypeAttrib] SimpleType"],
			[TS "UniversalQuantVariables",	TS_E,	TST "A." TA "{TypeVariable }+" TAT ":"]
	],MP [
		[],
		TS "An explicit specification is " TAC "required"
		TA (" when a function is exported, or when the programmer wants to impose additional restrictions on the application "+++
			"of the function (e.g. a more restricted type can be specified, strictness information can be added as explained in ")
		TAL "Chapter 10.1" TA ", a class context for the type variables to express overloading can be defined as explained in "
		TAL "Chapter 7" TA ", uniqueness information can be added as explained in 3.7.5 Functions with Strict Arguments).",
		[],
		TS ("The CLEAN type system uses a combination of Milner/Mycroft type assignment. This has as consequence that the type "+++
			"system in some rare cases is not capable to infer the type of a function (using the Milner/Hindley system) although it will "+++
			"approve a given type (using the Mycroft system; see Plasmeijer and Van Eekelen, 1993). Also when universally "+++
			"quantified types of rank 2 are used (")
		TAL "see 3.7.4" TA "), explicit typing by the programmer is required.",
		[],
		TS ("The Cartesian product is used for the specification of the function type. The Cartesian product is denoted by "+++
			"juxtaposition of the bracketed argument types. For the case of a single argument the brackets can be left out. In type "+++
			"specifications the binding priority of the application of type constructors is higher than the binding of the arrow ")
		TAC "->" TA ". To indicate that one defines an operator the function name is on the left-hand side surrounded by brackets."
	],CMSP [
		TS "The function symbol before the double colon should be the same as the function symbol of the corresponding rewrite rule.",
		TS ("The arity of the functions has to correspond with the number of arguments of which the Cartesian product is taken. "+++
			"So, in CLEAN one can tell the arity of the function by its type.")
	],PCH
		(TS "Showing how the arity of a function is reflected in type.")
		(map comment_blue [
		[],
		TS "map:: (a->b) [a] -> [b]                                   // map has arity 2",
		TS "map f []     =   []",
		TS "map f [x:xs] =   [f x : map f xs]",
		[],
		TS "domap:: ((a->b) [a] -> [b])                               // domap has arity zero",
		TS "domap = map"
	]),MSP [
		TS "The arguments and the result types of a function should be of kind " TAC "X" TA ".",
		TS ("In the specification of a type of a locally defined function one cannot refer to a type variable introduced in the type "+++
			"specification of a surrounding function (there is not yet a scope rule on types defined). The programmer can "+++
			"therefore not specify the type of such a local function. However, the type will be inferred and checked (after it is "+++
			"lifted by the compiler to the global level) by the type system.")
	]
	];

	= make_page pdf_i pdf_shl;

page_3_13 :: !{!CharWidthAndKerns} -> Page;
page_3_13 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Counter example (illegal type specification). The function " TAC "g"
						  TA " returns a tuple. The type of the first tuple element is the same as the type of the polymorphic argument of "
						  TAC "f" TA ". Such a dependency (here indicated by \"" TAC "^" TAC "\" cannot be specified).")
			(map syntax_color [
			[],
			TS "f:: a -> (a,a)",
			TS "f x = g x",
			TS "where",
			TS "    // g:: b -> (a^,b)",
			TS "    g y = (x,y)"
		]),H3
			"3.7.1" "Typing Curried Functions "
		,MP [
			[],
			TS "In CLEAN all symbols (functions and constructors) are defined with " TAI "fixed arity"
			TA ". However, in an application it is of course allowed to apply them to an arbitrary number of arguments. A "
			TAI "curried application"
			TA (" of a function is an application of a function with a number of arguments which is less than its arity (note that in CLEAN "+++
				"the arity of a function can be derived from its type). With the aid of the predefined internal function ") TAI "_AP"
			TA " a curried function applied on the required number of arguments is transformed into an equivalent uncurried function application.",
			[],				
			TS "The type axiom's of the CLEAN type system include for all "TAC "s" TA " defined with arity " TAC "n" 
			TA " the equivalence of " TAC "s::(t1->(t2->(...(tn->tr)...))" TA " with " TAC "s::t1 t2 ... tn -> tr" TA "."
		],H3
			"3.7.2" "Typing Operators"
		,P(
			TS "An " TAI "operator" TA " is a " TAI "function with arity two"
					TA (" that can be used in infix position. An operator can be defined by enclosing the operator name between "+++
						"parentheses in the left-hand-side of the function definition. An operator has a ")
					TAI "precedence" TA " (" TAC "0" TA " through " TAC "9" TA ", default " TAC "9" TA ") and a "
					 TABCr "fixity" TA " (" TABCr "infixl" TA ", " TABCr "infixr"
					TA " or just " TABCr "infix" TA ", default " TABCr "infixl"
					TA ("). A higher precedence binds more tightly. When operators have equal precedence, the fixity determines the priority. "+++
						"In an expression an ordinary function application always has the highest priority (")
					TAC "10" TA "). See also " TAL "Section 3.1" TA " and " TAL "3.4" TA "."
		),MSP [
			TS "The type of an operator must obey the requirements as defined for typing functions with arity two.",
			TS "If the operator is explicitly typed the operator name should also be put between parentheses in the type rule.",
			TS ("When an infix operator is enclosed between parentheses it can be applied as a prefix function. Possible recursive "+++
				"definitions of the newly defined operator on the right-hand-side also follow this convention.")
		],PCH
			(TS "Example of an operator definition and its type.")
			(map color_keywords [
			[],
			TS "(o) infix 8:: (x -> y) (z -> x) -> (z -> y)               // function composition",
			TS "(o) f g = \\x -> f (g x)"
		]),H3
			"3.7.3" "Typing Partial Functions"
		,P(
			TS "Patterns and guards imply a condition that has to be fulfilled before a rewrite rule can be applied ("
					TAL "see 3.2" TA " and "  TAL "3.3" TA "). This makes it possible to define "
					TAI "partial function s" TA ", functions which are not defined for all possible values of the specified type."
		),N
		,SP(
			TS "When a partial function is applied to a value outside the domain for which the function is defined it will result into a "
					TAI "run-time" TA " error. The compiler gives a warning when functions are defined which might be partial."
		),P(
			TS "With the " TAC "abort" TA " expression (see " TAC "StdMisc.dcl"
			TA ") one can change any partial function into a " TAI "total function" TA " (the " TAC "abort"  
			TA "expression can have any type). The abort expression can be used to give a user-defined run-time error message"
		),PCH
			(TS "Use of abort to make a function total.")
			[
			[],
			TS "fac:: Int -> Int",
			TS "fac 0        = 1",
			TS "fac n",
			TS "| n>=1       = n * fac (n - 1)",
			TS "| otherwise  = abort \"fac called with a negative number\""
		],H3
			"3.7.4" "Explicit use of the Universal Quantifier in Function Types"
		,S(
			"When a type of a polymorphic function is specified in CLEAN, the universal quantifier is generally left out."
		)]; 
 	= make_page pdf_i pdf_shl;

page_3_14 :: !{!CharWidthAndKerns} -> Page;
page_3_14 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "The function " TAC "map" TA " defined as usual, no universal quantifier is specified:")
			[
			[],
			TS "map:: (a->b) [a] -> [b]",
			TS "map f []     =   []",
			TS "map f [x:xs] =   [f x : map f xs]"
		],PCH
			(TSB "Counter Example." TA " The same function " TAC "map" TA (" again, but now the implicit assumed universal quantifier has been made "+++
							  "visible. It shows the meaning of the specified type more precisely, but is makes the type definition a bit longer as well. ")
							  ++orange_bold_s "The current version of Clean does not yet allow universal quantifiers on the topmost level !!")
			[
			[],
			TS "map:: A.a b: (a->b) [a] -> [b]",
			TS "map f []     =   []",
			TS "map f [x:xs] =   [f x : map f xs]"
		],P(
			orange_bold_s "Not yet Implemented:"
			TA (" In Clean 2.0 it is allowed to explicitly write down the universal quantifier. One can write down the qualifier "+++
				"A. (for all) direct after the :: in the type definition of a function. In this way one can explicitly introduce the type variables used in the "+++
				"type definition of the function. As usual, the type variables thus introduced have the whole function type definition as scope.")
		),ST [
			[TS "FunctionType",				TS_E,	TS "Type " TAT "->" TA " Type [ClassContext] [UnqTypeUnEqualities]"],
			[TS "Type",						TS_E,	TS "{BrackType}+"],
			[TS "BrackType",				TS_E,	TS "[UniversalQuantVariables] [Strict] [UnqTypeAttrib] SimpleType"],
			[TS "UniversalQuantVariables",	TS_E,	TST "A." TA "{TypeVariable }+" TAT ":"]
		],MP [
			[],
			orange_bold_s "Implemented:"
			TA (" CLEAN 2.0 offers Rank 2 polymorphism: it is also possible to specify the universal quantifier with as scope "+++
				"the type of an argument of a function or the type of the result of a function. This makes it possible to pass polymorphic "+++
				"functions as an argument to a function which otherwise would be treated monomorphic. The advantage of the use of "+++
				"Rank 2 polymorphism is that more programs will be approved by the type system, but one explicitly (by writing down the "+++
				"universal quantifier) has to specify in the type of function that such a polymorphic function is expected as argument or "+++
				"delivered as result."),
			[],
			orange_bold_s "Not yet Implemented:" TA " We will allow Rank N polymorphism. We are working on it."
		],PCH
			(TS "Example: The function " TAC "h" TA " is used to apply a polymorphic function of type "
						  TAC "(A.a: [a] -> Int)" TA " to a list of " TAC "Int" TA "as well as a list of " TAC "Char"
						  TA ". Due to the explicit use of the universal quantifier in the type specification of "
						  TAC "h" TA " this definition is approved.")
			[
			[],
			TS "h:: (A.a: [a] -> Int) -> Int",
			TS "h f = f [1..100] + f [\'a\'..\'z\']",
			[],
			TS "Start = h length"
		],PCH
			(TSB "Counter Example:" TA " The function " TAC "h2" TA " is used to apply a function of type "
						  TAC "([a] -> Int)" TA " to a list of Int as well as a list of " TAC "Char"
						  TA ". In this case the definition is rejected due to a type unification error. It is assumed that the argument of "
						  TAC "h2" TA " is unifiable with " TAC "[a] -> Int" TA ", but it is not assumed that the argument of " TAC "h2"
						  TA " is " TAC "(A.a: [a] -> Int)" TA ". So, the type variable a is unified with both " 
						  TAC "Int" TA " and " TAC "Char" TA ", which gives rise to a type error.")
			[
			[],
			TS "h2:: ([a] -> Int) -> Int",
			TS "h2 f = f [1..100] + f [\'a\'..\'z\']",
			[],
			TS "Start = h2 length"
		],PCH
			(TSB "Counter Example: " TA "The function h3 is used to apply a function to a list of " TAC "Int"
						  TA " as well as a list of " TAC "Char" TA ". Since no type is specified the type inference system will assume "
						  TAC "f" TA " to be of type " TAC "([a] -> Int)" TA " but not of type " TAC "(A.a: [a] -> Int)"
						  TA ". The situation is the same as above and we will again get a type error.")
			[
			[], 
			TS "h3 f = f [1..100] + f [\'a\'..\'z\']",
			[],
			TS "Start = h3 length"
		],MSP [
			TS ("CLEAN cannot infer polymorphic functions of Rank 2 automatically! One is obligated to explicitly specify universally "+++
				"quantified types of Rank 2."),
			TS ("Explicit universal quantification on higher ranks than rank 2 (e.g. quantifiers specified somewhere inside the type "+++
				"specification of a function argument) is not allowed."),
			TS ("A polymorphic function of Rank 2 cannot be used in a curried way for those arguments in which the function is "+++
				"universally quantified.")
		]
		];
	= make_page pdf_i pdf_shl;

page_3_15 :: !{!CharWidthAndKerns} -> Page;
page_3_15 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TSB "Counter Examples:" TA " In the example below it is shown that " TAC "f1" TA " can only be used when applied to "
						  TAI "all" TA " its arguments since its last argument is universally quantified. The function " TAC "f2"
						  TA " can be used curried only with respect to its last argument that is not universally quantified.")
			(map syntax_color [
			[],
			TS "f1:: a (A.b:b->b) -> a",
			TS "f1 x id = id x",
			[],
			TS "f2:: (A.b:b->b) a -> a",
			TS "f2 id x = id x",
			[],
			TS "illegal1 = f1                               // this will raise a type error",
			[],
			TS "illegal2 = f1 3                             // this will raise a type error",
			[],
			TS "legal1 :: Int",
			TS "legal1 = f1 3 id where id x = x             // ok",
			[],
			TS "illegal3 = f2                               // this will raise a type error",
			[],
			TS "legal2 :: (a -> a)",
			TS "legal2 = f2 id where id x = x               // ok",
			[],
			TS "legal3 :: Int",
			TS "legal3 = f2 id 3 where id x = x             // ok"
		]),H3
			"3.7.5" "Functions with Strict Arguments "
		,P(
			TS ("In the type definition of a function the arguments can optionally be annotated as being strict. In reasoning about functions "+++
				"it will always be true that the corresponding arguments will be in strong root normal form (") TAL "see 2.1"
			TA (") before the rewriting of the function takes place. In general, strictness information "+++
				"will increase the efficiency of execution (") TAL "see Chapter 10" TA ")."
		),PCH
			(TS "Example of a function with strict annotated arguments.")
			[
			[],
			TS "Acker:: !Int !Int -> Int",
			TS "Acker 0 j =  inc j",
			TS "Acker i 0 =  Acker (dec i) 1",
			TS "Acker i j =  Acker (dec i) (Acker i (dec j))"
		],P(
			TS ("The CLEAN compiler includes a fast and clever strictness analyzer that is based on abstract reduction (N"+++odieresis_string+++"cker, 1993). "+++
				"The compiler can derive the strictness of the function arguments in many cases, such as for the example above. "+++
				"Therefore there is generally no need to add strictness annotations to the type of a function by hand. When a function is "+++
				"exported from a module (")
			TAL "see Chapter 2"
			TA ("), its type has to be specified in the definition module. To obtain optimal efficiency, the programmer should also "+++
				"include the strictness information to the type definition in the definition module. One can ask the compiler to print "+++
				"out the types with the derived strictness information and paste this into the definition module.")
		),N
		,SP(
			TS ("Notice that strictness annotations are only allowed at the outermost level of the argument type. Strictness "+++
						"annotations inside type instances of arguments are not possible (with exception for some predefined types like "+++
						"tuples and lists). Any (part of) a data structure can be changed from lazy to strict, but this has to be specified "+++
						"in the type definition (") TAL "see 5.1.5" TA ")."
		)];
	= make_page pdf_i pdf_shl;
