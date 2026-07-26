# Open Watcom Makefile
#
# It is expected to run this file with openwatcom's wmake under Linux or
# Unix-compatible system.
#
# The idea is to use a modern (Linux) system to cross-compile to legacy DOS.
#
# Watcom's makefile is subtly different than GNU Make. Do not attempt to run
# this under GNU make or other kinds of make, it will not work.
#
# See also:
# * Example:     https://github.com/open-watcom/open-watcom-v2/blob/master/bld/src/goodies/makefile.c
# * PDF docs:    https://open-watcom.github.io/open-watcom-v2-wikidocs/ctools.pdf
# * HTML docs:   https://open-watcom.github.io/open-watcom-v2-wikidocs/ctools.html#The_Open_Watcom_Make_Utility
# * Docs source: https://github.com/open-watcom/open-watcom-v2/blob/master/docs/doc/cmn/wmake.gml

# wcc     Open Watcom C x86 16-bit Optimizing Compiler
# wcc386  Open Watcom C x86 32-bit Optimizing Compiler
# wcl     Open Watcom C/C++ x86 16-bit Compile and Link Utility
# wcl386  Open Watcom C/C++ x86 32-bit Compile and Link Utility
# wdis    Open Watcom Multi-processor Disassembler
# wdump   Open Watcom Executable Image Dump Utility
# wlib    Open Watcom Library Manager
# wlink   Open Watcom Linker
# wmake   Open Watcom Make
# wpp     Open Watcom C++ x86 16-bit Optimizing Compiler
# wpp386  Open Watcom C++ x86 32-bit Optimizing Compiler
# wstrip  Open Watcom Executable Strip Utility

# wcc help (only the relevant options)
#
# -?              print this message
# 
# -bt[=<os>]      build target is operating system <os>
#
# -fo[=<file>]    set object file name
# -d<name>[=text] same as #define name [text] before compilation
# -u[=<name>]     undefine macro name
# -i=<path>       add directory to list of include directories
# -fi=<file>      force <file> to be included
# -x              ignore all ..INCLUDE environment variables
# -xx             ignore default directories for file search (.,../h,../c,...)
#
# -ei             force enum base type to use at least an int
# -em             force enum base type to use minimum integral type
# -en             emit routine names in the code segment
# -j              change char default from unsigned to signed
# -q              operate quietly (display only error messages)
# -zq             operate quietly (display only error messages)
# -r              save/restore segment registers across calls
# -ri             return chars and shorts as ints
# -s              remove stack overflow checks
# -zc             place const data into the code segment
# -zp=<num>       pack structure members with alignment {1,2,4,8,16}
# -zpw            output warning when padding is added in a class
# -zs             syntax check only
#
# -zA             disable all extensions (strict ISO/ANSI C)
# -za             disable extensions (i.e., accept only ISO/ANSI C)
# -zam            disable old non-ISO compliant names (macros, symbols)
# -zastd=<std>    use specified ISO/ANSI C language standard (c89,c99)
# -ze             enable extensions (i.e., near, far, export, etc.)
# -zev            enable arithmetic on void derived types
#
# -0              8086 instructions
# -1              186 instructions
# -2              286 instructions
# -3              386 instructions
# -4              386 instructions, optimize for 486
# -5              386 instructions, optimize for Pentium
# -6              386 instructions, optimize for Pentium Pro
# -fp{2,3,5,6}    Generate Floating-point code
#   2             - 80287 FPU code
#   3             - 80387 FPU code
#   5             - 80387 FPU code optimize for Pentium
#   6             - 80387 FPU code optimize for Pentium Pro
# -fpc            calls to floating-point library
# -fpd            enable Pentium FDIV bug check
# -fpi            inline 80x87 instructions with emulation
# -fpi87          inline 80x87 instructions
# -fpr            generate backward compatible 80x87 code
# -zri            inline floating point rounding calls
# -zro            omit floating point rounding calls (non ANSI)
#
# -m{c,h,l,m,s}   Memory model
#   c             - compact - small code/large data
#   h             - huge - large code/huge data
#   l             - large - large code/large data
#   m             - medium - large code/small data
#   s             - small - small code/small data (defaul)
#
#         Multi-byte/Unicode character support
# -zk{0,0u,1,2,3,l,u=<num>,u8} 
#   0             - Japanese (Kanji, CP 932)
#   0u            - translate double-byte Kanji to Unicode
#   1             - Chinese/Taiwanese (Traditional, CP 950)
#   2             - Korean (Wansung, CP 949)
#   3             - Chinese (Simplified, CP 936)
#   l             - local installed language
#   u=<num>       - load Unicode translate table for specified code page
#   u8            - Unicode UTF-8
#
#        Debugging Information
# -d{0,1,1+,2,2~,3} 
#   0             - none
#   1             - only line numbers
#   1+            - only line numbers
#   2             - symbolic information
#   2~            - -d2 but without type names
#   3             - symbolic information with unreferenced type names
# -h{c,d,w}       Debugging Information format
#   c             - generate Codeview debugging information
#   d             - generate DWARF debugging information
#   w             - generate Watcom debugging information
#
#         Optimization
# -o{a,b,c,d,e[=<num>],f,f+,h,i,k,l,l+,m,n,o,p,r,s,t,u,x,z} 
#   a             - relax aliasing constraints
#   b             - enable branch prediction
#   c             - disable <call followed by return> to <jump> optimization
#   d             - disable all optimizations
#   e[=<num>]     - expand user functions inline (<num> controls max size)
#   f             - generate traceable stack frames as needed
#   f+            - always generate traceable stack frames
#   h             - enable expensive optimizations (longer compiles)
#   i             - expand intrinsic functions inline
#   k             - include prologue/epilogue in flow graph
#   l             - enable loop optimizations
#   l+            - enable loop unrolling optimizations
#   m             - generate inline code for math functions
#   n             - allow numerically unstable optimizations
#   o             - continue compilation if low on memory
#   p             - generate consistent floating-point results
#   r             - reorder instructions for best pipeline usage
#   s             - favor code size over execution time in optimizations
#   t             - favor execution time over code size in optimizations
#   u             - all functions must have unique addresses
#   x             - equivalent to -obmiler -s
#   z             - NULL points to valid memory in the target environment
#
#         Warning control
# -w{=<num>,cd=<id>,ce=<id>,e,o,x} 
#   =<num>        - set warning level number
#   cd=<id>       - disable warning message <id>
#   ce=<id>       - enable warning message <id>
#   e             - treat all warnings as errors
#   o             - warn about problems with overlaid code
#   x             - set warning level to maximum setting
 
