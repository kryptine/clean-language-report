implementation module clean_manual_strictness_macros;

import StdEnv,pdf_main,pdf_text,pdf_fonts,clean_manual_styles,clean_manual_text;

pages_10 :: [{!CharWidthAndKerns} -> Page];
pages_10 = [page_10_1,page_10_2,page_10_3,page_10_4,page_10_5];

page_10_1 :: !{!CharWidthAndKerns} -> Page;
page_10_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 10" "Strictness, Macros and Efficiency"
		,MP [
			[],
			TS ("Programming in a functional language means that one should focus on algorithms and without worrying about all kinds of "+++
				"efficiency details. However, when large applications are being written it may happen that this attitude results in a "+++
				"program that is unacceptably inefficient in time and/or space."),
			[],
			TS ("In this Chapter we explain several kinds of annotations and directives that can be defined in CLEAN. These annotations "+++
				"and directives are designed to give the programmer some means to influence the time and space behavior of CLEAN "+++
				"applications."),
			[],
			TS "CLEAN is by default a " TAI "lazy"
			TA (" language: applications will only be evaluated when their results are needed for the final "+++
				"outcome of the program. However, lazy evaluation is in general not very efficient. It is much more efficient to compute "+++
				"function arguments in advance (") TAI "strict"
			TA (" evaluation) when it is known that the arguments will be used in the function body. "+++
				"By using strictness annotations in type definitions the evaluation order of data structures and functions can be changed "+++
				"from lazy to strict. This is explained in ") TAL "Section 10.1" TA ".",
			[],
			TS "One can define constant graphs on the global level also known as " TAC "Constant Applicative Forms"
			TA " (" TAL "see Section 10.2"
			TA ("). Unlike "+++
				"constant functions, these constant graphs are shared such that they are computed only one. This generally reduces "+++
				"execution time possibly at the cost of some heap space needed to remember the shared graph constants."),
			[],
			TS "Macro's (" TAL "Section 10.3" TA ") are special functions that will already be substituted (evaluated) at " TAI "compile-time"
			TA (". This generally reduces execution time (the work has already been done by the compiler) but it will lead to an increase "+++
				"of object code.")
		],H2
			"10.1" "Annotations to Change Lazy Evaluation into Strict Evaluation"
		,P(
			TS "CLEAN uses by default a " TAI "lazy evaluation strategy"
			TA ": a redex is only evaluated when it is needed to compute the final result. Some functional languages (e.g. ML, Harper "
			TAI "et al." TA ") use an " TAI "eager" TA "  (" TAI "strict"
			TA ") evaluation strategy and always evaluate all function arguments in advance."
		),H3
			"10.1.1" "Advantages and Disadvantages of Lazy versus Strict Evaluation"
		,S(
			"Lazy evaluation has the following advantages (+) / disadvantages (-) over eager (strict) evaluation:"
		),MBP [
			TS ("only those computations which contribute to the final result are computed (for some algorithms this "+++
				"is a clear advantage while it generally gives a greater expressive freedom);"),
			TS "one can work with infinite data structures (e.g. [1..])",
			TS "it is unknown when a lazy expression will be computed (disadvantage for debugging, for controlling evaluation order);",
			TS ("strict evaluation is in general much more efficient, in particular for objects of basic types, non-recursive types and "+++
				"tuples and records which are composed of such types;")
		],PW "+/-" indent_width (
			TS "in general a strict expression (e.g. " TAC "2" TA" " TAC "+" TA " " TAC "3" TA " " TAC "+" TA " " TAC "4"
			TA ") takes less space than a lazy one, however, sometimes the other way around (e.g. " TAC "[1..1000]" TA ");"
		)
		];
	= make_page pdf_i pdf_shl;

