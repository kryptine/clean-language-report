definition module clean_manual_lexical_syntax;

from pdf_main import ::Page,::Headings,::Link;
from pdf_text import ::CharWidthAndKerns;

pages_b :: [{!CharWidthAndKerns} -> Page];
