/*
 *	globals.h
 *	gl65
 *
 *	Created by Jean-Baptiste Périn, June 2020.
 *
 */

#ifndef _GLOBALS_H_
#define _GLOBALS_H_


 // Camera Position use only low bytes
extern signed char      glCamPosX;
extern signed char      glCamPosY;
extern signed char      glCamPosZ;

 // Camera Orientation
extern signed char      glCamRotZ;  // -128 -> 127 unit : 2PI/(2^8 - 1)
extern signed char      glCamRotX;

 // Geometry size
extern unsigned char    glNbVertices;
extern unsigned char    glNbFaces;
extern unsigned char    glNbSegments;
extern unsigned char    glNbParticles;

 // Geometry buffers
extern signed char      glVerticesX[];
extern signed char      glVerticesY[];
extern signed char      glVerticesZ[];

extern unsigned char    glParticlesPt[];
extern unsigned char    glParticlesChar[];

extern unsigned char    glSegmentsPt1[];
extern unsigned char    glSegmentsPt2[];
extern unsigned char    glSegmentsChar[];

extern unsigned char    glFacesPt1[];
extern unsigned char    glFacesPt2[];
extern unsigned char    glFacesPt3[];
extern unsigned char    glFacesChar[];

// Render buffer
extern char             fbuffer[];  // frame buffer SCREEN_WIDTH * SCREEN_HEIGHT

#endif //_GLOBALS_H_