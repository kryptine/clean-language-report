implementation module pdf_fonts;

import StdEnv,pdf_text,parse_ttf;

make_object i s
	= toString i+++" 0 obj "+++s+++"\nendobj\n";

make_font_stream s
	= "<< /Length "+++toString (size s)+++" /Length1 "+++toString (size s)+++" >>\nstream\n"+++s+++"\nendstream";

MS_OR_LIBERATION ms liberation
//	:== ms;
	:== liberation;

COURIER_NIMBUS_OR_LIBERATION courier nimbus liberation
//	:== courier;//nimbus;//liberation;;
	:== nimbus;
//	:== liberation;;

//times_roman_font = "<< /Type /Font /Subtype /Type1 /BaseFont /Times-Roman >>";
//arial_font = "<< /Type /Font /Subtype /Type1 /BaseFont /Arial >>";
//microsoft_sans_serif_font = "<< /Type /Font /Subtype /Type1 /BaseFont /MicrosoftSansSerif >>";

dieresis :== "\212";//"\xa8";
adieresis :== "\xf6";
odieresis :== "\xf6";

adieresis_string :== "\xe4"; // 228 unicode
odieresis_string :== "\xf6"; // 246 unicode

lessequal_string :== "\x80";
greaterequal_string :== "\x81";
sigma_string :== "\x82";
tau_string :== "\x83";
Sigma_string :== "\x84";
Tau_string :== "\x85";

liberation_sans_font_descriptor
	= "<< /Type /FontDescriptor /FontName /LiberationSans /Flags 32"+++
	" /FontFile2 6 0 R"+++
	" >>";
liberation_sans_italic_font_descriptor
	= "<< /Type /FontDescriptor /FontName /LiberationSans-Italic /Flags 96"+++
	" /FontFile2 7 0 R"+++
	" >>";
liberation_sans_bold_font_descriptor
	= "<< /Type /FontDescriptor /FontName /LiberationSans-Bold /Flags 32"+++
	" /FontFile2 8 0 R"+++
	" >>";

differences_s
	= "/Differences [128 /lessequal /greaterequal /sigma /tau /Sigma /Tau 196 /Adieresis 225 /aacute 228 /adieresis 246 /odieresis 241 /ntilde 243 /oacute]";

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

liberation_sans_font char_width_and_kerns
	= "<< /Type /Font /Subtype /TrueType /BaseFont /LiberationSans"+++
	" /FontDescriptor 11 0 R"+++
	" /Encoding << /Type /Encoding "+++differences_s+++" >>"+++
//	" /Encoding << /Type /Encoding /BaseEncoding (WinAnsiEncoding) /Differences [228 /adieresis 246 /odieresis] >>"+++
	first_char_last_char_and_widths microsoft_sans_serif_n char_width_and_kerns.[microsoft_sans_serif_n]+++" >>";
liberation_sans_italic_font char_width_and_kerns
	= "<< /Type /Font /Subtype /TrueType /BaseFont /LiberationSans-Italic"+++
//	" /Encoding (WinAnsiEncoding)"+++
	" /Encoding << /Type /Encoding /BaseEncoding (WinAnsiEncoding) /Differences [] >>"+++
	" /FontDescriptor 12 0 R"+++
	first_char_last_char_and_widths microsoft_sans_serif_n char_width_and_kerns.[microsoft_sans_serif_n]+++" >>";
liberation_sans_bold_font char_width_and_kerns
	= "<< /Type /Font /Subtype /TrueType /BaseFont /LiberationSans-Bold"+++
	" /FontDescriptor 13 0 R"+++
	" /Encoding << /Type /Encoding "+++differences_s+++" >>"+++
//	" /Encoding << /Type /Encoding /BaseEncoding (WinAnsiEncoding) /Differences [228 /adieresis 246 /odieresis] >>"+++
	first_char_last_char_and_widths microsoft_sans_serif_n char_width_and_kerns.[microsoft_sans_serif_n]+++" >>";

