# nim_magic
# Copyright xmonader
# libmagic for nim


const  MAGIC_NONE*  = 0x000000                 # No flags 
const  MAGIC_DEBUG* = 0x000001                 # Turn on debugging 
const  MAGIC_SYMLINK* = 0x000002                 # Follow symlinks 
const  MAGIC_COMPRESS* = 0x000004                # Check inside compressed files 
const  MAGIC_DEVICES* = 0x000008                 # Look at the contents of devices 
const  MAGIC_MIME_TYPE* = 0x000010            # Return only the MIME type 
const  MAGIC_CONTINUE* = 0x000020             # Return all matches 
const  MAGIC_CHECK* = 0x000040                 # Print warnings to stderr 
const  MAGIC_PRESERVE_ATIME* = 0x000080        # Restore access time on exit 
const  MAGIC_RAW* = 0x000100                    # Don't translate unprint chars 
const  MAGIC_ERROR* = 0x000200                 # Handle ENOENT etc as real errors 
const  MAGIC_MIME_ENCODING* = 0x000400         # Return only the MIME encoding 
const  MAGIC_NO_CHECK_COMPRESS* = 0x001000     # Don't check for compressed files 
const  MAGIC_NO_CHECK_TAR* = 0x002000         # Don't check for tar files 
const  MAGIC_NO_CHECK_SOFT* = 0x004000         # Don't check magic entries 
const  MAGIC_NO_CHECK_APPTYPE* = 0x008000        # Don't check application type 
const  MAGIC_NO_CHECK_ELF* = 0x010000            # Don't check for elf details 
const  MAGIC_NO_CHECK_ASCII* = 0x020000         # Don't check for ascii files 
const  MAGIC_NO_CHECK_TOKENS* = 0x100000         # Don't check ascii/tokens 

import os
    
const libName* = "libmagic.so"

type Magic = object
type MagicPtr* = ptr Magic 

proc magic_open(i:cint) : MagicPtr {.importc, dynlib:libName.}
proc magic_close(p:MagicPtr): void {.importc,  dynlib:libName.}
proc magic_load(p:MagicPtr, s:cstring) : cint {.importc, dynlib: libName.}
proc magic_error(p: MagicPtr) : cstring  {.importc, dynlib:libName.}
proc magic_file(p:MagicPtr, filepath: cstring): cstring {.importc, dynlib: libName.} 

proc guessFile*(filepath: string, flags: cint = MAGIC_NONE): string =
    var mt : MagicPtr
    mt = magic_open(flags)
    discard magic_load(mt, nil)

    if fileExists(expandFilename(filepath)):
        result = $magic_file(mt, cstring(filepath))
    magic_close(mt)
