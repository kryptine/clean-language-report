implementation module clean_manual_overloading;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

pages_6 :: [{!CharWidthAndKerns} -> Page];
pages_6 = [page_6_1,page_6_2,page_6_3,page_6_4,page_6_5,page_6_6,page_6_7,page_6_8];

page_6_1 :: !{!CharWidthAndKerns} -> Page;
page_6_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 6" "Overloading"
		,MP [
			[],
			TS "CLEAN allows functions and operators to be " TAI "overloaded" TA ". " TAI "Type classes"
			TA (" and type constructor classes are provided (which look similar to Haskell (Hudak et  al. "+++
				"1992) and Gofer (Jones, 1993), although our classes have slightly different "+++
				"semantics) with which a restricted context can be imposed on a type variable in a type specification."),
			[],
			TS "If one defines a function it should in general have a name that is " TAI "different"
			TA " from all other function names defined within the same scope and name space ("
			TAL "see 2.1" TA "). However, it is sometimes very convenient to " TAI "overload"
			TA " certain  functions and operators (e.g. " TAC "+" TA "," TAC "-" TA "," TAC "==" TA "), i.e. use "
			TAI "identical" TA " names for " TAI "different" TA " functions or operators that perform " TAI "similar tasks"
			TA " albeit on objects of " TAI "different types" TA ".",
			[],
			TS "In principle it is possible to simulate a kind of overloading by using records. One simply defines a record ("
			TAL "see 5.2"
			TA (") in which a collection of functions are stored that somehow belong to each other. Now the field name of the "+++
				"record can be used as (overloaded) synonym for any concrete function stored on the corresponding position. The "+++
				"record can be regarded as a kind of ") TAI "dictionary" TA " in which the concrete function can be looked up."
		],PCH
			(TS "Example of the use of a dictionary record to simulate overloading. " TAI "sumlist"
			 TA (" can use the field name add as synonym for any concrete function "+++
				 "obeying the type as specified in the record definition. The operators ")
			 TAC "+." TA ", " TAC "+^" TA ", " TAC "-." TA " and " TAC "-^"
			 TA " are assumed to be predefined primitives operators for addition and subtraction on the basic types "
			 TAC "Real" TA " and " TAC "Int" TA ".")
			[
			[],
			TS "::Arith a =  {    add      :: a a -> a ",
			TS "             ,    subtract :: a a -> a ",
			TS "             } ",
			[],
			TS "ArithReal = { add = (+.), subtract = (-.) } ",
			TS "ArithInt  = { add = (+^), subtract = (-^) } ",
			[],
			TS "sumlist:: (Arith a) [a] [a] -> [a] ",
			TS "sumlist arith [x:xs] [y:ys]    =  [arith.add x y:sumlist arith xs ys] ",
			TS "sumlist arith x y              =  [] ",
			[],
			TS "Start = sumlist ArithInt [1..10] [11..20]"
		],P(
			TS ("A disadvantage of such a dictionary record is that it is syntactically not so nice (e.g. one explicitly has to pass the record "+++
				"to the appropriate function) and that one has to pay a huge price for efficiency (due to the use of higher order functions) "+++
				"as well. CLEAN's overloading system as introduced below enables the CLEAN system to automatically create and add "+++
				"dictionaries as argument to the appropriate function definitions and function applications. To avoid efficiency loss the "+++
				"CLEAN compiler will substitute the intended concrete function for the overloaded function application where possible. In "+++
				"worst case however CLEAN's overloading system will indeed have to generate a dictionary record that is then automatically "+++
				"passed as additional parameter to the appropriate function.")
		)
		];
	= make_page pdf_i pdf_shl;

