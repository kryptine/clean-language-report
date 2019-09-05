definition module parse_ttf;

parse_ttf_file :: !{#Char} !(Int->Int) !*World -> (!{!(Int,Int,[(Int,Int)])},!*World);
