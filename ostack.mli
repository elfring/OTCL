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

exception Empty

class ['a] c : unit -> object ('b)
  val mutable s : 'a list
  method push : 'a -> unit
  method pop : 'a
  method top : 'a
  method clear : unit
  method copy : 'b
  method is_empty : bool
  method length : int
  method iter : f:('a -> unit) -> unit
  method contents : 'a list
end