page_10_2 :: !{!CharWidthAndKerns} -> Page;
page_10_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3
			"10.1.2" "Strict and Lazy Context"
		,P(
			TS "Each expression in a function definition is considered to be either strict (appearing in a " TAI "strict context"
			TA ": it has to be evaluated to strong root normal form) or lazy (appearing in a " TAI "lazy context"
			TA (" : not yet to be evaluated to strong root normal form)  The following rules specify whether or not "+++
				"a particular expression is lazy or strict:")
		),MBP [
			TS "a non-variable pattern is strict;",
			TS "an expression in a guard is strict;",
			TS "the expressions specified in a strict let-before expression are strict;",
			TS "the "++TSB "root expression" TA " is strict;",
			TS ("the arguments of a function or data constructor in a strict context are strict when these arguments are being annotated "+++
			"as strict in the type definition of that function (manually or automatically) or in the type definition of the data "+++
			"constructor;"),
			TS "all the other expressions are lazy."
		],P(
			TS ("Evaluation of a function will happen in the following order: patterns, guard, expressions in a strict let before expression, "+++
				"root expression (") TAL "see also 3.1" TA ")."
		),H3
			"10.1.3" "Space Consumption in Strict and Lazy Context"
		,MP [
			[],
			TS ("The space occupied by CLEAN structures depend on the kind of structures one is using, but also depends on whether "+++
				"these data structures appear in a strict or in a lazy context. To understand this one has to have some knowledge about "+++
				"the basic implementation of CLEAN (see Plasmeijer and Van Eekelen, 1993)."),
			[],
			TS "Graphs (" TAL "see Chapter 1"
			TA (") are stored in a piece of memory called the heap. The amount of heap space needed highly "+++
				"depends on the kind of data structures that are in use. Graph structures that are created in a lazy context can occupy "+++
				"more space than graphs created in a strict context. The garbage collector in the run-time system of CLEAN automatically "+++
				"collects graphs that are not being used. The arguments of functions being evaluated are stored on a stack. There are "+++
				"two stacks: the A-stack, which contains references to graph nodes stored in the heap and the BC-stack which contains "+++
				"arguments of basic type and return addresses. Data structures in a ") TAI "lazy context"
			TA " are passed via references on the A-stack. Data structures of the " TAI "basic types"
			TA " (" TAC "Int" TA ", " TAC "Real" TA ", " TAC "Char" TA " or " TAC "Bool" TA ") in a " TAI "strict context"
			TA " are stored on the B-stack or in registers. This is also the case for these strict basic types when they are part of a "
			TAI "record" TA " or " TAI "tuple" TA " in a strict context.",
			[],
			TS "Data structures living on the B-stack are passed " TAI "unboxed"
			TA (". They consume less space (because they are not part of a node) and can be treated much more efficiently. When a function "+++
				"is called in a lazy context its data structures are passed in a graph node (") TAI "boxed"
			TA "). The amount of space occupied is also depending on the arity of the function.",
			[],
			TS ("In the table below the amount of space consumed in the different situations is summarised (for the lazy as well as for the "+++
				"strict context). For the size of the elements one can take the size consumed in a strict context."),
			[]
		],TB [
			[TSI "Type",				TSI "Arity",	TSI "Lazy context (bytes)",	TSI "Strict context (bytes)",	TSI	"Comment"],
			[TSC "Int,Bool",			TSC "-",		TSC "8",					TSC "4",						TS ""],
			[TSC ("Int (0"+++lessequal_string+++"n"+++lessequal_string+++"32), Char  "),
										TSC "-",		TSC "-",					TSC "4",						TS "node is shared"],
			[TSC "Real",				TSC "-",		TSC "12",					TSC "8",						TS ""],
			[TSC "Small Record",		TSC "n",		TSC ("4 + "+++Sigma_string+++" size elements"),	
																					TSC (Sigma_string+++" size elements"),
																													TS ("total length"+++lessequal_string+++"12")],
			[TSC "Large Record",		TSC "n",		TSC ("8 + "+++Sigma_string+++" size elements"),
																					TSC (Sigma_string+++" size elements"),
																													TS ""],
			[TSC "Tuple",				TSC "2",		TSC "12",					TSC (Sigma_string+++" size elements"),
																													TS ""],
			[TS "",						TSC ">2",		TSC "8  + 4*n",				TSC (Sigma_string+++" size elements"),
																													TS ""],
			[TSC "{a}",					TSC "n",		TSC "20 + 4*n",				TSC "12 + 4*n",					TS ""],
			[TSC " !Int",				TSC "n",		TSC "20 + 4*n",				TSC "12 + 4*n",					TS ""],
			[TSC " !Bool,!Char",		TSC "n",		TSC "20 + 4*ceil(n/4)",		TSC "12 + 4*ceil(n/4)",			TS ""],
			[TSC " !Real",				TSC "n",		TSC "20 + 8*n",				TSC "12 + 8*n",					TS ""],
			[TSC " !Tuple, !Record",	TSC "n",		TSC "20 + size rec/tup*n",	TSC "12 + size rec/tup*n",		TS ""],
			[TSC "Hnf",					TSC "0",		TSC "-",					TSC "4 + size node",			TS "node is shared "],
			[TS "",						TSC "1",		TSC "8",					TSC "4 + size node",			TS ""],
			[TS "",						TSC "2",		TSC "12",					TSC "4 + size node",			TS "also for " TAC "[a]"],
			[TS "",						TSC ">2",		TSC "8  + 4*n",				TSC "4 + size node",			TS ""],
			[TSC "Pointer to node",		TSC "-",		TSC "4",					TSC "4",						TS ""],
			[TSC "Function",			TSC "0,1,2",	TSC "12",					TSC "-",						TS ""],
			[TS "",						TSC ">2",		TSC "4  + 4*n",				TSC "-",						TS ""]
		]
		];
	= make_page pdf_i pdf_shl;

