implementation module clean_manual_preface;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

pages_p :: [{!CharWidthAndKerns} -> Page];
pages_p = [page_p_1,page_p_2,page_p_3,page_p_4,page_p_5,page_p_6,page_p_7];

page_p_1 :: !{!CharWidthAndKerns} -> Page;
page_p_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C3S "Version 3.0" "Language Report" "Preface"
		,MP [
			[],
			TS ("CLEAN is a practical applicable general-purpose lazy pure functional programming language suited for the development "+++
				"of real world applications."),
			[],
			TS "CLEAN has many features among which some very special ones.",
			[],
			TS "Functional languages are usually implemented using graph-rewriting techniques. CLEAN has explicit graph rewriting "
			TAI "semantics" TA "; one can explicitly define the " TAI "sharing" TA " of " TAI "structures" TA " (" TAI "cyclic structures"
			TA (" as well) in the language (Barendregt et al., 1987; Sleep et al., 1993, Eekelen et al., 1997). This provides a better framework for controlling the time space behavior "+++
				"of functional programs."),
			[],
			TS ("Of particular importance for practical use is CLEAN's Uniqueness Type System (Barendsen and Smetsers, 1993a) "+++
				"enabling the incorporation of destructive updates of arbitrary objects within a pure functional framework and the creation of "+++
				"direct interfaces with the outside world."),
			[],
			TS ("CLEAN's \"unique\" features have made it possible to predefine (in CLEAN) a sophisticated and efficient I/O library (Achten "+++
				"and Plasmeijer, 1992 & 1995). The CLEAN Object I/O library enables a CLEAN programmer to ")
			TAI "specify interactive window based I/O applications"
			TA (" on a very high level of abstraction. One can define callback functions and I/O components with "+++
				"arbitrary local states thus providing an object-oriented style of programming (Achten, 1996; Achten and Plasmeijer, "+++
				"1997). The library forms a platform independent interface to window-based systems: one can port window based I/O ap-"+++
				"plications written in CLEAN to different platforms (we support Mac and PC) without modification of source code."),
			[],
			TS "Although CLEAN is " TAI "by default" TA " a " TAI "lazy language" TA " one can smoothly turn it into a "
			TAI "strict language" TA " to obtain optimal time/space behavior: " TAI "functions" TA " can be defined "
			TAI "lazy" TA " as well as " TAI "(partially) strict" TA " in their arguments; any (recursive) " TAI "data structure"
			TA " can be defined " TAI "lazy " TA "as well as " TAI "(partially) strict" TA " in any of its arguments.",
			[],
			TS ("The rich type system of CLEAN 1.3 (offering high-order types, polymorph types, type classes, uniqueness types, "+++
				"existentially quantified types, algebraic types, abstract types, synonym types, record types, arrays, lists) is extended with ")
			TAI "multi parameter type constructor classes" TA " and " TAI "universally quantified types"
			TA (" currently limited to rank 2, rank n is in preparation). Furthermore, arrays and lists are better integrated "+++
				"in the language. Strict, spine-strict, unboxed and overloaded lists are predefined in the language."),
			[],
			TS ("CLEAN now offers a hybrid type system with both static and dynamic typing. An object (expression) of static type can be "+++
				"changed into an object of dynamic type (a \"") TAC "Dynamic" TA "\") and backwards. One can read a "
			TAC "Dynamic" TA " written by another CLEAN program with one function call. A " TAC "Dynamic"
			TA (" can contain data as well as (unevaluated) functions. This means that one can very easy transfer data as well as "+++
				"code (!) from one CLEAN application to another in a ") TAI "type safe" TA " manner enabling "
			TAI "mobile code" TA " and " TAI "persistent storage"
			TA " of an expression. This technique involves just-in-time code generation, dynamic linking and dynamic type unification.",
			[],
			TS ("CLEAN offers support for generic programming using an extension of the class overloading mechanism. One can define "+++
				"functions like equality, ") TAC "map" TA ", " TAC "foldr"
			TA (" and the like in a generic way such that these functions are available for any (user defined) data structure. "+++
				"The generic functions are very flexible since they not only work on types of kind star but also on higher order kinds."),
			[],
			TS "CLEAN (Brus " TAI "et al." TA ", 1987; Nöcker " TAI "et al."
			TA (", 1991; Plasmeijer and Van Eekelen, 1993) is not only well known for its many features but also for its fast "+++
				"compiler producing very efficient code (Smetsers ") TAI "et al."
			TA (", 1991). The new CLEAN 2.0 compiler is written in CLEAN . The CLEAN compiler is one of the fastest in the world "+++
				"and it produces very good code. For example, the compiler can compile itself from scratch within a minute.")
		]
	];
	= make_page pdf_i pdf_shl;