microsoft_sans_serif_font = "<< /Type /Font /Subtype /Type1 /BaseFont /MicrosoftSansSerif"+++
//	" /Encoding << /Type /Encoding /Differences [1 /bullet /ellipsis] >>"+++
	" >>";

microsoft_sans_serif_italic_font
	= "<< /Type /Font /Subtype /TrueType /BaseFont /MicrosoftSansSerif,Italic >>";
microsoft_sans_serif_bold_font
	= "<< /Type /Font /Subtype /TrueType /BaseFont /MicrosoftSansSerif,Bold >>";

perpendicular_string :== "\x86"; // not in liberation sans

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

differences2_s
	= "/Differences [128 /lessequal /greaterequal /sigma /tau /Sigma /Tau /perpendicular]";

nimbus_mono_font_descriptor
	= "<< /Type /FontDescriptor /FontName /NimbusMonoPS-Regular /Flags 33"+++
	" /FontFile2 9 0 R"+++
	" >>";
nimbus_mono_font_bold_descriptor
	= "<< /Type /FontDescriptor /FontName /NimbusMonoPS-Bold /Flags 33"+++
	" /FontFile2 10 0 R"+++
	" >>";

//nimbus_mono_font = "<< /Type /Font /Subtype /Type1 /BaseFont /NimbusMono >>";
nimbus_mono_font char_width_and_kerns
	= "<< /Type /Font /Subtype /TrueType /BaseFont /NimbusMonoPS-Regular"+++
//	" /Encoding (WinAnsiEncoding)"+++
	" /Encoding << /Type /Encoding "+++differences2_s+++" >>"+++
//	" /Encoding << /Type /Encoding /BaseEncoding (WinAnsiEncoding) /Differences [] >>"+++
	" /FontDescriptor 14 0 R"+++
	first_char_last_char_and_widths courier_n char_width_and_kerns.[courier_n]+++" >>";
//nimbus_mono_font = "<< /Type /Font /Subtype /Type1 /BaseFont /NimbusMono-Regular >>";
nimbus_mono_bold_font char_width_and_kerns
	= "<< /Type /Font /Subtype /TrueType /BaseFont /NimbusMonoPS-Bold"+++
//	" /Encoding (WinAnsiEncoding)"+++
//	" /Encoding << /Type /Encoding /BaseEncoding (WinAnsiEncoding) /Differences [] >>"+++
	" /FontDescriptor 15 0 R"+++
	first_char_last_char_and_widths courier_bold_n char_width_and_kerns.[courier_bold_n]+++" >>";
//nimbus_mono_bold_font = "<< /Type /Font /Subtype /Type1 /BaseFont /NimbusMono-Bold >>";

liberation_mono_font = "<< /Type /Font /Subtype /TrueType /BaseFont /LiberationMono >>";
liberation_mono_bold_font = "<< /Type /Font /Subtype /TrueType /BaseFont /LiberationMono-Bold >>";

courier_font = "<< /Type /Font /Subtype /Type1 /BaseFont /Courier >>";
courier_bold_font = "<< /Type /Font /Subtype /Type1 /BaseFont /Courier-Bold >>";

get_first_and_last_char font_cwk
	# (first_char,_,_) = font_cwk.[0];
	# last_char = find_last_char (size font_cwk-1) font_cwk;
	with {
		find_last_char i cwk
			# (char,_,_) = font_cwk.[i];
			| char<256
				= char;
			= find_last_char (i-1) cwk;
	}
	= (first_char,last_char);

first_char_last_char_and_widths font_n font_cwk
	# (first_char,last_char) = get_first_and_last_char font_cwk
	= " /FirstChar "+++toString first_char+++" /LastChar "+++toString last_char
	+++" /Widths "+++toString (font_n+3)+++" 0 R";

get_first_and_last_char_and_widths font_cwk
	# (first_char,last_char) = get_first_and_last_char font_cwk
	= (first_char,last_char,[char_width char font_cwk\\char<-[first_char..last_char]]);

