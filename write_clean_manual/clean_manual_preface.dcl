definition module clean_manual_preface;

from pdf_main import ::Page,::Headings,::Link;
from pdf_text import ::CharWidthAndKerns;

pages_p :: [{!CharWidthAndKerns} -> Page];
