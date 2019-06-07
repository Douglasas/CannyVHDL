#!/usr/bin/python3
import cv2
import numpy as np
import matplotlib.pyplot as plt

bits_total = 32
bits_fract = 22

def plot_dat(img_name: str, img_length: int):

    img_res = np.zeros((img_length, img_length), dtype=np.int32)

    img = open(img_name, "r")
    img = img.readlines()

    img_i = 0
    img_j = 0

    for line in img:

        img_res[img_j][img_i] = int(line[0:bits_total-1], 2)

        if img_i >= img_length-1:
            img_i = 0
            img_j += 1
        else:
            img_i += 1

    plt.imshow(img_res, cmap='gray')
    plt.show()

plot_dat("../dat/img_out.dat", 220)
