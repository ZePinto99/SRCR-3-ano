%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SIST. REPR. CONHECIMENTO E RACIOCINIO - MiEI/3

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Trabalho individual - A84590

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: Declaracoes iniciais

:- set_prolog_flag( discontiguous_warnings,off ).
:- set_prolog_flag( single_var_warnings,off ).
:- set_prolog_flag( unknown,fail ).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% SICStus PROLOG: definicoes iniciais

:-[baseConhecimento].

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%resolução caminho
caminho(A,B,P) :- caminho1(A,[B],P).
caminho1(A,[A|P1],[A|P1]).
caminho1(A,[Y],P):- aresta(X,Y), caminho1(A,[X,Y],P).
caminho1(A,[Y|P1],P) :-
     aresta(X,Y), \+ memberchk(X,[Y|P1]), caminho1(A,[X,Y|P1],P).


%resolução pp
resolve_pp(Nodo, Destino, [Nodo|Caminho]) :-
    profundidadeprimeiro(Nodo, Destino, Caminho).

profundidadeprimeiro(Nodo, Destino,[]) :-
    Nodo == Destino, !.

profundidadeprimeiro(Nodo, Destino,[ProxNodo|Caminho]) :-
    aresta(Nodo, ProxNodo),
    profundidadeprimeiro(ProxNodo, Destino,Caminho).


%aestrela
resolve_aestrela(Nodo, Destino, Caminho/Custo) :- 
        weight_list([Nodo,Destino],Estima),
        aestrela([[Nodo]/0/Estima], InvCaminho/Custo/_, Destino,40),
        inverso(InvCaminho, Caminho),!.

aestrela(Caminhos, Caminho, Destino,LIMIT) :- LIMIT>0,
        obtem_melhor(Caminhos, Caminho),
        Caminho = [Nodo|_]/_/_,
        Nodo==Destino.

aestrela(Caminhos, SolucaoCaminho, Destino, LIMIT) :-
        LIMIT>0, INC is LIMIT - 1, !,
        obtem_melhor(Caminhos, MelhorCaminho),
        seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
        expande_aestrela(Destino,MelhorCaminho, ExpCaminhos),
        append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        aestrela(NovoCaminhos, SolucaoCaminho, Destino,INC).     


obtem_melhor([Caminho], Caminho) :- !.

