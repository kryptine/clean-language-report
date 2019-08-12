implementation module clean_manual_semantics;

import StdEnv,pdf_main,pdf_text,pdf_graphics,clean_manual_styles,clean_manual_text,clean_manual_graphics;

courier_char_width = toReal font_size*0.6;

pages_1 :: [{!CharWidthAndKerns} -> Page];
pages_1 = [page_1_1,page_1_2,page_1_3,page_1_4];

page_1_1 :: !{!CharWidthAndKerns} -> Page;
page_1_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 1" "Basic Semantics"
		,P(
			TS "The semantics of CLEAN is based on " TAI "Term Graph Rewriting Systems"
			TA " (Barendregt, 1987; Plasmeijer and Van Eekelen, 1993). This means that functions in a CLEAN program semantically work on "
			TAI "graphs" TA " instead of the usual " TAI "terms"
			TA (". This enabled us to incorporate CLEAN's "+++
				"typical features (definition of cyclic data structures, lazy copying, uniqueness typing) which would "+++
				"otherwise be very difficult to give a proper semantics for. However, in many cases the programmer does not "+++
				"need to be aware of the fact that he/she is manipulating graphs. Evaluation of a CLEAN program takes place in the same "+++
				"way as in other lazy functional languages. One of the \"differences\" between CLEAN and other functional languages "+++
				"is that when a variable occurs more than once in a function body, the semantics ") TAI "prescribe"
			TA (" that the actual argument is shared (the semantics of most other languages do not prescribe this "+++
				"although it is common practice in any implementation of a functional language). Furthermore, one can label "+++
				"any expression to make the definition of cyclic structures possible. So, people familiar with other "+++
				"functional languages will have no problems writing CLEAN programs.")
		),S(
			"When larger applications are being written, or, when CLEAN is interfaced with the non-functional world, or, when efficiency "+++
			"counts, or, when one simply wants to have a good understanding of the language it is good to have some knowledge of "+++
			"the basic semantics of CLEAN which is based on term graph rewriting. In this chapter a short introduction into the basic "+++
			"semantics of CLEAN is given. An extensive treatment of the underlying semantics and the implementation techniques of "+++
			"CLEAN can be found in Plasmeijer and Van Eekelen (1993)."
		),H2
			"1.1" "Graph Rewriting"
		,MP [
			[],
			TS "A CLEAN " TAI "program" TA " basically consists of a number of " TAI "graph rewrite rules"
			TA " (" TAI "function definitions" TA ") which specify how a given " TAI "graph"
			TA " (the " TAI "initial expression" TA ") has to be " TAI "rewritten" TA ".",
			[],
			TS "A " TAI "graph" TA " is a set of nodes. Each node has a defining " TAI "node-identifier"
			TA " (the " TAI "node-id" TA "). A " TAI "node" TA " consists of a " TAI "symbol"
			TA " and a (possibly empty) sequence of " TAI "applied node-id's" TA " (the " TAI "arguments"
			TA " of the symbol) " TAI "Applied node-id's" TA " can be seen as " TAI "references" TA " ("
			TAI "arcs" TA ") to nodes in the graph, as such they have a " TAI "direction"
			TA ": from the node in which the node-id is applied to the node of which the node-id is the defining identifier.",
			[],
			TS "Each " TAI "graph rewrite rule" TA " consists of a " TAI "left-hand side graph"
			TA " (the " TAI "pattern" TA ") and a " TAI "right-hand side" TA " (rhs) consisting of a "
			TA "graph" TAI " " TA "(the " TAI "contractum" TA ") or just a " TAI "single" TA " node-id (a " TAI "redirection"
			TA ("). In CLEAN rewrite rules are not comparing: the left-hand side (lhs) "+++
				"graph of a rule is a tree, i.e. each node identifier is applied only once, so there exists "+++
				"exactly one path from the root to a node of this graph."),
			[],
			TS "A rewrite rule defines a (" TAI "partial" TA ") " TAI "function" TA "." TA " The " TAI "function symbol"
			TA " is the root symbol of the left-hand side graph of the rule alternatives. All other symbols that appear in rewrite rules, are "
			TAI "constructor symbols" TA ".",
			[],
			TS "The " TAI "program graph"
			TA (" is the graph that is rewritten according to the rules. Initially, this program graph is fixed: it consists of "+++
				"a single node containing the symbol Start, so there is no need to specify this graph in the program explicitly. The part "+++
				"of the graph that matches the pattern of a certain rewrite rule is called a ")
			TAI "redex" TA " (" TAI "reducible expression" TA "). A " TAI "rewrite of a redex" TA " to its " TAI "reduct"
			TA (" can take place according to the right-hand side of the corresponding rewrite rule. If the right-hand side "+++
				"is a contractum then the rewrite consists of building this contractum and doing a redirection of the root of the redex to "+++
				"root of the right-hand side. Otherwise, only a redirection of the root of the redex to the single node-id specified on the "+++
				"right-hand side is performed. A ")
			TAI "redirection"
			TA (" of a node-id n1 to a node-id n2 means that all applied occurrences of n1 are "+++
				"replaced by occurrences of n2 (which is in reality commonly implemented by ")
			TAI "overwriting" TA " n1 with n2)."
			]
		];
	= make_page pdf_i pdf_shl;

