import math
import numpy as np
import cv2
from bitstring import Bits


def to_float(val: str, MSB: int, LSB: int) -> float:
    b = Bits('0b'+val, length=MSB+LSB)
    return b.int / (2 ** LSB)

def dat2png(dat_path: str, img_path: str, size_x: int, size_y: int, MSB: int, LSB: int):

    img = open(dat_path, "r")
    img = img.readlines()

    img_res = np.zeros((size_x, size_y), dtype=np.float)
    img_i = 0
    img_j = 0

    for line in img:
        img_res[img_j][img_i] = to_float(line, MSB, LSB)

        if img_i == size_y-1:
            img_i = 0
            img_j += 1
        else:
            img_i += 1

    img_res = 255 * img_res / np.max(img_res)
    cv2.imwrite(img_path, img_res)

def gaussian_kernel(size: int, sigma: int = 1) -> np.array:
    size = size // 2
    x, y = np.mgrid[-size:size + 1, -size:size + 1]
    # print(x,y)
    normal = 1 / (2.0 * np.pi * sigma ** 2)
    g = np.exp(-((x ** 2 + y ** 2) / (2.0 * sigma ** 2))) * normal
    return g

from scipy import ndimage

def conv(image: np.array, kernel: np.array) -> np.array:
    if kernel.shape == (3,3):
        return ndimage.convolve(input=image, weights=kernel)[1:-1,1:-1]
    else:
        return ndimage.convolve(input=image, weights=kernel)[:-1,:-1]

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
    # print(max * 255)
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
    # print(imgx[0][0], imgy[0][0], theta[0][0] * 180 / np.pi)
    # print(imgx[0][1], imgy[0][1], theta[0][1] * 180 / np.pi)
    # print(imgx[0][2], imgy[0][2], theta[0][2] * 180 / np.pi)
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
