
import math

IMAGE_WIDTH, IMAGE_HEIGHT    = 240, 200

x0, y0 = 6, 3
x1, y1 = 18, 9
x2, y2 = 9, 14
xp, yp = 12, 9

def norm (xi, yi, xj, yj):
    return math.sqrt((xj-xi)**2 + (yj-yi)**2)


alpha   = math.atan2(y1-y0, x1-x0)
beta    = math.atan2(y2-y0, x2-x0)
# print (math.degrees(alpha), math.degrees(beta))

sinalpha    = math.sin(alpha)
cosalpha    = math.cos(alpha)
sinbeta     = math.sin(beta)
cosbeta     = math.cos(beta)

divisor     = sinalpha*cosbeta - cosalpha*sinbeta

r2prime     = (sinalpha*(xp-x0) - cosalpha*(yp-y0) ) / divisor
# print (r2prime)

r1prime     = (cosbeta*(yp-y0) - sinbeta*(xp-x0) ) / divisor
# print (r1prime)

L1          = norm (x0, y0, x1, y1)
L2          = norm (x0, y0, x2, y2)

W_RATIO     = IMAGE_WIDTH / L1
H_RATIO     = IMAGE_HEIGHT / L2

Xpix, Ypix = r1prime * W_RATIO, r2prime * H_RATIO

print (Xpix, Ypix)



P0x, P0y = x0, y0
P1x, P1y = x1, y1
P2x, P2y = x2, y2

Px, Py = xp, yp

def det (ux, uy, vx, vy):
    return ux*vy - uy*vx


v1x, v1y = P1x-P0x, P1y - P0y
v2x, v2y = P2x-P0x, P2y - P0y
vx, vy = Px - P0x, Py - P0y

a = (det (vx, vy, v2x, v2y)- det(P0x, P0y, v2x, v2y))/det(v1x, v1y, v2x, v2y)
b = (det (vx, vy, v1x, v1y)- det(P0x, P0y, v1x, v1y))/det(v1x, v1y, v2x, v2y)

print (a*IMAGE_WIDTH, b*IMAGE_HEIGHT)