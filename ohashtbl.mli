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

class ['a, 'b] c :
    ?equal:('a -> 'a -> bool) -> ?hash:('a -> int) -> int ->
  object ('c)
      (* [new c size ?equal ?hash] creates a new hash table
	 of given initial size, hash function, and using equality
	 [equal] on keys.
	 [equal] and [hash] default to Pervasives.(=) (logical equality)
	 and Hashtbl.hash. [hash] shall be such that two keys equal
	 by [equal] have the same image by [hash] *)
    method add : key:'a -> data:'b -> unit
    method clear : unit
    method copy : 'c
    method find : 'a -> 'b
    method find_all : 'a -> 'b list
    method fold : f:(key:'a -> data:'b -> 'd -> 'd) -> 'd -> 'd
    method iter : f:(key:'a -> data:'b -> unit) -> unit
    method mem : 'a -> bool
    method remove : 'a -> unit
    method replace : key:'a -> data:'b -> unit
  end
