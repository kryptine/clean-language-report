implementation module clean_manual_uniqueness_typing;

import StdEnv,pdf_main,pdf_text,pdf_fonts,clean_manual_styles,clean_manual_text;

pages_9 :: [{!CharWidthAndKerns} -> Page];
pages_9 = [page_9_1,page_9_2,page_9_3,page_9_4,page_9_5,page_9_6,page_9_7,page_9_8,page_9_9,page_9_10,page_9_11,page_9_12,page_9_13];

page_9_1 :: !{!CharWidthAndKerns} -> Page;
page_9_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 9" "Uniqueness Typing"
		,MP [
			[],
			TS ("Although CLEAN is purely functional, operations with side-effects (I/O operations, for instance) are permitted. To achieve "+++
				"this without violating the semantics, the classical types are supplied with so called uniqueness attributes. If an argument "+++
				"of a function is indicated as unique, it is guaranteed that at run-time the corresponding actual object is local, i.e. there are "+++
				"no other references to it. Clearly, a destructive update of such a \"unique object\" can be performed safely."),
			[],
			TS ("The uniqueness type system makes it possible to define direct interfaces with an operating system, a file system "+++
				"(updating persistent data), with GUI's libraries, it allows to create arrays, records or user defined data structures that can "+++
				"be updated destructively. The time and space behavior of a functional program therefore greatly benefits from the "+++
				"uniqueness typing."),
			[],
			TS ("Uniqueness types are deduced automatically. Type attributes are polymorphic: attribute variables and inequalities on "+++
				"these variables can be used to indicate relations between and restrictions on the corresponding concrete attribute "+++
				"values."),
			[],
			TS ("Sometimes the inferred type attributes give some extra information on the run-time behavior of a function. The "+++
				"uniqueness type system is a transparent extension of classical typing that means that if one is not interested in the "+++
				"uniqueness information one can simply ignore it."),
			[],
			TS ("Since the uniqueness typing is a rather complex matter we explain this type system and the motivation behind it in more "+++
				"detail. The first ") TAL "Section (9.1)"
			TA " explains the basic motivation for and ideas behind uniqueness typing. " TAL "Section 9.2"
			TA (" focuses on the so-called uniqueness propagation property of (algebraic) type constructors. Then we show how new data "+++
				"structures can be defined containing unique objects (") TAL "Section 9.3)"
			TA ". Sharing may destroy locality properties of objects. In " TAL "Section 9.4"
			TA (" we describe the effect of sharing on uniqueness types. In order to maintain referential transparency, it "+++
				"appears that function types have to be treated specially. The last ") TAL "Section (9.5)"
			TA (" describes the combination of uniqueness "+++
				"typing and overloading. Especially, the subsections on constructor classes and higher-oder type definitions are very "+++
				"complex: we suggest that the reader skips these sections at first instance.")
		],H2
			"9.1" "Basic Ideas behind Uniqueness Typing"
		,P(
			TS "The " TAI "uniqueness typing" TA " is an extension of classical Milner/Mycroft typing. In the uniqueness type system "
			TAI "uniqueness type attributes" TA "  are attached to the classical types. Uniqueness type attributes appear in the "
			TAI "type specifications of functions" TA " " TAL "see 9.4" TA ") but are also permitted in the definitions of "
			TAI "new data types " TA "(" TAL "see 9.3"
			TA "). A classical type can be prefixed by one of the following uniqueness type attributes:"
		),ST2 [
			[TS "Type",				TS_E,	TS "{BrackType}+",							[]],
			[TS "BrackType",		TS_E,	TS "[Strict] [UnqTypeAttrib] SimpleType",	[]],
			[TS "UnqTypeAttrib",	TS_E,	TST "*",									TS "// type attribute \"unique\""],
			[[],					TS_B,	TS "UniqueTypeVariable" TAT ":",			TS "// a type attribute variable"],
			[[],					TS_B,	TST ".",									TS "// an anonymous type attribute variable"]
		]
		];
	= make_page pdf_i pdf_shl;

page_9_2 :: !{!CharWidthAndKerns} -> Page;
page_9_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "The basic idea behind uniqueness typing is the following. Suppose a function, say " TAC "F"
			TA ", has a unique argument (an argument with type " TAC ("*"+++sigma_string) TA ", for some " TAC sigma_string
			TA "). This attribute imposes an additional restriction on applications of " TAC "F" TA ".",
			[],
			TS "It is " TAI "guaranteed" TA " that " TAC "F"
			TA (" will have private (\"unique\") access to this particular argument (see Barendsen and Smetsers, "+++
				"1993; Plasmeijer and Van Eekelen, 1993): the object will have a reference count of 1 ") TAI "at the moment "
			TA ("it is inspected by the function. It is important to know that there can be more than 1 reference to the object "+++
				"before this specific access takes place. If a uniquely typed argument is not used to construct the function result "+++
				"it will become garbage (the reference has dropped to zero). Due to the fact that this analysis is performed statically "+++
				"the object can be garbage collected (") TAL "see Chapter 1"
			TA (") at compile-time. It is harmless to reuse the space occupied by the argument to create the function result. "+++
				"In other words: ")
			TAI "it is allowed to update the unique object destructively without any consequences for referential transparency" TA "."
		],PCH
			(TS "Example: the I/O library function " TAC "fwritec"
			 TA ("is used to write a character to a file yielding a new file as result. In general it is "+++
				  "semantically not allowed to overwrite the argument file with the given character to construct the resulting file. "+++
				  "However, by demanding the argument file to be unique by specifying "))
			[
			[],
			TS "fwritec:: Char *File -> *File"
		],P(
			TS "It is guaranteed by the type system that " TAC "fwritec"
			TA (" has private access to the file such that overwriting the file can be done without violating "+++
				"the functional semantics of the program. The resulting file is unique as well and can therefore "+++
				"be passed as continuation to another call of e.g. ")
			TAC "fwritec" TA " to make further writing possible."
		),PC [
			TS "WriteABC:: *File -> *File",
			TS "WriteABC file = fwritec 'c' (fwritec 'b' (fwritec 'a' file))"
		],S(
			"Observe that a unique file is passed in a single threaded way (as a kind of unique token) from one function to another "+++
			"where each function can safely modify the file knowing that is has private access to that file."
		),PCH
			(TS "One can make these intermediate files more vissible by by writing the " TAC "WriteABC" TA " as follows.")
			(map color_keywords [
			[],
			TS "WriteABC file = file3",
			TS "where",
			TS "    file1 = fwritec 'a' file",
			TS "    file2 = fwritec 'b' file1",
			TS "    file3 = fwritec 'c' file2",
			[]
		]),CPCH
			(TS "or, alternatively (to avoid the explicit numbering of the files),")
			[
			[],
			TS "WriteABC file",
			TS "    #   file = fwritec 'a' file",
			TS "        file = fwritec 'b' file",
			TS "    =   fwritec 'c' file"
		],P(
			TS ("The type system makes it possible to make no distinction between a CLEAN file and a physical file of the real world: file "+++
				"I/O can be treated as efficiently as in imperative languages. The uniqueness typing prevents writing while other "+++
				"readers/writers are active. E.g. one cannot apply ") TAC "fwritec" TA " to a file being used elsewhere."
		),PCH
			(TS "For instance, the following expression is " TAI "not" TA " approved by the type system:")
			[
			[],
			TS "(file, fwritec 'a' file)"
		],N
		,SP(
			TS ("Function arguments with no uniqueness attributes added to the classical type are considered as \"non-unique\": "+++
				"there are no reference requirements for these arguments. The function is only allowed to have ") TAI "read access"
			TA " (as usual in a functional language) even if in some of the function applications the actual argument appears to have reference count 1."
		)
		];

	/* to do:
		1
		Note that it is very natural in Clean to speak about references due to the underlying graph rewriting semantics of the 
		language: it is always clear when objects are being shared or when cyclic structures are being created.
	*/

	= make_page pdf_i pdf_shl;

