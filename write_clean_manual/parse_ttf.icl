implementation module parse_ttf;

import StdEnv;

swap :: !Int -> Int;
swap i
	# i=(i<<16) bitor ((i>>16) bitand 0xffff);
	# i=((i<<8) bitand 0xff00ff00) bitor ((i>>8) bitand 0x00ff00ff);
	= i;

freadi8 :: !*File -> (!Int,!*File);
freadi8 file
	# (ok,c,file) = freadc file;
	| not ok
		= abort "freadi8";
	= (toInt c,file);

freadi16 :: !*File -> (!Int,!*File);
freadi16 file
	# (ok,c1,file) = freadc file;
	| not ok
		= abort "freadi16";
	# (ok,c2,file) = freadc file;
	| not ok
		= abort "freadi16";
	= ((toInt c1<<8)+toInt c2,file);

freadsi16 :: !*File -> (!Int,!*File);
freadsi16 file
	# (i,file) = freadi16 file;
	= ((i bitand 0x7fff)-(i bitand 0x8000),file);

freadi32 :: !*File -> (!Int,!*File);
freadi32 file
	# (ok,i,file) = freadi file;
	| not ok
		= abort "freadi32";
	= (swap i,file);

/*
https://developer.apple.com/fonts/TrueType-Reference-Manual/RM06/Chap6.html#Intro

The values 'true' (0x74727565) and 0x00010000 are recognized by OS X and iOS as referring to TrueType fonts.
The value 'typ1' (0x74797031) is recognized as referring to the old style of PostScript font housed in a sfnt
wrapper. 
The value 'OTTO' (0x4F54544F) indicates an OpenType font with PostScript outlines (that is, a 'CFF ' table
nstead of a 'glyf' table).
Other values are not currently supported.
*/

