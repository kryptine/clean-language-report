module split_html;

import StdEnv;

//NBSP_replacement :== "&#x2004;"; // 1/3 em
NBSP_replacement :== "&#x2005;"; // 1/4 em
//NBSP_replacement :== "&#x205F;"; // 4/18 em (0.222..)
//NBSP_replacement :== "&#x2009;"; // 1/5 (or 1/6) em
//NBSP_replacement :== "&#x2006;"; // 1/6 em
//NBSP_replacement :== "&#x2007;"; // width of digit
//NBSP_replacement :== "&#x2008;"; // width of .

//"&#x25a0;" 9632

digits_end_tag_newline i s
	| i<size s
		| isDigit s.[i]
			= digits_end_tag_newline (i+1) s;
			= end_tag_newline i s;
		= False;
{}{
	end_tag_newline i s
		| i<size s
			| s.[i]=='>'
				= newline (i+1) s;
				= False;
			= False;
	
	newline i s
		= i+1==size s && s.[i]=='\n';
}

read_until_word_section lines file
	# (line,file) = freadline file
	| size line==0
		= (lines,line,file);
	| size line<22
		= read_until_word_section [line:lines] file;
	| line.[0]=='<' && line.[1]=='d' && line.[2]=='i' && line.[3]=='v' && line.[4]==' '
		&& line % (5,9)=="class" && line.[10]=='=' && line % (11,21)=="WordSection"
		| digits_end_tag_newline 22 line
			# (auto_page_break_before,lines) = remove_page_break lines;
			| auto_page_break_before
				= read_until_word_section [line:lines] file;
				= (lines,line,file);
			= abort "Error in WordSection tag";
		= read_until_word_section [line:lines] file;

remove_page_break ["\n":lines]
	= remove_page_break lines;
remove_page_break lines=:["</span>\n","clear=all style='page-break-before:right'>\n",line:lines2]
	| string_begins_with "<span lang=EN-US style=" line && string_ends_with "><br\n" line
		= (False,lines2);
		= (False,lines);
remove_page_break lines=:["</span>\n","color:black'><br clear=all style='page-break-before:right'>\n",line:lines2]
	| string_begins_with "<span lang=EN-US style=" line && string_ends_with ";\n" line
		= (False,lines2);
		= (False,lines);
remove_page_break lines=:["</span>\n","clear=all style='page-break-before:auto'>\n",line:lines2]
	| string_begins_with "<span lang=EN-US style=" line && string_ends_with "><br\n" line
		= (True,lines);
		= (False,lines);
remove_page_break lines
	= (False,lines);

string_begins_with s1 s2
	= size s2>=size s1 && s2 % (0,size s1-1)==s1;

string_ends_with s1 s2
	= size s2>=size s1 && s2 % (size s2-size s1,size s2-1)==s1;

write_lines [line:lines] section_file
	= write_lines lines (fwrites line section_file);
write_lines [] section_file
	= section_file;

read_sections word_section_line file
	# (reversed_section_lines,next_word_section_line,file) = read_until_word_section [] file;
	# section_lines = [word_section_line : reverse reversed_section_lines]	
	| size next_word_section_line<>0
		# (sections_lines,file) = read_sections next_word_section_line file
		= ([section_lines:sections_lines],file);
		= ([section_lines],file);

replace_tabs_in_this_line line
	# s = "<p class=lopal>";
	| line % (0,size s-1) == s
		= True;
	# s = "<p class=lop>";
	| line % (0,size s-1) == s
		= True;
	# s = "style='font:7.0pt \"Times New Roman\""
	| line % (0,size s-1) == s
		= True;
		= False;

replace_nbsps_and_space i line
	| not (replace_tabs_in_this_line line)
		= line;
	| i<size line
		| line.[i]=='\xa0'
			# line = line % (0,i-1) +++ NBSP_replacement +++line % (i+1,size line-1);
			= skip_nbsps (i+size NBSP_replacement) line;
		| i+5<size line && line % (i,i+5)=="&nbsp;"
			# line = line % (0,i-1) +++ NBSP_replacement +++line % (i+6,size line-1);
			= skip_nbsps (i+size NBSP_replacement) line;
			= replace_nbsps_and_space (i+1) line;
		= line;
{}{
	skip_nbsps i line
		| i<size line
			| line.[i]=='\xa0'
				# line = line % (0,i-1) +++ NBSP_replacement +++ line % (i+1,size line-1);
				= skip_nbsps (i+size NBSP_replacement) line;
			| i+5<size line && line % (i,i+5)=="&nbsp;"
				# line = line % (0,i-1) +++ NBSP_replacement +++ line % (i+6,size line-1);
				= skip_nbsps (i+size NBSP_replacement) line;
			| line.[i]==' '
//				&& trace_tn "replaced space"
				# line = line % (0,i-1) +++ NBSP_replacement +++ line % (i+1,size line-1);
				# i = i+size NBSP_replacement;
				= replace_nbsps_and_space i line;
				= replace_nbsps_and_space i line;
			= line;
}

