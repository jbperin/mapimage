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
#include <cc65.h>
#include <conio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

#include "gl65.h"

#define ANGLE_MAX 0xC0
#define ANGLE_VIEW 0xE0
#define DOLLAR 36

//  __                            
// / _\     ___   ___  _ __    ___
// \ \     / __| / _ \| '_ \  / _ \
// _\ \   | (__ |  __/| | | ||  __/
// \__/    \___| \___||_| |_| \___|

extern unsigned char glNbSegments;
extern unsigned char glNbFaces;
extern unsigned char glNbParticles;

extern unsigned char glSegmentsPt1[];
extern unsigned char glSegmentsPt2[];
extern unsigned char glSegmentsChar[];

extern unsigned char glParticlesPt[];
extern unsigned char glParticlesChar[];

extern unsigned char glFacesPt1[];
extern unsigned char glFacesPt2[];
extern unsigned char glFacesPt3[];
extern unsigned char glFacesChar[];


//    ___                 _              _    _               
//   / _ \ _ __   ___    (_)  ___   ___ | |_ (_)  ___   _ __  
//  / /_)/| '__| / _ \   | | / _ \ / __|| __|| | / _ \ | '_ \ 
// / ___/ | |   | (_) |  | ||  __/| (__ | |_ | || (_) || | | |
// \/     |_|    \___/  _/ | \___| \___| \__||_| \___/ |_| |_|
//                     |__/                                   

extern unsigned char projOptions;
extern unsigned char glNbVertices;

extern unsigned char points2aH[];
extern unsigned char points2aV[];
extern unsigned char points2dH[];
extern unsigned char points2dL[];



extern unsigned char zbuffer[];  // z-depth buffer SCREEN_WIDTH * SCREEN_HEIGHT
extern char          fbuffer[];  // frame buffer SCREEN_WIDTH * SCREEN_HEIGHT


// void glInitScreenBuffers(){}
// void glInitScreenBuffers() {

//     memset(zbuffer, 0xFF, SCREEN_WIDTH * SCREEN_HEIGHT);
    
//     memset(fbuffer, 0x20, SCREEN_WIDTH * SCREEN_HEIGHT);  // Space

// }

extern unsigned char isFace2BeDrawn;
extern unsigned char idxPt1, idxPt2, idxPt3;
extern signed char P1AH, P1AV, P2AH, P2AV, P3AH, P3AV;
extern signed char P1X, P1Y, P2X, P2Y, P3X, P3Y;
extern char        ch2disp;
extern int           dmoy; 
extern unsigned char distseg;
extern unsigned char  distface;

extern signed char A1X;
extern signed char A1Y;
extern signed char A1destX;
extern signed char A1destY;
extern signed char A1dX;
extern signed char A1dY;
extern signed char A1err;
extern signed char A1sX;
extern signed char A1sY;
extern char        A1arrived;

extern signed char A2X;
extern signed char A2Y;
extern signed char A2destX;
extern signed char A2destY;
extern signed char A2dX;
extern signed char A2dY;
extern signed char A2err;
extern signed char A2sX;
extern signed char A2sY;
extern char        A2arrived;
extern unsigned char A1Right;

extern signed char pDepX;
extern signed char pDepY;
extern signed char pArr1X;
extern signed char pArr1Y;
extern signed char pArr2X;
extern signed char pArr2Y;

extern signed char mDeltaY1, mDeltaX1, mDeltaY2, mDeltaX2;
extern unsigned char log2_tab[];
extern    unsigned char m1, m2, m3;
extern    unsigned char v1, v2, v3;
extern    unsigned char isFace2BeDrawn;

extern unsigned char lineIndex;
extern unsigned char departX;
extern unsigned char finX;
extern signed char hLineLength;

extern unsigned char A1Right;
extern unsigned char A1XSatur;
extern unsigned char A2XSatur;


extern int PointX, PointY, PointZ;
extern signed char ResX, ResY;

