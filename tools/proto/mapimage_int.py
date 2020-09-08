
# import math
import trigo
import atanorm
import struct

IMAGE_WIDTH, IMAGE_HEIGHT    = 240, 200

## BOTTOM RIGHT
def computePixel_BR(P1, P2, P3, xn, yn):
    [x3, y3] = P3
    [x1, y1] = P1
    [x2, y2] = P2

    norm32                  = atanorm.norm(x2-x3,y2-y3)
    norm31                  = atanorm.norm(x1-x3,y1-y3)
    print (f"norm 32 = {norm32}, norm 31 = {norm31}")
    # norm32                  = math.sqrt((x2-x3)**2 + (y2-y3)**2)
    # norm31                  = math.sqrt((x1-x3)**2 + (y1-y3)**2)

    gamma                    = atanorm.atan2(y2-y3, x2-x3)
    delta                    = atanorm.atan2(y3-y1, x3-x1)
    print (f"gamma = {gamma*180/127}, delta = {delta*180/127}")

    cosgamma, singamma      = trigo.cos(gamma), trigo.sin(gamma)
    cosdelta, sindelta      = trigo.cos(delta), trigo.sin(delta)
    print ("cosgamma = %f, singamma = %f"%(cosgamma/32, singamma/32 ))
    print ("cosdelta= %f sindelta = %f"%(cosdelta/32, sindelta/32))

    divisor                = cosgamma * sindelta - cosdelta * singamma
    print (f"divisor = {divisor/(32*32)}")

    W_RATIO                = (((IMAGE_WIDTH*32) // norm32)*32)//(divisor//32)          # norm (x3, y3, x2, y2)
    H_RATIO                = (((IMAGE_HEIGHT*32) // norm31)*32)//(divisor//32)

    print (f"W_RATIO = {W_RATIO/32}, H_RATIO = {H_RATIO/32}")

    K                      = (sindelta * W_RATIO) # //(32*32)
    R                      = (cosdelta * W_RATIO) # //(32*32)
    S                      = (singamma * H_RATIO) # //(32*32)
    T                      = (cosgamma * H_RATIO) # //(32*32)
    print (f"K = {K/1024}, R = {R/1024}, S = {S/1024}, T = {T/1024}")

    r5                     = R*(yn - y3) - K*(xn - x3) 
    r4                     = T*(yn - y3) - S*(xn - x3) 
    print (f"r5 = {r5/1024}, r4 = {r4/1204}")

    # return [Xpix, Ypix]
    return [0,0]

# computePixel_BR([4,2], [1.16, 6.29], [3.48, 4.57], 3.36, 3.39)

# x0, y0 = 6, 3
# x1, y1 = 18, 9
# x2, y2 = 9, 14

## UP LEFT
# def computePixel_UL(P0, P1, P2, xp, yp):
#     [x0, y0] = P0
#     [x1, y1] = P1
#     [x2, y2] = P2

#     # xp, yp = 12, 9
#     alpha                   = math.atan2(y1-y0, x1-x0)
#     beta                    = math.atan2(y2-y0, x2-x0)
#     print (y1-y0, x1-x0, alpha, round(alpha*127/math.pi))
#     print (y2-y0, x2-x0, beta , round(beta*127/math.pi))
#     cosalpha, sinalpha      =  math.cos(alpha), math.sin(alpha)
#     cosbeta, sinbeta        =  math.cos(beta), math.sin(beta)

#     divisor                 = sinalpha*cosbeta - cosalpha*sinbeta

#     # r2prime                 = (sinalpha*(x0-xp) - cosalpha*(y0-yp) ) / divisor
#     # r1prime                 = (cosbeta*(y0-yp) - sinbeta*(x0-xp) ) / divisor
#     r1 = (sinbeta*(xp-x0)-cosbeta*(yp-y0))/(-divisor)
#     r2 = (sinalpha*(xp-x0)-cosalpha*(yp-y0))/divisor
#     W_RATIO                 = IMAGE_WIDTH / math.sqrt((x1-x0)**2 + (y1-y0)**2)          # norm (x0, y0, x1, y1)
#     H_RATIO                 = IMAGE_HEIGHT / math.sqrt((x2-x0)**2 + (y2-y0)**2)         # norm (x0, y0, x2, y2)

#     # Xpix, Ypix              = round(r1prime * W_RATIO), round(r2prime * H_RATIO)
#     Xpix, Ypix              = round(r1 * W_RATIO), round(r2 * H_RATIO)

#     return [Xpix, Ypix]



# P0x, P0y = x0, y0
# P1x, P1y = x1, y1
# P2x, P2y = x2, y2

# Px, Py = xp, yp

# def det (ux, uy, vx, vy):
#     return ux*vy - uy*vx


# v1x, v1y = P1x-P0x, P1y - P0y
# v2x, v2y = P2x-P0x, P2y - P0y
# vx, vy = Px - P0x, Py - P0y

# a = (det (vx, vy, v2x, v2y)- det(P0x, P0y, v2x, v2y))/det(v1x, v1y, v2x, v2y)
# b = (det (vx, vy, v1x, v1y)- det(P0x, P0y, v1x, v1y))/det(v1x, v1y, v2x, v2y)

# print (a*IMAGE_WIDTH, b*IMAGE_HEIGHT)


def main ():
    P0 = [20,20]
    P1 = [120, 60]
    P2 = [20,180]
    P3 = [120, 140]
    print (P0, P1, P2, P3)
    # P1 = [20,20]
    # P0 = [120, 60]
    # P3 = [20,180]
    # P2 = [120, 140]

    # P1 = [20,20]
    # P3 = [120, 60]
    # P0 = [20,180]
    # P2 = [120, 140]

    # xp, yp = 20, 20
    # print (xp, yp)
    # pixel = computePixel_UL(P0, P1, P2, xp, yp)
    # print (pixel)
    # xp, yp = 120, 60
    # pixel = computePixel_UL(P0, P1, P2, xp, yp)
    # print (pixel)
    # xp, yp = 20, 180
    # pixel = computePixel_UL(P0, P1, P2, xp, yp)
    # print (pixel)

    print ("*******")


    xn, yn = 120, 60
    pixel = computePixel_BR(P1, P2, P3, xn, yn)
    print (pixel)
    xn, yn = 20, 180
    pixel = computePixel_BR(P1, P2, P3, xn, yn)
    print (pixel)
    xn, yn = 120, 140
    pixel = computePixel_BR(P1, P2, P3, xn, yn)
    print (pixel)

    # xn, yn = 120, 60
    # pixel = computePixel_BR(P1, P2, P3, xn, yn)
    # print (pixel)
    # xn, yn = 20, 20
    # pixel = computePixel_BR(P1, P2, P3, xn, yn)
    # print (pixel)
    # xn, yn = 120, 140
    # pixel = computePixel_BR(P1, P2, P3, xn, yn)
    # print (pixel)


if __name__ == '__main__':
    main()