from proto import atanorm
from proto import trigo
import math
IMAGE_WIDTH, IMAGE_HEIGHT    = 240, 200


class bres_agent :
    def __init__ (self, x0, y0, x1, y1):
        self.X =  x0
        self.Y =  y0
        self.destX = x1
        self.destY = y1
        self.dX = abs(x1-x0)
        self.dY = -abs(y1-y0)
        self.err = self.dX + self.dY
        if (x0<x1):
            self.sx = 1
        else:
            self.sx = -1
        if (y0<y1):
            self.sy = 1
        else:
            self.sy = -1
        self.arrived = (self.X == self.destX) and ( self.Y == self.destY)

    def step(self,):

        e2 = 2*self.err;

        if (e2 >= self.dY):
            self.err += self.dY; # e_xy+e_x > 0 */
            self.X += self.sx;
        if (e2 <= self.dX): # e_xy+e_y < 0 */
            self.err += self.dX;
            self.Y += self.sy;

        if (self.X == self.destX) and ( self.Y == self.destY):
            self.arrived = True

        retval = [self.X, self.Y]
        return retval


    def stepY(self,):
        nxtY = self.Y+self.sy
        e2 = 2*self.err;
        # if (self.err > 63): e2 = 128
        # elif (self.err < -64): e2 = -127
        # else : e2 = 2*self.err

        while ( not self.arrived and ((e2 > self.dX ) or (self.Y != nxtY))):
            if (e2 >= self.dY):
                self.err += self.dY; # e_xy+e_x > 0 */
                self.X += self.sx;
            if (e2 <= self.dX): # e_xy+e_y < 0 */
                self.err += self.dX;
                self.Y += self.sy;

            if (self.X == self.destX) and ( self.Y == self.destY):
                self.arrived = True
            e2 = 2*self.err;
            # if (self.err > 63): e2 = 128
            # elif (self.err < -64): e2 = -127
            # else : e2 = 2*self.err

        retval = [self.X, self.Y]
        return retval


def fillcliper (p1, p2, p3):
    if (p1[1] <= p2[1]):
        if (p2[1] <= p3[1]):
            pDep = p3
            pArr1 = p2
            pArr2 = p1
        else:
            pDep = p2
            if (p1[1] <= p3[1]):
                pArr1 = p3
                pArr2 = p1
            else:
                pArr1 = p1
                pArr2 = p3
    else:
        if (p1[1] <= p3[1]):
            pDep = p3
            pArr1 = p1
            pArr2 = p2
        else:
            pDep = p1
            if (p2[1] <= p3[1]):
                pArr1 = p3
                pArr2 = p2
            else:
                pArr1 = p2
                pArr2 = p3

    if (pDep[1] != pArr1[1]):
        a1 = bres_agent(pDep[0],pDep[1],pArr1[0],pArr1[1])
        a2 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        # print ([a1.X, a1.Y], [a2.X, a2.Y])
        yield [a1.X, a1.Y], [a2.X, a2.Y]
        # state = 0
        # while (not (a1.arrived and a2.arrived)):
        #     print (a1.stepY(), a2.stepY())
        #     if ((a2.arrived) and (state == 0)):
        #         a2 = bres_agent(pArr2[0],pArr2[1],pArr1[0],pArr1[1])
        #         state = 1
        #     elif ((a1.arrived) and (state == 0)):
        #         a1 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
        #         state = 1
        while (not (a1.arrived)):
            # print (a1.stepY(), a2.stepY())
            yield a1.stepY(), a2.stepY()
        a1 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
        while (not (a1.arrived and a2.arrived)):
            # print (a1.stepY(), a2.stepY())
            yield a1.stepY(), a2.stepY()

    else:
        a1 = bres_agent(pDep[0],pDep[1],pArr2[0],pArr2[1])
        a2 = bres_agent(pArr1[0],pArr1[1],pArr2[0],pArr2[1])
        # print ([a1.X, a1.Y], [a2.X, a2.Y])
        while (not (a1.arrived and a2.arrived)):
            # print (a1.stepY(), a2.stepY())
            yield a1.stepY(), a2.stepY()

