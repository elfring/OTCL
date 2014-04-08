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

class c : string list -> object
      (* [new c keywords] creates a lexer using the keyword list.
         Output methods are inherited from Ostream.c *)
  val buffer : Obuffer.c
  val kwd_table : (string, Genlex.token) Ohashtbl.c
  val mutable s : Genlex.token Stream.t
  val mutable input : char Stream.t
  val mutable start : int
  val mutable stop : int
  method out : Genlex.token Stream.t
      (* the output stream of the lexer *)
  method iter : f:(Genlex.token -> unit) -> unit
  method next : Genlex.token
  method empty : unit
  method peek : Genlex.token option
  method junk : unit
  method count : int
      (* methods for the output stream of the lexer *)
  method start : int
      (* the count of the character starting the next token *)
  method stop : int
      (* the count of the last character of the last token *)
  method init : char Stream.t -> unit
      (* set input stream and reset both counters and output *)
end

(* This lexer is based on Genlex, and reuses most of its code.
   Using the object version presents some advantages.
   * you can get position information about the input stream
   * you can change the input stream, reusing the same lexer
     several times.
   You can create an independent lexer using the same keyword table
   by 1) Copying it with Oo.copy and 2) re-initializing it.
*)
