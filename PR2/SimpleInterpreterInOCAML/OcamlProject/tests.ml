(*
Author: Lorenzo Massagli
Date: 2020
Project: Interpreter in OCAML
*)

(*                TEST            *)

(*                TEST EVAL DICTIONARY                 *)

(*Should eval Dict*)
eval (Dict(Val("p1",Eint(10),Val("p2",Eint(20),Empty)))) (emptyenv Unbound);; 

(*Should eval Dict*)
eval (Dict(Val("p1",Eint(10),Val("p2",Ebool(true),Empty)))) (emptyenv Unbound);; 

(*Should eval Empty Dict --> Dict(Empty) *)
eval (Dict(Empty)) (emptyenv Unbound);; 

(*Should generate an error --> double key in dict*)
eval (Dict(Val("p2",Eint(10),Val("p2",Ebool(true),Empty)))) (emptyenv Unbound);; 

(*                TEST INSERT           *)

(*Should insert (p3,Int(30))*)
eval (Insert("p3",Eint(30),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Empty)))))) (emptyenv Unbound);; 

(*Should insert (p3,Bool(true))*)
eval (Insert("p3",Ebool(true),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Empty)))))) (emptyenv Unbound);; 

(*Should generate an error --> double key in dict*)
eval (Insert("p3",Eint(30),(Dict(Val("p2",Eint(10),Val("p2",Eint(20),Empty)))))) (emptyenv Unbound);; 

(*Should generate an error --> double key*)
eval (Insert("p3",Eint(30),(Dict(Val("p1",Eint(10),Val("p3",Eint(20),Empty)))))) (emptyenv Unbound);; 

(*Should insert the key in the Empty Dict!*)
eval (Insert("p3",Eint(30),(Dict(Empty)))) (emptyenv Unbound);; 


(*                TEST DELETE           *)

(*Should delete the key p2*)
eval (Delete((Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))),"p2")) (emptyenv Unbound);; 

(*Should generate an error --> Key not found*)
eval (Delete((Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))),"p4")) (emptyenv Unbound);; 

(*Should generate an error --> Double key in dict!*)
eval (Delete((Dict(Val("p1",Eint(10),Val("p3",Eint(20),Val("p3",Eint(30),Empty))))),"p4")) (emptyenv Unbound);; 

(*Should generate an error --> Key not found*)
eval (Delete(Dict(Empty),"p2")) (emptyenv Unbound);; 


(*                TEST HASKEY           *)

(*Should say true --> Key exists in dict*)
eval (Has_key("p1",(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Empty)))))) (emptyenv Unbound);; 

(*Should say false --> key doesn't exists in dict*)
eval (Has_key("p3",(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Empty)))))) (emptyenv Unbound);; 

(*Should say false --> Dict is Empty!*)
eval (Has_key("p1",Dict(Empty))) (emptyenv Unbound);; 

(*Should generate an error --> Double key in dict!*)
eval (Has_key("p3",(Dict(Val("p2",Eint(10),Val("p2",Eint(20),Empty)))))) (emptyenv Unbound);; 