page_9_3 :: !{!CharWidthAndKerns} -> Page;
page_9_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PC [
			TS "freadc:: File -> (Char, File)"
		],MP [
			[],
			TS "The function " TAC "freadc"
			TA (" can be applied to both a unique as well as non-unique file. This is fine since the function only "+++
				"wants read access on the file. The type indicates that the result is always a non-unique file. Such a file can be passed for "+++
				"further reading, but not for further writing."),
			[],
			TS "To indicate that functions don't change uniqueness properties of arguments, one can use " TAC "attribute variables" TA "."
		],PCH
			(TS "The simplest example is the identity functions that can be typed as follows:")
			[
			[],
			TS "id:: u:a -> u:a",
			TS "id x = x",
			[]
		],CPCH
			(TS "Here " TAC "a" TA " is an ordinary type variable, whereas " TAC "u" TA " is an attribute variable. If " TAC "id"
			 TA " is applied to an unique object the result is also unique (in that case " TAC "u"
			 TA " is instantiated with the concrete attribute " TAC "*"
			 TA ("). Of course, if id is applied to a non-unique object, the result remains non-unique. As with ordinary "+++
			  	  "type variables, attribute variables should be instantiated uniformly."))
			[
		],PCH
			(TS "A more interesting example is the function " TAC "freadc" TA " that is typed as")
			[
			[],
			TS "freadc:: u:File -> u:(Char, u:File)",
			[]
		],CPCH
			(TS "Again " TAC "freadc"
			 TA (" can be applied to both unique and non-unique files. In the first case the resulting file is also unique and "+++
				 "can, for example, be used for further reading or writing. Moreover, observe that not only the resulting file is attributed, but "+++
				 "also the tuple containing that file and the character that has been read. This is due to the so called ")
			 TAI "uniqueness propagation rule" TA "; see below.")
			[
		],S(
			"To summarize, uniqueness typing makes it possible to update objects destructively within a purely functional language. "+++
			"For the development of real world applications (which manipulate files, windows, arrays, databases, states etc.) this is an "+++
			"indispensable property."
		),H2
			"9.2" "Attribute Propagation"
		,MP [
			[],
			TS "Having explained the general ideas of uniqueness typing, we can now focus on some details of this typing system.",
			[],
			TS "If a unique object is stored in a data structure, the data structure itself becomes unique as well. This "
			TAI "uniqueness propagation rule"
			TA (" prevents that unique objects are shared indirectly via the data structure in which these objects are "+++
				"stored. To explain this form of hidden sharing, consider the following definition of the function head")
		],PC [
			TS "head:: [*a] -> *a",
			TS "head [hd:tl] = hd"
		]
		,P(
			TS "The pattern causes head to have access to the \deeper\" arguments " TAC "hd" TA " and " TAC "tl"
			TA (". Note that head does not have any uniqueness requirements on its direct list argument. This means that in an application of "+++
				"head the list might be shared, as can be seen in the following function heads")
		),PC [
			TS "heads list = (head list, head list)"
		],P(
			TS "If one wants to formulate uniqueness requirements on, for instance, the " TAC "hd" TA " argument of " TAC "head"
			TA ", it is " TAI "not" TA " sufficient to attribute the corresponding type variable " TAC "a" TA " with " TAC "*"
			TA "; the surrounding list itself should also become unique. One can easily see that, without this additional requirement the "
			TAC "heads" TA " example with type"
		),PC [
			TS "heads:: [*a] -> (*a,*a)",
			TS "heads list = (head list, head list)"
		],MP [
			[],
			TS "would still be valid although it delivers the same object twice. By demanding that the surrounding list becomes unique as well, (so the type of "
			TAC "head" TA " becomes " TAC "head:: *[*a] -> *a" TA ") the function " TAC "heads"
			TA " is rejected. In general one could say that uniqueness " TAI "propagates outwards" TA ".",
			[],
			TS "Some of the readers will have noticed that, by using attribute variables, one can assign a more general uniqueness type to head:"
		],PC [
			TS "head:: u:[u:a] -> u:a"
		]
		];
	= make_page pdf_i pdf_shl;

