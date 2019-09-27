implementation module clean_manual_dynamics;

import StdEnv,pdf_main,pdf_text,pdf_fonts,clean_manual_styles,clean_manual_text,clean_manual_graphics;

pages_8 :: [{!CharWidthAndKerns} -> Page];
pages_8 = [page_8_1,page_8_2,page_8_3,page_8_4,page_8_5,page_8_6,page_8_7,page_8_8,page_8_9,page_8_10,page_8_11,page_8_12,page_8_13];

page_8_1 :: !{!CharWidthAndKerns} -> Page;
page_8_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 8" "Dynamics"
		,MP [
			[],
			TS ("Dynamics are a new experimental feature of CLEAN. The concept is easy to understand, but the implementation is not so "+++
				"straightforward (see Vervoort and Plasmeijer, 2002). So, it will take some time before all bits and pieces are "+++
				"implemented and the system will work flawlessly. Please be patient."),
			[],
			TS ("What can you do with \"Dynamics\"? With \"Dynamics\" it is possible to store and exchange a CLEAN expression between "+++
				"(different) CLEAN applications in an easy and type-safe way. The expression may contain (unevaluated!) data and "+++
				"(unevaluated!) function applications. Here are some examples of its use.")
		],CMSP [
			TS "Almost all applications " TAI "store and fetch information to and from disk"
			TA " (settings and the like). Traditionally, information written to file first has to be converted by the programmer to some ("
			TAI "String" TA ") format. When the file is read in again a parser has to be constructed to parse the input and to convert the "
			TAI "String" TA " back to the appropriate data structure. With " TAC "Dynamic"
			TA ("s one can store and retrieve (almost) any CLEAN data structure in a type-safe way with just one (!) "+++
				"function call. Not only data can be saved, but also code (unevaluated functions, higher order functions), which is "+++
				"part of the data structure being stored. ")
			TAC "Dynamic" TA "s make it easier to write a " TAI "persistent application"
			TA (": an application "+++
				"that stores the settings in such a way that the next time the user will see everything in the same way as the last "+++
				"time the application was used."),
			TS "Different independently programmed CLEAN applications, even applications " TAI "distributed"
			TA " across a network, can easily " TAI "communicate arbitrary expressions"
			TA " that can contain data as well as code (unevaluated functions) in a type-safe way. " TAC "Dynamic"
			TA ("s can be communicated via files or via message passing primitives offered by the CLEAN libraries. "+++
				"The fact that CLEAN applications can communicate code means that a running CLEAN application can be extended "+++
				"with additional functionality. So, ")
			TAI "plug-ins"
			TA " and "
			TAI "mobile code"
			TA " can be realized very easily and everything is "
			TAI "type-safe" TA "."
		],MP [
			[],
			TS ("To make all this possible we need some special facilities in the CLEAN language. But, in the CLEAN run-time system "+++
				"special support is needed as well. This includes ")
			TAI "dynamic type checking" TA ", " TAI "dynamic type unification" TA ", " TA "dynamic encoding" TA " and " TAI "decoding"
			TA " of arbitrary CLEAN " TAI "expressions and types" TA ", " TAI "dynamic linking" TA ", " TAI "garbage collection"
			TA " of dynamics objects on disk, and " TAI "just-in-time code generation" TA ".",
			[],
			TS "In CLEAN 2.0 we have added a " TAI "dynamic type system" TA " such that CLEAN now offers a " TAI "hybrid type system"
			TA " with both " TAI "static" TA " as well as " TAI "dynamic typing"
			TA ". An object (expression) of static type can be packed into an object of dynamic type (a \""
			TAC "Dynamic"
			TA ("\") and backwards. The type of a Dynamic can only be checked at run-time. An application can also check whether types of "+++
				"several Dynamics can be unified with each other, without a need to know what types are exactly stored into a Dynamic. "+++
				"In this way CLEAN applications can be used as control language to manage processes and plug-ins (see Van Weelden "+++
				"and Plasmeijer, 2002)."),
			[],
			TS "In this Chapter we first explain how a Dynamic can be constructed (" TAL "see 8.1" TA "). In " TAL "Section 8.2"
			TA " we explain how the type of a " TAC "Dynamic" TA " can be inspected via a pattern match, and how one can ensure that "
			TAC "Dynamics" TA " fit together by using run-time type unification.",
			[],
			TS "We explain in " TAL "Section 8.3"
			TA (" how dynamics can be used to realize type safe communication of expressions between "+++
				"independently executing applications. In Section 8.4 we explain the basic architecture of the CLEAN run-time system that "+++
				"makes this all possible. Semantic restrictions and restrictions of the current implementation are summarized in ")
			TAL "Section 8.5" TA ".",
			[]
		],H2
			"8.1" "Packing Expressions into a Dynamic"
		,MP [
			[],
			TS "Since CLEAN is a strongly typed language (" TAL "see Chapter 5" TA "), " TAI "every"
			TA " expression in CLEAN has a " TAI "static type" TA " determined at " TAI "compile time"
			TA ". The CLEAN compiler is in general able to infer the static type of any expression or any function."			
		]
		];
	= make_page pdf_i pdf_shl;