//<span lang=EN-US style='font-size:12.0pt;font-family:Wingdings;
//color:#FFCC99'>n<span style='font:7.0pt "Times New Roman"'>&nbsp; </span></span>

//style='font-size:12.0pt;font-family:Wingdings;color:#FFCC99'>n<span
//style='font:7.0pt "Times New Roman"'>&nbsp; </span></span><span lang=EN-US>When

//<span lang=EN-GB style='font-size:12.0pt;font-family:Wingdings;
//color:#FFCC99'>n<span style='font:7.0pt "Times New Roman"'>&nbsp; </span></span>

//<span lang=EN-US style='font-size:12.0pt;
//font-family:Wingdings;color:#FFCC99'>n<span style='font:7.0pt "Times New Roman"'>&nbsp;
//</span></span>

//<span lang=EN-US
//style='font-size:12.0pt;font-family:Wingdings;color:#FFCC99'>n<span
//style='font:7.0pt "Times New Roman"'>&nbsp; </span></span>

NewSquareFont:== "\"Times New Roman\"";
BulletImage:=="<img src=\"square_8.png\" />";
SpaceAfterBullet:=="<span style=\"margin-left:20px\"></span>";
SpaceAfterBullet16:=="<span style=\"margin-left:16px\"></span>";

fix_nlop_and_nlopal_tabs [line1,line2:lines]
	# s1 = "<span lang=EN-US style='font-size:12.0pt;font-family:Wingdings;\n";
	# s2 = "color:#FFCC99'>n<span style='font:7.0pt \"Times New Roman\"'>&nbsp; </span></span>";
	# ss1 = size s1; ss2 = size s2; sl1 = size line1; sl2 = size line2;
	| sl1>=ss1 && line1 % (sl1-ss1,sl1-1)==s1 && sl2>=ss2 && line2 % (0,ss2-1)==s2
		# new_s2 = "color:#FFCC99'>"+++BulletImage+++"</span>" +++ SpaceAfterBullet;
		# line1 = line1 % (0,size line1-1-11)+++NewSquareFont+++";\n";
		# line2 = new_s2+++line2 % (ss2,sl2-1);
		= [line1:line2:fix_nlop_and_nlopal_tabs lines];
fix_nlop_and_nlopal_tabs [line1,line2:lines]
	# s1 = "'font-size:12.0pt;font-family:Wingdings;color:#FFCC99'>n<span\n";
	# s2 = "style='font:7.0pt \"Times New Roman\"'>&nbsp; </span></span>";
	# ss1 = size s1; ss2 = size s2; sl1 = size line1; sl2 = size line2;
	| sl1>=ss1 && line1 % (sl1-ss1,sl1-1)==s1 && sl2>=ss2 && line2 % (0,ss2-1)==s2
		# line1 = line1 % (0,size line1-1-ss1)+++"'font-size:12.0pt;font-family:"
					+++NewSquareFont+++";color:#FFCC99'>"+++BulletImage+++"\n";
		# line2 = "</span>"+++ SpaceAfterBullet16+++line2 % (ss2,sl2-1);
		= [line1:line2:fix_nlop_and_nlopal_tabs lines];
fix_nlop_and_nlopal_tabs [line1,line2:lines]
	# s1 = "<span lang=EN-GB style='font-size:12.0pt;font-family:Wingdings;\n";
	# s2 = "color:#FFCC99'>n<span style='font:7.0pt \"Times New Roman\"'>&nbsp; </span></span>";
	# ss1 = size s1; ss2 = size s2; sl1 = size line1; sl2 = size line2;
	| sl1>=ss1 && line1 % (sl1-ss1,sl1-1)==s1 && sl2>=ss2 && line2 % (0,ss2-1)==s2
		# new_s2 = "color:#FFCC99'>"+++BulletImage+++"</span>" +++ SpaceAfterBullet;
		# line1 = line1 % (0,size line1-1-11)+++NewSquareFont+++";\n";
		# line2 = new_s2+++line2 % (ss2,sl2-1);
		= [line1:line2:fix_nlop_and_nlopal_tabs lines];
