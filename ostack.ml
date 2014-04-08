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

class ['a] c () = object
  val mutable s : 'a list = []
  method push x = s <- x :: s
  method pop =
    match s with x::s' -> s <- s'; x
    | [] -> raise Empty
  method top =
    match s with x::_ -> x
    | [] -> raise Empty
  method clear = s <- []
  method copy = {< s = s >}
  method is_empty = s = []
  method length = List.length s
  method iter ~f = List.iter f s
  method contents = s
end
