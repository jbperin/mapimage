
import atanorm, trigo

def main():

    [xC, yC] = [4,1]
    angleC = 45 #degres
    [x1, y1] = [9,4]
    [x2, y2] = [4,6]

    # norm01                  = atanorm.norm(x1-x0, y1-y0)
    # norm02                  = atanorm.norm(x2-x0, y2-y0)
    # print (f"norm 01 = {norm01}, norm 02 = {norm02}")

    alpha                   = round(angleC * (128/180)) # atanorm.atan2(y1-yC, x1-xC)
    beta                    = atanorm.atan2(y2-y1, x2-x1)
    print (f"alpha = {alpha*180/128}, beta = {beta*180/128}")

    cosalpha, sinalpha      =  trigo.cos(alpha), trigo.sin(alpha)
    cosbeta, sinbeta        =  trigo.cos(beta), trigo.sin(beta)
    # print ("cosalpha = %f, sinalpha = %f"%(cosalpha/32, sinalpha/32 ))
    # print ("cosbeta= %f sinbeta = %f"%(cosbeta/32, sinbeta/32))

    dividend                = sinbeta*(xC-x1) - cosbeta*(yC-y1)
    print (f"dividend = {dividend}")
    divisor                 = sinalpha*cosbeta - cosalpha*sinbeta
    print (f"divisor = {divisor}")
    distance                = dividend*32//divisor
    print (f"distance = {distance}")

if __name__ == '__main__':
    main()