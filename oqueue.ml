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

open Queue

class ['a] c () = object
  val q = create ()
  method add x = add x q
  method take = take q
  method peek = peek q
  method clear = clear q
  method is_empty = is_empty q
  method length = length q
  method iter ~(f : 'a -> unit) = iter f q
  method fold : 'b. f:('b -> 'a -> 'b) -> 'b -> 'b =
    fun ~f init -> fold f init q
end