void hzfill() {
//     signed char dx, fx;
//     signed char nbpoints;
    char*          ptrFbuf;
    unsigned char* ptrZbuf;

//     printf ("A1Right=%d A1XSatur=%d A2XSatur=%d \n", A1Right, A1XSatur, A2XSatur);waitkey();
    lineIndex = A1Y;
    if (A1Right != 0) {
        if (A2XSatur != 0){
            departX = 0;

        } else {
            departX = A2X;
        }

        if (A1XSatur != 0){
           finX = SCREEN_WIDTH - 1;     
        } else {
           finX = A1X;   
        }

        
    } else {
        if (A1XSatur != 0) {
	    departX = 0;
        } else {
            departX = A1X;
        }

        if (A2XSatur !=0){
                finX = SCREEN_WIDTH - 1;
        } else {
                finX = A2X;
        }
    }
//     printf ("finX=%d, departX=%d \n", finX , departX);waitkey();
    hLineLength = finX - departX;
    if (hLineLength < 0) return;
    
    ptrZbuf = zbuffer + lineIndex * SCREEN_WIDTH + departX;
    ptrFbuf = fbuffer + lineIndex * SCREEN_WIDTH + departX;
    
    
    while (hLineLength > 0) {
        // printf ("hLineLength=%d \n", hLineLength);waitkey();
        if (distface < ptrZbuf[hLineLength]) {
                ptrFbuf[hLineLength] = ch2disp;
                ptrZbuf[hLineLength] = distface;
        }
        hLineLength --;
    }

}


void A1stepY() {
    signed char nxtY, e2;
    nxtY = A1Y + A1sY;
    //printf ("nxtY = %d\n", nxtY);
    e2 = (A1err < 0) ? (
                           ((A1err & 0x40) == 0) ? (
                                                       0x80)
                                                 : (
                                                       A1err << 1))
                     : (
                           ((A1err & 0x40) != 0) ? (
                                                       0x7F)
                                                 : (
                                                       A1err << 1));
    //printf ("e2 = %d\n", e2);
    while ((A1arrived == 0) && ((e2 > A1dX) || (A1Y != nxtY))) {
        if (e2 >= A1dY) {
            A1err += A1dY;
            //printf ("A1err = %d\n", A1err);
            A1X += A1sX;
            //printf ("A1X = %d\n", A1X);
        }
        if (e2 <= A1dX) {
            A1err += A1dX;
            //printf ("A1err = %d\n", A1err);
            A1Y += A1sY;
            //printf ("A1Y = %d\n", A1Y);
        }
        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
        e2        = (A1err < 0) ? (
                               ((A1err & 0x40) == 0) ? (
                                                           0x80)
                                                     : (
                                                           A1err << 1))
                         : (
                               ((A1err & 0x40) != 0) ? (
                                                           0x7F)
                                                     : (
                                                           A1err << 1));
        //printf ("e2 = %d\n", e2);
    }
}

void A2stepY() {
    signed char nxtY, e2;
    nxtY = A2Y + A2sY;
    e2   = (A2err < 0) ? (
                           ((A2err & 0x40) == 0) ? (
                                                       0x80)
                                                 : (
                                                       A2err << 1))
                     : (
                           ((A2err & 0x40) != 0) ? (
                                                       0x7F)
                                                 : (
                                                       A2err << 1));
    while ((A2arrived == 0) && ((e2 > A2dX) || (A2Y != nxtY))) {
        if (e2 >= A2dY) {
            A2err += A2dY;
            A2X += A2sX;
        }
        if (e2 <= A2dX) {
            A2err += A2dX;
            A2Y += A2sY;
        }
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
        e2        = (A2err < 0) ? (
                               ((A2err & 0x40) == 0) ? (
                                                           0x80)
                                                     : (
                                                           A2err << 1))
                         : (
                               ((A2err & 0x40) != 0) ? (
                                                           0x7F)
                                                     : (
                                                           A2err << 1));
    }
}

void initSatur_A1Right() {
    if (A1X > SCREEN_WIDTH - 1) {
        A1XSatur = 1;
    } else if (A1X == SCREEN_WIDTH - 1) {
        if (A1sX == 1) {
            A1XSatur = 1;
        } else {
            A1XSatur = 0;
        }
    } else {
        A1XSatur = 0;
    }

    if (A2X < 0) {
        A2XSatur = 1;
    } 
    else if (A2X == 0) {
        
        if (A2sX == 1) {
            A2XSatur = 0;
        } else {
            A2XSatur = 1;
        }

    } else {
        A2XSatur = 0;
    }
}
void initSatur_A1Left() {
    if (A2X > SCREEN_WIDTH - 1) {
        A2XSatur = 1;
    } else if (A2X == SCREEN_WIDTH - 1) {
        if (A2sX == 1){
            A2XSatur = 1;
        } else {
            A2XSatur = 0;
        }
    } else {
        A2XSatur = 0;
    }

    if (A1X < 0) {
        A1XSatur = 1;
    } else if (A1X == 0) {
        if (A1sX == 1){
            A1XSatur = 0;
        } else {
            A1XSatur = 1;
        }
    } else {
        A1XSatur = 0;
    }
}

