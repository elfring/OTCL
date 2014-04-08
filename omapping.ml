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

open StdLabels

class type ['a,'b] c = object
  method add : key:'a -> data:'b -> unit
  method find : 'a -> 'b
  method iter : f:(key:'a -> data:'b -> unit) -> unit
  method fold : 'c. f:(key:'a -> data:'b -> 'c -> 'c) -> 'c -> 'c
end

class type ['a,'b] f = object ('c)
  method add : key:'a -> data:'b -> 'c
  method find : 'a -> 'b
  method iter : f:(key:'a -> data:'b -> unit) -> unit
  method fold : 'c. f:(key:'a -> data:'b -> 'c -> 'c) -> 'c -> 'c
end

class ['a,'b] alist ?(equal=`Logical) l = object (_ : ('a,'b) #f)
  val assoc =
    match (equal : [`Physical|`Logical]) with
      `Physical -> List.assq
    | `Logical -> List.assoc
  val l = l
  method add ~key ~data = {< l = (key,data)::l >}
  method find key = assoc key l
  method iter ~f =
    List.iter l ~f:(fun (key,data) -> f ~key ~data)
  method fold : 'c. f:(key:'a -> data:'b -> 'c -> 'c) -> 'c -> 'c =
    fun ~f init ->
      List.fold_left l ~init
        ~f:(fun accu (key,data) -> f ~key ~data accu)
end
