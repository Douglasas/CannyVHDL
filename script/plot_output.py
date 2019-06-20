#!/usr/bin/python3
import cv2
import matplotlib.pyplot as plt
import numpy as np
from bitstring import Bits
import math

MSB = 10
LSB = 22

def to_float(val: str) -> float:
    b = Bits('0b'+val, length=MSB+LSB)
    return b.int / (2 ** LSB)

def plot_dat(img_name: str):

    img = open(img_name, "r")
    img = img.readlines()

    img_length = math.sqrt(len(img))
    print('img length:', img_length)
    img_length = int(img_length)

    img_res = np.zeros((img_length, img_length), dtype=np.float)
    img_i = 0
    img_j = 0

    for line in img:
        img_res[img_j][img_i] = to_float(line)

        if img_i >= img_length-1:
            img_i = 0
            img_j += 1
        else:
            img_i += 1

    plt.imshow(img_res*255, cmap='gray')
    plt.show()

plot_dat("../dat/canny_out.dat")
