NAMESPACED__mkfile_path_  := $(NAMESPACE__)mkfile_path_
NAMESPACED__current_dir_  := $(NAMESPACE__)current_dir_
NAMESPACED__STATIC        := $(NAMESPACE__)STATIC
NAMESPACED__INCDIR        := $(NAMESPACE__)INCDIR
NAMESPACED__SRCDIR        := $(NAMESPACE__)SRCDIR
NAMESPACED__SRC           := $(NAMESPACE__)SRC
NAMESPACED__OBJ           := $(NAMESPACE__)OBJ
NAMESPACED__clean         := $(NAMESPACE__)clean


$(NAMESPACED__mkfile_path_) := $(abspath $(lastword $(MAKEFILE_LIST)))
$(NAMESPACED__current_dir_) := $(notdir $(patsubst %/,%,$(dir $($(NAMESPACED__mkfile_path_)))))

$(NAMESPACED__STATIC)=$($(NAMESPACED__current_dir_))/mylib.a

$(NAMESPACED__INCDIR)=$($(NAMESPACED__current_dir_))/hdr
$(NAMESPACED__SRCDIR)=$($(NAMESPACED__current_dir_))/src

$(NAMESPACED__SRC)=$($(NAMESPACED__SRCDIR))/mylib.c
$(NAMESPACED__OBJ)=$($(NAMESPACED__SRC):.c=.o)


$($(NAMESPACED__STATIC)): $($(NAMESPACED__OBJ))
	ar rcs $@ $($(NAMESPACED__OBJ))

# TODO: that is I believe not a good practice...
.c.o:
	$(CC) -c $^ -o $@ -I $($(NAMESPACED__INCDIR))

$(NAMESPACED__clean):
	rm -f $($(NAMESPACED__OBJ))

