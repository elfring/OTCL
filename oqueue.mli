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

class ['a] c : unit -> object
  val q : 'a Queue.t
  method add : 'a -> unit
  method take : 'a
  method peek : 'a
  method clear : unit
  method length : int
  method is_empty : bool
  method iter : f:('a -> unit) -> unit
  method fold : f:('b -> 'a -> 'b) -> 'b -> 'b
end
