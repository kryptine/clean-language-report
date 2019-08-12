implementation module clean_manual_foreign_interface;

import StdEnv,pdf_main,pdf_text,clean_manual_styles,clean_manual_text;

pages_11:: [{!CharWidthAndKerns} -> Page];
pages_11 = [page_11_1,page_11_2];

// 183 in Adobe standard encoding
BulletString :== "\xB7";

page_11_1 :: !{!CharWidthAndKerns} -> Page;
page_11_1 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[C "Chapter 11" "Foreign Language Interface"
		,MP [
			[],
			TS "The tool htoclean can be used to generate interfaces to C functions. This is not discussed in this manual.",
			[],
			TS "How to call Clean functions from C is discussed in " TAL "section 11.1" TA ".",
			[],
			TS "ABC instructions of the virtual machine for Clean can be used. This is explained in " TAL "section 11.2" TA "."
		],H2
			"11.1" "Foreign Export"
		,S(
			"Some Clean functions can be called from C using foreign export. This is possible if:"
		),MBP [
			TS "The function is exported.",
			TS "All arguments are annotated as being strict (" TAL "see 3.7.5" TA ").",
			TS "The arguments and result type is either of the following:"
		],MPWI
			[(BulletString,(TS "Int"))
		 	,(BulletString,(TS "Real"))
		 	,(BulletString,(TS "{#Char}"))
		 	,(BulletString,(TS "{#Int}"))
		 	,(BulletString,(TS "{#Real}"))
		 	,(BulletString,(TS "A tuple of these strictly annotated types (including tuples)."))
		],S(
			"The following syntax is used in an implementation module to export a function to a foreign language:"
		),ST [
			[TS "ForeignExportDef",	TS_E,	TSBCr "foreign export" TA " [ " TABCr "ccall" TA " | " TABCr "stdcall" TA " ] " TAC "FunctionName" TA " " TABCb";"]
		],S(
			"The calling convention may be specified by prefixing the function name with ccall or stdcall. The default is ccall."
		),S(
			"To pass an argument from C of type:"
		),MBP [
			TS ("Int, use a C integer type that has the same size as an Int in Clean. On 32 bit platforms this is "+++
				"4 bytes, on 64 bit platforms 8 bytes. Usually long has the right size, except on 64 bit Windows "+++
				"__int64 can be used instead."),
			TS "Real, use type double.",
			TS ("{#Char}, pass the address of the string. The first 4 (on 32 bit platforms) or 8 (on 64 bit platforms) "+++
				"bytes should contain the number of characters. The characters of the string are stored in the following "+++
				"bytes. The string is copied to the heap of Clean, and this copy is used in Clean."),
			TS ("{#Int}, pass the address of the array. The elements of the array have the same size as an Int in Clean. "+++
				"The number of elements should be stored in 4 bytes at offset -8 (32 bit) or 8 bytes at offset -16 (64 bit). "+++
				"The array is copied to the heap of Clean, and this copy is used in Clean."),
			TS ("{#Real}, pass the address of the array. The elements of the array have the same size as a Real in Clean "+++
				"(8 bytes) and a double in C. The number of elements should be stored in the same way as for {#Int}. The "+++
				"array is copied to the heap of Clean, and this copy is used in Clean."),
			TS "Tuple. The elements are passed as separate arguments as described above, in the same order as in the tuple."
		],S(
			"Preferably, the macros in the file Clean.h (part of the tool htoclean) should be used to access strings and arrays."
		)
		];
	= make_page pdf_i pdf_shl;

page_11_2 :: !{!CharWidthAndKerns} -> Page;
page_11_2 char_width_and_kerns
	# pdf_i = init_PDFInfo char_width_and_kerns;
	# pdf_shl = make_pdf_shl pdf_i
		[MP [
			TS ("If result of the function is not a tuple, the result is passed in the same way as an argument, except that strings and arrays "+++
				"are not copied. The address of the string or array in the heap of Clean is passed to C. This string or array may only be "+++
				"used until the next call or return to Clean, because the Clean runtime system may deallocate or move the array."),
			[],
			TS ("If multiple values are yielded, because the result is a tuple, the result type in C is void. To return the values, for each "+++
				"value an additional argument with the address where the result should be stored is added (at the end, in the same order "+++
				"as in the tuple). For example, if the result has type (Real, Int), an additional double * and long * (__int64 * for 64 bit "+++
				"Windows) is added.")
		],H2
			"11.2" "Using ABC instructions"
		,S(
			"Function can be implemented using ABC instructions from the virtual machine used by Clean:"
		),ST [
			[TS "ABCCodeFunctionDef",	TS_E,	TS "Function {Pattern} " TAT "=" TA " " TABCr "code" TA " ["
			  TABCr "inline" TA "] " TABCb "{" TA " ABCInstructions " TABCb "}"]
		],P(
			TS "By adding " TABCr "inline"
			TA " the ABC instructions will be inlined if the function is called in a strict context."
		),S(
			"This is used to define primitive functions of the StdEnv, for example integer addition. "+++
			"htoclean generates calls to C functions using the ABC instruction ccall."
		)
		];
	= make_page pdf_i pdf_shl;
