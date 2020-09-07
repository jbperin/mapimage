


tabmult_A = [
    0, 1, 2, 3, 4, 5, 6, 7,
    8, 9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22, 23,
    24, 25, 26, 27, 28, 29, 30, 31,
    32, 33, 34, 35, 36, 37, 38, 39,
    40, 41, 42, 43, 44, 45, 46, 47,
    48, 49, 50, 51, 52, 53, 54, 55,
    56, 57, 58, 59, 60, 61, 62, 63,
    64, 65, 66, 67, 68, 69, 70, 71,
    72, 73, 74, 75, 76, 77, 78, 79,
    80, 81, 82, 83, 84, 85, 86, 87,
    88, 89, 90, 90, 91, 92, 93, 94,
    95, 96, 97, 98, 99, 100, 101, 102,
    103, 104, 105, 106, 107, 108, 109, 110,
    111, 112, 113, 114, 115, 116, 117, 118,
    119, 119, 120, 121, 122, 123, 124, 125
]
tabmult_B = [
    0, 0, 0, 0, 0, 1, 1, 1,
    1, 1, 1, 1, 2, 2, 2, 2,
    2, 3, 3, 3, 3, 3, 4, 4,
    4, 4, 4, 5, 5, 5, 6, 6,
    6, 6, 7, 7, 7, 7, 8, 8,
    8, 9, 9, 9, 10, 10, 10, 11,
    11, 11, 12, 12, 13, 13, 13, 14,
    14, 15, 15, 15, 16, 16, 17, 17,
    18, 18, 18, 19, 19, 20, 20, 21,
    21, 22, 22, 23, 23, 24, 24, 25,
    25, 26, 26, 27, 27, 28, 29, 29,
    30, 30, 31, 31, 32, 33, 33, 34,
    34, 35, 36, 36, 37, 38, 38, 39,
    39, 40, 41, 41, 42, 43, 44, 44,
    45, 46, 46, 47, 48, 48, 49, 50,
    51, 51, 52, 53, 54, 54, 55, 56
]
tabmult_C = [
    0, 0, 2, 3, 4, 5, 5, 6,
    7, 8, 8, 9, 10, 11, 12, 13,
    14, 14, 15, 16, 17, 18, 19, 19,
    20, 21, 22, 23, 24, 24, 25, 26,
    27, 28, 29, 30, 30, 31, 32, 33,
    34, 35, 35, 36, 37, 38, 39, 40,
    40, 41, 42, 43, 44, 44, 45, 46,
    47, 48, 49, 49, 50, 51, 52, 53,
    54, 54, 55, 56, 57, 58, 59, 59,
    60, 61, 62, 63, 63, 64, 65, 66,
    67, 68, 68, 69, 70, 71, 72, 72,
    73, 74, 75, 76, 76, 77, 78, 79,
    80, 80, 81, 82, 83, 84, 85, 85,
    86, 87, 88, 89, 89, 90, 91, 92,
    93, 93, 94, 95, 96, 97, 97, 98,
    99, 100, 101, 101, 102, 103, 104, 105
]
tabmult_D = [
    0, 1, 1, 1, 2, 2, 3, 4,
    4, 5, 5, 6, 7, 7, 8, 8,
    9, 9, 10, 10, 11, 11, 12, 13,
    13, 14, 14, 15, 15, 16, 17, 17,
    18, 18, 19, 19, 20, 20, 21, 22,
    22, 23, 23, 24, 24, 25, 26, 26,
    27, 27, 28, 28, 29, 30, 30, 31,
    31, 32, 33, 33, 34, 34, 35, 35,
    36, 37, 37, 38, 38, 39, 40, 40,
    41, 41, 42, 43, 43, 44, 44, 45,
    46, 46, 47, 47, 48, 49, 49, 50,
    50, 51, 52, 52, 53, 53, 54, 55,
    55, 56, 56, 57, 58, 58, 59, 59,
    60, 61, 61, 62, 63, 63, 64, 64,
    65, 66, 66, 67, 68, 68, 69, 69,
    70, 71, 71, 72, 73, 73, 74, 74
]

