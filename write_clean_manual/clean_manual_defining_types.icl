implementation module clean_manual_defining_types;

import StdEnv,pdf_main,pdf_text,pdf_graphics,pdf_fonts,clean_manual_styles,clean_manual_text;

courier_char_width = toReal font_size*0.6;

pages_5 :: [{!CharWidthAndKerns} -> Page];
pages_5 = [page_5_1,page_5_2,page_5_3,page_5_4,page_5_5,page_5_6,page_5_7,page_5_8,page_5_9,page_5_10,page_5_11];

page_5_1 :: !{!CharWidthAndKerns} -> Page;
page_5_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 5" "Defining New Types"
		,MP [
			[],
			TS ("CLEAN is a strongly typed language: every object (graph) and function (graph rewrite rule) in CLEAN has a type. The basic "+++
				"type system of CLEAN is based on the classical polymorphic Milner/Hindley/Mycroft (Milner  1978; Hindley 1969, Mycroft, "+++
				"1984) type system. This type system is adapted for graph rewriting systems and extended with ")
			TAI "basic types" TA ", (possibly " TAI "existentially and universally quantified" TA ") " TAI "algebraic types"
			TA ", " TAI "record types" TA ", " TAI "abstract types" TA " and " TAI "synonym types" TA ".",
			[],
				TS "New types can be defined in an implementation as well as in a definition module. Types can " TAI "only"
				TA (" be defined on the global level. Abstract types can only be defined in a definition module hiding the actual implementation "+++
					"in the corresponding implementation module.")
		],ST2 [
			[TS "TypeDef",	TS_E,	TS "AlgebraicTypeDef",			TS "// " TAL "see 5.1"],
			[[],			TS_B,	TS "RecordTypeDef",				TS "// " TAL "see 5.2"],
			[[],			TS_B,	TS "SynonymTypeDef",			TS "// " TAL "see 5.3"],
			[[],			TS_B,	TS "AbstractTypeDef",			TS "// " TAL "see 5.4"],
			[[],			TS_B,	TS "AbstractSynonymTypeDef",	[]],
			[[],			TS_B,	TS "ExtensibleAlgebraicTypeDef",[]],
			[[],			TS_B,	TS "AlgebraicTypeDefExtension",	[]],
			[[],			TS_B,	TS "NewTypeDef",				[]]
		],H2
			"5.1" "Defining Algebraic Data Types"
		,MP [
			[],
			TS ("With an algebraic data type one assigns a new type constructor (a new type) to a newly introduced data structure. The "+++
				"data structure consists of a new constant value (called the data constructor) that can have zero or more arguments (of "+++
				"any type). Every data constructor must unambiguously have been (pre) defined in an algebraic data type definition  Several "+++
				"data constructors can be introduced in one algebraic data type definition which makes it possible to define alternative "+++
				"data structures of the same algebraic data type. The data constructors can, just like functions, be used in a curried "+++
				"way. Also type constructors can be used in a curried way, albeit only in the type world of course."),
			[],
			TS ("Polymorphic algebraic data types can be defined by adding (possibly existentially or universally quantified, see below) "+++
				"type variables to the type constructors on the left-hand side of the algebraic data type definition. The arguments of the "+++
				"data constructor in a type definition are type instances of types (that are defined or are being defined)."),
			[],
			TS "Types can be preceded by uniqueness type attributes (" TAL "see Chapter 9"
			TA "). The arguments of a defined data constructor can optionally be annotated as being strict (" TAL "see 5.1.5" TA ")."
		],ST [
			[TS "AlgebraicTypeDef",	TS_E,	TST "::" TA "TypeLhs",	TST "=" TA " ConstructorDef"], 
			[[],					[],		[],						TS "{" TAT "|" TA " ConstructorDef} " TABCb ";"]
		],ST [
			[TS "TypeLhs",				TS_E,	TS "[" TAT "*" TA "] TypeConstructor {[" TAT "*" TAC "]TypeVariable" TA "}"],
			[TS "TypeConstructor",		TS_E,	TSC "TypeName"],
			[TS "ConstructorDef",		TS_E,	TS "[ExistQuantVariables] " TAC "ConstructorName" TA " {ArgType} {" TAT "&" TA " ClassConstraints}"],
			[[],						TS_B,	TS "[ExistQuantVariables] " TAT "(" TAC "ConstructorName" TAT ")" TA " [FixPrec] {ArgType} {" TAT "&" TA " ClassConstraints}"],
			[TS "FixPrec",				TS_E,	TSBCr "infixl" TA " [Prec]"],
			[[],						TS_B,	TSBCr "infixr" TA " [Prec]"],
			[[],						TS_B,	TSBCr "infix" TA " [Prec]"],
			[TS "Prec",					TS_E,	TS "Digit"],
			[[],						[],		[]],
			[TS "BrackType",			TS_E,	TS "[Strict] [UnqTypeAttrib] SimpleType"],
			[TS "ArgType",				TS_E,	TS "BrackType"],
			[[],						TS_B,	TS "[Strict] [UnqTypeAttrib] " TAT "(" TA "UnivQuantVariables Type [ClassContext]" TAT ")"],
			[TS "ExistQuantVariables",	TS_E,	TST "E." TA "{TypeVariable }+" TAT ":"],
			[TS "UnivQuantVariables",	TS_E,	TST "A." TA "{TypeVariable }+" TAT ":"] 
		]
		];
	= make_page pdf_i pdf_shl;

