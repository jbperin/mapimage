
import math

IMAGE_WIDTH, IMAGE_HEIGHT    = 240, 200

## BOTTOM RIGHT
def computePixel_BR(P1, P2, P3, xn, yn):
    [x3, y3] = P3
    [x1, y1] = P1
    [x2, y2] = P2

    norm32                  = math.sqrt((x2-x3)**2 + (y2-y3)**2)
    norm31                  = math.sqrt((x1-x3)**2 + (y1-y3)**2)

    gamma                   = math.atan2(y2-y3, x2-x3)
    delta                   = math.atan2(y3-y1, x3-x1)
    # print (f"gamma = {math.degrees(gamma)}, delta = {math.degrees(delta)}")

    cosgamma, singamma     = math.cos(gamma), math.sin(gamma)
    cosdelta, sindelta     = math.cos(delta), math.sin(delta)
    # print (cosgamma, singamma)
    # print (cosdelta, sindelta)
    divisor                = cosgamma * sindelta - cosdelta * singamma

    W_RATIO                = (IMAGE_WIDTH  / norm32)/divisor          # norm (x3, y3, x2, y2)
    H_RATIO                = (IMAGE_HEIGHT / norm31)/divisor          # norm (x3, y3, x1, y1)

    K                      = sindelta * W_RATIO # /divisor
    R                      = cosdelta * W_RATIO # /divisor
    S                      = singamma * H_RATIO # /divisor
    T                      = cosgamma * H_RATIO # /divisor

    r5                     = R*(yn - y3) - K*(xn - x3) 
    r4                     = T*(yn - y3) - S*(xn - x3) 
    # print (f"divisor {divisor}, r5 = {r5}, r4 = {r4}")

    Xpix, Ypix             = round(IMAGE_WIDTH + r5), round(IMAGE_HEIGHT + r4 )

    return [Xpix, Ypix]

## UP LEFT
def computePixel_UL(P0, P1, P2, xp, yp):
    [x0, y0] = P0
    [x1, y1] = P1
    [x2, y2] = P2

    # xp, yp = 12, 9
    norm01                  = math.sqrt((x1-x0)**2 + (y1-y0)**2)
    norm02                  = math.sqrt((x2-x0)**2 + (y2-y0)**2)

    alpha                   = math.atan2(y1-y0, x1-x0)
    beta                    = math.atan2(y2-y0, x2-x0)
    # print (y1-y0, x1-x0, alpha, round(alpha*127/math.pi))
    # print (y2-y0, x2-x0, beta , round(beta*127/math.pi))
    cosalpha, sinalpha      =  math.cos(alpha), math.sin(alpha)
    cosbeta, sinbeta        =  math.cos(beta), math.sin(beta)

    divisor                 = sinalpha*cosbeta - cosalpha*sinbeta
    W_RATIO                 = (IMAGE_WIDTH / norm01) /divisor        
    H_RATIO                 = (IMAGE_HEIGHT / norm02)/divisor

    K                       = cosbeta  * W_RATIO
    R                       = sinbeta  * W_RATIO
    S                       = sinalpha * H_RATIO
    T                       = cosalpha * H_RATIO

    r1                      = K*(yp-y0) - R*(xp-x0)
    r2                      = S*(xp-x0) - T*(yp-y0)

    Xpix, Ypix              = round(r1 ), round(r2)

    return [Xpix, Ypix]


def main ():
    P0 = [20,20]
    P1 = [120, 60]
    P2 = [20,180]
    P3 = [120, 140]

    # P1 = [20,20]
    # P0 = [120, 60]
    # P3 = [20,180]
    # P2 = [120, 140]

    # P1 = [20,20]
    # P3 = [120, 60]
    # P0 = [20,180]
    # P2 = [120, 140]

    print (P0, P1, P2, P3)

    xp, yp = 20, 20
    print (xp, yp)
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