page_p_2 :: !{!CharWidthAndKerns} -> Page;
page_p_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS ("The CLEAN 2.0 system includes lots of tools and libraries, all written in CLEAN of course. Included is an IDE (Integrated "+++
			"Development Environment), a dedicated text editor, a project manager, a code generator generating native code (the "+++
			"only piece of software written in C), a static linker, a dynamic linker, a proof system (Sparkle), a test system (GAST), a "+++
			"heap profiler, a time profiler, and lots of libraries."),
			[],
			TS ("People already familiar with other functional programming languages (such as Haskell; (Hudak et al., 1992), Gofer/Hugs "+++
			"(Jones, 1993), Miranda (Turner, 1985) and SML (Harper et al., 1986)) will have no difficulty to program in CLEAN. We "+++
			"hope that you will enjoy CLEAN's rich collection of features, CLEAN's compilation speed and the quality of the produced "+++
			"code (we generate native code for all platforms we support). CLEAN runs on a PC (Windows 2000, '98, '95, WindowsNT). "+++
			"There are also versions running on the Mac and Linux."),
			[],
			TS ("Research on CLEAN started in 1984 (the Dutch Parallel Machine Project) in which we had to good idea to focuss on "+++
			"compilation techniques for classical computer architectures. Many new concepts came out of the research of the CLEAN "+++
			"team (see below). These ideas are not only incorporated in our own system, many of them have also been adopted by "+++
			"other languages like Haskell and Mercury."),
			[]
		],H3T "More Information on Clean"
		,MP [
			[],
			TS "A tutorial teaching how to program in CLEAN can be found on our web pages.",
			TS "See " TAb "http://wiki.clean.cs.ru.nl/Functional_Programming_in_Clean" TA ".",
			[],
			TS "Information about the libraries (including the I/O library) that are available for CLEAN can also be found on the web, surf to ",
			TSb "http://wiki.clean.cs.ru.nl/Libraries" TA ".",
			[],
			TS ("There is a manual teaching the use of the Object I/O library. It includes many examples showing you how to write "+++
				"interactive window based programs."),
			TS "See " TAb "http://clean.cs.ru.nl/download/supported/ObjectIO.1.2/doc/tutorial.pdf" TA ".",
			[],
			TS ("The basic concepts behind CLEAN (albeit of one of the very first versions, namely CLEAN 0.8) as well as an explanation of "+++
				"the basic implementation techniques used can be found in Plasmeijer and Van Eekelen (Adisson-Wesley, 1993). "+++
				"The book is out of print, but copies can found on "),
			TSb "http://wiki.clean.cs.ru.nl/Functional_Programming_and_Parallel_Graph_Rewriting",
			[],
			TS "There are many papers on the concepts introduced by the CLEAN group (such as " TAI "term graph rewriting"
			TA " (Barendregt " TAI "et al" TA "., 1987), " TAI "lazy copying" TA " (van Eekelen " TAI "et al" TA "., 1991), "
			TAI "abstract reduction" TA " (Nöcker, 1993), " TAI "uniqueness typing" TA " (Barendsen and Smetsers, 1993, 1996), CLEAN's "
			TAI "I/O concept" TA " (Achten, 1996 & 1997), " TAI "Lazy Copying"
			TA (" for Concurrent CLEAN (Kesseler, 1991 & 1996), Type dependent Functions for Dynamics (Pil, 1999), I/O of Dynamics "+++
				"(Vervoort, 2001), a Typed Operating System (van Weelden, 2001). For the most recent information on papers (")
			TAb "http://wiki.clean.cs.ru.nl/Publications" TA ") and general information about CLEAN (" TAb "http://clean.cs.ru.nl"
			TA ") please check our web pages.",
			[]
		],H3T "About this Language Report"
		,MP [
			[],
			TS "In this report the syntax and semantics of CLEAN version 2.0 are explained. We always give a motivation " TAI "why"
			TA (" we have included a certain feature. Although the report is not intended as introduction into the language, we did "+++
				"our best to make it as readable as possible. Nevertheless, one sometimes has to work through several sections spread "+++
				"all over the report. We have included links where possible to support browsing through the manual."),
			[],
			TS ("At several places in this report context free syntax fragments of CLEAN are given. We sometimes repeat fragments that "+++
				"are also given elsewhere just to make the description clearer (e.g. in the uniqueness typing chapter we repeat parts of "+++
				"the syntax for the classical types). We hope that this is not confusing. The complete collection of context free grammar "+++
				"rules is summarized in Appendix A.")
		]
		];
	= make_page pdf_i pdf_shl;

