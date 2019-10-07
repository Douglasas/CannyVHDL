#!/usr/bin/python3
import numpy as np
import cv2
from skimage import measure

filters = ['laplacian', 'roberts', 'prewitt', 'sobel', 'canny'] # 'laplacian' , 'roberts', 'prewitt', 'sobel', 'canny'
offsets = [[None,None], [None,None], [None,None], [None,None], [2,-2]]

datasizes = [
    #'5-1', '5-3', '5-5', '5-8', '5-10', '5-15', '5-20',
    #'10-20', '12-20', '12-22', '20-40',
    '2-8', '4-6', '4-8', '8-6', '10-5', '10-6', '10-8', '10-10', '22-10'
]

import matplotlib.pyplot as plt

for (filt, of) in zip(filters, offsets):

    print('-'*10, filt, '-'*10)
    sw = cv2.imread("../img/sw-results/%s-sw.png" % filt, cv2.IMREAD_GRAYSCALE) [of[0]:of[1], of[0]:of[1]]
    # plt.imshow(sw, cmap='gray')
    # plt.show()

    for ds in datasizes:
        print('>', ds)
        hw = cv2.imread("../dat/%s/%s.png" % (ds, filt), cv2.IMREAD_GRAYSCALE)
        print(sw.shape, "?=", hw.shape)

        print('psnr:',  measure.compare_psnr(sw, hw))
        print('mse:',   measure.compare_mse(sw, hw))
        print('nrmse:', measure.compare_nrmse(sw, hw))
        print('ssim:',  measure.compare_ssim(sw, hw))

        res = np.zeros(sw.shape)
        res[sw == hw] = 1
        total = sw.shape[0] * sw.shape[1]
        print('hamming distance:', np.sum(res)/total)
