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

open Stream

class ['a] c s = object
  val mutable s = (s : 'a Stream.t)
  method out = s
  method iter ~(f : 'a -> unit) = iter f s
  method next = next s
  method empty = empty s
  method peek =  peek s
  method junk = junk s
  method count = count s
end

let from f = new c (from f)
and of_list l = new c (of_list l)
and of_string s = new c (of_string s)
and of_channel ic = new c (of_channel ic)
