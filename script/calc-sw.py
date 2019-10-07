#!/usr/bin/python3
import math
import numpy as np
import cv2


# generate gaussian 5x5 kernel

def gaussian_kernel(size: int, sigma: int = 1) -> np.array:
    size = size // 2
    x, y = np.mgrid[-size:size + 1, -size:size + 1]
    # print(x,y)
    normal = 1 / (2.0 * np.pi * sigma ** 2)
    g = np.exp(-((x ** 2 + y ** 2) / (2.0 * sigma ** 2))) * normal
    return g


def conv(image: np.array, kernel: np.array) -> np.array:
    buff = [[0] * (image.shape[1] - kernel.shape[1]) for i in range(kernel.shape[0] - 1)]
    data = [[0] * kernel.shape[1] for i in range(kernel.shape[0])]

    pad_y = (kernel.shape[0] - 1) // 2
    pad_x = (kernel.shape[1] - 1) // 2

    result = np.zeros((image.shape[0] - pad_y * 2, image.shape[1] - pad_x * 2), dtype=np.float64)

    line_count = 0
    column_count = 0

    for line in image:
        for pix in line:
            # insert pix in data 0
            data[0].insert(0, pix)
            # for each line
            for i in range(kernel.shape[0] - 1):
                # rotate data and buffers
                buff[i].insert(0, data[i].pop(-1))
                data[i + 1].insert(0, buff[i].pop(-1))

            if pad_y * 2 <= line_count and pad_x * 2 <= column_count:
                acc = 0
                for lined, linek in zip(data, kernel):
                    for pixd, pixk in zip(lined, linek):
                        acc += pixd * pixk
                result[line_count - pad_y * 2][column_count - pad_x * 2] = acc

            column_count += 1
            if column_count == image.shape[1]:
                line_count += 1
                column_count = 0

    return result


def calc_gradient_abs(imgx: np.array, imgy: np.array) -> np.array:
    result = np.zeros(imgx.shape, dtype=np.float64)
    for y, (linex, liney) in enumerate(zip(imgx, imgy)):
        for x, (pixx, pixy) in enumerate(zip(linex, liney)):
            result[y][x] = math.sqrt(pixx * pixx + pixy * pixy)
    return result


#img = cv2.imread('img/lena.png', cv2.IMREAD_GRAYSCALE)
lena = cv2.imread('../img/lena.png', cv2.IMREAD_GRAYSCALE)
lena = lena.astype(np.float64)/255.0

# gaussian_k = gaussian_kernel(3)
# img_blur = conv(img, gaussian_k)

#### ROBERTS ####
roberts_k_x = np.array([[1, 0], [0, -1]], dtype=np.float64)
roberts_k_y = np.array([[0, 1], [-1, 0]], dtype=np.float64)
img = lena[:]
robs_x = conv(img, roberts_k_x)
robs_y = conv(img, roberts_k_y)
img_robs = calc_gradient_abs(robs_x, robs_y)[1:,1:]
cv2.imwrite("../img/sw-results/roberts-sw.png", img_robs*255/np.max(img_robs))

#### PREWITT ####
prewitt_k_x = np.array([[-1, 0, 1], [-1, 0, 1], [-1, 0, 1]], dtype=np.float64)
prewitt_k_y = np.array([[-1, -1, -1], [0, 0, 0], [1, 1, 1]], dtype=np.float64)
img = lena[:]
img_prew_x = conv(img, prewitt_k_x)
img_prew_y = conv(img, prewitt_k_y)
img_prew = calc_gradient_abs(img_prew_x, img_prew_y)
cv2.imwrite("../img/sw-results/prewitt-sw.png", img_prew*255/np.max(img_prew))

#### SOBEL ####
sobel_k_x = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]], dtype=np.float64)
sobel_k_y = np.array([[-1, -2, -1], [0, 0, 0], [1, 2, 1]], dtype=np.float64)
img = lena[:]
img_sob_x = conv(img, sobel_k_x)
img_sob_y = conv(img, sobel_k_y)
img_sob = calc_gradient_abs(img_sob_x, img_sob_y)
cv2.imwrite("../img/sw-results/sobel-sw.png", img_sob*255/np.max(img_sob))


#### LAPLACIAN ####
#### SOBEL ####
laplacian_k = np.array([[0, -1, 0],[-1, 4, -1],[0, -1, 0]])
img = lena[:]
lp = conv(img, laplacian_k)
cv2.imwrite("../img/sw-results/laplacian-sw.png", abs(lp)*255.0/np.max(abs(lp)))