page_5_2 :: !{!CharWidthAndKerns} -> Page;
page_5_2 char_width_and_kerns
	# line_height = toReal line_height_i;
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of an algebraic type definition and its use.")
			(map comment_blue [
			[],
			TS "::Day = Mon | Tue | Wed | Thu | Fri | Sat | Sun",
			TS "::Tree a = NilTree",
			TS "         | NodeTree a (Tree a) (Tree a)",
			[],
			TS "MyTree:: (Tree Int)                    // constant function yielding a Tree of Int",
			TS "MyTree = NodeTree 1 NilTree NilTree"
		]),MP [
			[],
			TS ("An algebraic data type definition can be seen as the specification of a grammar in which is specified what legal data "+++
				"objects are of that specific type. Notice that all other CLEAN types (basic, list, tuple, array, record, abstract types) can be "+++
				"regarded as special cases of an algebraic type."),
			[],
			TS "Constructors with two arguments can be defined as " TABCr "infix"
			TA " constructor, in a similar way as function operators (with fixity (" TABCr "infixl"
			TA ", " TABCr "infixr" TA " or just " TABCr "infix" TA ", default " TABCr "infixl"
			TA ") and precedence (" TAC "0" TA " through " TAC "9" TA ", default " TAC "9"
			TA "). If infix constructors are surrounded by brackets they can also be used in prefix position (" TAL "see 3.1"
			TA " and " TAL "3.4" TA "). In a pattern match they can be written down in infix position as well.",
			[]
		],SP(
			TS "When a constructor operator is used in infix position (in an expression or in a in a pattern) " TAI "both"
			TA (" arguments have to be present. Constructor operators can be used in a curried way, but then they have to be "+++
				"used as ordinary prefix constructors (") TAL "see 3.1" TA " and " TAL "3.4" TA ")."
		),PCH
			(TS "Algebraic type definition and constructor pattern in function definition.")
			(map syntax_color [
			[],
			TS "::Tree2 a    = (/\\) infixl 0 (Tree a) (Tree a)",
			TS "             | Value a",
			[],
			TS "Mirror:: (Tree2 a) -> Tree2 a",
			TS "Mirror (left/\\right)  = Mirror right/\\Mirror left",
			TS "Mirror leaf           = leaf"
		]),PCH
			(TS "Example of an algebraic type defining an infix data constructor and a function on this type; notice that one cannot use a '"
			 TAC ":" TA "' because this character is already reserved.")
			(map syntax_color [
			[],
			TS "::List a = (<:>) infixr 5 a (List a)",
			TS"         | Nil",
			[],
			TS "Head:: (List a) -> a",
			TS "Head (x<:>xs) = x"
		]),N
		,SP(
			TS "All data constructors being defined in the scope must have " TAI "different"
			TA " names, to make type inferencing possible."
		),PCH
			(TS "Scope of type definitions.")
			[]
		,CPCP
			(map syntax_color [
			[],
			TS "implementation module XYZ",
			[],
			TS ":: Type_contructor type_vars = expression",
			[],
			TS "other_definitions"
		])[
			Rectangle (                        0.0,     line_height)     (42.0*courier_char_width,    5.0*line_height-1.0),
			Rectangle (18.0*courier_char_width+4.0, 3.0*line_height-1.0) (22.0*courier_char_width+4.0,    line_height)
		]
		,H3
			"5.1.1" "Using Constructors in Patterns" 
	 	,P(
			TS "An algebraic data type can be used in a pattern. The pattern consists of the " TAI "data constructor"
			TA " (" TAL "see 3.2" TA ") with its optional arguments which on its turn can contain " TAI "sub-patterns"
			TA (". A constructor pattern forces evaluation of the corresponding actual argument to strong root normal form "+++
				"since the strategy has to determine whether the actual argument indeed is equal to the specified constructor.")
		),ST2 [
			[TS "GraphPattern",	TS_E,	TS "QConstructor {Pattern}",				TS "// Constructor pattern"],
			[[],				TS_B,	TS "GraphPattern " TAC "QConstructorName",	TS "// Infix Constructor operator"],
			[[],				[],		TS "GraphPattern",							[]],
			[[],				TS_B,	TS "Pattern",								[]]
		]
		];
	= make_page pdf_i pdf_shl;