page_9_4 :: !{!CharWidthAndKerns} -> Page;
page_9_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "The above propagation rule imposes additional (implicit) restrictions on the attributes appearing in type specifications of functions.",
			[],
			TS "Another explicit way of indicating restrictions on attributes is by using "
			TAI "coercion statements" TA ". These statements consist of attribute variable inequalities of the form " TAC "u <= v"
			TA (". The idea is that attribute substitutions are only allowed if the resulting attribute inequalities are valid, i.e. "+++
				"not resulting in an equality of the form"),
			[],
			TS ("\'non-unique "+++lessequal_string+++" unique\'") TA ".",
			[],
			TS "The use of coercion statements is illustrated by the next example in which the uniqueness type of the well-known append function is shown."
		],PC [
			TS "append:: v:[u:a] w:[u:a] -> x:[u:a],    [v<=u, w<=u, x<=u,w<=x]"
		],MP [
			[],
			TS "The first three coercion statements express the uniqueness propagation for lists: if the elements " TAC "a"
			TA " are unique (by choosing " TAC "*" TA " for " TAC "u" TA ") these statements force " TAC "v" TA "," TAC "w" TA " and " TAC "x"
			TA " to be instantiated with " TAC "*" TA " also. (Note that " TAC "u <= *" TAC " iff " TAC "u = *"
			TA ".) The statement " TAC "w <= x" TA " expresses that the spine uniqueness of " TAC "append"
			TA "'s result depends only on the spine attribute " TAC "w" TA " of the second argument.",
			[],
			TS ("In CLEAN it is permitted to omit attribute variables and attribute inequalities that arise from propagation properties; these "+++
				"will be added automatically by the type system. As a consequence, the following type for ") TAC "append" TA " is also valid."
		],PC [
			TS "append:: [u:a] w:[u:a] -> x:[u:a],    [w<=x]"
		],P(
			TS ("Of course, it is always allowed to specify a more specific type (by instantiating type or attribute variables). All types given "+++
				"below are valid types for ") TAC "append" TA "."
		),PC [
			TS "append:: [u:a] x:[u:a] -> x:[u:a],",
			TS "append:: *[*Int] *[*Int] -> *[*Int],",
			TS "append:: [a] *[a] -> *[a]."
		],P(
			TS "To make types more readable, CLEAN offers the possibility to use " TAI "anonymous"
			TA (" attribute variables. These can be used as a shorthand for indicating attribute variables of which the actual names are "+++
				"not essential. This allows us to specify the type for ") TAC "append" TA " as follows."
		),PC [
			TS "append:: [.a] w:[.a] -> x:[.a],   [w<=x]"
		],S(
			"The type system of CLEAN will substitute real attribute variables for the anonymous ones. Each dot gives rise to a new "+++
			"attribute variable except for the dots attached to type variables: type variables are attributed uniformly in the sense that "+++
			"all occurrences of the same type variable will obtain the same attribute. In the above example this means that all dots are "+++
			"replaced by one and the same new attribute variable."
		),H2
			"9.3" "Defining New Types with Uniqueness Attributes"
		,let {
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
			 []]++dummy_columns
		],ST [
			[TS "TypeLhs",				TS_E,	TS "[" TAT "*" TA "]TypeConstructor {TypeVariable}"],
			[TS "TypeConstructor",		TS_E,	TSC "TypeName"]
		],ST [
			[TS "ExistQuantVariables",	TS_E,	TST "E." TA "{TypeVariable }+" TAT ":"],
			[TS "UnivQuantVariables",	TS_E,	TST "A." TA "{TypeVariable }+" TAT ":"] 
		],ST [
			[TS "BrackType",		TS_E,	TS "[Strict] [UnqTypeAttrib] SimpleType"],
			[TS "ArgType",			TS_E,	TS "BrackType"],
			[[],					TS_B,	TS "[Strict] [UnqTypeAttrib] " TAT "(" TA "UnivQuantVariables Type [ClassContext]" TAT ")"],
			[TS "UnqTypeAttrib",	TS_E,	TST "*"],
			[[],					TS_B,	TS "UniqueTypeVariable" TAT ":"],
			[[],					TS_B,	TST "."]
		]
		];
	= make_page pdf_i pdf_shl;

page_9_5 :: !{!CharWidthAndKerns} -> Page;
page_9_5 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "As can be inferred from the syntax, the attributes that are actually allowed in data type definitions are '" TAC "*" TA "' and '" TAC "."
			TA "'; attribute variables are not permitted. The (unique) " TAC "*"
			TA " attribute can be used at any subtype whereas the (anonymous). attribute is restricted to non-variable positions.",
			[],
			TS ("If no uniqueness attributes are specified, this does not mean that one can only build non-unique instances of such a data "+++
				"type. Attributes not explicitly specified by the programmer are added automatically by the type system. To explain this "+++
				"standard uniqueness attribution mechanism, first remember that the types of data constructors are not specified by the "+++
				"programmer but derived from their corresponding data type definition.")
		],PCH
			(TS "For example, the (classical) definition of the " TAC "List" TA " type")
			[
			[],
			TS ":: List a = Cons a (List a) | Nil",
			[]
		],CPCH
			(TS "leads to the following types for its data constructors:")
			[
			[],
			TS "Cons:: a (List a) -> List a",
			TS "Nil:: List a"
		],P(
			TS ("To be able to create unique instances of data types, the standard attribution of CLEAN will automatically derive appropriate "+++
				"uniqueness variants for the types of the corresponding data constructors. Such a uniqueness variant is "+++
				"obtained via a consistent attribution of all types and subtypes appearing in a data type definition. Here, consistency "+++
				"means that such an attribution obeys the following rules (assume that we have a type definition for some type ") TAC "T" TA ")."
		),MPW indent_width
		[("1)",(
			TS "Attributes that are explicitly specified are adopted."
		)),("2)",(
			TS "Each (unattributed) type variable and each occurrence of " TAC "T"
			TA " will receive an attribute variable. This is done in a uniform way: equal type variables will receive equal attributes, and all occurrence of "
			TAC "T" TA " are also equally attributed."
		)),("3)",(
			TS ("Attribute variables are added at non-variable positions if they are required by the propagation properties of the "+++
				"corresponding type constructor. The attribute variable that is chosen depends on the argument types of this "+++
				"constructor: the attribution scheme takes the attribute variable of first argument appearing on a propagating "+++
				"position (see example below).")
		)),("4)",(
			TS "All occurrences of the " TAC "." TA "attribute are replaced by the attribute variable assigned to the occurrences of " TAC "T" TA "."
		))],PCH
			(TS "Example of standard attribution for data constructors. For " TAC "Cons" TA " the standard attribution leads to the type")
			[
			[],
			TS "Cons:: u:a v:(List u:a) -> v:List u:a, [v<=u]",
			[]
		],CPCH
			(TS "The type of " TAC "Nil" TA " becomes")
			[
			[],
			TS "Nil:: v:List u:a, [v<=u]"
		],PCH
			(TS "Consider the following " TAC "Tree" TA " definition")
			[
			[],
			TS ":: Tree a  =  Node a [Tree a]",
			[]
		],CPCH
			(TS "The type of the data constructor " TAC "Node" TA " is")
			[
			[],
			TS "Node:: u:a v:[v:Tree u:a] -> v:Tree u:a, [v<=u]"
		],PCH
			(TS "Another " TAC "Tree" TA " variant.")
			[
			[],
			TS ":: *Tree *a  =  Node a *[Tree a]",
			[]
		],CPCH
			(TS "leading to")
			[
			[],
			TS "Node:: *a *[*Tree *a] -> *Tree *a",
			[]
		],CPCH
			(TS "Note that, due to propagation, all subtypes have become unique.")
			[
		],P(
			TS "Next, we will formalize the notion of uniqueness propagation. We say that an argument of a type constructor, say " TAC "T"
			TA ", is propagating if the corresponding type variable appears on a propagating position in one of the types used in the right-hand side of " TAC "T"
			TA ("'s definition. A propagating position is characterized by the fact that it is not surrounded by an arrow type "+++
				"or by a type constructor with non-propagating arguments. Observe that the definition of propagation is cyclic: a general "+++
				"way to solve this problem is via a fixed-point construction.")
		)
		];
	= make_page pdf_i pdf_shl;