page_10_3 :: !{!CharWidthAndKerns} -> Page;
page_10_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3 "10.1.4" "Time Consumption in Strict and Lazy Context"
		,S(
			"Strict arguments of functions can sometimes be handled much more efficiently than lazy arguments, in particular when "+++
			"the arguments are of basic type."
		),PCH
			(TS "Example: functions with strict arguments of basic type are more efficient.")
			[
			[],
			TS "Ackerman:: !Int !Int -> Int",
			TS "Ackerman 0 j = j+1",
			TS "Ackerman i 0 = Ackerman (i-1) 1",
			TS "Ackerman i j = Ackerman (i-1) (Ackerman i (j-1))",
			[]
		],CPCH
			(TS "The computation of a lazy version of " TAC "Ackerman 3 7"
			 TA (" takes 14.8 seconds + 0.1 seconds for garbage collection on an old fashion MacII (5Mb heap). "+++
			      "When both arguments are annotated as strict (which in this case will be done automatically by "+++
				  "the compiler) the computation will only take 1.5 seconds + 0.0 seconds garbage collection. The gain "+++
				  "is one order of magnitude. Instead of rewriting graphs the calculation is performed using stacks and registers "+++
				  "where possible. The speed is comparable with a recursive call in highly optimised C or with the speed obtainable "+++
				  "when the function was programmed directly in assembly."))
			[
		],H3
			"10.1.5" "Changing Lazy into Strict Evaluation"
		,S(
			"So, lazy evaluation gives a notational freedom (no worrying about what is computed when) but it might cost space as "+++
			"well as time. In CLEAN the default lazy evaluation can therefore be turned into eager evaluation by adding strictness "+++
			"annotations to types."
		),ST [
			[TS "Strict",	TS_E,	TST "!"]
		],S(
			"This can be done in several ways:"
		),MBP [
			TS "The CLEAN compiler has a built-in strictness analyzer based on " TAI "abstract reduction"	// (Nöcker, 1993)
			TA (" N"+++odieresis_string+++"cker, 1993) (it can be optionally turned off). The analyzer searches for "+++
				"strict arguments of a function and annotate them internally as strict (")
			TAL "see 10.1.1" TA "). In this way lazy arguments are " TAI "automatically"
			TA (" turned into strict ones. This optimization does not influence the termination behavior of the program. It appears that "+++
				"the analyzer can find much information. The analysis itself is quite fast."),
			TS "The strictness analyzer cannot find all strict arguments. Therefore one can also " TAI "manually"
			TA " annotate a function as being strict in a certain argument or in its result (" TAL "see 10.1.1" TA ").",
			TS ("By using strictness annotations, a programmer can define (partially) strict data structures "+++
				"N"+++odieresis_string+++"cker and Smetsers, 1993; ") TAL "see 10.1.3"
			TA "). Whenever such a data structure occurs in a strict context (" TAL "see 10.1.1"
			TA "), its strict components will be evaluated.",
			TS (" The order of evaluation of expressions in a function body can also be changed from lazy to strict by using a "+++
				"strict let-before expression ") TAL "see 3.5.4" TA ")."
		],P(
			TSI ("One has to be careful though. When a programmer manually changes lazy evaluation into strict evaluation, the "+++
				 "termination behavior of the program might change. It is only safe to put strictness annotations in the case that the "+++
				 "function or data constructor is known to be strict in the corresponding argument which means that the evaluation of that "+++
				 "argument in advance does not change the termination behavior of the program. The compiler is not able to check this.")
		),H2
			"10.2" "Defining Graphs on the Global Level"
		,P(
			TS "Constant graphs can also be defined on a global level (for local constant graphs see " TAL "3.6" TA ")."
		),ST [
			[TS "GraphDef",	TS_E,	TS "Selector " TAT "=" TA "[" TAT ":" TA "] GraphExpr " TABCb ";"]
		]
		];
	= make_page pdf_i pdf_shl;