page_8_2 :: !{!CharWidthAndKerns} -> Page;
page_8_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
	[PCH
		(TS "Example of CLEAN expressions and their static type:")
		[
		[],
		TS "3::Int",
		TS "map::(a -> b) [a] -> [b]",
		TS "map ((+) 1)::[Int] ->[Int]",
		TS "MoveColorPoint Green::(Real,Real) -> ColorPoint"
	],P(
		TS "By using the keyword " TABCr "dynamic" TA " one can (in principle) change " TAI "any"
		TA "expression of static type " TAC (":: "+++tau_string) TA " into a dynamically typed object of static type " TAC "::Dynamic"
		TA (". Such a \"dynamic\" is an object (a record to be precise) that contains the original "+++
			"expression as well as an encoding of the original static type of the expression. Both the expression as well as the "+++
			"encoding of its static type, are packed into a dynamic. At run-time, the contents of a dynamic (the value of the expression "+++
			"as well the encoded type) can be inspected via a dynamic pattern match (") TAL "see 8.2" TA ")."
	),ST [
		[TS "DynamicExpression"	,	TS_E,	TSBCr "dynamic" TA " GraphExpr [" TAT "::" TA " [UnivQuantVariables] Type [ClassContext]]"]
	],PCH
		(TS "Example showing how one can pack an expression into a " TAC "Dynamic"
		 TA ". Optionally, the static type of the expression one wants to pack into a Dynamic can be specified.")
		(map color_keywords [
		[],
		TS "dynamic 3",
		TS "dynamic 3::Int",
		TS "dynamic map::A.a b:(a->b) [a] -> [b]",
		TS "dynamic map::(Int -> Real) [Int] -> [Real]",
		TS "dynamic map ((+) 1)",
		TS "dynamic MoveColorPoint Green"
	]),PCH
		(TS "Example of a (constant) function creating a dynamic containing an expression of type " TAC "Tree Int" TA ".")
		(map color_keywords [
		[],
		TS ":: Tree a = Node a (Tree a) (Tree a) | Leaf",
		[],
		TS "MyTree::Dynamic",
		TS "MyTree = dynamic (DoubleTree 1 mytree)",
		TS "where",
		TS "    Doubletree rootvalue tree = Node rootvalue tree tree",
		[],
		TS "    mytree = (Node 2 (Node 3 Leaf Leaf) Leaf)"
	]),S(
		"Only the compiler is able to combine an expression with its type into a dynamic, such that it is guaranteed that the "+++
		"encoded type is indeed the type of the corresponding packed expression. However, as usual it is allowed to specify a "+++
		"more specific type than the one the compiler would infer. The compiler will check the correctness of such a (restricted) "+++
		"type specification. Polymorphic types can be stored as well."
	),N
	,SP(
		TS ("If an expression of polymorphic type is packed into a dynamic one needs to explicitly specify the universal "+++
			"quantifiers as well (see the example above).")
	),MP [
		[],
		TS ("In principle (there are a few exceptions), any algebraic data type can be packed into a dynamic, including basic types, "+++
			"function types, user defined types, polymorphic types, record types, all types of arrays, all types of lists, and existentially "+++
			"quantified types. The system can deal with synonym types as well. Restrictions hold for packing abstract data types, "+++
			"uniqueness types and overloaded functions, see the sub-sections below."),
		[],
		TS "The static type of the object created with the keyword \"dynamic\" is the predefined type " TAC "Dynamic"
		TA ". Since all objects created in this way are of type " TAC "Dynamic"
		TA ", the compiler is in general not able anymore to determine the static type hidden in the " TAC "Dynamic"
		TA " and it cannot check its type consistency anymore. The type stored into a " TAC "Dynamic"
		TA " has to be checked at run-time (" TAL "see 8.2" TA " and " TAL "8.3" TA ")."
	],H3
		"8.1.1" "Packing Abstract Data Types"
	,MP [
		[],
		TS "Certain types simply cannot be packed into a " TAC "Dynamic"
		TA " for fundamental reasons. Examples are objects of abstract predefined type that have a special meaning in the real world, such as objects of type "
		TAC "World" TA " and of type " TAC "File"
		TA ". It is not sound to pack objects of these types into a Dynamic, because their real world counterpart cannot be packed and stored.",
		[]
	],SP(
		TS "Abstract data types that have a meaning in the real world (such as World, File) cannot be packed into Dynamic."
	)
	];

	= make_page pdf_i pdf_shl;

page_8_3 :: !{!CharWidthAndKerns} -> Page;
page_8_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "A compile time error message will be given in those cases were the  compiler refuses to pack an expression into a " TAC "Dynamic" TA ".",
			[],
			TS "In the current implementation there are additional restrictions on the kind of types that can be packed into a" TAC "Dynamic"
			TA (". Currently it is not possible to pack any abstract data type into a dynamic at all. The reason is that the test on equality of "+++
				"abstract types is not easy: it does not seem to be enough to test the equality of the definitions of the types involved. We "+++
				"should also test whether the operations defined on these abstract data types are exactly the same. The most "+++
				"straightforward way to do this would be to require that abstract data types  are coming from the same module (repository)."),
			[]
		],SP(
			TS ("Expressions containing objects of abstract data type cannot be packed into a Dynamic. We are working on this. "+++
				"Check the latest version of the ") TAC "Clean" TA " system."
		),H3
			"8.1.2" "Packing Overloaded Functions"	
		,P(
			TS "Overloaded functions can also be packed into a " TAC "Dynamic"
			TA ". In that case the corresponding type classes (" TAL "see 6.1"
			TA ") are packed as additional dictionary argument of the function into the " TAC "Dynamic"
			TA ". When the " TAC "Dynamic"
			TA (" is unpacked in a pattern match, the same type classes have to be defined in the receiving function, "+++
				"otherwise the pattern match will fail (") TAL "see 8.2.2" TA ")."
		),PCH
			(TS "Example: storing an overloaded function into a " TAC "Dynamic" TA ".")
			(map color_keywords [
			[],
			TS "OverloadedDynamic:: Dynamic",
			TS "OverloadedDynamic = dynamic plus :: A.a:a a -> a | + a",
			TS "where",
			TS "    plus:: a a -> a | + a",
			TS "    plus x y = x + y"
		]),S(
			"Currently, when an overloaded function is packed into a dynamic, one explicitly has to specify the type, including "+++
			"the forall quantifier and the class context."
		),H3
			"8.1.3" "Packing Expressions of Unique Type"
		,P(
			TS "Expressions of unique type (" TAL "see Chapter 9"
			TA (") can also be packed into a Dynamic. However, the run-time system cannot deal with uniqueness type variables "+++
				"or with coercion statements (attribute variable inequalities). One can only use the type attribute \"") TAC "*"
			TA "\". Furthermore, one has to explicitly define the desired unicity in the type of the expression to be packed into a " 
			TAC "Dynamic"
			TA (". Otherwise the unicity properties of the packed expression will not be stored. As usual, the compiler will "+++
				"check whether the specified type (including the uniqueness type attributes) of the packed expression is correct.")
		),PCH
			(TS "Example: packing a function into a " TAC "Dynamic" TA " that can write a character to a unique file.")
			(map color_keywords [
			[],
			TS "MyDynamic:: Dynamic",
			TS "MyDynamic = dynamic fwritec :: Char *File -> *File"
		]),MSP [
			TS "Uniqueness type variables and coercion statements cannot be part of a type packed into a Dynamic.",
			TS "Uniqueness type attributes are only taken into account if they are explicitly specified in the type of the packed dynamic."
		],PCH
			(TS "Counter Example: " TAC "Dynamics" TA " cannot deal with uniqueness type variables or with attribute variable inequalities.")
			(map color_keywords [
			[],
			TS "MyDynamic:: Dynamic",
			TS "MyDynamic = dynamic append :: [.a] u:[.a] -> v:[.a]        , [u<=v]"
		]),H3
			"8.1.4" "Packing Arguments of Unknown Type"
		,P(
			TS "The compiler is not in all cases capable to infer the concrete type to be assigned to a " TAC "Dynamic"
			TA (". For instance, when a polymorphic function is defined it is in general unknown what the type of "+++
				"the actual argument will be. If it is polymorphic, it can be of any type.")
		),N
		,SP(
			TS "An argument of polymorphic type cannot be packed into a Dynamic."
		)
		];
	= make_page pdf_i pdf_shl;

