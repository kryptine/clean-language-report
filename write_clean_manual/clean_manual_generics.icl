implementation module clean_manual_generics;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

pages_7 :: [{!CharWidthAndKerns} -> Page];
pages_7 = [page_7_1,page_7_2,page_7_3,page_7_4,page_7_5,page_7_6,page_7_7,page_7_8,page_7_9];

page_7_1 :: !{!CharWidthAndKerns} -> Page;
page_7_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 7" "Generic Programming"
		,H2
			"7.1" "Basic Ideas Behind Generic Programming"
		,P(
			TS "In the previous Chapter on overloading it is explained how type classes can be used to define "
			TAI "different" TA " functions or operators that have the " TAI "same" TA " name and perform "
			TAI "similar tasks" TA " albeit on objects of " TAI "different types"
			TA (". These tasks are supposed to be similar, but they are in general not exactly the same. The corresponding "+++
				"function bodies are often slightly different because the data structures on which the functions work differ. "+++
				"As a consequence, one has to explicitly specify an implementation for every concrete instance of an "+++
				"overloaded function.")
		),PCH
			(TS ("Equality class. The equality function on lists and trees. The programmer has to specify explicitly the "+++
				 "function bodies for each concrete instantiation of equality."))
			(map color_keywords [
			[],
			TS ":: List a    =   Nil a",
			TS "             |   Cons a (List a)",
			TS ":: Tree a    =   Leaf a",
			TS "             |   Node (Tree a) (Tree a)",
			[],
			TS "class Eq a",
			TS "where",
			TS "   (==) infix 2 :: a a -> Bool",
			[],
			TS "instance Eq (List a) | Eq a",
			TS "where",
			TS "   (==) infix 2 :: (List a) (List a) -> Bool | Eq a",
			TS "   (==) Nil Nil                = True",
			TS "   (==) (Cons x xs) (Cons x xs)= x == y && xs == ys",
			TS "   (==) _      _               = False",
			[],
			TS "instance Tree a | Eq a",
			TS "where",
			TS "   (==) infix 2 :: (Tree a) (Tree a) -> Bool | Eq a",
			TS "   (==) (Leaf x) (Leaf y)          = x == y",
			TS "   (==) (Node lx rx)  (Node ly ry) = lx == ly && rx == ry",
			TS "   (==) _      _                   = False"
		]),MP [
			[],
			TS ("In the example above the programmer explicitly defines equality on lists and trees. For each new data type that we want "+++
				"to compare for equality, we have to define a similar instance. Moreover, if such a data type changes, the corresponding "+++
				"instance should be changed accordingly as well. Though the instances are ")
			TAI "similar" TA ", they are not the same since they operate on different data types.",
			[],
			TS ("What is similar in these instances? Both instances perform pattern match on the arguments. If the constructors are "+++
				"the same, they compare constructor arguments pairwise. For constructors with no arguments ") TAC "True"
			TA (" is returned. For constructors with several arguments, the results on the arguments are combined with &&. If constructors "+++
				"are not the same, ") TAC "False"
			TA (" is returned. In other words, equality on a data type is defined by looking at the structure of the data type. "+++
				"More precisely, it is defined by induction on the structure of types. There are many more functions than just equality that "+++
				"expose the same kind of similarity in their instances. Below is the mapping function that can be defined for type "+++
				"constructors of kind *->*."),
			[]
		]
		];
	= make_page pdf_i pdf_shl;