(*               TEST ITERATE          *)
eval (Iterate(Fun("y", Sum(Den "y", Eint 101)),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Iterate(Fun("y", Prod(Den "y", Eint 101)),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Iterate(Fun("y", Diff(Den "y", Eint 101)),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Iterate(Fun("y", And(Den "y", Ebool true)),(Dict(Val("p1",Ebool(true),Val("p2",Ebool(false),Val("p3",Ebool(true),Empty))))))) (emptyenv Unbound);;

eval (Iterate(Fun("y", Or(Den "y", Ebool true)),(Dict(Val("p1",Ebool(true),Val("p2",Ebool(false),Val("p3",Ebool(true),Empty))))))) (emptyenv Unbound);;

eval (Iterate(Fun("y", IsZero(Den "y")),(Dict(Val("p1",Eint(0),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Iterate(Fun("y", Eq(Den "y", Eint 30)),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Iterate(Fun("y", Minus(Den "y")),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Iterate(Fun("y", Not(Den "y")),(Dict(Val("p1",Ebool(true),Val("p2",Ebool(false),Val("p3",Ebool(true),Empty))))))) (emptyenv Unbound);;

(*Should generate an error --> DICT HAS INCOMPATIBLE TYPES!!!!*)
eval (Iterate(Fun("y", Or(Den "y", Ebool true)),(Dict(Val("p1",Eint(10),Val("p2",Ebool(false),Val("p3",Ebool(true),Empty))))))) (emptyenv Unbound);;

(*Should generate an error --> DOUBLE KEY IN DICT!!!*)
eval (Iterate(Fun("y", Or(Den "y", Ebool true)),(Dict(Val("p1",Eint(10),Val("p3",Ebool(false),Val("p3",Ebool(true),Empty))))))) (emptyenv Unbound);;

(*Should iterate on Empty Dict then has to return an Empty Dict!*)
eval (Iterate(Fun("y", Prod(Den "y", Eint 101)),(Dict(Empty)))) (emptyenv Unbound);;


(*               TEST FOLD          *)

eval (Fold(FunAcc("acc","y",Sum(Den "acc",Sum(Den "y", Eint 10))),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Fold(FunAcc("acc","y",Prod(Den "acc",Prod(Den "y", Eint 10))),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Fold(FunAcc("acc","y",Diff(Den "acc",Diff(Den "y", Eint 10))),(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Fold(FunAcc("acc","y",Or(Den "acc",Or(Den "y", Ebool(true)))),(Dict(Val("p1",Ebool(false),Val("p2",Ebool(true),Val("p3",Ebool(true),Empty))))))) (emptyenv Unbound);;

eval (Fold(FunAcc("acc","y",And(Den "acc",And(Den "y", Ebool(false)))),(Dict(Val("p1",Ebool(false),Val("p2",Ebool(true),Val("p3",Ebool(true),Empty))))))) (emptyenv Unbound);;


(*Should generate an error --> DICT HAS INCOMPATIBLE TYPES!!!!*)
eval (Fold(FunAcc("acc","y",Sum(Den "acc",Sum(Den "y", Eint 10))),(Dict(Val("p1",Ebool(true),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

(*Should generate an error --> DOUBLE KEY IN DICT!!!*)
eval (Fold(FunAcc("acc","y",Sum(Den "acc",Sum(Den "y", Ebool true))),(Dict(Val("p2",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

(*Fold on a Empty Dict --> Should return the base value of accomulator*)
eval (Fold(FunAcc("acc","y",Prod(Den "acc",Prod(Den "y", Eint 10))),(Dict(Empty)))) (emptyenv Unbound);;

(*               TEST FILTER          *)

eval (Filter(["p1";"p2";"p3"],(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Filter(["p1"],(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

eval (Filter([],(Dict(Val("p1",Eint(10),Val("p2",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;

(*Should generate an error --> DOUBLE KEY IN DICT!!!*)
eval (Filter(["p1";"p2";"p3"],(Dict(Val("p1",Eint(10),Val("p3",Eint(20),Val("p3",Eint(30),Empty))))))) (emptyenv Unbound);;


(*               TEST DYNAMIC TYPECHECKER          *)

typecheck "Dictvalues" (eval (Dict(Val("p1",Eint(10),Val("p2",Ebool(true),Empty)))) (emptyenv Unbound));;

typecheck "Dictvalues" (eval (Dict(Val("p1",Ebool(true),Val("p2",Eint(10),Empty)))) (emptyenv Unbound));;

typecheck "Dictvalues" (eval (Dict(Val("p1",Eint(10),Val("p2",Eint(10),Empty)))) (emptyenv Unbound));;

typecheck "Dictvalues" (eval (Dict(Val("p1",Ebool(false),Val("p2",Ebool(true),Empty)))) (emptyenv Unbound));;

typecheck "prova" (eval (Dict(Val("p1",Eint(10),Val("p2",Eint(10),Empty)))) (emptyenv Unbound));;

typecheck "funval" (FunVal("p1", (Sum(Den "p1", Eint 10)), (bind (emptyenv Unbound) "p1" (Int(10)))));;