page_5_3 :: !{!CharWidthAndKerns} -> Page;
page_5_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of an algebraic data type definition and its use in a pattern in function definition.")
			[
			[],
			TS "::Tree a = Node a (Tree a) (Tree a)",
			TS "         | Nil",
			[],
			TS "Mirror:: (Tree a) -> Tree a",
			TS "Mirror (Node e left right) = Node e (Mirror right) (Mirror left)",
			TS "Mirror Nil                 = Nil"
		]
		,N
		,SP(
			TS "The data constructor used in a patter must have been defined in an algebraic data type definition."
		),H3
			"5.1.2" "Using Higher Order Types"
		,MP [
			[],
				TS "In an algebraic type definition ordinary types can be used (such as a basic type, e.g. " TAC "Int"
			TA ", or a list type, e.g. " TAC "[Int]"
			TA ", or an instantiation of a user defined type, e.g. Tree Int), but one can also use " TAI "higher order types"
			TA (". Higher order types can "+++
				"be constructed by curried applications of the type constructors. Higher order types can be applied in the type world in a "+++
				"similar way as higher order functions in the function world. The use of higher order types increases the flexibility with "+++
				"which algebraic types can be defined. Predefined types can also be used in curried way (")
			TAL "see 4.5" TA "). Higher order types play an important role in combination with type classes ("
			TAL "see Chapter 6" TA ").",
			[],
			TS ("Of course, one needs to ensure that all types are applied in a correct way. To be able to specify the rules that indicate "+++
				"whether a type itself is correct, we introduce the notion of ") TAI "kind" 
			TA ". A kind can be seen as the 'type of a type' In our case, the kind of a type expresses the number of type arguments this type may have. The kind "
			TAC "X" TA " stands for any so-called " TAI "first-order"
			TA " type: a type expecting no further arguments (("
			TAC "Int" TA ", " TAC "Bool" TA ", " TAC "[Int]" TA ", etcetera). All function arguments are of kind " TAC "X"
			TA ". The kind " TAC "X -> X"
			TA " stands for a type that can be applied to a (first-order) type, which then yields another first-order type, "
			TAC "X -> X -> X" TA " expects two type arguments, and so on.",
			[],
			TS "In CLEAN each " TAI "top-level" TA " type should have kind " TAC "X"
			TA (". A top-level type is a type that occurs either as an argument or result "+++
				"type of a function or as argument type of a data constructor (in some algebraic type definition). The rule for determining "+++
				"the kinds of the type variables (which can be of any order) is fairly simple: The kind of a type variable directly follows "+++
				"from its use. If a variable has no arguments, its kind is ") TAC "X"
			TA (". Otherwise its kind corresponds to the number of arguments to "+++
				"which the variable is applied. The kind of type variable determines its possible instantiations, i.e. it can only be "+++
				"instantiated with a type, which is of the same kind as the type variable itself.")
		],PCH
			(TS "Example of an algebraic type using higher order types; the type variable " TAC "t"
			  TA "in the definition of " TAC "Tree2" TA " s of kind " TAC "X -> X" TA ". " TAC "Tree2"
			  TA " is instantiated with a list (also of kind " TAC "X -> X" TA ") in the definition of " TAC "MyTree2" TA ".")
			[
			[],
			TS "::Tree2 t    = NilTree",
			TS "             | NodeTree (t Int) (Tree2 t) (Tree2 t)",
			[],
			TS "MyTree2:: Tree2 []",
			TS "MyTree2 = NodeTree [1,2,3] NilTree NilTree"
		],H3
			"5.1.3" "Defining Algebraic Data Types with Existentially Quantified Variables"
		,P(
			TS "An algebraic type definition can contain " TAI "existentially quantified type variable s"
			TA " (or, for short, existential type variables) ("++TSB ("L"+++adieresis_string+++"ufer")
			TA " 1992). These special variables are defined on the right-hand side of the type definition and are indicated by preceding them with \""
			TAT "E."
			TA "\". Existential types are useful if one wants to create (recursive) data structures in which objects of "
			TAI "different types" TA " are being stored (e.g. a list with elements of different types)."
		),let {
			dummy_columns = repeatn 6 [];
		} in ST [
			[TS "AlgebraicTypeDef",		TS_E,	TST "::" TA "TypeLhs",
			 TST "=" TA " ConstructorDef"]++dummy_columns,
			[[],						[],		[],
			 TS "{" TAT "|" TA " ConstructorDef} " TABCb ";"]
			 ++dummy_columns,
			[TS "ConstructorDef",		TS_E,	TS "[ExistQuantVariables] " TAC "ConstructorName" TA " {ArgType} {" TAT "&" TA " ClassConstraints}",
			 []]++dummy_columns,
			[[],						TS_B,	TS "[ExistQuantVariables] " TAT "(" TAC "ConstructorName" TAT ")" TA " [FixPrec] {ArgType} {" TAT "&" TA " ClassConstraints}",
			 []]++dummy_columns,
			[TS "ExistQuantVariables",	TS_E,	TST "E." TA "{TypeVariable}+" TAT ":",
			 []]++dummy_columns
		]
		];
	= make_page pdf_i pdf_shl;

