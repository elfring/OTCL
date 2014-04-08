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

type 'a t

class ['a] c : ?compare:('a -> 'a -> int) -> 'a list -> object ('b)
      (* [new c elements ?compare] creates a set using comparison
      	 function compare and initializes it to elements.
	 This set is imperative, but you may take copies *)
  method contents : 'a t
  method set : 'b -> unit
      (* [s1#set s2] copies the state of s2 to s1 *)
  method clear : unit
      (* resets the state to empty *)
  method is_empty : bool
  method mem : 'a -> bool
  method add : 'a -> unit
  method remove : 'a -> unit
      (* add and remove modify the state *)
  method union : 'b -> 'b
  method inter : 'b -> 'b
  method diff : 'b -> 'b
      (* union, inter and diff return a new set without side-effect *)
  method compare : 'b -> int
  method equal : 'b -> bool
  method subset : 'b -> bool
  method iter : f:('a -> unit) -> unit
  method fold : f:('a -> 'c -> 'c) -> 'c -> 'c
  method for_all : f:('a -> bool) -> bool
  method exists : f:('a -> bool) -> bool
  method filter : f:('a -> bool) -> unit
  method partition : f:('a -> bool) -> 'b * 'b
  method cardinal : int
  method elements : 'a list
  method min_elt : 'a
  method max_elt : 'a
  method choose : 'a
end

class ['a] f : ?compare:('a -> 'a -> int) -> 'a list -> object ('b)
      (* functional version of Oset.c *)
  method contents : 'a t
  method is_empty : bool
  method mem : 'a -> bool
  method add : 'a -> 'b
  method remove : 'a -> 'b
  method union : 'b -> 'b
  method inter : 'b -> 'b
  method diff : 'b -> 'b
  method compare : 'b -> int
  method equal : 'b -> bool
  method subset : 'b -> bool
  method iter : f:('a -> unit) -> unit
  method fold : f:('a -> 'c -> 'c) -> 'c -> 'c
  method for_all : f:('a -> bool) -> bool
  method exists : f:('a -> bool) -> bool
  method filter : f:('a -> bool) -> 'b
  method partition : f:('a -> bool) -> 'b * 'b
  method cardinal : int
  method elements : 'a list
  method min_elt : 'a
  method max_elt : 'a
  method choose : 'a
end