page_8_4 :: !{!CharWidthAndKerns} -> Page;
page_8_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Counter Example of a function creating a " TAC "Dynamic"
						  TA ". Arguments of polymorphic type cannot be packed into a Dynamic.")
			(map color_keywords [
			[],
			TS "WrongCreateDynamic:: t -> Dynamic",
			TS "WrongCreateDynamic any = dynamic any"
		]),P(
			TS "If one wants to define a function that can wrap an arbitrary argument into a " TAC "Dynamic"
			TA (", not only the value, but also the concrete static type of that argument has to be passed to the function. For efficiency "+++
				"reasons, we of course do not want to pass the types of all arguments to all functions. Therefore, we have to know which of "+++
				"the arguments might be packed into a ") TAC "Dynamic"
			TA ". A special class context restriction is used to express this. So, instead of a " TAI "polymorphic"
			TA " function one has to define an " TAI "overloaded" TA " function ("  TAL "see Chapter 6"
			TA "). The class " TAC "TC" TA " (for " TAC "T" TA "ype " TAC "C"
			TA ("ode) is predefined and an instance of this "+++
				"class is required whenever an argument of unknown type is packed into a dynamic. The compiler will automatically "+++
				"generate an appropriate instance of the TC when needed.")
		),PCH
			(TS "Example of an overloaded function that can wrap an argument of arbitrary type into a " TAC "Dynamic" TA ".")
			[
			[],
			TS "CreateDynamic:: t -> Dynamic | TC t",
			TS "CreateDynamic any = dynamic any",
			[],
			TS "MyTree:: Dynamic",
			TS "MyTree = CreateDynamic (Node 2 (Node 3 Leaf Leaf) Leaf)"
		],H3
			"8.1.5" "Using Dynamic Typing to Defeat the Static Type System"
		,P(
			TS ("Dynamic typing can also be used to do things the static type system would forbid. For instance, lists require that all lists "+++
				"elements are of the same type. Since all dynamic expressions are of type ") TAC "Dynamic"
			TA ", one can combine objects of static different type into a list by turning them into a " TAC "Dynamic" TA "."
		),PCH
			(TS ("Example: three ways to pack objects of different type into a list. The first method is to define a new type in which all types "+++
				 "one likes to pack into a list are summarized with an appropriate constructor to distinguish them. For unpacking one can "+++
				 "make a case distinction on the different constructors in a pattern match. Everything is nice statically typed but one can "+++
				 "only pack and unpack the types that are mentioned in the wrapper type."))
			[
			[],
			TS ":: WrapperType = I Int | R Real | C Char",
			[],
			TS "MyWrapperList = [I 1, R 3.14, C 'a']"
		],PCH
			(TS "The next way to pack objects of different types is by defining a list structure using an existential type ("  TAL "see 5.1.3"
			 TA ("). Any type can be packed now but the disadvantage is that there is no simple way to distinguish the elements and unpack "+++
				 "them once they are packed."))
			[
			[],
			TS ":: ExstList = E.a: Cons a ExstList | Nil",
			[],
			TS "MyExstList = Cons 1 (Cons 3.14 (Cons 'a' Nil)"
		],PCH
			(TS ("The third way is to wrap the values into a Dynamic. Any type can be packed and via a pattern match one can unwrap "+++
				  "them as well. It is very inefficient though and one can only unwrap a value by explicitly naming the type in the pattern "+++
				  "match (") TAL "see 8.2" TA ").")
			(map color_keywords [
			[],
			TS "MyDynamicList = [dynamic 1, dynamic 3.14, dynamic 'a']"
		]),P(
			TS ("It is possible to write CLEAN programs in which all arguments are dynamically typed. You can do it, but it is not a good "+++
				"thing to do: programs with dynamics are less reliable (run-time type errors might occur) and much more inefficient. ")
			TAC "Dynamics"
			TA (" should be used for the purpose they are designed for: type-safe storage, retrieval, and communication of "+++
				"arbitrary expressions between (independent) applications.")
		)
		];
	= make_page pdf_i pdf_shl;

page_8_5 :: !{!CharWidthAndKerns} -> Page;
page_8_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2
			"8.2" "Unpacking Dynamics Using a Dynamic Pattern Match"
		,P(
			TS "When a " TAC "Dynamic" TA " is created (see above), its static type is the type " TAC "Dynamic" 
			TA ". The compiler is in general not able anymore to determine what the original type was of the expression that is packed into a "
			TAC "Dynamic" TA ". The only way to figure that out is at run-time (that why it is called a " TAC "Dynamic"
			TA "), by inspecting the dynamic via a pattern match (" TAL "see 3.2" TA ") or a case construct ("
			TAL "see 3.4.2" TA "). With a pattern match on a Dynamic one cannot only inspect the " TAI "value" 
			TA " of the expression that was packed into a " TAC "Dynamic" TA ", but also its original " TAI "type" TA ". So, with " TAC "Dynamics"
			TA (" run-time type checking and dynamic type unification is possible in CLEAN with all the advantages (more expressions can be typed) "+++
				"and disadvantages (type checking may fail at run-time) of a dynamic type system. The programmer has to take care of handling the case "+++
				"in which the pattern match fails due to a non-matching dynamic type.")
		),ST [
			[TS "DynamicPattern",			TS_E,	TST "(" TA "GraphPattern " TAT "::" TA " DynamicType" TAT ")"],
			[TS "DynamicType",				TS_E,	TS "[UnivQuantVariables] {DynPatternType}+ [ClassContext]"],
			[TS "DynPatternType",			TS_E,	TS "Type"],
			[[],							TS_B,	TS "TypePatternVariable"],
			[[],							TS_B,	TS "OverloadedTypePatternVariable"],
			[TS "TypePatternVariable",		TS_E,	TS "Variable"],
			[TS "OverloadedTypeVariable",	TS_E, TS "Variable" TABCr "^"]
		],P(
			TS "Any expression that can be packed into a dynamic can also be unpacked using a dynamic pattern match. With a pattern match on "
			TAC "Dynamic" TA "s a case distinction can be made on the contents of the " TAC "Dynamic" TA ". If the actual " TAC "Dynamic" 
			TA " matches the type " TAI "and"
			TA " the value specified in the pattern, the corresponding function alternative is chosen. Since it is known in that case that the "
			TAC "Dynamic"
			TA (" matches the specified type, this knowledge is used by the static type system: dynamics of known "+++
				"type can be handled as ordinary expressions in the body of the function. In this way dynamics can be converted back to "+++
				"ordinary statically typed expressions again. The static type checker will use the knowledge to check the type consistency "+++
				"in the body of the corresponding function alternative.")
		),PCH
			(TS "Example: Use of a dynamic pattern match to check whether a "TAC "Dynamic"
			 TA " is of a specific predefined type. The first alternative of the function transform matches if the "
			 TAC "Dynamic" TA " contains the Integer of value " TAC "0" TA ". The second alternative is chosen if the "
			 TAC "Dynamic" TA " contains any Integer (other than " TAC "0" TA "). The third alternative demands a function from "
			 TAC "[Int]" TA " to " TAC "[Int]" TA ". The next alternative is chosen if the " TAC "Dynamic" TA " is a pair of two "
			 TAC "[Int]"
			 TA ". If none of the alternatives match, the last alternative is chosen. The program will yield an empty list in that case.")
			[
			[],
			TS "transform :: Dynamic -> [Int]",
			TS "transform (0 :: Int)               = []",
			TS "transform (n :: Int)               = [n]",
			TS "transform (f :: [Int]->[Int])      = f [1..100]",
			TS "transform ((x,y) :: ([Int],[Int])) = x ++ y",
			TS "transform other                    = []"
		],P(
			TS "Warning: when defining a pattern match on " TAC "Dynamics"
			TA ", one should always be aware that the pattern match might fail. So, we advise you to " TAI "always" 
			TA ("include an alternative that can handle non-matching dynamics. The application will otherwise "+++
				"abort with an error message that none of the function alternatives matched.")
		)
		];
	= make_page pdf_i pdf_shl;

