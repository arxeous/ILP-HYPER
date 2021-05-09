% Working version of mini-HYPER
% Links to how to build this system along with other working sources used to build this can be found in the project report.

% The version of prove used to build mini-HYPER in Bratkos example is finicky. This may be due to the many years since that code was written.
% So instead we use a slightly different version of provided by University Of Birmingham. Usually prove is put in its own seperate file, but we include it here
% in order to keep everything in own tightly knit package.
% prove (A,B,C)\3
% A - Goal to be proved using the hypothesis. The form of a goal is that of a list of literal and argument pairs.
% B - Hypothesis that will prove the goal (try to prove.) The form of the hypothesis is that of a list of clauses
% C - Answer as to whether the goal can be proven from our hypothesis. Is either yes no or maybe.
% Prove seeks to prove whether a goal can be proved with our given hypothesis. We need to be able to test our hypothesis, and this is how we get it done.

% 1
% The goal is either provable (yes) or the answer cant be derived (maybe).
prove(Goal, Hypothesis, Answer) :-
    maxProofLength(MaxLength),
    prove(Goal, Hypothesis, MaxLength, RemainingLength),
    evalLength(RemainingLength, Answer).

% 2
% The goal is unprovable within the Length we set. 
prove(_, _, no).

% Prove(A, B, C, D)\4
% A - If you read before the form is in that of a list, with literals and and list of arguments for those literals.
% B - Hypothesis yes another list of literals that make up what we initially think the rule for a given literal is.
% C - Our current Length
% D - Our maximum Length.
% This is where the actual nitty gritty proving of a goal is done. We have four cases that will be gone over.
% Length is only decreased when we have a target predicated p(x) that calls itself. i.e. p(x) :- p(x). In cases like these we dont want our program to go in an infinite loop
% which is why we have a Length counter in the first place. Background literals defined in the knowledge base do not decrease the depth because they can be easily proven by prolog itself.

% 1 
% We have gone further than the maximum Length. 
prove(_, _, Length, Length) :-
    Length < 0, !.

% 2
% No more goals to try and prove.
prove([], _, Length, Length) :- !.

% 3
% Our goal is a whole bunch of clauses, so we have to prove its subgoals here.   
% Since goal is just a list we can break it up here and move through each component one by one.
% You might wonder why OtherLength is put in place of MaxLength, but this has to do with matching cases of Length like in functions versions 1, 2, and 3.
% Prolog is not a straight forward language so to be able to have our Length change accordingly we match current and max in the first prove call and send the depth to the 
% next prove call below. Much easier to follow all this using trace.
prove([Goal|Goals], Hypothesis, CurrLength, MaxLength) :- !,
    prove(Goal, Hypothesis, CurrLength, OtherLength),
    prove(Goals, Hypothesis, OtherLength, MaxLength).

% 4
% Here is where were check if our goal is a background predicate. Our knowledge base has this information so we execute prologPredicate() and see if its true. If it is
% we let prolog execute it directly.
prove(Goal, _, Depth, Depth) :-
    prologPredicate(Goal),
    call(Goal).

% 5 
% Here is when we reach the maximum Length. So we set the depth to -1 to let the previous prove function know that we our answer is undeterminable. 
 prove(_, _, MaxLength, NewMaxLength) :-
    MaxLength =:= 0,
    !,
    NewMaxLength is MaxLength - 1.

% 6
% This is essentially where the real goal proving happens. We take a clause from our hypothesis	and try to prove the goal with it. More formally: 
% We decrement our Length and then use member to obtain some random clause and argument pair from our hypothesis list. (Pairs are of the form Clause*Args).
% copy_term copies the clause but CHANGES the arguemnts (as defined by swiprolog). Why would we do this? because thats how you go about proving something, you change the arguments
% until you find something that works. Finally we match the head of this clause (clauses come in the form head() :- literal(), literal1(), etc.) with our goal
% and prove our goal with this new body. 
prove(Goal, Hypothesis, CurrLength, NewMaxLength) :-
    CurrLength > 0,
    NewLength is CurrLength - 1,
    member(Clause*_, Hypothesis),
    copy_term(Clause, [NewHead|NewBody]),
    Goal = NewHead,
    prove(NewBody, Hypothesis, NewLength, NewMaxLength).



% evalLength(A, B)\2
% A - Current Length, pretty self explanitory
% B - By evaluating Length we can check whether we can actually prove a hypothesis or not.
% In the prove function that takes 4 arguments we return the remaining Length in the RemainingLength variable. We send it to evalLength to check whether we are actually proveable or not.

% 1
% Here is the case in which we CAN prove the hypothesis
evalLength(CurrLength, yes) :-
    CurrLength >= 0, !.

% 2 
% Here is the case where we cant prove or disprove it. Why ? because if we reach a Length less than our maximum our prove function went through however many runs without being able to definitevly
% say whether we are provable or not. We know were not provable when we execute the background predicates and they all turn up false. 
evalLength(CurrLength, maybe) :-
    CurrLength < 0.


% induce(A)\1
% A - Hypothesis we wish to induce
% Induce returns a complete and consistent hyptoehsis for our target predicate.

% 1 
% First we get our maximum proof length, which is just telling us try and prove this within X iterations.
% then we use searchSpace to search for a valid hypothesis
induce(TargetHypothesis) :-
    maxProofLength(MaxLength),
    searchSpace(TargetHypothesis, 0, MaxLength).