page_6_2 :: !{!CharWidthAndKerns} -> Page;
page_6_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
			[H2 "6.1" "Type Classes"
			,P(
				TS "In a " TAI "type class definition" TA " one gives a name to a " TAI "set of overloaded functions"
				TA " (this is similar to the definition of a type of the dictionary record as explained above). For each "
				TAI "overloaded function" TA " or " TAI "operator" TA " which is a " TAI "member" TA " of the class the "
				TAI "overloaded name" TA " and its " TAI "overloaded type" TA " is specified. The " TAI "type class variables"
				TA (" are used to indicate how the different instantiations of the class vary from each other. "+++
					"CLEAN offers multi-parameter type constructor classes, similar to those available in Haskell.")
			),ST [
			[TS "TypeClassDef",	TS_E,	TSBCr "class" TA " ClassName TypeVariable+ [ClassContext]"],
		    [[],				[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA " {ClassMemberDef}+ " TABCb "}" TA "] " TABCb ";"],
			[[],				TS_B,	TSBCr "class" TA " FunctionName TypeVariable+ " TAT "::" TA " FunctionType" TABCb ";"],
			[[],				TS_B,	TSBCr "class" TA " (FunctionName) [FixPrec] TypeVariable+ " TAT "::" TA " FunctionType" TABCb ";"]
			],ST [
				[TS "ClassMemberDef",	TS_E,	TS "FunctionTypeDef"],
				[[],					[],		TS "[MacroDef]"]
			],PCH
				(TS "Example of the definition of a type class; in this case the class named " TAC "Arith"
				 TA " contains two overloaded operators.")
				(map color_keywords [
				[],
				TS "class Arith a",
				TS "where",
				TS "    (+) infixl 6:: a a -> a",
				TS "    (-) infixl 6:: a a -> a"
			]),PCH
				(TS "Example. Classes can have several type class variables.")
				(map color_keywords [
				[],
				TS "class Arith2 a b c",
				TS "where",
				TS "    (:+:) infixl 6:: a b -> c"
			]),P(
				TS "With an " TAI "instance declaration"
				TA (" an instance of a given class can be defined (this is similar to the creation of a dictionary "+++
					"record). When the instance is made one has to be specify for which ")
				TAI "concrete type" TA " an instance is created. For each overloaded function in the class an "
				TAI "instance of the overloaded function" TA " or " TAI "operator"
				TA (" has to be defined. The type of the instance can be found via uniform substitution of the type class "+++
					"variables by the corresponding type instances specified in the instance definition.")
			),ST2 [
			[TS "TypeClassInstanceDef",	TS_E,	TSBCr "instance" TA " " TAC "ClassName" TA " Type+ [ClassContext]",
			 []],
			[[],						[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA "{FunctionDef}+ " TABCb "}" TA "] " TABCb ";",
			 TS "// in implementation modules"],
			[[],						[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA "{FunctionTypeDef}+ " TABCb "}" TA "] [Special] " TABCb ";",
			 TS "// in definition modules"]
			],PCH
				(TS "Example of the definition of an instance of a type class " TAC "Arith" TA " for type " TAC "Int"
				 TA (". The type of the concrete functions can be  obtained via uniform substitution of the type class "+++
					 "variable in the class definition by the corresponding type specified in the instance definition. "+++
					 "One is not obliged to repeat the type of the concrete functions instantiated (nor the fixity or "+++
					 "associativity in the case of operators)."))
				(map color_keywords [
				[],
				TS "instance Arith Int",
				TS "where",
				TS "    (+):: Int Int -> Int",
				TS "    (+) x y = x +^ y",
				[],
				TS "    (-):: Int Int -> Int",
				TS "    (-) x y = x -^ y"
			]),PCH
				(TS "Example of the definition of an instance of a type class " TAC "Arith" TA " for type " TAC "Real" TA ".")
				(map color_keywords [
				[],
				TS "instance Arith Real",
				TS "where",
				TS "    (+) x y = x +. y",
				TS "    (-) x y = x -. y"
			])
			];
	= make_page pdf_i pdf_shl;

page_6_3 :: !{!CharWidthAndKerns} -> Page;
page_6_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example. Instantiation of " TAC "Arith2" TA " using the instantiations of " TAC "Arith" TA " specified above.")
			(map color_keywords [
			[],
			TS "instance Arith2 Int  Int  Int  where (:+:) x y = x + y",
			TS "instance Arith2 Int  Real Real  where (:+:) x y = toReal x + y",
			TS "instance Arith2 Real Int  Real  where (:+:) x y = x + toReal y",
			TS "instance Arith2 Real Real Real where (:+:) x y = x + y"
		]),S(
			"One can define as many instances of a class as one likes. Instances can be added later on in any module that has "+++
			"imported the class one wants to instantiate."
		),SP(
			TS "When an instance of a class is defined a concrete definition has to be given for all the class members."
		),H2
			"6.2" "Functions Defined in Terms of Overloaded Functions"
		,S(
			"When an overloaded name is encountered in an expression, the compiler will determine which of the corresponding "+++
			"concrete functions/operators is meant by looking at the concrete type of the expression. This type is used to determine "+++
			"which concrete function to apply."
		),P(
			TS "All instances of a type variable of a certain class have to be of a flat type (see the restrictions mentioned in "
			TAL "6.11" TA ")."
		),S(
			"If it is clear from the type of the expression which one of the concrete instantiations is meant the compiler will in principle "+++
			"substitute the concrete function for the overloaded one, such that no efficiency is lost."
		),PCH
			(TS "Example of the substitution of a concrete function for an overloaded one. Given the definitions above the function")
			[
			[],
			TS "inc n = n + 1",
			[]
		],CPCH
			(TS "will be internally transformed into")
			[
			[],
			TS "inc n = n +^ 1"
		],S(
			"However, it is very well possible that the compiler, given the type of the expression, cannot decide which one of the "+++
			"corresponding concrete functions to apply. The new function then becomes overloaded as well."
		),PCH
			(TS "For instance, the function")
			[
			[],
			TS "add x y = x + y",
			[]
		],CPCH
			(TS "becomes overloaded as well because it cannot be determined which concrete instances can be applied: "
			 TAC "add" TA "can be applied to arguments of any type, as long as addition (" TAC "+" TA ") is defined on them.")
			[
		],P(
			TS "This has as consequence that an additional restriction must be imposed on the type of such an expression. A "
			TAI "class context"
			TA (" has to be added to the function type to express that the function can only be applied provided that "+++
				"the appropriate type classes have been instantiated (in fact one specifies the type of the dictionary "+++
				"record which has to be passed to the function in worst case). Such a context can also be regarded as an "+++
				"additional restriction imposed on a type variable, introducing a kind of ") TAI "bounded polymorphism" TA "."
		),ST [
			[TS "FunctionType",			TS_E,	TS "[{ArgType}+ " TAT "->" TA "] Type [ClassContext] [UnqTypeUnEqualities]"],
			[TS "ClassContext",			TS_E,	TST "|" TA " ClassOrGenericName-list {SimpleType}+ {" TAT "&" TA " ClassOrGenericName-list {SimpleType}+}"],
			[TS "ClassOrGenericName",	TS_E,	TSC "ClassName"],
			[[],						TS_B,	TSC "FunctionName" TA " " TAT "{|" TA "TypeKind" TAT "|}"]
		],PCH
			(TS "Example of the use of a class context to impose a restriction on the instantiation of a type variable. The function "
			 TAC "add" TA" can be applied on arguments of any type under the condition that an instance of the class "
			 TAC "Arith" TA " is defined on them.")
			[
			[],
			TS "add:: a a -> a | Arith a",
			TS "add x y = x + y"
		],S(
			"CLEAN's type system can infer class contexts automatically. If a type class is specified as a restricted context the type "+++
			"system will check the correctness of the specification (as always a type specification can be more restrictive than is "+++
			"deduced by the compiler)."
		)
		];
	= make_page pdf_i pdf_shl;

page_6_4 :: !{!CharWidthAndKerns} -> Page;
page_6_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2
			"6.3" "Type Classes Defined in Terms of Overloaded Functions"
		,S(
			"The concrete functions defined in a class instance definition can also be defined in terms of (other) overloaded functions. "+++
			"This is reflected in the type of the instantiated functions. Both the concrete type and the context restriction have to be "+++
			"specified."
		),PCH
			(TS "Example of an instance declaration with a type which is depending on the same type class. The function "
			 TAC "+" TA " on lists can be defined in terms of the overloaded operator " TAC "+"
			 TA "on the list elements. With this definition " TAC "+"
			 TA "is defined not only on lists, but also on a list of lists etcetera.")
			(map syntax_color [
			[],
			TS "instance Arith [a] | Arith a                        // on lists",
			TS "where",
			TS "    (+) infixl 6:: [a] [a] -> [a] | Arith a",
			TS "    (+) [x:xs] [y:ys] = [x + y:xs + ys]",
			TS "    (+) _       _     = []",
			[],
			TS "    (-) infixl 6:: [a] [a] -> [a] | Arith a",
			TS "    (-) [x:xs] [y:ys] = [x - y:xs - ys]",
			TS "    (-) _      _      = []"
		]),PCH
			(TS "Equality class.")
			(map syntax_color [
			[],
			TS "class Eq a",
			TS "where",
			TS "  (==) infix 2:: a a -> Bool",
			[],
			TS "instance Eq [a] | Eq a                              // on lists",
			TS "where",
			TS "    (==) infix 2:: [a] [a] -> Bool | Eq a",
			TS "    (==) [x:xs] [y:ys] = x == y && xs == ys",
			TS "    (==) []     []     = True",
			TS "    (==) _      _      = False"
		]),H2
			"6.4" "Type Constructor Classes"
		,P(
			TS "The CLEAN type system offers the possibility to use higher order types (" TAL "see 3.7.1"
			TA "). This makes it possible to define " TAI "type constructor classes"
			TA (" (similar to constructor classes as introduced in Gofer, Jones (1993)). In that case the "+++ 
				"overloaded type variable of the type class is not of kind ") TAC "X"
			TA ", but of higher order, e.g. " TAC "X -> X" TA ", " TAC "X -> X -> X"
			TA (", etcetera. This offers the possibility to define overloaded functions that can be instantiated with "+++
				"type constructors of higher order (as usual, the overloaded type variable and a concrete instantiation "+++
				"of this type variable need to be of the same kind). This makes it possible to overload more complex functions "+++
				"like map and the like.")
		),PCH
			(TS "Example of a definition of a type constructor class. The class " TAC "Functor"
			 TA " including the overloaded function " TAC "map" TA " which varies in type variable "
			 TAC "f" TA " of kind " TAC "X -> X" TA ".")
			(map color_keywords [
			[],
			TS "class Functor f",
			TS "where",
			TS "    map:: (a -> b) (f a) -> (f b)"
		]),PCH
			(TS "Example of an instantiation of a type constructor class. An instantiation of the well-known function "
			 TAC "map" TA " applied on lists (" TAC "[]" TA " is of kind " TAC "X -> X"
			 TA "), and a map function defined on " TAC "Tree" TA "'s (" TAC "Tree" TA " is of kind " TAC "X -> X" TA ").")
			(map color_keywords [
			[],
			TS "instance Functor []",
			TS "where",
			TS "    map:: (a -> b) [a] -> [b]",
			TS "    map f [x:xs] = [f x : map f xs]",
			TS "    map f []     = []",
			[],
			TS "::Tree a = (/\\) infixl 0 (Tree a) (Tree a)",
			TS "         | Leaf a",
			[],
			TS "instance Functor Tree",
			TS "where",
			TS "    map:: (a -> b) (Tree a) -> (Tree b)",
			TS "    map f (l/\\r)      = map f l /\\ map f r",
			TS "    map f (Leaf a)    = Leaf (f a)"
		])
		];
	= make_page pdf_i pdf_shl;

page_6_5 :: !{!CharWidthAndKerns} -> Page;
page_6_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS ("CLEAN 2.0 offers the possibility to define generic functions. With generic functions one is able to define "+++
						"a function like ") TAC "map" TA " once that works for " TAI "any" TA " type (see ???)."
		),H2
			"6.5" "Overlapping Instances"
		,S(
			"Identical instances of the same class are not allowed. The compiler would not know which instance to choose. However, "+++
			"it is not required that all instances are of different type. It is allowed to specify an instance of a class of which the types "+++
			"overlap with some other instance given for that class, i.e. the types of the different class instances are different but they "+++
			"can be unified with each other. It is even allowed to specify an instance that works for any type, just by instantiating with "+++
			"a type variable instead of instantiating with a concrete type. This can be handy to define a simple default case (see also "+++
			"the section one generic definitions). If more than one instance is applicable, the compiler will always choose the most "+++
			"specific instantiation."
		),PCH
			(TS "Example of overlapping instances. Below there are three instances given for the class "
			 TAC "Eq" TA ": one for " TAC "Int" TA "eger values, one for " TAC "Real"
			 TA (" values, and one for objects of any type. The latter instance is more general and overlaps "+++
				 "with both the other instances that are more specific. If ")
			 TAC "Int" TA "egers or " TAC "Real"
			 TA ("s are compared, the corresponding equality function will be chosen. For all other types for "+++
				 "which no specific instances for equality are defined, the general instance will be chosen. "))
			(map syntax_color [
			[],
			TS "class Eq a",
			TS "where",
			TS "    (==) infix 2:: a a -> Bool",
			[],
			TS "instance Eq Int                                  // on Integers",
			TS "where",
			TS "    (==) x y = x ==^ y",
			[],
			TS "instance Eq Real                                 // on Reals",
			TS "where",
			TS "    (==) x y = x ==. y",
			[],
			TS "instance Eq a                                   // generic instance for Eq",
			TS "where",
			TS "    (==) x y = False"
		]),P(
			TS ("It is sometimes unclear which of the class instances is the most specific. In that case the lexicographic "+++
				"order is chosen looking at the specified instances (with type variables always ") TAC "<=" TA " type constructors)."
		),PCH
			(TS "Example of overlapping instances. The two instances of class " TAC "C"
			 TA " overlap with each other. In the " TAC "Start" TA " rule the function " TAC "f"
			 TA " is applied to two " TAC "Bool" TA "ean values. In this case any of the two instances of "
			 TAC "f" TA " could be chosen. They both can be applied (one has type "
			 TAC "f::Bool a -> Bool" TA ", the other " TAC "f::a Bool -> Bool" TA ", " TAC "Start"
			 TA " requires " TAC "f:: Bool Bool -> Bool"
			 TA "). The compiler will choose the first instance, because in lexicographical order "
			 TAC " instance C Bool dontcare" TA " <= " TAC "instance C dontcare Bool" TA ".")
			(map syntax_color [
			[],
			TS "class C a1 a2",
			TS "where",
			TS "    f:: a1 a2 -> Bool",
			[],
			TS "instance C Bool dontcare",
			TS "where",
			TS "    f b x  = b",
			[],
			TS "instance C dontcare Bool",
			TS "where",
			TS "    f x b  = b",
			[],
			TS "Start = f True False                     // the result will yield True"
		]),H2
			"6.6" "Internal Overloading"
		,P(
			TS "It is possible that a CLEAN expression using overloaded functions is internally ambiguously overloaded"
			TA (". The problem can occur when an overloaded function is used which has on overloaded "+++
				"type in which an overloaded type variable appears on the right-hand side of the ") TAC "->"
			TA (". If such a function is applied in such a way that the overloaded type does not appear in "+++
				"the resulting type of the application, any of the available instances of the overloaded function can be used.")
		),N
		,SP(
			TS ("In that case that an overloaded function is internally ambiguously overloaded the compiler cannot "+++
				"determine which instance to take: a type error is given.")
		)
		];
	= make_page pdf_i pdf_shl;