page_9_6 :: !{!CharWidthAndKerns} -> Page;
page_9_6 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example of the propagation rule. Consider the (record) type definition for " TAC "Object" TA ".")
			[
			[],
			TS "Object a b::  {state:: a, fun:: b -> a}",
			[]
		],CPCH
			(TS "The argument " TAC "a" TA " is propagating. Since " TAC "b" 
			 TA " does not appear on a propagating position inside this definition, "
			 TAC "Object" TA " is not propagating in its second argument.")
			[
		],H2
			"9.4" "Uniqueness and Sharing"
		,P(
			TS "The type inference system of CLEAN will derive uniqueness information " TAI "after"
			TA " the classical Milner/Mycroft types of functions have been inferred ("
			TAL "see 4.3" TA "). As explained in " TAL "Section 9.1" TA ", a function may require a " 
			TAI "non-unique" TA " object, a " TAI "unique" TA " object or a " TAI "possibly unique"
			TA (" object. Uniqueness of the result of a function will depend on the attributes of its arguments "+++
				"and how the result is constructed. Until now, we distinguished objects with reference count 1 from objects with a larger "+++
				"reference count: only the former might be unique (depending on the uniqueness type of the object itself). In practice, "+++
				"however, one can be more liberal if one takes the evaluation order into account. The idea is that multiple reference to an "+++
				"(unique) object are harmless if one knows that only one of the references will be present at the moment it is accessed "+++
				"destructively. This has been used in the following function.")
		),PC (map color_keywords [
			TS "AppendAorB:: *File -> *File",
			TS "AppendAorB file",
			TS "|   fc == 'a' = fwritec 'a' file",
			TS "              = fwritec 'b' file",
			TS "where",
			TS "    (fc,nf)   = freadc file"
		]),MP [
			[],
			TS "When the right-hand side of " TAC "AppendAorB" TA " is evaluated, the guard is determined first (so access from " 
			TAC "freadc" TA " to " TAC "file"
			TA " is not unique), and subsequently one of the alternatives is chosen and evaluated. Depending on " TAC "cond"
			TA ", either the reference from the first " TAC "fwritec"
			TA " application to function file or that of the second application is left and therefore unique.",
			[],
			TS "For this reason, the uniqueness type system uses a kind of " TAI "sharing analysis"
			TA ".  This sharing analysis is input for the uniqueness type system itself to check uniqueness type consistency ("
			TAL "see 9.3" TA "). The analysis will label each " TAI "reference"
			TA " in the right-hand side of a function definition as " TAI "read-only"
			TA " (if destructive access might be dangerous) or " TAI "write-permitted"
			TA (" (otherwise). Objects  accessed via a read-only reference are always non-unique. On the other hand, "+++
				"uniqueness of objects accessed via a reference labeled with ") TAI "write-permitted"
			TA " solely depends on the types of the objects themselves.",
			[],
			TS ("Beforecg describing the labeling mechanism of CLEAN we mention that the \"lifetime\" of references is determined on a "+++
				"syntactical basis. For this reason we classify references to the same expression in a function definition (say for ") TAC "f" 
			TA ") according to their estimated run-time use, as " TAI "alternative" TA ", " TAI "observing" TA " and " TAI "parallel" TA "."
		],MBP [
			TS "Two references are " TAI "alternative" TA " if they belong to different alternatives of " TAC "f"
			TA ". Note that alternatives are distinguished by patterns (including " TAC "case" TA " expressions) or by guards.",
			TS "A reference " TAC "r" TA " is " TAI "observing" TA " w.r.t. a reference " TAC "r'"
		 	TA " if the expression containing " TAC "r'"
	 		TA " is either (1) guarded by an expression or (2) preceded by a strict let before expression containing " TAC "r" TA ".",
			TS "Otherwise, references are in " TAI "parallel" TA "."
		],S(
			"The rules used by the sharing analysis to label each reference are the following."
		),MBP [
			TS "A reference, say " TAC "r"
			TA ", to a certain object is labeled with read-only if there exist another reference, say " TAC "r'"
			TA ", to the same object such that either " TAC "r" TA " is observing w.r.t " TAC "r'" TA " or " TAC "r" TA " and " TAC "r'"
			TA "are in parallel.",
			TS "Multiple references to " TAI "cyclic structures" TA " are always labeled as read-only.",
			TS "All other references are labeled with write-permitted."
		],P(
			TS ("Unfortunately, there is still a subtlety that has to be dealt with. Observing references belonging in a strict context do not "+++
				"always vanish totally after the expression containing the reference has been evaluated: further analysis appears to be "+++
				"necessary to ensure their disappearance. More concretely, suppose ")
			TAC "e[r]" TA " denotes the expression containing " TAC "r" TA ". If the type of " TAC "e[r]"
			TA " is a basic type then, after evaluation, " TAC "e[r]"
			TA " will be reference-free. In particular, it does not contain the reference " TAC "r"
			TA " anymore. However, If the type of "	TAC "e[r]" TA " is not a basic type it is assumed that, after evaluation, " TAC "e[r]"
			TA " might still refer to r. But even in the latter case a further refinement is possible. The idea is, depending on " TAC "e[r]"
			TA ", to correct the type of the object to which "	TAC "r"
			TA " refers partially in such way that only the parts of this object that are still shared lose their uniqueness."
		)
		]; 
	= make_page pdf_i pdf_shl;

