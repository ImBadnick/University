type ide = string;;

type exp = CstInt of int
| CstTrue
| CstFalse
| Times of exp * exp
| Sum of exp * exp
| Sub of exp * exp
| Eq of exp * exp
| Iszero of exp
| Or of exp * exp
| And of exp * exp
| Not of exp
| Den of ide
| Ifthenelse of exp * exp * exp
| Let of ide * exp * exp
| Fun of ide list * exp
| Appl of exp * exp list;;

let rec lookup x env = match env with
    | [] -> failwith("can't find the value")
    | (z,t)::xs-> if x==z then t
            else lookup x xs;;

let rec bind x y env = match env with
              | [] -> (x,y)::[]
              | x::xs -> bind x y xs;;


              let typecheck (x,y) = match x with
                | int -> match y with
                	     | Int(u) -> true
                       | _ -> false
                | bool -> match y with
                       | Bool(u) -> true
                       | _ -> false;;








type exp = Stack of stackarg;; and stackarg= Empty | Val of exp*stackarg;;      // exp=valore, stackarg= Resto dei valori


type evT = Stackvalue of evT list;;

let rec eval e r=
                  match e with
                  .
                  .
                  | Stack(l) -> Stackvalue(evallist l r);;
and let rec evallist ll amb =
          match ll with
          |Empty -> []
          |Val(e,sa) -> let evalue=eval e amb
                        in if typecheck("int",evalue) then evalue::(evallist sa amb)
                           else failwith("Not an int")
          |_ -> failwith("Not a stack");;





type exp = .... | Fun of ide * exp | Apply of exp * exp;;

type evT = .... | Clousure of ide * exp * evT env;;

let rec eval e env =
                     match e with
                     .
                     .
                     .
                     | Fun(id,e) -> Clousure(id,exp,env)
                     | Apply(Den(f),arg) -> let fclousure = lookup f env
                                            in match fclousure with
                                            | Clousure(id,exp,funenv) ->
                                                          let earg = eval arg env
                                                          in let newenv = bind id earg funenv
                                                          in eval exp newenv;;
                                            | _ -> failwith("not a function value");




lookup x env --> cerca il valore dell' identificatore x nell'ambiente env

bind x y env --> estende l'env con l'associazione ide(x)->val(y)


(*)
and evalList l amb =
                     match l with
                     | Empty -> []
                     | Val(id,e,ls) -> let evalue = eval e amb
                                       in (id,evalue)::evallist ls amb
                     | _ -> failwith("Not a dict")

and insert l id1 value=
                     match l with
                     | [] -> (id1,value)::[]
                     | x::xs -> insert xs id1 value

and delete l id1 a =
                     match (l,a) with
                     | ([],_) -> []
                     | (id,x)::xs -> if id == id1 && a == false then delete xs id1 true
                                     else (id,x)::delete xs id1

and haskey l id1 =
                     match l with
                     | [] -> false
                     | (id,x)::xs -> if id1==id then true
                                     else haskey xs id1

and apply funz l1 a =
                     match l1 with
                     | [] -> a
                     | (id,x)::xs -> apply xs ((funz x)+a)

and applyfun funct l1 =
                     match l1 with
                     | [] -> []
                     | (id,x)::xs -> (id,funct x) :: applyfun funct xs;;*)
