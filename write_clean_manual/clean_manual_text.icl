implementation module clean_manual_text;

import StdEnv;
import pdf_text,clean_manual_styles;

courier_n :== 1;
courier_bold_n :== 2;

red_bold_s_in_courier s
	= [TFont courier_bold_n ("/F5 "+++toString font_size+++" Tf") (FCRGB (255,0,0)),
	   TString s,
	   TFont courier_n ("/F4 "+++toString font_size+++" Tf") FCBlack];

blue_s s = [TFont -1 "" (FCRGB (0,0,255)), TString s, TFont -1 "" FCBlack];

skip_to_ident_or_comment :: !Int !{#Char} -> Int;
skip_to_ident_or_comment i s
	| i<size s
		# c=s.[i]
		| c>='a' && c<='z' || c>='A' && c<='Z' || c=='_'
			= i;
		| c== '/'
			= i;
		| c== '\"'
			// to do: skip strings
			= size s;
			= skip_to_ident_or_comment (i+1) s;
		= i;

skip_to_space :: !Int !{#Char} -> Int;
skip_to_space i s
	| i<size s
		| s.[i]==' '
			= i;
			= skip_to_space (i+1) s;
		= i;

color_keywords :: ![Text] -> [Text];
color_keywords [t=:TString s:ts]
	= color_keywords_TString 0 s t ts;
where  {
	color_keywords_TString :: !Int !{#Char} !Text ![Text] -> [Text];
	color_keywords_TString i s t ts
		# i = skip_to_ident_or_comment i s;
		| i>=size s
			= [t:color_keywords ts];
		| i<size s-1 && s.[i]=='/' && s.[i+1]=='/'
			= [t:color_keywords ts];
		# j = skip_to_space i s;
		# word = s % (i,j-1);
		| word=="where" || word=="module" || word=="import" || word=="implementation" || word=="definition"
		|| word=="from" || word=="class" || word=="instance" || word=="case" || word=="of" || word=="otherwise"
		|| word=="let" || word=="in" || word=="with" || word=="infix" || word=="infixl" || word=="infixr"
		|| word=="generic" || word=="derive" || word=="dynamic"
			| i==0
				| j>=size s
					= red_bold_s_in_courier s++color_keywords ts;
					= red_bold_s_in_courier word++color_keywords [TString (s % (j,size s-1)):ts];
				# begin_s = TString (s % (0,i-1));
				| j>=size s
					= [begin_s:red_bold_s_in_courier word++color_keywords ts];
					= [begin_s:red_bold_s_in_courier word++color_keywords [TString (s % (j,size s-1)):ts]];
			= color_keywords_TString j s t ts;
}
color_keywords [t:ts] = [t:color_keywords ts];
color_keywords [] = [];

skip_to_slash :: !Int !{#Char} -> Int;
skip_to_slash i s
	| i<size s
		| s.[i]=='/'
			= i;
			= skip_to_slash (i+1) s;
		= i;

comment_blue :: ![Text] -> [Text];
comment_blue [t=:TString s:ts]
	# i = skip_to_slash 0 s;
	| i<size s-1 && s.[i+1]=='/'
		| i==0
			= blue_s s++comment_blue ts;
			= [TString (s % (0,i-1))]++blue_s (s % (i,size s-1))++comment_blue ts;
		= [t:comment_blue ts];
comment_blue [t:ts] = [t:comment_blue ts];
comment_blue [] = [];

syntax_color :: ![Text] -> [Text];
syntax_color t = comment_blue (color_keywords t);
