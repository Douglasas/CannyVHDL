#!/usr/bin/python3
import cv2
import numpy as np
import matplotlib.pyplot as plt
from bitstring import Bits

MSB = 12
LSB = 22

def to_fixed(val: float) -> str:
    intval = int(round(val * (2 ** LSB)))
    b = Bits(int=intval, length=MSB + LSB)
    return b.bin

def img_to_dat(img_name: str, file_name: str = "../dat/img.dat"):

    img = cv2.imread(img_name, cv2.IMREAD_GRAYSCALE)
    file = open(file_name, "w")

    i = 0
    j = 0
    for line in img:
        for pix in line:

            file.write(to_fixed(pix))
            file.write('\n')
        i = 0
        j+= 1
    print(img[0,-1]*2**22)
    print(img[:3,:3]*2**22)
    print(i,j)

img_to_dat("../img/lena.png")
