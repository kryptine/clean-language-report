implementation module split_html2;

import StdEnv;

read_header file
	# (line,file) = freadline file;
	| line % (0,12)=="<!-- chapter:"
		= ([],line,file);
	# (lines,chapter_line,file) = read_header file;
	= ([line:lines],chapter_line,file);

read_chapter file
	# (line,file) = freadline file;
	| line % (0,12)=="<!-- chapter:"
		= ([],line,file);
	| line % (0,6)=="</body>"
		= ([],line,file);
	# (lines,line_after_chapter,file) = read_chapter file;
	= ([line:lines],line_after_chapter,file);

read_lines file
	# (line,file) = freadline file;
	| size line==0
		= ([],file);
	# (lines,file) = read_lines file;
	= ([line:lines],file);

read_chapters chapter_line file
	# (chapter_lines,line_after_chapter,file) = read_chapter file;
	| line_after_chapter % (0,12)=="<!-- chapter:"
		# (chapters,final_lines,file) = read_chapters line_after_chapter file;
		= ([(chapter_line,chapter_lines):chapters],final_lines,file);
	# (lines,file) = read_lines file;
	= ([(chapter_line,chapter_lines)],[line_after_chapter:lines],file);

chapter_name_from_comment chapter_comment_line
	# chapter_name = chapter_comment_line % (13,size chapter_comment_line-5);
	| chapter_name % (0,7)=="Chapter "
		= chapter_name % (8,size chapter_name-1);
	| chapter_name % (0,8)=="Appendix "
		= chapter_name % (9,size chapter_name-1);
	| chapter_name=="Preface"
		= "P";
	| chapter_name=="Table of Contents"
		= "T";
	= chapter_name;

write_lines [line:lines] file = write_lines lines (fwrites line file);
write_lines [] file = file;

skip_to_double_quote i line
	| i<size line && line.[i]<>'"'
		= skip_to_double_quote (i+1) line;
		= i;

skip_to_dot i line
	| i<size line && line.[i]<>'.'
		= skip_to_dot (i+1) line;
		= i;

file_name_extension_from_href href
	# i = skip_to_dot 0 href;
	| i<size href
		= href % (0,i-1);
		= href;

update_href href chapter_name file_name line i
	# file_name_extension = file_name_extension_from_href href
	| file_name_extension==chapter_name
		= line % (0,i+size href-1);
		= line % (0,i-3)+++file_name+++file_name_extension+++".html#_"+++href;

update_hrefs i line chapter_name file_name
	// "<a href="#_
	| i+10<size line
		| line.[i]=='<'
			&& line.[i+1]=='a' && line.[i+2]==' ' && line.[i+3]=='h' && line.[i+4]=='r' && line.[i+5]=='e'
			&& line.[i+6]=='f' && line.[i+7]=='=' && line.[i+8]=='"' && line.[i+9]=='#' && line.[i+10]=='_'
			# i = i+11;
			# j = skip_to_double_quote i line;
			| j<size line
				# href = line % (i,j-1);
				# href = update_href href chapter_name file_name line i;
				= href+++update_hrefs 0 (line % (j,size line-1)) chapter_name file_name;
				= update_hrefs (i+1) line chapter_name file_name;
			= update_hrefs (i+1) line chapter_name file_name;
		= line;

write_chapters [(chapter_name,chapter_lines):chapters] header final_lines file_name w
	# chapter_file_name = file_name+++chapter_name+++".html";
	# (ok,file,w) = fopen chapter_file_name FWriteData w
	| not ok
		= abort "Could not create file";
	# file = write_lines header file;

	# chapter_lines = [update_hrefs 0 chapter_line chapter_name file_name\\chapter_line<-chapter_lines];
	
	# file = write_lines chapter_lines file;
	# file = write_lines final_lines file;
	# (ok,w) = fclose file w;
	| not ok
		= abort ("Could not write file: "+++chapter_file_name);	
	= write_chapters chapters header final_lines file_name w;
write_chapters [] header final_lines file_name w
	= w;

split_html_chapters :: !{#Char} !*World -> *World;
split_html_chapters file_name w
	# (ok,input_file,w) = fopen (file_name+++".html") FReadData w;
	| not ok
		= abort "Error: could not open file\n";
	# (header,chapter_line,input_file) = read_header input_file;
	# (chapters,final_lines,input_file) = read_chapters chapter_line input_file;
	# (ok,w) = fclose input_file w;
	# chapters = [(chapter_name_from_comment chapter_line,chapter_lines)\\(chapter_line,chapter_lines)<-chapters];
	= write_chapters chapters header final_lines file_name w;
/*
Start w
	= split_html_chapters "test" w;
*/