#ifdef USE_C_SWITCHA1XSATUR
void switch_A1XSatur(){
    if (A1XSatur == 0) {
        A1XSatur = 1;
    } else {
        A1XSatur = 0;
    }
}
#else
extern void switch_A1XSatur();
#endif

#ifdef USE_C_SWITCHA2XSATUR
void switch_A2XSatur(){
    if (A2XSatur == 0) {
        A2XSatur = 1;
    } else {
        A2XSatur = 0;
    }
}
#else
extern void switch_A2XSatur();
#endif

void A1stepY_A1Right() {
    signed char nxtY, e2;
    nxtY = A1Y + A1sY;
    //printf ("nxtY = %d\n", nxtY);
    e2 = (A1err < 0) ? (
                           ((A1err & 0x40) == 0) ? (
                                                       0x80)
                                                 : (
                                                       A1err << 1))
                     : (
                           ((A1err & 0x40) != 0) ? (
                                                       0x7F)
                                                 : (
                                                       A1err << 1));
    //printf ("e2 = %d\n", e2);
    while ((A1arrived == 0) && ((e2 > A1dX) || (A1Y != nxtY))) {
        if (e2 >= A1dY) {
            A1err += A1dY;
            //printf ("A1err = %d\n", A1err);
            A1X += A1sX;
            //printf ("A1X = %d\n", A1X);
            if (A1X == SCREEN_WIDTH - 1){
                switch_A1XSatur();
            }
        }
        if (e2 <= A1dX) {
            A1err += A1dX;
            //printf ("A1err = %d\n", A1err);
            A1Y += A1sY;
            //printf ("A1Y = %d\n", A1Y);
        }
        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
        e2        = (A1err < 0) ? (
                               ((A1err & 0x40) == 0) ? (
                                                           0x80)
                                                     : (
                                                           A1err << 1))
                         : (
                               ((A1err & 0x40) != 0) ? (
                                                           0x7F)
                                                     : (
                                                           A1err << 1));
        //printf ("e2 = %d\n", e2);
    }
}

void A2stepY_A1Right() {
    signed char nxtY, e2;
    nxtY = A2Y + A2sY;
    e2   = (A2err < 0) ? (
                           ((A2err & 0x40) == 0) ? (
                                                       0x80)
                                                 : (
                                                       A2err << 1))
                     : (
                           ((A2err & 0x40) != 0) ? (
                                                       0x7F)
                                                 : (
                                                       A2err << 1));
    while ((A2arrived == 0) && ((e2 > A2dX) || (A2Y != nxtY))) {
        if (e2 >= A2dY) {
            A2err += A2dY;
            A2X += A2sX;

            if (A2X == 0){

                switch_A2XSatur();
            }
        }
        if (e2 <= A2dX) {
            A2err += A2dX;
            A2Y += A2sY;
        }
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
        e2        = (A2err < 0) ? (
                               ((A2err & 0x40) == 0) ? (
                                                           0x80)
                                                     : (
                                                           A2err << 1))
                         : (
                               ((A2err & 0x40) != 0) ? (
                                                           0x7F)
                                                     : (
                                                           A2err << 1));
    }
}

void A1stepY_A1Left() {
    signed char nxtY, e2;
    nxtY = A1Y + A1sY;
    //printf ("nxtY = %d\n", nxtY);
    e2 = (A1err < 0) ? (
                           ((A1err & 0x40) == 0) ? (
                                                       0x80)
                                                 : (
                                                       A1err << 1))
                     : (
                           ((A1err & 0x40) != 0) ? (
                                                       0x7F)
                                                 : (
                                                       A1err << 1));
    //printf ("e2 = %d\n", e2);
    while ((A1arrived == 0) && ((e2 > A1dX) || (A1Y != nxtY))) {
        if (e2 >= A1dY) {
            A1err += A1dY;
            //printf ("A1err = %d\n", A1err);
            A1X += A1sX;
            if (A1X == 0){
                switch_A1XSatur();
            }
            //printf ("A1X = %d\n", A1X);
        }
        if (e2 <= A1dX) {
            A1err += A1dX;
            //printf ("A1err = %d\n", A1err);
            A1Y += A1sY;
            //printf ("A1Y = %d\n", A1Y);
        }
        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;
        e2        = (A1err < 0) ? (
                               ((A1err & 0x40) == 0) ? (
                                                           0x80)
                                                     : (
                                                           A1err << 1))
                         : (
                               ((A1err & 0x40) != 0) ? (
                                                           0x7F)
                                                     : (
                                                           A1err << 1));
        //printf ("e2 = %d\n", e2);
    }
}