page_7_2 :: !{!CharWidthAndKerns} -> Page;
page_7_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "The Functor provides the mapping function for a type constructor of kind *->* (" TAL "see also 6.4" TA ").")
			(map syntax_color [
			[],
			TS "class Functor f",
			TS "where",
			TS "    fmap :: (a -> b) (f a) -> (f b)",
			[],
			TS "instance Functor List",
			TS "where",
			TS "    fmap :: (a -> b) (List a) -> (List b)",
			TS "    fmap f Nil         = Nil",
			TS "    fmap f (Cons x xs) = Cons (f x) : Cons (fmap f xs)",
			[],
			TS "instance Functor Tree",
			TS "where",
			TS "    fmap :: (a -> b) (Tree a) -> (Tree b)",
			TS "    fmap f (Leaf a)   = Leaf (f a)",
			TS "    fmap f (Node l r) = Node (fmap f l) (fmap f r)"
		]),MP [
			[],
			TS ("Again, both instances are similar: they perform pattern match on constructors and pairwise mapping of their arguments. "+++
				"The results are packed back in the same constructor."),
			[],
			TS "Generic programming enables the programmer to capture this kind of similarities and define a single implementation for "
			TAI "all" TA " instances of such a class of functions. To do so we need a universal structural representation of "
			TAI "all" TA " data types. A generic function can then be defined " TAI "ones and forall"
			TA (" on that universal representation. A specific type is handled using its "+++
				"structural representation. In the rest of this section we will explain roughly how it all works. First we focus on the "+++
				"universal structural representation of types; then we show how a generic function can be defined on it; and at last we "+++
				"show how the generic definition is specialized to a concrete type. See also (Alimarine & Plasmeijer, 2001, ")
				++TSb "A Generic Programming Extension for Clean" TA ").",
			[],
			TS "In CLEAN data types are algebraic: they are built in of sums of products of type terms. For example, the " TAC "List"
			TA " type is a sum of two things: nullary product for " TAC "Nil"
			TA " and a binary product of the head and the tail for " TAC "Cons"
			TA ". The Tree type is a sum of unary product of elements for Leaf and binary product of trees for " TAC "Node"
			TA ". Having this in mind we can uniformly represent CLEAN data types using binary sums and products."
		],PCH
			(TS ("Binary sum and product types defined in StdGeneric.dcl. These types are needed to represent CLEAN types as sums of "+++
							  "products of types for the purpose of generic programming."))
			[
			[],
			TS ":: UNIT a        = UNIT a",
			TS ":: PAIR a b      = PAIR a b",
			TS ":: EITHER l r    = LEFT l | RIGHT r"
		],P(
			TS "The " TAC "UNIT" TA " type represents a nullary product. The " TAC "PAIR" TA " type is a binary product. The " TAC "EITHER"
			TA (" type is a binary sum. We do not need a type for nullary sums, as in CLEAN data types have "+++
				"at least one alternative. As one can imagine, we want sum-product representation of types "+++
				"to be equivalent (i.e. isomorphic) to the original data types. In the following example "+++
				"we give representations for ") TAC "List" TA " and " TAC "Tree"
			TA " with conversion functions that implement the required isomorphisms."
		),PCH
			(TS "Sum-product representation of the structure of " TAC "List" TA " and " TAC "Tree"
						  TA (" with conversion functions that implement isomorphisms "+++
							  "between the types and their sum-product representations."))
			[
			[],
			TS ":: ListS a :== EITHER UNIT (PAIR a (List a))",
			[],
			TS "listToStruct    :: (List a)  -> _ListS a",
			TS "listToStruct Nil                   = LEFT UNIT",
			TS "listToStruct (Cons x xs)           = RIGHT (PAIR x xs)",
			[],
			TS "listFromStruct   :: (ListS a) -> _List a",
			TS "listFromStruct (LEFT UNIT)         = Nil",
			TS "listFromStruct (RIGHT (PAIR x xs)  = Cons x xs",
			[],
			TS ":: TreeS a :== EITHER a (PAIR (Tree a) (Tree a))",
			[],
			TS "treeToStruct     :: (Tree a)   -> _TreeS a",
			TS "treeFromStruct   :: (TreeS a)  -> _Tree a"
		]
		];
	= make_page pdf_i pdf_shl;