def norm (dx,dy):
    if (abs(dx)>=128 or abs(dy)>=128):
        ax, ay = abs(dx)//2, abs(dy)//2
        dividedBy2 = True
    else:
        ax, ay = abs(dx), abs(dy)
        dividedBy2 = False
    if ax >= ay:
        x, y = ax, ay
    else:
        x, y = ay, ax
    if y > x/2 :
        # N = (math.sqrt(5)-math.sqrt(2))*x + (2*math.sqrt(2) - math.sqrt(5))*y
        #N = tabmult_sqrt5_m_sqrt2 [x] + tabmult_2sqrt2_m_sqrt5[y]
        N = tabmult_C [x] + tabmult_D[y]
    else:
        # N = x+(math.sqrt(5)/2 - 1)*y
        #N = x + tabmult_sqrt5_m2 [y]
        N = tabmult_A [x] + tabmult_B[y]
    if dividedBy2:
        return 2*N
    else:
        return N


        ## atan(2^(x/32))*128/pi

atan_tab = [
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x01,0x01,0x01,
            0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
            0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
            0x01,0x01,0x01,0x01,0x01,0x01,0x01,0x01,
            0x01,0x01,0x01,0x01,0x01,0x02,0x02,0x02,
            0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,
            0x02,0x02,0x02,0x02,0x02,0x02,0x02,0x02,
            0x03,0x03,0x03,0x03,0x03,0x03,0x03,0x03,
            0x03,0x03,0x03,0x03,0x03,0x04,0x04,0x04,
            0x04,0x04,0x04,0x04,0x04,0x04,0x04,0x04,
            0x05,0x05,0x05,0x05,0x05,0x05,0x05,0x05,
            0x06,0x06,0x06,0x06,0x06,0x06,0x06,0x06,
            0x07,0x07,0x07,0x07,0x07,0x07,0x08,0x08,
            0x08,0x08,0x08,0x08,0x09,0x09,0x09,0x09,
            0x09,0x0a,0x0a,0x0a,0x0a,0x0b,0x0b,0x0b,
            0x0b,0x0c,0x0c,0x0c,0x0c,0x0d,0x0d,0x0d,
            0x0d,0x0e,0x0e,0x0e,0x0e,0x0f,0x0f,0x0f,
            0x10,0x10,0x10,0x11,0x11,0x11,0x12,0x12,
            0x12,0x13,0x13,0x13,0x14,0x14,0x15,0x15,
            0x15,0x16,0x16,0x17,0x17,0x17,0x18,0x18,
            0x19,0x19,0x19,0x1a,0x1a,0x1b,0x1b,0x1c,
            0x1c,0x1c,0x1d,0x1d,0x1e,0x1e,0x1f,0x1f
]

        ## log2(x)*32 