page_1_2 :: !{!CharWidthAndKerns} -> Page;
page_1_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS "A " TAI "reduction strategy" TA " is a function that makes choices out of the available redexes. A "
			TAI "reducer"
			TA (" is a process that reduces redexes that are indicated by the strategy. The result of a reducer "+++
				" is reached as soon as the reduction strategy does not indicate redexes any more. A graph is in ")
			TAI "normal form"
			TA (" if none of the patterns in the rules match any part of the graph. A graph is said to be in root normal form"+++
				" when the root of a graph is not the root of a redex and can never become the root "+++
				"of a redex. In general it is undecidable whether a graph is in root normal form."),
			[],
			TS "A pattern " TAI "partially matches"
			TA (" a graph if firstly the symbol of the root of the pattern equals the symbol of the root of the "+++
				"graph and secondly in positions where symbols in the pattern are not syntactically equal to symbols in the graph, the "+++
				"corresponding sub-graph is a redex or the sub-graph itself is partially matching a rule. A graph is in ")
			TAI "strong root normal form"
			TA (" if the graph does not partially match any rule. It is decidable whether or not a graph is in strong root normal form. A "+++
				"graph in strong root normal form does not partially match any rule, so it is also in root normal form."),
			[],
			TS "The default reduction strategy used in CLEAN is the "
			TAI "functional reduction strategy"
			TA (". Reducing graphs according to this "+++
				"strategy resembles very much the way execution proceeds in other lazy functional languages: in the standard lambda "+++
				"calculus semantics the functional strategy corresponds to normal order reduction. On graph rewrite rules the functional "+++
				"strategy proceeds as follows: if there are several rewrite rules for a particular function, the rules are tried in textual order; "+++
				"patterns are tested from left to right; evaluation to strong root normal form of arguments is forced when an actual argument"+++
				" is matched against a corresponding non-variable part of the pattern. A formal definition of this strategy can be found in (Toyama ")
			TAI "et al." TA ", 1991)."
		],H3
			"1.1.1" "A Small Example"
		,S
			"Consider the following CLEAN program:"
		,PC (map color_keywords [
			TS "Add Zero z       =    z                         (1)",
			TS "Add (Succ a) z   =    Succ (Add a z)            (2)",
			[],
			TS "Start            =    Add (Succ o) o",
			TS "                      where",
			TS "                          o = Zero              (3)"
		]),P(
			TS ("In CLEAN a distinction is between function definitions (graph rewriting rules) and graphs (constant definitions). A semantic "+++
				"equivalent definition of the program above is given below where this distinction is made explicit (\"=>\" indicates a rewrite "+++
				"rule whereas \"=:\" is used for a constant (")
			TAI "sub-" TA ") " TAI "graph" TA " definition"
		),PC (map color_keywords [
			TS "Add Zero z       =    z                         (1)",
			TS "Add (Succ a) z   =    Succ (Add a z)            (2)",
			[],
			TS "Start            =    Add (Succ o) o",
			TS "                      where",
			TS "                          o =: Zero             (3)"
		]),S(
			"These rules are internally translated to a semantically equivalent set of rules in which the graph structure on both left-"+++
			"hand side as right-hand side of the rewrite rules has been made explicit by adding node-id's. Using the set of rules with "+++
			"explicit node-id's it will be easier to understand what the meaning is of the rules in the graph rewriting world."
		)];
	= make_page pdf_i pdf_shl;

