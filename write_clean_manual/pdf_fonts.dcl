definition module pdf_fonts;

from pdf_text import ::CharWidthAndKerns;

microsoft_sans_serif_n :== 0;
courier_n :== 1;
courier_bold_n :== 2;

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

perpendicular_string :== "\x86"; // not in liberation sans

make_font_objects :: !Int ![{#Char}] !{!CharWidthAndKerns} -> (!Int,![{#Char}]);
read_font_files :: !*World -> (![{#Char}],!{!CharWidthAndKerns},!*World);
page_font_stream :: !{!CharWidthAndKerns} -> {#Char};