page_8_6 :: !{!CharWidthAndKerns} -> Page;
page_8_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example: use of a dynamic pattern match to check whether a " TAC "Dynamic"
			 TA " is of a specific user defined algebraic data type. If the " TAC "Dynamic" TA " contains a "
			 TAC "Tree" TA " of " TAC "Int" TA ", the function " TAC "CountDynamicLeafs"
			 TA " will count the number of leafs in this tree. Otherwise CountDynamicLeafs  will return " TAC "0" TA ".")
			(map color_keywords [
			[],
			TS ":: Tree a = Node a (Tree a) (Tree a) | Leaf",
			[],
			TS "CountDynamicLeafs :: Dynamic -> Int",
			TS "CountDynamicLeafs (tree :: Tree Int)  = countleafs tree",
			TS "CountDynamicLeafs other               = 0",
			TS "where",
			TS "    countleafs :: (Tree Int) -> Int",
			TS "    countleafs  tree = count tree 0",
			TS "    where",
			TS "        count:: (Tree a) Int -> Int",
			TS "        count Leaf nleafs              = nleafs + 1",
			TS "        count (Node left right) nleafs = count left (count right nleafs)",
			[],
			TS "MyTree :: Dynamic",
			TS "MyTree = dynamic (Node 1 (Node 2 (Node 3 Leaf Leaf) Leaf) (Node 4 Leaf Leaf))",
			[],
			TS "Start :: Int",
			TS "Start = CountDynamicLeafs MyTree"
		]),PCH
			(TS "Example: use of a dynamic pattern match to check whether a " TAC "Dynamic"
			 TA " is a polymorphic function (the identity function in this case).")
			[
			[],
			TS "TestId :: Dynamic a -> a",
			TS "TestId (id :: A.b: b -> b) x = id x",
			TS "TestId else x                = x"
		],MSP [
			TS "To avoid confusion with type pattern variables (" TAL "see 8.2.4" TA " and " TAL "8.2.5"
			TA "), polymorphic type variables have to be explicitly introduced with the forall quantifier " TAC "(A" TA ".).",
			TS "Quantifiers are only allowed on the outermost level (Rank 1)."
		],MP [
			[],
			TSC "Dynamic" TA "s can be created by functions in other modules or even come from other (totally different) "
			TAC "Clean" TA " applications (" TAL "see 8.3" TA "). It is therefore possible that in a " TAC "Dynamic"
			TA (" a type with a certain name is stored, yet this type might have a type "+++
				"definition which is (slightly or totally) different from the type known in the matching function. So, the context in which a "+++
				"dynamic is packed might be totally different from the context in which the dynamic is unpacked via a pattern match. "+++
				"Hence, it is not enough that matching type constructors have identical names; they should also have exactly the same "+++
				"type definition. If not, the match will fail."),
			[],
			TSI ("Two types are considered to be equal if and only if all the type definitions (type constructors, data constructors, class "+++
				"definitions) are syntactically identical modulo the names of type variables (alpha conversion is allowed). Type "+++
				"equivalence of type constructors is automatically checked by the ")
			TAC "Clean" TA " run-time system, even if these types are defined in totally different "
			TAC "Clean" TA " applications. To make this possible, we had to change the architecture of the "
			TAC "Clean" TA " run-time system (" TAL "see 8.4" TA ").",
			[],
			TS ("So, when a pattern match on a dynamic takes place, the following things are checked in the indicated order (case "+++
				"constructs are handled in a similar way):"),
			[]
		],PW "1)" indent_width (
			TS ("All the type constructors (either of basic type, predefined or user defined) specified in a dynamic pattern will be "+++
				"compared with the name of the corresponding actual type constructors stored in the dynamics. If corresponding "+++
				"type constructors have different names, the pattern match fails and the next alternative is tried.")
		),N
		,PW "2)" indent_width (
			TS ("If in the pattern match, corresponding type's constructors have the same name, the run-time system will check "+++
				"whether their type definitions (their type might have been defined in different ") TAC "Clean"
			TA " applications or different " TAC "Clean"
			TA " modules) are the same as well. The system knows where to find these type definitions (" TAL "see 8.3" TA " and " TAL "8.4"
			TA "). If the definitions are not the same, the types are considered to be different. The pattern match fails and the next alternative is tried."
		),N
		,PW "3)" indent_width (
			TS ("If the types are the same, the actual data constructors (constant values) are compared with the data constructors "+++
			 	"specified in the patterns, as usual in a standard pattern match (") TAL "see 3.2"
			TA (") without dynamics. If all the specified constants match the actual values, the match is successful and the "+++
				"corresponding function alternative is chosen. Otherwise, the pattern match fails and the next alternative is tried.")
		)
		];
	= make_page pdf_i pdf_shl;