page_7_3 :: !{!CharWidthAndKerns} -> Page;
page_7_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[S(
			"As we said, all algebraic types can be represented in this way. Basic types are not algebraic, but there are only few of "+++
			"them: they are represented by themselves. Arrow types are represented by the arrow type constructor (->). To define a "+++
			"function generically on the structure of a type it is enough to define instances on the components the structure can be "+++
			"built from. These are binary sums, binary products, basic types, and the arrow type."
		),PCH
			(TS ("Equality on sums, products and primitive types. Equality cannot be feasibly defined for the arrow type, so the instance "+++
							 "is omitted."))
			(map syntax_color [
			[],
			TS "instance UNIT",
			TS "where",
			TS "    (==) infix 2 :: UNIT UNIT -> Bool",
			TS "    (==) UNIT UNIT            = True",
			[],
			TS "instance PAIR a b | Eq a & Eq b",
			TS "where",
			TS "    (==) infix 2 :: (PAIR a b) (PAIR a b) -> Bool",
			TS "    (==) (PAIR a1 b1) (PAIR a2 b2) = a1 == a2 && b1 == b2",
			[], 
			TS "instance EITHER a b | Eq a & Eq b",
			TS "where",
			TS "    (==) infix 2 :: (EITHER a b) (EITHER a b) -> Bool",
			TS "    (==) (LEFT x)  (Leaf y)   = x == y",
			TS "    (==) (RIGHT x) (RIGHT y)  = x == y",
			TS "    (==) x_         y_        = False",
			[],
			TS "instance Int",
			TS "where",
			TS "    (==) infix 2 :: Int Int -> Bool",
			TS "    (==) x y = eqInt x y             // primitive equality on integers"
		]),S(
			"Having defined instances on the structure components we can generate instances for all other types automatically."
		),PCH
			(TS ("Equality for lists and trees that can be automatically generated. "+++
				 "Arguments are first converted to the structural representations which are then compared."))
			(map color_keywords [
			[],
			TS "instance Eq (List a) | Eq a",
			TS "where",
			TS "    (==) infix 2 :: (List a) (List a) -> Bool | Eq a",
			TS "    (==) xs ys = listToStruct xs == listToStruct ys",
			[],
			TS "instance Tree a | Eq a",
			TS "where",
			TS "    (==) infix 2 :: (Tree a) (Tree a) -> Bool | Eq a",
			TS "    (==) xs ys = treeToStruct xs == treeToStruct ys"
		]),S(
			"Not only instances of one class expose similarity in the definition of instances."
		),PCH
			(TS ("The Bifunctor provides the mapping function for a type constructor of kind *->*->*. Instances are "+++
				  "defined in a similar way to instances of Functor."))
			(map color_keywords [
			[],
			TS ":: Tree2 a b      = Tip a",
			TS "                  | Bin b (Tree a b) (Tree a b)",
			[],
			TS "class Bifunctor f",
			TS "where",
			TS "    bmap :: (a1 -> b1) (a2 -> b2) (f a1 a2) -> (f b1 b2)",
			[],
			TS "instance Bifunctor Tree",
			TS "where",
			TS "    bmap :: (a1 -> b1) (a2 -> b2) (Tree2 a1 a2) -> (Tree b1 b2)",
			TS "    bmap f1 f2 (Tip x) = Tip (f1 x)",
			TS "    bmap f1 f2 (Bin x l r) = Bin (f2 x) (bmap f1 f2 l) (bmap f1 f2 r)"
		])
		];
	= make_page pdf_i pdf_shl;

