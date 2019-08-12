definition module pdf_outline;

:: Outline = Outline !(!{#Char},!{#Char}) !Int !Int ![Outline];

:: Headings :== [(Int,{#Char},{#Char},Int)];

outlines_object :: !Int !Int -> {#Char};

add_headings :: ![(Int,{#Char},{#Char},Int,Int)] ![Outline] -> [Outline];
outlines_to_pdf_objects :: ![Outline] !Int !Int -> (![{#Char}],!Int,!Int,!Int);

write_html_outline :: ![Outline] !*File -> *File;
