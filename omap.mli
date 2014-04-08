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

class ['a, 'b] c : ?compare:('a -> 'a -> int) -> ('a * 'b) list -> object
      (* [new c bindings ?compare] creates a new map using
      	 compare as comparison function, and initializes it
	 with the given bindings.
	 [new c bindings] uses Pervasives.compare.
	 This map is imperative, and behaves exactly like
	 Hashtbl.c, except that previous old bindings for the
      	 same key are not kept *)
  method clear : unit
  method is_empty : bool
  method add : key:'a -> data:'b -> unit
  method find : 'a -> 'b
  method mem : 'a -> bool
  method remove : 'a -> unit
  method iter : f:(key:'a -> data:'b -> unit) -> unit
  method fold : f:(key:'a -> data:'b -> 'c -> 'c) -> 'c -> 'c
end

class ['a, 'b] f : ?compare:('a -> 'a -> int) -> ('a * 'b) list -> 
object ('c)
      (* functional version of Omap.c *)
  method is_empty : bool
  method add : key:'a -> data:'b -> 'c
  method find : 'a -> 'b
  method mem : 'a -> bool
  method remove : 'a -> 'c
  method iter : f:(key:'a -> data:'b -> unit) -> unit
  method fold : f:(key:'a -> data:'b -> 'd -> 'd) -> 'd -> 'd
end