page_p_3 :: !{!CharWidthAndKerns} -> Page;
page_p_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3T "Some Remarks on the Clean Syntax"
		,S ("The syntax of CLEAN is similar to the one used in most other modern functional languages. However, there are a couple "+++
			"of small syntactic differences we want to point out here for people who don?t like to read language reports.")
		,S ("In CLEAN the arity of a function is reflected in its type. When a function is defined its uncurried type is specified! To avoid "+++
			"any confusion we want to explicitly state here that in CLEAN there is no restriction whatsoever on the curried use of "+++
			"functions. However, we don't feel a need to express this in every type. Actually, the way we express types of functions "+++
			"more clearly reflects the way curried functions are internally treated.")
		,PCH
			(TS "E.g., the standard map function (arity 2) is specified in CLEAN as follows:")
			[
			[],
			TS "map::(a -> b) [a] -> [b]",
			TS "map f []   = []",
			TS "map f [x:xs]  = [f x:map f xs]"
		],P(
			TS "Each predefined structure such as a list, a tuple, a record or array has its own kind of brackets: lazy lists are always"
			TA "denotated with square brackets " TAC "[...]" TA ", strict lists are denotated by " TAC "[! ...]" TA ", spine strict lists by "
			TAC "[... !]" TA ", overloaded lists by " TAC " [|...]]" TAC " , unboxed lists by " TAC "[#…]"
			TA ". For tuples the usual parentheses are used " TAC "(...,...)"
			TA ", curly braces are used for records (indexed by field name) as well as for arrays (indexed by number)."
		),P(
			TS "In types funny symbols can appear like " TAC "." TA ", " TAC "u:" TA ", " TAC "*," TA " " TAC "!"
			TA " which can be ignored and left out if one is not interested in uniqueness typing or strictness."
		),P(
			TS "There are only a few keywords in CLEAN leading to a heavily overloaded use of " TAC ":" TA " and " TAC "=" TA " symbols:"
		),PC (map comment_blue [
			TS "function::argstype -> restype           // type specification of a function"
		]),PC (map comment_blue [
			TS "function pattern",
			TS "| guard = rhs                           // definition of a function"
		]),PC (map comment_blue [
			TS "selector = graph                        // definition of a constant/CAF/graph"
		]),PC (map comment_blue [
			TS "function args :== rhs                   // definition of a macro"
		]),PC (map comment_blue [
			TS "::Type args = typedef                   // an algebraic data type definition",
			TS "::Type args :== typedef                 // a type synonym definition",
			TS "::Type args                             // an abstract type definition"
		]),P(
			TS "As is common in modern functional languages, there is a layout rule in CLEAN (" TAL "see 2.3"
			TA "). For reasons of portability it is assumed that a tab space is set to 4 white spaces and that a non-proportional font is used."
		),PCH
			(TS "Function definition in CLEAN making use of the layout rule.")
			(map syntax_color [
			[],
			TS "primes:: [Int]",
			TS "primes = sieve [2..]",
			TS "where",
			TS "  sieve:: [Int] -> [Int]",
			TS "  sieve [pr:r]  = [pr:sieve (filter pr r)]",
			[],
			TS "  filter:: Int [Int] -> [Int]",
			TS "  filter pr [n:r]",
			TS "  | n mod pr == 0  = filter pr r",
			TS "  | otherwise    = [n:filter pr r]"
		])
		];
	= make_page pdf_i pdf_shl;

