implementation module pdf_main;

import StdEnv,pdf_fonts,pdf_outline,pdf_text;

import StdDebug;

:: Page :== (!{#Char},!{#Char},!Headings,![Link]);

make_catalog_object outlines
	= "<< /Type /Catalog /Pages 2 0 R"+++" /Outlines "+++toString outlines+++" 0 R"+++">>";

concat_strings_with_spaces [s] = s;
concat_strings_with_spaces [s:sl] = s+++" "+++concat_strings_with_spaces sl;
concat_strings_with_spaces [] = "";

list_of_references object_n_list
	= "["+++concat_strings_with_spaces [toString object_n+++" 0 R"\\object_n<-object_n_list]+++"]";

make_pages_object pages top
	= "<< /Type /Pages /Kids "+++list_of_references pages+++" /Count "+++toString (length pages)+++" /MediaBox [0 0 595 "+++toString top+++"]>>";

make_page_object page_object_n char_width_and_kerns
	= "<< /Type /Page /Parent 2 0 R /Resources << /Font << "+++page_font_stream char_width_and_kerns+++" >> >> /Contents "+++toString page_object_n+++" 0 R >>";

make_page_object_with_annots page_object_n annots char_width_and_kerns
	= "<< /Type /Page /Parent 2 0 R /Resources << /Font << "+++page_font_stream char_width_and_kerns+++" >> >>"+++
		" /Annots "+++list_of_references annots+++" /Contents "+++toString page_object_n+++" 0 R >>";

get_section_number i begin_i s
	| i<size s && (isDigit s.[i] || s.[i]=='.')
		= get_section_number (i+1) begin_i s;
		= (begin_i,i);

find_section_number_indices :: !Int !{#Char} -> (!Int,!Int);
find_section_number_indices i s
	| i<size s
		| isDigit s.[i]
			= get_section_number (i+1) i s;
		| (s.[i]=='A' || s.[i]=='B') && (i+1==size s || s.[i+1]=='.')
			= get_section_number (i+2) i s;
			= find_section_number_indices (i+1) s;
		= (-1,-1);

find_section_number :: !{#Char} -> {#Char};
find_section_number s
	# (begin_section_number_i,end_section_number_i)	= find_section_number_indices 0 s;
	| begin_section_number_i<0
		= "";
		= s % (begin_section_number_i,end_section_number_i-1);

remove_chapter_or_appendix :: !{#Char} -> {#Char};
remove_chapter_or_appendix s
	| s % (0,7)=="Chapter "
		= s % (8,size s-1);
	| s % (0,8)=="Appendix "
		= s % (9,size s-1);
		= s;

find_out_line :: ![Outline] !{#Char} -> (!Bool,!{#Char},!Int,!Int);
find_out_line [outline=:Outline (h_s,n_s) page_n page_y nested_outlines:outlines] section_n
	# s=h_s+++" "+++n_s;
	# s = remove_chapter_or_appendix s;
	| size s>=1+size section_n && s.[size section_n]==' ' && s % (0,size section_n-1)==section_n
		= (True,s,page_n,page_y);
	# (found,s,page_n,page_y) = find_out_line nested_outlines section_n
	| found
		= (True,s,page_n,page_y);
	= find_out_line outlines section_n;
find_out_line [] section_n
	= (False,"",0,0);

make_link :: !Link ![Outline] !Real !Real !{!CharWidthAndKerns} -> {#Char};
make_link {link_begin_pos,link_line_word_spacing,link_y_pos,link_font_n,link_font_size,link_s} outlines left_margin top char_width_and_kerns
	# link_begin_pos = left_margin+link_begin_pos;
	# link_width = compute_link_width; with {
		compute_link_width
			| link_line_word_spacing<0.0
				= ~link_line_word_spacing
			# link_s_width = toReal (string_width link_s char_width_and_kerns.[link_font_n]*link_font_size)/1000.0
			| link_line_word_spacing==0.0
				= link_s_width
				= link_s_width + (link_line_word_spacing*toReal (count_spaces 0 0 link_s));
	  }
	# y_pos = top-2.0-toReal link_y_pos;
	# pos_s = toString link_begin_pos+++" "+++toString y_pos+++" "+++
			  toString (link_begin_pos+link_width)+++" "+++toString (y_pos+toReal link_font_size);
	# link_object_s = "<</Subtype /Link /Rect["+++pos_s+++"] /BS<</W 0>>";
	# section_n = find_section_number link_s;
	| size section_n==0 && trace_t "Destination of link \"" && trace_t link_s && trace_tn "\" not found"
		= link_object_s+++" /Dest ["+++toString 3+++" 0 R /XYZ "+++toString left_margin+++" "+++toString top+++" 0]"+++">>";
	# (found,s,page_n,page_y) = find_out_line outlines section_n
	| not found && trace_t "Section " && trace_t section_n && trace_t " of destination of link \"" && trace_t link_s && trace_tn "\" not found"
		= link_object_s+++" /Dest ["+++toString 3+++" 0 R /XYZ "+++toString left_margin+++" "+++toString top+++" 0]"+++">>";
		= link_object_s+++" /Dest ["+++toString page_n+++" 0 R /XYZ "+++toString left_margin+++" "+++toString page_y+++" 0]"+++">>";

add_page_object_number_to_headings page_object_n headings top
	= [(heading_depth,heading_h_s,heading_n_s,page_object_n,toInt top-y_pos) \\ (heading_depth,heading_h_s,heading_n_s,y_pos)<-headings];

add_page_and_link :: !Page !Real !{!CharWidthAndKerns} !Int ![Outline] ![(Int,{#Char},{#Char},[Link])] ![{#Char}]
												   -> (!Int,![Outline],![(Int,{#Char},{#Char},[Link])],![{#Char}]);
add_page_and_link (page_s,page_h,page_headings,page_links) top char_width_and_kerns page_object_n outlines page_objects page_hs
	# outlines = add_headings (reverse (add_page_object_number_to_headings page_object_n page_headings top)) outlines;
	# page_hs = [page_h:page_hs];
	| page_links=:[]
		# page_objects = [(page_object_n,make_object page_object_n (make_page_object (page_object_n+1) char_width_and_kerns),
						   make_object (page_object_n+1) page_s,[]):page_objects]; // reversed
		= (page_object_n+2,outlines,page_objects,page_hs);
		# n_link_objects=length page_links;
		# annots = [page_object_n+2..page_object_n+1+n_link_objects];
		# page_objects = [(page_object_n,make_object page_object_n (make_page_object_with_annots (page_object_n+1) annots char_width_and_kerns),
						   make_object (page_object_n+1) page_s,page_links):page_objects]; // reversed
		= (page_object_n+2+n_link_objects,outlines,page_objects,page_hs);

add_pages_and_links :: ![{!CharWidthAndKerns}->Page] !Real !{!CharWidthAndKerns}
							!Int ![Outline] ![(Int,{#Char},{#Char},[Link])] ![Int] ![{#Char}]
						-> (!Int,![Outline],![(Int,{#Char},{#Char},[Link])],![Int],![{#Char}]);
add_pages_and_links [page:pages] top char_width_and_kerns page_object_n outlines page_objects page_object_numbers page_hs
	# page_object_numbers = [page_object_n:page_object_numbers];
	# (page_object_n,outlines,page_objects,page_hs)
		= add_page_and_link (page char_width_and_kerns) top char_width_and_kerns page_object_n outlines page_objects page_hs;
	= add_pages_and_links pages top char_width_and_kerns page_object_n outlines page_objects page_object_numbers page_hs;
add_pages_and_links [] top char_width_and_kerns page_object_n outlines page_objects page_object_numbers page_hs
	= (page_object_n,outlines,page_objects,page_object_numbers,page_hs);

convert_links_to_objects link_object_n page_links outlines left_margin top char_width_and_kerns
	= [make_object link_object_n (make_link link outlines left_margin top char_width_and_kerns)
	   \\ link<-page_links & link_object_n<-[link_object_n..]];

add_links_to_pages [(object_n,page_object,page_contents,page_links):page_and_link_objects] outlines left_margin top char_width_and_kerns
	= [page_object,page_contents:
		convert_links_to_objects (object_n+2) page_links outlines left_margin top char_width_and_kerns]
		++add_links_to_pages page_and_link_objects outlines left_margin top char_width_and_kerns;
add_links_to_pages [] outlines left_margin top char_width_and_kerns
	= [];

all_objects :: ![{!CharWidthAndKerns} -> Page] ![{#Char}] !Real !Real !{!CharWidthAndKerns} -> (![{#Char}],[{#Char}],![Outline]);
all_objects pages font_file_s_l left_margin top char_width_and_kerns
	# page_object_n = 3;
	# outlines = [];
	# page_objects = [];
	# page_object_numbers = [];

	# (page_object_n,font_objects) = make_font_objects page_object_n font_file_s_l char_width_and_kerns;

	# (page_object_n,outlines,page_and_link_objects,page_object_numbers,page_hs)
		= add_pages_and_links pages top char_width_and_kerns page_object_n outlines page_objects page_object_numbers [];

	# page_objects = add_links_to_pages (reverse page_and_link_objects) outlines left_margin top char_width_and_kerns;
	  page_object_numbers = reverse page_object_numbers;

	# outline_object_n = page_object_n;

	# (pdf_objects,last_object_n,_,next_object_n) = outlines_to_pdf_objects outlines outline_object_n (outline_object_n+1);
	# pdf_objects = [make_object object_n pdf_object \\ pdf_object<-pdf_objects & object_n<-[(outline_object_n+1)..]];

	# objects =
	   [make_object 1 (make_catalog_object outline_object_n),
		make_object 2 (make_pages_object page_object_numbers (toInt top))]++
		font_objects++
		page_objects++
		[make_object outline_object_n (outlines_object (outline_object_n+1) last_object_n)]++
		pdf_objects;
	= (objects,page_hs,outlines);

make_stream s
	= "<< /Length "+++toString (size s)+++" >>\nstream\n"+++s+++"\nendstream";

make_object i s
	= toString i+++" 0 obj "+++s+++"\nendobj\n";

toString10 i
	# s=toString i;
	= "0000000000" % (0,9-size s) +++ s;

write_objects [] pdf_file = pdf_file;
write_objects [object:objects] pdf_file = write_objects objects (pdf_file <<< object);

write_xref [] pdf_file = pdf_file;
write_xref [offset:offsets] pdf_file
	# pdf_file = pdf_file <<< toString10 offset <<< " 00000 n \n";
	= write_xref offsets pdf_file;

compute_object_offsets :: ![{#Char}] !Int -> [Int];
compute_object_offsets [] offset = [];
compute_object_offsets [object:objects] offset = [offset:compute_object_offsets objects (offset+size object)];

write_pdf :: !{#Char} ![{!CharWidthAndKerns} -> Page] !Real !Real !*World -> (!Bool,!*World);
write_pdf file_name pages left_margin top world
	# (font_file_s_l,char_width_and_kerns,world) = read_font_files world;

	# (ok,pdf_file,world) = fopen (file_name+++".pdf") FWriteData world;
	| not ok
		= abort ("creating pdf file: "+++file_name+++".pdf failed");
	
	# pdf_header = "%PDF-1.3\n\n";
	# pdf_file = pdf_file <<< pdf_header;

	# (objects,page_hs,outlines) = all_objects pages font_file_s_l left_margin top char_width_and_kerns;
	# object_offsets = compute_object_offsets objects (size pdf_header);
	# n_objects = length objects;
	# xref_offset = last object_offsets+size (last objects);
	
	# pdf_file = write_objects objects pdf_file;
	  pdf_file = pdf_file <<< "xref\n0 " <<< toString (n_objects+1) <<< "\n0000000000 65535 f \n";
	  pdf_file = write_xref object_offsets pdf_file;
	  pdf_file = pdf_file <<< "trailer << /Root 1 0 R /Size "<<<toString (n_objects+1)<<<" >>\n";
	  pdf_file = pdf_file <<< "startxref\n" <<< toString xref_offset <<< '\n';
	  pdf_file = pdf_file <<<"%%EOF\n";
	# (ok,world) = fclose pdf_file world;
	| not ok
		= (ok,world);
	
	# (ok,html_file,world) = fopen (file_name+++".html") FWriteData world;
	| not ok
		= abort ("creating html file: "+++file_name+++".html failed");
	
	# html_file=html_file<<<"<!DOCTYPE html>\n<html>\n<body style=\"font-family:Helvetica\">\n";

	# html_file = write_html_outline outlines html_file

	# html_file = write_objects (reverse page_hs) html_file;

	# html_file=html_file<<<"</body>\n</html>\n";

	= fclose html_file world;