page_6_6 :: !{!CharWidthAndKerns} -> Page;
page_6_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
	[PCH
		(TSB "Counter example" TA " (ambiguous internal overloaded expression). The function body of " TAC "f"
					  TA (" is internally ambiguously overloaded which results in a type error. It is not possible to determine "+++
						  "whether its argument should be converted to an ") TAC "Int" TA " or to a " TAC "Bool" TA ".")
		(map syntax_color [
		[],
		TS "class Read  a:: a -> String",
		[],
		TS "class Write a:: String -> a",
		[],
		TS "instance Read  Int, Bool                        // export of class instance, see 6.10",
		[],
		TS "instance Write Int, Bool",
		[],
		TS "f:: String -> String",
		TS "f x = Write (Read x)                            // ! This results in a type error !"
	]),S(
		"One can solve such an ambiguity by splitting up the expression in parts that are typed "+++
		"explicitly such that it becomes clear which of the instances should be used."
	),PC (map color_keywords [
			TS "f:: String -> String",
			TS "f x = Write (MyRead x)",
			TS "where",
			TS "    MyRead:: Int -> String",
			TS "    MyRead x = Read x"
	]),PCH
		(TSB "Counter example" TA " (ambiguous internal overloaded expression). The function " TAC ":+:"
		 TA (" is internally ambiguously overloaded which results in a type error. The compiler is not able "+++
		 	 "to infer the result type ") TAC "c" TA " of the multi parameter type class " TAC "Arith2 a b c"
		 TA (". The reason is that the compiler will first do the type unification and then tries to solve the "+++
			 "overloading. In this case solving the overloading will have consequences for other overloading "+++
			 "situations. The system can only solve one overloaded situation at a time and solving the overloading "+++
			 "may not have any effect on other unifications."))
		[
		[],
		TS "Start :: Int",
		TS "Start = 2 :+: 3 :+: 4"
	],PCH
		(TSB "Example " TA ("(ambiguous internal overloaded expression). By explicitly specifying types the "+++
					  "overloading can be solved. The following program is accepted."))
		(map color_keywords [
		[],
		TS "Start:: Int",
		TS "Start = 2 :+: more",
		TS "where",
		TS "    more:: Int",
		TS "    more = 3 :+: 4"
	]),H2
		"6.7" "Defining Derived Members in a Class"
	,P(
		TS ("The members of a class consist of a set of functions or operators that logically belong to each other. "+++
			"It is often the case that the effect of some members (") TAI "derived members"
		TA ") can be expressed in others. For instance, "
		TAC "<>" TA " can be regarded as synonym for " TAC "not (==)"
		TA (". For software engineering (the fixed relation is made explicit) and efficiency (one does not need to include such "+++
			"derived members in the dictionary record) it is good to make this relation explicit. In CLEAN the existing macro facilities (")
		TAL "see Chapter 10.3" TA ") are used for this purpose."
	)
	];
	= make_page pdf_i pdf_shl;

