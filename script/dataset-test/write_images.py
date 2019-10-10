#!/usr/bin/python3
import glob
from tqdm import tqdm
import sys

import cv2
import numpy as np
import matplotlib.pyplot as plt
from bitstring import Bits

if (len(sys.argv) != 3):
    exit("Usage: ./write_images.py [integer bits] [decimal bits]")
MSB = int(sys.argv[1])
LSB = int(sys.argv[2])

def to_fixed(val: np.float64) -> str:
    intval = int(round(val * (2 ** LSB)))
    b = Bits(int=intval, length=MSB + LSB)
    return b.bin

def img_to_dat(img_name: str, file_name: str = "../dat/img.dat"):

    img = cv2.imread(img_name, cv2.IMREAD_GRAYSCALE)
    file = open(file_name, "w")

    for line in img:
        for pix in line:
            pix = np.float64(pix)
            file.write(to_fixed(pix/255.0))
            file.write('\n')

print("Converting images to dat")
imgs_folder = "../../img/BSDS500-test"
for i,filename in enumerate(tqdm(glob.glob(imgs_folder+"/*.jpg"))):
    img_to_dat(filename, "../../dat/dataset/%d.dat" % i)

