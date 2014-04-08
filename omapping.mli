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

(* An embryo of class hierarchy for mappings.
   4 implementations of Omapping.c are provided:

    * Omapping.alist: association lists
    * Omap.c, Omap.f: BDD-based maps, imperative and functional versions
    * Ohashtbl.c: Hash tables

   Omapping.alist and Omap.f support the stronger functional interface
   Omapping.f.
   We have also Ohashtbl.c <: Omap.c *)

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

class ['a,'b] alist :
  ?equal:[`Logical|`Physical] -> ('a * 'b) list -> ['a,'b] f
      (* A class wrapper for association lists.
	 If [equal] is [`Physical] then use List.assq for find,
	 otherwise use List.assoc. *)
