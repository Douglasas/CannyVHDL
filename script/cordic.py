import math

ANGLE_TABLE_SIZE = 20
ANGLE_TABLE = []
last_val = 1
for i in range(ANGLE_TABLE_SIZE):
    ANGLE_TABLE.append(math.atan(last_val) * 180 / math.pi)
    last_val = last_val / 2

print(ANGLE_TABLE)


def atan2(y: int, x: int) -> int:
    angle = 0
    loop_num = 0

    quad3_4 = y < 0

    if x < 0:
        angle = 180
        x = -x
        y = -y
    elif y < 0:
        angle = 360

    for i in range(len(ANGLE_TABLE)):
        if y < 0:
            # rotate counter-clockwise
            xn = x - (y >> loop_num)
            yn = y + (x >> loop_num)
            angle = angle - ANGLE_TABLE[loop_num]
        else:
            # rotate clockwise
            xn = x + (y >> loop_num)
            yn = y - (x >> loop_num)
            angle = angle + ANGLE_TABLE[loop_num]
        #print(angle)
        print(x, y)
        loop_num = loop_num + 1
        x = xn
        y = yn
    if quad3_4:
        return angle - 360
    return angle


y = -100
x = 200
print(atan2(y, x))
print(math.atan2(y, x)*180/math.pi)
