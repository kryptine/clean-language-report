definition module clean_manual_syntax;

from pdf_main import ::Page,::Headings,::Link;
from pdf_text import ::CharWidthAndKerns;

pages_a :: [{!CharWidthAndKerns} -> Page];