page_6_7 :: !{!CharWidthAndKerns} -> Page;
page_6_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Classes with macro definitions to specify derived members.")
			(map color_keywords [
			[],
			TS "class Eq a",
			TS "where",
			TS "    (==) infix 2:: a a -> Bool",
			[],
			TS "    (<>) infix 2:: a a ->  Bool | Eq a",
			TS "    (<>) x y :== not (x == y)",
			[],
			TS "class Ord a",
			TS "where",
			TS "    (<) infix 2:: a a ->  Bool",
			[],
			TS "    (>) infix 2:: a a ->  Bool | Ord a",
			TS "    (>) x y :== y < x",
			[],
			TS "    (<=) infix 2:: a a ->  Bool | Ord a",
			TS "    (<=) x y :== not (y<x)",
			[],
			TS "    (>=) infix 2:: a a ->  Bool | Ord a",
			TS "    (>=) x y :== not (x<y)",
			[],
			TS "min:: a a -> a | Ord a",
			TS "min x y :== if (x<y) x y",
			[],
			TS "max:: a a -> a | Ord a",
			TS "max x y :== if (x<y) y x"
		]),H2
			"6.8" "A Shorthand for Defining Overloaded Functions"
		,S(
			"A class definition seems sometimes a bit overdone when a class actually only consists of one member. "+++
			"Special syntax is provided for this case."
		),ST [
			[TS "TypeClassDef",	TS_E,	TSBCr "class" TA " ClassName TypeVariable+ [ClassContext]"],
		    [[],				[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA " {ClassMemberDef}+ " TABCb "}" TA "] " TABCb ";"],
			[[],				TS_B,	TSBCr "class" TA " FunctionName TypeVariable+ " TAT "::" TA " FunctionType" TABCb ";"],
			[[],				TS_B,	TSBCr "class" TA " (FunctionName) [FixPrec] TypeVariable+ " TAT "::" TA " FunctionType" TABCb ";"]
		],PCH
			(TS "Example of an overloaded function/operator.")
			(map color_keywords [
			[],
			TS "class (+) infixl 6 a:: a a -> a",
			[]
		]),CPCH
			(TS "which is shorthand for:")
			(map color_keywords [
			[],
			TS "class + a",
			TS "where",
			TS"     (+) infixl 6:: a a -> a"
		]),S(
			"The instantiation of such a simple one-member class is done in a similar way as with ordinary classes, "+++
			"using the name of the overloaded function as class name."
		),PCH
			(TS "Example of an instantiation of an overloaded function/operator.")
			(map color_keywords [
			[],
			TS "instance + Int",
			TS "where",
			TS "    (+) x y = x +^ y"
		]),H2
			"6.9" "Classes Defined in Terms of Other Classes"
		,P(
			TS ("In the definition of a class one can optionally specify that other classes that already have been defined elsewhere are "+++
				"included. The classes to include are specified as context after the overloaded type variable. It is not needed (but it is "+++
				"allowed) to define new members in the class body of the new class. In this way one can give a new name to a collection "+++
				"of existing classes creating a hierarchy of classes (cyclic dependencies are forbidden). Since one and the same class "+++
				"can be included in several other classes, one can combine classes in different kinds of meaningful ways. For an example "+++
				"have a closer look at the CLEAN standard library (see e.g. ")
			TAC "StdOverloaded" TA " and " TAC "StdClass" TA ")"
		)
		];
	= make_page pdf_i pdf_shl;

