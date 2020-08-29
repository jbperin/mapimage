#-------------------------------------------------------------------------------
# Name:        module2
# Purpose:
#
# Author:      catineau
#
# Created:     13/08/2019
# Copyright:   (c) catineau 2019
# Licence:     <your licence>
#-------------------------------------------------------------------------------


from tkinter import *
from tkinter import messagebox
from PIL import Image
import os

# from example import gng, gng2

HiresPixelPerByte=6

HiresScreenWidth=240
HiresScreenHeight=200

zoomfactor=2

OricViewDefaultScreenSizeX      = HiresScreenWidth*zoomfactor
OricViewDefaultScreenSizeY      = HiresScreenHeight*zoomfactor

CHANGE_INK_TO_BLACK	            = 0		
CHANGE_INK_TO_RED	            = 1		
CHANGE_INK_TO_GREEN	            = 2		
CHANGE_INK_TO_YELLOW	        = 3		
CHANGE_INK_TO_BLUE	            = 4		
CHANGE_INK_TO_MAGENTA           = 5			
CHANGE_INK_TO_CYAN	            = 6		
CHANGE_INK_TO_WHITE	            = 7	

USE_STANDARD_CHARSET    	                    = 8		
USE_ALTERNATE_CHARSET	                        = 9		
USE_DOUBLE_SIZE_STANDARD_CHARSET	            = 10		
USE_DOUBLE_SIZE_ALTERNATE_CHARSET	            = 11		
USE_DOUBLE_SIZE_BLINKING_STANDARD_CHARSET       = 12		
USE_DOUBLE_SIZE_BLINKING_ALTERNATE_CHARSET      = 13		
USE_BLINKING_STANDARD_CHARSET	                = 14		
USE_BLINKING_ALTERNATE_CHARSET	                = 15		
# // Change Paper (background) color	
CHANGE_PAPER_TO_BLACK			                = 16		
CHANGE_PAPER_TO_RED	                            = 17		
CHANGE_PAPER_TO_GREEN	                        = 18		
CHANGE_PAPER_TO_YELLOW	                        = 19		
CHANGE_PAPER_TO_BLUE	                        = 20		
CHANGE_PAPER_TO_MAGENTA	                        = 21		
CHANGE_PAPER_TO_CYAN	                        = 22		
CHANGE_PAPER_TO_WHITE	                        = 23		
# // Video control attributes	
SWITCH_TO_TEXT_MODE_60HZ		                = 24		
SWITCH_TO_TEXT_MODE_50HZ		                = 26		
SWITCH_TO_HIRES_MODE_60HZ	                    = 28		
SWITCH_TO_HIRES_MODE_50HZ                       = 30		


HIRES_SCREEN_ADDRESS                            = 0xA000
HIRES_MEM_LENGTH                                = 8000

SCREEN_WIDTH                    = 40
SCREEN_HEIGHT                   = 26

invertedColor = { 'black' : 'white',          # 0
                'red' : 'cyan',             # 1
                '#00FF00' : 'magenta',      # 2
                'yellow' : 'blue',          # 3
                'blue' : 'yellow',          # 4
                'magenta' : '#00FF00',      # 5
                'cyan' : 'red',             # 6
                'white' : 'black',          # 7

                8 : 'black',
                9 : 'black',
                10 : 'black',
                11 : 'black',
                12 : 'black',
                13 : 'black',
                14 : 'black',
                15 : 'black',

                'black': 'white',           # 16
                'red' : 'cyan',             # 17
                '#00FF00' : 'magenta',      # 18
                'yellow' : 'blue',          # 19
                'blue' : 'yellow',          # 20
                'magenta' : '#00FF00',      # 21
                'cyan' : 'red',             # 22
                'whtie' : 'black',          # 23
                24 : '', # 60 Hz TEXT display
                25 : '', # 60 Hz TEXT display
                26 : '', # 50 Hz TEXT display
                27 : '', # 50 Hz TEXT display
                28 : '', # 60 Hz HIRES display
                29 : '', # 60 Hz HIRES display
                30 : '', # 50 Hz HIRES display
                31 : '' # 50 Hz HIRES display
                }

colorFromByte = { 0 : 'black', # ink
                1 : 'red',
                2 : '#00FF00',
                3 : 'yellow',
                4 : 'blue',
                5 : 'magenta',
                6 : 'cyan',
                7 : 'white',

                8 : 'black',
                9 : 'black',
                10 : 'black',
                11 : 'black',
                12 : 'black',
                13 : 'black',
                14 : 'black',
                15 : 'black',

                16 : 'black', # paper
                17 : 'red',
                18 : '#00FF00',
                19 : 'yellow',
                20 : 'blue',
                21 : 'magenta',
                22 : 'cyan',
                23 : 'white',

                24 : '', # 60 Hz TEXT display
                25 : '', # 60 Hz TEXT display
                26 : '', # 50 Hz TEXT display
                27 : '', # 50 Hz TEXT display
                28 : '', # 60 Hz HIRES display
                29 : '', # 60 Hz HIRES display
                30 : '', # 50 Hz HIRES display
                31 : '', # 50 Hz HIRES display

                128 : 'white', # INVERTED ink
                129 : 'cyan',
                130 : 'magenta',
                131 : 'blue',
                132 : 'yellow',
                133 : '#00FF00',
                134 : 'red',
                135 : 'black',

                144 : 'white', # inverted paper
                145 : 'cyan',
                146 : 'magenta',
                147 : 'blue',
                148 : 'yellow',
                149 : '#00FF00',
                150 : 'red',
                151 : 'black',
                }


