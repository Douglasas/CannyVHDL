#!/usr/bin/python3
import math
import numpy as np
import cv2
from skimage import measure
import glob
from tqdm import tqdm

from img_functs import *


QT_IMGS       = 64
QT_IMGS_CANNY = 32

sum_lp    = 0
sum_robs  = 0
sum_prew  = 0
sum_sob   = 0
sum_canny = 0

imgs_folder = "../../img/BSDS500-test"
for i in tqdm(range(QT_IMGS)):
    filename = glob.glob(imgs_folder+"/*.jpg")[i]
    img_orig = cv2.imread(filename, cv2.IMREAD_GRAYSCALE)
    img_orig = img_orig.astype(np.float64)/255.0

    #### LAPLACIAN ####
    laplacian_k = np.array([[0, -1, 0],[-1, 4, -1],[0, -1, 0]])
    img = img_orig[:]
    # lp = conv(img, laplacian_k)
    lp = ndimage.convolve(input=img, weights=laplacian_k)[1:-1,1:-1]
    img_lp = 255 * abs(lp)/np.max(abs(lp))
    cv2.imwrite("../../dat/sw-results/laplacian/%d.png" % i, img_lp)

    #### ROBERTS ####
    roberts_k_x = np.array([[1, 0], [0, -1]], dtype=np.float64)
    roberts_k_y = np.array([[0, 1], [-1, 0]], dtype=np.float64)
    img = img_orig[:]
    robs_x = conv(img, roberts_k_x)
    robs_y = conv(img, roberts_k_y)
    img_robs = calc_gradient_abs(robs_x, robs_y)
    img_robs = 255 * img_robs/np.max(img_robs)
    cv2.imwrite("../../dat/sw-results/roberts/%d.png" % i, img_robs)

    #### PREWITT ####
    prewitt_k_x = np.array([[-1, 0, 1], [-1, 0, 1], [-1, 0, 1]], dtype=np.float64)
    prewitt_k_y = np.array([[-1, -1, -1], [0, 0, 0], [1, 1, 1]], dtype=np.float64)
    img = img_orig[:]
    img_prew_x = conv(img, prewitt_k_x)
    img_prew_y = conv(img, prewitt_k_y)
    img_prew = calc_gradient_abs(img_prew_x, img_prew_y)
    img_prew = 255 * img_prew/np.max(img_prew)
    cv2.imwrite("../../dat/sw-results/prewitt/%d.png" % i, img_prew)

    #### SOBEL ####
    sobel_k_x = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]], dtype=np.float64)
    sobel_k_y = np.array([[-1, -2, -1], [0, 0, 0], [1, 2, 1]], dtype=np.float64)
    img = img_orig[:]
    img_sob_x = conv(img, sobel_k_x)
    img_sob_y = conv(img, sobel_k_y)
    img_sob = calc_gradient_abs(img_sob_x, img_sob_y)
    img_sob = 255 * img_sob/np.max(img_sob)
    cv2.imwrite("../../dat/sw-results/sobel/%d.png" % i, img_sob)

    #### CANNY #####
    if i < QT_IMGS_CANNY:
        gaussian_k = gaussian_kernel(3)
        img_blur = conv(img, gaussian_k)

        sobel_k_x = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]], dtype=np.float64)
        sobel_k_y = np.array([[1, 2, 1], [0, 0, 0], [-1, -2, -1]], dtype=np.float64)
        img_sob_x = conv(img_blur, sobel_k_x)
        img_sob_y = conv(img_blur, sobel_k_y)
        img_grad = calc_gradient_abs(img_sob_x, img_sob_y)
        img_norm_grad = normalize_max(img_grad)
        img_theta = calc_theta_sobel(img_sob_x, img_sob_y)
        img_supressed = non_max_suppress(img_norm_grad, img_theta)
        img_threshold = threshold(img_supressed)
        img_hist = hysteresis(img_threshold)
        img_canny = 255 * img_hist/np.max(img_hist)
        cv2.imwrite("../../dat/sw-results/canny/%d.png" % i, img_canny)

    # COMPARE IMAGES

    # original size: x=321 y=481

    dat2png(
        dat_path="../../dat/dataset-final-results/laplacian-4-8/%d.dat" % i,
        img_path="../../dat/dataset-final-results/laplacian-4-8/%d.png" % i,
        size_x=319, size_y=479,
        MSB=4, LSB=8
    )
    hw_lp     = cv2.imread("../../dat/dataset-final-results/laplacian-4-8/%d.png" % i, cv2.IMREAD_GRAYSCALE).astype(np.float64)
    sum_lp    += measure.compare_ssim(img_lp, hw_lp)

    dat2png(
        dat_path="../../dat/dataset-final-results/roberts-2-8/%d.dat" % i,
        img_path="../../dat/dataset-final-results/roberts-2-8/%d.png" % i,
        size_x=320, size_y=480,
        MSB=2, LSB=8
    )
    hw_robs   = cv2.imread("../../dat/dataset-final-results/roberts-2-8/%d.png" % i, cv2.IMREAD_GRAYSCALE).astype(np.float64)
    sum_robs  += measure.compare_ssim(img_robs, hw_robs)

    dat2png(
        dat_path="../../dat/dataset-final-results/prewitt-2-8/%d.dat" % i,
        img_path="../../dat/dataset-final-results/prewitt-2-8/%d.png" % i,
        size_x=319, size_y=479,
        MSB=2, LSB=8
    )
    hw_prew   = cv2.imread("../../dat/dataset-final-results/prewitt-2-8/%d.png" % i, cv2.IMREAD_GRAYSCALE).astype(np.float64)
    sum_prew  += measure.compare_ssim(img_prew, hw_prew)

    dat2png(
        dat_path="../../dat/dataset-final-results/sobel-4-8/%d.dat" % i,
        img_path="../../dat/dataset-final-results/sobel-4-8/%d.png" % i,
        size_x=319, size_y=479,
        MSB=4, LSB=8
    )
    hw_sob    = cv2.imread("../../dat/dataset-final-results/sobel-4-8/%d.png" % i, cv2.IMREAD_GRAYSCALE).astype(np.float64)
    sum_sob   += measure.compare_ssim(img_sob, hw_sob)

    if i < QT_IMGS_CANNY:
        dat2png(
            dat_path="../../dat/dataset-final-results/canny-10-8/%d.dat" % i,
            img_path="../../dat/dataset-final-results/canny-10-8/%d.png" % i,
            size_x=(321-8),size_y=(481-8),
            MSB=10, LSB=8
        )
        hw_canny  = cv2.imread("../../dat/dataset-final-results/canny-10-8/%d.png" % i, cv2.IMREAD_GRAYSCALE).astype(np.float64)
        sum_canny += measure.compare_ssim(img_canny[2:-2,2:-2], hw_canny)
        print(measure.compare_ssim(img_canny[2:-2,2:-2], hw_canny))

print("AVG SSIM laplacian", sum_lp    / QT_IMGS)
print("AVG SSIM roberts",   sum_robs  / QT_IMGS)
print("AVG SSIM prewitt",   sum_prew  / QT_IMGS)
print("AVG SSIM sobel",     sum_sob   / QT_IMGS)
print("AVG SSIM canny",     sum_canny / QT_IMGS_CANNY)