page_1_3 :: !{!CharWidthAndKerns} -> Page;
page_1_3 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;

	# line_height = toReal line_height_i;

	# pdf_shl = make_pdf_shl pdf_i
		[PC [
			TS "x =: Add y z",
			TS "y =: Zero        =>   z                         (1)",
			TS "x =: Add y z",
			TS "y =: Succ a      =>   m =: Succ n",
			TS "                      n =: Add a z              (2)",
			[],
			TS "x =: Start       =>   m =: Add n o",
			TS "                      n =: Succ o",
			TS "                      o =: Zero                 (3)"
		],S
			"The fixed initial program graph that is in memory when a program starts is the following:"
		,N
		,PWP "The initial graph in linear notation:" 50 (TS "The initial graph in pictorial notation:")

		,PCNP [
			TS "@DataRoot    =: Graph @StartNode",
			TS "@StartNode   =: Start"
		] (3*line_height_i) ([
			TextFont 5 font_size,
			StringAt (8.0 * courier_char_width, 1.0 * line_height) "@DataRoot=:Graph",
			StringAt (7.0 * courier_char_width, 3.0 * line_height) "@StartNode=:Start",
			TextFont 1 font_size,
			PenColor (0,0,0)
		]++picture_elements_arrow	(21.5 * courier_char_width) (1.0 * line_height+3.0)
									(21.5 * courier_char_width) (2.0 * line_height+3.0))
		,N
		,MP [
			[],
			TS "To distinguish the node-id's appearing in the rewrite rules from the node-id's appearing in the graph the latter always begin with a \""
			TAC "@" TA "\".",
			[],
			TS "The initial graph is rewritten until it is in normal form. Therefore a CLEAN program must at least contain a \""
			TAI "start rule"
			TA ("\" that matches this initial graph via a pattern. The right-hand side of the start rule specifies the actual computation. "+++
				"In this start rule in the left-hand side the symbol ")
			TAC "Start" TA " is used. However, the symbols " TAC "Graph" TA " and " TAC "Initial" TA " ("
//			TAL "see next Section"
			TAL "see 1.2"
			TA ") are internal, so they cannot actually be addressed in any rule.",
			[],
			TS "The patterns in rewrite rules contain " TAI "formal node-id's"
			TA ". During the matching these formal nodeid's are mapped to the " TAI "actual node-id's"
			TA "of the graph  After that the following semantic actions are performed:",
			[],
			TS "The start node is the only redex matching rule (3). The contractum can now be constructed:",
			[]
		],PWP "The contractum in linear notation:" 50 (TS "The contractum in pictorial notation:")

		,PCNP [
			TS "@A =: Add  @B @C",
			TS "@B =: Succ @C",
			TS "@C =: Zero"
		] (5*line_height_i) ([
			TextFont 5 font_size,
			StringAt (16.0 * courier_char_width, 1.0 * line_height) "@A=:Add",
			StringAt (11.0 * courier_char_width, 3.0 * line_height) "@B=:Succ @C=:Zero",
			TextFont 1 font_size,
			PenColor (0,0,0)
		]++picture_elements_arrow	(21.0 * courier_char_width) (1.0 * line_height+3.0)
									(18.0 * courier_char_width) (2.0 * line_height+3.0)
		 ++picture_elements_arrow	(22.0 * courier_char_width) (1.0 * line_height+3.0)
									(25.0 * courier_char_width) (2.0 * line_height+3.0)
		 ++picture_elements_down_right_up_arrow 
									(18.0 * courier_char_width) (25.0 * courier_char_width) (3.0*line_height+3.0))
		,P(
			TS "All applied occurrences of " TAC "@StartNode" TA " will be replaced by occurrences of " TAC "@A"
			TA ". The graph after rewriting is then:"
		),N
		,PWP "The graph after rewriting:" 50 (TS "Pictorial notation:")

		,PCNP [
			TS "@DataRoot    =: Graph @A",
			TS "@StartNode   =: Start",
			TS "@A =: Add  @B @C",
			TS "@B =: Succ @C",
			TS "@C =: Zero"
		] (9*line_height_i) ([
			TextFont 5 font_size,
			StringAt ( 8.0 * courier_char_width, 1.0 * line_height) "@DataRoot=:Graph",
			StringAt ( 7.0 * courier_char_width, 3.0 * line_height) "@StartNode=:Start",
			StringAt (16.0 * courier_char_width, 5.0 * line_height) "@A=:Add",
			StringAt (11.0 * courier_char_width, 7.0 * line_height) "@B=:Succ @C=:Zero",
			TextFont 1 font_size,
			PenColor (0,0,0)
		]
		/* to do: dotted line
		 ++picture_elements_arrow	(21.5 * courier_char_width) (1.0 * line_height+3.0)
									(21.5 * courier_char_width) (2.0 * line_height+3.0)
		*/
		++let {
			corner_size = 6.0;
			x0 = 21.5 * courier_char_width;
			y0 =  1.0 * line_height+3.0;
			x1 = x0+corner_size;
			y1 = y0+corner_size;
			x2 = x1+20.0;
			y2 = y1;
			x3 = x2+corner_size;
			y3 = y2+corner_size;
			x4 = x3;
			y4 = y3+9.0;
			x5 = x4-corner_size;
			y5 = y4+corner_size;
			x6 = x5-20.0;
			y6 = y5;
			x7 = x6-corner_size;
			y7 = y6+corner_size;
		} in [Path (x0,y0) [
			path_element_corner_first_y x0 y0 corner_size corner_size,
			PLine (x2,y2),
	 		path_element_corner_first_x x2 y2 corner_size corner_size,
			PLine (x4,y4),
			path_element_corner_first_y x4 y4 (~corner_size) corner_size,
			PLine (x6,y6),
	 		path_element_corner_first_x x6 y6 (~corner_size) corner_size
	 	  ]]++picture_elements_arrow x7 y7 x7 (y7+5.0)
		 ++picture_elements_arrow	(21.0 * courier_char_width) (5.0 * line_height+3.0)
									(18.0 * courier_char_width) (6.0 * line_height+3.0)
		 ++picture_elements_arrow	(22.0 * courier_char_width) (5.0 * line_height+3.0)
									(25.0 * courier_char_width) (6.0 * line_height+3.0)
		 ++picture_elements_down_right_up_arrow 
									(18.0 * courier_char_width) (25.0 * courier_char_width) (7.0*line_height+3.0)
		)
		,N,N
		,P (
			TS "This completes one rewrite. All nodes that are not accessible from "
			TAC "@DataRoot"
			TA (" are garbage and not considered any more in the next rewrite steps. In an implementation once in a "+++
				"while garbage collection is performed in order to reclaim the memory space occupied by these garbage nodes. "+++
				"In this example the start node is not accessible from the data root node after the rewrite step and can be left out.")
		)];
	= make_page pdf_i pdf_shl;

