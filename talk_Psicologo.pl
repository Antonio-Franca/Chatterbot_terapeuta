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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% 						Dialogue Manager


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% 				ANÁLISE DA SENTENÇA COMO PERGUNTA %%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse_question :-
	ler(Words),
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