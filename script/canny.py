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
    max = 0
    for y, (linex, liney) in enumerate(zip(imgx, imgy)):
        for x, (pixx, pixy) in enumerate(zip(linex, liney)):
            result[y][x] = math.sqrt(pixx * pixx + pixy * pixy)
            if pixx * pixx + pixy * pixy > max:
                max = pixx * pixx + pixy * pixy
    print(max * 255)
    return result

def normalize_max(img: np.array) -> np.array:
    max = 0.
    for line in img:
        for pix in line:
            if pix > max:
                max = pix
    norm = np.zeros(img.shape, dtype=np.float64)
    for y, line in enumerate(img):
        for x, pix in enumerate(line):
            norm[y][x] = pix / max
    return norm

def calc_theta_sobel(imgx: np.array, imgy: np.array) -> np.array:
    theta = np.zeros(imgx.shape, dtype=np.float64)
    for y, (linex, liney) in enumerate(zip(imgx, imgy)):
        for x, (pixx, pixy) in enumerate(zip(linex, liney)):
            theta[y][x] = np.arctan2(pixy, pixx)
    print(imgx[0][0], imgy[0][0], theta[0][0] * 180 / np.pi)
    print(imgx[0][1], imgy[0][1], theta[0][1] * 180 / np.pi)
    print(imgx[0][2], imgy[0][2], theta[0][2] * 180 / np.pi)
    return theta

def non_max_suppress(img: np.array, theta: np.array) -> np.array:
    result = np.zeros(img.shape, dtype=np.float64)
    theta_deg = theta * 180. / np.pi
    theta_deg[theta_deg < 0] += 180

    for y, line in enumerate(img):
        for x, pix in enumerate(line):
            q = 255
            r = 255

            if not (0 < y < img.shape[0] - 1 and 0 < x < img.shape[1] - 1):
                result[y][x] = 0
            else:
                if (0 <= theta_deg[y][x] < 22.5) or (157.5 <= theta_deg[y][x] <= 180):  # angle 0
                    q = img[y][x + 1]
                    r = img[y][x - 1]
                elif 22.5 <= theta_deg[y][x] < 67.5:  # angle 45
                    q = img[y + 1][x - 1]
                    r = img[y - 1][x + 1]
                elif 67.5 <= theta_deg[y][x] < 112.5:  # angle 90
                    q = img[y + 1][x]
                    r = img[y - 1][x]
                elif 112.5 <= theta_deg[y][x] < 157.5:  # angle 135
                    q = img[y - 1][x - 1]
                    r = img[y + 1][x + 1]

                if pix >= q and pix >= r:
                    result[y][x] = pix
                else:
                    result[y][x] = 0
    return result

def threshold(img: np.array) -> np.array:
    highThreshold = 0.15  # 38
    lowThreshold = 0.0075  # highThreshold * 0.05 # 2

    M, N = img.shape
    res = np.zeros((M, N), dtype=np.float64)

    weak = np.int32(75)
    strong = np.int32(255)

    strong_i, strong_j = np.where(img >= highThreshold)
    # zeros_i, zeros_j = np.where(img < lowThreshold)

    weak_i, weak_j = np.where((img <= highThreshold) & (img >= lowThreshold))

    res[strong_i, strong_j] = strong
    res[weak_i, weak_j] = weak

    return res

def hysteresis(img: np.array) -> np.array:
    M, N = img.shape
    weak = np.int32(75)
    strong = np.int32(255)

    for i in range(1, M - 1):
        for j in range(1, N - 1):
            if img[i, j] == weak:
                try:
                    if ((img[i + 1, j - 1] == strong) or (img[i + 1, j] == strong) or (img[i + 1, j + 1] == strong)
                        or (img[i, j - 1] == strong) or (img[i, j + 1] == strong)
                        or (img[i - 1, j - 1] == strong) or (img[i - 1, j] == strong) or (img[i - 1, j + 1] == strong)):
                        img[i, j] = strong
                    else:
                        img[i, j] = 0
                except IndexError as e:
                    pass

    return img

#img = cv2.imread('img/lena.png', cv2.IMREAD_GRAYSCALE)
img = cv2.imread('../img/lena.png', cv2.IMREAD_GRAYSCALE)
# img = cv2.imread('/home/douglas/Desktop/lena_noise.png', cv2.IMREAD_GRAYSCALE)
img = img.astype(np.float64) / 255.0
# cv2.imshow('lena', img)

gaussian_k = gaussian_kernel(3)
print(gaussian_k)

# PRINT GAUSSIAN IN FIXED POINT
# for lin in gaussian_k:
#     for el in lin:
#         print(hex(int(round(el * (2**22)))), end='\t')
#         #print(hex(round()))
#     print()

img_blur = conv(img, gaussian_k)
# cv2.imshow('lena blur', img_blur)

sobel_k_x = np.array([[-1, 0, 1], [-2, 0, 2], [-1, 0, 1]], dtype=np.float64)
sobel_k_y = np.array([[1, 2, 1], [0, 0, 0], [-1, -2, -1]], dtype=np.float64)
img_sob_x = conv(img_blur, sobel_k_x)
img_sob_y = conv(img_blur, sobel_k_y)
# cv2.imshow('lena sobx', img_sob_x)
# cv2.imshow('lena soby', img_sob_y)
print("img[0,0]", img[0][0])
print("gauss[0,0]:\n", img_blur[:3, :3])
print("sobel[0,0]:", img_sob_x[0][0], img_sob_y[0][0])

img_grad = calc_gradient_abs(img_sob_x, img_sob_y)
img_norm_grad = normalize_max(img_grad)
# # cv2.imshow('lena grad', img_grad)
# # cv2.imshow('lena norm grad', img_norm_grad)
#
img_theta = calc_theta_sobel(img_sob_x, img_sob_y)
# cv2.imshow('lena theta', img_theta)
#
img_supressed = non_max_suppress(img_norm_grad, img_theta)
# # cv2.imshow('lena supressed', img_supressed)
#
# # print(cv2.threshold(img_supressed, 127, 255,cv2.THRESH_BINARY))
# #val, th = cv2.threshold((img_supressed * 255).astype(np.uint8), 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
# # cv2.imshow('lena threshold otsu', th)
#
img_threshold = threshold(img_supressed)
# # cv2.imshow('lena threshold', img_threshold)
#
img_hist = hysteresis(img_threshold)
# # cv2.imshow('lena hysteresis', img_hist)
#
# # hiTh, _ = cv2.threshold((img*255).astype(np.uint8), thresh=0, maxval=255, type=(cv2.THRESH_BINARY + cv2.THRESH_OTSU))
# # loTh = hiTh * .1
# # print(loTh, hiTh)
canny = cv2.Canny((img_blur * 255).astype(np.uint8), 255, 255)
# # cv2.imshow('canny opencv', canny)
#
# # cv2.waitKey(0)
# # cv2.destroyAllWindows()
#
import matplotlib.pyplot as plt

plt.imshow(img_hist, cmap='gray')
plt.show()
cv2.imwrite("../img/sw-results/canny-sw.png", img_hist*255/np.max(img_hist))