obtem_melhor([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
        Custo1 + Est1 =< Custo2 + Est2, !, %>
        obtem_melhor([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
    
obtem_melhor([_|Caminhos], MelhorCaminho) :- 
        obtem_melhor(Caminhos, MelhorCaminho).

expande_aestrela(Destino, Caminho, ExpCaminhos) :- !,
        findall(NovoCaminho, adjacente(Destino,Caminho,NovoCaminho), ExpCaminhos).

adjacente(Destino,[Nodo|Caminho]/Custo/_, [ProxNodo,Nodo|Caminho]/NovoCusto/Est) :-
        aresta(Nodo, ProxNodo),\+ member(ProxNodo, Caminho),
        weight_list([Nodo,ProxNodo],PassoCusto),
        NovoCusto is Custo + PassoCusto,
        weight_list([ProxNodo,Destino],Est).


%gulosa
resolve_gulosa(Nodo, Destino,Caminho/Custo) :-
    weight_list([Nodo,Destino],Estima),
    agulosa([[Nodo]/0/Estima], Destino, InvCaminho/Custo/_),
    inverso(InvCaminho, Caminho).

agulosa(Caminhos, Destino, Caminho) :-
    obtem_melhor_g(Caminhos, Caminho),
    Caminho = [Nodo|_]/_/_, Nodo == Destino.

agulosa(Caminhos, Destino,  SolucaoCaminho) :-
    obtem_melhor_g(Caminhos, MelhorCaminho),
    seleciona(MelhorCaminho, Caminhos, OutrosCaminhos),
    expande_gulosa(MelhorCaminho, Destino, ExpCaminhos),
    append(OutrosCaminhos, ExpCaminhos, NovoCaminhos),
        agulosa(NovoCaminhos, Destino, SolucaoCaminho).      


obtem_melhor_g([Caminho], Caminho) :- !.

obtem_melhor_g([Caminho1/Custo1/Est1,_/Custo2/Est2|Caminhos], MelhorCaminho) :-
    Est1 =< Est2, !, %>
    obtem_melhor_g([Caminho1/Custo1/Est1|Caminhos], MelhorCaminho).
    
obtem_melhor_g([_|Caminhos], MelhorCaminho) :- 
    obtem_melhor_g(Caminhos, MelhorCaminho).

expande_gulosa(Caminho, Destino, ExpCaminhos) :-
    findall(NovoCaminho, adjacente(Destino, Caminho,NovoCaminho), ExpCaminhos).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%Selecionar apenas algumas das operadoras de transporte para um determinado percurso
caminhoOP(A,B,OP,P) :- paragem(B,_,_,_,_,_,OPERADORA,_,_,_,_), memberchk(OPERADORA,OP), caminho1OP(A,[B],OP,P).
caminho1OP(A,[A|P1],OP,[A|P1]).
caminho1OP(A,[Y|P1],OP,P) :-
                            aresta(X,Y),
                             \+ memberchk(X,[Y|P1]),
                            paragem(X,_,_,_,_,_,OPERADORA,_,_,_,_),memberchk(OPERADORA,OP),
                             caminho1OP(A,[X,Y|P1],OP,P).

resolve_pp_OP(A,B,OP,P) :- resolve_pp(A,B,P), verificaOPS(P,OP).

resolve_aestrela_OP(A,B,OP,P) :- resolve_aestrela(A,B,P/_), verificaOPS(P,OP). 

resolve_gulosa_OP(A,B,OP,P) :- resolve_gulosa(A,B,P/_), verificaOPS(P,OP).

%##############################Funções auxiliares
verificaOPS([],OP).
verificaOPS([X|T],OP) :- paragem(X,_,_,_,_,_,OPERADORA,_,_,_,_), memberchk(OPERADORA,OP), verificaOPS(T,OP).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%Excluir 1 ou mais operadores de transporte para o percurso
caminhoOP_R(A,B,OP,P) :- paragem(B,_,_,_,_,_,OPERADORA,_,_,_,_), \+ memberchk(OPERADORA,OP), caminho1OP_R(A,[B],OP,P).
caminho1OP_R(A,[A|P1],OP,[A|P1]).
caminho1OP_R(A,[Y|P1],OP,P) :-
                            aresta(X,Y),
                             \+ memberchk(X,[Y|P1]),
                            paragem(X,_,_,_,_,_,OPERADORA,_,_,_,_), \+ memberchk(OPERADORA,OP),
                            caminho1OP_R(A,[X,Y|P1],OP,P).


resolve_pp_OP_R(A,B,OP,P) :- resolve_pp(A,B,P), verificaN(P,OP).

resolve_aestrela_OP_R(A,B,OP,P) :- resolve_aestrela(A,B,P/_), verificaN(P,OP).

resolve_gulosa_OP_R(A,B,OP,P) :- resolve_gulosa(A,B,P/_), verificaN(P,OP). 


%#############################auxiliares
verificaN([],OP).
verificaN([X|T],OP) :- paragem(X,_,_,_,_,_,OPERADORA,_,_,_,_), \+memberchk(OPERADORA,OP), verificaN(T,OP).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%Identificar quais as paragens com o maior número de carreiras num determinado percurso

%Calcula a lista de carreiras com o maior número de carreiras
carreiras_MaxCarreiras(P,C) :- maisCarreiras(P,M), matchCarreiras(M,P,C).

matchCarreiras(M,[],C).
matchCarreiras(M,[X|T], C) :- maiorNrCarreiras(X,M), matchCarreiras(M, T, C1), adicionar(C1,X,C).
matchCarreiras(M,[X|T], C) :- nao(maiorNrCarreiras(X,M)), matchCarreiras(M, T, C).

%calcula uma das carrerias com o valor máximo de carreiras
maisCarreiras([X],X).
maisCarreiras([X|XS],X) :- maisCarreirasAux(XS,X).
maisCarreiras([X|XS],R) :- nao(maisCarreirasAux(XS,X)), maisCarreiras(XS,R).

maisCarreirasAux([],R).
maisCarreirasAux([X|XS], R) :- nao(maiorNrCarreiras(X,R)), maisCarreirasAux(XS,R).

maiorNrCarreiras(ID1,ID2):-  paragem(ID1,_,_,_,_,_,_,C,_,_,_), paragem(ID2,_,_,_,_,_,_,CR,_,_,_) ,length(C,T1), length(CR,T2), T1 >= T2.

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%Escolher o menor percurso usando critério menor número de paragens;
%resolução caminho
menorNumeroParagens_CAM(A,B,P) :- findall(T,caminho(A,B,T),L), menorDaLista(L,P).

%resolução pp
menorNumeroParagens_PP(A,B,P) :- findall(T,resolve_pp(A,B,T),L), menorDaLista(L,P).

%resolução aestrela
menorNumeroParagens_Ast(A,B,P) :- findall(T,resolve_aestrela(A,B,T/_),L), menorDaLista(L,P). 

%resolução gulosa
menorNumeroParagens_Gul(A,B,P) :- findall(T, resolve_gulosa(A,B,T/_),L), menorDaLista(L,P).

%#########auxiliares
menorDaLista([X],X).
menorDaLista([X,Y|T], M) :- length(X,N1), length(Y,N2), N1<N2, menorDaLista([X|T],M).
menorDaLista([X,Y|T], M) :- length(X,N1), length(Y,N2), N1 >= N2,menorDaLista([Y|T],M).
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

%Escolher o percurso mais rápido usando critério da distância;

%vai buscar todos os caminhos possíveis
%resolução caminho
fastest_path_CAM(A,B,P):- findall(L,caminho(A,B,L),CAMS), check_weights(CAMS,P).

%resolução pp
fastest_path_PP(A,B,P):- findall(L,resolve_pp(A,B,L),CAMS), check_weights(CAMS,P).

%resolução aestrela
fastest_path_Ast(A,B,P):- findall(L,resolve_aestrela(A,B,L/_),CAMS), check_weights(CAMS,P).

%resolução gulosa
fastest_path_Gul(A,B,P):- findall(L,resolve_gulosa(A,B,L/_),CAMS), check_weights(CAMS,P).

%#########auxiliares
%vai comparando o tamnho das listas até ficar com a menor
check_weights([X],X).
check_weights([X,Y|T],P) :- weight_list(X,D1), weight_list(Y,D2), D1 <  D2, check_weights([X|T],P).
check_weights([X,Y|T],P) :- weight_list(X,D1), weight_list(Y,D2), D1 >= D2,  check_weights([Y|T],P).

%calcula o tamnho de uma lista
weight_list([X],0).
weight_list([X,Y|T],P) :- paragem(X,LAT1,LONG1,_,_,_,_,_,_,_,_), paragem(Y,LAT2,LONG2,_,_,_,_,_,_,_,_),
                          dist(LAT1,LONG1,LAT2,LONG2,D), weight_list([Y|T], P1), P = D + P1.


%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Escolher o percurso que passe apenas por abrigos com publicidade;
caminhoPub(A,B,P) :- paragem(B,_,_,_,_,'Yes',_,_,_,_,_), caminho1Pub(A,[B],P).
caminho1Pub(A,[A|P1],[A|P1]).
caminho1Pub(A,[Y|P1],P) :-
     aresta(X,Y), \+ memberchk(X,[Y|P1]), paragem(X,_,_,_,_,'Yes',_,_,_,_,_),caminho1Pub(A,[X,Y|P1],P).


resolve_pp_PUB(A,B,P) :- resolve_pp(A,B,P), verificaPUB(P).

resolve_aestrela_PUB(A,B,P) :- resolve_aestrela(A,B,P/_), verificaPUB(P).

resolve_gulosa_PUB(A,B,P) :- resolve_gulosa(A,B,P/_), verificaPUB(P).

%#########auxiliares
verificaPUB([]).
verificaPUB([X|T]) :- paragem(X,_,_,_,_,'Yes',_,_,_,_,_), verificaPUB(T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -

% Escolher o percurso que passe apenas por paragens abrigadas;
caminhoAbrig(A,B,P) :- paragem(B,_,_,_,ABG,_,_,_,_,_,_), ABG \= 'Sem Abrigo', caminho1Abrig(A,[B],P).
caminho1Abrig(A,[A|P1],[A|P1]).
caminho1Abrig(A,[Y|P1],P) :-
     aresta(X,Y), \+ memberchk(X,[Y|P1]), paragem(X,_,_,_,ABG,_,_,_,_,_,_), ABG \= 'Sem Abrigo', caminho1Abrig(A,[X,Y|P1],P).


resolve_pp_Abrig(A,B,P) :- resolve_pp(A,B,P), verificaAbrig(P).

resolve_aestrela_Abrig(A,B,P) :- resolve_aestrela(A,B,P/_), verificaAbrig(P).

resolve_gulosa_Abrig(A,B,P) :- resolve_gulosa(A,B,P/_), verificaAbrig(P).

%#############auxiliares
verificaAbrig([]).
verificaAbrig([X|T]) :- paragem(X,_,_,_,ABG,_,_,_,_,_,_), ABG \= 'Sem Abrigo', verificaAbrig(T).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Escolher um ou mais pontos intermédios por onde o percurso deverá passar

%resolve caminho
caminhoComParagens_CAM(A,B,INT,CAM):- caminho(A,B,CAM), passaIntermedios(INT,CAM).

%resolução pp
caminhoComParagens_PP(A,B,INT,CAM):- resolve_pp(A,B,CAM), passaIntermedios(INT,CAM).

%resolução aestrela
caminhoComParagens_Ast(A,B,INT,CAM):- resolve_aestrela(A,B,CAM/_), passaIntermedios(INT,CAM).

%resolução gulosa
caminhoComParagens_Gul(A,B,INT,CAM):- resolve_gulosa(A,B,CAM/_), passaIntermedios(INT,CAM).

%#########auxiliares
passaIntermedios([],CAM).
passaIntermedios([X|T],CAM) :- memberchk(X,CAM), passaIntermedios(T,CAM).


%--------------------------------- - - - - - - - - - -  -  -  -  -
%#####################Funções auxiliares###########################
%--------------------------------- - - - - - - - - - -  -  -  -  -
inverso(Xs, Ys):-
	inverso(Xs, [], Ys).

inverso([], Xs, Xs).
inverso([X|Xs],Ys, Zs):-
	inverso(Xs, [X|Ys], Zs).

seleciona(E, [E|Xs], Xs).
seleciona(E, [X|Xs], [X|Ys]) :- seleciona(E, Xs, Ys).

adicionar([],X,[X]).
adicionar([H|T],X,[H|T]) :- pertence(X, [H|T]).
adicionar([H|T],X, [X|[H|T]]) :- nao(pertence(X,[H|T])). 

%função responsável por calcular a distância
dist(Lat1,Long1,Lat2,Long2,D):- D is (sqrt((Lat1-Lat2)^2 + (Long1-Long2)^2)).

%--------------------------------- - - - - - - - - - -  -  -  -  -   -
% Extensao do meta-predicado nao: Questao -> {V,F}

nao( Questao ) :-
    Questao, !, fail.
nao( Questao ).
