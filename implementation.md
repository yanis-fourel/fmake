
# Namespace

When including a file with the `import` keyword, we create a variable called "NAMESPACE__" like so:

`fmake`:
```
import "mylib/mylib.fmake" as my_library
```
`transpiled gnumake`:
```
$(NAMESPACE__):=my_library__
include "mylib/mylib.mk"
```

then in that file, we start by computing the new name of each variable and rules and store the new name in a simple variable named "NAMESPACED__<name>" like so:

`fmake`:
```
SRCDIR=./src
SRC=$(SRCDIR)/main.c
```
`transpiled gnumake`:
```
$(NAMESPACED__SRCDIR):=$(NAMESPACE__)SRCDIR
$(NAMESPACED__SRC):=$(NAMESPACE__)SRC

$(NAMESPACED__SRCDIR)=./src
$(NAMESPACED__SRC)=$($(NAMESPACED__SRCDIR))main.c
```
notice how we had to evaluate the variable whose name was stored in `NAMESPACED__SRCDIR` to get the value of SRCDIR.

Now, every dot in a variable name is replaced by a double underscore like so:
`fmake`:
```
$(NAME): my_library.STATIC
```
`transpiled gnumake`:
```
$($(NAMESPACED__NAME)): my_library__STATIC
```
this `my_library__STATIC` is the true name of the STATIC variable in the my_library namespace, as described by the value of NAMESPACED_STATIC in the mylib.fmake file

## Still to be done:

### Test with variables name who contain another variable changed later. 
eg:

$(BINDIR)myapp:
	...

toto: BINDIR=./
toto: $(BINDIR)myapp

### Handle nested namespace

Currently, we can 'push' a namespace with
```
$(NAMESPACE__):=$(NAMESPACE__)subnamespace__
```
but we can't 'pop' the added namespace properly.

There may be some tricks to save the old namespace with a variable containing the full makefile path, otherwise we'd have to use a list.
Using a list is probably the best option

## Notes:

+ Requires understanding of what is a variable/rule
+ Have to check about circular include