page_10_4 :: !{!CharWidthAndKerns} -> Page;
page_10_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "A " TAI "global graph definition"
			TA (" defines a global constant (closed) graph, i.e. a graph which has the same scope as a global "+++
				"function definition (") TAL "see 2.1"
			TA ("). The selector variables that occur in the selectors of a global graph definition have a global "+++
				"scope just as globally defined functions."),
			[],
			TS "Special about " TAI "global" TA " graphs (in contrast with " TAI "local"
			TA " graphs) is that they are " TAI "not"
			TA " garbage collected during the evaluation of the program  A global graph can be compared with a "
			TAI "CAF" TA " (" TAI "Constant Applicative Form"
			TA ("): its value is computed at most once and remembered at run-time. A global graph can save execution-time "+++
				"at the cost of permanent space consumption."),
			[],
			TS ("Syntactically the definition of a graph is distinguished from the definition of a function by the symbol "+++
				"which separates the left-hand side from the right-hand side: \"")
			TAC "=" TA "\" or \"" TAC "=>" TA "\" is used for functions, while \""
			TAC "=" TA "\" is used for local graphs and \"" TAC "=:"
			TA "\" for global graphs. However, in general \"" TAC "="
			TA ("\" is used both for functions and local graphs. Generally it is clear from the context which is meant (functions "+++
				"have parameters, selectors are also easy recognisible). However, when a simple constant is defined the syntax is "+++
				"ambiguous (it can be a constant function definition as well as a constant graph definition)."),
			[],
			TS "To allow the use of the \"" TAC "=" TA "\" whenever possible, the following rule is followed. Locally constant definitions are "
			TAI "by default" TA " taken to be " TAI "graph" TA " definitions and therefore shared, globally they are "
			TAI "by default" TA " taken to be " TAI "function" TA " definitions (" TAL "see 3.1" TA ") "
			TA ("and therefore recomputed. If one wants to obtain a different behavior one has to explicit state the nature of the constant "+++
				"definition (has it to be shared or has it to be recomputed) by using \"") TAC "=:"
			TA "\" (on the global level, meaning it is a constant graph which is shared) or \"" TAC "=>"
			TA "\" (on the local level, meaning it is a constant function and has to be recomputed)."
		],PCH
			(TS " Global constant graph versus global constant function definition: " TAC "biglist1"
			 TA " is a " TAI "graph" TA " which is computed only once, " TAC "biglist3" TA " and " TAC "biglist2"
			 TA " is a constant " TAI "function" TA " which is computed every time it is applied.")
			(map comment_blue [
			[],
			TS "biglist1 =   [1..10000]                // a constant function (if defined globally)",
			TS "biglist2 =:  [1..10000]                // a graph (if defined globally)",
			TS "biglist3 =>  [1..10000]                // a constant function"
		]),S(
			"A graph saves execution-time at the cost of space consumption. A constant function saves space at the cost of "+++
			"execution time. So, use graphs when the computation is time-consuming while the space consumption is small and "+++
			"constant functions in the other case."
		),H2
			"10.3" "Defining Macros"
		,MP [
			[],
			TS "Macros are functions (rewrite rules) which are applied at " TAI "compile-time"
			TA " instead of at " TAI "run-time"
			TA (". Macro's can be used to define constants, create in-line substitutions, rename functions, do "+++
				"conditional compilation etc. With a macro definition one can, for instance, assign a name to a "+++
				"constant such that it can be used as pattern on the left-hand side of a function definition."),
			[],
			TS "At compile-time the right-hand side of the " TAI "macro definition"
			TA (" will be substituted for every application of the macro in the scope of the macro definition. This saves a "+++
				"function call and makes basic blocks larger (see Plasmeijer and Van Eekelen, 1993) such that ")
			TAI "better" TA " code can be generated. A disadvantage is that also " TAI "more"
			TA (" code will be generated. Inline substitution is also one of the regular optimisations performed by the "+++
				"CLEAN compiler. To avoid code explosion a compiler will generally not substitute big functions. Macros give "+++
				"the programmer a possibility to control the substitution process manually to get an optimal trade-off "+++
				"between the efficiency of code and the size of the code.")
		],ST [
			[TS "MacroDef",			TS_E,	TS "[MacroFixityDef]"],
			[[],					[],	    TS "DefOfMacro"],
			[TS "MacroFixityDef",	TS_E,	TST "(" TAC "FunctionName" TAT ")" TA " [FixPrec] " TABCb ";"],
			[TS "DefOfMacro",		TS_E,	TS "Function {Variable} " TAT ":==" TA " FunctionBody " TABCb ";"],
			[[],					[],		TS "[LocalFunctionAltDefs]"]
		],S(
			"The compile-time substitution process is guaranteed to terminate. To ensure this some restrictions are imposed on "+++
			"Macro's (compared to common functions). Only variables are allowed as formal argument. A macro rule always consists "+++
			"of a single alternative. Furthermore,"
		),PW "8)" indent_width (
			TS "Macro definitions are not allowed to be cyclic to ensure that the substitution process terminates."
		),PCH
			(TS "Example of a macro definition.")
			(map comment_blue [
			[],
			TS "Black    :== 1                                       // Macro definition",
			TS "White    :== 0                                       // Macro definition",
			[],
			TS ":: Color :== Int                                     // Type synonym definition",
			[],
			TS "Invert:: Color -> Color                              // Function definition",
			TS "Invert Black = White",
			TS "Invert White = Black"
		])
		];
	= make_page pdf_i pdf_shl;