page_p_4 :: !{!CharWidthAndKerns} -> Page;
page_p_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H3T "Notational Conventions Used in this Report"
		,P(
			TS "The following " TAI "notational conventions" TA " are used in this report. Text is printed in Microsoft Sans Serif 9pts,"
		//CST
		),ST [
			[TS "the context free syntax descriptions are given in  Microsoft Sans Serif 9pts,"]
		],CPC [
			TS "examples of CLEAN programs are given in Courier New 9pts,"
		],N
		,SP(
			TS ("Semantic restrictions are always given in a bulleted list-of-points. When these restrictions are not obeyed they will "+++
				"almost always result in a compile-time error. In very few cases the restrictions can only be detected at run-time "+++
				"(array index out-of-range, partial function called outside the domain).")
		),
		P (
			TS "The following notational conventions are used in the context-free syntax descriptions:"
		),T [
			[TS "[notion]",				TS "means that the presence of notion is optional"],
			[TS "{notion}",				TS "means that notion can occur zero or more times"],
			[TS "{notion}+",			TS "means that notion occurs at least once"],
			[TS "{notion}-" TAI "list",	TS "means one or more occurrences of notion separated by commas"],
			[TST "terminals",			TS "are printed in " TAT "9 pts courier bold brown"],
			[TSBCr "keywords",			TS "are printed in " TABCr "9 pts courier bold red"],
			[TSBCb "terminals",			TS "that can be left out in layout mode are printed in " TABCb "9 pts courier bold blue"],
			[TS "~",					TS "is used for concatenation of notions"],
			[TS "{notion}/ str",		TS "means the longest expression not containing the string str"]
		],P (
			TS ("All CLEAN examples given in this report assume that the layout dependent mode has been chosen which means that "+++
				"redundant semi-colons and curly braces are left out (") TAL "see 2.3.3" TA ")."
		),N,
		H3T "How to Obtain Clean"
		,P (
			TS "CLEAN and the INTEGRATED DEVELOPMENT ENVIRONMENT (IDE) can be used free of charge. They can be obtained"
		),MBP [
			TS "via World Wide Web (" TAb "http://clean.cs.ru.nl" TA ") or ",
			TS "via ftp (" TAb "ftp://ftp.cs.ru.nl" TA " in directory " TAI "pub/Clean)"
		],N
		,H3T "Current State of the Clean System"
		,P(
			TST "Release 2.1 (November 2002)."
		),P(
			TS "Compared with the previous version the following changes have been made."
		),CMSP [
			TS "Experimental features of the previous version, such as dynamics (" TAL "see Chapter 8"
			TA "), generics (" TAL "see Chapter 7" TA ") and strict-lists (" TAL "see 4.2"
			TA ") have been improved and further incorporated in the language.",
			TS "Many bugs, most of which appeared in the new features, have been removed.",
			TS "The quality of the generated code has been improved."
		],P(
			TST "Release 2.0 (November 2001)."
		),P(
			TS "There are " TAI "many"
			TA " changes compared to the previous release (CLEAN 1.3.x). We have added many new features in CLEAN 2.0 we hope you will like."
		),CMSP [
			TS "CLEAN 2.0 has multi-parameter type constructor classes. " TAL "See Section 6.4" TA ".",
			TS "CLEAN 2.0 has universally quantified data types and functions (rank 2). See Section " TAL "3.7.4" TA " and " TAL "5.1.4" TA ".",
			TS "The explicit import mechanism has been refined. One can now more precisely address what to import and what not. " TAL "See 2.5.1" TA ".",
			TS ("Cyclic depedencies between definition modules are allowed. This makes it easier to define implementation "+++
				"modules that share definitions. ") TAL "See 2.5.1" TA ".",
			TS "Definitions in a definition module need not to be repeated in the corresponding implementation module anymore. "
			TAL "See 2.4" TA ".",
			TS "Due to multi-parameter type constructor classes a better incorporation of the type Array could be made. " TAL "See 4.4" TA ".",
			TS "CLEAN 2.0 offers an hybrid type system: one can have statically and dynamically typed objects ("++TSB "Dynamics"
			TA "). A statically typed expression can be changed into a dynamically typed one and backwards. The type of a " TAC "Dynamic"
			TA "can be inspected via a pattern match, one can ensure that " TAC "Dynamics"
			TA " fit together by using run-time type unification, one can store a " TAC "Dynamic"
			TA " into a file with one function call or read a " TAC "Dynamic" TA " stored by another CLEAN application. " TAC "Dynamics"
			TA (" can be used to store and retrieve information without the need for writing parsers, it can be used to "+++
				"exchange data and code (!) between applications in a type safe manner. ") TAC "Dynamics"
			TA ("make it easy to create mobile code, create plug-ins or create a persistent store. The CLEAN run-time system has been "+++
				"extended to support dynamic type checking, dynamic type unification, lazy dynamic linking and just-in-time code generation (")
			TAL "See Chapter 8" TA ")."
		]
		];
	= make_page pdf_i pdf_shl;

