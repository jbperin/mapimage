/* =======================================
 * 	       gl65 3D            v0.1
 * =======================================
 *     3D graphic library for 6502  
 *			
 *			by Jean-Baptiste PERIN 
 *
 *  advised by the great Mickael POINTIER 
 *                        (a.k.a Dbug)
 *  for insane optimizations 
 * =======================================
 * 
 * Copyright 2020 Jean-Baptiste PERIN
 * Email: jbperin@gmail.com
 *
 * Website: https://github.com/jbperin/gl65
 * 
 * =======================================
 */

#ifndef GL65_H
#define GL65_H


#define ADR_BASE_SCREEN         48000 
#define HIRES_SCREEN_ADDRESS    0xA000

#define SIZEOF_3DPOINT          4
#define SIZEOF_SEGMENT          4
#define SIZEOF_PARTICULE        2
#define SIZEOF_2DPOINT          4
#define SIZEOF_FACE             4

#define NB_LESS_LINES_4_COLOR   4


extern void glProjectArrays();
extern void glDrawFaces();
extern void glDrawSegments();
extern void glDrawParticules();
extern void glInitScreenBuffers();
extern void glBuffer2Screen();
extern void glZPlot(signed char X, signed char Y, unsigned char dist, char char2disp);
extern void glProjectPoint(signed char x, signed char y, signed char z, unsigned char options, signed char *ah, signed char *av, unsigned int *dist);
#endif

