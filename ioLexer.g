lexer grammar ioLexer;

Ws: Whitespace+ -> skip;
Direction: ((Cardinal 'R') | Cardinal) | 'BUS_SORT';
Integer: Digit+;
Float: Integer ('.' Integer)?;
Identifier: Nondigit (Nondigit | Digit)*;
At: '@';
Hash: '#';
Equal: '=';
Regex:
	'^'? (
		Digit
		| Nondigit
		| '.'
		| '+'
		| '*'
		| '?'
		| '\\'
		| '['
		| ']'
		| '('
		| ')'
		| '|'
	)+ '$'?;
Dollar: '$';

// Common
fragment Cardinal: ('N' | 'E' | 'W' | 'S');
fragment Whitespace: (' ' | '\t' | EOL);
fragment EOL: ('\n');
fragment NonEOL: ~('\n');
fragment Nondigit: [a-zA-Z_];
fragment Digit: [0-9];