% searchSpace(A, B, C)\3
%  A - Hypothesis we wish to "iterate" through. What we mean is that a hypothesis can be seen as a tree, with refinements as its child nodes. To find a complete and consistent hypothesis
%       we simply iterate through this tree.
%  B - The current Length we are at.
%  C - Max Length

% 1
% To search our space we need our initial hypothesis. We then check to see if its complete. An incomplete hypothesis cant be made compelte with refinement, so 
%  if it isnt there is no point continuing. Once we know that the hypothesis is complete then we use depth first search to make refinements of our hypothesis.
searchSpace(Hypothesis, CurrLength, MaxLength) :-
    CurrLength =< MaxLength,
    initialHypothesis(InitialHypothesis),
    complete(InitialHypothesis),
    depthFirst(InitialHypothesis, Hypothesis, MaxLength).

% 2
% Search further.
searchSpace(Hypothesis, CurrLength, MaxLength) :-
    CurrLength < MaxLength,
    NewCurrLength is CurrLength + 1,
    searchSpace(Hypothesis, NewCurrLength, MaxLength).


% depthFirst(A, B, C)\3					       
% A - Hypothesis
% B - Refinement of hypothesis A.
% C - Current depth
% Refines the first hypothesis into the second

% 1
% Base case, we need to check if our hypothesis is consistent at this point.
depthFirst(Hypothesis, Hypothesis, CurrDepth) :-
    CurrDepth >= 0,
    consistent(Hypothesis).

% 2
% Search by refining the OriginalHypothesis into NewHypothesis. Check that its complete, and then refine it once more to check if its consistent.
% Hypothesis is the variable in this program, so whatever is in NewHypothesis gets matched with Hypothesis and sent to function 1 to check for consistency.		       
depthFirst(OriginalHypothesis, Hypothesis, CurrDepth) :-
    CurrDepth > 0,
    NewDepth is CurrDepth - 1,
    refineHyp(OriginalHypothesis, NewHypothesis),
    complete(NewHypothesis),
    depthFirst(NewHypothesis, Hypothesis, NewDepth).

% complete(A)
% A - Hypothesis
% Checks for a hypothesis completeness by using the \+() operator. This will return true if whatever is in the () CANT be proven.
						       
% 1
% Grab a positive example and then prove it with our hypothesis.
% If you cant find a positive example that gives us an answer of no or maybe when we try to prove it with hypothesis, then we are complete, because that means every answer was yes.
complete(Hypothesis) :-
    \+ (ex(PositiveExample),
    	once(prove(PositiveExample, Hypothesis, Answer)),
    	Answer \== yes
    ).


% consistent(A)
% A - Hypothesis
%  Works like above, except we are checking to see if our hypothesis returns true for any negative example.
						       
% 1
% Grab a negative example and try and prove it with our hypothesis
% If you cant find a negative example that gives us an answer of yes when we try to prove it then we are consistent, because that means every answer was no.
consistent(Hypothesis) :-
    \+ (nex(NegativeExample),
        once(prove(NegativeExample, Hypothesis, Answer)),
        Answer \== no
    ).

% refineHyp(A, B)
% A - Hypothesis
% B - Refinement of B
% This is the refinement function, which just chooses a random clause in our list to be refined. 

% 1
% First we use append to choose some random Clause and its variables from our hypothesis (RandomClause*RandomVariables).
% Then we put into NewHypothesis place holders NewClause*NewVariables.
% We send in this random RandomClause*RandomVariables into refine for refinement. When its done Clause and Variables will be the refinements of these variables,
% and Hypothesis will contain these new refinements. 
refineHyp(OriginalHypothesis, NewHypothesis) :-
    append(OtherClauses, [RandomClause*RandomVariables | RemainingClauses], OriginalHypothesis),
    append(OtherClauses, [NewClause*NewVariables | RemainingClauses], NewHypothesis),
    refine(RandomClause, RandomVariables, NewClause, NewVariables).
    

% refine(A, B, C, D)\4
% A - Clause
% B - Variables for the clause
% C - Refinement of clause A
% D - new list of variables for new clause C
% Returns true if Arg3 is a refinement of Arg1

% 1
% refinement by unficiation of variables. 
% We use append to pick some random variable from our original list of variables
% we then take this variable and match it with the remaining variables. 
% Afterwards we simply append OtherVariables and RemainingVariables into NewVariables, which avoids putting in duplicate variables into the list.
refine(Clause, Variables, Clause, NewVariables) :-
    append(OtherVariables, [Variable | RemainingVariables], Variables),
    member(Variable, RemainingVariables),
    append(OtherVariables, RemainingVariables, NewVariables).
   

% 2
% This refinement is the type by adding a  new sub goal has_daughter(X) :- parent(X,Y)  -> has_daughter(X) :- parent(X,Y), Female(Y)
% First we need to check the limit of subgoals we imposed on the hypothesis. This is done in maxClauseLength()
% After were clear we select a background literal to use and add this to the list clauses we have.
% then we add the argument for this literal to the list of arguements we have.  
refine(Clause, Variables, NewClause, NewVariables) :-
    length(Clause, NumOfLiterals),
    maxClauseLength(MaxLiterals),
    NumOfLiterals < MaxLiterals,
    backliteral(Literal, VariablesOfLiteral),
    append(Clause, [Literal], NewClause),
    append(Variables, VariablesOfLiteral, NewVariables).

maxProofLength(6).
maxClauseLength(3).