log2_tab = [
        0x00,0x00,0x20,0x32,0x40,0x4a,0x52,0x59,
        0x60,0x65,0x6a,0x6e,0x72,0x76,0x79,0x7d,
        0x80,0x82,0x85,0x87,0x8a,0x8c,0x8e,0x90,
        0x92,0x94,0x96,0x98,0x99,0x9b,0x9d,0x9e,
        0xa0,0xa1,0xa2,0xa4,0xa5,0xa6,0xa7,0xa9,
        0xaa,0xab,0xac,0xad,0xae,0xaf,0xb0,0xb1,
        0xb2,0xb3,0xb4,0xb5,0xb6,0xb7,0xb8,0xb9,
        0xb9,0xba,0xbb,0xbc,0xbd,0xbd,0xbe,0xbf,
        0xc0,0xc0,0xc1,0xc2,0xc2,0xc3,0xc4,0xc4,
        0xc5,0xc6,0xc6,0xc7,0xc7,0xc8,0xc9,0xc9,
        0xca,0xca,0xcb,0xcc,0xcc,0xcd,0xcd,0xce,
        0xce,0xcf,0xcf,0xd0,0xd0,0xd1,0xd1,0xd2,
        0xd2,0xd3,0xd3,0xd4,0xd4,0xd5,0xd5,0xd5,
        0xd6,0xd6,0xd7,0xd7,0xd8,0xd8,0xd9,0xd9,
        0xd9,0xda,0xda,0xdb,0xdb,0xdb,0xdc,0xdc,
        0xdd,0xdd,0xdd,0xde,0xde,0xde,0xdf,0xdf,
        0xdf,0xe0,0xe0,0xe1,0xe1,0xe1,0xe2,0xe2,
        0xe2,0xe3,0xe3,0xe3,0xe4,0xe4,0xe4,0xe5,
        0xe5,0xe5,0xe6,0xe6,0xe6,0xe7,0xe7,0xe7,
        0xe7,0xe8,0xe8,0xe8,0xe9,0xe9,0xe9,0xea,
        0xea,0xea,0xea,0xeb,0xeb,0xeb,0xec,0xec,
        0xec,0xec,0xed,0xed,0xed,0xed,0xee,0xee,
        0xee,0xee,0xef,0xef,0xef,0xef,0xf0,0xf0,
        0xf0,0xf1,0xf1,0xf1,0xf1,0xf1,0xf2,0xf2,
        0xf2,0xf2,0xf3,0xf3,0xf3,0xf3,0xf4,0xf4,
        0xf4,0xf4,0xf5,0xf5,0xf5,0xf5,0xf5,0xf6,
        0xf6,0xf6,0xf6,0xf7,0xf7,0xf7,0xf7,0xf7,
        0xf8,0xf8,0xf8,0xf8,0xf9,0xf9,0xf9,0xf9,
        0xf9,0xfa,0xfa,0xfa,0xfa,0xfa,0xfb,0xfb,
        0xfb,0xfb,0xfb,0xfc,0xfc,0xfc,0xfc,0xfc,
        0xfd,0xfd,0xfd,0xfd,0xfd,0xfd,0xfe,0xfe,
        0xfe,0xfe,0xfe,0xff,0xff,0xff,0xff,0xff
]

octant_adjust = [
        0b00111111, #        ;; x+,y+,|x|>|y|
        0b00000000, #        ;; x+,y+,|x|<|y|
        0b11000000, #        ;; x+,y-,|x|>|y|
        0b11111111, #        ;; x+,y-,|x|<|y|
        0b01000000, #        ;; x-,y+,|x|>|y|
        0b01111111, #        ;; x-,y+,|x|<|y|
        0b10111111, #        ;; x-,y-,|x|>|y|
        0b10000000, #        ;; x-,y-,|x|<|y|
]


import math
def oldatan2(dy, dx):

    x , y = dx, dy
    print (math.atan2(y,x)*127/math.pi)
    v = 255 - abs(log2_tab [x] - log2_tab[y])
    print (x, y , log2_tab[x]/32, log2_tab[y]/32, (log2_tab [x] - log2_tab[y])/16, v)
    print (atan_tab[v])
# int.from_bytes(b'\xff', byteorder='big', signed=True)

import struct

def atan2 (ty, tx):

    if abs(tx)>127 or abs(ty)>127:
        x=tx//2
        y=ty//2
    else:
        x=tx
        y=ty
    noct = 0
    if (x<0):
        ix = struct.unpack('B',struct.pack("b", x))[0] ^ 0xFF
        noct |= 4
    else: ix = x
    if (y<0):
        iy = struct.unpack('B',struct.pack("b", y))[0] ^ 0xFF
        noct |= 2
    else: iy = y
    # print (ix, iy)
    # print (log2_tab[ix], log2_tab [iy], log2_tab[ix] - log2_tab [iy])
    res_div = log2_tab[ix] - log2_tab [iy]
    # print(res_div)
    if log2_tab[ix] >= log2_tab [iy]:
        idx = res_div ^ 0xFF #struct.unpack('B',struct.pack("b", res_div))[0] ^ 0xFF
        noct |= 1
    #
    #if (res_div > 0): idx = res_div ^ 0xFF
    else : idx = res_div # struct.unpack('B',struct.pack("b", res_div))[0]

    v= atan_tab[idx]
    #v = v ^ octant_adjust [noct]
    v = int.from_bytes(bytes([v ^ octant_adjust [noct]]), byteorder='big', signed=True)

    return v