void A2stepY_A1Left() {
    signed char nxtY, e2;
    nxtY = A2Y + A2sY;
    e2   = (A2err < 0) ? (
                           ((A2err & 0x40) == 0) ? (
                                                       0x80)
                                                 : (
                                                       A2err << 1))
                     : (
                           ((A2err & 0x40) != 0) ? (
                                                       0x7F)
                                                 : (
                                                       A2err << 1));
    while ((A2arrived == 0) && ((e2 > A2dX) || (A2Y != nxtY))) {
        if (e2 >= A2dY) {
            A2err += A2dY;
            A2X += A2sX;
            if (A2X == SCREEN_WIDTH - 1){
                switch_A2XSatur();
            }
        }
        if (e2 <= A2dX) {
            A2err += A2dX;
            A2Y += A2sY;
        }
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;
        e2        = (A2err < 0) ? (
                               ((A2err & 0x40) == 0) ? (
                                                           0x80)
                                                     : (
                                                           A2err << 1))
                         : (
                               ((A2err & 0x40) != 0) ? (
                                                           0x7F)
                                                     : (
                                                           A2err << 1));
    }
}



void reachScreen(){
        while ((A1Y >= SCREEN_HEIGHT)  && (A1arrived == 0)){ 

            A1stepY();
            A2stepY();
        }
}
void bresStepType1() {
    // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
    reachScreen ();
    // A1Right = (A1X > A2X); 

    
    if (A1Right == 0) {
        initSatur_A1Left ();
        // printf ("bt1 A1L (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
        hzfill();
        while ((A1arrived == 0) && (A1Y > 1)){
            A1stepY_A1Left();
            A2stepY_A1Left();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            // printf ("bt1 A1L (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
            hzfill();
        }
    } else {
        initSatur_A1Right ();
        // printf ("bt1 A1R (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
        hzfill();
        while ((A1arrived == 0) && (A1Y > 1)){
            A1stepY_A1Right();
            A2stepY_A1Right();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            // printf ("bt1 A1R (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
            hzfill();
        }
    }
}
void bresStepType2() {

    if (A1Right == 0) {
        initSatur_A1Left ();
        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1)) {
            A1stepY_A1Left();
            A2stepY_A1Left();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            // printf ("bt2 A1L (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
            hzfill();
        }
    } else {
        initSatur_A1Right ();
        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1)){
            A1stepY_A1Right();
            A2stepY_A1Right();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            // printf ("bt2 A1R (%d: %d, %d) = A1XSatur=%d A2XSatur=%d\n", A1X, A2X, A1Y, A1XSatur, A2XSatur); get();
            hzfill();
        }
    }

}
void bresStepType3() {

        // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); waitkey();

    reachScreen ();

    // A1Right = (A1X > A2X); 
    if (A1Right == 0) {
        initSatur_A1Left ();
        hzfill();
        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1) ) {
            A1stepY_A1Left();
            A2stepY_A1Left();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); waitkey();
            // A1Right = (A1X > A2X); 
            hzfill();
        }
    } else {
        initSatur_A1Right ();
        hzfill();
        while ((A1arrived == 0) && (A2arrived == 0) && (A1Y > 1) ) {
            A1stepY_A1Right();
            A2stepY_A1Right();
            // printf ("hf (%d: %d, %d) = %d %d\n", A1X, A2X, A1Y, distface, ch2disp); get();
            // A1Right = (A1X > A2X); 
            hzfill();
        }
    }
}