make_font_width_table font_cwk
	# (first_char,last_char,char_widths) = get_first_and_last_char_and_widths font_cwk
//	= "["+++concat_strings_with_separator " " [toString width\\width<-char_widths]+++"]";
	= "["+++concat_strings_with_separator " " [toString (if (width==0) 600 width) \\width<-char_widths]+++"]";

concat_strings_with_separator s l=:[e] = e;
concat_strings_with_separator s [e:l] = e+++s+++concat_strings_with_separator s l;

microsoft_sans_serif_n :== 0;
courier_n :== 1;
courier_bold_n :== 2;

font1 char_width_and_kerns
	= MS_OR_LIBERATION microsoft_sans_serif_font (liberation_sans_font char_width_and_kerns);
font2 char_width_and_kerns
	= MS_OR_LIBERATION microsoft_sans_serif_italic_font (liberation_sans_italic_font char_width_and_kerns);
font3 char_width_and_kerns
	= MS_OR_LIBERATION microsoft_sans_serif_bold_font (liberation_sans_bold_font char_width_and_kerns);
font4 char_width_and_kerns
	= COURIER_NIMBUS_OR_LIBERATION courier_font (nimbus_mono_font char_width_and_kerns) liberation_mono_font;
font5 char_width_and_kerns
	= COURIER_NIMBUS_OR_LIBERATION courier_bold_font (nimbus_mono_bold_font char_width_and_kerns) liberation_mono_bold_font;

make_font_width_objects font_n page_object_n char_width_and_kerns
	| font_n<size char_width_and_kerns
		# font_width_object = make_object page_object_n (make_font_width_table char_width_and_kerns.[font_n])
		# (page_object_n,font_width_objects) = make_font_width_objects (font_n+1) (page_object_n+1) char_width_and_kerns;
		= (page_object_n,[font_width_object:font_width_objects]);
		= (page_object_n,[]);

make_font_file_objects [font_file_s:font_file_s_l] page_object_n
	# font_file_object = make_object page_object_n (make_font_stream font_file_s);
	  page_object_n=page_object_n+1;
	  (font_file_s_l,page_object_n) = make_font_file_objects font_file_s_l page_object_n;
	= ([font_file_object:font_file_s_l],page_object_n);
make_font_file_objects [] page_object_n
	= ([],page_object_n);

