implementation module pdf_text;

import StdEnv;

import StdDebug;

:: CharWidthAndKerns :== {!(Int,Int,[(Int,Int)])};

:: Text = TString !{#Char} | TFont !Int !{#Char} !FontColor | TLink !{#Char};

:: FontColor = FCNo | FCBlack | FCRGB !(!Int,!Int,!Int);

:: Link = {
	link_begin_pos :: !Real,
	link_line_word_spacing :: !Real,
	link_font_n :: !Int,
	link_font_size :: !Int,
	link_s :: !{#Char},
	link_y_pos :: !Int,
	link_extra_margin :: !Real
   };

search_width_and_kern_pairs first_i end_i c char_width_and_kerns
	# n = end_i-first_i;
	| n==0
		= (-1,[]);
	# middle_i = first_i+(n>>1);
	# (middle_c,middle_width,middle_kerns) = char_width_and_kerns.[middle_i];
	| c==middle_c
		= (middle_width,middle_kerns);
	| c<middle_c
		= search_width_and_kern_pairs first_i middle_i c char_width_and_kerns;
		= search_width_and_kern_pairs (middle_i+1) end_i c char_width_and_kerns;

char_width :: Int CharWidthAndKerns -> Int;
char_width c1 char_width_and_kerns
	# (width,_) = search_width_and_kern_pairs 0 (size char_width_and_kerns) c1 char_width_and_kerns;
	| width <> -1
		= width;
		= 0;

get_kern [] c2
	= 0;
get_kern [(c,k):cks] c2
	| c==c2	
		= k;
		= get_kern cks c2;

add_kern [] c2 width
	= width;
add_kern [(c,k):cks] c2 width
	| c==c2	
		= width+k;
		= add_kern cks c2 width;

char_width_kern :: !Int !Int !CharWidthAndKerns -> Int;
char_width_kern c1 c2 char_width_and_kerns
	# (width,kerns) = search_width_and_kern_pairs 0 (size char_width_and_kerns) c1 char_width_and_kerns;
	| width <> -1
		= add_kern kerns c2 width;
		= 0;

char_width_and_kern :: !Int !Int !CharWidthAndKerns -> (!Int,!Int);
char_width_and_kern c1 c2 char_width_and_kerns
	# (width,kerns) = search_width_and_kern_pairs 0 (size char_width_and_kerns) c1 char_width_and_kerns;
	| width <> -1
		= (width,get_kern kerns c2);
		= (0,0);

char_kern :: !Int !Int !CharWidthAndKerns -> Int;
char_kern c1 c2 char_width_and_kerns
	# (width,kerns) = search_width_and_kern_pairs 0 (size char_width_and_kerns) c1 char_width_and_kerns;
	| width <> -1
		= get_kern kerns c2;
		= 0;

string_width :: !{#Char} !CharWidthAndKerns -> Int;
string_width s char_width_and_kerns
	| size s==0
		= 0;
		= string_width 0 0 s char_width_and_kerns;
{
	string_width i width s char_width_and_kerns
		# c1 = toInt s.[i];
		| i<size s-1
			# c2 = toInt s.[i+1];
			# width = width + char_width_kern c1 c2 char_width_and_kerns;
			= string_width (i+1) width s char_width_and_kerns;
			= width + char_width c1 char_width_and_kerns;
}

string_words_width :: !{#Char} !CharWidthAndKerns -> (![(Int,Int,Int,Int)],!Int);
string_words_width s char_width_and_kerns
	| size s==0
		= ([],0);
	| s.[0]==' '
		= string_width_spaces 0 0 s char_width_and_kerns;
		= string_width_word 0 0 0 0 s char_width_and_kerns;
{}{
	string_width_spaces i width s char_width_and_kerns
		# c1 = s.[i];
		| c1<>' '
			= abort "string_width_spaces";
		| i<size s-1
			# c2 = s.[i+1];
			# next_width = width + char_width_kern (toInt c1) (toInt c2) char_width_and_kerns;
			| c2==' '
				= string_width_spaces (i+1) next_width s char_width_and_kerns;
				= string_width_word (i+1) next_width (i+1) width s char_width_and_kerns;
			# next_width = width + char_width (toInt c1) char_width_and_kerns;
			= ([],next_width);

	string_width_word i width word_begin_i word_begin_width s char_width_and_kerns
		# c1 = s.[i];
		| c1==' '
			= abort "string_width_word";
		| i<size s-1
			# c2 = s.[i+1];
			# (c1_width,kern) = char_width_and_kern (toInt c1) (toInt c2) char_width_and_kerns;
			# next_width = width + c1_width + kern;
			| c2==' '
				# (word_widths,total_width) = string_width_spaces (i+1) next_width s char_width_and_kerns;
				= ([(word_begin_i,i+1,word_begin_width,width+c1_width):word_widths],total_width);
				= string_width_word (i+1) next_width word_begin_i word_begin_width s char_width_and_kerns;
			# next_width = width + char_width (toInt c1) char_width_and_kerns;
			= ([(word_begin_i,i+1,word_begin_width,next_width)],next_width);
}

text_words_width :: ![Text] !Int !{!CharWidthAndKerns} -> ([(Int,Int,Int,Int)],Int);
text_words_width text_l font_n char_width_and_kerns
	= text_words_width text_l 0 0 font_n char_width_and_kerns;
{
	text_words_width [TString s:text_l] index_offset width_offset font_n char_width_and_kerns
		# (words_width,string_width) = string_words_width s char_width_and_kerns.[font_n];
		# text_index_offset = index_offset+size s;
		# text_width_offset = width_offset+string_width;
		# (text_widths,text_width) = text_words_width text_l text_index_offset text_width_offset font_n char_width_and_kerns;
		= (add_offsets_and_append words_width index_offset width_offset text_widths,text_width);

	text_words_width [TLink s:text_l] index_offset width_offset font_n char_width_and_kerns
		# (words_width,string_width) = string_words_width s char_width_and_kerns.[font_n];
		# text_index_offset = index_offset+size s;
		# text_width_offset = width_offset+string_width;
		# (text_widths,text_width) = text_words_width text_l text_index_offset text_width_offset font_n char_width_and_kerns;
		= (add_offsets_and_append words_width index_offset width_offset text_widths,text_width);

	text_words_width [TFont next_font_n _ _:text_l] index_offset width_offset font_n char_width_and_kerns
		| next_font_n>=0
			= text_words_width text_l index_offset width_offset next_font_n char_width_and_kerns;
			= text_words_width text_l index_offset width_offset font_n char_width_and_kerns;
	text_words_width [] index_offset width_offset font_n char_width_and_kerns
		= ([],width_offset);

	add_offsets_and_append [(begin_i,end_i,begin_pos,end_pos):offsets] index_offset width_offset text_widths
		= [(begin_i+index_offset,end_i+index_offset,begin_pos+width_offset,end_pos+width_offset)
		  : add_offsets_and_append offsets index_offset width_offset text_widths];
	add_offsets_and_append [] index_offset width_offset text_widths
		= text_widths;
}

split_lines :: ![(Int,Int,Int,Int)] !Int !Int {#Char} -> [{#Char}];
split_lines words_widths total_width max_line_width line
	| total_width<=max_line_width
		= [line];
		= split_lines words_widths max_line_width line;
{}{
	split_lines [first_word_widths=:(first_i,end_i,first_width,end_width):words_widths] max_width line
		| end_width<=max_width
			= add_words words_widths max_width line first_word_widths first_word_widths;

	add_words [next_word_widths=:(first_i,end_i,first_width,end_width):words_widths] max_width line first_word_widths last_word_widths
		| end_width<=max_width
			= add_words words_widths max_width line first_word_widths next_word_widths;
			# (first_i_,_,_,_) = first_word_widths;
			# (_,end_i_,_,_) = last_word_widths;
			# max_width = max_line_width + first_width;
			= [line % (first_i_,end_i_-1) : split_lines [next_word_widths:words_widths] max_width line];
	add_words [] max_width line first_word_widths last_word_widths
		# (first_i_,_,_,_) = first_word_widths;
		# (_,end_i_,_,_) = last_word_widths;
		= [line % (first_i_,end_i_-1)];
}

split_lines_slices :: ![(Int,Int,Int,Int)] !Int !Int {#Char} -> [({#Char},Int,Int)];
split_lines_slices words_widths total_width max_line_width line
	| total_width<=max_line_width
		= [(line,0,size line)];
		= split_lines words_widths max_line_width line;
{}{
	split_lines [first_word_widths=:(first_i,end_i,first_width,end_width):words_widths] max_width line
		| end_width<=max_width
			= add_words words_widths max_width line first_word_widths first_word_widths;

	add_words [next_word_widths=:(first_i,end_i,first_width,end_width):words_widths] max_width line first_word_widths last_word_widths
		| end_width<=max_width
			= add_words words_widths max_width line first_word_widths next_word_widths;
			# (first_i_,_,_,_) = first_word_widths;
			# (_,end_i_,_,_) = last_word_widths;
			# max_width = max_line_width + first_width;
			= [(line % (first_i_,end_i_-1),first_i_,end_i_) : split_lines [next_word_widths:words_widths] max_width line];
	add_words [] max_width line first_word_widths last_word_widths
		# (first_i_,_,_,_) = first_word_widths;
		# (_,end_i_,_,_) = last_word_widths;
		= [(line % (first_i_,end_i_-1),first_i_,end_i_)];
}

count_spaces :: !Int !Int !{#Char} -> Int;
count_spaces i n s
	| i<size s
		| s.[i]==' '
			= count_spaces (i+1) (n+1) s;
			= count_spaces (i+1) n s;
		= n;

count_spaces_before :: !Int !Int !Int !{#Char} -> Int;
count_spaces_before i n stop_i s
	| i<stop_i
		| s.[i]==' '
			= count_spaces_before (i+1) (n+1) stop_i s;
			= count_spaces_before (i+1) n stop_i s;
		= n;

add_kerning :: !Int !{#Char} !CharWidthAndKerns -> (!Bool,{#Char});
add_kerning i s char_width_and_kerns
	| i<size s-1
		# c1 = s.[i];
		| c1=='(' || c1==')' || c1=='\\'
			# s = s % (0,i-1) +++ "\\" +++ s % (i,size s-1);
			# i = i+1;
			| i<size s-1
				# kern = char_kern (toInt s.[i]) (toInt s.[i+1]) char_width_and_kerns;
				| kern<>0
					# s = s % (0,i)+++")"+++toString (~kern)+++"("+++add_more_kerning 0 (s % (i+1,size s-1)) char_width_and_kerns;
					= (True,s);
					= add_kerning (i+1) s char_width_and_kerns;
			| i==size s-1
				# c = s.[i];
				| c=='(' || c==')' || c=='\\'
					= (False,s % (0,i-1) +++ "\\" +++ s % (i,size s-1));
					= (False,s);
				= (False,s);
		# kern = char_kern (toInt c1) (toInt s.[i+1]) char_width_and_kerns;
		| kern<>0
			# s = s % (0,i)+++")"+++toString (~kern)+++"("+++add_more_kerning 0 (s % (i+1,size s-1)) char_width_and_kerns;
			= (True,s);
			= add_kerning (i+1) s char_width_and_kerns;
	| i==size s-1
		# c = s.[i];
		| c=='(' || c==')' || c=='\\'
			= (False,s % (0,i-1) +++ "\\" +++ s % (i,size s-1));
			= (False,s);
		= (False,s);

add_more_kerning :: !Int !{#Char} !CharWidthAndKerns -> {#Char};
add_more_kerning i s char_width_and_kerns
	| i<size s-1
		# c1 = s.[i];
		| c1=='(' || c1==')' || c1=='\\'
			# s = s % (0,i-1) +++ "\\" +++ s % (i,size s-1);
			# i = i+1;
			| i<size s-1
				# kern = char_kern (toInt s.[i]) (toInt s.[i+1]) char_width_and_kerns;
				| kern<>0
					= s % (0,i)+++")"+++toString (~kern)+++"("+++add_more_kerning 0 (s % (i+1,size s-1)) char_width_and_kerns;
					= add_more_kerning (i+1) s char_width_and_kerns;
			| i==size s-1
				# c = s.[i];
				| c=='(' || c==')' || c=='\\'
					= s % (0,i-1) +++ "\\" +++ s % (i,size s-1);
					= s;
				= s;
		# kern = char_kern (toInt c1) (toInt s.[i+1]) char_width_and_kerns;
		| kern<>0
			= s % (0,i)+++")"+++toString (~kern)+++"("+++add_more_kerning 0 (s % (i+1,size s-1)) char_width_and_kerns;
			= add_more_kerning (i+1) s char_width_and_kerns;
	| i==size s-1
		# c = s.[i];
		| c=='(' || c==')' || c=='\\'
			= s % (0,i-1) +++ "\\" +++ s % (i,size s-1);
			= s;
		= s;

compute_word_spacing line font_size width char_width_and_kerns
	# line_width = string_width line char_width_and_kerns;
	# n_line_spaces = count_spaces 0 0 line;
	| n_line_spaces<>0
		= (1000.0*width-toReal (font_size*line_width))/(toReal n_line_spaces*1000.0);
		= 0.0;

format_lines :: !{#Char} !Real !Int !CharWidthAndKerns -> (![{#Char}],!Int);
format_lines p_lines width font_size char_width_and_kerns
	# (words_widths,total_width) = string_words_width p_lines char_width_and_kerns;
	# lines = split_lines words_widths total_width (toInt (1000.0* width /toReal font_size)) p_lines;
	# n_lines = length lines;
	= (lines,n_lines);

format_text :: ![Text] !Real !Int !Int !{!CharWidthAndKerns} -> (!(![({#Char},Int,Int)],![Text]),!Int);
format_text text_l width font_size font_n char_width_and_kerns
	# (words_widths,total_width) = text_words_width text_l font_n char_width_and_kerns;
	# p_lines = concat_text_strings text_l;
	# lines_and_slices = split_lines_slices words_widths total_width (toInt (1000.0* width /toReal font_size)) p_lines;
	# n_lines = length lines_and_slices;
	= ((lines_and_slices,text_l),n_lines);

print_justified_line :: !{#Char} !Int !Real !CharWidthAndKerns -> {#Char};
print_justified_line line font_size width char_width_and_kerns
	#! word_spacing = compute_word_spacing line font_size width char_width_and_kerns;
	# (uses_kerning,k_line) = add_kerning 0 line char_width_and_kerns;
	| uses_kerning
		= toString word_spacing+++" Tw "+++ "[("+++k_line+++")]TJ "+++"0 Tw "+++"T*\n";
		= toString word_spacing+++" Tw "+++ "("+++k_line+++")Tj "+++"0 Tw "+++"T*\n";

print_formatted_string :: !{#Char} !CharWidthAndKerns -> {#Char};
print_formatted_string line char_width_and_kerns
	| size line<>0
		# (uses_kerning,k_line) = add_kerning 0 line char_width_and_kerns;
		| uses_kerning
			= "[("+++k_line+++")]TJ ";
			= "("+++k_line+++")Tj ";
		= "";

print_lines :: ![{#Char}] !Int !Real !CharWidthAndKerns -> {#Char};
print_lines [line] font_size width char_width_and_kerns
	= print_formatted_string line char_width_and_kerns;
print_lines [line:lines] font_size width char_width_and_kerns
	= print_justified_line line font_size width char_width_and_kerns+++
	  print_lines lines font_size width char_width_and_kerns;

print_new_lines :: ![{#Char}] !Int !Real !CharWidthAndKerns -> {#Char};
print_new_lines lines font_size width char_width_and_kerns
	= "T*\n"+++print_lines lines font_size width char_width_and_kerns;

has_link [TLink _:_] = True;
has_link [_:text_l] = has_link text_l;
has_link [] = False;

printTFont fs FCNo
	= fs;
printTFont fs FCBlack
	| size fs==0
		= "0 0 0 rg";
		= fs+++" 0 0 0 rg";
printTFont fs (FCRGB rgb)
	| size fs==0
		= rgb_8bit_last_t rgb;
		= fs+++" "+++rgb_8bit_last_t rgb;

print_format_lines :: !(![({#Char},Int,Int)],![Text]) !Int !Int !Real !{!CharWidthAndKerns} -> (!{#Char},![Link]);
print_format_lines (lines_and_slices,text_l) font_size font_n width char_width_and_kerns
	= print_format_lines lines_and_slices text_l 0 0 font_size font_n width char_width_and_kerns;
where {
	print_format_lines :: ![({#Char},Int,Int)] ![Text] !Int !Int !Int !Int !Real !{!CharWidthAndKerns} -> (!{#Char},![Link]);
	print_format_lines [(line,first_i,end_i)] text_l index line_n font_size font_n width char_width_and_kerns
		| has_link text_l
			= print_format_last_line_link 0 0 first_i text_l index line_n font_n line end_i char_width_and_kerns;
			= (print_format_last_line_no_link 0 first_i text_l index font_n line end_i char_width_and_kerns,[]);
	print_format_lines lines_and_slices=:[(line,first_i,end_i):_] [TString s:text_l] index line_n font_size font_n width char_width_and_kerns
		# index = index+size s;
		= print_format_lines lines_and_slices text_l index line_n font_size font_n width char_width_and_kerns;
	print_format_lines lines_and_slices=:[(line,first_i,end_i):_] [TLink s:text_l] index line_n font_size font_n width char_width_and_kerns
		# index = index+size s;
		= print_format_lines lines_and_slices text_l index line_n font_size font_n width char_width_and_kerns;
	print_format_lines lines_and_slices=:[(line,first_i,end_i):next_lines_and_slices] text_l=:[TFont next_font_n fs fc:next_text_l] index line_n font_size font_n width char_width_and_kerns
		// index<first_i is possible if a space at the end of a line is removed
		| index<=first_i
			# next_font_n = if (next_font_n>=0) next_font_n font_n;
			# (t_s,link_l)
				= print_format_lines lines_and_slices next_text_l index line_n font_size next_font_n width char_width_and_kerns;
			= (printTFont fs fc+++" "+++t_s,link_l);
		| index>=end_i
			# (t_s,link_l) = print_format_lines next_lines_and_slices text_l index (line_n+1) font_size font_n width char_width_and_kerns;
			= (print_justified_line line font_size width char_width_and_kerns.[font_n]+++t_s,link_l);
			# (k_line,line_width,index,font_n,text_l,link_l)
				= print_format_line_and_compute_width 0 0 first_i text_l index font_n line end_i char_width_and_kerns;
			# n_line_spaces = count_spaces 0 0 line;
			# word_spacing
				= if (n_line_spaces<>0)
					((1000.0*width-toReal (font_size*line_width))/(toReal n_line_spaces*1000.0))
					0.0;
			# link_l = [{link & link_line_word_spacing=word_spacing,
								link_begin_pos=link_begin_pos+link_line_word_spacing*word_spacing,
								link_y_pos=line_n} \\ link=:{link_begin_pos,link_line_word_spacing}<-link_l];
			# (t_s,link_l2)
				= print_format_lines next_lines_and_slices text_l index (line_n+1) font_size font_n width char_width_and_kerns;
			= (toString word_spacing+++" Tw "+++k_line+++"0 Tw "+++"T*\n"+++t_s,link_l++link_l2);
	print_format_lines lines_and_slices [] index line_n font_size font_n width char_width_and_kerns
		# t_s = print_lines [line\\(line,_,_)<-lines_and_slices] font_size width char_width_and_kerns.[font_n];
		= (t_s,[]);

	print_format_line_and_compute_width :: !Int !Int !Int ![Text] !Int !Int !{#Char} !Int !{!CharWidthAndKerns}
										-> (!{#Char},!Int,!Int,!Int,![Text],![Link]);
	print_format_line_and_compute_width line_start_i line_begin_width first_i [TString s:text_l] index font_n line end_i char_width_and_kerns
		# index = index+size s;
		= print_format_line_and_compute_width line_start_i line_begin_width first_i text_l index font_n line end_i char_width_and_kerns;
	print_format_line_and_compute_width line_start_i line_begin_width first_i [TLink s:text_l] index font_n line end_i char_width_and_kerns		
		# n_spaces_before_link = count_spaces_before 0 0 line_start_i line;
		# link = {link_begin_pos = (toReal (line_begin_width*font_size))/1000.0,
				  link_line_word_spacing = toReal n_spaces_before_link, link_y_pos = 0, // overwritten by print_format_lines
				  link_extra_margin = 0.0,
				  link_font_n = font_n, link_font_size = font_size, link_s = s};

		# index = index+size s;
		# (k_lines,line_width,index,next_font_n,text_l,link_l)
			= print_format_line_and_compute_width line_start_i line_begin_width first_i text_l index font_n line end_i char_width_and_kerns;
		# link_l = [link:link_l]
		= (k_lines,line_width,index,next_font_n,text_l,link_l);
	print_format_line_and_compute_width line_start_i line_begin_width first_i text_l=:[TFont next_font_n fs fc:next_text_l] index font_n line end_i char_width_and_kerns
		| index<=first_i
			# next_font_n = if (next_font_n>=0) next_font_n font_n;
			# (k_lines,line_width,index,next_font_n,text_l,link_l)
				= print_format_line_and_compute_width line_start_i line_begin_width first_i next_text_l index next_font_n line end_i char_width_and_kerns;
			= (printTFont fs fc+++" "+++k_lines,line_width,index,next_font_n,text_l,link_l);
		| index>=end_i
			# rest_of_line = if (line_start_i==0) line (line % (line_start_i,size line-1));
			# line_width = string_width rest_of_line char_width_and_kerns.[font_n];
			= (print_formatted_string rest_of_line char_width_and_kerns.[font_n],line_begin_width+line_width,index,font_n,text_l,[]);
			# line_part_before_TFont = line % (line_start_i,line_start_i+index-first_i-1);
			# line_part_before_TFont_width = string_width line_part_before_TFont char_width_and_kerns.[font_n];
			# (uses_kerning,k_line) = add_kerning 0 line_part_before_TFont char_width_and_kerns.[font_n];
			# next_font_n = if (next_font_n>=0) next_font_n font_n;
			# line_start_i = line_start_i+index-first_i;
			# (k_lines,line_width,index,next_font_n,text_l,link_l)
				= print_format_line_and_compute_width line_start_i (line_begin_width+line_part_before_TFont_width) index next_text_l index next_font_n line end_i char_width_and_kerns;
			| uses_kerning
				= ("[("+++k_line+++")]TJ " +++printTFont fs fc+++" "+++k_lines,line_width,index,next_font_n,text_l,link_l);
				= ("("+++k_line+++")Tj " +++printTFont fs fc+++" "+++k_lines,line_width,index,next_font_n,text_l,link_l);
	print_format_line_and_compute_width line_start_i line_begin_width first_i [] index font_n line end_i char_width_and_kerns
		# rest_of_line = if (line_start_i==0) line (line % (line_start_i,size line-1));
		# line_width = string_width rest_of_line char_width_and_kerns.[font_n];
		= (print_formatted_string rest_of_line char_width_and_kerns.[font_n],line_begin_width+line_width,index,font_n,[],[]);

	print_format_last_line_link :: !Int !Int !Int ![Text] !Int !Int !Int !{#Char} !Int !{!CharWidthAndKerns} -> (!{#Char},![Link]);
	print_format_last_line_link line_start_i line_begin_width first_i [TString s:text_l] index line_n font_n line end_i char_width_and_kerns
		# index = index+size s;
		= print_format_last_line_link line_start_i line_begin_width first_i text_l index line_n font_n line end_i char_width_and_kerns;
	print_format_last_line_link line_start_i line_begin_width first_i [TLink s:text_l] index line_n font_n line end_i char_width_and_kerns
		# link = {link_begin_pos = (toReal (line_begin_width*font_size))/1000.0, link_line_word_spacing = 0.0,
				  link_extra_margin = 0.0,
				  link_y_pos = line_n, link_font_n = font_n, link_font_size = font_size, link_s = s};

		# index = index+size s;
		# (t_s,link_l) = print_format_last_line_link line_start_i line_begin_width first_i text_l index line_n font_n line end_i char_width_and_kerns;
		= (t_s,[link:link_l]);
	print_format_last_line_link line_start_i line_begin_width first_i text_l=:[TFont next_font_n fs fc:next_text_l] index line_n font_n line end_i char_width_and_kerns
		| index<=first_i
			# next_font_n = if (next_font_n>=0) next_font_n font_n;
			# (t_s,link_l) = print_format_last_line_link line_start_i line_begin_width first_i next_text_l index line_n next_font_n line end_i char_width_and_kerns;
			= (printTFont fs fc+++" "+++t_s,link_l);
		| index>=end_i
			&& (index==end_i || trace_t "print_format_last_line_link " && trace_t index && trace_t ' ' && trace_tn end_i)
			# rest_of_line = if (line_start_i==0) line (line % (line_start_i,size line));
			= (print_formatted_string rest_of_line char_width_and_kerns.[font_n]+++print_fonts text_l,[]);
			# line_part_before_TFont = line % (line_start_i,line_start_i+index-first_i-1);
			# line_part_before_TFont_width = string_width line_part_before_TFont char_width_and_kerns.[font_n];
			# next_font_n = if (next_font_n>=0) next_font_n font_n;
			# (uses_kerning,k_line) = add_kerning 0 (line % (line_start_i,line_start_i+index-first_i-1)) char_width_and_kerns.[font_n];
			# line_start_i = line_start_i+index-first_i;
			# (t_s,link_l)
				= print_format_last_line_link line_start_i (line_begin_width+line_part_before_TFont_width) index next_text_l index line_n next_font_n line end_i char_width_and_kerns;
			| uses_kerning
				= ("[("+++k_line+++")]TJ " +++printTFont fs fc+++" "+++t_s,link_l);
				= ("("+++k_line+++")Tj " +++printTFont fs fc+++" "+++t_s,link_l);
	print_format_last_line_link line_start_i line_begin_width first_i [] index line_n font_n line end_i char_width_and_kerns
		# rest_of_line = if (line_start_i==0) line (line % (line_start_i,size line));
		= (print_formatted_string rest_of_line char_width_and_kerns.[font_n],[]);

	print_format_last_line_no_link :: !Int !Int ![Text] !Int !Int !{#Char} !Int !{!CharWidthAndKerns} -> {#Char};
	print_format_last_line_no_link line_start_i first_i [TString s:text_l] index font_n line end_i char_width_and_kerns
		# index = index+size s;
		= print_format_last_line_no_link line_start_i first_i text_l index font_n line end_i char_width_and_kerns;
	print_format_last_line_no_link line_start_i first_i text_l=:[TFont next_font_n fs fc:next_text_l] index font_n line end_i char_width_and_kerns
		| index<=first_i
			# next_font_n = if (next_font_n>=0) next_font_n font_n;
			= printTFont fs fc+++" "+++
			  print_format_last_line_no_link line_start_i first_i next_text_l index next_font_n line end_i char_width_and_kerns;
		| index>=end_i
			&& (index==end_i || trace_t "print_format_last_line_no_link " && trace_t index && trace_t ' ' && trace_tn end_i)
			# rest_of_line = if (line_start_i==0) line (line % (line_start_i,size line));
			= print_formatted_string rest_of_line char_width_and_kerns.[font_n]+++print_fonts text_l;
			# next_font_n = if (next_font_n>=0) next_font_n font_n;
			# (uses_kerning,k_line) = add_kerning 0 (line % (line_start_i,line_start_i+index-first_i-1)) char_width_and_kerns.[font_n];
			# line_start_i = line_start_i+index-first_i;
			| uses_kerning
				= "[("+++k_line+++")]TJ " +++printTFont fs fc+++" "+++
					print_format_last_line_no_link line_start_i index next_text_l index next_font_n line end_i char_width_and_kerns;
				= "("+++k_line+++")Tj " +++printTFont fs fc+++" "+++
					print_format_last_line_no_link line_start_i index next_text_l index next_font_n line end_i char_width_and_kerns;
	print_format_last_line_no_link line_start_i first_i [] index font_n line end_i char_width_and_kerns
		# rest_of_line = if (line_start_i==0) line (line % (line_start_i,size line));
		= print_formatted_string rest_of_line char_width_and_kerns.[font_n];

	print_fonts [TFont _ fs fc:text_l]
		= printTFont fs fc+++" "+++print_fonts text_l;
	print_fonts [_:text_l]
		= print_fonts text_l;
	print_fonts []
		= "";
}

print_new_indented_lines :: ![{#Char}] !Int !Real !Real !CharWidthAndKerns -> {#Char};
print_new_indented_lines lines font_size indent_width width char_width_and_kerns
	= "T*\n"+++toString indent_width+++" 0 Td "+++
	  print_lines lines font_size width char_width_and_kerns+++
	  toString (~indent_width)+++" 0 Td ";

concat_text_strings [TString s] = s;
concat_text_strings [TLink s] = s;
concat_text_strings [_] = "";
concat_text_strings [TString s:sl] = s+++concat_text_strings sl;
concat_text_strings [TLink s:sl] = s+++concat_text_strings sl;
concat_text_strings [_:sl] = concat_text_strings sl;
concat_text_strings [] = "";

compute_max_column_widths :: ![[([(Int,Int,Int,Int)],Int)]] !Int ![[[Text]]] -> [Int];
compute_max_column_widths [row_widths:rows_widths] column_space_in_font_units [row:rows]
	= adjust_max_column_widths (compute_row_element_widths row row_widths column_space_in_font_units) rows_widths rows column_space_in_font_units;

compute_row_element_widths elements=:[_,[]:elements2] row_widths=:[(_,width),_:_] column_space_in_font_units
	// to do subtract column_space
	# n_nil_elements_at_begining = count_n_nil_elements_at_begining elements2;
	= compute_merge_row_element_widths (2+n_nil_elements_at_begining) width elements row_widths column_space_in_font_units;
compute_row_element_widths [_:elements] [(_,width):row_widths] column_space_in_font_units
	= [width : compute_row_element_widths elements row_widths column_space_in_font_units];
compute_row_element_widths [] [] column_space_in_font_units
	= [];

count_n_nil_elements_at_begining [[]:l] = 1+count_n_nil_elements_at_begining l;
count_n_nil_elements_at_begining _ = 0;

compute_merge_row_element_widths 1 width [_:elements] [_:row_widths] column_space_in_font_units
	= [width : compute_row_element_widths elements row_widths column_space_in_font_units];
compute_merge_row_element_widths n width [_:elements] [_:row_widths] column_space_in_font_units
	# element_width = (width - column_space_in_font_units*(n-1)) / n;
	# element_width = if (element_width<0) 0 element_width;
	# next_width = width-element_width-column_space_in_font_units;
	# next_width = if (next_width<0) 0 next_width;
	= [element_width : compute_merge_row_element_widths (n-1) next_width elements row_widths column_space_in_font_units];

adjust_max_column_widths :: ![Int] ![[([(Int,Int,Int,Int)],Int)]] ![[[Text]]] !Int -> [Int];
adjust_max_column_widths max_row [row_widths:rows_widths] [row:rows] column_space_in_font_units
	# max_row = [if (a>b) a b \\ a<-max_row & b<-compute_row_element_widths row row_widths column_space_in_font_units];
	= adjust_max_column_widths max_row rows_widths rows column_space_in_font_units;
adjust_max_column_widths max_row [] [] column_space_in_font_units
	= max_row;

show_row [e_text_l:e_text_ls] [max_column_width:max_column_widths] x_pos column_space font_size font_n char_width_and_kerns
	# p_lines = concat_text_strings e_text_l;
	# lines_and_slices = [(p_lines,0,size p_lines)];
	// to do Link list
	# (t_s,link_l) = print_format_lines (lines_and_slices,e_text_l) font_size font_n (toReal max_column_width) char_width_and_kerns;

	# link_l = [{link & link_begin_pos=link_begin_pos+x_pos} \\ link=:{link_begin_pos}<-link_l];

	# column_width = toReal ((toReal font_size*toReal max_column_width)/1000.0) + toReal column_space;
	# x_pos = x_pos + column_width;
	# (r_s,link_l_r) = show_row e_text_ls max_column_widths x_pos column_space font_size font_n char_width_and_kerns;
	= (t_s+++toString column_width+++" 0 Td "+++r_s,link_l++link_l_r);
show_row [] [] x_pos column_space font_size font_n char_width_and_kerns
	= (toString (~x_pos)+++" 0 Td ",[]);

print_table :: ![[[Text]]] ![Int] !Int !Int !Int !{!CharWidthAndKerns} -> (!{#Char},![Link]);
print_table rows max_column_widths column_space font_size font_n char_width_and_kerns
	= print_rows rows 0 max_column_widths column_space font_size font_n char_width_and_kerns;
{
	print_rows :: ![[[Text]]] !Int ![Int] !Int !Int !Int !{!CharWidthAndKerns} -> (!{#Char},![Link]);
	print_rows [row:rows] row_n max_column_widths column_space font_size font_n char_width_and_kerns
		# (r_s,link_l_r) = show_row row max_column_widths 0.0 column_space font_size font_n char_width_and_kerns;
		# link_l_r = [{link & link_y_pos=link_y_pos+row_n} \\ link=:{link_y_pos}<-link_l_r];
		# (t_s,link_l_t) = print_rows rows (row_n+1) max_column_widths column_space font_size font_n char_width_and_kerns;
		= ("T*\n"+++r_s+++t_s,link_l_r++link_l_t);
	print_rows [] row_n max_column_widths column_space font_size font_n char_width_and_kerns
		= ("",[]);
}

make_table :: ![[[Text]]] !Int !Int !Int !{!CharWidthAndKerns} -> (!{#Char},![Link]);
make_table table column_space font_size font_n char_width_and_kerns
	# table_widths = [[text_words_width text_l font_n char_width_and_kerns\\text_l<-row]\\row<-table];
	# max_column_widths = compute_max_column_widths table_widths (column_space *1000/font_size) table;
	= print_table table max_column_widths column_space font_size font_n char_width_and_kerns;

compute_table_widths_with_min_widths :: ![[[Text]]] ![Int] !Int !Int !Int !{!CharWidthAndKerns} -> [Int];
compute_table_widths_with_min_widths table min_widths column_space font_size font_n char_width_and_kerns
	# table_widths = [[text_words_width text_l font_n char_width_and_kerns\\text_l<-row]\\row<-table];
	# n_table_rows = length (hd table);
	# n_min_widths = length min_widths;
	# min_widths = [(min_width*1000)/font_size\\min_width<-min_widths];
	# min_widths = if (n_min_widths<n_table_rows) (min_widths++repeatn (n_table_rows-n_min_widths) 0) min_widths;
	= adjust_max_column_widths min_widths table_widths table (column_space*1000/font_size);

make_table_min_widths :: ![[[Text]]] ![Int] !Int !Int !Int !{!CharWidthAndKerns} -> (!{#Char},![Link]);
make_table_min_widths table min_widths column_space font_size font_n char_width_and_kerns
	# max_column_widths = compute_table_widths_with_min_widths table min_widths column_space font_size font_n char_width_and_kerns;
	= print_table table max_column_widths column_space font_size font_n char_width_and_kerns;

rgb_8bit_last :: !Int !Int !Int -> {#Char};
rgb_8bit_last r g b
	# r_s = toString (toReal r/255.0)+++" ";
	# g_s = toString (toReal g/255.0)+++" ";
	# b_s = toString (toReal b/255.0)+++" ";
	= r_s+++g_s+++b_s+++"rg";

rgb_8bit_last_t :: !(!Int,!Int,!Int) -> {#Char};
rgb_8bit_last_t (r,g,b)
	= rgb_8bit_last r g b;
