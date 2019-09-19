(***********************************************************************)
(*                                                                     *)
(*                                CamlDBM                              *)
(*                                                                     *)
(*          Francois Rouaix, projet Cristal, INRIA Rocquencourt        *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the GNU Library General Public License, with    *)
(*  the special exception on linking described in file ../../LICENSE.  *)
(*                                                                     *)
(***********************************************************************)

open! Core

let optfind d k = Dbm.find d k

let _ =
  let dbname = "testdatabase" in
  let db = Dbm.opendbm dbname [Dbm.Dbm_rdwr;Dbm.Dbm_create] 0o666 in
  Dbm.add db "one" "un";
  Dbm.add db "two" "dos";
  Dbm.replace db "two" "deux";
  Dbm.add db "three" "trois";
  assert (String.(=) (optfind db "one" ) "un");
  assert (String.(=) (optfind db "two") "deux");
  assert (String.(=) (optfind db "three") "trois");
  assert (try let _val = optfind db "four" in false with Not_found_s _ -> true);
  Dbm.close db;
  let db = Dbm.opendbm "testdatabase" [Dbm.Dbm_rdonly] 0 in
  Dbm.iter (fun k d -> printf "key '%s' -> data '%s'\n" k d) db;
  Dbm.close db;
  Dbm.delete_dbm dbname
