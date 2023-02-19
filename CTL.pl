verify(Input) :-
see(Input), read(T), read(L), read(S), read(F), seen,
check(T, L, S, [], F).


verify(Input) :-
see(Input), read(T), read(L), read(S), read(F), seen,
check(T, L, S, [], F).


%neg
check(_T,L,S,_U,neg(F)):-
  translateLabel(L,S,Atom), not(member(F, Atom)). %check(T,L,S,U,F).

% And
check(T, L, S, U, and(F,G)) :-
	check(T, L, S, U, F),
	check(T, L, S, U, G),!.

% Or
check(T, L, S, U, or(F,_)):-
	check(T, L, S, U, F).

check(T, L, S, U, or(_,G)):-
	check(T, L, S, U, G),!.
% AX
check(T,L,S,U,ax(F)):-translateLinks(T,S,Links), ax_checker(T,L,Links,U,F).

% EX
check(T,L,S,U,ex(F)):-
  translateLinks(T,S,Links),
  ex_checker(T,L,Links,U,F),!.

%AF
check(T,L,S,U,af(F)):- not(member(S,U)), translateLinks(T,S,Links), af_checker(T,L,Links,[S|U],F), !.
check(T,L,S,U,af(F)):- not(member(S,U)),check(T,L,S,U,F),!.

%EF
check(T,L,S,U,ef(F)):- not(member(S,U)), translateLinks(T,S,Links), \+ef_checker(T,L,[S|Links],U,F).
check(T,L,S,U,ef(F)):-not(member(S,U)), check(T,L,S,U,F).
%AG
check(T,L,S,U,ag(F)):-
  \+member(S,U), translateLinks(T,S,Links), ag_checker(T,L,Links,[S|U],F),check(T,L,S,[],F),!.
check(_T,_L,S,U,ag(_F)):- member(S,U).

%EG
check(T,L,S,U,eg(F)):-
  (member(S,U); (\+member(S,U), translateLinks(T,S,Links), eg_checker(T,L,Links,U,F),check(T,L,S,U,F))),!.

%p
check(_,L,S,_,F):- f_checker(F), translateLabel(L,S,Atom),member(F,Atom),!.

%helper to Ax.
ax_checker(_,_,[],_,_).
ax_checker(T,L,[HLinks|TLinks],U,F):- check(T,L,HLinks,U,F), ax_checker(T,L,TLinks,U,F).

%helper to Ex.
ex_checker(T,L,Links,U,F):- (Links=[]; (\+Links=[], ex_checker_sub(T,L,Links,U,F))).
ex_checker_sub(_,_,[],_,_):-!,false.
ex_checker_sub(T,L,[HLinks|TLinks],U,F):-!, (check(T,L,HLinks,U,F); (\+check(T,L,HLinks,U,F), ex_checker_sub(T,L,TLinks,U,F))).

%helper to AG.
ag_checker(_,_,[],_,_).
ag_checker(T,L,[HLinks|TLinks],U,F):- check(T,L,HLinks,U,ag(F)),ag_checker(T,L,TLinks,[HLinks|U],F).

%helper to EG.
eg_checker(_,_,[],_,_):-false.
%eg_checker(T,L,[HLinks|TLinks],U,F):- \+[HLinks|TLinks]=[], translateLinks(T,HLinks,NextLinks),member(HLinks,NextLinks),check(T,L,HLinks,U,F).
eg_checker(_T,_L,[HLinks|_TLinks],U,_F):- member(HLinks,U).
eg_checker(T,L,[HLinks|TLinks],U,F):- not(member(HLinks,U)), translateLinks(T,HLinks,NextLinks),
(check(T,L,HLinks,U,F), eg_checker(T,L,NextLinks,[HLinks|U],F));
eg_checker(T,L,TLinks,U,F).


%helpers to AF
af_checker(_,_,[],_,_):-false.
af_checker(T,L,[HLinks|TLinks],U,F):- member(HLinks,U), af_checker(T,L,TLinks,U,F).
af_checker(T,L,[HLinks|TLinks],U,F):- not(member(HLinks,U)),
    translateLinks(T,HLinks,NextLinks),!,
    (check(T,L,HLinks,U,F);af_checker(T,L,NextLinks,[HLinks|U],F)),!, (TLinks=[];af_checker(T,L,TLinks,[HLinks|U],F)),!.

%helpers to EF

  ef_checker(_,_,[],_,_).
  ef_checker(T,L,[HLinks|TLinks],U,F):- member(HLinks,U), ef_checker(T,L,TLinks,U,F).
  ef_checker(T,L,[HLinks|TLinks],U,F):- not(member(HLinks,U)),
    translateLinks(T,HLinks,NextLinks),
    \+check(T,L,HLinks,[],F),ef_checker(T,L,NextLinks,[HLinks|U],F), ef_checker(T,L,TLinks,[HLinks|U],F).

%General helpers
translateLinks(T,Sn,Links):-
    member([Sn|[FoundLinks]],T),
    Links=FoundLinks,!.

translateLabel(L,Sn,Atom):-
    member([Sn|[FoundAtom]],L),
    Atom=FoundAtom,!.

f_checker(F):- \+F=and(_), \+F=neg(_), \+F=or(_), \+F=ax(_), \+F=ex(_),
\+F=ag(_), \+F=eg(_), \+F=ef(_), \+F=af(_).
