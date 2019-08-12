implementation module clean_manual_bibliography;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

pages_c :: [{!CharWidthAndKerns} -> Page];
pages_c = [page_c_1,page_c_2];

page_c_1 :: !{!CharWidthAndKerns} -> Page;
page_c_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Appendix C" "Bibliography"
		,MP [
			[],
			TS "You can find all our papers on our site:"++TSb "http://wiki.clean.cs.ru.nl/Publications",
			[],
			TS "Peter Achten, John van Groningen and Rinus Plasmeijer (1992). \"High-level specification of I/O in functional languages\". "
			TAI "In: Proc. of the Glasgow workshop on Functional programming"
			TA ", ed. J. Launchbury and P. Sansom, Ayr, Scotland, Springer-Verlag, Workshops in Computing, pp. 1-17.",
			[],
			TS "Peter Achten and Rinus Plasmeijer (1995). \"The Ins and Outs of CONCURRENT CLEAN I/O\". "
			TAI "Journal of Functional Programming," TA " 5, 1, pp. 81-110.",
			[],
			TS "Peter Achten and Rinus Plasmeijer (1997). \"Interactive Functional Objects in CLEAN\". In: "
			TAI "Proc. of the 1997 Workshop on the Implementation of Functional Languages (IFL'97)"
			TA ", ed. K. Hammond Davie, T., and Clack, C., St.Andrews, Scotland, pp. 387-406.",
			[],
			TS ("Artem Alimarine and Rinus Plasmeijer. A Generic Programming Extension for Clean. In: Arts, Th., Mohnen, M. eds. "+++
				"Proceedings of the 13th International workshop on the Implementation of Functional Languages, IFL'01, Älvsjö, Sweden, "+++
				"September 24-26, 2001, Ericsson Computer Science Laboratory, pp.257-278."),
			[],
			TS "Tom Brus, Marko van Eekelen, Maarten van Leer, Rinus Plasmeijer (1987). 'CLEAN - A Language for Functional Graph Rewriting'. "
			TAI "Proc. of the Third International Conference on Functional Programming Languages and Computer Architecture (FPCA '87)"
			TA ", Portland, Oregon, USA, LNCS 274, Springer Verlag, 364-384.",
			[],
			TS "Barendregt, H.P. (1984). The Lambda-Calculus, its Syntax and Semantics. North-Holland.",
			[],
			TS "Henk Barendregt, Marko van Eekelen, John Glauert, Richard Kennaway, Rinus Plasmeijer, Ronan Sleep (1987). 'Term Graph Rewriting'. "
			TAI "Proceedings of Parallel Architectures and Languages Europe (PARLE)"
			TA ", part II, Eindhoven, The Netherlands. LNCS 259, Springer Verlag, 141-158.",
			[],
			TS "Erik Barendsen and Sjaak Smetsers (1993a). 'Extending Graph Rewriting with Copying'. In: "
			TAI "Proc. of the Seminar on Graph Transformations in Computer Science"
			TA ", ed. B. Courcelle, H. Ehrig, G. Rozenberg and H.J. Schneider, Dagstuhl, Wadern, Springer-Verlag, Berlin, LNCS 776, Springer Verlag, pp 51-70.",
			[],
			TS "Erik Barendsen and Sjaak Smetsers (1993b). 'Conventional and Uniqueness Typing in Graph Rewrite Systems (extended abstract)'. In: "
			TAI "Proc. of the 13th Conference on the Foundations of Software Technology & Theoretical Computer Science"
			TA ", ed. R.K. Shyamasundar, Bombay, India, LNCS 761, Springer Verlag, pp. 41-51.",
			[],
			TS "Bird, R.S. and P. Wadler (1988). " TAI "Introduction to Functional Programming" TA ". Prentice Hall.",
			[],
			TS "Marko van Eekelen, Rinus Plasmeijer, Sjaak Smetsers (1991). 'Parallel Graph Rewriting on Loosely Coupled Machine Architectures'. In Kaplan, S. and M. Okada (Eds.) "
			TAI "Proc. of the 2nd Int. Worksh. on Conditional and Typed Rewriting Systems (CTRS'90)"
			TA ", 1990. Montreal, Canada, LNCS 516, Springer Verlag, 354-370.",
			[],
			TS "Eekelen, M.C.J.D. van, J.W.M. Smetsers, M.J. Plasmeijer (1997). \"Graph Rewriting Semantics for Functional Programming Languages\". In: "
			TAI "Proc. of the CSL '96, Fifth Annual conference of the European Association for Computer Science Logic (EACSL)"
			TA ", ed. Marc Bezem Dirk van Dalen, Utrecht, Springer-Verlag, LNCS, 1258, pp. 106-128.",
			[],
			TS "Harper, R., D. MacQueen and R. Milner (1986). 'Standard ML'. Edinburgh University, Internal report ECS-LFCS-86-2.",
			[],
			TS "Hindley R. (1969). The principle type scheme of an object in combinatory logic. "
			TAI "Trans. of the American Math. Soc." TA ", "++TSB "146" TA ", 29-60.",
			[],
			TS " Hudak, P. , S. Peyton Jones, Ph. Wadler, B. Boutel, J. Fairbairn, J. Fasel, K. Hammond, J. Hughes, Th. Johnsson, D. "
			TA "Kieburtz, R. Nikhil, W. Partain and J. Peterson (1992). 'Report on the programming language Haskell'. "
			TAI "ACM SigPlan notices," TA " 27, 5, pp. 1-164."
		]
		];
	= make_page pdf_i pdf_shl;