page_1_4 :: !{!CharWidthAndKerns} -> Page;
page_1_4 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;

	# line_height = toReal line_height_i;

	# pdf_shl = make_pdf_shl pdf_i
		[PWP "The graph after garbage collection:" 50 (TS "Pictorial notation:")

		,PCNP [
			TS "@DataRoot   =: Graph @A",
			TS "@A =: Add  @B @C",
			TS "@B =: Succ @C",
			TS "@C =: Zero"
		] (7*line_height_i) ([
			TextFont 5 font_size,
			StringAt ( 8.0 * courier_char_width, 1.0 * line_height) "@DataRoot=:Graph",
			StringAt (16.0 * courier_char_width, 3.0 * line_height) "@A=:Add",
			StringAt (11.0 * courier_char_width, 5.0 * line_height) "@B=:Succ @C=:Zero",
			TextFont 1 font_size,
			PenColor (0,0,0)
		]++picture_elements_arrow	(21.5 * courier_char_width) (1.0 * line_height+3.0)
									(21.5 * courier_char_width) (2.0 * line_height+3.0)
		 ++picture_elements_arrow	(21.0 * courier_char_width) (3.0 * line_height+3.0)
									(18.0 * courier_char_width) (4.0 * line_height+3.0)
		 ++picture_elements_arrow	(22.0 * courier_char_width) (3.0 * line_height+3.0)
									(25.0 * courier_char_width) (4.0 * line_height+3.0)
		 ++picture_elements_down_right_up_arrow 
									(18.0 * courier_char_width) (25.0 * courier_char_width) (5.0*line_height+3.0)
		)
		,N
		,P(
			TS "The graph accessible from " TAC "@DataRoot"
			TA " still contains a redex. It matches rule 2 yielding the expected normal form:"
		),N
		,PWP "The final graph:" 50 (TS "Pictorial notation:")

		,PCNP [
			TS "@DataRoot =: Graph @D",
			TS "@D =: Succ @C",
			TS "@C =: Zero"
		] (5*line_height_i) ([
			TextFont 5 font_size,
			StringAt ( 8.0 * courier_char_width, 1.0 * line_height) "@DataRoot=:Graph",
			StringAt (15.0 * courier_char_width, 3.0 * line_height) "@D=:Succ",
			StringAt (15.0 * courier_char_width, 5.0 * line_height) "@C=:Zero",
			TextFont 1 font_size,
			PenColor (0,0,0)
		]++picture_elements_arrow	(21.5 * courier_char_width) (1.0 * line_height+3.0)
									(21.5 * courier_char_width) (2.0 * line_height+3.0)
		 ++picture_elements_arrow	(21.5 * courier_char_width) (3.0 * line_height+3.0)
									(21.5 * courier_char_width) (4.0 * line_height+3.0)
		)
		,N,N
		,CS (
			"The fact that graphs are being used in CLEAN gives the programmer the ability to explicitly share terms or to "+++
			"create cyclic structures. In this way time and space efficiency can be obtained."
		),H2
			"1.2" "Global Graphs"
		,S(
			"Due to the presence of global graphs in CLEAN the initial graph in a specific CLEAN program is slightly "+++
			"different from the basic semantics. In a specific CLEAN program the initial graph is defined as:"
		),PC [
			TS "@DataRoot    =: Graph @StartNode @GlobId1 @GlobId2 ... @GlobIdn",
			TS "@StartNode   =: Start",
			TS "@GlobId1     =: Initial", 
			TS "@GlobId2     =: Initial",
			TS "...",
			TS "@GlobIdn     =: Initial"
		],P (
			TS ("The root of the initial graph will not only contain the node-id of the start node, the root of the graph to be rewritten, "+++
				"but it will also contain for each ")
			TAI "global graph" TA " (" TAL "see 10.2"
			TA ") a reference to an initial node (initialized with the symbol " TAC "Initial"
			TA ("). All references to a specific global graph will be references to its initial node or, when it is rewritten, "+++
				"they will be references to its reduct.")
		)];
	= make_page pdf_i pdf_shl;
