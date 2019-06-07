#!/usr/bin/python3
import cv2
import numpy as np
import math

bits_total = 32
bits_fract = 22

def plot_dat(img_name: str):

    img = open(img_name, "r")
    img = img.readlines()

    img_length = int(math.sqrt(len(img)))
    print(img_length)

    img_res = np.zeros((img_length, img_length), dtype=np.uint8)
    img_i = 0
    img_j = 0

    for line in img:
        img_res[img_j][img_i] = int(line[0:bits_total-1], 2) >> bits_fract

        if img_i >= img_length-1:
            img_i = 0
            img_j += 1
        else:
            img_i += 1

    cv2.imshow('result', img_res)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

plot_dat("../dat/img_out.dat")