page_p_5 :: !{!CharWidthAndKerns} -> Page;
page_p_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MSP [
			TS ("There is special syntax and support for strict and unboxed lists. One can easily change from lazy to strict and "+++
				"backwards. Overloaded functions can be defined which work for any list (lazy, strict or unboxed). ") TAL "See 4.2"
			TA ". One can write functions like " TAC "==" TA ", " TAC "map" TA ", " TAC "foldr" TA " in a generic way. The "
			++TSC "generic functions"
			TA " one can define can work on higher order kinds. With kind indexed functions one can indicated which kind is actually meant ("
			TAL "see Chapter 7" TA "). A generic definition can be specialized for a certain concrete type.",
			TS ("The CLEAN system has been changed and extended: a new version of the CLEAN IDE, a new version of the run-time-system, "+++
				"and a dynamic linker is included. ") TAL "See 8.3" TA ".",
			TS "CLEAN 2.0 comes with an integrated proof system  (Sparkle), all written in CLEAN of course. See "
			TAb "http://www.cs.kun.nl/Sparkle" TA ".",
			TS "CLEAN 2.0 is open source. All source code will be made available on the net."
		],S "We have also removed things:"
		,MSP [
			TS ("We do not longer support annotations for concurrent evaluations ({P} and {I} annotations. However, we are working "+++
				"on a library that will support distributed evaluation of CLEAN expressions using Dynamics (see Van Weelden and "+++
				"Plasmeijer, 2002)."),
			TS "There is no strict let-before expression (" TAC "let!"
			TA ") anymore in CLEAN 2.x. You still can enforce strict evaluation using the strict hash let (" TAC "#!" TA ").",
			TS ("One cannot specify default instances anymore that could be used to disambiguate possible ambiguous internal "+++
				"overloading. Disambiguating can be done by explicitely specifying the required type.")
		],S "There is also some bad news:"
		,MSP [
			TS "Due to all these changes CLEAN 2.0 is " TAI "not"
			TA (" upwards compatible with CLEAN 1.3.x. Many things are the same but there are small differences as well. So, one has to "+++
				"put some effort in porting a CLEAN 1.3.x application to CLEAN 2.0. The most important syntactical differences are "+++
				"described below. Note that we do no longer support CLEAN 1.3."),
			TS ("The CLEAN 1.3 compiler is written in C. The CLEAN 2.0 compiler has been rewritten from scratch in CLEAN. The "+++
				"internal structure of the new compiler is a better than the old one, but the new compiler has become a bit slower "+++
				"than the previous C version as well. Large programs will take about 1.7 times as much time to compile (which is still "+++
				"pretty impressive for a lazy functional language).")
		],N,
		H3T "Syntactic differences between Clean 1.3 and Clean 2.0"
		,S ("CLEAN 2.x is not downward compatible with CLEAN 1.3.x. Probably you have to change your 1.3.x sources to get them "+++
			"through the CLEAN 2.x compiler.")
		,N
		,H3T "Differences in Expression Syntax"
		,P (
			TS "There is no " TAI "strict let" TA " expression (" TAC "let!"
			TA ") anymore in CLEAN 2.x. You still can enforce strict evaluation using the strict hash let (" TAC "#!" TA ")."
		),N
		,H3T "Differences in the Type System"
		,N
		,SP (
			TS "For " TAI "multiparameter type"
			TA (" classes a small change in the syntax for instance definitions was necessary. In CLEAN 1.3.x it was assumed that every "+++
				"instance definition only has one type argument. So in the following 1.3.x instance definition")
		),PC [
			TS "      instance c T1 T2"
		],N
		,PW "" indent_width (
			TS "the type " TAC "(T1 T2)" TA " was meant (the type " TAC "T1" TA " with the argument " TAC "T2"
			TA "). This should be written in CLEAN 2.x as"
		),PC [
			TS "      instance c (T1 T2)"
		],N
		,PW "" indent_width (
			TS "otherwise " TAC "T1" TA " and " TAC "T2" TA " will be interpreted as two types."		
		)
		];
	= make_page pdf_i pdf_shl;

