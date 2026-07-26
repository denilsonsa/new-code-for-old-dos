// This code is based on sample code from the official documentation:
// https://open-watcom.github.io/open-watcom-1.9/clib.html#_setvideomode
// https://open-watcom.github.io/open-watcom-1.9/clib.html#delay

// This program misbehaves if compiled with "large code" memory model.
// https://github.com/open-watcom/open-watcom-v2/issues/1641

#include <conio.h>
#include <graph.h>
#include <i86.h>
#include <stdio.h>

int main(int argc, char *argv[]){
    int mode;
    struct videoconfig vc;
    char buf[80];

    puts("Hi");
    delay(1000);
    puts("Querying the video modes");

    _getvideoconfig( &vc );
    puts("Got the video config");

    /* select "best" video mode */
    switch( vc.adapter ) {
    case _VGA :
    case _SVGA :
        puts( "VGA" );
        mode = _VRES16COLOR;
        break;
    case _MCGA :
        puts( "MCGA" );
        mode = _MRES256COLOR;
        break;
    case _EGA :
        if( vc.monitor == _MONO ) {
            puts( "EGA MONO" );
            mode = _ERESNOCOLOR;
        } else {
            puts( "EGA COLOR" );
            mode = _ERESCOLOR;
        }
        break;
    case _CGA :
        puts( "CGA" );
        mode = _MRES4COLOR;
        break;
    case _HERCULES :
        puts( "Hercules" );
        mode = _HERCMONO;
        break;
    default :
        puts( "No graphics adapter" );
        return 1;
    }
    delay(1000);
    if( _setvideomode( mode ) ) {
        _getvideoconfig( &vc );
        sprintf( buf, "%d x %d x %d\n", vc.numxpixels,
                          vc.numypixels, vc.numcolors );
        _outtext( buf );
        delay(2000);
        //getch();
        _setvideomode( _DEFAULTMODE );
    }
    return 0;
}