class Memory():
    def __init__ (self,):
        self.__ram__ = bytearray(8000)
        for i in range(0,8000):
            self.__ram__[i]= 0x40 # gng2[i]

    def getRam (self,):
        return (self.__ram__)

    def poke (self, address, value):
        if (address >= HIRES_SCREEN_ADDRESS) and (address < HIRES_SCREEN_ADDRESS + HIRES_MEM_LENGTH):
            self.__ram__[address-HIRES_SCREEN_ADDRESS] = value

    def peek (self, address):
        if (address >= HIRES_SCREEN_ADDRESS) and (address < HIRES_SCREEN_ADDRESS + HIRES_MEM_LENGTH):
            return self.__ram__[address-HIRES_SCREEN_ADDRESS]
        return None

    def memcpy(self, address, buffer, length):
        if (address >= HIRES_SCREEN_ADDRESS) and (address < HIRES_SCREEN_ADDRESS + HIRES_MEM_LENGTH):
            if (address+length < HIRES_SCREEN_ADDRESS + HIRES_MEM_LENGTH):
                adr =  address - HIRES_SCREEN_ADDRESS
                ii = 0
                while (adr < address- HIRES_SCREEN_ADDRESS +length ):
                    self.__ram__[adr] = buffer[ii]
                    ii = ii + 1
                    adr = adr + 1
            else:
                print ("ERROR out of bound writing")
        else:
            print ("ERROR in start address")
        

theMemory = None # Memory()


def loadTape():
    global theMemory
    l = 100
    c = 120
    pattern = 0b01101010
    hidx = c//6
    pidx = c%6
    theMemory.poke (HIRES_SCREEN_ADDRESS+l*SCREEN_WIDTH + hidx - 1, CHANGE_INK_TO_GREEN)
    cv = theMemory.peek (HIRES_SCREEN_ADDRESS+l*SCREEN_WIDTH + hidx);
    cv |= 0x20>>pidx;
    theMemory.poke (HIRES_SCREEN_ADDRESS+l*SCREEN_WIDTH + hidx, cv)
    theMemory.memcpy(HIRES_SCREEN_ADDRESS+l*SCREEN_WIDTH + hidx + 1, [pattern]*10, 4)
    DrawRam(img,theMemory.getRam())

def test():
    global theMemory

    filepath = "tools\logo.dat"

    file_length_in_bytes = os.path.getsize(filepath)

    print(f"Reading {file_length_in_bytes} from file {filepath}")

    with open(filepath, "rb") as binary_file:
        gng3 = binary_file.read()

    print ("Loading bytes in memory")
    ram = theMemory.getRam()
    for i in range(0,8000):
        ram[i] = gng3[i]
    print ("Refreshing Screen")
    DrawRam(img,ram)



# must use photoimage instead line or rectangle
# https://stackoverflow.com/questions/12284311/python-tkinter-how-to-work-with-pixels
# there are not comment because it make slow down program running with them