fix_nlop_and_nlopal_tabs [line1,line2,line3:lines]
	# s1 = "<span lang=EN-US style='font-size:12.0pt;\n";
	# s2 = "font-family:Wingdings;color:#FFCC99'>n<span style='font:7.0pt \"Times New Roman\"'>&nbsp;\n";
	# s3 = "</span></span>"
	# ss1 = size s1; ss3 = size s3; sl1 = size line1; sl3 = size line3;
	| sl1>=ss1 && line1 % (sl1-ss1,sl1-1)==s1 && line2==s2 && sl3>=ss3 && line3 % (0,ss3-1)==s3
		# line2 = "font-family:"+++NewSquareFont+++";color:#FFCC99'>"+++BulletImage+++"</span>\n";
		# line3 = SpaceAfterBullet+++line3 % (ss3,sl3-1);
		= [line1,line2,line3:fix_nlop_and_nlopal_tabs lines];
fix_nlop_and_nlopal_tabs [line1,line2,line3:lines]
	# s1 = "<span lang=EN-US\n";
	# s2 = "style='font-size:12.0pt;font-family:Wingdings;color:#FFCC99'>n<span\n";
	# s3 = "style='font:7.0pt "+++"'>&nbsp; </span></span>";
	# ss1 = size s1; ss3 = size s3; sl1 = size line1; sl3 = size line3;
	| sl1>=ss1 && line1 % (sl1-ss1,sl1-1)==s1 && line2==s2 && sl3>=ss3 && line3 % (0,ss3-1)==s3
		# line2 = "style='font-size:12.0pt;font-family:"+++NewSquareFont+++";color:#FFCC99'>"+++BulletImage+++"</span\n";
		# line3 = SpaceAfterBullet+++line3 % (ss3,sl3-1);
		= [line1,line2,line3:fix_nlop_and_nlopal_tabs lines];
fix_nlop_and_nlopal_tabs [line:lines]
	= [line:fix_nlop_and_nlopal_tabs lines];
fix_nlop_and_nlopal_tabs []
	= [];

write_sections [section_lines:sections_lines] section_n lines file_name world
	# section_file_name = file_name+++"_"+++toString section_n+++".htm";
	# (ok,section_file,world) = fopen section_file_name FWriteText world;
	| not ok
		= abort ("Could not create file "+++section_file_name);

	# section_file = write_lines lines section_file;
	
	# section_lines = fix_nlop_and_nlopal_tabs section_lines;

	# section_lines = [replace_nbsps_and_space 0 line \\ line<-section_lines];

	# section_file = write_lines section_lines section_file;
	# section_file = fwrites "</body>\n" section_file;
	# section_file = fwrites "</html>\n" section_file;

	# (ok,world) = fclose section_file world;
	| not ok
		= abort ("Error writing file "+++section_file_name);
	
	= write_sections sections_lines (section_n+1) lines file_name world;
write_sections [] section_n lines file_name world
	= world;