page_p_6 :: !{!CharWidthAndKerns} -> Page;
page_p_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[SP (
			TS "The " TAI "type" TA " " TAC "Array" TA " has changed. In CLEAN 2.x the " TAC "Array"
			TA (" class has become a multiparameter class, whose first argument type is the array and whose second argument type "+++
				"is the array element (see ??). Therefore a 1.3 definition like")
		),PC [
			TS "      MkArray:: !Int (Int -> e) ->.(a e) | Array a & ArrayElem e",
			TS "      MkArray i f = {f j \\ j <- [0..i-1]}"
		],N
		,PW "" indent_width (
			TS "becomes in CLEAN 2.x:"
		),PC [
			TS "      MkArray:: !Int (Int -> e) ->.(a e) | Array a e",
			TS "      MkArray i f = {f j \\ j <- [0..i-1]}"
		],N,
		SP (
			TS "There is a difference in " TAI "resolving overloading" TA ". Consider the following code:"
		),PC [
			TS "      class c a :: a -> a",
			[],
			TS "      instance c [Int]",
			TS "         where",
			TS "           c [1] = [2]",
			[],
			TS "      f [x:xs]",
			TS "        = c xs"
		],N
		,PW "" indent_width (
			TS ("Although this is accepted by CLEAN 1.3.x, CLEAN 2.x will complain: \"Overloading error [...,..,f]: c no instance "+++
				"available of type [a].\" The CLEAN 2.x compiler applies no type unification after resolving overloading. So ")
			TAC "c" TA " is in function " TAC "f" TA " applied to a list with a polymorph element type (" TAC "[a]"
			TA "). And this is considered to be different from the instance type " TAC "[Int]"
			TA ". If you give f the type " TAC "[Int] -> [Int]" TA " the upper code will be accepted."
		),N
		,SP (
			TS "CLEAN 2.x handles " TAI "uniqueness attributes in type synonyms"
			TA " different than CLEAN 1.3.x. Consider the following definitions:"
		),PC [
			TS "      :: ListList a :== [[a]]",
			[],
			TS "      f :: *(ListList *{Int}) -> *{Int}",
			TS "      f [[a]] = { a & [0]=0 }"
		],N
		,PW "" indent_width (
			TS "In CLEAN 1.3.x the " TAC "ListList" TA " type synonym was expanded to"
		),PC [
			TS "      f :: *[*[*{Int}]] -> *{Int}"
		],N
		,PW "" indent_width (
			TS "which is correct in CLEAN 1.3.x. However, CLEAN 2.x expands it to"
		),PC [
			TS "      f :: *[[*{Int}]] -> *{Int}"
		],N
		,PW "" indent_width (
			TS ("This yields a uniqueness error in CLEAN 2.x because the inner list is shared but contains a unique object. This "+++
				"problem happens only with type synonyms that have attributes \"inbetween\". An \"inbetween\" attribute is neither the "+++
				"\"root\" attribute nor the attribute of an actual argument. E.g. with the upper type synonym, the formal argument \"")
			TAC "a" TA "\" is substituted with " TAC "*{Int}" TA ". Note that also the \"" TAC "*" TA "\" is substituted for \"" TAC "a"
			TA "\". Because we wrote " TAC "*(ListList ...)" TA " the root attribute is \"" TAC "*" TA "\". The result of expanding "
			TAC "*(ListList *{Int})" TA " is " TAC "*[u:[*{Int]]" TA ". \"" TAC "u"
			TA ("\" is an attribute \"inbetween\" because it is neither the root attribute nor the attribute of a formal argument. "+++
				"Such attributes are made _non_unique_ in CLEAN 2.x and this is why the upper code is not accepted. The code will be "+++
				"accepted if you redefine ") TAC "ListList" TA " to"
		),PC [
			TS "      :: ListList a :== [*[a]]"
		],N
		,SP (
			TSI "Anonymous uniqueness attributes in type contexts"
			TA " are not allowed in CLEAN 2.x. So in the following function type simply remove the point."
		),PC [
			TS "      f :: a | myClass .a"
		]
		];
	= make_page pdf_i pdf_shl;

