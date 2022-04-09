# What is `fmake`

This is a giga-early draft. Most of it is more 'out loud thinking' than actual plans.

I just chose the name `fmake`, standing for "functional Make". The goal of this language is to repace Make by providing the same low-level `sh` script control over how everything is make, while providing a more abstract functionnal flavored layer to allow projects to scale and reference each other safely.

TODO: develop why a functional paradygm is perfect for a build system.
Is GNU Make already a 'functional language' ?


# Why not just `Make`

TODO: Proove that `make` is too limited


# How does it work

It transpiles everything to GNU Make Makefiles, and invokes GNU Make on it

# `fmake` features

## Invoking fmake

Invoking `fmake` works exactly the same way as invoking `make`
```
> fmake [OPTIONS]... [TARGET]...
```
TODO: option to target a 'main fmakefile'. May the default file should be name "./main.fmake"...  

`make`  searches for a file called "./Makefile"  
`fmake` searches for a file called "./default.fmake"  

This design decision comes from the fact that `fmake` files are aimed to be as easily executed by themselves than to be included by others. This is super useful when building libraries that you want to expose. Keeping the `fmake` extension encourages other `fmake` files to be created, where the name "Makefile" encourages everything to be put in a single file  

## Variables:

### Additional predefined variables:

Special variables starting with an '$^' (TODO: define a symbol)

	$^DIR : The absolute path to the current Makefile

	$^ENV.XYZ : The XYZ env environment


### Mandatory declaration

Every used variable has to be previously defined.


## Namespacing

Every makefile can be imported as a namespace (TODO: and maybe define different namespaces inside a makefile?):

```
import "mylib/default.fmake" as mylib # TODO: Should we chose a name to import it as, or an name to export the API as ? The later would trade vanilla Makefile compatibility for consistency across names (the same Makefile is always imported as the same name) and easier refactor (LSP could rename in all files)

NAME=foo
OBJ=...

all: $(NAME)

$(NAME): $(mylib.LIB_STATIC)
	$(CC) $(OBJ) $(mylib.LIB_STATIC) -I (mylib.INC_PATH) -o $@
```


This allows to safely include any Makefile without risking name clashes
example:


mylib/default.fmake:
```
BIN_DIR=$(DIR)/bin/ # << $(DIR) is an automatic variable that is the absolute path to current Makefile

LIB_STATIC=$(BIN_DIR)/mylib.a

$(LIB_STATIC):
	...
```

myproject/default.fmake:
```
import "mylib/default.fmake" as mylib

BIN_DIR=$(DIR)/bin # << NOTE: BIN_DIR can safely be defined because not in the same namespace as mylib.BIN_DIR

mylib.BIN_DIR=$(DIR)/lib_bin/


myproject: $(mylib.LIB_STATIC) # << will build mylib static with BIN_DIR = $(DIR)/lib_bin
	$(CC) main.c $(mylib.LIB_STATIC) $(mylib.INCLUDE)
```

## Target and functions

No more `rule` concept: .PHONY 'rules' are now `functions`, and 'rules' to build a file/folder are called `target`
TODO: define syntax. Rethink about `functions`, are they really useful ? Probably not in the core build system but maybe side tasks such as clearing... idk

Both target and functions can take parameters

A variable can be the result of a function / rule.

example:
./codegen/default.fmake
```
DEFAULT_DISTDIR=$^(DIR)/dist
OUT_NAME=code.py

func gen_default: 

.param distdir
.name generate     # <<< TODO: How to give a name ?
$(distdir)/$(OUT_NAME):
	echo 'print("Hello world")' > $@
```

./pythonproject/default.fmake
```
import "../codegen/default.fmake" as codegen

DISTDIR=$^(DIR)/project_dist/

GENERATED_FILE=$(codegen.generate($(DISTDIR)))

all: $(GENERATED_FILE)  # This will generated the python file in this project's $(DISTDIR)
	python $(GENERATED_FILE) # Launch the file
```

TODO:
This has to be the most powerful feature of `fmake`. The syntax has to be very carefully designed

What kind of assignment should parameters be passed as ? How can we give user the choice, and what default to use ?
How to properly give a name to a target whose name uses a parameter ?
What to do if this target is the default target ?

Should we call that `template` and use an entirely new syntax ?
example syntax with `template`

## Template

TODO: This is more or less just explicitely listing all the variables used in a rule. all GNU Make `targets` ARE templates that use other variables...
This is either redundant, syntactic sugar, transpile-time error check, or the start of an entire redisign of Make logic that stops using global variables

Maybe this is just a way to clearly expose people what varibles you give them access to changing safely, or just as a documentation of 'what's possible to change'


```
DEFAULT_DISTDIR=$^(DIR)/dist
DEFAULT_FILENAME=main.py

.template generate <
	distdir ?= $(DEFAULT_DISTDIR)
	filename ?= $(DEFAULT_FILENAME)
> 
$(distdir)$(filename):
	echo 'print("Hello world")' > $@


MY_OUTPUT=generate<distdir := "$^(DIR)/newdist"
```

## Syntax

TODO: design decision. Need trial and error
All variables have to be defined between quotes (or something)

ex
```
SRCDIR = $^(DIR)/src   # ERROR

SRCDIR = "$^(DIR)/src" # OK
```

This aims at preventing accidental extra spaces, and maybe enforce a type system. Maybe this could help make it clearer what is directly assigned (assigned a string) to what is assigned the return value of a function or  a target


Also this could remove the need to type $() around variable names, if all values are surrounded by quotes. all values would be concatenated by default (maybe a symbol could make it cleaner, say ".."
example:
```
SRCDIR = ^DIR .. "/src"
OBJDIR = ^DIR .. "/obj"

SRC = SRCDIR .. "main.c"
OBJ = pathsubst js sais plus

a.out: OBJ, SomethingElse   # NOTE: that would probably require comma separation of lists. This kind of goes in the way of functions. `functionnal make` could be a thing. `fmake`
```

## Typing (?)

TODO: This entire section is WIP (or THINKING IN PROGRESS)
Types:
	- String
	- File
	- Path      : Automatic multi-slash concact ? methods to .slash("path").slash("to").slash("file") for portability?
	- Target
	- Function
	- List<T>

Could it prevent some mistakes ?
need examples

