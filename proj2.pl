% COMP30020 Project 2
% Author: Mingyang
% Last modified: 10/12/2017

% Puzzle Constraints:
% 1. Each row and each column contains no repeated digits
% 2. All squares on the diagonal line from upper left to lower right contain the same value;
% 3. The heading of reach row and column (leftmost square in a row and topmost square in a column)
%    holds either the sum or the product of all the digits in that row or column


% Load transpose
:- ensure_loaded(library(clpfd)).


% Provide solution for puzzle
% arg1: a list of equal length lists
puzzle_solution([PHead|PTail]) :-
    valid_rows([PHead|PTail]),
    valid_cols([PHead|PTail]),
    valid_diag(PTail, 1, _),
    maplist(label, [PHead|PTail]). % Make sure to show concrete solutions. Thank god for StackOverflow!


% Sum of a list
% arg1: list to be summed
% arg2: sum
ls_sum([], 0).
ls_sum([Head|Tail], Sum) :-
    Head #>= 1,
    Head #=< 9,
    ls_sum(Tail, TailSum),
    Sum #= Head + TailSum.


% Product of a list
% arg1: the list
% arg2: product
ls_prod([], 1).
ls_prod([Head|Tail], Prod) :-
    Head #>= 1,
    Head #=< 9,
    ls_prod(Tail, TailProd),
    Prod #= Head * TailProd.


% Check if a list is valid. i.e. sum || product
% arg1: the row (list)
valid_ls([Head|Tail]) :-
    ls_sum(Tail, Head);
    ls_prod(Tail, Head).


% Check if tail contains no repeated digits
% arg1: a row or col
unique_digits([_|Tail]) :-
    all_distinct(Tail).


% Check if the tail of a puzzle has all valid rows
% arg1: puzzle without header row. i.e. tail of puzzle
valid_puzzle_tail([]).
valid_puzzle_tail([Row|Tail]) :-
    valid_ls(Row),
    unique_digits(Row),
    valid_puzzle_tail(Tail).


% Check if an entire puzzle has valid rows.
% arg1: puzzle (list of equal length lists)
valid_rows([]).
valid_rows([_|Tail]) :-
    valid_puzzle_tail(Tail).


% Check if the puzzle has all valid cols
% arg1: an entire puzzle
valid_cols([]).
valid_cols(Puzzle) :-
    transpose(Puzzle, [_|TransTail]), % Transpose and strip the header row
    valid_puzzle_tail(TransTail).


% Indexing a list, provided the index and element
% arg1: index
% arg2: element
% arg3: list to be indexed
index_ls(0, Head, [Head|_]).
index_ls(Index, Element, [_|Tail]) :-
    NextIndex #= Index - 1,
    index_ls(NextIndex, Element, Tail).


% Check if the diagonal of tail of puzzle (stripped of header row) is valid
% arg1: tail of puzzle
% arg2: current index of diagonal of current row. Always starts from 1
% arg3: value in the diagonal block
valid_diag([], _, _).
valid_diag([Head|Tail], Index, Val) :-
    index_ls(Index, Val, Head),
    NextIndex #= Index + 1,
    valid_diag(Tail, NextIndex, Val).