page_8_7 :: !{!CharWidthAndKerns} -> Page;
page_8_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "In the current implementation there are additional restrictions on the kind of types that can be packed into a "
			TAC "Dynamic" TA " and therefore also be unpacked from a " TAC "Dynamic" TA " ("
			TAL "see 8.2.1" TA ", " TAL "8.2.2" TA ", and " TAL "8.2.3" TA ").",
			[],
			TS "In a dynamic pattern match one can explicitly specify to match on a certain type constructors (e.g. " TAC "Tree Int"
			TA "). One can also use a type pattern variable (" TAL "see 8.2.4"
			TA ") to specify a type scheme with which the actual type has to be unified. By using overloaded variables (" TAL "see 8.2.5"
			TA (") defined in the type of the function, the static context in which a function is used "+++
				"can have influence on the kind of dynamic that is accepted. So, there are two special types of variables that can occur in "+++
				"a type pattern: type pattern variables and overloaded type pattern variables.")
		],H3
			"8.2.1" "Unpacking Abstract Data Types"
		,N
		,SP(
			TS "It is not yet possible to pack or unpack an abstract data type. " TAL "See also 8.1.1" TA "."
		),H3
			"8.2.2" "Unpacking of Overloaded Functions"
		,P(
			TS ("One can specify a class restriction in the type in a dynamic pattern match. The system will "+++
				"check whether the actual dynamic contains a function that is indeed overloaded with exactly the same class context "+++
				"restriction as specified in the pattern. Two class definitions are regarded to be equal if all involved class definitions are "+++
				"syntactically equal, modulo alpha conversion of the type variables.")
		),MSP [
			TS ("One is obligated for overloaded type variables to introduce them via the forall quantifier in the pattern, to avoid "+++
				"confusion with type pattern variables (see ") TAL "8.2.4" TA " and " TAL "8.2.5" TA ").",
			TS "Quantifiers are only allowed on the outermost level."
		],PCH
			(TS "Example: Unpacking of an overloaded function. The pattern match will only be successful if the dynamic contains a function overloaded in "
			 TAC "+" TA ". The corresponding class definitions will be checked: the definition of the class " TAC "+"
			 TA " has to be the same as the class " TAC "+" TA " known in the context where the dynamic has been created. Due to the application of "
			 TAC "plus 2 3" TA ", the type checker will require an instance for " TAC "+" TA " on integer values.")
			[
			[],
			TS "CheckDynamic:: Dynamic -> Int",
			TS "CheckDynamic (plus :: A.a : a a -> a | + a) = plus 2 3",
			TS "CheckDynamic else                           = 0"
		],H3
			"8.2.3" "Unpacking Expressions of Unique Type"
		,P(
			TS "Expressions of unique type (" TAL "see Chapter 9)"
			TA (" can also be unpacked via a dynamic pattern "+++
				"match. However, the run-time system cannot deal with uniqueness type variables or with coercion statements (attribute "+++
				"variable inequalities). One can only use the type attribute \"") TAC "*"
			TA ("\". The match will only be successful if the specified types "+++
				"match and all type attributes also match. No coercion from unique to non-unique or the other way around will take place.")
		),PCH
			(TS "Example: Unpacking a function that can write a character to a unique file.")
			[
			[],
			TS "WriteCharDynamic:: Dynamic Char *File -> *File",
			TS "WriteCharDynamic (fwc :: Char *File -> *File) char myfile = fwc char myfile",
			TS "WriteCharDynamic else char myfile                         = myfile"
		],MSP [
			TS "Uniqueness type variables and coercion statements cannot be used in a dynamic pattern match.",
			TS ("The type attributes of the formal argument and the actual argument have to be exactly the same. No coercion from "+++
				"unique to non-unique or the other way around will take place.")
		],H3
			"8.2.4" "Checking and Unifying Types Schemes using Type Pattern Variables"
		,P(
			TS "In an ordinary pattern match one can use " TAI "data constructors" TA " (to test whether an argument is of a "
			TAI "specific value" TA ") and " TAI "variables" TA " (which match on " TAI "any concrete value"
			TA " in the domain). Similarly, in a pattern match on a dynamic type one can use " TAI "type constructors"
			TA " (to test whether a dynamic contains an expression of a " TAI "specific type" TA ") and " TAI "type pattern variables"
			TA " (which match on " TAI "any type"
			TA ("). However, there are differences between ordinary variables and type pattern variables as "+++
				"well. All ordinary variable symbols introduced at the left-hand side of a function definition must have different names (")
			TAL "see 3.2"
			TA ("). But, the same type variable symbol can be used several times in the left-hand side (and, of course, also in the right-"+++
				"hand side) of a function definition. Type pattern variables have the function alternative as scope and can appear in a "+++
				"pattern as well as in the right-hand side of a function in the context of a dynamic type.")
		)
		];
	= make_page pdf_i pdf_shl;

page_8_8 :: !{!CharWidthAndKerns} -> Page;
page_8_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
				[TS "TypePatternVariable",	TS_E,	TS "Variable"]
		],MP [
			[],
			TS "Each time the " TAI "same" TA " type variable is used in the left-hand side, the pattern matching mechanism will try to " TAI "unify"
			TA (" the type variable with the concrete type stored in the dynamic. If the same type variable is used several times on the left hand-"+++
				"side, the most general unifier is determined that matches on ") TAI "all"
			TA (" corresponding types in the dynamics. If no general unifier can be found, the match will fail. As usual, of all corresponding "+++
				"type constructors it will be checked whether they are indeed the same: the corresponding type definitions have to be equivalent (")
			TAL "see 8.2"
			TA "). Type equivalence of matching type constructors is automatically checked by the " TAC "Clean"
			TA " run-time system, even if these types are defined in different " TAC "Clean" TA " applications.",
			[],
			TS ("Type pattern variables are very handy. They can be used to check for certain type schemes or to check the internal type "+++
				"consistency between different Dynamics, while the checking function does not exactly has to know which concrete types "+++
				"are actually stored in a dynamic. One can make use of type pattern variables to manage and control plug-ins in a flexible "+++
				"way see 8.3).")
		],PCH
			(TS "The function " TAC "dynApply" TA " has two arguments of type " TAC "Dynamic" TA " and yields a value of type "
			 TAC "Dynamic" TA " as well. The first " TAC "Dynamic" TA " has to contain a function unifiable with type " TAC "(a -> b)"
			 TA ", the second argument has to be " TAI "unifiable" TA " with the argument type " TAC "a"
			 TA (" the function is expecting. In this way we can ensure that it is type technically safe to apply the function "+++
			 	  "to the argument, without exactly knowing what the actual types are. The result will have the statically unknown type ")
			 TAC "b" TA ", but, by packing this result into a Dynamic again, the static type system is happy: it is a " TAC "Dynamic"
			 TA ". If the dynamics types cannot be unified, it is not type safe to apply the function to the argument, and the next alternative of "
			 TAC "dynApply" TA " is chosen. It yields an error message stored into a dynamic.")
			(map color_keywords [
			[],
			TS "dynApply :: Dynamic Dynamic -> Dynamic",
			TS "dynApply (f :: a -> b) (x :: a)    = dynamic (f x :: b)",
			TS "dynApply  df            dx         = dynamic (\"cannot apply \",df,\" to \",dx)",
			[],
			TS "Start = dynApply (dynamic (map ((+) 1)) (dynamic [1..10])"
		]),P(
			TS "Type pattern variables behave similar as existentially quantified type variables (" TAL "see 5.1.3"
			TA ("). It is statically impossible to "+++
				"determine what the actual type of a type pattern variable is. So, in the static type system one cannot define an "+++
				"expression which type is depending on the value of a type pattern variable. The static type system cannot deal with it, "+++
				"since it does no know its value. However, an expression which type is depending on the type assigned to a type pattern "+++
				"variable can be packed into a dynamic again, because this is done at run-time. See the ")
			TAC "dynAppy" TA " example above."
		),N
		,SP(
			TS "	It is not allowed to create an expression which static type is depending on the value of a type pattern variable."
		),PCH
			(TS "Counter Example: It is not possible to let a static type depend on the value of a type pattern variable. The actual value of the type "
			 TAC "b" TA " in " TAC "WrongDynApply" TA " is unknown at run-time. This example will result into a type error. See "
			 TAL "8.2.5" TA " for a legal variant of this function.")
			(map color_keywords [
			[],
			TS "WrongDynApply :: Dynamic Dynamic -> ???",
			TS "WrongDynApply (f :: a -> b) (x :: a)  = f x",
			TS "WrongDynApply df            dx        = abort \"cannot perform the dyanmic application\"",
			[],
			TS "Start = WrongDynApply (dynamic (map ((+) 1)) (dynamic [1..10]) ++ [11..99]"
		]),P(
			TS ("Note: don't confuse type pattern variables with the other variables that can appear in a dynamic type to indicate "+++
				"polymorphic or overloaded functions or constructors. The latter are introduced via a quantifier in the type. ")
			TAL "See also 8.2.5" TA "."
		),H3
			"8.2.5" "Checking and Unifying Unknown Types using Overloaded Type Variables"
		,P(
			TS "In a dynamic pattern match one can explicitly state what type of a " TAC "Dynamic"
			TA (" is demanded. But it is also possible to let the static context in which a function is used impose restrictions "+++
				"on the Dynamic to be accepted. This can be realized by using ")
			TAI "overloaded type variables"
			TA (" in a dynamic pattern. Such an overloaded type variable has to be introduced in the type "+++
				"of the function itself and the variable should have the predefined type class ")
			TAC "TC" TA " (" TAL "see 8.1.1"
			TA (") as context restriction. This makes it possible to let the overloading mechanism determine what the demanded type of a Dynamic "+++
				"has to be (the \"type dependent functions\" as introduced by Marco Pil, 1999). By using such an overloaded type variable in a dynamic "+++
				"pattern, the type assigned by the static overloading mechanism to this variable is used as specification of the required "+++
				"type in the dynamic pattern match. The caret symbol (")
			TAC "^"
			TA (") is used as suffix of a type pattern variable in a dynamic pattern "+++
				"match to indicate that an overloaded type variable is used, instead of a type pattern variable. Overloaded type variables "+++
				"have the whole function definition as scope, including the type of the function itself.")
		)
		];
	= make_page pdf_i pdf_shl;