page_7_4 :: !{!CharWidthAndKerns} -> Page;
page_7_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS ("The instance in the example above also works in a similar way as the instance of Functor: it also maps "+++
				"substructures component-wise. Both Functor and Bifunctor provide ") TAI "mapping"
			TA (" function. The difference is that one provides mapping for type constructors of kind *->* and the other for "+++
				"type constructors of kind *->*->*. In fact instances of mapping functions for all kinds are similar.")
		),H2
			"7.2" "Defining Generic Functions"
		,MP [
			[],
			TS ("The generic feature of CLEAN is able to derive instances for types of different kinds from a single generic definition. "+++
				"Such generic functions are known as kind-indexed generic functions (Alimarine & Plasmeijer, ")
			++TSb "A Generic Programming Extension for Clean" TA "). Actually, a generic function in CLEAN stands for a "
			TAI "set" TA " of classes and instances of the "TAI "same" TA " function for "
			TAI "different" TA " kinds. Since CLEAN allows function to be used in a Curried manner (" TAL "see 3.7.1"
			TA "), the compiler is in general not able to deduce which kind of map is meant. Therefore the " TAI "kind"
			TA " of a generic function application has to be specified explicitly.",
			[],
			TS ("To define a generic function the programmer has to provide to things: the base type of the "+++
				"generic function and the base cases (instances) of the generic function.")
		],ST [
			[TS "GenericsDef",	TS_E,	TS "GenericDef ;"],
			[[],				TS_B,	TS "GenericCase;"],
			[[],				TS_B,	TS "DeriveDef ;"]
		],ST [
			[TS "GenericDef",		TS_E,	TSBCr "generic" TA " " TAC "FunctionName" TA " " TAC "TypeVariable" TA "+ " TAT "::" TA " FunctionType"],
			[TS "GenericCase",		TS_E,	TSC "FunctionName" TA " " TAT "{|" TA "GenericTypeArg" TAT "|}" TA " {Pattern}+ " TAT "=" TA " FunctionBody"],
			[TS "GenericTypeArg",	TS_E,	TSBCr "CONS" TA " [" TABCr "of" TA " {Pattern}]"],
			[[],					TS_B,	TSBCr "FIELD" TA " ["  TABCr "of" TA " {Pattern}]"],
			[[],					TS_B,	TSC "TypeConstructorName"],
			[[],					TS_B,	TSC "TypeVariable"]
		],PCH
			(TS "Example. The generic definition of equality.")
			(map color_keywords [
			[],
			TS "generic gEq a ::         a            a             -> Bool",
			TS "gEq {|Int|}              x            y             = x == y",
			TS "gEq {|Char|}             x            y             = x == y",
			TS "gEq {|Bool|}             x            y             = x == y",
			TS "gEq {|Real|}             x            y             = x == y",
			TS "gEq {|UNIT|}             UNIT         UNIT          = True",
			TS "gEq {|PAIR|}   eqx eqy   (PAIR x1 y1) (PAIR x2 y2)  = eqx x1 x2 && eqy y1 y2",
			TS "gEq {|EITHER|} eql eqr   (LEFT x)     (LEFT y)      = eql x y",
			TS "gEq {|EITHER|} eql eqr   (RIGHT x)    (RIGHT y)     = eqr x y",
			TS "gEq {|EITHER|} eql eqr   x            y             = False",
			TS "gEq {|CONS|}   eq        (CONS x)     (CONS y)      = eq x y",
			TS "gEq {|FIELD|}  eq        (FIELD x)    (FIELD y)     = eq x y"
		]),PCH
			(TS "Example. The generic definition of map.")
			(map color_keywords [
			[],
			TS "generic gMap a b ::        a            -> b",
			TS "gMap {|c|}        x                     = x",
			TS "gMap {|PAIR|}     fx fy    (PAIR x y)   = PAIR (fx x) (fy y)",
			TS "gMap {|EITHER|}   fl fr    (LEFT x)     = LEFT (fl x)",
			TS "gMap {|EITHER|}   fl fr    (RIGHT x)    = RIGHT (fr x)",
			TS "gMap {|CONS|}     fx       (CONS x)     = CONS (fx x)",
			TS "gMap {|FIELD|}    fx       (FIELD x)    = FIELD (fx x)"
		])
		];
	= make_page pdf_i pdf_shl;

