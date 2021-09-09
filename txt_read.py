import cv2
import numpy as np


in_file = open("man_out(hex)_detect.txt","r",encoding = 'utf-8') #결과 txt file(hex) open
count1 = 0
count2 = 0
new_line = []
for line in in_file:
    #결과 txt file은 verilog 안에서 주소값을 반환하기 때문에 counting한다.
    if (line.find("//") != -1):
        count1 = count1+1
        print("//발생")
        print(count1)
    elif (line.find("xxxx") != -1):
        count2 = count2+1
        print("xxxx발생")
        print(count2)
    else:
        new_line.append(line) #위의 경우 제외 값을 new_line에 append한다.
in_file.close() #최초 read 전용으로 열었던 output txt file 닫기
out_file = open("Trans_1.txt","w",encoding = 'utf-8') #write위한 txt파일 생성 열기
print(len(new_line))
for i in range(len(new_line)):
    out_file.write(new_line[i]) #new_line 내용을 차례로 txt파일에 write

out_file.close() #작성 완료 후 file 닫기


with open('./Trans_2.txt', 'w') as out_file, open('./Trans_1.txt') as in_file:
    for hex in in_file.read().split():  #infile의 값을 (hex값) 읽는다.
       print(int(hex, 16), file=out_file)  #out_file에 hex값을 int 16형태로 쓴다.


channel1=np.loadtxt('./Trans_2.txt',dtype='uint8') #int32 정수형태로 Tran_2.txt 받아와 Channel1 객체에 저장

Channel1=channel1.reshape(209,240) #원본이미지 크기에 맞게 reshape

np.savetxt('./Output.txt', Channel1, fmt = '%d', delimiter = ' ') #txt로 저장

print(Channel1)

cv2.imwrite('man_out.jpg',Channel1)  #jpg로 저장
cv2.waitKey() 
cv2.destroyAllWindows()