page_8_9 :: !{!CharWidthAndKerns} -> Page;
page_8_9 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[ST [
				[TS "OverloadedTypeVariable",	TS_E,	TS "Variable" TABCr"^"]
		],MSP [
			TS "An overloaded type pattern variable has to be introduced in the type definition of the function.",
			TS "The predefined type class " TAC "TC" TA " (" TAL "see 8.1.1" TA ") has to be specified as context restriction on the global type pattern variable.",
			TS "As is usual with overloading (" TAL "see 6.6"
			TA "), in some cases the compiler is not able to resolve overloading, e.g. due to internally ambiguously overloading."
		],PCH
			(TS "Example: The function " TAC "Start" TA " appends " TAC "[11..99]" TA "to the result of "
			 TAC "FlexDynApply" TA ". So, it is clear that " TAC "FlexDynApply" TA " will have to deliver a " TAC "[Int]"
			 TA " to the function " TAC "Start" TA ". The additional context restriction " TAC "TC b" TA " turns "
			 TAC "FlexDynApply into an overloaded function in " TAC "b" TA ". The function " TAC "FlexDynApply"
			 TA " will not deliver " TAI "some" TA " dynamic type " TAC "b" TA ", but " TAI "the" TA " static type "
			 TAC "b" TA " that is demanded by the context applying " TAC "FlexDynApply"
			 TA ". The overloading mechanism will automatically pass as additional parameter information about the static type "
			 TAC "b" TA (" that is required by the context. This type is then used to check the actual type of the "+++
			 "dynamic in the dynamic pattern match"))
			(map color_keywords [
			[],
			TS "FlexDynApply :: Dynamic Dynamic -> b | TC b",
			TS "FlexDynApply (f :: a -> b^) (x :: a)   = f x",
			TS "FlexDynApply df            dx          = abort \"cannot perform the dyanmic application\"",
			[],
			TS "Start = FlexDynApply (dynamic (map ((+) 1)) (dynamic [1..10]) ++ [11..99]"
		]),PCH
			(TS "Example: The function " TAC "lookup"
			 TA " will look up a value of a certain type " TAC "a" TA " in its lists of " TAC "Dynamic"
			 TA "s. The type it will search for  depends on the context in which the function "
			 TAC "lookup" TA " is used. In Start the lookup function is used twice. In the first case an integer value is demanded (due to "
			 TAC "+ 5" TA "), in the second case a real value (due to "
			 TAC "+ 2.5" TA ") is required. The program will be aborted if a value of the required type cannot be found in the list.")
			(map color_keywords [
			[],
			TS "lookup :: [Dynamic] -> a  | TC a",
			TS "lookup [(x :: a^):xs] = x",
			TS "lookup [x:xs]         = lookup xs",
			TS "lookup []             = abort \"dynamic type error\"",
			[],
			TS "Start = (lookup DynamicList + 5, lookup DynamicList + 2.5)  // result will be (6,5.64)",
			[],
			TS "DynamicList = [dynamic 1, dynamic 3.14, dynamic 'a']"
		]),S(
			"Note: don't confuse overloaded type variables with type pattern variables or the other variables that can appear in a "+++
			"dynamic type to indicate polymorphic or overloaded functions or constructors. The latter are introduced via a quantifier in "+++
			"the type."
		),PCH
			(TS ("Example: the following artificial example the kinds of type variables that can be used in a dynamic pattern are shown. In "+++
				 "the first alternative a type variable ") TAC "a"
			 TA (" is used (introduced by the forall quantifier). This alternative only matches on a "+++
				 "polymorphic function. In the second alternative an overloaded type variable is used (indicated by ")
			 TAC "a^" TA ") referring to the overloaded type variable " TAC "a | TC a"
			 TA (" introduced in the function body. It will match on a function of the same type as the "+++
				 "actual type of the second argument of AllSortsOfVariables. The last alternative uses type pattern variables ")
			 TAC "a" TA " and " TAC "b" TA ". It matches on any function type, although this function is not used.")
			[
			[],
			TS "AllSortsOfVariables :: Dynamic  a -> a | TC a",
			TS "AllSortsOfVariables (id::A.a : (a -> a)) x  = id x",
			TS "AllSortsOfVariables (f::a^ -> a^)        x  = f x",
			TS "AllSortsOfVariables (f::a -> b)          x  = x"
		],H2
			"8.3" "Type Safe Communication using Dynamics"
		,MP [
			[],
			TS "As explained in the introduction of this Chapter, the most important practical use of "
			TAC "Dynamic"
			TA "s is enabling type safe communication of data and code between different (distributed) CLEAN applications. When a "
			TAC "Dynamic"
			TA (" is stored or communicated it will be encoded (serialized) to a string. So, in principle almost any communication media "+++
				"can be used to communicate ") TAC "Dynamic"
			TA "s. In this section we only explain how to store and retrieve a " TAC "Dynamic" TA " from a " TAC "File"
			TA ". It is also possible to communicate a " TAC "Dynamic"
			TA (" directly via a channel or via send / receive communication primitives. The actual possibilities are "+++
				  "depending on the facilities offered by CLEAN libraries. This is outside the scope of this CLEAN language report."),
			[],
			TS "If a CLEAN application stores a " TAC "Dynamic" TA " into a " TAC "File" TA " " TAI "any"
			TA " other (totally different) CLEAN application can read the " TAC "Dynamic" TA " from it. Since a " TAC "Dynamic"
			TA (" can contain data as well as code (unevaluated function applications), this means that any part of one CLEAN program "+++
				"can be plugged into another. Since CLEAN is using compiled code, this has a high impact on the run-time system (")
			TAL "see 8.4" TA ")."
		]
		];
	= make_page pdf_i pdf_shl;

