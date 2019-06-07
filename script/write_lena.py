#!/usr/bin/python3
import cv2
import numpy as np
import matplotlib.pyplot as plt

bits_total = 32
bits_fract = 22

def img_to_dat(img_name: str, file_name: str = "../dat/img.dat"):

    img = cv2.imread(img_name, cv2.IMREAD_GRAYSCALE)
    file = open(file_name, "w")

    for line in img:
        for pix in line:
            bin_value = bin(pix << bits_fract)[2:]
            file.write((bits_total-len(bin_value))*'0' + bin_value)
            file.write('\n')

img_to_dat("../img/lena.png")
