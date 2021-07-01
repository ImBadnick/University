(*
Author: Lorenzo Massagli
Date: 2020
Project: OCAML INTERPRETER
*)

type ide = string;;

type exp = Eint of int | Ebool of bool | Den of ide | Prod of exp * exp | Sum of exp * exp | Diff of exp * exp |
	Eq of exp * exp | Minus of exp | IsZero of exp | Or of exp * exp | And of exp * exp | Not of exp |
	Ifthenelse of exp * exp * exp | Let of ide * exp * exp | Fun of ide * exp | FunCall of exp * exp |
  Letrec of ide * exp * exp
  (*Extends a dict and his operations*)
  | Dict of dictarg
  | Insert of ide * exp * exp
  | Delete of exp * ide
  | Has_key of ide * exp
  | Iterate of exp * exp
  | Fold of exp * exp
  | Filter of (ide list) * exp
  | FunAcc of ide * ide * exp (*Extends binary functions*)
  | FunCallAcc of exp * exp * exp (*Extends binary functions*)
  and dictarg = Empty | Val of ide * exp * dictarg;;

(*polymorph enviroment*)
type 't env = ide -> 't;;
let emptyenv (v : 't) = function x -> v;;
let applyenv (r : 't env) (i : ide) = r i;;
let bind (r : 't env) (i : ide) (v : 't) = function x -> if x = i then v else applyenv r x;;

(*types*)
type evT = Int of int | Bool of bool | Unbound | FunVal of evFun | RecFunVal of ide * evFun
           | Dictvalues of (ide * evT) list
           | FunValAcc of evFunAcc (*Closure of a function that gets an accomulator*)
and evFunAcc= ide * ide * exp * evT env (*Closure of a function that gets an accomulator*)
and evFun = ide * exp * evT env;;

(*rts*)
(*type checking*)
let rec typecheck (s : string) (v : evT) : bool = match s with
	"int" -> (match v with
            Int(_) -> true
            | _ -> false)
  |	"bool" -> (match v with
		           Bool(_) -> true
               | _ -> false)
  | "unbound" -> (match v with
                Unbound -> true
                |_ -> false)
  | "funval" -> (match v with
                FunVal(_) -> true
                | _ -> false)
  | "recfunval" -> (match v with
                    RecFunVal(_) -> true
                    | _ -> false)
  | "funvalacc" -> (match v with
                     FunValAcc(_) -> true
                     | _ -> false)
  (*Dynamic typecheck of dict --> Controls if all the elements of the dict passed as parameter have the same type*)
  | "Dictvalues" -> (match v with
                     Dictvalues(l) -> (match l with
                                      [] -> true
                                      |(id,x)::xs -> if (typecheck "int" x) then typec "int" xs
                                                    else typec "bool" xs
                                      |_ -> failwith("typecheck error"))
                     |_ -> false
                     )
  | _ -> failwith("not a valid type")
  and typec (tp: string) (l:(ide * evT) list) : bool =
      (match l with
      [] -> true
      | (id,x)::xs -> (typecheck tp x) && (typec tp xs));;

(*primitive functions*)
let prod x y = if (typecheck "int" x) && (typecheck "int" y)
	then (match (x,y) with
		(Int(n),Int(u)) -> Int(n*u))
	else failwith("Type error");;

let sum x y = if (typecheck "int" x) && (typecheck "int" y)
	then (match (x,y) with
		(Int(n),Int(u)) -> Int(n+u))
	else failwith("Type error");;

let diff x y = if (typecheck "int" x) && (typecheck "int" y)
	then (match (x,y) with
		(Int(n),Int(u)) -> Int(n-u))
	else failwith("Type error");;

let eq x y = if (typecheck "int" x) && (typecheck "int" y)
	then (match (x,y) with
		(Int(n),Int(u)) -> Bool(n=u))
	else failwith("Type error");;

let minus x = if (typecheck "int" x)
	then (match x with
	   	Int(n) -> Int(-n))
	else failwith("Type error");;

let iszero x = if (typecheck "int" x)
	then (match x with
		Int(n) -> Bool(n=0))
	else failwith("Type error");;

let vel x y = if (typecheck "bool" x) && (typecheck "bool" y)
	then (match (x,y) with
		(Bool(b),Bool(e)) -> (Bool(b||e)))
	else failwith("Type error");;

let et x y = if (typecheck "bool" x) && (typecheck "bool" y)
	then (match (x,y) with
		(Bool(b),Bool(e)) -> Bool(b&&e))
	else failwith("Type error");;

let non x = if (typecheck "bool" x)
	then (match x with
		Bool(true) -> Bool(false) |
		Bool(false) -> Bool(true))
	else failwith("Type error");;

(*interpreter*)
let rec eval (e : exp) (r : evT env) : evT = match e with
      Eint n -> Int n
    | Ebool b -> Bool b
    | IsZero a -> iszero (eval a r)
    | Den i -> applyenv r i
    | Eq(a, b) -> eq (eval a r) (eval b r)
    | Prod(a, b) -> prod (eval a r) (eval b r)
    | Sum(a, b) -> sum (eval a r) (eval b r)
    | Diff(a, b) -> diff (eval a r) (eval b r)
    | Minus a -> minus (eval a r)
    | And(a, b) -> et (eval a r) (eval b r)
    | Or(a, b) -> vel (eval a r) (eval b r)
    | Not a -> non (eval a r)
    | Ifthenelse(a, b, c) -> let g = (eval a r) in
			                        if (typecheck "bool" g) then (if g = Bool(true) then (eval b r) else (eval c r))
                              else failwith ("nonboolean guard")
    | Let(i, e1, e2) -> eval e2 (bind r i (eval e1 r))
    | Fun(i, a) -> FunVal(i, a, r)
    | FunAcc(acc,i,a) -> FunValAcc(acc,i,a,r)   (*  Funzione che prende 2 parametri, usata per il fold  *)
    | FunCall(f, eArg) -> let fClosure = (eval f r) in
			                        (match fClosure with
                                   FunVal(arg, fBody, fDecEnv) -> eval fBody (bind fDecEnv arg (eval eArg r))
                                 | RecFunVal(g, (arg, fBody, fDecEnv)) -> let aVal = (eval eArg r) in
                                                                    	let rEnv = (bind fDecEnv g fClosure) in
				                                                          			let aEnv = (bind rEnv arg aVal) in
                                                                          eval fBody aEnv
                                 | _ -> failwith("non functional value"))
    | FunCallAcc(f,eAcc,eArg) -> let fclosure = (eval f r) in (*Chiamata di una funzione con 2 parametri*)
                                 (match fclosure with
                                    FunValAcc(acc,arg,fBody,fDecEnv) -> let newenv= bind fDecEnv arg (eval eArg r)
                                                                        in eval fBody (bind newenv acc (eval eAcc r)))
    | Letrec(f, funDef, letBody) ->  (match funDef with
            	                        	Fun(i, fBody) -> let r1 = (bind r f (RecFunVal(f, (i, fBody, r)))) in
                                               eval letBody r1
                                        |_ -> failwith("non functional def"))
    | Dict(l) -> Dictvalues(evalList l r [])
    | Insert(id,e1,d) -> (match eval d r with
                         Dictvalues(l1) -> let evalue = eval e1 r in Dictvalues(insert l1 id evalue)
                        | _ -> failwith("Insert not used on a dict"))
    | Delete(d,id) -> (match eval d r with
                      Dictvalues(l1) -> (match haskey l1 id with
                                        Bool true -> Dictvalues(delete l1 id)
                                        |Bool false -> failwith ("Non esiste la chiave nel dizionario --> Non posso eliminarla!"))
                      | _ -> failwith("delete not used on a dict"))
    | Has_key(id,d) -> (match eval d r with
                       Dictvalues(l1) -> haskey l1 id
                       | _ -> failwith("HasKey not used on a dict"))
    | Iterate(funz,d) -> (let x=eval d r in
                          match x with
                            (*Applying the function after have controlled that all elements of the dict have the same type*)
                            Dictvalues(l1) -> if (typecheck "Dictvalues" (Dictvalues(l1))) then Dictvalues(iterate funz l1 r)
                                              else failwith("Dynamic typecheck error")
                             | _ -> failwith("Iterate not used on a dict"))
    | Fold(funz,d) -> (let x=eval d r in
                       match x with
                       (* Checking if all elements of the dict have the same type and assigning the right accomulator*)
                       Dictvalues(l1) -> (match funz with
                                         FunAcc(_,_,Sum(_)) -> if (typecheck "Dictvalues" (Dictvalues(l1))) then fold funz l1 (Int(0)) r
                                                               else failwith("Dynamic typecheck error")
                                       | FunAcc(_,_,Prod(_)) -> if (typecheck "Dictvalues" (Dictvalues(l1))) then fold funz l1 (Int(1)) r
                                                                else failwith("Dynamic typecheck error")
                                       | FunAcc(_,_,Diff(_)) -> if (typecheck "Dictvalues" (Dictvalues(l1))) then fold funz l1 (Int(0)) r
                                                                else failwith("Dynamic typecheck error")
                                       | FunAcc(_,_,And(_)) -> if (typecheck "Dictvalues" (Dictvalues(l1))) then fold funz l1 (Bool(true)) r
                                                               else failwith("Dynamic typecheck error")
                                       | FunAcc(_,_,Or(_)) -> if (typecheck "Dictvalues" (Dictvalues(l1))) then fold funz l1 (Bool(false)) r
                                                              else failwith("Dynamic typecheck error")
                                       | _ -> failwith("Not an admissible function"))
                       | _ -> failwith("Fold not used on a dict"))

    | Filter(kl,d) -> (match eval d r with
                       Dictvalues(l1) -> Dictvalues(filter kl l1)
                       | _ -> failwith("Filter not used on a dict"))


    (*Function that evals the dict*)
     and evalList (l:dictarg) (amb: evT env) (a:(ide*evT) list) : (ide*evT) list = (match l with
                          Empty -> a
                          | Val(id,e,ls) -> let evalue = eval e amb
                                            in (evalList ls amb (match haskey a id with
                                                             Bool false -> a@[(id,evalue)]
                                                             |Bool true -> failwith("Ci sono chiavi duplicate!")
                                                ))
                          | _ -> failwith("Not a dict value"))

     (*Function that inserts an element at the end of the dict!*)
     and insert (l:(ide*evT) list) (id1:string) (value:evT) : (ide*evT) list=
                          (match haskey l id1 with
                           Bool true -> failwith("Insert errato -> Esiste gia' la chiave nel dizionario")
                           |Bool false -> l @ [(id1,value)])

     (*Function that deletes an element of the dict that has the same key of the key passed in parameters*)
     and delete (l:(ide*evT) list) (id1:string) : (ide*evT) list =
                          ( match l with
                           [] -> []
                         | ((id,x)::xs) -> if id=id1 then delete xs id1
                                                else (id,x)::(delete xs id1) )

    (*Function that controls if the dict has the key passed in parameters*)
     and haskey (l:(ide*evT) list) (id1:string) : evT  = (match l with
                         [] -> Bool false
                       | (id,x)::xs -> if id1=id then Bool true
                                       else haskey xs id1)

     (*Function that applies the function passed as parameter to all the elements of the dict*)
     and iterate (funct:exp) (l1:(ide*evT) list) (amb:evT env) : (ide*evT) list = (match l1 with
                          [] -> []
                         | (id,x)::xs -> (match x with
                                           Int(u) ->let value = eval (FunCall(funct,Eint(u))) amb
                                                    in (id,value) :: iterate funct xs amb
                                           |Bool(w) ->let value = eval (FunCall(funct,Ebool(w))) amb
                                                     in (id,value) :: iterate funct xs amb
                                           |_ -> failwith("Error in iterate operation"))
                         |_ -> failwith("Not a dict"))

     (*Function that does the fold*)
     and fold (funct:exp) (l1:(ide*evT) list) (a:evT) (amb:evT env)  : evT  = (match l1 with
                                   [] -> a
                                 | (id,x)::xs -> (match (a,x) with
                                                  ((Int(u)),(Int(w))) -> fold funct xs (eval (FunCallAcc(funct,(Eint(u)),Eint(w))) amb) amb
                                                  |((Bool(u)),(Bool(w))) -> fold funct xs (eval (FunCallAcc(funct,(Ebool(u)),Ebool(w))) amb) amb
                                                  | _ -> failwith ("Error in fold operation"))
                                 | _ -> failwith("Not a dict"))
     (*Function that filters the elements of the dict -> Eliminates the elements that are not in the list passed as parameter*)
    and filter (kl:string list) (l:(ide*evT) list) : (ide*evT) list = (match l with
                                  [] -> []
                                  |(id,x)::xs ->  if (empty kl) then []
                                                  else if (List.mem id kl) then (filter kl xs)@[(id,x)]
                                                  else filter kl xs)
    (*Function that controls if a list is empty*)
    and empty (l:string list) : bool= (match l with
                                      [] -> true
                                     | _ -> false);;