page_8_10 :: !{!CharWidthAndKerns} -> Page;
page_8_10 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS "One can read and write a " TAC "Dynamic" TA " with just " TAI "one"
			TA " function call. In the CLEAN library " TAC "StdDynamic" TA " the functions "
			TAC "readDynamic" TA " and " TAC "writeDynamic"
			TA " are predefined. As usual in CLEAN, uniqueness typing is used for performing I/O (" TAL "see 9.1"
			TA "). When a " TAC "Dynamic" 
			TA "is written, the whole expression (the graph expression and its static type) is encoded symbolically to a "
			TAC "String" TA " and stored on disk. When a " TAC "Dynamic" 
			TA " is read, it is read in lazily. Only when the evaluation of the " TAC "Dynamic"
			TA " is demanded (which can only happen after a successful pattern match), the String is decoded back to a "
			TAC "Dynamic" TA ". If new function definitions have to be plugged in, this will be done automatically (" TAL "see 8.4"
			TA "). This lazy reading is also done for " TAC "Dynamics" TA " stored into a " TAC "Dynamic" TA ". So, a "
			TAC "Dynamic" TA " can only be plugged in if its type is approved in a " TAC "Dynamic" TA " pattern match."
		),PCH
			(TS "Standard functions for reading and writing of a Dynamic.")
			(map color_keywords [
			[],
			TS "definition module StdDynamic",
			[],
			TS "...",
			[],
			TS "writeDynamic :: Dynamic String *World -> *(Bool,*World)",
			[],
			TS "readDynamic :: String *World -> *(Bool, Dynamic, *World)"
		]),P(
			TS "The use of " TAC "Dynamics" TA " is shown in the examples below. Each example is a complete CLEAN application."
		),PCH
			(TS "Example of a CLEAN application writing a " TAC "Dynamic"
			 TA " containing a value of type " TAC "Tree Int" TA " to a " TAC "File" TA " named " TAC "DynTreeValue"
			 TA ". This example shows that data can be stored to disk using the CLEAN function " TAC "writeDynamic" TA ".")
			(map color_keywords [
			[],
			TS "module TreeValue",
			[],
			TS "import StdDynamic, StdEnv",
			[],
			TS ":: Tree a = Node a (Tree a) (Tree a) | Leaf",
			[],
			TS "Start world",
			TS "# (ok,world) = writeDynamic \"DynTreeValue\" MyTree world",
			TS "| not ok     = abort \"could not write MyTree to file named DynTreeValue\"",
			TS "| otherwise  = world",
			TS "where",
			TS "    MyTree::Dynamic",
			TS "    MyTree = dynamic (Node 1 mytree mytree)",
			TS "    where",
			TS "        mytree = (Node 2 (Node 3 Leaf Leaf) Leaf)"
		])
		];
	= make_page pdf_i pdf_shl;

page_8_11 :: !{!CharWidthAndKerns} -> Page;
page_8_11 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of another CLEAN application writing a " TAC "Dynamic"
			 TA " containing the function countleafs to a File named CountsLeafsinTrees. This function can count the numbers of leafs in a "
			 TAC "Tree" TA " and is of type " TAC "(Tree Int) -> Int"
			 TA ". This examples shows that code (in this case the function "
			 TAC "CountLeafs" TA ") can be stored on disk as well, just using " TAC "WriteDynamic" TA ".")
			(map color_keywords [
			[],
			TS "module CountLeafs",
			[],
			TS "import StdDynamic, StdEnv",
			[],
			TS ":: Tree a = Node a (Tree a) (Tree a) | Leaf",
			[],
			TS "Start world",
			TS "# (ok,world) = writeDynamic \"CountsLeafsinTrees\" CountLeafs world",
			TS "| not ok     = abort \"could not write dynamic\"",
			TS "| otherwise  = world",
			TS "where",
			TS "    CountLeafs = dynamic countleafs",
			[],
			TS "    countleafs:: (Tree Int) -> Int",
			TS "    countleafs  tree = count tree 0",
			TS "    where",
			TS "        count:: (Tree a) Int -> Int",
			TS "        count Leaf nleafs               = nleafs + 1",
			TS "        count (Node left right) nleafs  = count left (count right nleafs)",  
			TS "        count else                      = abort \"count does not match\""
		]),N
		,PCMH [
			TS "The third CLEAN application reads in the file TreeValue containing a " TAC "Tree Int" TA " and the function "
			TAC "countleafs" TA " (a plugin) that can counts the number of " TAC "Leaf" TA "s in a " TAC "Tree"
			TA ". So, new functionality is added to the running application Apply. By using the function " TAC "dynapply"
			TA " the new plugged in function countleafs is applied to the tree that has been read in as well. The application "
			TAC "Apply" TA " itself has a function to count the number of nodes and applies this function on the tree read in. ",
			TS "Note that this application will only work if all the type " TAC "Tree"
			TA "s defined in the different applications are exactly the same (module the names for the type variables used)."
		](map color_keywords [
			[],
			TS "module Apply",
			[],
			TS "import StdDynamic, StdEnv",
			[],
			TS ":: Tree a = Node a (Tree a) (Tree a) | Leaf",
			[],
			TS "Start world",
			TS "# (ok,countleafs,world)   = read \"CountsLeafsinTrees\" world",
			TS "| not ok                  = abort (\"could not read CountsLeafsinTrees\")",
			TS "# (ok,treevalue,world)    = read \"TreeValue\" world",
			TS "| not ok                  = abort (\"could not read TreeValue\")",
			TS "| otherwise  =   (    countnodes (case treevalue of (v::(Tree Int))= v) 0",
			TS "                 ,    dynapply countleafs treevalue",
			TS "                 )",
			TS "where",
			TS "    dynapply :: Dynamic Dynamic -> Dynamic",
			TS "    dynapply (f::a -> b) (v::a)  = dynamic (f v)",
			TS "    dynapply df          dv     = dynamic \"incorrectly typed dynamic application\"",
			[],
			TS "    countnodes Leaf nnodes              = nnodes",
			TS "    countnodes (Node left right) nnodes = countnodes left (countnodes right (nnodes+1))"
		]),H2
			"8.4" "Architecture of the implementation"
		,P(
			TS "From the examples above we learn that a " TAC "Dynamic"
			TA (" stored on disk can contain data as well as code (unevaluated functions and function applications). How is this "+++
				"information stored into a file and how is a running CLEAN application extended with new data and new functionality? "+++
				"To understand this one has to know a little bit more about how a CLEAN application is generated.")
		)
		];
	= make_page pdf_i pdf_shl;

