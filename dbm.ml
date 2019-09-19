(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*          Francois Rouaix, projet Cristal, INRIA Rocquencourt        *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file ../../LICENSE.  *)
(*                                                                     *)
(***********************************************************************)

open Base

(* $Id: dbm.ml 11156 2011-07-27 14:17:02Z doligez $ *)

type t

type open_flag =
   Dbm_rdonly | Dbm_wronly | Dbm_rdwr | Dbm_create

exception Dbm_error of string

external raw_opendbm : string -> open_flag list -> int -> t
              = "caml_dbm_open"

let opendbm file flags mode =
  try
    raw_opendbm file flags mode
  with Dbm_error _msg ->
    raise(Dbm_error("Can't open file " ^ file))

 (* By exporting opendbm as val, we are sure to link in this
    file (we must register the exception). Since t is abstract, programs
    have to call it in order to do anything *)

external close : t -> unit = "caml_dbm_close"
external raw_find : t -> string -> string = "caml_dbm_fetch"

let find t key =
  try
    raw_find t key
  with Caml.Not_found ->
    raise (Not_found_s (Sexp.Atom key))

external add : t -> string -> string -> unit = "caml_dbm_insert"
external replace : t -> string -> string -> unit = "caml_dbm_replace"
external remove : t -> string -> unit = "caml_dbm_delete"
external firstkey : t -> string = "caml_dbm_firstkey"
external nextkey : t -> string = "caml_dbm_nextkey"

let _ = Caml.Callback.register_exception "dbmerror" (Dbm_error "")

(* Usual iterator *)
let iter f t =
  let rec walk = function
      None -> ()
    | Some k ->
        f k (find t k);
        walk (try Some(nextkey t) with Caml.Not_found -> None)
  in
  walk (try Some(firstkey t) with Caml.Not_found -> None)

let delete_dbm fn =
  begin
    try Core.Sys.remove (fn ^ ".dir")
    (* A .dir file is not always created. *)
    with Sys_error _ -> ()
  end;
  Core.Sys.remove (fn ^ ".pag")