page_7_5 :: !{!CharWidthAndKerns} -> Page;
page_7_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Bidirectional mapping/ illustrate arrows")
			[
			[],
			TS "generic gMap a b ::        a           -> b",
			TS "gMap {|c|}        x                    = x",
			TS "gMap {|PAIR|}     fx fy    (PAIR x y)  = PAIR (fx x) (fy y)", 
			TS "gMap {|EITHER|}   fl fr    (LEFT x)    = LEFT (fl x)",
			TS "gMap {|EITHER|}   fl fr    (RIGHT x)   = RIGHT (fr x)",
			TS "gMap {|CONS|}     fx       (CONS x)    = CONS (fx x)",
			TS "gMap {|FIELD|}    fx       (FIELD x)   = FIELD (fx x)"
		],P(
			TS "In the generic definition, recognised by the keyword " TABCr "generic"
			TA (", first the type of the generic function has to be specified. "+++
				"The type variables mentioned after the generic function name are called ") TAI "generic type variables"
			TA ". Similar to type classes, they are substituted by the actual instance type. A generic definition actually defines a "
			TAI "set"
			TA (" of type constructor classes. There is one class for each possible kind in the set. Such a generic funcion is sometimes "+++
				"called a kind-indexed class. The classes are generated using the type of the generic function. The classes always have one "+++
				"class variable, even if the generic function has several generic variables. The reason for this restriction is that the "+++
				"generic function can be defined by induction on one argument only.")
		),PCH
			(TS "Classes that are automatically generated for the generic map function given above.")
			(map color_keywords [
			[],
			TS "class gMap{|*|} t              :: t -> t",
			TS "class gMap{|*->*|} t           :: (a -> b) (t a) -> t b",
			TS "class gMap{|*->*->*|} t        :: (a1 -> b1) (a2 -> b2) (t a1 a2) -> t b1 b2",
			TS "..."
		]),S(
			"Roughly the algorithm for deriving classes is the following."
		),PCH
			(TS "Algorithm for generating classes. Suppose we have a generic function " TAC "genFun" TA " with type " TAC "GenFun" TA ".")
			(map color_keywords [
			[],
			TS ":: GenFun a1 .. an :== ..",
			TS "generic genFun a1 .. an :: GenFun a1 .. an",
			[]
		]),CPCH
			(TS "A class for kind " TAI "k" TA ".")
		 	(map color_keywords [
	 		[],
			TS "class genFun{|k|} t     :: GenFun{|k|} t .. t",
			[]
		]),CPCH
			(TS "Is derived by induction on the structure of kind")
			[
			[],
			TS ":: GenFun{|*|} a1 ... an   :== GenFun a1.. an",
			TS ":: GenFun{|k->l|} a1 ..an  :==",
			TS "    A.b1 .. bn: (GenFun{|k|} b1 .. bn) -> GenFun{|l|} (a1 b1) .. (an bn)"
		],S(
			"The programmer provides a set of basic cases for a generic function. Based on its basic cases a generic function can be "+++
			"derived for other types. See the next section for detailed discussion on types for which a generic function can and cannot "+++
			"be derived. Here we discuss what can be specified as the type argument in the definition of a generic base case"
		),CMSP [
			TSI "A Generic structural representation type" TA ": " TAC "UNIT" TA ", " TAC "PAIR" TA ", " TAC "EITHER" TA ", " TAC "CONS"
			TA " and " TAC "FIELD" TA ". The programmer " TAI "must always provide"
			TA (" these cases as they cannot be derived by the compiler. Without these cases a generic function "+++
				"cannot be derived for basically any type."),
			TSI "Basic type"
			TA (". If a generic function is supposed to work on types that involve basic types, "+++
				"instances for basic types must be provided."),
			TSI "Type variable"
			TA (". Type variable stands for all types of kind *. If a generic function has a case for a type variable it "+++
				"means that by default all types of kind star will be handled by that instance. The programmer can override the "+++
				"default behavior by defining an instance on a specific type."),
			TSI "Arrow type (->)"
			TA (". If a generic function is supposed to work with types that involve the arrow type, an "+++
				"instance on the arrow type has to be provided."),
			TSI "Type constructor" TA ". A programmer may provide instances on other types. This may be needed for two reasons:"	
		]
		,MPWI
			[ ("1.", (TS "The instance cannot be derived for the reasons explained in the next section.")
			),("2.", (TS ("The instance can be generated, but the programmer is not satisfied with generic behavior for this type "+++
					   "and wants to provide a specific behavior."))
			)]
		];
	= make_page pdf_i pdf_shl;