#ifdef USE_C_ISA1RIGHT1
void isA1Right1 (){
    
    A1Right = 0;
//  log2_tab[];
    if ((mDeltaX1 & 0x80) == 0){
        
        if ((mDeltaX2 & 0x80) == 0){
            // printf ("%d*%d  %d*%d ", mDeltaY1, mDeltaX2, mDeltaY2,mDeltaX1);get ();
            A1Right = ((log2_tab[mDeltaX2] + log2_tab[mDeltaY1])/2) > ((log2_tab[mDeltaX1] + log2_tab[mDeltaY2])/2);
            // A1Right = mDeltaY1*mDeltaX2 > mDeltaY2*mDeltaX1;
        } else {
            A1Right = 0 ; // (mDeltaX1 < 0) 
        }
    } else {
        if ((mDeltaX2 & 0x80) == 0){
            A1Right = 1 ; // (mDeltaX1 < 0)
        } else {
            // printf ("%d*%d  %d*%d ", mDeltaY1, -mDeltaX2, mDeltaY2,-mDeltaX1);get ();
            A1Right = ((log2_tab[abs(mDeltaX2)] + log2_tab[mDeltaY1])/2) < ((log2_tab[abs(mDeltaX1)] + log2_tab[mDeltaY2])/2);
        }
    }
}
#else
extern void isA1Right1 ();
#endif //USE_C_ISA1RIGHT1


#ifdef USE_C_ISA1RIGHT3
void isA1Right3 (){
 A1Right = (A1X > A2X);
}
#else
extern void isA1Right3 ();
#endif //USE_C_ISA1RIGHT3

// #define USE_C_PREPAREBRESRUN
#ifdef USE_C_PREPAREBRESRUN
void prepare_bresrun() {
    if (P1Y <= P2Y) {
        if (P2Y <= P3Y) {
            pDepX  = P3X;
            pDepY  = P3Y;
            pArr1X = P2X;
            pArr1Y = P2Y;
            pArr2X = P1X;
            pArr2Y = P1Y;
        } else {
            pDepX = P2X;
            pDepY = P2Y;
            if (P1Y <= P3Y) {
                pArr1X = P3X;
                pArr1Y = P3Y;
                pArr2X = P1X;
                pArr2Y = P1Y;
            } else {
                pArr1X = P1X;
                pArr1Y = P1Y;
                pArr2X = P3X;
                pArr2Y = P3Y;
            }
        }
    } else {
        if (P1Y <= P3Y) {
            pDepX  = P3X;
            pDepY  = P3Y;
            pArr1X = P1X;
            pArr1Y = P1Y;
            pArr2X = P2X;
            pArr2Y = P2Y;
        } else {
            pDepX = P1X;
            pDepY = P1Y;
            if (P2Y <= P3Y) {
                pArr1X = P3X;
                pArr1Y = P3Y;
                pArr2X = P2X;
                pArr2Y = P2Y;
            } else {
                pArr1X = P2X;
                pArr1Y = P2Y;
                pArr2X = P3X;
                pArr2Y = P3Y;
            }
        }
    }
}
#else
extern void prepare_bresrun();
#endif // USE_C_PREPAREBRESRUN

#define USE_C_ANGLE2SCREEN
#ifdef USE_C_ANGLE2SCREEN
void angle2screen() {
    P1X = (SCREEN_WIDTH - P1AH) >> 1;
    P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
    P2X = (SCREEN_WIDTH - P2AH) >> 1;
    P2Y = (SCREEN_HEIGHT - P2AV) >> 1;
    P3X = (SCREEN_WIDTH - P3AH) >> 1;
    P3Y = (SCREEN_HEIGHT - P3AV) >> 1;
}
#else
extern void angle2screen();
#endif // USE_C_ANGLE2SCREEN