page_5_4 :: !{!CharWidthAndKerns} -> Page;
page_5_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of the use of an existentially quantified type. In this example a record (" TAL "see 5.2"
			 TA ") is defined containing an existentially quantified state " TAC "s"
			 TA ", a method to change this state  s, and a method to convert the state " TAC "s" TA " into a " TAC "String"
			 TA ". Notice that upon creation of the record " TAC "MyObject"
			 TA " the type of the internal state and the methods defined on the state are consistent (in this case the state is of type "
			 TAC "Int" TA "). The methods stored in the object " TAC "Object"
			 TA (" can (only) be applied on the "+++
				 "state of that object thus enabling an object-oriented style of programming. The concrete type of the state hidden in the "+++
				 "object is not visible from outside. To show it to the outside world one has to convert the state, which can be of any type, "+++
				 "to an ordinary not existentially quantified type. For instance,")
			 TAC "PrintState" TA " converts the any state into a " TAC "String"
			 TA ". Objects that have states of different type are considered to be of the same type and can for instance be part of the same list.")
			(map comment_blue [
				[],
				TS "::Object = E.s: {state::s, method::s->s, tostring:: s -> String }",
				[],
				TS "MyObject =   { state = 3",
				TS "             , method = (+) 1",
				TS "             , tostring = toString",
				TS "             }",
				[],
				TS "IncrementObject obj=:{method,state} = {obj & state = method state}",
				[],
				TS "PrintState obj=:{tostring,state} = tostring state",
				[],
				TS "Start = PrintState (IncrementObject MyObject)        // the result will be 4"
		]),P(
			TS "To ensure correctness of typing, there is a limitation imposed on the use of " TAI "existentially quantified data" TA " structures."
		),N
		,SP(
			TS ("Once a data structure containing existentially quantified parts is created the type of these components are "+++
				"forgotten. This means that, in general, if such a data structured is passed to another function it is statically "+++
				"impossible to determine the actual types of those components: it can be of any type. Therefore, a function having "+++
				"an existentially quantified data structure as input is not allowed to make specific type assumptions on the parts that "+++
				"correspond to the existential type variables. This implies that one can only instantiate an existential type variable "+++
				"with a concrete type when the object is created. In all other cases it can only be unified with a universally quantified "+++
				"type.")
		),PCH
			(TSB "Counter Example" TA ". Illegal use of an object with existentially quantified components.")
			[
			[],
			TS "Start = (IncrementObject MyObject).state"
		],H3
			"5.1.4" "Defining Algebraic Data Types with Universally Quantified Variables"
		,P(
			TS "An algebraic type definition can contain " TAI "universally quantified type variables"
			TA (" (or, for short, universal type variables) of "+++
				"Rank 2 (on the argument position of a data constructor). These special variables are defined on the right-hand side of a "+++
				"type definition on the arguments position of the data constructor being defined and have to be preceded by an  \"")
			TAT "A."
			TA ("\" (meaning: \"for all\"). It can be used to store polymorphic functions that work on arguments of 'any' type. The universal "+++
				"type is very useful for constructing dictionaries for overloaded functions (")
			TAL "see Chapter 6" TA ")."
		),let {
			dummy_columns = repeatn 6 [];
		} in ST [
			[TS "AlgebraicTypeDef",		TS_E,	TST "::" TA "TypeLhs",
			 TST "=" TA " ConstructorDef"]++dummy_columns,
			[[],						[],		[],
			 TS "{" TAT "|" TA " ConstructorDef} " TABCb ";"]
			 ++dummy_columns,
			[TS "ConstructorDef",		TS_E,	TS "[ExistQuantVariables] " TAC "ConstructorName" TA " {ArgType} {" TAT "&" TA " ClassConstraints}",
			 []]++dummy_columns,
			[[],						TS_B,	TS "[ExistQuantVariables] " TAT "(" TAC "ConstructorName" TAT ")" TA " [FixPrec] {ArgType} {" TAT "&" TA " ClassConstraints}",
			 []]++dummy_columns,
			[TS "BrackType",			TS_E,	TS "[Strict] [UnqTypeAttrib] SimpleType",
			 []]++dummy_columns,
			[TS "ArgType",				TS_E,	TS "BrackType",
			 []]++dummy_columns,
			[[],						TS_B,	TS "[Strict] [UnqTypeAttrib] " TAT "(" TA "UnivQuantVariables Type" TA ")",
			 []]++dummy_columns,
			[TS "UnivQuantVariables",	TS_E,	TST "A." TA "{TypeVariable}+" TAT ":",
			 []]++dummy_columns
		],PCH
			(TSB "Counter Example" TA ". The following program is ill typed. Although an identity function is stored in "
			 TAC "T2" TA ", " TAC "T2" TA " can contain any function that can be unified with " TAC "b -> b"
			 TA " (for instance " TAC "Int -> Int" TA " will do). Therefore a type error is given for "
			 TAC "f2" TA " since " TAC "g" TA " is applied to both an " TAC "Int" TA " and a " TAC "Char" TA ".")
			[
			[],
			TS ":: T2 b = C2 (b -> b)",
			[],
			TS "f2:: (T2 b) -> (Int,Char)",
			TS "f2 (C2 g) = (g 1, g 'a')",
			[],
			TS "Id::a -> a",
			TS "Id x = x",
			[],
			TS "Start = f2 (C2 Ids)"
		]
		];
	= make_page pdf_i pdf_shl;

page_5_5 :: !{!CharWidthAndKerns} -> Page;
page_5_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of the use of a universally quantified type. In contrast with the example above it is now specified that "
			 TAC "T" TA " must contain a universally quantified function " TAC "b -> b" TA ". The identity function "
			 TAC "Id" TA " can be stored in " TAC "T" TA ", since its type " TAC "Id::a -> a"
			 TA " is actually a shorthand for " TAC "Id::A.a:a -> a" TA ".  A function from " TAC "Int -> Int"
			 TA " cannot be stored in " TAC "T" TA " since this type is not unifiable with " TAC "A.a:a -> a" TA ".")
			[
			TS ":: T = C (A.b: b -> b)",
			[],
			TS "f:: (T b) -> (Int,Char)",
			TS "f (C g) = (g 1, g 'a')",
			[],
			TS "Id::a -> a",
			TS "Id x = x",
			[],
			TS "Start = f (C Ids)"
		],H3
			"5.1.5" "Strictness Annotations in Type Definitions"
		,S(
			"Functional programs will generally run much more efficient when strict data structures are being used instead of lazy "+++
			"ones. If the inefficiency of your program becomes problematic one can think of changing lazy data structures into strict "+++
			"ones. This has to be done by hand in the definition of the type."
		),ST
		let {
			dummy_columns = repeatn 6 [];
		} in [
			[TS "AlgebraicTypeDef",	TS_E,	TST "::" TA "TypeLhs",
			 TST "=" TA " ConstructorDef"]++dummy_columns,
			[[],					[],		[],
			 TS "{" TAT "|" TA " ConstructorDef} " TABCb ";"]
			 ++dummy_columns,
			[TS "ConstructorDef",	TS_E,	TS "[ExistQuantVariables] " TAC "ConstructorName" TA " {ArgType} {" TAT "&" TA " ClassConstraints}",
			 []]++dummy_columns,
			[[],					TS_B,	TS "[ExistQuantVariables] " TAT "(" TAC "ConstructorName" TAT ")" TA " [FixPrec] {ArgType} {" TAT "&" TA " ClassConstraints}",
			 []]++dummy_columns,
			[TS "Strict",			TS_E,	TST "!",
			 []]++dummy_columns
		],MP [
			[],
			TS ("In the type definition of a constructor (in an algebraic data type definition or in a definition of a record type) the arguments "+++
				"of the data constructor can ") TAI "optionally"
			TA (" be annotated as being strict. So, some arguments can be defined strict while "+++
				"others can be defined as being lazy. In reasoning about objects of such a type it will always be true that the annotated "+++
				"argument will be in strong root normal form when the object is examined. Whenever a new object is created in a strict "+++
				"context, the compiler will take care of the evaluation of the strict annotated arguments. When the new object is created in "+++
				"a lazy context, the compiler will insert code that will take care of the evaluation whenever the object is put into a strict "+++
				"context. If one makes a data structure strict in a certain argument, it is better not define infinite instances of such a data "+++
				"structure to avoid non-termination."),
			[],
			TS ("So, in a type definition one can define a data constructor to be strict in zero or more of its arguments. Strictness is a "+++
				"property of data structure that is specified in its type."),
			[]
		],SP(
			TS ("In general (with the exceptions of tuples) one cannot arbitrary mix strict and non-strict data structures because they "+++
				"are considered to be of different type.")
		),MP [
			[],
			TS ("When a strict annotated argument is put in a strict context while the argument is defined in terms of another strict "+++
				"annotated data structure the latter is put in a strict context as well and therefore also evaluated. So, one can change the "+++
				"default ") TAI "lazy semantics" TA " of CLEAN into a (" TAI "hyper" TA ") " TAI "strict semantics"
			TA  " as demanded. The type system will check the consistency of types and ensure that the specified strictness is maintained.",
			[],
			TS ("There is no explicit notation for creating unboxed versions of an algebraic data type. The compiler will automatically "+++
				"choose the most efficient representation for a given data type. For algebraic data type definitions containing strict "+++
				"elements of basic type, record type and array type an unboxed representation will be chosen.")
		],PCH
			(TS "Example: both integer values in the definition of " TAC "Point"
			 TA (" are strict and will be stored unboxed since they are known to be of basic type. "+++
				 "The integer values stored in ") TAC "MyPoint"
			 TA " are strict as well, but will be stored unboxed since " TAC "MyTuple" TA " is polymorphic.")
			[
			[],
			TS "::Point = (!Int,!Int)",
			[],
			TS "::MyTuple a = Pair !a !a",
			[],
			TS "::MyPoint :== MyTuple Int"
		]
		];
	= make_page pdf_i pdf_shl;

