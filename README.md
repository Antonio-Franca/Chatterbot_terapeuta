O objetivo do trabalho era implementar de forma funcional o algoritmo do programa TALK, encontrado no livro Prolog and Natural Language Analysis e aplicá-los de forma a também conseguirem interpretar perguntas, além de, caso obtivessemos sucesso nas implementações já citadas, fazer com que o TALK funcionasse como um Chatter-Bot que simula um psicólogo.

O predicado principal do livro foi dado da seguinte forma:

```prolog
main_loop :-
	write('>> '),
	read_sent(Words),
	talk(Words, Reply), 
	print_reply(Reply),
	main_loop.
```

Ao inserir a regra acima no SWI-Prolog e inserirmos um novo fato que esteja de acordo com os nomes próprios e verbos já definidos na base de conhecimento (‘terry met bill’, por exemplo), temos um novo sintagma armazenado dinamicamente na sua base. Assim, se depois verificarmos a regra que foi *assertada,* veremos que ela será verdadeira.

![Screen Shot 2019-06-18 at 15.43.07.png](resources/B36B9EE99BA60976883215C6E348496D.png)

A implementação resultante do trabalho divide-se em duas: a primeira faz uma análise morfossintática da sentença, verificando o tipo de período, se é simples, composto ou pergunta, e a segunda temos um predicado em repetição que simula um diálogo agente-usuário, em que o agente passa por psicólogo. 

Na primeira implementação, para conectarmos a gramática definida em português, pouco aproveitou-se dos sintagmas e predicados originais do algoritmo. O predicado de leitura dos caractéres (read\_sent) da sentença inserida pelo usuário foi mantido. O predicado main\_loop ficou da forma:

```prolog
main_loop :-
	write('>> '),
	read_sent(Words),
	typeOfSentence(Words,Type),
	replySentenceType(Words, Type),
	wordMorphology(Words),
	main_loop.
```

Falaremos individualmente de cada linha