void fill8() {

    prepare_bresrun();

    // printf ("Dep = [%d, %d], Arr1 = [%d, %d], Arr2= [%d, %d]\n", pDepX,pDepY, pArr1X, pArr1Y, pArr2X, pArr2Y);get();
    if (pDepY != pArr1Y) {
        //a1 = bres_agent(pDep[0],pDep[1],pArr1[0],pArr1[1])
        //a2 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        A1X     = pDepX;
        A2X     = pDepX;
        A1Y     = pDepY;
        A2Y     = pDepY;

        A1destX = pArr1X;
        A1destY = pArr1Y;
        A1dX    = abs(A1destX - A1X);
        A1dY    = -abs(A1destY - A1Y);
        A1err   = A1dX + A1dY;
        if ((A1err > 64) || (A1err < -63))
            return;
        A1sX      = (A1X < A1destX) ? 1 : -1;
        A1sY      = (A1Y < A1destY) ? 1 : -1;
        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;

        A2destX = pArr2X;
        A2destY = pArr2Y;
        A2dX    = abs(A2destX - A2X);
        A2dY    = -abs(A2destY - A2Y);
        A2err   = A2dX + A2dY;
        if ((A2err > 64) || (A2err < -63))
            return;

        A2sX      = (A2X < A2destX) ? 1 : -1;
        A2sY      = (A2Y < A2destY) ? 1 : -1;
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;

        mDeltaY1 = (A1Y - A1destY);
        mDeltaX1 = (A1X - A1destX );
        mDeltaY2= (A2Y - A2destY);
        mDeltaX2 = (A2X - A2destX);

        isA1Right1 ();

        bresStepType1();

        A1X       = pArr1X;
        A1Y       = pArr1Y;
        A1destX   = pArr2X;
        A1destY   = pArr2Y;
        A1dX      = abs(A1destX - A1X);
        A1dY      = -abs(A1destY - A1Y);
        A1err     = A1dX + A1dY;
        A1sX      = (A1X < A1destX) ? 1 : -1;
        A1sY      = (A1Y < A1destY) ? 1 : -1;
        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;

        bresStepType2();
    } else {
        // a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        A1X     = pDepX;
        A1Y     = pDepY;
        A1destX = pArr2X;
        A1destY = pArr2Y;
        A1dX    = abs(A1destX - A1X);
        A1dY    = -abs(A1destY - A1Y);
        A1err   = A1dX + A1dY;

        if ((A1err > 64) || (A1err < -63))
            return;

        A1sX = (A1X < A1destX) ? 1 : -1;
        A1sY = (A1Y < A1destY) ? 1 : -1;

        A1arrived = ((A1X == A1destX) && (A1Y == A1destY)) ? 1 : 0;

        // a2 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
        A2X     = pArr1X;
        A2Y     = pArr1Y;
        A2destX = pArr2X;
        A2destY = pArr2Y;
        A2dX    = abs(A2destX - A2X);
        A2dY    = -abs(A2destY - A2Y);
        A2err   = A2dX + A2dY;

        if ((A2err > 64) || (A2err < -63))
            return;

        A2sX      = (A2X < A2destX) ? 1 : -1;
        A2sY      = (A2Y < A2destY) ? 1 : -1;
        A2arrived = ((A2X == A2destX) && (A2Y == A2destY)) ? 1 : 0;

        isA1Right3();
        bresStepType3() ;
    }
}
void fillFace() {
    angle2screen();
    fill8();
}

void guessIfFace2BeDrawn () {

    m1 = P1AH & ANGLE_MAX;
    m2 = P2AH & ANGLE_MAX;
    m3 = P3AH & ANGLE_MAX;
    v1 = P1AH & ANGLE_VIEW;
    v2 = P2AH & ANGLE_VIEW;
    v3 = P3AH & ANGLE_VIEW;

    isFace2BeDrawn = 0;
    if ((m1 == 0x00) || (m1 == ANGLE_MAX)) {
        if ((v1 == 0x00) || (v1 == ANGLE_VIEW)) {
            if (
                (
                    (P1AH & 0x80) != (P2AH & 0x80)) ||
                ((P1AH & 0x80) != (P3AH & 0x80))) {
                if ((abs(P3AH) < 127 - abs(P1AH))) {
                    isFace2BeDrawn=1;
                }
            } else {
                isFace2BeDrawn=1;
            }
        } else {
            // P1 FRONT
            if ((m2 == 0x00) || (m2 == ANGLE_MAX)) {
                // P2 FRONT
                if ((m3 == 0x00) || (m3 == ANGLE_MAX)) {
                    // P3 FRONT
                    // _4_
                    if (((P1AH & 0x80) != (P2AH & 0x80)) || ((P1AH & 0x80) != (P3AH & 0x80))) {
                        isFace2BeDrawn=1;
                    } else {
                        // nothing to do
                    }
                } else {
                    // P3 BACK
                    // _3_
                    if ((P1AH & 0x80) != (P2AH & 0x80)) {
                        if (abs(P2AH) < 127 - abs(P1AH)) {
                            isFace2BeDrawn=1;
                        }
                    } else {
                        if ((P1AH & 0x80) != (P3AH & 0x80)) {
                            if (abs(P3AH) < 127 - abs(P1AH)) {
                                isFace2BeDrawn=1;
                            }
                        }
                    }

                    if ((P1AH & 0x80) != (P3AH & 0x80)) {
                        if (abs(P3AH) < 127 - abs(P1AH)) {
                            isFace2BeDrawn=1;
                        }
                    }
                }
            } else {
                // P2 BACK
                // _2_ nothing to do
                if ((P1AH & 0x80) != (P2AH & 0x80)) {
                    if (abs(P2AH) < 127 - abs(P1AH)) {
                        isFace2BeDrawn=1;
                    }
                } else {
                    if ((P1AH & 0x80) != (P3AH & 0x80)) {
                        if (abs(P3AH) < 127 - abs(P1AH)) {
                            isFace2BeDrawn=1;
                        }
                    }
                }

                if ((P1AH & 0x80) != (P3AH & 0x80)) {
                    if (abs(P3AH) < 127 - abs(P1AH)) {
                        isFace2BeDrawn=1;
                    }
                }
            }
        }
    } else {
        // P1 BACK
        // _1_ nothing to do
    }
}


