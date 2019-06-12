% TALK Program

% Operators

:- op(500,xfy,&). 
:- op(510,xfy, =>). 
:- op(100,fx, 'opd').

gramatic :-
	open('gramAtual.pl',read,X),
	set_input(X), 
	code_reading,
	close(X).

%%% 						Dialogue Manager

main :-
 	write('DICA: NAO USE ACENTOS rsrs'), nl, nl,
	write('Ola, eu sou Shrink, seu terapeuta'),nl,
	write('Como voce esta?'),nl,
	read_sent(Words), 
	talk(Words, Reply),  
	main_loop(Reply).

main_loop(Reply) :-
	nl,write(Reply),nl,
	% write('>> '),nl,nl, % prompt the user 
	read_sent(Words), % read a sentence 
	talk(Words, NewReply), % process it with TALK 
	main_loop(NewReply). % pocess more sentences

%%%  				REGRA DE INTERACAO HUMANO-AGENTE %%%

talk(Sentence, Reply) :-
	% parse the sentence
	% clause, if possible
	typeOfSentence(Sentence,Type),
	parse(Sentence, Type),
	therapist(Sentence,Reply).
	%(therapist(Sentence,Reply,Pronome);therapist(Sentence,Reply)).

% No parse was found, sentence is too difficult. 
talk(_Sentence, Reply) :-
	answer(error,Reply).


%%%					ANÁLISE SINTÁTICA GERAL %%%%

parse(Sentence, assertion) :-
	sentenca(Numero, Genero, Sentence, []).

% Parsing a query: a question.

parse(Sentence, question) :-
    questao(Numero, Genero, Sentence, []).

%%% 				ANÁLISE DA SENTENÇA COMO PERGUNTA %%%%

parse_question :-
	ler(Words),
	isAQuestion(Words),!.

isAQuestion(Sentence) :-
	questao(_Numero,_Genero,Sentence,[]),
	write('It is a question!').

isAQuestion(_Sentence) :-
	write('It is not a question!').


%%%%				DESENVOLVIMENTO DO AGENTE %%%%%

context(Sentence,Theme) :-
	assunto(Word,Theme),
	member(Word,Sentence).


typeOfSentence(Sentence,question) :-
	member(?,Sentence).

typeOfSentence(_Sentence,assertion).


member(X,[X|_]).
member(X,[_|Y]):-
	member(X,Y).


therapist(Sentence,Reply) :-
	context(Sentence,Theme),
	answer(Theme,Reply).

therapist(_Sentence,Reply) :-
	answer(outOfKB,Reply).


%%%%% 				LEITURA DA SENTENCA 			%%%%%%%

read_sent(Words) :-
	get0(Char), % prime the lookahead 
	read_sent(Char, Words). % get the words

% Newlines end the input. 
read_sent(C, []) :- 
	newline(C), !.

% Spaces are ignored.
read_sent(C, Words) :- 
	space(C), !,
    get0(Char),
    read_sent(Char, Words).

% Everything else starts a word. 
read_sent(Char, [Word|Words]) :-
	read_word(Char, Chars, Next),
	name(Word, Chars),
	read_sent(Next, Words).

% Space and newline end a word. 
read_word(C, [], C) :- 
	space(C), !. 

read_word(C, [], C) :- 
	newline(C), !.

% All other chars are added to the list. 
read_word(Char, [Char|Chars], Last) :-
	get0(Next),
	read_word(Next, Chars, Last).


%%% space(Char)
%%% ===========
%%%
%%% Char === the ASCII code for the space
%%% 		 character

space(32).

%%% newline(Char)
%%% =============
%%%
%%% Char === the ASCII code for the newline
%%%			 character

newline(10).
















%%%%									OUTRA OPCAO DE LEITURA %%%
 
%%% Read in a sentence - "?-ler(S)"
ler([W|Ws]) :- 
	get_char(C), lepalavra(C, W, C1), resto_enviado(W, C1, Ws).

%%% Given a word and the character after it, read in the rest of the sentence 
resto_enviado(W, _, []) :- 
	ultima_palavra(W), !.
resto_enviado(W, C, [W1|Ws]) :- 
	lepalavra(C, W1, C1), resto_enviado(W1, C1, Ws).


%%% Read in a single word, given an initial character, and remembering which character came after the word.

lepalavra(C, C, C1) :- 
	caractere_unico(C), !, get_char(C1).

lepalavra(C, W, C2) :- 
	na_palavra(C, NewC),
	!,
	get_char(C1),
	resta_palavra(C1, Cs, C2), 
	atom_chars(W, [NewC|Cs]).


lepalavra(C, W, C2) :- 
	get_char(C1), lepalavra(C1, W, C2).
resta_palavra(C,[NewC|Cs], C2) :- 
	na_palavra(C, NewC),!,
	get_char(C1), 
	resta_palavra(C1, Cs, C2). 
resta_palavra(C, [], C).


%%% These characters can appear within a word. The second na_palavra clause converts letras to lower-case 
na_palavra(C, C) :- 
	letra(C, _). 

na_palavra(C, L) :- 
	letra(L, C). 

na_palavra(C, C) :- 
	digito(C). 

na_palavra(C, C) :- 
	caractere_especial(C). 

membro(X,[X|_]).
membro(X,[_|Y]):-
	membro(X,Y).

							%%% Special characters 
caractere_especial('-'). 
caractere_especial('').

			%%% These characters form words on their own
caractere_unico(','). 
caractere_unico('.'). 
caractere_unico(';').
caractere_unico(':').
caractere_unico('?'). 
caractere_unico('!').

					%%% Upper and lower case letras 
letra(a, 'A'). 
letra(b, 'B'). 
letra(c, 'C'). 
letra(d, 'D'). 
letra(e, 'E'). 
letra(f, 'F'). 
letra(g, 'G'). 
letra(h, 'H'). 
letra(i, 'I'). 
letra(j, 'J'). 
letra(k, 'K').
letra(n, 'N'). 
letra(o, 'O'). 
letra(p, 'P'). 
letra('q', 'Q').
letra(r, 'R'). 
letra('s', 'S').
letra(t, 'T'). 
letra(u, 'U').
letra(v, 'V'). 
letra(w, 'W'). 
letra('x', 'X').
letra('y', 'Y'). 
letra(z, 'Z').
letra(l, 'L'). 
letra('m', 'M').

					%%% digitos
digito('0'). 
digito('1'). 
digito('2'). 
digito('3'). 
digito('4').
digito('5'). 
digito('6'). 
digito('7'). 
digito('8'). 
digito('9').

				%%% These words terminate a sentence
ultima_palavra('.'). 
ultima_palavra('!'). 
ultima_palavra('?').

spaces(0) :- !.
spaces(N) :- write(' '), N1 is N - 1, spaces(N1).


phh([]) :- nl.
phh([H|T]) :- 
	write(H),
	spaces(1), 
	phh(T).

% CARACTERES

caractere_unico --> [,]. 
caractere_unico --> [.]. 
caractere_unico --> [;].
caractere_unico --> [:].
caractere_unico --> [!].