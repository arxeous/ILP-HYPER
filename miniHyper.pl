use_module(library(lists)).

% prove (Goal,Hypo,Answer)
% Goal - If you read before the form is in that of a list, with literals and and list of arguments for those literals.
% Hypo - Hypothesis yes another list of literals that make up what we initially think the rule for a given literal is.
% Answer - This is our answer, which can either be yes no, or maybe.

% The goal is either provable or not. IF its provable (or can't be disproved) then we use this function.
% max_proof_length will give us the maximum proof length that we set later on.
% Now with the depth we then use prove again, and try to prove the hypothesis.
% evaluate_depth then evaluates if were within the limit of depth search for this literal.
prove(Goal, Hypo, Answer) :-
    max_proof_length(Max_Depth),
    prove(Goal, Hypo, Max_Depth, Remaining_Depth),
    evaluate_depth(Remaining_Depth, Answer).

% If it isnt provable, then we execute this line of code, which just does nothing essentially. 
prove(_Goal, _, no).


% evaluate_depth(Current_Depth, answer)
% Current_Depth - Current depth, pretty self explanitory
% answer - By evaluating depth we can check whether we can actually prove a hypothesis or not.
% In the prove function that takes 4 arguments we return the remaining depth in the Remaining_Depth variable. We send it to evaluate_depth to check whether we are actually proveable or not.

% Here is the case in which we CAN prove the hypothesis
evaluate_depth(Current_Depth, yes) :-
    Current_Depth >= 0, !.

% Here is the case where we can prove or disprove it. Remember the case where we aren't proveable is above.
evaluate_depth(Current_Depth, maybe) :-
    Current_Depth < 0.

% Prove(Goal, Hypo, Depth, Depth)
% Goal - If you read before the form is in that of a list, with literals and and list of arguments for those literals.
% Hypo - Hypothesis yes another list of literals that make up what we initially think the rule for a given literal is.
% Depth - Our current depth
% Depth - Our maximum depth.
% The hypothesis is either going to be provable within our assigned maximum depth or it cant be proven in that depth. This is where
% we go about finding out that answer.

% We have exceeded the max depth of our proof
prove(_Goal, _Hypo, Depth, Depth) :-
    Depth < 0, !.

% Since this program works recursively, this is a "Base case" in which there are no more sub goals to try and prove. 
prove([],_Hypo,Depth,Depth) :- !.

% Our goal is a conjunction, so we have to prove its subgoals here    
% Since goal is just a list we can break it up here and move through each literal one by one.
prove([Goal|Goals], Hypo, Depth0, Depth) :- !,
    prove(Goal, Hypo, Depth0, Depth1),
    prove(Goals, Hypo, Depth1, Depth).

% Here is where were check if our goal is a background predicate. Our knowledge base has this information so we execute prolog_predicate() and see if its true.
% if it is then we can go ahead and execute the predicate.
prove(Goal, _Hypothesis, Depth, Depth) :-
    prolog_predicate(Goal),
    call(Goal).

% Here is when we reach the maximum depth. So we set the depth to -1 to let the previous prove function know that we can't really prove the hypothesis nor disprove it.
 prove(_Goal, _Hypo, Max_Depth, New_Max_Depth) :-
    Max_Depth =:= 0,
    !,
    New_Max_Depth is Max_Depth - 1.

% Finally if we havent reached the max depth yet then we go agead and continue our search.
% We decrement the current proof length called Max_Depth1.
% After we do this we then use member() to select a clause from the hypothesis
% From there we change the variables in clause, effectively searching the "space".
% Next we match the head of the new clause after its been changed with the current goal.
% Then we prove the goal using this new body.						       
prove(Goal, Hypo, Max_Depth, New_Max_Depth) :-
    Max_Depth > 0,
    Max_Depth1 is Max_Depth - 1,
    member(Clause*_Arguments, Hypo),
    copy_term(Clause, [Head | Body]),
    Goal = Head,
    prove(Body, Hypo, Max_Depth1, New_Max_Depth).


% induce(Hypo)
% Hypo - Just a list of literals and arguments for those literals as covered before.
% Induce returns true is our hypothesis is complete (true for all positive cases) and consistent (false for all the negative examples). It also has to be within the max search depth that we set.

% First we get the maximum depth
% then we use iter_deep to search for a valid hypothesis
induce(Hypo) :-
    max_proof_length(Depth_Threshold),
    iter_deep(Target_Hypo, 0, Depth_Threshold).


% Prolog is weird in that functions are spread out in a way thats sort of analogous to a switch statement.
% so a single function can have different "Versions" (cases) that do different things to the parameters. Its a little confusing 
% but its how things need to get done in this language.
% iter_deep(Hypo, Max_Depth, Depth_Threshold)
%  Hypo - A list of literals and their arguments
%  Max_Depth - The current depth we are at.
%  Depth_Threshold - Max depth

% this initial iter_deep tries to search the initial hypotehsis given for a refinement.
% we write out the current depth to help us track where we are at in the program.
% After that we check if our max depth is reached.
% We then retrieve the initial hypothesis
% The nature of this program means that if a hypothesis isn't complete then there no point in continuing. So we naturally check for its completeness
% Then we use a depth first search(since this hypothesis is represented as a tree) to search for the refinement
iter_deep(Hypo, Max_Depth, Depth_Threshold) :-
    write('MaxD='), write(MaxD),nl,
    Max_Depth =< Depth_Threshold,
    initial_hypo(Hypo0),
    compelte(Hypo0),
    depth_first(Hypo0m Hypo, Depth_Threshold).


% Here were searching at an even GREATER depth
% Obviously like before we need to check were not exceededing our max depth
% Then we just increment the counter and look further using iter deep again.
						       
iter_deep(Hypo, Max_Depth, Depth_Threshold) :-
    Max_Depth < Depth_Threshold,
    New_Max_Depth is Max_Depth + 1,
    iter_deep(Hypothesis, New_Max_Depth, Depth_Threshold).


% depth_first(Hypo, Hypo, Max_Depth)						       
% Hypo - Hypothesis, like every other instance of hypo its a list with literals and their arguments.
% Hypo - same as above
% Max_Depth - Current depth
% returns true if we can refine the first hypothesis into the second hypothesis.

% Here is the case where we terminate. When our hypothesis is consistent then weve reached a refinement.
depth_first(Hypo, Hypo, Max_Depth) :-
    Max_Depth >= 0,
    consistent(Hypo).

% This ist he recursive case.
% Like before we check our depth, then we refine Hypo0 into Hypo1
% If this is complete we simply move further with our search till we find something that is also consistent.						       
depth_first(Hypo0, Hypo, Max_Depth0) :-
    Max_Depth0 > 0,
    Max_Depth1 is Max_Depth0 - 1,
    refine_hyp(Hypo0, Hypo1),
    complete(Hypo1),
    depth_first(Hypo1, Hypo, Max_Depth1).

% complete(Hypo)
% Hypo - Hypothesis, like every other instance of hypo its a list with literals and their arguments.
% Returns true if we can't find a positive example that turns up false when we pass it through our hypothesis.
						       
						       
% If there is any query that isnt true that should be true, we got a 
% problem. 
% not returns true if it can't prove what is in its ().
% In this case we find a positive example, we attempt to prove it with the hypothesis we have.
% Not will return true if whatever is inside the () can't be proven. So if we can't prove that there is a positive example that can't be proven we return true, because that means were complete.
complete(Hypo) :-
    not(ex(Positive_Example),
    	once(prove(Positive_Example, Hypo, Answer))
    	Answer \== yes
).


% consistent(Hypo)
% Hypo - Hypothesis, like every other instance of hypo its a list with literals and their arguments.
% returns true if no negative example turns out true when we try to prove it with our hypothesis
% Like complete it uses the NOT operation to achieve this. 
						       
% If there is any query that is (or may be) true that should be false,
% we got a problem
consistent(Hypo) :-
    not(nex(Negative_Example),
        once(prove(Negative_Example, Hypo, Answer)),
        Answer \== no
).

% refine_hpy(Hypo0, Hypo)
% Hypo0 - Hypothesis, like every other instance of hypo its a list with literals and their arguments.
% Hypo - Hypothesis, like every other instance of hypo its a list with literals and their arguments.
% true if the second hypotheis is a refinement of the first hypotheis.

% Here we find a clause from our hypothesis.
% we then add the a placeholder clause to the hypothesis
% We then refine this clause into a new clause.
refine_hyp(Hypo0, Hypo) :-
    append(Clauses1, [Clause0*Arguments0 | Clauses2], Hypothesis0),
    append(Clauses1, [Clause*Arguments|Clauses2], Hypothesis),
    refine(Clause0, Arguments0, Clause, Arguments).
    

%refine(Clause, Args, Clause, New_Args)
% Clause - list of clauses like [clause1(X),clause2(Y)]
% Arg - list of arguments [X,Y]
% Clause - This is actually a new clause. Comes in a list like the first clause.
% New_Args - new list of arguments
% Returns true if Arg3 is a refinement of Arg1

% HEre we are refining by unifiying our arguments. I.e. has_daughter(X) :- parent(X,Y), Female(W) -> has_daughter(X) :- parent(X,Y), Female(Y) 
% Again by using append we select an arugment
% we unify this argument with another argument from our list.
% Then we recombine them but this time removing the argument shared among the two.
refine(Clause, Args, Clause, New_Args) :-
    append(Args1, [Argument | Args2], Args),
    member(Argument, Args2),
    append(Args1, Arguments2, New_Arguments).
   

% This refinement is the type by addinga  new sub goal has_daughter(X) :- parent(X,Y)  -> has_daughter(X) :- parent(X,Y), Female(Y)
% First we need to check the limit of subgoals we imposed on the hypothesis. This is done in max_clause_length()
% After were clear we select a background literal to use and add this to the list clauses we have.
% then we add the argument for this literal to the list of arguements we have.  
refine(Clause, Args, New_Clause, New_Args) :-
    length(Clause, Number_of_Literals),
    max_clause_length(Max_Number_of_Literals),
    Number_of_Literals < Max_Number_of_Literals,
    backliteral(Lit, Args_of_Literals),
    append(Clause, [Literal], New_Clause);
    append(Args, Args_of_Literals, NewArgs).
   
% Here is where we set the max depth of our tree
max_proof_length(6).
% Here is where we set the maximum number of clauses that can make up our hypothesis.
max_clause_length(3).

