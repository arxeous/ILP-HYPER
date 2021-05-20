% backliteral(A,B)
% A - goal
% B - list of arguments
% Back litearls are literally just our background literals. Our program needs these
% in order to compose its hypothesis. Otherwise its flying blind.
backliteral(long_wings(X), [X]).
backliteral(pointed_wings(X), [X]).
backliteral(black_white_plumage(X), [X]).
backliteral(large(X), [X]).
backliteral(small(X), [X]).
backliteral(tiny(X), [X]).  


% prologPredicate(A)
% A - predicate
% This is just a list of predicates recognized by our program. These can be directly executed by prolog.
% It's important to make this distinction because some parts of this program have an "interpreter".
prologPredicate(long_wings(_)).
prologPredicate(pointed_wings(_)).
prologPredicate(black_white_plumage(_)).
prologPredicate(small()).
prologPredicate(tiny()).
prologPredicate(large).

% ex(A)
% A - clause
% This is just all of our positive examples. i.e. they are true when tested.
ex(elaninae(black-winged_kite)).
ex(elaninae(letter-winged_kite)).

% nex(A)
% A - clause
% This is just all of our negative examples. i.e. they are false when tested.
nex(elaninae(bearded_vulture)).
nex(elaninae(palm-nut_vulture)).


% initialHypothesis(A).
% A - hypothesis
% This initial hypothesis is a list of the body of our initial guess along with a list of its arguments
% notice how it is very simmilar in form to backliteral
initialHypothesis([[elaninae(X)]*[X]]).

% The following is just a prolog program. They are rules needed for our program to build and test its hypothesis
% in order to see what does and doesnt work. Without this knowledge base our program is flying blind.
long_wings(black-winged_kite).
long_wings(letter-winged_kite).
long_wings(bearded_vulture).
long_wings(palm-nut_vulture).

pointed_wings(black-winged_kite).
pointed_wings(letter-winged_kite).
pointed_wings(palm-nut_vulture).

black_white_plumage(black-winged_kite).
black_white_plumage(letter-winged_kite).
black_white_plumage(bearded_vulture).

small(black-winged_kite).
small(letter-winged_kite).
small(pearl_kite).

large(beareded_vulture).
large(palm-nut_vulture).
