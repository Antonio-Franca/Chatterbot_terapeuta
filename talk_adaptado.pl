q(VP) --> whpron, vp(VP, nogap).
q(X^S) --> whpron, sinv(S, gap(np, X)). 
q(yes^S) --> sinv(S, nogap).
s(S) --> s(S, nogap).
s(S, Gap) --> np(VP^S, nogap), vp(VP, Gap).
sinv(S, GapInfo) --> aux, np(VP^S, nogap), vp(VP, GapInfo).
np(NP, nogap) --> det(N2^NP), n(N1), optrel(N1^N2). 
np((E^S)^S, nogap) --> pn(E).
np((X^S)^S, gap(np, X)) --> [].
vp(X^S, Gap) --> tv(X^VP), np(VP^S, Gap). 
vp(VP, nogap) --> iv(VP).
optrel(N^N) --> []. 
optrel((X^S1)^(X^(S1 ; S2))) --> relpron, vp(X^S2, nogap). 
optrel((X^S1)^(X^(S1 ; S2))) --> relpron, s(S2, gap(np, X)).
det(LF) --> [D], {det(D, LF)}.
det(every, (X^S1)^(X^S2)^all(X,(S1 -> S2))). 
det(a, (X^S1)^(X^S2)^exists(X,S1 ; S2)).
n(LF) --> [N], {n(N, LF)}. 
n( program, X^program(X)). 
n( student, X^student(X) ).
pn(E) --> [PN], {pn(PN, E)}. 
pn( terry, terry ).
pn( shrdlu, shrdlu ).
tv(LF) --> [TV], {tv(TV, LF)}. 
tv( wrote, X^Y^wrote(X,Y) ).
iv(LF) --> [IV], {iv(IV, LF)}. 
iv( halts, X^halts(X) ).
relpron --> [RelPron], {relpron(Relpron)}. 
relpron(that). 
relpron(who). 
relpron(whom).

whpron( who ). 
whpron( whom ). 
whpron( what ).


talk(Sentence, Reply) :-
	parse(Sentence, LF, Type), 
	clausify(LF, Clause, FreeVars),
	!, 
	reply(Type, FreeVars, Clause, Reply).

talk(Sentence, error('Prossiga...')).

# parse(Sentence, LF, assertion):-
# 	s(finite, LF, nogap, Sentence, []).

	
parse(Sentence, LF, query) :- 
	q(LF, Sentence, []).

clausify(all(X,F0),F,[X|V]) :- 
	clausify(F0,F,V).

clausify(A0 -> C0,(C:- A),V) :- 
	clausify_literal(C0,C), 
	clausify_antecedent(A0,A,V).

clausify(C0,C,[]) :- 
	clausify_literal(C0,C).

clausify_antecedent(L0,L,[]) :- 
	clausify_literal(L0,L).

clausify_antecedent(E0;F0,(E,F),V) :- 
	clausify_antecedent(E0,E,V0), 
	clausify_antecedent(F0,F,V1), 
	conc(V0,V1,V).

clausify_antecedent(exists(X,F0),F,[X|V]) :- 
	clausify_antecedent(F0,F,V).

reply(assertion, _FreeVars, Assertion, asserted(Assertion)) :-
	assert(Assertion), !.

reply(query, FreeVars, (answer(Answer):-Condition), Reply) :-
	(setof(Answer, FreeVars^Condition, Answers) -> Reply = Answers
	; Reply = [no]), !.

reply(_Type, _FreeVars, _Clause, error('unknown type')).