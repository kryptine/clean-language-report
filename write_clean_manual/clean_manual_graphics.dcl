definition module clean_manual_graphics;

from pdf_graphics import ::PictureElement;

clean_logo :: !Real !Real -> {#Char};
clean_logo_text :: !Real !Real -> {#Char};

picture_1 :: !Int -> [PictureElement];
picture_2 :: !Int -> [PictureElement];

move_text_cursor_y :: !Int !Int !{#Char} -> (!Int,!{#Char});

draw_down_right_up_arrow :: !Real !Real !Real !{#Char} -> {#Char};
picture_elements_down_right_up_arrow :: !Real !Real !Real -> [PictureElement];

clean_svg_logo :: {#Char};
clean_svg_picture :: !Real !Real ![PictureElement] -> {#Char};
clean_svg_picture_absolute :: !Real ![PictureElement] -> {#Char};