page_8_12 :: !{!CharWidthAndKerns} -> Page;
page_8_12 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3T "Implementation of Dynamics"
		,P(
			TS "CLEAN applications are not interpreted via an interpreter. Executables are generated using compiled machine code. Storing a "
			TAC "Dynamic" 
			TA " into disk and retrieving it again from disk cannot simply be done by (re) interpretation of CLEAN source code."
		),PI 120 (picture_1 font_size)
		,P(
			TS ("The CLEAN compiler (written in CLEAN) compiles CLEAN implementation modules (.icl and .dcl files) to machine "+++
				"independent abc-code (.abc files). The CLEAN definition modules are used to check the type consistency between the "+++
				"separately programmed CLEAN modules. The abc-code contains machine instructions for a virtual abstract machine, the "+++
				"abc-machine (see ")++TSb "Plasmeijer and van van Eekelen"
			TA (", 1993). The abc-code is a kind of platform independent byte code "+++
				"specially designed for CLEAN. The Code Generator (the one and only application in the Clean system which is written in "+++
				"C) translates the abc-code into platform dependent symbolic machine code (.obj files under Windows). The code "+++
				"generator can generate code for different platforms such as for Intel (Windows, Linux), Motorola (Mac) and Sparc (Unix) "+++
				"processors. The Static Linker (written in CLEAN) links all the object modules of one CLEAN program together into a click "+++
				"able executable application (.exe file under Windows). The compilation scheme described above can be used even if "+++
				"Dynamics are internally used in an application. But, as soon as ") TAC "Dynamic" TA "s are communicated to " TAC "File"
			TA (" or communicated to another program, a different run-time support is needed and the traditional compilation scheme "+++
				"is changed to prepare this.")
		),PI 170 (picture_2 font_size)
		,P(
			TS ("In the changed compilation scheme, the static linker not only generates an application (actually, currently it is a .bat file), "+++
				"but it also generates two additional files. One is called the code repository (.lib file). All object codes of your application "+++
				"are collected here. The other file (.typ file) is a repository that contains all type definitions. The repositories serve as a "+++
				"database which is accessed by the Dynamic Linker. Whenever an (other) running application needs code for a plug in or "+++
				"a type that has to be checked, the Dynamic Linker will look it up in the appropriate repository. Each time a CLEAN "+++
				"program is recompiled, new repositories are created. Repositories should not be removed by hand because it might make the ")
			TAC "Dynamic" TA "s stored on disk unreadable. A special garbage collector is provided that can remove unused repositories."
		)
		];
	= make_page pdf_i pdf_shl;

page_8_13 :: !{!CharWidthAndKerns} -> Page;
page_8_13 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS ("When a CLEAN application doing dynamic I/O is started, a special linker (the Dynamic Linker, written in CLEAN) is started "+++
				"with it as well (if it is not already running). The Dynamic Linker is a server application on the computer. It will serve all "+++
				"running CLEAN programs that read or write ")
			TAC "Dynamic"
			TA ("s. The Dynamic Linker will construct the application or plug-in at run-"+++
				"time in the same way as the Static Linker would do at compile-time for a conventional CLEAN program. There is no "+++
				"efficiency penalty once the code is linked in."),
			[],
			TS "When a " TAC "Dynamic" TA " is written to disk using the function " TAC "writeDynamic"
			TA (", two (!) files are created: a .dyn file and a .sysdyn "+++
				"file. The .sysdyn file contains the actual information: a String encoding of the dynamic. This sysdyn file is used by the "+++
				"Dynamic Linker and should not be touched by the user because it might make the ")
			TAC "Dynamic"
			TA "s stored on disk unreadable. The special garbage collector provided will also remove unused .sysdyn files.",
			[],
			TS ("The user may only touch and use the .dyn file that contains references to the actual dynamic stored in the .sysdyn file. "+++
				"The .dyn file can be seen as a \"typed\" file. It can be handled like any other user file. It can be renamed, moved or deleted "+++
				"without any danger."),
			[],
			TS "When a " TAC "Dynamic"
			TA ("is written to a file, an encoding of the graph and its type are written to disk. The graph is encoded in "+++
				"such a way that sharing will be maintained when the graph is read in again. The stored graph may contain unevaluated "+++
				"functions. In a ") TAC "Dynamic"
			TA (" on disk, functions are represented by symbolic pointers to the corresponding code repositories. "+++
				"The types stored in a Dynamic on disk point to the corresponding type definitions stored in the type repositories."),
			[],
			TSI "No plug-in will be plugged in unless its type is approved." TA " When a " TAC "Dynamic"
			TA " stored on disk is read in by an (other) application, first only a pointer to the stored " TAC "Dynamic"
			TA ("is used in the CLEAN program. To use a Dynamic in an application "+++
				"one first has to examine it in a pattern match. In the pattern match the type of the ")
			TAC "Dynamic" TA " is unified with a specified type or with the type of another " TAC "Dynamic"
			TA ("s. If the run-time type unification is successful, the Dynamic Linker will check "+++
				"whether all type definitions of the types involved are identical as well. This type information is fetched from the "+++
				"corresponding type repository when needed. If the types are identical and the conventional pattern match succeeds as "+++
				"well, the corresponding function body can be evaluated. Only when the evaluation of the stored Dynamic is demanded, "+++
				"the graph encoded in the Dynamic on disk is reconstructed as far as needed (")
			TAC "Dynamic" TA "s nested in a " TAC "Dynamic"
			TA " are reconstructed lazily). The Dynamic Linker links in the code corresponding to the unevaluated functions stored in the "
			TAC "Dynamic"
			TA (". It is fetched from the code repository and plugged in the running (!) application. In some cases the Dynamic "+++
				"Linker will ask the Code Generator to generate new code (just-in-time code generation) to construct the required image. "+++
				"The Dynamic Linker has to ensure that identical data types defined in different applications are linked in such a way that "+++
				"they are indeed considered to be of the same type at run-time.")
		],H2
			"8.5" "Semantic Restrictions on Dynamics"
		,N
		,SP(
			TS "The following types cannot be packed/unpacked: abstract data types, uniqueness types, overloaded types. We are working on it."
		)
		];
	= make_page pdf_i pdf_shl;
