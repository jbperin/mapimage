
import math

IMAGE_WIDTH, IMAGE_HEIGHT    = 240, 200

## BOTTOM RIGHT
def computePixel_BR(P1, P2, P3, xn, yn):
    [x3, y3] = P3
    [x1, y1] = P1
    [x2, y2] = P2

    gamma                    = math.atan2(y2-y3, x2-x3)
    delta                    = math.atan2(y3-y1, x3-x1)

    # print (f"gamma = {math.degrees(gamma)}, delta = {math.degrees(delta)}")

    cosgamma, singamma      = math.cos(gamma), math.sin(gamma)
    cosdelta, sindelta      = math.cos(delta), math.sin(delta)
    # print (cosgamma, singamma )
    # print (cosdelta, sindelta)
    divisor                 = cosgamma * sindelta - cosdelta * singamma

    r5          = (sindelta*(xn - x3) - cosdelta*(yn - y3))/(divisor)
    r4          = (singamma*(xn - x3) - cosgamma*(yn - y3))/(divisor)
    # print (f"divisor {divisor}, r5 = {r5}, r4 = {r4}")
    W_RATIO                 = IMAGE_WIDTH / math.sqrt((x2-x3)**2 + (y2-y3)**2)          # norm (x3, y3, x2, y2)
    H_RATIO                 = IMAGE_HEIGHT / math.sqrt((x1-x3)**2 + (y1-y3)**2)         # norm (x3, y3, x1, y1)

    Xpix, Ypix              = round(IMAGE_WIDTH-(r5 * W_RATIO)), round(IMAGE_HEIGHT - (r4 * H_RATIO))

    return [Xpix, Ypix]

# computePixel_BR([4,2], [1.16, 6.29], [3.48, 4.57], 3.36, 3.39)

# x0, y0 = 6, 3
# x1, y1 = 18, 9
# x2, y2 = 9, 14

## UP LEFT
def computePixel_UL(P0, P1, P2, xp, yp):
    [x0, y0] = P0
    [x1, y1] = P1
    [x2, y2] = P2

    # xp, yp = 12, 9

    alpha                   = math.atan2(y1-y0, x1-x0)
    beta                    = math.atan2(y2-y0, x2-x0)

    cosalpha, sinalpha      =  math.cos(alpha), math.sin(alpha)
    cosbeta, sinbeta        =  math.cos(beta), math.sin(beta)

    divisor                 = sinalpha*cosbeta - cosalpha*sinbeta

    # r2prime                 = (sinalpha*(x0-xp) - cosalpha*(y0-yp) ) / divisor
    # r1prime                 = (cosbeta*(y0-yp) - sinbeta*(x0-xp) ) / divisor
    r1 = (sinbeta*(xp-x0)-cosbeta*(yp-y0))/(-divisor)
    r2 = (sinalpha*(xp-x0)-cosalpha*(yp-y0))/divisor
    W_RATIO                 = IMAGE_WIDTH / math.sqrt((x1-x0)**2 + (y1-y0)**2)          # norm (x0, y0, x1, y1)
    H_RATIO                 = IMAGE_HEIGHT / math.sqrt((x2-x0)**2 + (y2-y0)**2)         # norm (x0, y0, x2, y2)

    # Xpix, Ypix              = round(r1prime * W_RATIO), round(r2prime * H_RATIO)
    Xpix, Ypix              = round(r1 * W_RATIO), round(r2 * H_RATIO)

    return [Xpix, Ypix]



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

    xp, yp = 20, 20
    pixel = computePixel_UL(P0, P1, P2, xp, yp)
    print (pixel)
    xp, yp = 120, 60
    pixel = computePixel_UL(P0, P1, P2, xp, yp)
    print (pixel)
    xp, yp = 20, 180
    pixel = computePixel_UL(P0, P1, P2, xp, yp)
    print (pixel)

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
    xn, yn = 25, 178
    pixel = computePixel_BR(P1, P2, P3, xn, yn)
    print (pixel)


if __name__ == '__main__':
    main()