page_p_7 :: !{!CharWidthAndKerns} -> Page;
page_p_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[SP (
			TS "The " TAC "String" TA " type has become a " TAI "predefined type"
			TA ". As a consequence you cannot import this type explicitly anymore. So:"
		),PC [
			TS "      from StdString import :: String"
		],N
		,PW "" indent_width (
			TS "is not valid."
		),N,
		SP (
			TS ("There was a bug in the uniqueness typing system of CLEAN 1.3: Records or data constructors could have "+++
				"existentially quantified variables, whose uniqueness attribute did _not_ propagate. This bug has been solved in "+++
				"CLEAN 2.x. As a consequence, the 2.x compiler might complain about your program where the 1.3.x compiler was "+++
				"happy. The problem might occur when you use the object I/O library and you use objects with a uniquely attributed "+++
				"local state. Now the object becomes unique as well and may not be shared anymore.")
		),N
		,H3T "Differences in the Module System"
		,N
		,SP (
			TS "The syntax and semantics of " TAI "explicit import statements"
			TA (" has been completely revised. With CLEAN 2.x it is possible to discriminate the different namespaces in "+++
				"import statements. In CLEAN 1.3.x the following statement")
		),PC (map syntax_color [
			TS "      from m import F"
		]),N
		,PW "" indent_width (
			TS "could have caused the import of a " TAI "function" TA " " TAC "F" TA " together with a " TAI "type" TA " " TAC "F"
			TA " and a " TAI "class" TA " " TAC "F"
			TA " with all its instances from m. In CLEAN 2.x one can precisely describe from which name space one wants to import ("
			TAL "see 2.5.2" TA "). For example, the following import statement"
		),PC (map syntax_color [
			TS "      from m import  F,",
			TS "                     :: T1, :: T2(..), :: T3(C1, C2), :: T4{..}, :: T5{field1, field2},",
			TS "                     class C1, class C2(..), class C3(mem1, mem2)"
		]),N
		,PW "" indent_width (
			TS "causes the following declarations to be imported: the " TAI "function" TA " or " TAI "macro" TA " " TAC "F"
			TA ", the " TAI "type" TA " " TAC "T1" TA ", the " TAI "algebraic type" TA " " TAC "T2" TA " with " TAI "all"
			TA " it's constructors that are exported by " TAC "m" TA ", the " TAI "algebraic type" TA " " TAC "T3"
			TA " with it's constructors " TAC "C1" TA " and " TAC "C2" TA ", the " TAI "record type" TA " " TAC "T4"
			TA " with " TAI "all" TA " it's fields that are exported by " TAC "m" TA ", the " TAI "record type" TA " "
			TAC "T5" TA " with it's fields " TAC "field1" TA " and " TAC "field2" TA ", the " TAI "class"
			TA " " TAC "C1" TA ", the" TAI "class" TA " " TAC "C2" TA " with all it's members that are exported by " TAC "m"
			TA ", the " TAI "class" TA " " TAC "C3" TA " with it's members " TAC "mem1" TA " and " TAC "mem2" TA "."
		),P (
			TST "Previous Releases."
			TA ("The first release of CLEAN was publicly available in 1987 and had version number 0.5 (we "+++
				"thought half of the work was done, ;-)). At that time, CLEAN was only thought as an intermediate language. Many "+++
				"releases followed. One of them was version 0.8 which is used in the Plasmeijer & Van Eekelen Bible (Adisson-Wesley, "+++
				"1993). Version 1.0 was the first mature version of CLEAN.")
		)
		];
	= make_page pdf_i pdf_shl;
