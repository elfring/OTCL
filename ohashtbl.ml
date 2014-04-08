(***********************************************************************)
(*                                                                     *)
(*                      OCaml Class Library                            *)
(*                                                                     *)
(*               Jacques Garrigue, Nagoya University                   *)
(*                                                                     *)
(*  Copyright 2002-2014 Kyoto University and Nagoya University.        *)
(*  All rights reserved.  This file is distributed under the terms     *)
(*  of the GNU Library General Public License, with the special        *)
(*  exception on linking described in file LICENSE.                    *)
(*                                                                     *)
(***********************************************************************)

(* This is an example of the wrong way to mix modules and classes :-)
   You cannot use let module in the class prefix, and this forces this
   strange workaround, along with plenty of magic to break abstraction.
   Do not copy.
*)

type ('a, 'b) t
type key

class ['a,'b] c ?(equal = (=)) ?(hash=Hashtbl.hash) size =
  let (create, clear, copy, add, remove, find, find_all,
       replace, mem, iter, fold) =
    let mkey : 'a -> key = Obj.magic
    and unkey : key -> 'a = Obj.magic in
    let module H = Hashtbl.Make
        (struct type t = key
          let equal a b = equal (unkey a) (unkey b)
          let hash k = hash (unkey k)
        end) in
    let wrap : 'b H.t -> ('a,'b) t = Obj.magic
    and unwrap : ('a,'b) t -> 'b H.t = Obj.magic in
    ((fun n -> wrap (H.create n)), (fun t -> H.clear (unwrap t)),
     (fun t -> wrap (H.copy (unwrap t))),
     (fun t ~key ~data -> H.add (unwrap t) (mkey key) data),
     (fun t k -> H.remove (unwrap t) (mkey k)),
     (fun t k -> H.find (unwrap t) (mkey k)),
     (fun t k -> H.find_all (unwrap t) (mkey k)),
     (fun t ~key ~data -> H.replace (unwrap t) (mkey key) data),
     (fun t k -> H.mem (unwrap t) (mkey k)),
     (fun ~f t -> H.iter (fun k data -> f ~key:(unkey k) ~data) (unwrap t)),
     (fun ~f t -> H.fold (fun k -> f (unkey k)) (unwrap t)))
  in object
    val h = create size
    method clear = clear h
    method copy = {< h = copy h >}
    method add = add h
    method remove = remove h
    method find = find h
    method find_all = find_all h
    method replace = replace h
    method mem = mem h
    method iter = iter h
    method fold : 'c. f:(key:'a -> data:'b -> 'c -> 'c) -> 'c -> 'c =
      fun ~f init ->
        Obj.obj
          (fold h (Obj.repr init)
             ~f:(fun key data x -> Obj.repr (f ~key ~data (Obj.obj x))))
end