page_7_6 :: !{!CharWidthAndKerns} -> Page;
page_7_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
	[H2	"7.3" "Deriving Generic Functions"
	,P(
		TS "The user has to tell the compiler instances of which generic functions on which types are to be generated. This is done with the "
		TAI "derive" TA " clause."
	),ST [
		[TS "DeriveDef",	TS_E,	TSBCr "derive" TA " "TAC "FunctionName" TA " " TAC "TypeConstructorName" TA "+"]
	],PCH
		(TS "Deriving instances of generic mapping and generic equality for List , Tree and standard list")
		(map syntax_color [
		[],
		TS "derive gEq  List, Tree, []",
		TS "derive gMap List, Tree, []"
	]),P(
		TS "A generic function can be automatically specialized only to algebraic types that are not abstract in the module where the "
		TAI "derive" TA " directive is given. A generic function cannot be automatically derived for the following types:"
	),CMSP [
		TSI "Generic structure representation types: " TAC "PAIR" TA ", " TAC "EITHER" TA ", " TAC "UNIT" TA ", " TAC "CONS" TA ", " TAC "FIELD"
		TA (". See also the previous section. It is "+++
			"impossible to derive instances for these types automatically because they are themselves used to build structural "+++
			"representation of types that is needed to derive an instance. Deriving instances for then would yield non-"+++
			"terminating cyclic functions. Instances on these types must be provided for the user. Derived instances of algebraic "+++
			"types call these instances."),
		TSI "Arrow  type  (->)"
		TA (". An instance on the arrow type has to be provided by the programmer, if he or she wants the "+++
			"generic function to work with types containing arrows."),
		TSI "Basic types" TA " like " TAC "Int" TA ", " TAC "Char" TA ", " TAC "Real" TA ", " TAC "Bool"
		TA (". In principle it is possible to represent all these basic types as algebraic types but that "+++
			"would be very inefficient. The user can provide a user defined instance on a basic type."),
		TSI "Array types" TA " as they are not algebraic. The user can provide a user defined instance on an array type.",
		TSI "Synonym types"
		TA  (". The user may instead derive a generic function for the types involved on the right-hand-side of a "+++
			 "type synonym type definition."),
		TSI "Abstract types" TA ". The compiler does not know the structure of an abstract data type needed to derive the instance.",
		TSI "Quantified types"
		TA ". The programmer has to manually provide instances for type definitions with universal and existential quantification."
	],S(
		"The compiler issues an error if there is no required instance for a type available. Required instances are "+++
		"determined by the overloading mechanism."
	),H2
		"7.4" "Applying Generic Functions"
	,P(
		TS ("The generic function in Clean stands for a set of overloaded functions. There is one function in the set for each kind. "+++
			"When a generic function is applied, the compiler must select one overloaded function in the set. The compiler cannot "+++
			"derive the required kind automatically. For this reason a kind has to be provided explicitly at each generic function "+++
			"application. Between the brackets ")
		TAC "{|" TA " and " TAC "|}" TA (" one can specify the intended kind. The compiler then resolves overloading "+++
			"of the selected overloaded function as usually.")
	),ST [
		[TS "GenericAppExpression",	TS_E,	TSC "FunctionName" TA "TypeKind GraphExpr"],
		[TS "TypeKind",				TS_E,	TST "{|* " TA "{" TAT "-> *" TA "} " TAT "|}"]
	],PCH
		(TS "Example: a generic equality operator can be defined as equality on types of kind *.")
		(map color_keywords [
		[],
		TS "(===) infix 2 :: a a -> Bool | gEq{|*|} a",
		TS "(===) x y = gEq{|*|} x y"
	]),PCH
		(TS "Example: a mapping function " TAC "fmap" TA " for functors and " TAC "bmap"
		 TA " for bifunctors can be defined in terms of the generic mapping function defined above just by specializing it for the appropriate kind.")
		[
		[],
		TS "fmap :: (a -> b) (f a) -> (f b) | gMap{|*->*|} f",
		TS "fmap f x y = gMap{|*->*|} f x y",
		[],
		TS "bmap :: (a1 -> b1) (a2 -> b2) (f a1 a2) -> (f b1 b2) | gMap{|*->*->*|} f",
		TS "bmap f1 f2 x y = gMap{|*->*->*|} f1 f2 x y"
	],PCH
		(TS ("Equality makes sense not only on for kind *. In the example we alter the standard way of "+++
			 "comparing elements. Equality for kind * and *->* are explicitly used."))
 		[
		[],
		TS "eqListFsts :: [(a, b)] [(a, c)] -> Bool | gEq{|*|} a",
		TS "eqListFsts xs ys = gEq{|*->*|} (\x y -> fst x === fst y) ys",
		[],
		TS "eqFsts :: (f (a, b)) (f (a, c)) -> Bool | gEq{|*->*|} f & gEq{|*|} a",
		TS "eqFsts xs ys     = gEq{|*->*|} (\x y -> fst x === fst y) ys"
	]
	];
	= make_page pdf_i pdf_shl;

