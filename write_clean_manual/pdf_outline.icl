implementation module pdf_outline;

import StdEnv;
from clean_manual_styles import html_chapter_3s;

:: Headings :== [(Int,{#Char},{#Char},Int)];

HeaderColor :== (153,153,255);

outlines_object :: !Int !Int -> {#Char};
outlines_object first last
	= "<< /Type /Outlines /First "+++toString first+++" 0 R /Last "+++toString last+++" 0 R >>";

single_outlines_item :: !{#Char} !Int !Int !Int !Int -> {#Char};
single_outlines_item name parent dest_page dest_x dest_y
	= "<< /Title ("+++name+++") /Parent "+++toString parent+++" 0 R "+++
		"/Dest ["+++toString dest_page+++" 0 R /XYZ "+++toString dest_x+++" "+++toString dest_y+++" 0] >>";

first_outlines_item :: !{#Char} !Int !Int !Int !Int !Int -> {#Char};
first_outlines_item name parent next dest_page dest_x dest_y
	= "<< /Title ("+++name+++") /Parent "+++toString parent+++" 0 R "+++
		"/Next "+++toString next+++" 0 R "+++
		"/Dest ["+++toString dest_page+++" 0 R /XYZ "+++toString dest_x+++" "+++toString dest_y+++" 0] >>";

middle_outlines_item :: !{#Char} !Int !Int !Int !Int !Int !Int -> {#Char};
middle_outlines_item name parent prev next dest_page dest_x dest_y
	= "<< /Title ("+++name+++") /Parent "+++toString parent+++" 0 R "+++
		"/Prev "+++toString prev+++" 0 R "+++"/Next "+++toString next+++" 0 R "+++
		"/Dest ["+++toString dest_page+++" 0 R /XYZ "+++toString dest_x+++" "+++toString dest_y+++" 0] >>";

last_outlines_item :: !{#Char} !Int !Int !Int !Int !Int -> {#Char};
last_outlines_item name parent prev dest_page dest_x dest_y
	= "<< /Title ("+++name+++") /Parent "+++toString parent+++" 0 R "+++
		"/Prev "+++toString prev+++" 0 R "+++
		"/Dest ["+++toString dest_page+++" 0 R /XYZ "+++toString dest_x+++" "+++toString dest_y+++" 0] >>";

single_outlines_item_with_children :: !{#Char} !Int !Int !Int !Int !Int !Int !Int -> {#Char};
single_outlines_item_with_children name parent first last count dest_page dest_x dest_y
	= "<< /Title ("+++name+++") /Parent "+++toString parent+++" 0 R "+++
		"/First "+++toString first+++" 0 R "+++"/Last "+++toString last+++" 0 R /Count "+++toString count+++" "+++
		"/Dest ["+++toString dest_page+++" 0 R /XYZ "+++toString dest_x+++" "+++toString dest_y+++" 0] >>";

first_outlines_item_with_children :: !{#Char} !Int !Int !Int !Int !Int !Int !Int !Int -> {#Char};
first_outlines_item_with_children name parent next first last count dest_page dest_x dest_y
	= "<< /Title ("+++name+++") /Parent "+++toString parent+++" 0 R "+++
		"/Next "+++toString next+++" 0 R "+++
		"/First "+++toString first+++" 0 R "+++"/Last "+++toString last+++" 0 R /Count "+++toString count+++" "+++
		"/Dest ["+++toString dest_page+++" 0 R /XYZ "+++toString dest_x+++" "+++toString dest_y+++" 0] >>";

middle_outlines_item_with_children :: !{#Char} !Int !Int !Int !Int !Int !Int !Int !Int !Int -> {#Char};
middle_outlines_item_with_children name parent prev next first last count dest_page dest_x dest_y
	= "<< /Title ("+++name+++") /Parent "+++toString parent+++" 0 R "+++
		"/Prev "+++toString prev+++" 0 R "+++"/Next "+++toString next+++" 0 R "+++
		"/First "+++toString first+++" 0 R "+++"/Last "+++toString last+++" 0 R /Count "+++toString count+++" "+++
		"/Dest ["+++toString dest_page+++" 0 R /XYZ "+++toString dest_x+++" "+++toString dest_y+++" 0] >>";

last_outlines_item_with_children :: !{#Char} !Int !Int !Int !Int !Int !Int !Int !Int -> {#Char};
last_outlines_item_with_children name parent prev first last count dest_page dest_x dest_y
	= "<< /Title ("+++name+++") /Parent "+++toString parent+++" 0 R "+++
		"/Prev "+++toString prev+++" 0 R "+++
		"/First "+++toString first+++" 0 R "+++"/Last "+++toString last+++" 0 R /Count "+++toString count+++" "+++
		"/Dest ["+++toString dest_page+++" 0 R /XYZ "+++toString dest_x+++" "+++toString dest_y+++" 0] >>";

:: Outline = Outline !(!{#Char},!{#Char}) !Int !Int ![Outline];

add_heading :: (Int,{#Char},{#Char},Int,Int) !Int ![Outline] -> [Outline];
add_heading heading=:(heading_depth,heading_n_s,heading_h_s,page_n,page_y) outline_depth outlines
	| heading_depth==outline_depth
		= [Outline (heading_n_s,heading_h_s) page_n page_y []:outlines];
	| heading_depth>outline_depth
		# [Outline outline_s outline_page_n outline_page_y outline_childern:outlines] = outlines;
		# outline_childern = add_heading heading (outline_depth+1) outline_childern;
		= [Outline outline_s outline_page_n outline_page_y outline_childern:outlines];

add_headings :: ![(Int,{#Char},{#Char},Int,Int)] ![Outline] -> [Outline];
add_headings [heading:headings] outlines
	# outlines = add_heading heading 1 outlines;
	= add_headings headings outlines;
add_headings [] outlines
	= outlines;

outlines_to_pdf_objects :: ![Outline] !Int !Int -> (![{#Char}],!Int,!Int,!Int);
outlines_to_pdf_objects [Outline (h_s,n_s) outline_page_n outline_page_y []] parent_object_n next_object_n
	# outline_s = h_s+++" "+++n_s;
	# pdf_object = single_outlines_item outline_s parent_object_n outline_page_n 50 outline_page_y;
	= ([pdf_object],next_object_n,1,next_object_n+1);
outlines_to_pdf_objects [Outline (h_s,n_s) outline_page_n outline_page_y outline_childern] parent_object_n next_object_n
	# outline_s = h_s+++" "+++n_s;
	# object_n = next_object_n;
	# next_object_n = next_object_n+1;
	# first_object_n = next_object_n;
	# (pdf_objects,last_object_n,n_childern,next_object_n)
		= outlines_to_pdf_objects outline_childern object_n next_object_n;
	# pdf_object = single_outlines_item_with_children outline_s parent_object_n first_object_n last_object_n (~n_childern) outline_page_n 50 outline_page_y;
	= ([pdf_object:pdf_objects],object_n,1,next_object_n);

outlines_to_pdf_objects outlines parent_object_n next_object_n
	# outlines = reverse outlines;
	# n_objects = length outlines;
	# object_n = next_object_n;
	# next_object_n = next_object_n+n_objects;
	# (pdf_objects,children_pdf_objects,next_object_n) = make_outlines_to_pdf_objects outlines object_n parent_object_n next_object_n;
	= (pdf_objects++children_pdf_objects,object_n+n_objects-1,n_objects,next_object_n);

make_outlines_to_pdf_objects [Outline (h_s,n_s) outline_page_n outline_page_y []:outlines] object_n parent_object_n next_object_n
	# outline_s = h_s+++" "+++n_s;
	# pdf_object = first_outlines_item outline_s parent_object_n (object_n+1) outline_page_n 50 outline_page_y;
	# (pdf_objects,children_pdf_objects,next_object_n) = make_more_outlines_to_pdf_objects outlines (object_n+1) parent_object_n next_object_n;
	= ([pdf_object:pdf_objects],children_pdf_objects,next_object_n);
make_outlines_to_pdf_objects [Outline (h_s,n_s) outline_page_n outline_page_y outline_childern:outlines] object_n parent_object_n next_object_n
	# outline_s = h_s+++" "+++n_s;
	# first_object_n = next_object_n;
	# (outline_children_pdf_objects,last_object_n,n_childern,next_object_n)
		= outlines_to_pdf_objects outline_childern object_n next_object_n;
	# pdf_object = first_outlines_item_with_children outline_s parent_object_n (object_n+1) first_object_n last_object_n (~n_childern) outline_page_n 50 outline_page_y;
	# (pdf_objects,children_pdf_objects,next_object_n) = make_more_outlines_to_pdf_objects outlines (object_n+1) parent_object_n next_object_n;
	= ([pdf_object:pdf_objects],outline_children_pdf_objects++children_pdf_objects,next_object_n);

make_more_outlines_to_pdf_objects [Outline (h_s,n_s) outline_page_n outline_page_y []] object_n parent_object_n next_object_n
	# outline_s = h_s+++" "+++n_s;
	# pdf_object = last_outlines_item outline_s parent_object_n (object_n-1) outline_page_n 50 outline_page_y;
	= ([pdf_object],[],next_object_n);
make_more_outlines_to_pdf_objects [Outline (h_s,n_s) outline_page_n outline_page_y outline_childern] object_n parent_object_n next_object_n
	# outline_s = h_s+++" "+++n_s;
	# first_object_n = next_object_n;
	# (outline_children_pdf_objects,last_object_n,n_childern,next_object_n)
		= outlines_to_pdf_objects outline_childern object_n next_object_n;
	# pdf_object = last_outlines_item_with_children outline_s parent_object_n (object_n-1) first_object_n last_object_n (~n_childern) outline_page_n 50 outline_page_y;
	= ([pdf_object],outline_children_pdf_objects,next_object_n);
make_more_outlines_to_pdf_objects [Outline (h_s,n_s) outline_page_n outline_page_y []:outlines] object_n parent_object_n next_object_n
	# outline_s = h_s+++" "+++n_s;
	# pdf_object = middle_outlines_item outline_s parent_object_n (object_n-1) (object_n+1) outline_page_n 50 outline_page_y;
	# (pdf_objects,children_pdf_objects,next_object_n) = make_more_outlines_to_pdf_objects outlines (object_n+1) parent_object_n next_object_n;
	= ([pdf_object:pdf_objects],children_pdf_objects,next_object_n);
make_more_outlines_to_pdf_objects [Outline (h_s,n_s) outline_page_n outline_page_y outline_childern:outlines] object_n parent_object_n next_object_n
	# outline_s = h_s+++" "+++n_s;
	# first_object_n = next_object_n;
	# (outline_children_pdf_objects,last_object_n,n_childern,next_object_n)
		= outlines_to_pdf_objects outline_childern object_n next_object_n;
	# pdf_object = middle_outlines_item_with_children outline_s parent_object_n (object_n-1) (object_n+1) first_object_n last_object_n (~n_childern) outline_page_n 50 outline_page_y;
	# (pdf_objects,children_pdf_objects,next_object_n) = make_more_outlines_to_pdf_objects outlines (object_n+1) parent_object_n next_object_n;
	= ([pdf_object:pdf_objects],outline_children_pdf_objects++children_pdf_objects,next_object_n);

html_color :: !(Int,!Int,!Int) -> {#Char};
html_color (r,g,b)
	= {hex_char (r>>4),hex_char r,hex_char (g>>4),hex_char g,hex_char (b>>4),hex_char b};

hex_char i
	= "0123456789ABCDEF".[i bitand 15];

remove_chapter_or_appendix :: !{#Char} -> {#Char};
remove_chapter_or_appendix s
	| s % (0,7)=="Chapter "
		= s % (8,size s-1);
	| s % (0,8)=="Appendix "
		= s % (9,size s-1);
	| s=="Preface"
		= "P";
		= s;

compute_max_outline_depth :: ![Outline] !Int !Int -> Int;
compute_max_outline_depth [Outline _ _ _ []:outlines] current_depth max_depth
	= compute_max_outline_depth outlines current_depth max_depth;
compute_max_outline_depth [Outline _ _ _ nested_outlines:outlines] current_depth max_depth
	# next_depth=current_depth+1;
	# max_depth=if (next_depth>max_depth) next_depth max_depth;
	# max_depth=compute_max_outline_depth nested_outlines next_depth max_depth;
	= compute_max_outline_depth outlines current_depth max_depth;
compute_max_outline_depth [] current_depth max_depth
	= max_depth;

write_n_indent_columns :: !Int !*File -> *File;
write_n_indent_columns 0 html_file = html_file;
write_n_indent_columns n_columns html_file = write_n_indent_columns (n_columns-1) (html_file<<<"<td>&nbsp&nbsp&nbsp&nbsp</td>");

write_html_nested_outlines :: ![Outline] !Int !Int !*File -> *File;
write_html_nested_outlines [Outline (h_s,n_s) _ _ nested_outlines:outlines] depth n_columns html_file
	# html_file = html_file <<< "<tr>";
	# html_file = write_n_indent_columns (depth-2) html_file;
	# html_file = html_file
		<<< "<td><a href=\"#_" <<< h_s <<< "\">"<<< h_s <<< "</a></td>";
	# html_file = if (n_columns<=1)
					(html_file <<< "<td>")
					(html_file <<< "<td colspan=\""<<<toString n_columns<<<"\">");
	# html_file = html_file
		<<< "<a href=\"#_" <<< h_s <<< "\">"
		<<< n_s
		<<< "</a>"
		<<< "</td></tr>\n";
	# html_file = write_html_nested_outlines (reverse nested_outlines) (depth+1) (n_columns-1) html_file;
	= write_html_nested_outlines outlines depth n_columns html_file;
write_html_nested_outlines [] depth n_columns html_file
	= html_file;

write_html_outline_chapters :: ![Outline] !Int !*File -> *File;
write_html_outline_chapters [Outline (h_s,n_s) _ _ nested_outlines:outlines] n_columns html_file
	# html_file = html_file
		<<< "<tr style=\"padding-top:6.0pt;padding-bottom:6.0pt;font-weight:bold;text-transform:uppercase\">";
	# html_file = if (n_columns<=1)
					(html_file <<< "<td>")
					(html_file <<< "<td colspan=\""<<<toString n_columns<<<"\">");
	# html_file = html_file
		<<< "<a href=\"#_" <<< remove_chapter_or_appendix h_s <<< "\">"
		<<< "<p style=\"margin-bottom:6.0pt;margin-top:6.0pt;background-color:#"
		<<<html_color HeaderColor<<<" \">"
		<<< h_s <<< ' ' <<< n_s
		<<< "</p>"
		<<< "</a>"
		<<< "</td></tr>\n";	
	# html_file = write_html_nested_outlines (reverse nested_outlines) 2 (n_columns-1) html_file;
	= write_html_outline_chapters outlines n_columns html_file;
write_html_outline_chapters [] n_columns html_file
	= html_file;

write_html_outline :: ![Outline] !*File -> *File;
write_html_outline outlines html_file
	# max_outline_depth = compute_max_outline_depth outlines 1 1
	# html_file = html_file
		<<< html_chapter_3s "Version 3.0" "Language Report" "Table of Contents"
//		<<< "<h1 style=\"background-color:#"<<<html_color HeaderColor<<<"\">Table of Contents</h1>\n"
	;
	# html_file = html_file <<< "<table style=\"width:100%;text-align:left\">\n";
	# html_file = write_html_outline_chapters (reverse outlines) max_outline_depth html_file;
	# html_file = html_file <<< "</table>\n";
	= html_file;