#ifdef USE_C_SORTPOINTS
void sortPoints(){
    signed char   tmpH, tmpV;
    if (abs(P2AH) < abs(P1AH)) {
        tmpH = P1AH;
        tmpV = P1AV;
        P1AH = P2AH;
        P1AV = P2AV;
        P2AH = tmpH;
        P2AV = tmpV;
    }
    if (abs(P3AH) < abs(P1AH)) {
        tmpH = P1AH;
        tmpV = P1AV;
        P1AH = P3AH;
        P1AV = P3AV;
        P3AH = tmpH;
        P3AV = tmpV;
    }
    if (abs(P3AH) < abs(P2AH)) {
        tmpH = P2AH;
        tmpV = P2AV;
        P2AH = P3AH;
        P2AV = P3AV;
        P3AH = tmpH;
        P3AV = tmpV;
    }
}
#else
extern void sortPoints();
#endif

#ifdef USE_C_RETRIEVEFACEDATA
void retrieveFaceData(){

        // printf ("face %d : %d %d %d\n",ii, idxPt1, idxPt2, idxPt3);get();
        dmoy = points2dL[idxPt1]; //*((int*)(points2d + offPt1 + 2));
        P1AH = points2aH[idxPt1];
        P1AV = points2aV[idxPt1];

        dmoy += points2dL[idxPt2]; //*((int*)(points2d + offPt2 + 2));
        P2AH = points2aH[idxPt2];
        P2AV = points2aV[idxPt2];

        dmoy +=  points2dL[idxPt3]; //*((int*)(points2d + offPt3 + 2));
        P3AH = points2aH[idxPt3];
        P3AV = points2aV[idxPt3];

        // printf ("dis %d %d %d\n",d1, d2, d3);get();
        dmoy = dmoy / 3;
        if (dmoy >= 256) {
            dmoy = 256;
        }
        distface = (unsigned char)(dmoy & 0x00FF);

        // printf ("disface %d %d\n",dmoy, distface);get();

}
#else
extern void retrieveFaceData();
#endif // USE_C_RETRIEVEFACEDATA

void glDrawFaces() {
    unsigned char ii = 0;

    // printf ("%d Points, %d Segments, %d Faces\n", glNbVertices, glNbSegments, glNbFaces); get();
    for (ii = 0; ii < glNbFaces; ii++) {

        idxPt1 = glFacesPt1[ii] ;
        idxPt2 = glFacesPt2[ii] ;
        idxPt3 = glFacesPt3[ii] ;
        ch2disp = glFacesChar[ii];

        retrieveFaceData();

        // printf ("P1 [%d, %d], P2 [%d, %d], P3 [%d %d]\n", P1AH, P1AV, P2AH, P2AV,  P3AH, P3AV); get();

        sortPoints();

        // printf ("AHs [%d, %d, %d] [%x, %x], %x], %x, %x, %x]\n", P1AH, P2AH, P3AH, m1, m2, m3, v1,v2,v3);get();
        guessIfFace2BeDrawn();

        if (isFace2BeDrawn) {

            fillFace();

        }
    }

}


