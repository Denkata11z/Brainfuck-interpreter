# Brainfuck

Assembly interpreter for the programming language Brainfuck

In specific, they take care of the fiddly bit with reading a file.

There are a few files:

 - main.s:
    This file contains the main function.
    It reads a file from a command line argument and passes it to your brainfuck implementation.

 - read_file.s:
    Holds a subroutine for reading the contents of a file.
    This subroutine is used by the main function in main.s.

 - brainfuck.s:
    This file contains the brainfuck implementation.
    It defines a `brainfuck` subroutine that takes
    a single argument: a string holding the code to execute.

 - Makefile:
    A file containing compilation information.  If you have a working make,
    you can compile the code in this directory by simply running the command `make`.

Actions :
  1. Run `make`
  2. Run `./brainfuck`