make_font_objects :: !Int ![{#Char}] !{!CharWidthAndKerns} -> (!Int,![{#Char}]);
make_font_objects page_object_n font_file_s_l char_width_and_kerns
	# (page_object_n,font_width_objects) = make_font_width_objects 0 page_object_n char_width_and_kerns;
	# (font_file_objects,page_object_n) = make_font_file_objects font_file_s_l page_object_n;
	# font_1_descriptor = make_object page_object_n liberation_sans_font_descriptor;
	  page_object_n=page_object_n+1;
	# font_2_descriptor = make_object page_object_n liberation_sans_italic_font_descriptor;
	  page_object_n=page_object_n+1;
	# font_3_descriptor = make_object page_object_n liberation_sans_bold_font_descriptor;
	  page_object_n=page_object_n+1;
	# font_4_descriptor = make_object page_object_n nimbus_mono_font_descriptor;
	  page_object_n=page_object_n+1;
	# font_5_descriptor = make_object page_object_n nimbus_mono_font_bold_descriptor;
	  page_object_n=page_object_n+1;
	# font_1 = make_object page_object_n (font1 char_width_and_kerns);
	  page_object_n=page_object_n+1;
	# font_2 = make_object page_object_n (font2 char_width_and_kerns);
	  page_object_n=page_object_n+1;
	# font_3 = make_object page_object_n (font3 char_width_and_kerns);
	  page_object_n=page_object_n+1;
	# font_4 = make_object page_object_n (font4 char_width_and_kerns);
	  page_object_n=page_object_n+1;
	# font_5 = make_object page_object_n (font5 char_width_and_kerns);
	  page_object_n=page_object_n+1;
	= (page_object_n,
		font_width_objects++font_file_objects++[
		font_1_descriptor,font_2_descriptor,font_3_descriptor,font_4_descriptor,font_5_descriptor,
		font_1,font_2,font_3,font_4,font_5
		]);

read_font font_file_name world
	# (ok,font_file,world) = fopen font_file_name FReadData world;
	| not ok
		= abort ("fopen "+++font_file_name+++" failed");
	# (font_file_s,font_file) = freads font_file 1000000;
	| size font_file_s==1000000
		= abort "read_font"; // to do
	# (ok,world) = fclose font_file world;
	| not ok
		= abort "fclose failed";
	= (font_file_s,world);

read_font_files :: !*World -> (![{#Char}],!{!CharWidthAndKerns},!*World);
read_font_files world
	# ttf_file_name = MS_OR_LIBERATION "micross.ttf" "LiberationSans-Regular.ttf"
	# (microsoft_or_liberation_sans_serif_cwk,world) = parse_ttf_file ttf_file_name ls_unicode_to_adobe_encoding world;
	# ttf_file_name = COURIER_NIMBUS_OR_LIBERATION "COM_____.TTF" "NimbusMonoPS-Regular.ttf" "COM_____.TTF";
	# (courier_cwk,world) = parse_ttf_file ttf_file_name c_unicode_to_adobe_encoding world;
	# ttf_file_name = COURIER_NIMBUS_OR_LIBERATION "COB_____.TTF" "NimbusMonoPS-Bold.ttf" "COB_____.TTF";
	# (courier_bold_cwk,world) = parse_ttf_file ttf_file_name c_unicode_to_adobe_encoding world;
	
	# char_width_and_kerns = {!microsoft_or_liberation_sans_serif_cwk,courier_cwk,courier_bold_cwk};

//	= [get_first_and_last_char_and_widths cwk \\ cwk<-:char_width_and_kerns];

	# font_file_name1 = "LiberationSans-Regular.ttf";
	# (font_file_s1,world) = read_font font_file_name1 world;
	# font_file_name2 = "LiberationSans-Italic.ttf";
	# (font_file_s2,world) = read_font font_file_name2 world;
	# font_file_name3 = "LiberationSans-Bold.ttf";
	# (font_file_s3,world) = read_font font_file_name3 world;
	# font_file_name4 = "NimbusMonoPS-Regular.ttf";
	# (font_file_s4,world) = read_font font_file_name4 world;
	# font_file_name5 = "NimbusMonoPS-Bold.ttf";
	# (font_file_s5,world) = read_font font_file_name5 world;
	# font_file_s_l = [font_file_s1,font_file_s2,font_file_s3,font_file_s4,font_file_s5];
	= (font_file_s_l,char_width_and_kerns,world);

page_font_stream :: !{!CharWidthAndKerns} -> {#Char};
page_font_stream char_width_and_kerns
	= "/F1 16 0 R /F2 17 0 R /F3 18 0 R /F4 19 0 R /F5 20 0 R";
/*
	MS_OR_LIBERATION
		("/F1 "+++microsoft_sans_serif_font+++
		 " /F2 "+++microsoft_sans_serif_italic_font+++
		 " /F3 "+++microsoft_sans_serif_bold_font)
		("/F1 "+++liberation_sans_font char_width_and_kerns+++
		 " /F2 "+++liberation_sans_italic_font char_width_and_kerns+++
		 " /F3 "+++liberation_sans_bold_font char_width_and_kerns
		)
	+++
	COURIER_NIMBUS_OR_LIBERATION
 		(" /F4 "+++courier_font+++
		 " /F5 "+++courier_bold_font)
		(" /F4 "+++nimbus_mono_font char_width_and_kerns+++
		 " /F5 "+++nimbus_mono_bold_font char_width_and_kerns)
		(" /F4 "+++liberation_mono_font+++
		 " /F5 "+++liberation_mono_bold_font);
*/