page_c_2 :: !{!CharWidthAndKerns} -> Page;
page_c_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS ("John van Groningen and Rinus Plasmeijer. Strict and unboxed lists using type constructor classes in a lazy functional "+++
				"language. Presented at the 13th International Workshop on the Implementation of Functional Languages, IFL 2001, "+++
				"Älvsjö, Sweden, September 24-26, 2001, Ericsson Computer Science Laboratory."),
			[],
			TS "Jones, M.P. (1993). " TAI "Gofer - Gofer 2.21 release notes" TA ". Yale University.",
			[],
			TS "Marko Kesseler (1991). 'Implementing the ABC machine on transputers'. In: "
			TAI "Proc. of the 3rd International Workshop on Implementation of Functional Languages on Parallel Architectures"
			TA ", ed. H. Glaser and P. Hartel, Southampton, University of Southampton, Technical Report 91-07, pp. 147-192.",
			[],
			TS ("Kesseler, M.H.G. (1996). The Implementation of Functional Languages on Parallel Machines with Distributed Memory. "+++
				"Ph.D., University of Nijmegen."),
			[],
			TS "Milner, R.A. (1978). 'Theory of type polymorphism in programming'. "
			TAI "Journal of Computer and System Sciences," TA " 17, 3, 348-375.",
			[],
			TS "Mycroft A. (1984). Polymorphic type schemes and recursive definitions. In "
			TAI "Proc. International Conference on Programming,"
			TA " Toulouse (Paul M. and Robinet B., eds.), LNCS 167, Springer Verlag, 217–239.",
			[],
			TS "Eric Nöcker, Sjaak Smetsers, Marko van Eekelen, Rinus Plasmeijer (1991). 'CONCURRENT CLEAN'. In Aarts, E.H.L., J. van Leeuwen, M. Rem (Eds.), "
			TAI "Proceedings of the Conference on Parallel Architectures and Languages Europe (PARLE'91)"
			TA ", Vol II, Eindhoven, The Netherlands, LNCS 505, Springer Verlag, June 1991, 202-219.",
			[], 
			TS "Eric Nöcker (1993). 'Strictness analysis using abstract reduction'. In: "
			TAI "Proc. of the 6th Conference on Functional Programming Languages and Computer Architectures"
			TA ", ed. Arvind, Copenhagen, ACM Press, pp. 255-265.",
			[],
			TS "Eric Nöcker and Sjaak Smetsers (1993). 'Partially strict non-recursive data types'. "
			TAI "Journal of Functional Programming," TA " "++TSB "3" TA ", 2, pp. 191-215.",
			[],
			TS ("Pil, M.R.C. (1999), Dynamic types and type dependent functions , In Proc. of Implementation of Functional Languages "+++
				"(IFL '98), London, U.K., Hammond, Davie and Clack Eds., Springer-Verlag, Berlin, Lecture Notes in Computer Science "+++
				"1595, pp 169-185."),
			[],
			TS "Rinus Plasmeijer and Marko van Eekelen (1993). "
			TAI "Functional Programming and Parallel Graph Rewriting" TA ". Addison Wesley, ISBN 0-201-41663-8.",
			[],
			TS "Sjaak Smetsers, Eric Nöcker, John van Groningen, Rinus Plasmeijer (1991). 'Generating Efficient Code for Lazy Functional Languages'. In Hughes, J. (Ed.), "
			TAI "Proc. of the Fifth International Conference on Functional Programming Languages and Computer Architecture (FPCA '91)"
			TA ", USA, LNCS 523, Springer Verlag, 592-618.",
			[],
			TS "Ronan Sleep, Rinus Plasmeijer and Marko van Eekelen (1993). "
			TAI "Term Graph Rewriting - Theory and Practice" TA ". John Wiley & Sons.",
			[],
			TS "Yoshihito Toyama, Sjaak Smetsers, Marko van Eekelen and Rinus Plasmeijer (1993). 'The functional strategy and transitive term rewriting systems'. In: "
			TAI "Term Graph Rewriting" TA ", ed. Sleep, Plasmeijer and van Eekelen, John Wiley.",
			[],
			TS "Turner, D.A. (1985). 'Miranda: a non-strict functional language with polymorphic types'. In: "
			TAI "Proc. of the Conference on Functional Programming Languages and Computer Architecture"
			TA ", ed. J.P. Jouannaud, Nancy, France. LNCS 201, Springer Verlag, 1-16.",
			[],
			TS ("Martijn Vervoort and Rinus Plasmeijer (2002). Lazy Dynamic Input/Output in the lazy functional language Clean - early "+++
				"draft -. In: Peña, R. ed. Proceedings of the 14th International Workshop on the Implementation of Functional Languages, "+++
				"IFL 2002, Madrid, Spain, September 16-18, 2002, Technical Report 127-02, Departamento de Sistemas Informáticos y "+++
				"Programació n, Universidad Complutense de Madrid, pages 404-408."),
			[],
			TS ("Arjen van Weelden and Rinus Plasmeijer (2002). Towards a Strongly Typed Functional Operating System. In: Peña, R. "+++
				"ed. Proceedings of the 14th International Workshop on the Implementation of Functional Languages, IFL 2002, Madrid, "+++
				"Spain, September 16-18, 2002, Technical Report 127-02, Departamento de Sistemas Informáticos y Programación, "+++
				"Universidad Complutense de Madrid, pages 301-319.")
		]
	];
	= make_page pdf_i pdf_shl;