# tab_exp = []
# for ii in range (256):
    
#     tab_exp.append(round(2**((ii)/32)))


tab_exp = [
    0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 
    0x01, 0x01, 0x01, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 
    0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x03, 0x03, 0x03, 0x03, 0x03, 
    0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x03, 0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 
    0x04, 0x04, 0x04, 0x04, 0x04, 0x04, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x05, 0x06, 
    0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x06, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x07, 0x08, 0x08, 
    0x08, 0x08, 0x08, 0x09, 0x09, 0x09, 0x09, 0x09, 0x0a, 0x0a, 0x0a, 0x0a, 0x0a, 0x0b, 0x0b, 0x0b, 
    0x0b, 0x0c, 0x0c, 0x0c, 0x0c, 0x0d, 0x0d, 0x0d, 0x0d, 0x0e, 0x0e, 0x0e, 0x0f, 0x0f, 0x0f, 0x10, 
    0x10, 0x10, 0x11, 0x11, 0x11, 0x12, 0x12, 0x13, 0x13, 0x13, 0x14, 0x14, 0x15, 0x15, 0x16, 0x16, 
    0x17, 0x17, 0x18, 0x18, 0x19, 0x19, 0x1a, 0x1a, 0x1b, 0x1b, 0x1c, 0x1d, 0x1d, 0x1e, 0x1f, 0x1f, 
    0x20, 0x21, 0x21, 0x22, 0x23, 0x24, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x29, 0x2a, 0x2b, 0x2c, 
    0x2d, 0x2e, 0x2f, 0x30, 0x31, 0x32, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3b, 0x3c, 0x3d, 0x3f, 
    0x40, 0x41, 0x43, 0x44, 0x46, 0x47, 0x49, 0x4a, 0x4c, 0x4e, 0x4f, 0x51, 0x53, 0x55, 0x57, 0x59, 
    0x5b, 0x5c, 0x5f, 0x61, 0x63, 0x65, 0x67, 0x69, 0x6c, 0x6e, 0x70, 0x73, 0x75, 0x78, 0x7b, 0x7d, 
    0x80, 0x83, 0x86, 0x89, 0x8c, 0x8f, 0x92, 0x95, 0x98, 0x9c, 0x9f, 0xa2, 0xa6, 0xaa, 0xad, 0xb1, 
    0xb5, 0xb9, 0xbd, 0xc1, 0xc5, 0xca, 0xce, 0xd3, 0xd7, 0xdc, 0xe1, 0xe6, 0xeb, 0xf0, 0xf5, 0xfb
]


strexp = "tab_exp = [\n" + ", ".join(map(lambda x: "0x%02x"%(x), tab_exp)) + "]\n"
print (strexp)
def main ():

    print (atan2 (40,100)) # ==> 15
    print (atan2 (160,0))  # ==> 63
    print (atan2 (0,160)) # ==> 0
    print (atan2(-160,0)) # ==> -63
    print (atan2(100,100)) # ==> 31
    print (atan2(-100,100)) # ==> -32
    print (atan2(100,-100)) # ==> 96
    print (atan2(-100,-100)) # ==> -97
    print ("***************")
    print (norm(134, 0)) # ==> 134
    print (norm(3, 4))      # => 5
    print (norm(30, 40)) # ==> 51


if __name__ == '__main__':
    main()