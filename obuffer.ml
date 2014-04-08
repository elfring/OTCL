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

open Buffer

class c size = object
  val b = create size
  method contents = contents b
  method length = length b
  method clear = clear b
  method reset = reset b
  method add_char = add_char b
  method add_string = add_string b
  method add_substring s ~pos ~len = add_substring b s pos len
  method add_buffer = add_buffer b
  method add_channel chan ~len = add_channel b chan len
  method output oc = output_buffer oc b
end