page_9_7 :: !{!CharWidthAndKerns} -> Page;
page_9_7 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Consider, for example, the following rule")
			[
			[],
			TS "f l =",
			TSBCr "#!" TA " x = hd (hd l)",
			TS "= (x, l)",
			[]
		],CPCH
			(TS "Clearly, x and l share a common substructure; " TAC "x" TA " is even part of " TAC "l"
			 TA ". But the whole \"spine\" of " TAC "l" TA " (of type " TAC "[[...]]"
			 TA ") does not contain any new external references. Thus, if " TAC "l"
			 TA " was spine-unique originally, it remains spine unique in the result of " TAC "f"
			 TA ". Apparently, the access to " TAC "l" TA " only affected part of " TAC "l"
			 TA "'s structure. More technically, the type of " TAC "l"
			 TA " itself is corrected to take the partial access on " TAC "l" TA " into account. In the previous example, " TAC "x"
			 TA ", regarded as a function on " TAC "l" TA " has type " TAC "[[a]] -> a" TA ". In " TAC "f"
			 TA "'s definition the part of " TAC "l"
			 TA "'s type corresponding to the variable a is made non-unique. This is clearly reflected in the derived type for "
			 TAC "f" TA ", being ")
			[
			[],
			TS "f:: u:[w:[a]] -> (a,v:[x:[a]]), [w <= x, u <= v]"
		],P(
			TS "In CLEAN this principle has been generalized: If the strict let expression " TAC "e[r]"
			TA " regarded as a function on r has type"
		),CPC [
			TS "T (... a...) -> a"
		],P(
			TS "Then the a-part of the type of the object to which r refers becomes non-unique; the rest of the type remains unaffected. If the type of "
			TAC "e[r]" TA " is not of the indicated form, " TAC "r"
			TA " is not considered as an observing reference (w.r.t. some reference " TAC "r'" TA "), but, instead, as in parallel with " TAC "r'" TA "."
		),H3
			"9.4.1" "Higher Order Uniqueness Typing"
		,P(
			TS "Higher-order functions give rise to partial (often called " TAI "curried"
			TA (") applications, i.e. applications in which the actual number of arguments is less than the arity of the corresponding symbol. "+++
				"If these partial applications contain unique sub-expressions one has to be careful.")
		),PCH
			(TS "Consider, for example the following the function " TAC "fwritec" TA " with type")
			[
			[],
			TS "fwritec:: *File Char -> *File",
			[]
		],CPCH
			(TS "in the application")
			[
			[],
			TS "fwritec unifile",
			[]
		],CPCH
			(TS "(assuming that unifile returns a unique file). Clearly, the type of this application is of the form "
			 TAC "o:(Char -> *File)" TA ". The question is: what kind of attribute is " TAC "o"
			 TA "? Is it a variable, is it " TA "*"
			 TA (", or, is it not unique? Before making a decision, one should notice that it is dangerous to allow the above "+++
			 	 "application to be shared. For example, if the expression ")
			 TAC "fwritec unifile" TA " is passed to a function")
			[
			[],
			TS "WriteAB write_fun = (write_fun 'a', write_fun 'b')"
		],P(
			TS "Then the argument of " TAC "fwritec"
			TA " is no longer unique at the moment one of the two write operations take place. Apparently, the "
			TAC "fwritec unifile" TA " expression is " TAI "essentially"
			TA (" unique: its reference count should never become greater than 1. To prevent such an essentially "+++
				"unique expression from being copied, CLEAN considers the ") TAC "->"
			TA " type constructor in combination with the " TAC "*"
			TA " attribute as special: it is not permitted to discard its uniqueness. Now, the question about the attribute "
			TAC "o" TA " can be answered: it is set to " TAC "*" TA ". If " TAC "WriteAB" TA " is typed as follows"
		),PC [
			TS "WriteAB:: (Char -> u:File) -> (u:File, u:File)",
			TS "WriteAB write_fun = (write_fun 'a', write_fun 'b')"
		],MP [
			[],
			TS "the expression " TAC "WriteAB (fwritec unifile)"
			TA " is rejected by the type system because it does not allow the argument of type " TAC "*(Char -> *File)"
			TA " to be coerced to " TAC "(Char -> u:File)"
			TA ". One can easily see that it is impossible to type " TAC "WriteAB"
			TA " in such a way that the expression becomes typable.",
			[],
			TS "To define data structures containing Curried applications it is often convenient to use the (anonymous) "
			TAC "." TA " attribute. Example"
		],CPC [
			TS ":: Object a b = { state:: a, fun::.(b -> a) }",
			TS "new:: * Object *File Char",
			TS "new = { state = unifile, fun = fwritec unifile }"
		],P(
			TS "By adding an attribute variable to the function type in the definition of " TAC "Object"
			TA ", it is possible to store unique functions in this data structure. This is shown by the function " TAC "new"
			TA " . Since " TAC "new"
			TA " contains an essentially unique expression it becomes essentially unique itself. So, " TAC "new"
			TA " can never lose its uniqueness, and hence, it can only be used in a context in which a unique object is demanded."
		)
		];
	= make_page pdf_i pdf_shl;

page_9_8 :: !{!CharWidthAndKerns} -> Page;
page_9_8 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[S(
			"Determining the type of a curried application of a function (or data constructor) is somewhat more involved if the type of "+++
			"that function contains attribute variables instead of concrete attributes. Mostly, these variables will result in additional "+++
			"coercion statements. as can be seen in the example below."
		),PC [
			TS "Prepend:: u:[.a] [.a] -> v:[.a],  [u<=v]",
			TS "Prepend a b = Append b a",
			[],
			TS "PrependList:: u:[.a] -> w:([.a] -> v:[.a]),    [u<=v, w<=u]",
			TS "PrependList a = Prepend a"
		],P(
			TS "Some explanation is in place. The expression " TAC "(PrependList some_list)"
			TA " yields a function that, when applied to another list, say " TAC "other_list"
			TA ", delivers a new list extended consisting of the concatenation of " TAC "other_list"
			TA " and " TAC "some_list" TA ". Let's call this final result new_list. If " TAC "new_list"
			TA " should be unique (i.e. v becomes " TAC "*"	TA ") then, because of the coercion statement "
			TAC "u<=v" TA " the attribute u also becomes " TAC "*" TA ". But, if " TAC "u = *" TA " then also "
			TAC "w = *" TA ", for, " TAC "w<=u" TA ". This implies that (arrow) type of the original expression "
			TAC "(PrependList some_list)" TA " becomes unique, and hence this expression cannot be shared."
		),H3
			"9.4.2" "Uniqueness Type Coercions"
		,MP [
			[],
			TS ("As said before, offering a unique object to a function that requires a non-unique argument is safe (unless we are dealing "+++
				"with unique arrow types; see above). The technical tool to express this is via a coercion (subtype) relation based on the "+++
				"ordering"),
			[],
			TS ("'unique' "+++lessequal_string+++" 'non-unique'"),
			[],
			TS ("on attributes. Roughly, the validity of "+++sigma_string+++" "+++lessequal_string+++" "+++sigma_string+++"' depends subtype-wise on the validity of ")
			TAC "u" TA (" "+++lessequal_string+++" ") TAC "u'" TA " with " TAC "u" TA "," TAC "u'"
			TA (" attributes in "+++sigma_string+++","+++sigma_string+++"`. One has, for example"),
			[],
			TSC "u:[v:[w:Int]]" TA (" "+++lessequal_string+++" ") TAC "u':[v':[w':Int]]" TA " iff " 
			TAC "u" TA (" "+++lessequal_string+++" ") TAC "u'" TA ", " TAC "v" TA (" "+++lessequal_string+++" ") TAC "v'" TA ", " TAC "w" TA (" "+++lessequal_string+++" ") TAC "w'" TA ".",
			[],
			TS ("However, a few refinements are necessary. Firstly, the uniqueness constraints expressed in terms of coercion "+++
				"statements (on attribute variables) have to be taken into account. Secondly, the coercion restriction on arrow types "+++
				"should be handled correctly. And thirdly, due to the so-called ")
			TAI "contravariance" TA " of " TAC "->" TA " in its first argument we have that",
			[],
			TSC "u" TA (":("+++sigma_string+++" ") TAC "->" TA (" "+++sigma_string+++"') "+++lessequal_string+++" ")
			TAC "u" TA (":("+++tau_string+++" ") TAC "->" TA (" "+++tau_string+++"') iff "+++tau_string+++" "+++
						lessequal_string+++" "+++sigma_string+++", "+++sigma_string+++"' "+++lessequal_string+++" "+++tau_string+++"'"),
			[],
			TS "Since " TAC "->"
			TA (" may appear in the definitions of algebraic type constructors, these constructors may inherit the co- and "+++
				"contravariant subtyping behavior with respect to their arguments. We can classify the 'sign' of the arguments of each "+++
				"type constructor as + (positive, covariant), - (negative, contravariant) or top (both positive and negative). In general this is "+++
				"done by analysing the (possible mutually recursive) algebraic type definitions by a fixed-point construction, with basis "+++
				"sign(") TAC "->" TA ") = (" TAC "-" TA "," TAC "+" TA ")."
		],PCH
			(TS "Example: " TAC "a" TA " has sign " TAC "T" TA ", " TAC "b" TA " has sign " TAC "+" TA " in")
			[
			[],
			TS "::FunList a b = FunCons (a, a -> b) (FunList a b)",
			TS "              | FunNil"
		],S(
			"This leads to the following coercion rules"
		),MPW indent_width
		[("5)",(
			TS "Attributes of two corresponding type variables as well as of two corresponding arrow types must be equal."
		)),("6)",(
			// to do: center
			TS ("The sign classification of each type constructor is obeyed. If, for instance, the sign of "+++Tau_string+++"'s argument "+++
				"is negative, then "+++Tau_string+++" "+++sigma_string+++" "+++lessequal_string+++" "+++Tau_string+++" "+++sigma_string+++"' iff "+++
				sigma_string+++"' "+++lessequal_string+++" "+++sigma_string)
		)),("7)",(
			TS "In all other cases, the validity of a coercion relation depends on the validity of "
			TAC "u" TA (" "+++lessequal_string+++" ") TAC "u'" TA ", where " TAC "u" TA "," TAC "u'" TA " are attributes of the two corresponding subtypes."
		))],P(
			TS ("The presence of sharing inherently causes a (possibly unique) object to become non-unique, if it is accessed via a read-"+++
				"only reference. In CLEAN this is achieved by a type correction operation that converts each unique type S to its smallest "+++
				"non-unique supertype, simply by making the outermost attribute of S non-unique. Note that this operation fails if S is a "+++
				"function type.")
		)
		];
	= make_page pdf_i pdf_shl;

