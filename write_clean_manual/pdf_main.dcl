definition module pdf_main;

from pdf_text import ::CharWidthAndKerns,::Link;
from pdf_outline import ::Headings;

:: Page :== (!{#Char},!{#Char},!Headings,![Link]);

write_pdf :: !{#Char} ![{!CharWidthAndKerns} -> Page] !Real !Real !*World -> (!Bool,!*World);