page_5_6 :: !{!CharWidthAndKerns} -> Page;
page_5_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "A user defined lazy list similar to type " TAC "[a]" TA " could be defined in algebraic type definition as follows:")
			[
			[],
			TS "::LazyList a      =   LazyCons a (LazyList a)",
			TS "                  |   LazyNil"
		],PCH
			(TS "A head strict list similar to type " TAC "[!a]" TA " could be defined in algebraic type definition as follows:")
			[
			[],
			TS "::HeadSList a     =   HeadSCons !a (HeadSList a)",
			TS "                  |   HeadSNil"
		],PCH
			(TS "A tail strict list similar to type " TAC "[a!]" TA " could be defined in algebraic type definition as follows:")
			[
			[],
			TS "::TailSList a     =   TailSCons a !(TailSList a)",
			TS "                  |   TailSNil"
		],PCH
			(TS "A strict listssimilar to type " TAC "[!a!]" TA " could be defined in algebraic type definition as follows:")
			[
			[],
			TS "::StrictList a    =   StrictCons !a !(StrictList a)",
			TS "                  |   StrictNil"
		],PCH
			(TS "An unboxed list similar to type " TAC "[#Int]" TA "could be defined in algebraic type definition as follows:")
			[
			[],
			TS "::UnboxedIList    =   UnboxedICons !Int  UnboxedIList",
			TS "                  |   UnboxedINil"
		],PCH
			(TS "An unboxed list similar to type " TAC "[#Int!]" TA " could be defined in algebraic type definition as follows:")
			[
			[],
			TS "::UnboxedIList    =   UnboxedICons !Int  !UnboxedIList",
			TS "                  |   UnboxedINil"
		],H3
			"5.1.6" "Semantic Restrictions on Algebraic Data Types"
	 	,S(
			"Other semantic restrictions on algebraic data types:"
		),MSP [
			TS "The name of a type must be different from other names in the same scope and name space (" TAL "see 2.1" TA ").",
			TS "The name of a type variable must be different from other type variable names in the same scope and name space",
			TS ("All type variables used on the right-hand side are bound, i.e. must either be introduced on the left-hand side of the "+++
				"algebraic type being defined, or they must be bound by an existential quantifier on the right-hand side, or, they "+++
				"must be bound by a universal quantifier specified on the corresponding argument."),
			TS ("A data constructor can only be defined once within the same scope and name space. So, each data constructor "+++
				"unambiguously identifies its type to make type inferencing possible."),
			TS ("When a data constructor is used in infix position both arguments have to be present. Data constructors can be used "+++
				"in a curried way in the function world, but then they have to be used as ordinary prefix constructors."),
			TS ("Type constructors can be used in a curried way in the type world; to use predefined bracket-like type constructors "+++
				"(for lists, tuples, arrays) in a curried way they must be used in prefix notation."),
			TS "The right-hand side of an algebraic data type definition should yield a type of kind" TAC "X"
			TA ", all arguments of the data constructor being defined should be of kind " TAC "X" TA " as well.",
			TS "A type can only be instantiated with a type that is of the same kind.",
			TS ("An existentially quantified type variable specified in an algebraic type can only be instantiated with a concrete type "+++
				"(= not a type variable) when a data structure of this type is created.")
		],H2
			"5.2" "Defining Record Types"
		,P(
			TS "A " TAI "record type"
			TA " is basically an algebraic data type in which exactly one constructor is defined. Special about records is that a "
			TAI "field name" TA " is attached to each of the arguments of the data constructor and that"
		),N
		,SP(
			TS "records cannot be used in a curried way."
		),P(
			TS ("Compared with ordinary algebraic data structures the use of records gives a lot of notational convenience because the "+++
				"field names enable ") TAI "selection by field name" TA " instead of "
			TAI "selection by position" TA ". When a record is created " TAI "all" 
			TA " arguments of the constructor have to be defined but one can specify the arguments in " TAI "any"
			TA " order. Furthermore, when pattern matching is performed on a record, one only has to mention those fields one is interested in ("
			TAL "see 5.2.2" TA "). A record can be created via a functional update (" TAL "see 5.2.1"
			TA ("). In that case one only has to specify the values for those fields that differ from the old "+++
				"record. Matching and creation of records can hence be specified in CLEAN in such a way that after a change in the "+++
				"structure of a record only those functions have to be changed that are explicitly referring to the changed fields.")
		)
		];
	= make_page pdf_i pdf_shl;