page_9_9 :: !{!CharWidthAndKerns} -> Page;
page_9_9 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2	"9.5" "Combining Uniqueness Typing and Overloading"
		,MP [
			[],
			TS ("An overloaded function actually stands for a collection of real functions. The types of these real functions are obtained "+++
				"from the type of the overloaded function by substituting the corresponding instance type for the class variable. These "+++
				"instance types may contain uniqueness information, and, due to the propagation requirement, the above-mentioned "+++
				"substitution might give rise to uniqueness attributes overloaded type specification."),
			[],
			TS "Consider, for instance, the identity class"
		],PC (map color_keywords [
			TS "class id a:: a -> a"
		]),P(
			TS "If we want to define an instance of " TAC "id" TA " for lists, say " TAC "id L"
			TA ", which leaves uniqueness of the list elements intact, the (fully expanded) type of " TAC "idL" TA " becomes"
		),PC (map color_keywords [
			TS "instance id L v:[u:a] -> v:[u:a]"
		]),MP [
			[],
			TS ("However, as said before, the type specification of such an instance is not specified completely: it is derived from the "+++
				"overloaded type in combination with the instance type (i.e. ") TAC "[...]" TA " in this particular example).",
			[],
			TS ("In CLEAN we require that the type specification of an overloaded operator anticipates on attributes arising from "+++
				"uniqueness propagation, that is, the uniqueness attribute of the class variable should be chosen in such a way that for "+++
				"any instance type this 'class attribute' does not conflict with the corresponding uniqueness attribute(s) in the fully "+++
					"expanded type of this instance. In the above example this means that the type of ") TAC "id" TA " becomes"
		],PC (map color_keywords [
			TS "class id a:: a -> a"
		]),S(
			"Another possibility is"
		),PC (map color_keywords [
			TS "class id a:: *a -> *a"
		]),P(
			TS "However, the latter version of " TAC "id"
			TA " will be more restrictive in its use, since it will always require that its argument is unique."
		),H3
			"9.5.1" "Constructor Classes"
		,S(
			"The combination of uniqueness typing and constructor classes (with their higher-order class variables) introduces "+++
			"another difficulty. Consider, for example, the overloaded map function."
		),PC (map color_keywords [
			TS "class map m:: (a -> b) (m a) -> m b"
		]),P(
			TS "Suppose we would add (distinct) attribute variables to the type variables " TAC "a" TA " and " TAC "b"
			TA " (to allow 'unique instances' of map)"
		),PC (map color_keywords [
			TS "class map m:: (.a ->.b) (m .a) -> m .b"
		]),P(
			TS "The question that arises is: Which attributes should be added to the two applications of the class variable "
			TAC "m" TA "? Clearly, this depends on the actual instance type filled in for " TAC "m"
			TA ". E.g., if " TAC "m" TA " is instantiated with a propagating type constructor (like " TAC "[]"
			TA "), the attributes of the applications of " TAC "m"
			TA " are either attribute variables or the concrete attribute 'unique'. Otherwise, one can choose anything."
		)
		];
	= make_page pdf_i pdf_shl;

