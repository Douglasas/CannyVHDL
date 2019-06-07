#!/usr/bin/python3
import cv2
import numpy as np
from bitstring import Bits
import math

LSB = 22
MSB = 10

def to_float(val: str) -> float:
    b = Bits('0b'+val, length=MSB+LSB)
    return b.int / (2 ** LSB)

def plot_dat(img_name: str):

    img = open(img_name, "r")
    img = img.readlines()

    img_length = int(math.sqrt(len(img)))
    print('img length:', img_length)

    img_res = np.zeros((img_length, img_length), dtype=np.uint8)
    img_i = 0
    img_j = 0

    for line in img:
        img_res[img_j][img_i] = round(to_float(line))

        if img_i >= img_length-1:
            img_i = 0
            img_j += 1
        else:
            img_i += 1

    cv2.imshow('result', img_res)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

plot_dat("../dat/img_out.dat")
