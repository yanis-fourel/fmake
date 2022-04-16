TODO:


# Namespace

TODO: Test with variables name who contain another variable changed later. 
eg:

$(BINDIR)myapp:
	...

toto: BINDIR=./
toto: $(BINDIR)myapp
