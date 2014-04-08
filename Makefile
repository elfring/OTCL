#Adjust this directory for installation
LIBDIR=`ocamlc -where`
COMPILER=ocamlc -c
LIBRARIAN=ocamlc -a
OPTCOMP=ocamlopt -c
OPTLIB=ocamlopt -a
INSTALL=cp

OBJECTS=obuffer.cmo	ohashtbl.cmo	oqueue.cmo	ostack.cmo \
	omap.cmo	oset.cmo	ostream.cmo	omapping.cmo
#	ogenlex.cmo
OPTOBJS=$(OBJECTS:.cmo=.cmx)

# Default rules

.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(COMPILER) $(INCLUDES) $<

.ml.cmx:
	$(OPTCOMP) $(INCLUDES) $<

.mli.cmi:
	$(COMPILER) $(INCLUDES) $<

all: stdclass.cma
opt: stdclass.cmxa

stdclass.cma: $(OBJECTS)
	$(LIBRARIAN) -o stdclass.cma $(OBJECTS)

stdclass.cmxa: $(OPTOBJS)
	$(OPTLIB) -o stdclass.cmxa $(OPTOBJS)

ogenlex.cmo: ogenlex.ml
	$(COMPILER) -pp camlp4o $(INCLUDES) $<

ogenlex.cmx: ogenlex.ml
	$(OPTCOMP) -pp camlp4o $(INCLUDES) $<

install:
	@$(MAKE) real-install LIBDIR=$(LIBDIR)

real-install:
	$(INSTALL) stdclass.cma *.cmi *.mli $(LIBDIR)
	if test -f stdclass.cmxa; \
	then $(INSTALL) stdclass.cmxa stdclass.a *.cmx $(LIBDIR); fi

clean:
	rm -f *.cm* *.o *.a *~ #*

depend:
	ocamldep *.ml *.mli > .depend

include .depend