def DrawRam(img, ram):

    ramindex = 0
    
    for  Ycount in range(1,201):
        inkcolor = "white" # INK=White
        papercolor = "black"  # Paper=Black
        blinkmode = False;

        # 40 bytes by line
        for Xcount in range(1,41):
            attribut=False
            inversion=False
            saveinkcolorinversion=''
            savepapercolorinversion=''

            readByte = ram[ramindex]

            if (readByte & 0b10000000 ):
                inversion=True
                readByte=readByte-128

            if not(readByte & 0b01000000 ):attribut=True

            if (attribut):
                if ((readByte >= 0) and (readByte <= 7)):
                    inkcolor = colorFromByte.get(readByte)
                if ((readByte > 7) and (readByte <12)):
                    blinkmode = False;
                    if (savecolor!=""):inkcolor = savecolor;
                if ((readByte > 11) and (readByte <16)):
                    savecolor = inkcolor;
                    blinkmode = True;
                if ((readByte >= 16) and (readByte <= 23)):
                    papercolor = colorFromByte.get(readByte)

            if (inversion):
                saveinkcolorinversion=inkcolor
                savepapercolorinversion=papercolor
                inkcolor = invertedColor.get(inkcolor)
                papercolor = invertedColor.get(papercolor)

            if (blinkmode):
                if (blinktime == false):color = inkcolor;
                else:inkcolor = papercolor;

            calpos=((Xcount * HiresPixelPerByte)+ HiresPixelPerByte)

            x1= (calpos-5)-HiresPixelPerByte

            if ((readByte & (0b00000001<<5)) and not attribut): color=inkcolor
            else: color=papercolor

            can.create_rectangle(x1*zoomfactor,Ycount*zoomfactor,x1*zoomfactor,Ycount*zoomfactor,outline=color)

            x1= (calpos-4)-HiresPixelPerByte

            if ((readByte & (0b00000001<<4)) and not attribut): color=inkcolor
            else: color=papercolor

            can.create_rectangle(x1*zoomfactor,Ycount*zoomfactor,x1*zoomfactor,Ycount*zoomfactor,outline=color)

            x1= (calpos-3)-HiresPixelPerByte

            if ((readByte & (0b00000001<<3)) and not attribut): color=inkcolor
            else:color=papercolor

            can.create_rectangle(x1*zoomfactor,Ycount*zoomfactor,x1*zoomfactor,Ycount*zoomfactor,outline=color)

            x1= (calpos-2)-HiresPixelPerByte

            if ((readByte & (0b00000001<<2)) and not attribut):color=inkcolor
            else:color=papercolor

            can.create_rectangle(x1*zoomfactor,Ycount*zoomfactor,x1*zoomfactor,Ycount*zoomfactor,outline=color)

            x1= (calpos-1)-HiresPixelPerByte

            if ((readByte & (0b00000001<<1)) and not attribut):color=inkcolor
            else:color=papercolor

            can.create_rectangle(x1*zoomfactor,Ycount*zoomfactor,x1*zoomfactor,Ycount*zoomfactor,outline=color)

            x1= (calpos-0)-HiresPixelPerByte

            if ((readByte & (0b00000001<<0)) and not attribut):color=inkcolor
            else:color=papercolor

            can.create_rectangle(x1*zoomfactor,Ycount*zoomfactor,x1*zoomfactor,Ycount*zoomfactor,outline=color)

            if saveinkcolorinversion != '' : inkcolor=saveinkcolorinversion
            if savepapercolorinversion != '' : papercolor=savepapercolorinversion

            ramindex+=1


''' VALUE	EFFECT
Change Ink (foreground) color
0	Change INK to BLACK
1	Change INK to RED
2	Change INK to GREEN
3	Change INK to YELLOW
4	Change INK to BLUE
5	Change INK to MAGENTA
6	Change INK to CYAN
7	Change INK to WHITE
Character Set modifier
8	Use Standard Charset
9	Use Alternate Charset
10	Use Double Size Standard Charset
11	Use Double Size Alternate Charset
12	Use Blinking Standard Charset
13	Use Blinking Alternate Charset
14	Use Double Size Blinking Standard Charset
15	Use Double Size Blinking Alternate Charset
Change Paper (background) color
16	Change PAPER to BLACK
17	Change PAPER to RED
18	Change PAPER to GREEN
19	Change PAPER to YELLOW
20	Change PAPER to BLUE
21	Change PAPER to MAGENTA
22	Change PAPER to CYAN
23	Change PAPER to WHITE
Video control attributes
24	Switch to TEXT mode (60 Hz)
25
26	Switch to TEXT mode (50 Hz)
27
28	Switch to HIRES mode (60 Hz)
29
30	Switch to HIRES mode (50 Hz)
'''

def main():

    global img, can
    global theMemory

    print ("Creating Memory")
    theMemory = Memory()

    print ("Creating Windows")

    win=Tk()
    win.geometry(str(OricViewDefaultScreenSizeX+128)+"x"+str(OricViewDefaultScreenSizeY+128))
    win.title("Orixel")

    print ("Creating Canvas")
    can= Canvas(win,width=OricViewDefaultScreenSizeX,height=OricViewDefaultScreenSizeY,bg='blue')
    can.grid(column=1,row=1)
    can.pack()

    print ("Creating Image")

    img = PhotoImage(width=HiresScreenWidth, height=HiresScreenHeight)
    can.create_image((OricViewDefaultScreenSizeX/2, OricViewDefaultScreenSizeY/2), image=img, state="normal")
    can.image=img

    print ("Creating Buttons")

    boutonTapeLoad=Button(win, text="Tape Load", command=lambda:loadTape())
    boutonTapeLoad.pack()

    boutonTest=Button(win, text="Test", command=lambda:test())
    boutonTest.pack()


    print ("Initializing Screen")
    DrawRam(img, theMemory.getRam())

    print ("Starting Mainloop ..")
    win.mainloop()
    print ("Leaving ..")

if __name__ == '__main__':
    main()



# def IsBitSet(byte, bit):
#     return bool(byte & (0b00000001<<bit))
