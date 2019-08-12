implementation module parse_afm;

import StdEnv;

skip_tabs_and_spaces i s
	| i<size s && (s.[i]==' ' || s.[i]=='\t')
		= skip_tabs_and_spaces (i+1) s;
		= i;

skip_to_semicolon i s
	| i<size s
		| s.[i]==';'
			= i
			= skip_to_semicolon (i+1) s;
		= i;

skip_number i s
	| i<size s
		| s.[i]=='-'
			= skip_digits (i+1) s;
			= skip_digits i s;
		= i;

skip_name i s
	| i<size s
		| s.[i]==' ' || s.[i]=='\t'
			= i;
			= skip_name (i+1) s;
		= i;

skip_digits i s
	| i<size s && (s.[i]>='0' && s.[i]<='9')
		= skip_digits (i+1) s;
		= i;

is_empty_line_or_comment line
	= size line==0 || (line % (0,6)=="Comment" && (size line==7 || line.[7]==' ' || line.[7]=='\t'));

read_afm_lines afm_file
	# (afm_line,afm_file) = freadline afm_file;
	| size afm_line==0
		= ([],afm_file);
	| afm_line.[size afm_line-1]=='\n'
		# afm_line = afm_line % (skip_tabs_and_spaces 0 afm_line,size afm_line-2);
		| is_empty_line_or_comment afm_line
			= read_afm_lines afm_file;
			# (afm_lines,afm_file) = read_afm_lines afm_file;
			= ([afm_line:afm_lines],afm_file);
		# afm_line = afm_line % (skip_tabs_and_spaces 0 afm_line,size afm_line-1);
		| is_empty_line_or_comment afm_line
			= ([],afm_file);
			= ([afm_line],afm_file);

skip_to_StartCharMetrics [line:lines]
	| line % (0,15)=="StartCharMetrics" && (size line==16 || line.[16]==' ' || line.[16]=='\t')
		= lines;
		= skip_to_StartCharMetrics lines;
skip_to_StartCharMetrics []
	= abort "StartCharMetrics not found in file";

:: Option a = Some !a | None;

parse_CharMetric i line metric
	# i = skip_tabs_and_spaces i line;
	| i<size line
		# semicolon_i = skip_to_semicolon i line;
		| semicolon_i==size line
			= metric;
		| line.[i]=='C' && (line.[i+1]==' ' || line.[i+1]=='\t')
			# i = skip_tabs_and_spaces (i+2) line;
			# no_digit_i = skip_number i line;
			| no_digit_i<>i
				#! char_code = toInt (line % (i,no_digit_i-1));
				# (_,owx,on) = metric;
				= parse_CharMetric (semicolon_i+1) line (Some char_code,owx,on);
				= abort "- or digit missing after C in CharMetric";
		| line.[i]=='W' && line.[i+1]=='X' && (line.[i+2]==' ' || line.[i+2]=='\t')
			# i = skip_tabs_and_spaces (i+3) line;
			# no_digit_i = skip_number i line;
			| no_digit_i<>i
				#! wx = toInt (line % (i,no_digit_i-1));
				# (oc,_,on) = metric;
				= parse_CharMetric (semicolon_i+1) line (oc,Some wx,on);
				= abort "- or digit missing after C in CharMetric";
		| line.[i]=='N' && (line.[i+1]==' ' || line.[i+1]=='\t')
			# i = skip_tabs_and_spaces (i+2) line;
			# no_name_i = skip_name i line;
			| no_name_i<>i
				#! name = line % (i,no_name_i-1);
				# (oc,owx,_) = metric;
				= parse_CharMetric (semicolon_i+1) line (oc,owx,Some name);
				= abort "name missing after N in CharMetric";
			= parse_CharMetric (semicolon_i+1) line metric;
		= metric;

parse_CharMetrics [line:lines] metrics
	| line % (0,13)=="EndCharMetrics" && (size line==14 || line.[14]==' ' || line.[14]=='\t')
		= (lines,metrics);
		# (lines,metrics) = parse_CharMetrics lines metrics;
		# metric = parse_CharMetric 0 line (None,None,None);
		# metrics = case metric of {
						(Some c,Some wx,Some n) -> [(c,wx,n):metrics];
						_ -> metrics;
					}
		= (lines,metrics);
parse_CharMetrics _ metrics
	= abort "EndCharMetrics not found in file";

skip_to_StartKernPairs [line:lines]
	| line % (0,13)=="StartKernPairs" && (size line==14 || line.[14]==' ' || line.[14]=='\t')
		= (True,lines);
		= skip_to_StartKernPairs lines;
skip_to_StartKernPairs []
	= (False,[]); // abort "StartKernPairs not found in file";

