% TALK Program

% Operators

:- op(500,xfy,&). 
:- op(510,xfy, =>). 
:- op(100,fx, 'opd').

gramatic :-
	include('gramAtual.pl').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% 						Dialogue Manager


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main :-
	['Users/caiotelles/Desktop/Trab03_IA/gramAtual.pl'],
 	write('DICA: NAO USE ACENTOS rsrs'), nl, nl,
	write('Ola, eu sou Shrink, seu terapeuta'),nl,
	write('Como voce esta?'),nl,
	read_sent(Words), 
	talk(Words, Reply),  
	main_loop(Reply).

main_loop(Reply) :-
	nl,write(Reply),nl,
	read_sent(Words), 
	talk(Words, NewReply),
	main_loop(NewReply). 

main_livro :-
	write('>> '),
	read_sent(Words),
	typeOfSentence(Words,Type),
	replySentenceType(Words, Type),
	wordMorphology(Words),
	main_livro.


%%%  				REGRA DE INTERACAO HUMANO-AGENTE 			%%%

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% 				ANÁLISE DA SENTENÇA COMO PERGUNTA %%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse_question :-
	read_sent(Words),
	isAQuestion(Words),!.

isAQuestion(Sentence) :-
	questao(_Numero,_Genero,Sentence,[]),
	write('It is a question!').

isAQuestion(_Sentence) :-
	write('It is not a question!').


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%				DESENVOLVIMENTO DO AGENTE %%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% 				PRINT DA ANALISE 			%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

replySentenceSimpleType(Sentence, question) :-
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