page_5_7 :: !{!CharWidthAndKerns} -> Page;
page_5_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS "Existential and universal type variables (" TAL "see 5.1.3" TA " and " TAL "5.1.4"
			TA (") are allowed in record types (as in any other type). The "+++
				"arguments of the constructor can optionally be annotated as being strict (")
			TAL "see 10.1" TA "). The optional uniqueness attributes are treated in " TAL "Chapter 9" TA "."
		),ST [
			[TS "RecordTypeDef",	TS_E,
			 TST "::" TA "TypeLhs " TAT "=" TA " [ExistQuantVariables] [Strict] " TAT "{" TA "{" TAC "FieldName" TA " " TAT "::" TA "FieldType}-list" TAT "}" TA " " TABCb ";"],
			[TS "FieldType",		TS_E,	TS "[Strict] Type"],
			[[],					TS_B,	TS "UnivQuantVariables [Strict] Type"],
			[[],					TS_B,	TS "[Strict] [UnqTypeAttrib] " TAT "(" TA "UnivQuantVariables Type" TA ")"]
		],S(
			"As data constructor for a record the name of the record type is used internally."
		),MSP [
			TS "The semantic restrictions that apply for algebraic data types also hold for record types.",
			TS ("The field names inside one record all have to be different. It is allowed to use the same field name in different "+++
				"records. If the same names are used in different records, one can explicitly specify the intended record type when "+++
				"the record is constructed.")
		],PCH
			(TS "Example of a record definition.")
			[
			[],
			TS "::Complex    =   { re :: Real",
			TS "                 , im :: Real",
			TS "                 }"
		],S(
			"The combination of existential type variables in record types are of use for an object oriented style of programming."
		),PCH
			(TS "Example of the use of an existentially quantified record. One can create an object of a certain type that can have different representations.")
			(map color_keywords [
			[],
			TS "::Object = E.x:  { state  :: x",
			TS "                 , get :: x -> Int",
			TS "                 , set :: x Int -> x",
			TS "                 }",
			[],
			TS "CreateObject1:: Object",
			TS "CreateObject1 = {state = [], get = myget, set = myset}",
			TS "where",
			TS "    myget:: [Int] -> Int",
			TS "    myget [i:is] = i",
			TS "    myget []     = 0",
			[],
			TS "    myset:: [Int] Int -> [Int]",
			TS "    myset is i = [i:is]"
		]),PC (map color_keywords [
			TS "CreateObject2 = {state = 0.0, get = myget, set = myset}",
			TS "where",
			TS "    myget:: Real -> Int",
			TS "    myget r = toInt r",
			[],
			TS "    myset:: Real Int -> Real",
			TS "    myset r i = r + toReal i",
			[],
			TS "Get:: Object -> Int",
			TS "Get {state,get} = get state",
			[],
			TS "Set:: Object Int -> Object",
			TS "Set o=:{state,set} i = {o & state = set state i}",
			[],
			TS "Start:: [Object]",
			TS "Start = map (Set 3) [CreateObject1,CreateObject2]"
		])
		];
	= make_page pdf_i pdf_shl;

page_5_8 :: !{!CharWidthAndKerns} -> Page;
page_5_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of a complex number as record type with strict components.")
			[
			[],
			TS "::Complex    =   {    re:: !Real",
			TS "                 ,    im:: !Real",
			TS "                 }",
			[],
			TS "(+) infixl 6:: !Complex !Complex -> Complex",
			TS "(+) {re=r1,im=i1} {re=r2,im=i2} = {re=r1+r2,im=i1+i2}"
		],S(
			"The compiler often unboxes records to make the generated code more efficient. However in some cases this is less "+++
			"efficient, for example for abstract data types, large unique records that can be updated in place, or when records are "+++
			"shared. Therefore unboxing can be prevented by adding an ! before the { in the record type definition."
		),H3
			"5.2.1" "Creating Records and Selection of Record Fields"
		,P(
			TS "A " TAI "record" TA " is a tuple-like algebraic data structure that has the advantage that its elements can be selected by "
			TA "field name" TA " rather than by position."
		),ST [
			[TS "Record",	TS_E,	TS "RecordDenotation"],
			[[],			TS_B,	TS "RecordUpdate"]
		],N
		,H3T "Simple Records"
		,P(
			TS "The first way is to create a record is by " TAI "explicitly" TA " defining a value for " TAI "each" TA " of its fields."
		),ST [
			[TS "RecordDenotation",	TS_E,	TST "{" TA "[" TAC "TypeName" TAT "|" TA "] {" TAC "FieldName" TA " " TAT "=" TA " GraphExpr}-list]" TAT "}"]
		],PCH
			(TS "Creation of a record.")
			(map comment_blue [
			[],
			TS "::Point      =   { x:: Real                         // record type definition",
			TS "                 , y:: Real",
			TS "                 }",
			TS "::ColorPoint =   { p:: Point                        // record type definition",
			TS "                 , c:: Color",
			TS "                 }",
			TS "::Color      =   Red | Green | Blue                 // algebraic type definition",
			[],
			TS "CreateColorPoint:: (Real,Real) Color -> ColorPoint  // type of function",
			TS "CreateColorPoint (px,py) col = { c = col            // function creating a new record",
			TS "                               , p = { x = px",
			TS "                                     , y = py",
			TS "                                     }",
			TS "                               }"
		]),MSP [
			TS ("A record can only be used if its type has been defined in a record type definition; the field names used must be "+++
				"identical to the field names specified in the corresponding type."),
			TS "When creating a record explicitly, the order in which the record fields are instantiated is irrelevant, but " TAI "all"
			TA (" fields have to get a value; the type of these values must be an instantiation of the corresponding type "+++
				"specified in record type definition. Curried use of records is ") TAI "not" TA " possible.",
			TS ("When creating a record, its type constructor that can be used to disambiguate the record from other records; the "+++
				"type constructor can be left out if there is ") TAI "at least"
			TA " one field name is specified which is not being defined in some other record."
		],N
		,H3T "Record Update"
		,P(
			TS "The second way is to construct a new record out of an existing one (a " TAI "functional record update" TA ")."
		),ST2 [
			[TS "RecordUpdate",	TS_E,	TST "{" TA "[" TAC "TypeName" TAT "|" TA "][RecordExpr " TAT "&" TA "][{" TAC "FieldName" TA " {Selection} = GraphExpr}-list]" TAT "}"],
			[TS "Selection",	TS_E,	TST "." TAC "FieldName"],
			[[],				TS_B,	TST "." TA "ArrayIndex"],
			[TS "RecordExpr",	TS_E,	TS "GraphExpr"]
		],N
		,SP(
			TS "The record expression must yield a record."
		)];
	= make_page pdf_i pdf_shl;