parse_KernPair i line
	| size line>3 && line.[i]=='K' && line.[i+1]=='P' && line.[i+2]=='X' && (line.[i+3]==' ' || line.[i+3]=='\t')
		# i1 = skip_tabs_and_spaces (i+4) line;
		# no_name_i1 = skip_name i1 line;
		| no_name_i1==i1
			= abort "first name missing after KPX in file";
		#! name1 = line % (i1,no_name_i1-1);
		# i2 = skip_tabs_and_spaces (no_name_i1+1) line;
		# no_name_i2 = skip_name i2 line;
		| no_name_i2==i2
			= abort "second name missing after KPX in file";
		#! name2 = line % (i2,no_name_i2-1);
		# i3 = skip_tabs_and_spaces (no_name_i2+1) line;
		# no_digit_i = skip_number i3 line;
		| no_digit_i==i
			= abort "- or digit missing after KPX in file";
		#! k = toInt (line % (i3,no_digit_i-1));
		= (name1,name2,k);
		= abort "KPX expected in file";

parse_KernPairs [line:lines] kern_pairs
	| line % (0,11)=="EndKernPairs" && (size line==12 || line.[12]==' ' || line.[12]=='\t')
		= (lines,kern_pairs);
		# kern_pair = parse_KernPair 0 line;
		# (_,_,k) = kern_pair;
		| k==0
			= parse_KernPairs lines kern_pairs;
			# (lines,kern_pairs) = parse_KernPairs lines kern_pairs;
			= (lines,[kern_pair:kern_pairs]);
parse_KernPairs _ kern_pairs
	= abort "EndKernPairs not found in file";

search_char_code name sorted_names_and_char_codes
	= search_char_code 0 (size sorted_names_and_char_codes) name sorted_names_and_char_codes;
{
	search_char_code first_i end_i name sorted_names_and_char_codes
		# n = end_i-first_i;
		| n==0
			= -1;
		# middle_i = first_i+(n>>1);
		# (middle_name,middle_char_code) = sorted_names_and_char_codes.[middle_i];
		| name==middle_name
			= middle_char_code;
		| name<middle_name
			= search_char_code first_i middle_i name sorted_names_and_char_codes;
			= search_char_code (middle_i+1) end_i name sorted_names_and_char_codes;
}

merge_kern_pairs sorted_char_code_kern_pairs
	# sorted_char_code_kern_pairs = [(char_code1,[(char_code2,k)]) \\ (char_code1,char_code2,k) <-sorted_char_code_kern_pairs];
	= merge_kern_pairs sorted_char_code_kern_pairs;
{
	merge_kern_pairs [k1=:(char_code1,name1_k):l1=:[(char_code2,name2_k):l2]]
		| char_code1==char_code2
			= merge_kern_pairs [(char_code1,name1_k++name2_k):l2];
			= [k1:merge_kern_pairs l1];
	merge_kern_pairs l
		= l;
}

merge_widths_and_kern_chars l1=:[(char_code1,width):t1] l2=:[(char_code2,kern_pairs):t2]
	| char_code1<char_code2
		= [(char_code1,width,[]) : merge_widths_and_kern_chars t1 l2];
	| char_code1==char_code2
		= [(char_code1,width,kern_pairs) : merge_widths_and_kern_chars t1 t2];
		= merge_widths_and_kern_chars l1 t2;
merge_widths_and_kern_chars l1 _
	= [(char_code1,width,[]) \\ (char_code1,width)<-l1];

parse_afm_file :: !{#Char} !*World -> (!{!(Int,Int,[(Int,Int)])},!*World);
parse_afm_file file_name world
	# (ok,afm_file,world) = fopen file_name FReadText world;
	| not ok
		= abort ("fopen failed for: "+++file_name);
	
	# (afm_lines,afm_file) = read_afm_lines afm_file;
	
	# afm_lines = skip_to_StartCharMetrics afm_lines;
	
	# (afm_lines,metrics) = parse_CharMetrics afm_lines []
	
	# (has_kern_pairs,afm_lines) = skip_to_StartKernPairs afm_lines;
//	# (has_kern_pairs,afm_lines) = (False,[]);
	
	# (afm_lines,kern_pairs) = if has_kern_pairs (parse_KernPairs afm_lines []) ([],[]);

	# (ok,world) = fclose afm_file world;
	| not ok
		= abort "reading file failed";
	# sorted_names_and_char_codes = {! n_c \\ n_c<-sort [(name,char_code) \\ (char_code,width,name)<-metrics]};
	# char_code_kern_pairs = [(search_char_code name1 sorted_names_and_char_codes,search_char_code name2 sorted_names_and_char_codes,k)
								\\ (name1,name2,k)<-kern_pairs];
	# sorted_char_code_kern_pairs = sort char_code_kern_pairs;
	# sorted_char_code_kern_chars = merge_kern_pairs sorted_char_code_kern_pairs;
	# char_widths = [(char_code,width) \\ (char_code,width,_) <- metrics | char_code <> -1];
	# l = merge_widths_and_kern_chars char_widths sorted_char_code_kern_chars;
	= ({! e\\e<-l },world);

/*
Start world
//	# char_width_and_kerns = parse_afm_file "TIR_____.AFM" world;
	# (char_width_and_kerns,world) = parse_afm_file "HV______.AFM" world;
	= [(char,width,kps,'\n') \\ (char,width,kps)<-: char_width_and_kerns];
*/