collect_anchors :: ![[{#Char}]] !Int -> [({#Char},Int)];
collect_anchors [section_lines:sections_lines] section_n
	# section_labels = collect_anchors_in_lines section_lines;
	# sections_labels = collect_anchors sections_lines (section_n+1);
	= [(label,section_n) \\ label<-section_labels] ++ sections_labels;
{}{
	collect_anchors_in_lines :: ![{#Char}] -> [{#Char}];
	collect_anchors_in_lines [line:lines]
		= collect_anchors_in_lines2 0 line lines;
	collect_anchors_in_lines []
		= [];

	collect_anchors_in_lines2 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	collect_anchors_in_lines2 i line lines
		| i<size line
			| line.[i]=='<' && i+2<size line && line.[i+1]=='a' && (let{ c=line.[i+2]; }in c==' ' || c=='\t' || c=='\n')		
				# (i,line,lines) = skip_spaces (i+3) line lines;
				= collect_anchors_in_lines3 i line lines;
				= collect_anchors_in_lines2 (i+1) line lines;
			= collect_anchors_in_lines lines; 

	collect_anchors_in_lines3 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	collect_anchors_in_lines3 i line lines
		| i+3<size line && line.[i]=='n' && line.[i+1]=='a' && line.[i+2]=='m' && line.[i+3]=='e'
			# (i,line,lines) = skip_spaces (i+4) line lines;
			= collect_anchors_in_lines4 i line lines;
		| i+3<size line && line.[i]=='h' && line.[i+1]=='r' && line.[i+2]=='e' && line.[i+3]=='f'
			# (i,line,lines) = skip_spaces (i+4) line lines;
			= collect_anchors_in_lines6 i line lines;
			= collect_anchors_in_lines2 i line lines;
	
	collect_anchors_in_lines4 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	collect_anchors_in_lines4 i line lines
		| i<size line && line.[i]=='='
			# (i,line,lines) = skip_spaces (i+1) line lines;
			= collect_anchors_in_lines5 i line lines;
			= collect_anchors_in_lines2 i line lines;
	
	collect_anchors_in_lines5 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	collect_anchors_in_lines5 i line lines
		| i<size line && line.[i]=='"'
			# j = find_double_quote (i+1) line;
			| j>=0
				# label = line % (i+1,j-1);
				# labels = collect_anchors_in_lines2 (j+1) line lines;
				= [label:labels];
				= collect_anchors_in_lines2 (i+1) line lines;
			= collect_anchors_in_lines2 i line lines;

	collect_anchors_in_lines6 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	collect_anchors_in_lines6 i line lines
		| i<size line && line.[i]=='='
			# (i,line,lines) = skip_spaces (i+1) line lines;
			= collect_anchors_in_lines7 i line lines;
			= collect_anchors_in_lines2 i line lines;
	
	collect_anchors_in_lines7 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	collect_anchors_in_lines7 i line lines
		| i<size line && line.[i]=='"'
			# j = find_double_quote (i+1) line;
			| j>=0
				# (i,line,lines) = skip_spaces (j+2) line lines;
				= collect_anchors_in_lines3 i line lines;
				= collect_anchors_in_lines2 (i+1) line lines;
			= collect_anchors_in_lines2 i line lines;

	skip_spaces :: !Int !{#Char} ![{#Char}] -> (!Int,!{#Char},![{#Char}]);
	skip_spaces i line lines
		| i<size line
			# c=line.[i];
			| c==' ' || c=='\t' || c=='\n'
				= skip_spaces (i+1) line lines;
				= (i,line,lines);
			= skip_spaces2 lines;
	
	skip_spaces2 :: ![{#Char}] -> (!Int,!{#Char},![{#Char}]);
	skip_spaces2 [line:lines]
		= skip_spaces 0 line lines;
	skip_spaces2 []
		= (0,"",[]);
}
collect_anchors [] section_n
	= [];

update_anchors :: ![[{#Char}]] !Int !{!({#Char},Int)} !{#Char} -> [[{#Char}]];
update_anchors [section_lines:sections_lines] section_n labels_a file_name
	# section_lines = update_anchors_in_lines section_lines;
	# sections_lines = update_anchors sections_lines (section_n+1) labels_a file_name;
	= [section_lines :  sections_lines];
{}{
	update_anchors_in_lines :: ![{#Char}] -> [{#Char}];
	update_anchors_in_lines [line:lines]
		= update_anchors_in_lines2 0 line lines;
	update_anchors_in_lines []
		= [];

	update_anchors_in_lines2 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	update_anchors_in_lines2 i line lines
		| i<size line
			| line.[i]=='<' && i+2<size line && line.[i+1]=='a' && (let{ c=line.[i+2]; }in c==' ' || c=='\t' || c=='\n')		
				= skip_spaces (i+3) line lines update_anchors_in_lines3;
				= update_anchors_in_lines2 (i+1) line lines;
			= [line : update_anchors_in_lines lines];

	update_anchors_in_lines3 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	update_anchors_in_lines3 i line lines
		| i+3<size line && line.[i]=='h' && line.[i+1]=='r' && line.[i+2]=='e' && line.[i+3]=='f'
			= skip_spaces (i+4) line lines update_anchors_in_lines4;
		| i+3<size line && line.[i]=='n' && line.[i+1]=='a' && line.[i+2]=='m' && line.[i+3]=='e'
			= skip_spaces (i+4) line lines update_anchors_in_lines6;
			= update_anchors_in_lines2 i line lines;
	
	update_anchors_in_lines4 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	update_anchors_in_lines4 i line lines
		| i<size line && line.[i]=='='
			= skip_spaces (i+1) line lines update_anchors_in_lines5;
			= update_anchors_in_lines2 i line lines;
	
	update_anchors_in_lines5 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	update_anchors_in_lines5 i line lines
		| i<size line && line.[i]=='"'
			# j = find_double_quote (i+1) line;
			| j>=0
				# label = line % (i+1,j-1);
				# label_section_n = find_label label labels_a;
				| label_section_n<0 || label_section_n==section_n
					= update_anchors_in_lines2 (j+1) line lines;
					# section_file_name = file_name+++"_"+++toString label_section_n+++".htm";
					# line = line % (0,i) +++ section_file_name +++ line % (i+1,size line-1);
					= update_anchors_in_lines2 (j+1+size section_file_name) line lines;
				= update_anchors_in_lines2 (i+1) line lines;
			= update_anchors_in_lines2 i line lines;

	update_anchors_in_lines6 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	update_anchors_in_lines6 i line lines
		| i<size line && line.[i]=='='
			= skip_spaces (i+1) line lines update_anchors_in_lines7;
			= update_anchors_in_lines2 i line lines;
	
	update_anchors_in_lines7 :: !Int !{#Char} ![{#Char}] -> [{#Char}];
	update_anchors_in_lines7 i line lines
		| i<size line && line.[i]=='"'
			# j = find_double_quote (i+1) line;
			| j>=0
				= skip_spaces (j+2) line lines update_anchors_in_lines3;
				= update_anchors_in_lines2 (i+1) line lines;
			= update_anchors_in_lines2 i line lines;

	skip_spaces :: !Int !{#Char} ![{#Char}] !(Int {#Char} [{#Char}] -> [{#Char}]) -> [{#Char}];
	skip_spaces i line lines f
		| i<size line
			# c=line.[i];
			| c==' ' || c=='\t' || c=='\n'
				= skip_spaces (i+1) line lines f;
				= f i line lines;
			= [line : skip_spaces2 lines f];
	
	skip_spaces2 :: ![{#Char}] !(Int {#Char} [{#Char}] -> [{#Char}]) -> [{#Char}];
	skip_spaces2 [line:lines] f
		= skip_spaces 0 line lines f;
	skip_spaces2 [] f
		= f 0 "" [];
}
update_anchors [] labels_a section_n file_name
	= [];

find_double_quote :: !Int !{#Char} -> Int;
find_double_quote i s
	| i<size s
		| s.[i]<>'"'
			= find_double_quote (i+1) s;
			= i;
		= -1;

import StdDebug;

find_label label labels_a
	| label.[0]=='#'
		= find 0 (size labels_a) (label % (1,size label-1));
//	| trace_tn ("find_label "+++label)
		= -1;
{}{
	find l r label
		# m = (l+r)>>1;
		| m==l
			# (label_name,section_n) = labels_a.[m];
			| l==r || label_name<>label
//				= abort ("label "+++label+++" not found")
				| trace_tn ("label "+++label+++" not found")
					= -1;
					= -1;
				= section_n
		# (label_name,section_n) = labels_a.[m];
		| label_name==label
			= section_n;
		| label_name>label
			= find l m label;
			= find (m+1) r label;
}

// <link rel="stylesheet" href="CleanRep.2.1.css" type="text/css">

link_style_sheet ["<style>\n":lines] world
	# file_name = "CleanRep.2.1.css";
	# (ok,file,world) = fopen file_name FWriteText world;
	| not ok
		= abort ("Could not create file "+++file_name+++".htm");
	# (lines,file) = write_style_sheet lines file;
	# (ok,world) = fclose file world;
	| not ok
		= abort ("Error writing file "+++file_name);
	# line = "<link rel=\"stylesheet\" href=\"CleanRep.2.1.css\" type=\"text/css\">";
	= ([line:lines],world);
link_style_sheet [line:lines] world
	# (lines,world) = link_style_sheet lines world;
	= ([line:lines],world);
link_style_sheet [] world
	= ([],world);

write_style_sheet ["</style>\n":lines] file
	= (lines,file);
write_style_sheet [line:lines] file
	# file = fwrites line file;
	= write_style_sheet lines file;
write_style_sheet [] file
	= abort "error in style sheet";
//	= ([],file);

Start world
	# file_name = "CleanRep.2.1"
	# (ok,file,world) = fopen (file_name+++".htm") FReadText world;
	| not ok
		= abort ("Could not open file "+++file_name+++".htm");

	# (reversed_lines,word_section_line,file) = read_until_word_section [] file;
	# lines = reverse reversed_lines;
	| size word_section_line==0
		= abort "WordSection not found";

	# (sections_lines,file) = read_sections word_section_line file;

	# (ok,world) = fclose file world;
	| not ok
		= abort ("Error reading html file");

	# labels_list = sort (collect_anchors sections_lines 0);
	# labels_a = {! label \\ label<-labels_list}

	# sections_lines = update_anchors sections_lines 0 labels_a file_name;

	# (lines,world) = link_style_sheet lines world;

	# world = write_sections sections_lines 0 lines file_name world;
	= world;
