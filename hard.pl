% backliteral(A,B)
% A - goal
% B - list of arguments
% Back litearls are literally just our background literals. Our program needs these
% in order to compose its hypothesis. Otherwise its flying blind.

backliteral(open_land_habitat(X), [X]).    
backliteral(orange_forehead(X), [X]).
backliteral(yellow_forehead(X), [X]).
backliteral(forward_eyes(X), [X]).
backliteral(hooked_beak(X), [X]).
backliteral(weak_beak(X), [X]).
backliteral(feathered_neck(X), [X]).
backliteral(long_wings(X), [X]).
backliteral(broad_wings(X), [X]).
backliteral(narrow_wings(X), [X]).
backliteral(pointed_wings(X), [X]).
backliteral(black_white_plumage(X), [X]).
backliteral(brown_plumage(X), [X]).
backliteral(strong_legs(X), [X]).
backliteral(forked_tail(X), [X]).
backliteral(long_tail(X), [X]).
backliteral(lozenge_tail(X), [X]).
backliteral(short_tail(X), [X]).
backliteral(forest_habitat(X), [X]).
backliteral(mountain_habitat(X), [X]).
backliteral(bird_diet(X), [X]).
backliteral(carrion_diet(X), [X]).
backliteral(fruit_diet(X), [X]).
backliteral(insect_diet(X), [X]).
backliteral(mammal_diet(X), [X]).
backliteral(reptile_diet(X), [X]).
backliteral(small(X), [X]).
backliteral(tiny(X), [X]).
    

% prologPredicate(A)
% A - predicate
% This is just a list of predicates recognized by our program. These can be directly executed by prolog.
% It's important to make this distinction because some parts of this program have an "interpreter".
prologPredicate(small(_)).
prologPredicate(tiny(_)).
prologPredicate(orange_forehead(_)).
prologPredicate(yellow_forehead(_)).
prologPredicate(forward_eyes(_)).
prologPredicate(hooked_beak(_)).
prologPredicate(weak_beak(_)).
prologPredicate(feathered_neck(_)).
prologPredicate(long_wings(_)).
prologPredicate(broad_wings(_)).
prologPredicate(narrow_wings(_)).
prologPredicate(pointed_wings(_)).
prologPredicate(black_white_plumage(_)).
prologPredicate(brown_plumage(_)).
prologPredicate(strong_legs(_)).
prologPredicate(forked_tail(_)).
prologPredicate(long_tail(_)).
prologPredicate(lozenge_tail(_)).
prologPredicate(short_tail(_)).
prologPredicate(forest_habitat(_)).
prologPredicate(mountain_habitat(_)).
prologPredicate(open_land_habitat(_)).
prologPredicate(bird_diet(_)).
prologPredicate(carrion_diet(_)).
prologPredicate(fruit_diet(_)).
prologPredicate(insect_diet(_)).
prologPredicate(mammal_diet(_)).
prologPredicate(reptile_diet(_)).


% ex(A)
% A - clause
% This is just all of our positive examples. i.e. they are true when tested.
ex(elaninae(black-winged_kite)).
ex(elaninae(letter-winged_kite)).
ex(elaninae(scissor-tailed_kite)).
ex(elaninae(pearl_kite)).

% nex(A)
% A - clause
% This is just all of our negative examples. i.e. they are false when tested.
nex(elaninae(bearded_vulture)).
nex(elaninae(palm-nut_vulture)).
nex(elaninae(cinereous_vulture)).
nex(elaninae(griffon_vulture)).
nex(elaninae(bat_hawk)).


% initialHypothesis(A).
% A - hypothesis
% This initial hypothesis is a list of the body of our initial guess along with a list of its arguments
% notice how it is very simmilar in form to backliteral
initialHypothesis([[elaninae(X)]*[X]]).


% The following is just a prolog program. They are rules needed for our program to build and test its hypothesis
% in order to see what does and doesnt work. Without this knowledge base our program is flying blind.

small(black-winged_kite).
small(letter-winged_kite).
small(scissor-tailed_kite).
small(robin).

tiny(pearl_kite).

orange_forehead(letter-winged_kite).

yellow_forehead(pearl_kite).

forward_eyes(black-winged_kite).

hooked_beak(cinereous_vulture).

weak_beak(scissor-tailed_kite).

feathered_neck(bearded_vulture).

broad_wings(cinereous_vulture).
broad_wings(griffon_vulture).

open_land_habitat(black-winged_kite).
open_land_habitat(letter-winged_kite).
open_land_habitat(scissor-tailed_kite).
open_land_habitat(pearl_kite).
open_land_habitat(bat_hawk).

long_wings(black-winged_kite).
long_wings(letter-winged_kite).
long_wings(scissor-tailed_kite).
long_wings(pearl_kite).
long_wings(bearded_vulture).
long_wings(bat_hawk).

narrow_wings(bearded_vulture).

pointed_wings(black-winged_kite).
pointed_wings(letter-winged_kite).
pointed_wings(scissor-tailed_kite).
pointed_wings(pearl_kite).

black_white_plumage(black-winged_kite).
black_white_plumage(letter-winged_kite).
black_white_plumage(scissor-tailed_kite).
black_white_plumage(pearl_kite).
black_white_plumage(bearded_vulture).
black_white_plumage(palm-nut_vulture).

brown_plumage(cinereous_vulture).

strong_legs(bearded_vulture).

forked_tail(scissor-tailed_kite).

long_tail(bearded_vulture).

lozenge_tail(bearded_vulture).

short_tail(black-winged_kite).
short_tail(letter-winged_kite).
short_tail(pearl_kite).
short_tail(griffon_vulture).

forest_habitat(palm-nut_vulture).

mountain_habitat(bearded_vulture).
mountain_habitat(cinereous_vulture).
mountain_habitat(griffon_vulture).


bird_diet(pearl_kite).

carrion_diet(bearded_vulture).
carrion_diet(cinereous_vulture).
carrion_diet(griffon_vulture).

fruit_diet(palm-nut_vulture).

insect_diet(black-winged_kite).
insect_diet(scissor-tailed_kite).
insect_diet(pearl_kite).

mammal_diet(black-winged_kite).
mammal_diet(letter-winged_kite).
mammal_diet(scissor-tailed_kite).

reptile_diet(black-winged_kite).
reptile_diet(scissor-tailed_kite).
reptile_diet(pearl_kite).

