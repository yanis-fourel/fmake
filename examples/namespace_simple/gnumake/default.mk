.DEFAULT_GOAL := all

# mkfile_path_ := $(abspath $(lastword $(MAKEFILE_LIST)))
# current_dir_ := $(notdir $(patsubst %/,%,$(dir $(mkfile_path_))))
current_dir_ :=.

NAMESPACE__:=mylib__
include mylib/mylib.mk
#TODO: properly 'pop' the namespace, respecting possible nested namespaces

SRCDIR=$(current_dir_)/src
SRC=$(SRCDIR)/main.c
OBJ=$(SRC:.c=.o)

NAME=$(current_dir_)/hello_world

all: $(NAME)

$(NAME): $(mylib__STATIC) $(OBJ)
	$(CC) $(OBJ) -o $@ -I $(mylib__INCDIR) $(mylib__STATIC)


clean: mylib__clean
	rm -f $(OBJ)