page_5_9 :: !{!CharWidthAndKerns} -> Page;
page_5_9 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS "The record written to the left of the " TAC "& (r & f = v" TA " is pronounced as: "TAC "r"
			TA " with for " TAC "f" TA " the value " TAC "v" TA ") is the record to be duplicated.  On the right from the "
			TAC "&" TA " the structures are specified in which the new record " TAI "differs"
			TA (" from the old one. A structure can be any field of the record or a selection of any field or array element of a record or array "+++
				"stored in this record. All other fields are duplicated and created") TAI "implicitly"
			TA ". Notice that the functional update is not an update in the classical, destructive sense since a " TAI "new"
			TA (" record is created.  The functional update of records is performed very efficient "+++
				"such that we have not added support for destructive updates of records of unique type. The ")
			TAC "&" TA "-operator is strict in the record argument and arguments for strict fields."
		),PCH
			(TS "Updating a record within a record using the functional update.")
			[
			[],
			TS "MoveColorPoint:: ColorPoint (Real,Real) -> ColorPoint",
			TS "MoveColorPoint cp (dx,dy) = {cp & p.x = cp.p.x + dx, p.y = c.p.y + dy}"
		],N

		,H3T "# with Record Update"
		,P (TSC "variable = {variable & " TA "updates" TAC "}" TA " after " TAC "#" TA " or " TAC "#!" TA " can be abbreviated to "
			TAC "variable & " TA "updates, by omitting " TAC "= {variable" TA " and " TAC "}"
			TA " (same as for array updates in " TAL "section 4.4.1" TA ").")
		,ST [
			[[],						TS_B,	TS "Variable " TAT "&" TA " {" TAC "FieldName" TA " {Selection} " TAT "=" TA" GraphExpr}-list " TABCb ";"]
		],S "For example:"
		,PC [TS "# r & x = 1"]
		,CPCH
			(TS "instead of")
			[TS "# r = {r & x = 1}"]
		,S "Multiple updates are also allowed, for example:"
		,PC
			[TS "# r & x=1, y=2, z.c='a'"]
		,CPCH
			(TS "instead of")
			[TS "# r = {r & x=1, y=2, z.c='a'}"]
		,N
		,H3T "Selection of a Record Field"
		,ST [
			[TS "RecordSelection",	TS_E,	TS "RecordExpr [" TAT "." TAC "TypeName" TA "]" TAT "." TAC "FieldName" TA " {Selection}"],
			[[],					TS_B,	TS "RecordExpr [" TAT "." TAC "TypeName" TA "]" TAT "!" TAC "FieldName" TA " {Selection}"],
			[TS "Selection",		TS_E,	TST "." TAC "FieldName"],
			[[],					TS_B,	TST "." TA "ArrayIndex"]
		],P(
			TS "With a " TAI "record selection" TA " (using the '" TAC "."
			TA "' symbol) one can select the value stored in the indicated record field. A \"unique\" selection using the '" TAC "!"
			TA ("' symbol returns a tuple containing the demanded record field and the original record. This type of "+++
				"record selection can be very handy for destructively updating of uniquely typed records with values that depend on the "+++
				"current contents of the record. Record selection binds more tightly (priority ")
			TAC "11" TA ") than application (priority " TAC "10" TA ")."
		),PCH
			(TS "Record selection.")
			(map comment_blue [
			[],
			TS "GetPoint:: ColorPoint -> Point",
			TS "GetPoint cp = cp.p                                  // selection of a record field",
			[],
			TS "GetXPoint:: ColorPoint -> Real",
			TS "GetXPoint cp = cp.p.x                               // selection of a record field",
			[],
			TS "GetXPoint2:: *ColorPoint -> (Real,.ColorPoint)",
			TS "GetXPoint2 cp = cp!p.x                              // selection of a record f"
		]),H3
			"5.2.2" "Record Patterns"
		,P(
			TS "An object of type " TAI "record"
			TA (" can be specified as pattern. Only those fields which contents one would like to use in the right-hand "+++
				"side need to be mentioned in the pattern.")
		),ST [
			[TS "RecordPattern",	TS_E,	TST "{" TA "[" TAC "TypeName" TA " " TAT "|" TA "] {" TAC "FieldName" TA " [" TAT "=" TA " GraphPattern]}-list" TAT "}"]
		],MSP [
			TS "The type of the record must have been defined in a record type definition.",
			TS "The field names specified in the pattern must be identical to the field names specified in the corresponding type.",
			TS ("When matching a record, the type contructor which can be used to disambiguate the record from other records, can "+++
				"only be left out if there is ") TAI "at least "
			TA "one field name is specified which is not being defined in some other record."
		]
		];
	= make_page pdf_i pdf_shl;