class Triangle_UL:
    def __init__(self, P0, P1, P2):
        [x0, y0] = P0
        [x1, y1] = P1
        [x2, y2] = P2

        self.fillclip    = fillcliper(P0, P1, P2)

        norm01                  = atanorm.norm(x1-x0, y1-y0)
        norm02                  = atanorm.norm(x2-x0, y2-y0)
        # print (f"norm 01 = {norm01}, norm 02 = {norm02}")

        alpha                   = atanorm.atan2(y1-y0, x1-x0)
        beta                    = atanorm.atan2(y2-y0, x2-x0)
        # print (f"alpha = {alpha*180/127}, beta = {beta*180/127}")

        cosalpha, sinalpha      =  trigo.cos(alpha), trigo.sin(alpha)
        cosbeta, sinbeta        =  trigo.cos(beta), trigo.sin(beta)
        # print ("cosalpha = %f, sinalpha = %f"%(cosalpha/32, sinalpha/32 ))
        # print ("cosbeta= %f sinbeta = %f"%(cosbeta/32, sinbeta/32))

        divisor                 = sinalpha*cosbeta - cosalpha*sinbeta
        # print (f"divisor = {divisor/(32*32)}")

        W_RATIO                 = (((IMAGE_WIDTH*32) // norm01)*32) //(divisor//32)      
        H_RATIO                 = (((IMAGE_HEIGHT*32) // norm02)*32)//(divisor//32)
        # print (f"W_RATIO = {W_RATIO/32}, H_RATIO = {H_RATIO/32}")
    
        # K                       = cosbeta  * W_RATIO
        # R                       = sinbeta  * W_RATIO
        # S                       = sinalpha * H_RATIO
        # T                       = cosalpha * H_RATIO
        K = (cosbeta  *32 *32 *32 * IMAGE_WIDTH) / (norm01*divisor)
        R = (sinbeta  *32 *32 *32 * IMAGE_WIDTH) / (norm01*divisor)
        S = (sinalpha *32 *32 *32 * IMAGE_HEIGHT) / (norm02*divisor)
        T = (cosalpha *32 *32 *32 * IMAGE_HEIGHT) / (norm02*divisor)

        self.Ka, self.Kb = (cosbeta  *32 *32 *32 * IMAGE_WIDTH)  , (norm01*divisor)
        self.Ra, self.Rb = (sinbeta  *32 *32 *32 * IMAGE_WIDTH)  , (norm01*divisor)
        self.Sa, self.Sb = (sinalpha *32 *32 *32 * IMAGE_HEIGHT) , (norm02*divisor)
        self.Ta, self.Tb = (cosalpha *32 *32 *32 * IMAGE_HEIGHT) , (norm02*divisor)

        # print (f"K = {(self.Ka/self.Kb)/1024}, R = {(self.Ra/self.Rb)/1024}, S = {(self.Sa/self.Sb)/1024}, T = {(self.Ta/self.Tb)/1024}")

        self.x0, self.y0 = x0, y0
        self.x1, self.y1 = x1, y1
        self.x2, self.y2 = x2, y2

        self.currentX = self.x0
        self.currentY = self.y0

        self.endX = self.x0
        self.endY = self.y0

        # r1                      = (Ka/Kb)*(yp-y0) - (Ra/Rb)*(xp-x0)
        # r2                      = (Sa/Sb)*(xp-x0) - (Ta/Tb)*(yp-y0)
        # print (f"r1 = {r1/1024}, r2 = {r2/1204}")

        # Xpix, Ypix              = round(r1/1024), round(r2/1024)
        

    def getPixel (self, xp, yp):

        r1                      = (self.Ka/self.Kb)*(yp-self.y0) - (self.Ra/self.Rb)*(xp-self.x0)
        r2                      = (self.Sa/self.Sb)*(xp-self.x0) - (self.Ta/self.Tb)*(yp-self.y0)
        # print (f"r1 = {r1/1024}, r2 = {r2/1204}")

        Xpix, Ypix              = round(r1/1024), round(r2/1024)
        return (Xpix, Ypix)

    def getAccuratePixel (self, xp, yp):

        # xp, yp = 12, 9
        norm01                  = math.sqrt((self.x1-self.x0)**2 + (self.y1-self.y0)**2)
        norm02                  = math.sqrt((self.x2-self.x0)**2 + (self.y2-self.y0)**2)
        # print (f"norm 01 = {norm01}, norm 02 = {norm02}")

        alpha                   = math.atan2(self.y1-self.y0, self.x1-self.x0)
        beta                    = math.atan2(self.y2-self.y0, self.x2-self.x0)
        # print (f"alpha = {math.degrees(alpha)}, beta = {math.degrees(beta)}")

        cosalpha, sinalpha      =  math.cos(alpha), math.sin(alpha)
        cosbeta, sinbeta        =  math.cos(beta), math.sin(beta)
        # print ("cosalpha = %f, sinalpha = %f"%(cosalpha, sinalpha))
        # print ("cosbeta= %f sinbeta = %f"%(cosbeta, sinbeta))

        divisor                 = sinalpha*cosbeta - cosalpha*sinbeta
        # print (f"divisor = {divisor}")

        W_RATIO                 = (IMAGE_WIDTH / norm01) /divisor        
        H_RATIO                 = (IMAGE_HEIGHT / norm02)/divisor
        # print (f"W_RATIO = {W_RATIO}, H_RATIO = {H_RATIO}")


        # K                       = cosbeta  * W_RATIO
        # R                       = sinbeta  * W_RATIO
        # S                       = sinalpha * H_RATIO
        # T                       = cosalpha * H_RATIO

        K = (cosbeta  * IMAGE_WIDTH) / (norm01*divisor)
        R = (sinbeta  * IMAGE_WIDTH) / (norm01*divisor)
        S = (sinalpha * IMAGE_HEIGHT) / (norm02*divisor)
        T = (cosalpha * IMAGE_HEIGHT) / (norm02*divisor)

        # print (f"K = {K}, R = {R}, S = {S}, T = {T}")

        r1                      = K*(yp-self.y0) - R*(xp-self.x0)
        r2                      = S*(xp-self.x0) - T*(yp-self.y0)
        # print (f"r1 = {r1}, r2 = {r2}")

        Xpix, Ypix              = round(r1 ), round(r2)

        return [Xpix, Ypix]

    def next(self):
        for (PL, PR) in self.fillclip:
            Left = min(PL[0], PR[0])
            Right = max(PL[0], PR[0])
            for i in range (Left, Right+1):
                pix, piy = self.getPixel(i, PR[1])
                
                yield i, PR[1], min(max(pix,0), IMAGE_WIDTH-1), min(max(piy,0), IMAGE_HEIGHT-1)


    
def main():


    P0, P1, P2 = [6, 3], [15, 10], [2,13]
    
    fillclip    = fillcliper(P0, P1, P2)
    for (PL, PR) in fillclip:
        print (PL, PR)

    triul       = Triangle_UL(P0, P1, P2)
    # nextPixel   = triul.next
    for (x, y, pix, piy) in triul.next():
        print (x, y, " => ",pix, piy)
    # for (PL, PR) in fillclip:
    #     print (PL, PR)
    #     Left = min(PL[0], PR[0])
    #     Right = max(PL[0], PR[0])
    #     triul.newLine (Left, Right, PR[1])
    #     for (pix, piy) in triul.nextPixel:
    #         print (pix, piy) 

if __name__ == '__main__':
    main()