page_6_8 :: !{!CharWidthAndKerns} -> Page;
page_6_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of defining classes in terms of existing classes. The class "
			 TAC "Arith" TA " consists of the class " TAC "+" TAC " and " TAC "-" TA ".")
			[
			[],
			TS "class (+) infixl 6 a:: a a -> a",
			[],
			TS "class (-) infixl 6 a:: a a -> a",
			[],
			TS "class Arith a | +,- a"
		],H2
			"6.10" "Exporting Type Classes"
		,P(
			TS "To export a class one simply repeats the class definition in the definition module ("
			TAL "see Chapter 2"
			TA "). To export an instantiation of a class one simply repeats the instance definition in the definition module, however "
			TAI "without"
			TA " revealing the concrete implementation (which can only be specified in the implementation module)."
		),ST2 [
			[TS "TypeClassInstanceDef",	TS_E,	TSBCr "instance" TA " " TAC "ClassName" TA " Type+ [ClassContext]",
			 []],
			[[],						[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA "{FunctionDef}+ " TABCb "}" TA "] " TABCb ";",
			 TS "// only in implementation modules"],
			[[],						[],		TS "[[" TABCr "where" TA "] " TABCb "{" TA "{FunctionTypeDef}+ " TABCb "}" TA "] [Special] " TABCb ";",
			 TS "// only in definition modules"],
			[TS "Special",				TS_E,	TSBCr "special" TA " " TABCb "{" TA "{" TAC "TypeVariable" TA " " TAT "=" TA " Type}-list" TA " { " TABCb ";" TA " {" TAC "TypeVariable" TA " " TAT "=" TA " Type}-list }" TABCb "}",
			 []]
		],PCH
			(TS "Exporting classes and instances.")
			(map syntax_color [
			[],
			TS "definition module example",
			[],
			TS "class Eq a                         // the class Eq is exported",
			TS "where",
			TS "    (==) infix 2:: a a -> Bool",
			[],
			TS "instance Eq [a] | Eq a             // an instance of Eq on lists is exported",
			TS "special  a = Int                   // with an additional specialised version for [Int]",
			TS "         a = Real                  // and an additional specialised version for [Real]",
			[],
			TS "instance Eq  a                     // a general instance of Eq is exported"
		]),MP [
			[],
			TS ("For reasons of efficiency the compiler will always make specialized efficient versions of overloaded functions inside an "+++
				"implementation module. For each concrete application of an overloaded function a specialized version is made for the "+++
				"concrete type the overloaded function is applied to. So, when an overloaded function is used in the implementation "+++
				"module in which the overloaded function is defined, no overhead is introduced."),
			[],
			TS ("However, when an overloaded function is exported it is unknown with which concrete instances the function will be "+++
				"applied. So, a dictionary record is constructed in which the concrete function can be stored as is explained in the "+++
				"introduction of this Section. This approach can be very inefficient, especially in comparison to a specialized version. One "+++
				"can therefore ask the compiler to generate specialized versions of an overloaded function that is being exported. This "+++
				"can be done by using the keyword ") TABCr "special"
			TA (". If the exported overloaded function will be used very frequently, we advise "+++
				"to specialize the function for the most important types it will be applied on."),
			[]
		],SP(
			TS ("A specialised function can only be generated if for all type variables which appear in the "+++
				"instance definition of a class a concrete type is defined.")
		),H2
			"6.11" "Semantic Restrictions on Type Classes"
		,S(
			"Semantic restrictions:"
		),CMSP [
			TS "When a class is instantiated a concrete definition must be given for each of the members in the class (not for derived members).",
			TS ("The type of a concrete function or operator must exactly match the overloaded type after uniform substitution of the "+++
				"overloaded type variable by the concrete type as specified in the corresponding type instance declaration."),
			TS "The overloaded type variable and the concrete type must be of the same kind.",
			TS "A type instance of an overloaded type must be a " TAI "flat type" TA ", i.e. a type of the form " TAC "T a1 ... an"
			TA " where " TAC "ai" TA " are type variables which are " TAI "all" TA " different.",
			TS "It is not allowed to use a type synonym as instance.",
			TS "The start rule cannot have an overloaded type.",
			TS "For the specification of derived members in a class the same restrictions hold as for defining macros.",
			TS "A restricted context can only be imposed on one of the type variables appearing in the type of the expression.",
			TS "The specification of the concrete functions can only be given in implementation modules.",
			TS ("A specialised function can only be generated if for all type variables which appear in the "+++
				"instance definition of a class a concrete type is defined."),
			TS "A request to generate a specialised function for a class instance can only be defined in a definition module."
		]
		];
	= make_page pdf_i pdf_shl;