page_5_10 :: !{!CharWidthAndKerns} -> Page;
page_5_10 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Use of record patterns.")
			[
			[],
			TS "::Tree a     =    Node (RecTree a)",
			TS "             |    Leaf a",
			TS "::RecTree a  =    { elem  :: a",
			TS "                  , left  :: Tree a",
			TS "                  , right  :: Tree a",
			TS "                  }",
			[],
			TS "Mirror:: (Tree a) -> Tree a",
			TS "Mirror (Node tree=:{left=l,right=r})    = Node {tree & left=r,right=l}",
			TS "Mirror leaf                             = leaf"
		],PCH
			(TS "The first alternative of function " TAC "Mirror" TA " defined in another equivalent way:")
			[
			[],
			TS "Mirror (Node tree=:{left,right}) = Node {tree & left=right,right=left}",
			[]
		],CPCH
			(TS "or (except " TAC "tree" TA " may be evaluated lazily):")
			[
			[],
			TS "Mirror (Node tree) = Node {tree & left=tree.right,right=tree.left}"
		],H2
			"5.3" "Defining Synonym Types"
		,P(
			TSI "Synonym types" TA " permit the programmer to introduce a new type name for an existing type."
		),ST [
			[TS "SynonymTypeDef",	TS_E,	TST "::" TA "TypeLhs " TAT ":==" TA " Type " TABCb ";"]
		],MSP [
			TS "For the left-hand side the same restrictions hold as for algebraic types.",
			TS "Cyclic definitions of synonym types (e.g. " TAC "::T a b :== G a b; ::G a b :== T a b" TA ") are not allowed."
		],PCH
			(TS "Example of a type synonym definition.")
			[
			[],
			TS "::Operator a :== a a -> a",
			[],
			TS "map2:: (Operator a) [a] [a] -> [a]",
			TS "map2 op [] []             = []",
			TS "map2 op [f1:r1] [f2:r2]   = [op f1 f2 :map2 op r1 r2]",
			[],
			TS "Start:: Int",
			TS "Start = map2 (*) [2,3,4,5] [7,8,9,10]"
		],H2
			"5.4" "Defining Abstract Data Types"
		,P(
			TS "A type can be exported by defining the type in a CLEAN definition module (" TAL "see Chapter 2"
			TA ("). For software engineering reasons it sometimes better only to export the name of a type but not its "+++
				"concrete definition (the right-hand side of the type definition). The type then becomes an ")
			TAI "abstract data type"
			TA (". In CLEAN this is done by specifying only the left-hand-side of a type "+++
				"in the definition module while the concrete definition (the right-hand side of the type definition) is hidden in the "+++
				"implementation module. So, CLEAN's module structure is used to hide the actual implementation. When one wants to do "+++
				"something useful with objects of abstract types one needs to export functions that can create and manipulate objects of "+++
				"this type as well.")
		),CMSP [
			TS ("Abstract data type definitions are only allowed in definition modules, the concrete definition has to be given in the "+++
				"corresponding implementation module."),
			TS ("The left-hand side of the concrete type should be identical to (modulo alpha conversion for variable names) the left-"+++
				"hand side of the abstract type definition (inclusive strictness and uniqueness type attributes).")
		],ST [
			[TS "AbstractTypeDef",	TS_E,	TST "::" TA "TypeLhs " TABCb ";"]
		],PCH
			(TS "Example of an abstract data type.")
			(map color_keywords [
			[],
			TS "definition module stack",
			[],
			TS "::Stack a",
			[],
			TS "Empty    ::   (Stack a)",
			TS "isEmpty  ::   (Stack a) -> Bool",
			TS "Top      ::   (Stack a) -> a",
			TS "Push     :: a (Stack a) -> Stack a",
			TS "Pop      ::   (Stack a) -> Stack a"
		])
		];
	= make_page pdf_i pdf_shl;

page_5_11 :: !{!CharWidthAndKerns} -> Page;
page_5_11 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PC (map color_keywords [
			TS "implementation module stack",
			[],
			TS "::Stack a :== [a]",
			[],
			TS "Empty:: (Stack a)",
			TS "Empty = []",
			[],
			TS "isEmpty:: (Stack a) -> Bool",
			TS "isEmpty [] = True",
			TS "isEmpty s  = False",
			[],
			TS "Top:: (Stack a) -> a",
			TS "Top [e:s] = e",
			[],
			TS "Push:: a (Stack a) -> Stack a",
			TS "Push e s = [e:s]",
			[],
			TS "Pop:: (Stack a) -> Stack a",
			TS "Pop [e:s] = s"
		]),H3
			"5.4.1" "Defining Abstract Data Types with Synonym Type Definition"
	 	,S(
			"Because the concrete definition of an abstract data type does not appear in the definition module, the compiler cannot "+++
			"generate optimal code. Therefore, if the concrete type is a synonym type, the right-hand-side of the definition may be "+++
			"included surrounded by brackets:"
		),ST [
			[TS "AbstractSynonymTypeDef",	TS_E,	TST "::" TA "TypeLhs ( " TAT ":==" TA " Type ) " TABCb ";"]
		],S(
			"The type of the implementation is still hidden as for other abstract data types, except that the compiler uses it only to "+++
			"generate the same code as for a synonym type."
		)
		];
	= make_page pdf_i pdf_shl;
