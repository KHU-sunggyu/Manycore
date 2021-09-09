import cv2
import numpy as np

imageFile = './man.jpg'   #jpg을 연다.
img = cv2.imread(imageFile, 0) #cv을 사용해 read한다. (dec)
print(img)
print(img.shape)


np.savetxt('./man_out(hex).txt', img, fmt='%x', delimiter=' ') #hex 숫자로 변환하여 다시 txt파일로 write한다.
