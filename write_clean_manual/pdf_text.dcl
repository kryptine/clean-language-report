definition module pdf_text;

:: Text = TString !{#Char} | TFont !Int !{#Char} !FontColor | TLink !{#Char};

:: FontColor = FCNo | FCBlack | FCRGB !(!Int,!Int,!Int);

:: Link = {
	link_begin_pos :: !Real,
	link_line_word_spacing :: !Real, // if <0.0 link width
	link_font_n :: !Int,
	link_font_size :: !Int,
	link_s :: !{#Char},
	link_y_pos :: !Int,
	link_extra_margin :: !Real
   };

:: CharWidthAndKerns :== {!(Int,Int,[(Int,Int)])};

char_width :: Int CharWidthAndKerns -> Int;
string_width :: !{#Char} !CharWidthAndKerns -> Int;
string_words_width :: !{#Char} !CharWidthAndKerns -> (![(Int,Int,Int,Int)],!Int);
text_words_width :: ![Text] !Int !{!CharWidthAndKerns} -> ([(Int,Int,Int,Int)],Int);
char_kern :: !Int !Int !CharWidthAndKerns -> Int;

count_spaces :: !Int !Int !{#Char} -> Int;

format_lines :: !{#Char} !Real !Int !CharWidthAndKerns -> (![{#Char}],!Int);
format_text :: ![Text] !Real !Int !Int !{!CharWidthAndKerns} -> (!(![({#Char},Int,Int)],![Text]),!Int);

print_formatted_string :: !{#Char} !CharWidthAndKerns -> {#Char};

split_lines :: ![(Int,Int,Int,Int)] !Int !Int {#Char} -> [{#Char}];
print_lines :: ![{#Char}] !Int !Real !CharWidthAndKerns -> {#Char};
print_new_lines :: ![{#Char}] !Int !Real !CharWidthAndKerns -> {#Char};
split_lines_slices :: ![(Int,Int,Int,Int)] !Int !Int {#Char} -> [({#Char},Int,Int)];
print_format_lines :: !(![({#Char},Int,Int)],![Text]) !Int !Int !Real !{!CharWidthAndKerns} -> (!{#Char},![Link]);

print_new_indented_lines :: ![{#Char}] !Int !Real !Real !CharWidthAndKerns -> {#Char};

compute_max_column_widths :: ![[([(Int,Int,Int,Int)],Int)]] !Int ![[[Text]]] -> [Int];
compute_table_widths_with_min_widths :: ![[[Text]]] ![Int] !Int !Int !Int !{!CharWidthAndKerns} -> [Int];
print_table :: ![[[Text]]] ![Int] !Int !Int !Int !{!CharWidthAndKerns} -> (!{#Char},![Link]);

make_table :: ![[[Text]]] !Int !Int !Int !{!CharWidthAndKerns} -> (!{#Char},![Link]);
make_table_min_widths :: ![[[Text]]] ![Int] !Int !Int !Int !{!CharWidthAndKerns} -> (!{#Char},![Link]);

rgb_8bit_last :: !Int !Int !Int -> {#Char};
rgb_8bit_last_t :: !(!Int,!Int,!Int) -> {#Char};
