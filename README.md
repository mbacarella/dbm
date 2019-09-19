# The CamlDBM library

## OVERVIEW

This is a fork of the "official" CamlDBM library.  I started this fork to get rid of some build errors that happen if you try to use it in the Jane ecosystem.  The major changes are porting to dune and very lightly using Base/Core.

This OCaml library is a binding to the NDBM/GDBM Unix "databases" -- more exactly, persistent key-value stores.

See the file `dbm.mli` for documentation of the programming inteface.

This library used to be included in the standard OCaml distribution. This is the standalone distribution of this library, with the same functionalities.


## REQUIREMENTS

* OCaml
* Either the GDBM library or any NDBM-compatible library.  Make sure to install the development files as well.  For Debian or Ubuntu, install the package `libgdbm-dev`.


## INSTALLATION

* Build the library:
       dune build

* Test the library:
       dune runtest

* Install the library with opam pin


## USAGE

In bytecode:
     ocamlc dbm.cma <other bytecode files>

In native code:
     ocamlopt dbm.cmxa <other bytecode files>


## LICENSE

This Library is distributed under the terms of the GNU Library General Public License version 2, with a special exception allowing unconstrained static linking.  See file LICENSE for details.