page_9_10 :: !{!CharWidthAndKerns} -> Page;
page_9_10 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[PCH
			(TS "Example")
			(map color_keywords [
			[],
			TS "instance map []",
			TS "where",
			TS "    map f l = [ f x // x <- l ]",
			[],
			TS "::  T a = C (Int -> a)",
			[],
			TS "instance map T",
			TS "where",
			TS "    map f (C g) = C (f o g)",
			[]
		]),CPCH
			(TS "In this example, the respective expanded types of the instances are")
			[
			[],
			TS "map:: (u:a -> v:b) w:[u:a] -> x:[v:b], w <= u, x <= v",
			TS "map:: (u:a -> v:b) (T u:a) -> T v:b"
		],P(
			TS ("The type system of CLEAN requires that a possible propagation attribute is explicitly indicated in the type specification of "+++
				"the overloaded function. In order to obtain versions of ") TAC "map"
			TA " producing spine unique data structures, its overloaded type should be specified as follows:"
		),PC (map color_keywords [
			TS "class map m:: (.a ->.b).(m. a) ->.(m. b)"
		]),S(
			"This type will provide that for an application like"
		),PC [
			TS "map inc [1,2,3]"
		],MP [
			[],
			TS "indeed yields a spine unique list.",
			[],
			TS ("Observe that if you would omit the (anonymous) attribute variable of the second argument, the input data structure "+++
				"cannot contain unique data on propagating positions, e.g. one could not use such a version of ") TAC "map"
			TA " for mapping a destructive write operator on a list of unique files.",
			[],
			TS ("In fact, the propagation rule is used to translate uniqueness properties of objects into uniqueness properties of the data "+++
				"structures in which these objects are stored. As said before, in some cases the actual data structures are unknown."),
			[],
			TS "Consider the following function"
		],PC [
			TS "DoubleMap f l = (map f l, map f l)"
		],S(
			"The type of this function is something like"
		),MP [
			[],
			TS "Clearly, " TAC "l"
			TA " is duplicated. However, this does not necessarily mean that a cannot be unique anymore. If, for instance, " TAC "m"
			TA (" is instantiated with a non-propagating type constructor (like "+++Tau_string+++" as defined on the previous page) then "+++
				"uniqueness of a is still permitted. On the other hand, if ") TAC "m"
			TA (" is instantiated with a propagating type constructor, a unique instantiation of a should "+++
				"be disapproved. In CLEAN, the type system 'remembers' sharing of objects (like ") TAC "l"
			TA " in the above example) by making the corresponding type attribute non-unique. Thus, the given type for " TAC "DoubleMap"
			TA (" is exactly the type inferred by CLEAN?s type system. If one tries to instantiate ") TAC "m"
			TA " with a propagating type constructor, and, at the same type, a with some unique type, this will fail.",
			[],
			TS ("The presence of higher-order class variables, not only influences propagation properties of types, but also the coercion "+++
				"relation between types. These type coercions depend on the sign classification of type constructors. The problem with "+++
				"higher-order polymorphism is that in some cases the actual type constructors substituted for the higher order type "+++
				"variables are unknown, and therefore one cannot decide whether coercions in which higher-order type variable are "+++
				"involved, are valid."),
			[],
			TS "Consider the functions"
		],PC [
			TS "double x = (x,x)",
			TS "dm f l = double (map f l)"
		]
		];
	= make_page pdf_i pdf_shl;

page_9_11 :: !{!CharWidthAndKerns} -> Page;
page_9_11 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS "Here, " TAC "map" TA "'s result (of type " TAC ".(m .a)" TA ") is coerced to the non-unique supertype " TAC "(m .a)"
			TA ". However, this is only allowed if " TAC "m"
			TA " is instantiated with type constructors that have no coercion restrictions. E.g., if one tries to substitute "
			TAC "*WriteFun" TA " for " TAC "m" TA ", where"
		),PC [
			TS "WriteFun a = C.(a -> *File)"
		],MP [
			[],
			TS "this should fail, for, " TAC "*WriteFun" TA " is " TAI "essentially"
			TA (" unique. The to solve this problem is to restrict coercion properties of type variable applications (m "+++sigma_string+++") to"),
			[],
			TSC "u:" TA "(" TAC "m" TA (" "+++sigma_string+++") = ") TAC "u:" TA "(" TAC "m"
			TA (" "+++tau_string+++") iff "+++sigma_string+++" "+++lessequal_string+++" "+++tau_string+++" && "+++tau_string+++" "+++lessequal_string+++" "+++sigma_string+++""),
			[],
			TS ("A slightly modified version of this solution has been adopted in CLEAN. For convenience, we have added the following "+++
				"refinement. The instances of type constructors classes are restricted to type constructors with no coercion restrictions. "+++
				"Moreover, it is assumed that these type constructors are uniqueness propagating. This means that the ") TAC "WriteFun"
			TA " cannot be used as an instance for " TAC "map"
			TA ". Consequently, our coercion relation we can be more liberal if it involves such class variable applications.",
			[],
			TS "Overruling this requirement can be done adding the anonymous attribute. the class variable. E.g."
		],PC (map color_keywords [
			TS "class map.m:: (.a ->.b).(m. a) ->.(m. b)"
		]),S(
			"Now"
		),PC (map color_keywords [
			TS "instance map WriteFun ",
			TS "where",
			TS "    map..."
		]),MP [
			[],
			TS "is valid, but the coercions in which (parts of) " TAC "map"
			TA ("'s type are involved are now restricted as explained above. To see the difference between the "+++
				"two indicated variants of constructor variables, we slightly modify map?s type."),
			[],
			TS "To see the difference between the two indicated variants of constructor variables, we slightly modify " TAC "map" TA "'s type."
		],PC (map color_keywords [
			TS "class map m:: (.a ->.b) *(m. a) ->.(m. b)"
		]),P(
			TS "Without overruling the instance requirement for " TAC "m" TA " the type of " TAC "dm" TA " (" TAC "dm"
			TA " as given on the previous page) becomes."
		),PC [
			TS "dm:: (.a ->.b) *(m.a) ->.(m b, m b)"
		],MP [
			[],
			TS "Observe that the attribute of disappeared due to the fact that each type constructor substituted for " TAC "m"
			TA " is assumed to be propagating.",
			[],
			TS "If one explicitly indicates that there are no instance restriction for the class variable " TAC "m"
			TA " (by attributing " TAC "m" TA " with.), the function " TAC "dm" TA " becomes untypable."
		],H2
			"9.6" "Higher-Order Type Definitions"
		,MP [
			[],
			TS ("We will describe the effect of uniqueness typing on type definitions containing higher-order type variables. At it turns out, "+++
				"this combination introduces a number of difficulties which would make a full description very complex. But even after "+++
				"skipping a lot of details we have to warn the reader that some of the remaining parts are still hard to understand."),
			[],
			TS ("As mentioned earlier, two properties of newly defined type constructor concerning uniqueness typing are important, "+++
				"namely, propagation and sign classification. One can probably image that, when dealing with higher-order types the "+++
				"determination on these properties becomes more involved. Consider, for example, the following type definition.")
		],PC [
			TS "::  T m a = C (m a)"
		],P(
			TS "The question whether " TAC "T"
			TA (" is propagating in its second argument cannot be decided by examining this definition only; it "+++
				"depends on the actual instantiation of the (higher-order) type variable ") TAC "m" TA ". If " TAC "m"
			TA " is instantiated with a propagating type constructor, like " TAC "[]" TA ", then " TAC "T"
			TA (" becomes propagating in its second argument as well. Actually, propagation is not only a "+++
				"property of type constructors, but also of types themselves, particularly of 'partial types' "+++
				"For example, the partial type ") TA "[]"
			TA (" is propagating in its (only) argument (Note that the number of arguments a partial type expects, "+++
				"directly follows from the kinds of the type constructors that have been used). The type ")
			TAC "T []" TA " is also propagating in its argument, so is the type " TAC "T ((,) Int)" TA ")."
		)
		];
	= make_page pdf_i pdf_shl;