page_7_7 :: !{!CharWidthAndKerns} -> Page;
page_7_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
	[PCH
		(TS "Examples of generic applications")
		(map comment_blue [
		[],
		TS "Start =",
		TS "    ( gEq{|*|} [1,2,3] [2,3,3]                          // True",
		TS "    , [1,2,3] === [1,2,3]                               // True",
		TS "    , gEq{|*->*|} (\\x y -> True) [1,2,3] [4,5,6]        // True",
		TS "    )"
	]),H2
		"7.5" "Using Constructor Information"
	,S(
		"As it was outlined above, the structural representation of types lacks information about specific constructors and record "+++
		"fields, such as name, arity etc. This is because this information is not really part of the structure of types: different types "+++
		"can have the same structure. However, some generic functions need this information. Consider, for example a generic "+++
		"toString function that converts a value of any type to a string. It needs to print constructor names. For that reason the "+++
		"structural representation of types is extended with special constructor and field markers that enable us to pass "+++
		"information about fields and constructors to a generic function."
	),PCH
		(TS "Definition of the constructor and field marker types (in StdGeneric.dcl).")
		[
		[],
		TS ":: CONS a        = CONS a",
		TS ":: FIELD a       = FIELD a"
	],S(
		"The markers themselves do not contain any information about constructors and fields. Instead, the information is passed "+++
		"to instances of a generic function on these markers."
	),PCH
		(TS "Examples of structural representation with constructor and field information")
		[
		[],
		TS ":: ListS a   :== EITHER (CONS UNIT) (CONS (PAIR a (List a)))",
		TS ":: TreeS a   :== EITHER (CONS a) (CONS (PAIR (Tree a) (Tree a)))",
		[],
		TS ":: Complex   = { re   :: Real, im   :: Real }",
		TS ":: ComplexS  :== PAIR (FIELD Real) (FIELD Real)"
	],ST [
 		[TS "GenericTypeArg",	TS_E,	TSBCr "CONS" TA " [" TABCr "of" TA " {Pattern}]"],
		[[],					TS_B,	TSBCr "FIELD" TA " ["  TABCr "of" TA " {Pattern}]"],
		[[],					TS_B,	TSC "TypeConstructorName"],
		[[],					TS_B,	TSC "TypeVariable"]
	],PCH
		(TS "Definition of the constructor and field descriptors (StdGeneric.dcl). Constructor descriptor is passed after "
		 TABCr "of" TA " in the CONS case of a generic function.")
		[
		[],
		TS ":: ConsDescriptor     =",
		TS "    { gcd_name        :: String",
		TS "    , gcd_arity       :: Int",
		TS "    }"
	],CPCH
		(TS "Field descriptor is passed after " TABCr "of" TA " in the FIELD case of a generic function.")
		[
		[],
		TS ":: FieldDescriptor    =",
		TS "  { gfd_name        :: String",
		TS "  }"
	]
	];
	= make_page pdf_i pdf_shl;