read_tables :: Int *File -> ([({#Char},Int,Int,Int)],*File);
read_tables 0 file
	= ([],file);
read_tables n file
	# (tag,file) = freads file 4;
	# (check_sum,file) = freadi32 file;
	# (offset,file) = freadi32 file;
	# (length,file) = freadi32 file;
	# (tables,file) = read_tables (n-1) file;
	= ([(tag,check_sum,offset,length):tables],file);

read_head :: [({#Char},a,Int,b)] *File -> (((Int,Int,Int,Int),Int,Int,(Int,Int,Int,Int),(Int,Int,Int,Int),Int,(Int,Int,Int,Int)),*File);
read_head tables file
	# (check_sum,offset,length)
		= hd [(check_sum,offset,length) \\ (tag,check_sum,offset,length)<-tables | tag=="head"]
	# (ok,file) = fseek file offset FSeekSet;
	| not ok
		= abort "fseek failed";
	# (version,file) = freadi32 file;
	# (font_revision,file) = freadi32 file;
	# (check_sum_adjustment,file) = freadi32 file;
	# (magic_number,file) = freadi32 file;
	# (flags,file) = freadi16 file;
	# (units_per_em,file) = freadi16 file;
	# (created_0,file) = freadi32 file;
	# (created_1,file) = freadi32 file;
	# (modified_0,file) = freadi32 file;
	# (modified_1,file) = freadi32 file;
	# (x_min,file) = freadsi16 file;
	# (y_min,file) = freadsi16 file;
	# (x_max,file) = freadsi16 file;
	# (y_max,file) = freadsi16 file;
	# (mac_style,file) = freadi16 file;
	# (lowest_rec_ppem,file) = freadi16 file;
	# (font_direction_hint,file) = freadi16 file;
	# (index_to_loc_format,file) = freadi16 file;
	# (glyph_data_format,file) = freadi16 file;
	= (((version,font_revision,check_sum_adjustment,magic_number),
		flags,units_per_em,(created_0,created_1,modified_0,modified_1),
		(x_min,y_min,x_max,y_max),
		mac_style,
		(lowest_rec_ppem,font_direction_hint,index_to_loc_format,glyph_data_format)),
		file);

read_hhea :: [({#Char},a,Int,b)] !*File -> ((Int,Int,Int,Int,Int,Int,Int,Int,Int),*File);
read_hhea tables file
	# (check_sum,offset,length)
		= hd [(check_sum,offset,length) \\ (tag,check_sum,offset,length)<-tables | tag=="hhea"]
	# (ok,file) = fseek file offset FSeekSet;
	| not ok
		= abort "fseek failed";
	# (version,file) = freadi32 file;
	# (ascent,file) = freadsi16 file;
	# (descent,file) = freadsi16 file;
	# (line_gap,file) = freadsi16 file;
	# (advance_width_max,file) = freadi16 file;
	# (min_left_side_bearing,file) = freadsi16 file;
	# (min_right_side_bearing,file) = freadsi16 file;
	# (max_extent,file) = freadsi16 file;
	# (caret_slope_rise,file) = freadi16 file;
	# (caret_slope_run,file) = freadi16 file;
	# (caret_offset,file) = freadi16 file;
	# (_,file) = freadi16 file;
	# (_,file) = freadi16 file;
	# (_,file) = freadi16 file;
	# (_,file) = freadi16 file;
	# (metric_data_format,file) = freadi16 file;
	# (num_of_long_hor_metrics,file) = freadi16 file;
	= ((version,ascent,descent,line_gap,advance_width_max,min_left_side_bearing,min_right_side_bearing,
		max_extent,num_of_long_hor_metrics),file);

read_maxp :: ![({#Char},a,Int,Int)] !*File -> ((Int,Int,[((Int,Int,Int,Int),(Int,Int),(Int,Int,Int,Int,Int),(Int,Int))]),*File);
read_maxp tables file
	# (check_sum,offset,length)
		= hd [(check_sum,offset,length) \\ (tag,check_sum,offset,length)<-tables | tag=="maxp"]
	# (ok,file) = fseek file offset FSeekSet;
	| not ok
		= abort "fseek failed";
	# (version,file) = freadi32 file;
	# (num_glyphs,file) = freadi16 file;
	| length==6 // open type font
		= ((version,num_glyphs,[]),file);
	# (max_points,file) = freadi16 file;
	# (max_contours,file) = freadi16 file;
	# (max_component_points,file) = freadi16 file;
	# (max_component_contours,file) = freadi16 file;
	# (max_zones,file) = freadi16 file;
	# (max_twilight_points,file) = freadi16 file;
	# (max_storage,file) = freadi16 file;
	# (max_function_defs,file) = freadi16 file;
	# (max_instruction_defs,file) = freadi16 file;
	# (max_stack_elements,file) = freadi16 file;
	# (max_size_of_instructions,file) = freadi16 file;
	# (max_component_elements,file) = freadi16 file;
	# (max_component_depth,file) = freadi16 file;
	= ((version,num_glyphs,[
		((max_points,max_contours,max_component_points,max_component_contours),
		 (max_zones,max_twilight_points),
		 (max_storage,max_function_defs,max_instruction_defs,max_stack_elements,max_size_of_instructions),
		 (max_component_elements,max_component_depth)
		)
	]),file);

read_hmtx :: [({#Char},a,Int,Int)] Int Int *File -> ((Int,Int,{!(Int,Int)},[Int]),*File);
read_hmtx tables num_of_long_hor_metrics num_glyphs file
	# (check_sum,offset,length)
		= hd [(check_sum,offset,length) \\ (tag,check_sum,offset,length)<-tables | tag=="hmtx"]
	# (ok,file) = fseek file offset FSeekSet;
	| not ok
		= abort "fseek failed";
	# left_side_bearing_a_size = (length-4*num_of_long_hor_metrics)/2;
	| left_side_bearing_a_size<>num_glyphs-num_of_long_hor_metrics
		= abort "read_hmtx";
	# (hor_metrics,file) = read_hormetrics num_of_long_hor_metrics file;
	# (lef_side_bearings,file) = read_left_side_bearings left_side_bearing_a_size file;
	# hor_metrics_a = {!e\\e<-hor_metrics};
	= ((num_of_long_hor_metrics,left_side_bearing_a_size,hor_metrics_a,lef_side_bearings),file);

read_hormetrics :: Int *File -> ([(Int,Int)],*File);
read_hormetrics n file
	| n>0
		# (advance_width,file) = freadi16 file;
		# (left_side_bearing,file) = freadsi16 file;
		# (hormetrics,file) = read_hormetrics (n-1) file;
		= ([(advance_width,left_side_bearing):hormetrics],file);
		= ([],file);

read_left_side_bearings :: !Int *File -> ([Int],*File);
read_left_side_bearings n file
	| n>0
		# (left_side_bearing,file) = freadsi16 file;
		# (left_side_bearings,file) = read_left_side_bearings (n-1) file;
		= ([left_side_bearing:left_side_bearings],file);
		= ([],file);

read_cmap_windows_bmp :: [({#Char},a,Int,b)] *File -> ((Int,Int,[(Int,Int,Int,{#Char})],Int,(Int,Int,Int,Int,[(Int,Int,Int,Int,{#Int})])),*File);
read_cmap_windows_bmp tables file
	# (check_sum,offset,length)
		= hd [(check_sum,offset,length) \\ (tag,check_sum,offset,length)<-tables | tag=="cmap"]
	# (ok,file) = fseek file offset FSeekSet;
	| not ok
		= abort "fseek failed";
	# (version,file) = freadi16 file;
	# (number_subtables,file) = freadi16 file;
	# (cmap_subtables,file) = read_cmap_subtable_list number_subtables file;
	
	# cmap_subtable=:(_,_,subtable_offset,_) = get_windows_bmp_subtable cmap_subtables
		
	# (subtable,file) = read_cmap_subtable subtable_offset offset file;
	= ((version,number_subtables,cmap_subtables,subtable_offset,subtable),file);

get_windows_bmp_subtable :: [(Int,Int,Int,{#Char})] -> (Int,Int,Int,{#Char});
get_windows_bmp_subtable [cmap_subtable=:(3,1,a,b):_]
	= (3,1,a,b);
get_windows_bmp_subtable [_:cmap_subtables]
	= get_windows_bmp_subtable cmap_subtables;

read_cmap_subtable_list :: Int *File -> ([(Int,Int,Int,{#Char})],*File);
read_cmap_subtable_list 0 file
	= ([],file);
read_cmap_subtable_list n_subtables file
	# (platform_id,file) = freadi16 file;
	# (platform_specific_id,file) = freadi16 file;
	# (offset,file) = freadi32 file;
	# (cmp_subtables,file) = read_cmap_subtable_list (n_subtables-1) file;
	= ([(platform_id,platform_specific_id,offset,
		decode_platform platform_id platform_specific_id+++"\n"):cmp_subtables],file);

read_cmap_subtable :: Int Int *File -> ((Int,Int,Int,Int,[(Int,Int,Int,Int,{#Int})]),*File);
read_cmap_subtable subtable_offset offset file
	# (ok,file) = fseek file (offset+subtable_offset) FSeekSet;
	| not ok
		= abort "fseek failed in read_cmap_subtable";
	# (format,file) = freadi16 file;
	# (length,file) = freadi16 file;
	# (language,file) = freadi16 file;
	# (cmap_mapping,file) = read_cmap_mapping format length file;
	= ((subtable_offset,format,length,language,cmap_mapping),file);

decode_platform 0 3 = "Unicode 2.0 (BMP only)";
decode_platform 0 _ = "Unicode";
decode_platform 1 _ = "Macintosh";
decode_platform 3 1 = "Microsoft Unicode BMP only (UCS-2)";
decode_platform 3 _ = "Microsoft";
decode_platform _ _ = "?";

read_int8_table :: Int Int *File -> ([Int],*File);
read_int8_table i n file
	| i<n
		# (ok,c,file) = freadc file;
		| not ok
			= abort "freadc failed in read_int8_table";
		# e = toInt c;
		# (es,file) = read_int8_table (i+1) n file;
		= ([e:es],file);
		= ([],file);

read_int16_table :: Int Int *File -> ([Int],*File);
read_int16_table i n file
	| i<n
		# (e,file) = freadi16 file;
		# (es,file) = read_int16_table (i+1) n file;
		= ([i:es],file);
		= ([],file);

int16_from_string :: !Int !{#Char} -> Int;
int16_from_string i s
	= (toInt s.[i]<<8)+toInt s.[i+1];

int32_from_string :: !Int !{#Char} -> Int;
int32_from_string i s
	= (toInt s.[i]<<24)+(toInt s.[i+1]<<16)+(toInt s.[i+2]<<8)+toInt s.[i+3];

signed_int16_from_string :: !Int !{#Char} -> Int;
signed_int16_from_string i s
	# i = (toInt s.[i]<<8)+toInt s.[i+1];
	= (i bitand 0x7fff)-(i bitand 0x8000);

read_cmap_mapping :: Int Int *File -> ([(Int,Int,Int,Int,{#Int})],*File);
read_cmap_mapping 0 262 file
	# (a,file) = read_int8_table 0 256 file;
	= ([(0,256,0,0,{e\\e<-a})],file);
read_cmap_mapping 4 length file
	# (seg_count_x2,file) = freadi16 file;
	# (search_range,file) = freadi16 file;
	# (entry_selector,file) = freadi16 file;
	# (range_shift,file) = freadi16 file;
	# (end_code_s,file) = freads file seg_count_x2;
	# (reserved_pad,file) = freadi16 file;
	| reserved_pad<>0
		= abort "reserved_pad<>0 in read_cmap_mapping";
	# (start_code_s,file) = freads file seg_count_x2;
	# (id_delta_s,file) = freads file seg_count_x2;
	# (id_range_offset_s,file) = freads file seg_count_x2;
	| size end_code_s<>seg_count_x2 ||
	  size start_code_s<>seg_count_x2 ||
	  size id_delta_s<>seg_count_x2 ||
	  size id_range_offset_s<>seg_count_x2
		= abort "freads failed in read_cmap_mapping";
	# glyph_index_array_size_bytes = length-16-4*seg_count_x2;
	# (glyph_index_array,file) = freads file glyph_index_array_size_bytes;
	# segments = [	(int16_from_string i start_code_s,int16_from_string i end_code_s,
					 int16_from_string i id_delta_s,  int16_from_string i id_range_offset_s)
					\\ i<-[0,2..seg_count_x2-2]	];
					
	# segments = [(start_code,end_code,
					if (start_code+id_delta<65536) id_delta (id_delta-65536),id_range_offset,
					if (id_range_offset==0)
						{}
						(glyph_indices (id_range_offset-i) start_code (1+end_code) glyph_index_array)
					)
					\\ (start_code,end_code,id_delta,id_range_offset) <- segments & i<-[seg_count_x2,seg_count_x2-2..2]];
	= (segments,file);
read_cmap_mapping 6 length file
	# (first_code,file) = freadi16 file;
	# (entry_count,file) = freadi16 file;
	| entry_count*2+10==length
		# (a,file) = read_int16_table first_code (first_code+entry_count) file;
		= ([(first_code,entry_count,0,0,{e\\e<-a})],file);
read_cmap_mapping format length file
	= ([],file);

glyph_indices :: !Int !Int !Int !{#Char} -> {#Int};
glyph_indices start_i start_c stop_c glyph_index_array
	= {int16_from_string i glyph_index_array \\ c<-[start_c..stop_c-1] & i<-[start_i,start_i+2..] };

read_kern :: [({#Char},a,Int,b)] *File -> ([(Int,Int,Int,Int,Int,[(Int,(Int,Int,Int),[(Int,Int,Int)])])],*File);
read_kern tables file
	= case [(check_sum,offset,length) \\ (tag,check_sum,offset,length)<-tables | tag=="kern"] of {
		[]
			-> ([],file);
		[(check_sum,offset,length):_]
			# (ok,file) = fseek file offset FSeekSet;
			| not ok
				-> abort "fseek failed";
			# (version,file) = freadi16 file;
			# (n_tables,file) = freadi16 file;
			-> read_kern_subtables version n_tables file;
	};

// use documentation of microsoft not apple
read_kern_subtables :: .a .b *File -> ([(.a,.b,Int,Int,Int,[(Int,(Int,Int,Int),[(Int,Int,Int)])])],*File);
read_kern_subtables version n_tables file
	# (version2,file) = freadi16 file;
	# (length,file) = freadi16 file;
	# (coverage,file) = freadi16 file;
	# kern_format = coverage>>8;
	| kern_format<>0
		= ([(version,n_tables,version2,length,coverage,[])],file);
	# (n_pairs,file) = freadi16 file;
	# (search_range,file) = freadi16 file;
	# (entry_selector,file) = freadi16 file;
	# (range_shift,file) = freadi16 file;
	# (kern_pairs,file) = read_kern_pairs n_pairs file;
	= ([(version,n_tables,version2,length,coverage,[
		(n_pairs,(search_range,entry_selector,range_shift),kern_pairs)
	])],file);

read_kern_pairs :: !Int *File -> ([(Int,Int,Int)],*File);
read_kern_pairs n file
	| n>0
		# (left,file) = freadi16 file;
		# (right,file) = freadi16 file;
		# (value,file) = freadsi16 file;
		# (kern_pairs,file) = read_kern_pairs (n-1) file;
		= ([(left,right,value):kern_pairs],file);
		= ([],file);

parse_ttf_file :: !{#Char} !(Int->Int) !*World -> (!{!(Int,Int,[(Int,Int)])},!*World);
parse_ttf_file file_name unicode_to_adobe_encoding w
	# (ok,file,w) = fopen file_name FReadData w;
	| not ok
		= abort "fopen failed";
	# (major_version,file) = freadi16 file;
	  (minor_version,file) = freadi16 file;
	  (num_tables,file) = freadi16 file;
	  (search_range,file) = freadi16 file;
	  (entry_selector,file) = freadi16 file;
	  (range_shift,file) = freadi16 file;
	  (tables,file) = read_tables num_tables file;
	  (head,file) = read_head tables file;
	  (_,_,units_per_em,_,_,_,(_,_,index_to_loc_format,_)) = head;
	  (hhea,file) = read_hhea tables file;
	  (_,_,_,_,_,_,_,_,num_of_long_hor_metrics) = hhea;
	  (maxp,file) = read_maxp tables file;
	  (_,num_glyphs,_) = maxp;
	  (hmtx,file) = read_hmtx tables num_of_long_hor_metrics num_glyphs file;
	  (cmap,file) = read_cmap_windows_bmp tables file;
	  (kern,file) = read_kern tables file;
	  (ok,w) = fclose file w;
	
	  (num_of_long_hor_metrics,left_side_bearing_a_size,hor_metrics_a,lef_side_bearings) = hmtx;
	  (cmap_version,cmap_number_subtables,cmap_subtables,cmap_subtable_offset,subtables=:(_,_,_,_,cmap_ranges)) = cmap;

	  scaled_unicode_kern_pairs = convert_kern_pairs kern cmap_ranges units_per_em;
	  cmap_with_hor_metrics = add_hor_metrics_to_cmap cmap_ranges hor_metrics_a units_per_em;
	
	  char_widths_and_kerns = add_kerns_to_cmap_with_hor_metrics cmap_with_hor_metrics scaled_unicode_kern_pairs;

	  char_widths_and_kerns = to_adobe_encoding unicode_to_adobe_encoding char_widths_and_kerns;

	  char_widths_and_kerns_a = {!e\\e<-char_widths_and_kerns};
	= (char_widths_and_kerns_a,w);

add_hor_metrics_to_cmap :: [(Int,Int,Int,Int,{#Int})] {!(Int,Int)} Int -> [(Int,Int)];
add_hor_metrics_to_cmap [(start_code,end_code,delta,0,_):cmps] hor_metrics_a units_per_em
	= add_hor_metrics_to_cmap_range start_code end_code delta hor_metrics_a units_per_em ++ add_hor_metrics_to_cmap cmps hor_metrics_a units_per_em;
add_hor_metrics_to_cmap [(start_code,end_code,delta,offset,char_code_and_glyph_n_a):cmps] hor_metrics_a units_per_em
	= add_hor_metrics_to_cmap_range_a 0 start_code char_code_and_glyph_n_a hor_metrics_a units_per_em ++ add_hor_metrics_to_cmap cmps hor_metrics_a units_per_em;
add_hor_metrics_to_cmap [] hor_metrics_a units_per_em
	= [];

add_hor_metrics_to_cmap_range :: Int Int Int {!(Int,Int)} Int -> [(Int,Int)];
add_hor_metrics_to_cmap_range char_code end_code delta hor_metrics_a units_per_em
	| char_code>end_code
		= [];
		# glyph_n = char_code+delta;
		# glyph_n = if (glyph_n>=size hor_metrics_a) 0 glyph_n;
		# (hor_metric,_) = hor_metrics_a.[glyph_n];
		#! hor_metric = hor_metric;
		# hor_metric = to_1000_units_per_em hor_metric units_per_em;
		= [(char_code,hor_metric):add_hor_metrics_to_cmap_range (char_code+1) end_code delta hor_metrics_a units_per_em];

add_hor_metrics_to_cmap_range_a :: Int Int {#Int} {!(Int,Int)} Int -> [(Int,Int)];
add_hor_metrics_to_cmap_range_a i start_code char_code_and_glyph_n_a hor_metrics_a units_per_em
	| i<size char_code_and_glyph_n_a
		# glyph_n = char_code_and_glyph_n_a.[i];
		# glyph_n = if (glyph_n>=size hor_metrics_a) 0 glyph_n;
		# (hor_metric,_) = hor_metrics_a.[glyph_n];
		#! hor_metric = hor_metric;
		# hor_metric = to_1000_units_per_em hor_metric units_per_em;
		= [(start_code+i,hor_metric):add_hor_metrics_to_cmap_range_a (i+1) start_code char_code_and_glyph_n_a hor_metrics_a units_per_em];
		= [];

to_1000_units_per_em :: Int Int -> Int;
to_1000_units_per_em hor_metric units_per_em
	| units_per_em==2048
		| hor_metric>=0
//			= (hor_metric*125+255)/256;
			= (hor_metric*125+128)/256;
			= ~(~hor_metric*125+128)/256;
	| units_per_em==1000
		= hor_metric;

convert_kern_pairs :: [(a,b,c,d,e,[(f,g,[(Int,Int,Int)])])] [(Int,Int,Int,Int,{#Int})] Int -> [(Int,[(Int,Int)])];
convert_kern_pairs [(_,_,_,_,_,[(_,_,kern_pairs)])] cmap_ranges units_per_em
	# kern_pairs = merge_kern_pairs kern_pairs;
	= [(glyph_n_to_char_code a cmap_ranges,
		[(glyph_n_to_char_code b cmap_ranges,to_1000_units_per_em c units_per_em) \\ (b,c)<-ps])
		\\ (a,ps)<-kern_pairs];
convert_kern_pairs [] cmap_ranges units_per_em
	= [];

merge_kern_pairs :: [(Int,Int,Int)] -> [(Int,[(Int,Int)])];
merge_kern_pairs [(char_code1a,char_code1b,kern1):kern_pairs1=:[(char_code2a,char_code2b,kern2):kern_pairs2]]
	| char_code1a<>char_code2a
		= [(char_code1a,[(char_code1b,kern1)]) : merge_kern_pairs kern_pairs1];
		# (added_kerns,kern_pairs2) = add_kern_pairs char_code1a kern_pairs2;
		= [(char_code1a,[(char_code1b,kern1),(char_code2b,kern2):added_kerns]) : merge_kern_pairs kern_pairs2];
merge_kern_pairs [(char_code1a,char_code1b,kern1)]
	= [(char_code1a,[(char_code1b,kern1)])];
merge_kern_pairs []
	= [];

add_kern_pairs :: Int [(Int,Int,Int)] -> ([(Int,Int)],[(Int,Int,Int)]);
add_kern_pairs char_code [(char_code1a,char_code1b,kern1):kern_pairs]
	| char_code==char_code1a
		# (added_kerns,kern_pairs) = add_kern_pairs char_code kern_pairs;
		= ([(char_code1b,kern1):added_kerns],kern_pairs);
add_kern_pairs char_code kern_pairs
	= ([],kern_pairs);

add_kerns_to_cmap_with_hor_metrics :: [(Int,Int)] [(Int,[(Int,Int)])] -> [(Int,Int,[(Int,Int)])];
add_kerns_to_cmap_with_hor_metrics [(char,width):char_and_widths] kerns=:[(kern_char_a,char_kerns):kerns2]
	| char<kern_char_a
		= [(char,width,[]):add_kerns_to_cmap_with_hor_metrics char_and_widths kerns];
	| char==kern_char_a
		= [(char,width,char_kerns):add_kerns_to_cmap_with_hor_metrics char_and_widths kerns2];
add_kerns_to_cmap_with_hor_metrics [(char,width):char_and_widths] kerns=:[]
	= [(char,width,[]):add_kerns_to_cmap_with_hor_metrics char_and_widths kerns];
add_kerns_to_cmap_with_hor_metrics [] _
	= [];

glyph_n_to_char_code :: Int [(Int,Int,Int,Int,{#Int})] -> Int;
glyph_n_to_char_code glyph_n [(start_code,end_code,delta,0,_):cmps]
	# char_code = glyph_n-delta;
	| char_code<start_code
		= glyph_n_to_char_code glyph_n cmps;
//		= -1;
	| char_code<=end_code
		= char_code;
		= glyph_n_to_char_code glyph_n cmps;
glyph_n_to_char_code glyph_n [(start_code,end_code,delta,_,a):cmps]
	# i = find_array_elem 0 glyph_n a;
	| i<0
		= glyph_n_to_char_code glyph_n cmps;
		= start_code+i;
glyph_n_to_char_code glyph_n []
	= -1;

find_array_elem :: !Int !Int !{#Int} -> Int;
find_array_elem i e a
	| i<size a
		| a.[i]<>e
			= find_array_elem (i+1) e a;
			= i;
		= -1;

to_adobe_encoding :: (Int -> Int) ![(Int,Int,[(Int,Int)])] -> [(Int,Int,[(Int,Int)])];
to_adobe_encoding unicode_to_adobe_encoding char_widths_and_kerns
	= sort [(unicode_to_adobe_encoding c,w,
		sort [(unicode_to_adobe_encoding c,k)
				\\ (c,k)<-l | unicode_to_adobe_encoding c<256])
		\\ (c,w,l)<-char_widths_and_kerns | unicode_to_adobe_encoding c<256];
/*
extra_characters1
	= [(148,"lessequal"),(149,"greaterequal"),(98,"Adieresis"),(105,"aacute"),(108,"adieresis"),(124,"odieresis"),(120,"ntilde"),(121,"oacute")];

extra_characters2
	= ["sigma","tau","Sigma","Tau"];
*/
ls_unicode_to_adobe_encoding :: !Int -> Int;
ls_unicode_to_adobe_encoding 0x2022 = 183; // bullet
ls_unicode_to_adobe_encoding 0x2026 = 188; // ellipsis
ls_unicode_to_adobe_encoding 0x2264 = 128; // lessequal
ls_unicode_to_adobe_encoding 0x2265 = 129; // greaterequal
ls_unicode_to_adobe_encoding 0x03C3 = 130; // sigma
ls_unicode_to_adobe_encoding 0x03C4 = 131; // tau
ls_unicode_to_adobe_encoding 0x03A3 = 132; // Sigma
ls_unicode_to_adobe_encoding 0x03A4 = 133; // Tau
//ls_unicode_to_adobe_encoding 0x00C4 = 196; // Adieresis
//ls_unicode_to_adobe_encoding 0x00E1 = 225; // aacute
//ls_unicode_to_adobe_encoding 0x00E4 = 228; // adieresis
//ls_unicode_to_adobe_encoding 0x00F6 = 246; // odieresis
//ls_unicode_to_adobe_encoding 0x00F1 = 241; // ntilde
//ls_unicode_to_adobe_encoding 0x00F3 = 243; // oacute

ls_unicode_to_adobe_encoding 183 = 999999999; // bullet
ls_unicode_to_adobe_encoding 188 = 999999999; // ellipsis
ls_unicode_to_adobe_encoding c
	| c>=128 && c<=133
		= 999999999; // lessequal, greaterequal, sigma, tau, Sigma, Tau

ls_unicode_to_adobe_encoding c = c;

/*
BulletChar   = toChar 183; // \xB7 0x2022
EllipsisChar = toChar 188; // \xBC 0x2026
*/

/*
	/Differences [
	128 /lessequal /greaterequal /sigma /tau /Sigma /Tau
	196 /Adieresis
	225 /aacute
	228 /adieresis
	246 /odieresis
	241 /ntilde
	243 /oacute
	]
*/

/*
[("lessequal",[(2126,"2264")]),("greaterequal",[(2127,"2265")]),("Adieresis",[(134,"00C4")]), ("aacute",[(163,"00E1")]),
 ("adieresis",[(166,"00E4")]), ("odieresis",[(184,"00F6")]),    ("ntilde",[(179,"00F1")]),    ("oacute",[(181,"00F3")])],
[("Sigma",633,[(853,"03A3")]), ("Tau",634,[(854,"03A4")]),      ("sigma",662,[(885,"03C3")]), ("tau",663,[(886,"03C4")])]
*/

c_unicode_to_adobe_encoding :: !Int -> Int;
c_unicode_to_adobe_encoding 0x2022 = 183; // bullet
c_unicode_to_adobe_encoding 0x2026 = 188; // ellipsis
c_unicode_to_adobe_encoding 0x2264 = 128; // lessequal
c_unicode_to_adobe_encoding 0x2265 = 129; // greaterequal
c_unicode_to_adobe_encoding 0x03C3 = 130; // sigma
c_unicode_to_adobe_encoding 0x03C4 = 131; // tau
c_unicode_to_adobe_encoding 0x03A3 = 132; // Sigma
c_unicode_to_adobe_encoding 0x03A4 = 133; // Tau
c_unicode_to_adobe_encoding 0x22A5 = 134; // perpendicular

c_unicode_to_adobe_encoding 183 = 999999999; // bullet
c_unicode_to_adobe_encoding 188 = 999999999; // ellipsis
c_unicode_to_adobe_encoding c
	| c>=128 && c<=134
		= 999999999; // lessequal, greaterequal, sigma, tau, Sigma, Tau, perpendicular

c_unicode_to_adobe_encoding c = c;

// "/Differences [128 /lessequal /greaterequal /sigma /tau /Sigma /Tau /perpendicular]";

//[("perpendicular",454,[(711,"22A5")])]