page_10_5 :: !{!CharWidthAndKerns} -> Page;
page_10_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example: macro to write (a?b) for lists instead of [a:b] and its use in the function map.")
			(map syntax_color [
			[],
			TS "(?) infixr 5                                         // Fixity of Macro",
			TS "(?) h t :== [h:t]                                    // Macro definition of operator",
			[],
			TS "map:: (a -> b) [a] -> [b]",
			TS "map f (x?xs) = f x ? map f xs",
			TS "map f []     = []"
		]),S(
			"Notice that macros can contain local function definitions. These local definitions (which can be recursive) will also be "+++
			"substituted inline. In this way complicated substitutions can be achieved resulting in efficient code."
		),PCH
			(TS "Example: macros can be used to speed up frequently used functions. See for instance the definition of the function "
			 TAC "foldl" TA " in " TAC "StdList" TA ".")
			(map syntax_color [
			[],
			TS "foldl op r l :== foldl r l                           // Macro definition",
			TS "where",
			TS "    foldl r []    = r",
			TS "    foldl r [a:x] = foldl (op r a) x",
			[],
			TS "sum list = foldl (+) 0 list",
			[]
		]),CPCH
			(TS "After substitution of the macro " TAC "foldl" TA " a very efficient function "
			 TAC "sum" TA " will be generated by the compiler:")
			[
			[],
			TS "sum list = foldl 0 list",
			TS "where",
			TS "    foldl r []    = r",
			TS "    foldl r [a:x] = foldl ((+) r a) x"
		],S(
			"The expansion of the macros takes place before type checking. Type specifications of macro rules are not possible. "+++
			"When operators are defined as macros, fixity and associativity can be defined."
		),H2
			"10.4" "Efficiency Tips"
		,S(
			"Here are some additional suggestions how to make your program more efficient:"
		),MBP [
			TS ("Use the CLEAN profiler to find out which frequently called functions are consuming a lot of "+++
				"space and/or time. If you modify your program, these functions are the ones to have a good look at."),
			TS "Transform a recursive function to a tail-recursive function.",
			TS "It is better to accumulate results in parameters instead of in the right-hand side results.",
			TS "It is better to use records instead of tuples.",
			TS ("Arrays can be more efficient than lists since they allow constant access time on their elements and can be "+++
			    "destructive updated."),
			TS ("When functions return multiple ad-hoc results in a tuple put these results in a strict tuple instead "+++
				"(can be indicated in the type)."),
			TS "Use strict data structures whenever possible.",
			TS "Export the strictness information to other modules (the compiler will warn you if you don't).",
			TS "Make function strict in its arguments whenever possible.",
			TS "Use macros for simple constant expressions or frequently used functions.",
			TS "Use CAF's and local graphs to avoid recalculation of expressions.",
			TS "Selections in a lazy context can better be transformed to functions which do a pattern match.",
			TS ("Higher order functions are nice but inefficient (the compiler will try to convert "+++
				"higher order function into first order functions)."),
			TS "Constructors of high arity are inefficient.",
			TS "Increase the heap space in the case that the garbage collector takes place too often."
		]
		];
	= make_page pdf_i pdf_shl;