// #define USE_C_GLZPLOT
#ifdef USE_C_GLZPLOT
void glZPlot(signed char X,
           signed char Y,
           unsigned char dist,
           char          char2disp) {
    int            offset;
    char*          ptrFbuf;
    unsigned char* ptrZbuf;

    if ((Y <= 0) || (Y >= SCREEN_HEIGHT) || (X <= 0) || (X >= SCREEN_WIDTH))
        return;

#ifdef USE_MULTI40
    offset = multi40[Y] + X;  // 
#else
    offset = Y*SCREEN_WIDTH+X; 
#endif

    ptrZbuf = zbuffer + offset;
    ptrFbuf = fbuffer + offset;

    // printf ("pl [%d %d] zbuff = %d , pointDist = %d\n", X, Y, *ptrZbuf, dist);
    if (dist < *ptrZbuf) {
        *ptrFbuf = char2disp;
        *ptrZbuf = dist;
    }
}
#endif // USE_C_GLZPLOT


void lrDrawLine() {

    signed char e2;
    char        ch2dsp;

    A1X     = P1X;
    A1Y     = P1Y;
    A1destX = P2X;
    A1destY = P2Y;
    A1dX    = abs(P2X - P1X);
    A1dY    = -abs(P2Y - P1Y);
    A1sX    = P1X < P2X ? 1 : -1;
    A1sY    = P1Y < P2Y ? 1 : -1;
    A1err   = A1dX + A1dY;

    if ((A1err > 64) || (A1err < -63))
        return;

    if ((ch2disp == '/') && (A1sX == -1)) {
        ch2dsp = DOLLAR;
    } else {
        ch2dsp = ch2disp;
    }

    while (1) {  // loop
        // printf ("plot [%d, %d] %d %d\n", A1X, A1Y, distseg, ch2disp); cgetc ();          
        glZPlot(A1X, A1Y, distseg, ch2dsp);
        if ((A1X == A1destX) && (A1Y == A1destY))
            break;
        //e2 = 2*err;
        e2 = (A1err < 0) ? (
                ((A1err & 0x40) == 0) ? (
                                                0x80)
                                        : (
                                            A1err << 1))
            : (
                ((A1err & 0x40) != 0) ? (
                                                0x7F)
                                        : (
                                                A1err << 1));
        if (e2 >= A1dY) {
            A1err += A1dY;  // e_xy+e_x > 0
            A1X += A1sX;
        }
        if (e2 <= A1dX) {  // e_xy+e_y < 0
            A1err += A1dX;
            A1Y += A1sY;
        }
    }
}

void glDrawSegments(){
    unsigned char ii = 0;
 
    for (ii = 0; ii < glNbSegments; ii++) {

        idxPt1    = glSegmentsPt1[ii];
        idxPt2    = glSegmentsPt2[ii];
        ch2disp = glSegmentsChar[ii];

        // dmoy = (d1+d2)/2;

        P1AH = points2aH[idxPt1];
        P1AV = points2aV[idxPt1];

        dmoy = points2dL[idxPt1];


        P2AH = points2aH[idxPt2];
        P2AV = points2aV[idxPt2];

        dmoy += points2dL[idxPt2];

        dmoy = dmoy >> 1;
        

        if ((dmoy & 0xFF00) != 0)
            continue;
        distseg = (unsigned char)((dmoy)&0x00FF);
        distseg--;  // FIXME

        P1X = (SCREEN_WIDTH - P1AH) >> 1;
        P1Y = (SCREEN_HEIGHT - P1AV) >> 1;
        P2X = (SCREEN_WIDTH - P2AH) >> 1;
        P2Y = (SCREEN_HEIGHT - P2AV) >> 1;

        // printf ("dl ([%d, %d] , [%d, %d] => %d c=%d\n", P1X, P1Y, P2X, P2Y, distseg, ch2disp); waitkey();
        lrDrawLine();
    }

}

#ifdef USE_C_GLDRAWPARTICLES
void glDrawParticules(){
    unsigned char ii;
    unsigned char idxPt;
    for (ii = 0; ii < glNbParticles; ii++) {
        idxPt    = glParticlesPt[ii];
        glZPlot(
            (SCREEN_WIDTH -points2aH[idxPt]) >> 1,      // PX
            (SCREEN_HEIGHT - points2aV[idxPt]) >> 1,    // PY
            points2dL[idxPt]-2,                         // distance
            glParticlesChar[ii]                          // character 2 display
        );
    }
};
#endif

#ifdef USE_C_GLBUFFER2SCREEN
void glBuffer2Screen() {
    memcpy((void*)ADR_BASE_LORES_SCREEN, fbuffer, SCREEN_HEIGHT* SCREEN_WIDTH);
}
#endif
