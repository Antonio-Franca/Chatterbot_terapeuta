%%%%%	Iniciar o programa:
% '?- main_livro.'  


main_livro :-
	write('>> '),
	read_sent(Words),
	typeOfSentence(Words,Type),
	replySentenceType(Words, Type),
	wordMorphology(Words),
	main_livro.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%				PERGUNTA OU AFIRMACAO %%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


typeOfSentence(Sentence,question) :-
	member(?,Sentence).

typeOfSentence(_Sentence,assertion).


member(X,[X|_]).
member(X,[_|Y]):-
	member(X,Y).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% 				PRINT DA ANALISE SINTATICA			%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

replySentenceType(Sentence, question) :-
	questao(Num,Gen,Sentence,[]),
	nl,write('Pergunta:'),nl.

replySentenceType(Sentence, assertion) :-
	periodoSimples(Num,Gen,Sentence,[]),
	nl,write('Periodo Simples:'),nl,nl.

replySentenceType(Sentence, assertion) :-
	periodoComposto(Num,Gen,Sentence,[]),
	nl,write('Periodo Composto:'),nl,nl.

wordMorphology([?]).
wordMorphology([]).
wordMorphology([Sentence|Rest]) :-
	(pronomeVerify(Sentence);
	artigoVerify(Sentence);
	substantivoVerify(Sentence);
	verboVerify(Sentence);
	adjetivoVerify(Sentence);
	numeralVerify(Sentence);
	adverbioVerify(Sentence);
	preposicaoVerify(Sentence);
	conjuncaoVerify(Sentence);
	interjeicaoVerify(Sentence);
	pontoOuVirgula(Sentence)),
	wordMorphology(Rest).

pontoOuVirgula(Word) :-
	caractere_unico([Word],[]),
	nl,write('Ponto ou virgula'),nl,nl.

pronomeVerify(Word) :-
	pronome(Num,Gen,[Word],[]),
	write('Pronome:       '),
	write(Word),nl.

artigoVerify(Word) :-
	artigo(Num,Gen,[Word],[]),
	write('Artigo:        '),
	write(Word),nl.

substantivoVerify(Word) :-
	substantivo(Num,Gen,[Word],[]),
	write('Substantivo:   '),
	write(Word),nl.

verboVerify(Word) :-
	verbo(Num,[Word],[]),
	write('Verbo:         '),
	write(Word),nl.

adjetivoVerify(Word) :-
	adjetivo(Num,Gen,[Word],[]),
	write('Adjetivo:      '),
	write(Word),nl.


numeralVerify(Word) :-
	numeral(Num,[Word],[]),
	write('Numeral:       '),
	write(Word),nl.

adverbioVerify(Word) :-
	adverbio(Num,[Word],[]),
	write('Adverbio:      '),
	write(Word),nl.

preposicaoVerify(Word) :-
	preposicao(Num,[Word],[]),
	write('Preposicao:    '),
	write(Word),nl.

conjuncaoVerify(Word) :-
	conjuncao([Word],[]),
	write('Conjuncao:     '),
	write(Word),nl.

interjeicaoVerify(Word) :-
	interjeicao(Num,Gen,[Word],[]),
	write('Interjeicao:   '),
	write(Word),nl.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% unica parte que eu aproveitei do codigo do livro 
%%%%%%%%%%%%%%% foi essa:

%%%%% 				LEITURA DA SENTENCA 			%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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