# wdis help (only the relevant options)
#
# -a          generate assembleable output
# -e          generate lists of externs
# -p          generate list of publics
# -m          leave C++ names mangled
#
# -i=<char>   initial character of internal labels
# -l[=<file>] generate listing file (.lst by default)
# -s[=<file>] include source lines

DEBUGLEVEL = -d3

CFLAGS = -q -3 -fp3 -bt=dos -ml $(DEBUGLEVEL) -ox
#LFLAGS = SYS dos OPTION STACK=8192
LFLAGS = SYS dos OPTION QUIET

PLATFORM = 16
SUFFIX = .exe

# Already defined by default in wmake.
# .EXTENSIONS: .exe .obj .c

all: hello.exe exvideo.exe

hello.exe: hello.obj hello2.obj
exvideo.exe: exvideo.obj

# Special macros:
#   $$ represents the character "$"
#   $# represents the character "#"
# UNIX compatible special macros:
#   $@ full file name of the target
#   $* target with the extension removed
#   $< list of all dependents
#   $? list of dependents that are younger than the target
#
# Special macros:
#   $<file_specifier><form_qualifier>
# where <file_specifier> is one of:
#   "^" represents the current target being updated
#   "[" represents the first member of the dependent list
#   "]" represents the last member of the dependent list
# and <form_qualifier> is one of:
#   "@" full file name
#   "*" file name with extension removed
#   "&" file name with path and extension removed
#   "." file name with path removed
#   ":" path of file name
#
# https://open-watcom.github.io/open-watcom-v2-wikidocs/ctools.html#Special_Macros
# https://open-watcom.github.io/open-watcom-v2-wikidocs/ctools.html#Macros
# https://open-watcom.github.io/open-watcom-v2-wikidocs/ctools.pdf
#  '-> page 96, section 10.2.4 Special Macros
#  '-> pages 119-120, section 10.33 Macros
#
# In summary:
# $^* means the current target without the extension
# $^@ means the current target with extension
# $[@ means the first dependent with extension

.c.obj:
	rm -f $^*.err
	wcc $(CFLAGS) -fo=$^@ $[@
	# Generating a disassembly of the object code.
	# This is equivalent to `gcc -S`.
	# > Open Watcom C/C++ compiles directly to object files,
	# > so we need the disassembler to achieve a similar effect.
	# https://open-watcom.github.io/open-watcom-v2-wikidocs/ctools.html#owcc_Options_Summary
	wdis -e -p -s -l $^@
	wdis -a -e -p -s -l=$^*.s $^@
	# Adding a Vi modeline
	echo // vi:ts=8 >> $^*.lst
	echo \; vi:ts=8 >> $^*.s

.obj.exe:
	wlink NAME $^@ $(LFLAGS) FILE { $< }
	@wc -c $^@

help: .SYMBOLIC
	# Page 144, section 10.39.1 echo command
	# The operating system shell "echo" command is intercepted by Make.
	# https://open-watcom.github.io/open-watcom-v2-wikidocs/ctools.pdf
	@echo Hello! Someday there will be help here.

clean: .SYMBOLIC
	rm -f hello.exe
	rm -f *.obj *.err *.s *.lst

# vim:ft=make
