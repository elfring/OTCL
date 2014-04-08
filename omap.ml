(***********************************************************************)
(*                                                                     *)
(*                      OCaml Class Library                            *)
(*                                                                     *)
(*          Xavier Leroy, Jacques Garrigue, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996-2014 Institut National de Recherche en Informatique *)
(*  et en Automatique.  All rights reserved.  This file is distributed *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file LICENSE.        *)
(*                                                                     *)
(***********************************************************************)

open StdLabels

(* module Map = struct *)

type ('a,'b) t =
    Empty
  | Node of ('a,'b) t * 'a * 'b * ('a,'b) t * int

let empty = Empty

let height = function
    Empty -> 0
  | Node(_,_,_,_,h) -> h

let create l x d r =
  let hl = height l and hr = height r in
  Node(l, x, d, r, (if hl >= hr then hl + 1 else hr + 1))

let bal l x d r =
  let hl = match l with Empty -> 0 | Node(_,_,_,_,h) -> h in
  let hr = match r with Empty -> 0 | Node(_,_,_,_,h) -> h in
  if hl > hr + 2 then begin
    match l with
      Empty -> invalid_arg "Set.bal"
    | Node(ll, lv, ld, lr, _) ->
        if height ll >= height lr then
          create ll lv ld (create lr x d r)
        else begin
          match lr with
            Empty -> invalid_arg "Set.bal"
          | Node(lrl, lrv, lrd, lrr, _)->
              create (create ll lv ld lrl) lrv lrd (create lrr x d r)
        end
  end else if hr > hl + 2 then begin
    match r with
      Empty -> invalid_arg "Set.bal"
    | Node(rl, rv, rd, rr, _) ->
        if height rr >= height rl then
          create (create l x d rl) rv rd rr
        else begin
          match rl with
            Empty -> invalid_arg "Set.bal"
          | Node(rll, rlv, rld, rlr, _) ->
              create (create l x d rll) rlv rld (create rlr rv rd rr)
        end
  end else
    Node(l, x, d, r, (if hl >= hr then hl + 1 else hr + 1))

let rec add ~cmp x data = function
    Empty ->
      Node(Empty, x, data, Empty, 1)
  | Node(l, v, d, r, h) ->
      let c = compare x v in
      if c = 0 then
        Node(l, x, data, r, h)
      else if c < 0 then
        bal (add ~cmp x data l) v d r
      else
        bal l v d (add ~cmp x data r)

let rec find ~cmp x = function
    Empty ->
      raise Not_found
  | Node(l, v, d, r, _) ->
      let c = compare x v in
      if c = 0 then d
      else find ~cmp x (if c < 0 then l else r)

let rec mem ~cmp x = function
    Empty ->
      false
  | Node(l, v, d, r, _) ->
      let c = compare x v in
      c = 0 || mem ~cmp x (if c < 0 then l else r)

let rec merge t1 t2 =
  match (t1, t2) with
    (Empty, t) -> t
  | (t, Empty) -> t
  | (Node(l1, v1, d1, r1, h1), Node(l2, v2, d2, r2, h2)) ->
      bal l1 v1 d1 (bal (merge r1 l2) v2 d2 r2)

let rec remove ~cmp x = function
    Empty ->
      Empty
  | Node(l, v, d, r, h) ->
      let c = compare x v in
      if c = 0 then
        merge l r
      else if c < 0 then
        bal (remove ~cmp x l) v d r
      else
        bal l v d (remove ~cmp x r)

let rec iter ~f = function
    Empty -> ()
  | Node(l, v, d, r, _) ->
      iter ~f l; (f ~key:v ~data:d : unit); iter ~f r

let rec fold ~f m init =
  match m with
    Empty -> init
  | Node(l, v, d, r, _) ->
      fold ~f l (f ~key:v ~data:d (fold ~f r init))

(* end *)

class ['a,'b] c ?compare:(cmp=Pervasives.compare) l = object
  val mutable map =
    List.fold_left l ~init:Empty
      ~f:(fun acc (x,y : 'a * 'b) -> add ~cmp x y acc)
  method clear = map <- Empty
  method is_empty = map = Empty
  method add ~key ~data = map <- add ~cmp key data map
  method find key = find ~cmp key map
  method mem key = mem ~cmp key map
  method remove key = map <- remove ~cmp key map
  method iter = iter map
  method fold : 'c. f:(key:'a -> data:'b -> 'c -> 'c) -> 'c -> 'c = fold map
end

class ['a,'b] f ?compare:(cmp=Pervasives.compare) l = object
  val map =
    List.fold_left l ~init:Empty
      ~f:(fun acc (x,y : 'a * 'b) -> add ~cmp x y acc)
  method is_empty = map = Empty
  method add ~key ~data = {< map = add ~cmp key data map >}
  method find key = find ~cmp key map
  method mem key = mem ~cmp key map
  method remove key = {< map = remove ~cmp key map >}
  method iter = iter map
  method fold : 'c. f:(key:'a -> data:'b -> 'c -> 'c) -> 'c -> 'c = fold map
end