page_7_8 :: !{!CharWidthAndKerns} -> Page;
page_7_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Generic pretty printer.")
			[
			[],
			TS "generic gToString a ::        String    a            -> String",
			TS "gToString {|Int|}             sep       x            = toString x",
			TS "gToString {|UNIT|}            sep       x            = x",
			TS "gToString {|PAIR|} fx fy      sep       (PAIR x y)   = fx sep x +++ sep +++ fy sep y",
			TS "gToString {|EITHER|} fl fr    sep       (LEFT x)     = fl sep x",
			TS "gToString {|EITHER|} fl fr    sep       (RIGHT x)    = fr sep x",
			TS "gToString {|CONS of c|} fx    sep       (CONS x)",
			TS "    | c.gcd_arity == 0",
			TS "         = c.gcd_name",
			TS "    | isEmpty c.gcd_fields",
			TS "         = \"(\" +++ c.gcd_name +++ \" \" +++ fx \" \"  x +++ \")\"",
			TS "    | otherwise",
			TS "        = \"{\" +++ c.gcd_name +++ \" | \" +++ fx \", \" x +++ \"}\"",
			TS "gToString {|FIELD of f|} fx   sep       (FIELD x)    = f.gfd_name +++ \"=\" +++ fx x",
			[],
			TS "toStr :: a -> String | gToString{|*|} a",
			TS "toStr   x = gToString{|*|} \"\" x"
		],H2
			"7.6" "Generic Functions and Uniqueness Typing"
		,S(
			"Uniqueness is very important in Clean. The generic extension can deal with uniqueness. The mechanism that derives "+++
			"generic types for different kinds is extended to deal with uniqueness information. Roughly speaking it deals with "+++
			"uniqueness attribute variables in the same way as it does with normal generic variables."
		),PCH
			(TS "The type of standard mapping for lists with uniqueness")
			[
			[],
			TS "map :: (.a -> .b) ![.a] -> [.b]"
		],PCH
			(TS "Generic mapping with uniqueness.  The instance on lists has the same uniqueness typing as the standard map")
			(map color_keywords [
			[],
			TS "generic gMap a b :: .a -> .b"
		]),S(
			"Uniqueness information specified in the generic function is used in typing of generated code."
		),PCH
			(TS "Generated classes")
			[
			[],
			TS "class gMap{|*|} t             :: .t -> .t",
			TS "class gMap{|*->*|} t          :: (.a -> .b) (.t .a) -> .t .b",
			TS "class gMap{|*->*->*|} t       :: (.a1 -> .b1) (.a2 -> .b2) (.t .a1 .a2) -> .t .b1 .b2"
		],S(
			"Current limitations with uniqueness: generated types for higher order types require local "+++
			"uniqueness inequalities which are currently not supported."
		),PCH
			(TS "Counter Example due to limitation in the current version of Clean.")
			[
			[],
			TS "class gMap{|(*->*)->*|} t  ::",
			TS "    (A. (a:a) (b:b): (.a -> .b) -> (f:f a:a) -> g:g a:a, [f <= a, g <= b])",
			TS "    (.t .f) -> .t .g",
			TS "    , [f <= t, g <= t]"
		],H2
			"7.7" "Exporting Generic Functions"
		,P(
			TS ("Generic declarations and generic cases - both provided and derived - can be exported from a module. "+++
				"Exporting a generic function is done by giving the ")
			TAI "generic" TA " declaration in the DCL module. Exporting provided and derived generic cases is done by means of "
			TAI "derive" TA "."
		),ST [
			[TS "GenericExportDef",	TS_E,	TS "GenericDef " TABCb ";"],
			[[],					TS_B,	TS "DeriveDef " TABCb ";"]
		],ST [
			[TS "GenericDef",	TS_E,	TSBCr "generic" TA " " TAC "FunctionName" TA " " TAC "TypeVariable" TA "+ " TAT "::" TA " FunctionType"],
			[TS "DeriveDef",	TS_E,	TSBCr "derive" TA " " TAC "FunctionName" TA " " TAC "TypeConstructorName" TA "+"]
		]
		];
	= make_page pdf_i pdf_shl;

page_7_9 :: !{!CharWidthAndKerns} -> Page;
page_7_9 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example. Exporting of generic mapping. Definition as given in module GenMap.dcl")
			(map color_keywords [
			[],
			TS "generic gMap a b :: .a -> .b",
			TS "derive gMap c, PAIR, EITHER, CONS, FIELD, []"
		]),S(
			"A generic function cannot be derived for an abstract data type, but it can be derived in the module where the "+++
			"abstract type defined. Thus, when one may export derived instance along with the abstract data type."
		)];
	= make_page pdf_i pdf_shl;