page_9_12 :: !{!CharWidthAndKerns} -> Page;
page_9_12 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[P(
			TS ("The analysis in CLEAN that determines propagation properties of (partial) types has been split into two phases. During the "+++
				"first phase, new type definitions are examined in order to determine the propagation dependencies between the "+++
				"arguments of each new type constructor. To explain the idea, we return to our previous example.")
		),PC [
			TS "::  T m a = C (m a)"
		],P(
			TS "First observe that the propagation of the type variable " TAC "m" TA " is not interesting because "
			TAC "m" TA " does not stand for 'real data' (which is always of kind " TAC "*" TA "). We associate the propagation of "
			TAC "m" TA " in " TAC "T" TA " with the position(s) of the occurrence(s) of " TAC "m"
			TA "'s applications. So in general, " TAC "T" TA " is propagating in a higher-order variable " TAC "m" TA " if one of " TAC "m"
			TA ("'s applications appears on a propagating position in the definition of T. Moreover, for each higher order type variable, "+++
				"we determine the propagation properties of all first order type variables in the following way: ")
			TAC "m" TA " is propagating in " TAC "a" TA ", where " TAC "m" TA " and " TAC "a"
			TA " are higher-order respectively first-order type variables of " TAC "T" TA ", if " TAC "a"
			TA " appears on a propagating position in one of " TAC "m"	TA "'s applications. In the above example, "TAC "m"
			TA " is propagating in " TAC "a" TA ", since " TAC "a" TA " is on a propagating position in the application " TAC "(m" TA " " TAC "a)"
			TA (". During the second phase, the propagation properties of (partial) types are determined using the results of the first phase. "+++
				"This (roughly) proceeds as follows. Consider the type ") TAC "T"
			TA (" "+++sigma_string+++" for some (partial) type "+++sigma_string+++", and ") TAC "T"
			TA (" as defined earlier. First, determine (recursively) the propagation of "+++sigma_string+++". Then the type ")
			TAC "T"
			TA (" "+++sigma_string+++" is propagating if (1) "+++sigma_string+++" is propagating, (2) ") TAC "T" TA " is propagating in " TAC "m"
			TA ", and moreover (3) " TAC "m" TA " is propagating in " TAC "a" TA " (the second argument of the type constructor). With "
			TAC "T" TA " as defined above, (2) and (3) are fulfilled. Thus, for example " TAC "T" TA " " TAC "[]"
			TA " is propagating and therefore also " TAC "T" TA " " TAC "(T" TA " " TAC "[])" TA ". Now define"
		),PC [
			TS "::  T2 a = C2 (a -> Int)"
		],MP [
			[],
			TS "Then " TAC "T" TA " " TAC "T2" TA " is not propagating.",
			[],
			TS "The adjusted uniqueness propagation rule (see also...) becomes:",
			[]
		],BP (
			TS ("Let "+++sigma_string+++","+++tau_string+++" be two uniqueness types. Suppose "+++sigma_string+++" has attribute ") TAC "u"
			TA (". Then, if "+++tau_string+++" is propagating the application ("+++tau_string+++" "+++sigma_string+++") should have an attribute ") TAC "v"
			TA " such that " TAC "v" TA (" "+++lessequal_string+++" ") TAC "u" TA "."
		),MP [
			[],
			TS ("Some of the readers might have inferred that this propagation rule is a 'higher-order' generalization of the old 'first-order' "+++
				"propagation rule."),
			[],
			TS ("As to the sign classification, we restrict ourselves to the remark that that sign analysis used in CLEAN is adjusted in a "+++
				"similar way as described above for the propagation case."),
			[],
			TS "Example"
		],PC [
			TS "::  T m a = C ((m a) -> Int)"
		],MP [
			[],
			TS "The sign classification of " TAC "T" TA " if (-," TAC perpendicular_string TA "). Here " TAC perpendicular_string
			TA " denotes the fact the " TAC "a"
			TA " is neither directly used on a positive nor on a negative position. The sign classification of m w.r.t. " TAC "a"
			TA " is +. The partial type " TAC "T" TA " " TAC "[]" TA " has sign -, which e.g. implies that",
			TSC ("T [] Int "+++lessequal_string+++" T [] *Int"),
			[],
			TS "The type " TAC "T T2" TA " (with " TAC "T2" TA " as defined on the previous page) has sign +, so",
			TSC ("T T2 Int "+++greaterequal_string+++" T T2 *Int"),
			[],
			TS ("It will be clear that combining uniqueness typing with higher-order types is far from trivial: the description given above is "+++
				"complex and moreover incomplete. However explaining all the details of this combination is far beyond the scope of the "+++
				"reference manual."),
			[]
		]
		];
	= make_page pdf_i pdf_shl;

page_9_13 :: !{!CharWidthAndKerns} -> Page;
page_9_13 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[H2
			"9.7" "Destructive Updates using Uniqueness Typing"
		,MP [
			[],
			TS "So, it is " TAI "allowed" TA " to update a uniquely typed function argument (" TAC "*"
			TA (") destructively when the argument does not reappear in the function result. The question is: "+++
				"when does the compiler indeed make use of this possibility."),
			[],
			TS ("Destructive updates takes place in some predefined functions and operators which work on predefined data structures "+++
				"such arrays (&-operator) and files (writing to a file). Arrays and files are intended to be updated destructively and their "+++
				"use can have a big influence on the space and time behavior of your application (a new node does not have to be claimed "+++
				"and filled, the garbage collector is invoked less often and the locality of memory references is increased)."),
			[],
			TS "Performing destructive updates is only sensible when information is stored in nodes. Arguments of basic type ("
			TAC "Int" TA ", " TAC "Real" TA ", " TAC "Char" TA " or " TAC "Bool"
			TA ") are stored on the B-stack or in registers and it therefore does not make sense to make them unique.",
			[],
			TS ("The CLEAN compiler also has an option to re-use user-defined unique data structures: the space being occupied by a "+++
				"function argument of unique type will under certain conditions be reused destructively to construct the function result "+++
				"when (part of) this result is of the same type. So, a more space and time efficient program can be obtained by turning "+++
				"heavily used data structures into unique data structures. This is not just a matter of changing the uniqueness type "+++
				"attributes (like turning a lazy data structure into a strict one). A unique data structure also has to be used in a 'single "+++
				"threaded' way (see Chapter 4). This means that one might have to restructure parts of the program to maintain the "+++
				"unicity of objects."),
			[],
			TS ("The compiler will do compile-time garbage collection for user defined unique data-structures only in certain cases. In that "+++
				"case run-time garbage collection time is reduced. It might even drop to zero. It is also possible that you gain even more "+++
				"than just garbage collection time due to better cache behavior.")
		]
		];
	= make_page pdf_i pdf_shl;
