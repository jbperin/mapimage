/*
 *	platC64.c
 *	gl65
 *
 *	Created by Jean-Baptiste Périn, June 2020.
 *
 */

#include <c64.h>
#include <stdio.h>
#include <conio.h>
#include <string.h>
#include "../globals.h"
#include "../plat.h"


/*-----------------------------------------------------------------------*/
// System locations
#define VIC_BASE_RAM			(0xC000)
#define BITMAP_OFFSET			(0x0000)
#define CHARMAP_ROM				(0xD000)
#define SCREEN_RAM				((char*)VIC_BASE_RAM + 0x2000)
#define CHARMAP_RAM				((char*)VIC_BASE_RAM + 0x2800)

// #define SCREEN_WIDTH            40
// #define SCREEN_HEIGHT           26

void glBuffer2Screen() {
    memcpy(1024, fbuffer, SCREEN_HEIGHT* SCREEN_WIDTH);
}
