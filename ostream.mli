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

class ['a] c : 'a Stream.t -> object
      (* [new c s] creates a new stream object acting on s *)
  val mutable s : 'a Stream.t
      (* the internal stream is not actually modified by methods,
      	 but subclasses may change it *)
  method out : 'a Stream.t
      (* [st#out] returns the internal stream *)
  method iter : f:('a -> unit) -> unit
  method next : 'a
  method empty : unit
  method peek : 'a option
  method junk : unit
  method count : int
end

val from : (int -> 'a option) -> 'a c
val of_list : 'a list -> 'a c
val of_string : string -> char c
val of_channel : in_channel -> char c
