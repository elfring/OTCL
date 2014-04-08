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

class c : int -> object
  val b : Buffer.t
  method add_buffer : Buffer.t -> unit
  method add_channel : in_channel -> len:int -> unit
  method add_char : char -> unit
  method add_string : string -> unit
  method add_substring : string -> pos:int -> len:int -> unit
  method clear : unit
  method contents : string
  method length : int
  method output : out_channel -> unit
  method reset : unit
end
