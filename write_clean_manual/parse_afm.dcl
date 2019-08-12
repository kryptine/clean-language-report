definition module parse_afm;

parse_afm_file :: !{#Char} !*World -> (!{!(Int,Int,[(Int,Int)])},!*World);
