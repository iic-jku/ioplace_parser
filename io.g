grammar io;

options {
	tokenVocab = ioLexer;
}

top: directive* EOF;

directive: annotation | direction | virtualPin | regex;

annotation: At Identifier (Equal (Float | Integer))?;
direction: Hash Direction;
regex: Regex | Identifier;
virtualPin: Dollar Integer;