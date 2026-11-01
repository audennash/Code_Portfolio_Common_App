from tkinter import *
import mnist
from net import NeuralNet

image_num=0
root = Tk()
canvas = Canvas(root, width = 600, height = 650, bg="white")
canvas.pack()


images=mnist.openimage("t10k-images-idx3-ubyte")
print("a")
labels=mnist.openlabel("t10k-labels-idx1-ubyte")
print("b")
digit_recognizer=NeuralNet(784, 16, 16, 10)
digit_recognizer.load("firstsave")


drawnstuff = []

def load_image():
    global image_num
    canvas.delete("all")
    image_data = images[4][image_num]
    rows=images[2]

    input= [i/256 for i in images[4][image_num]]
    digit_recognizer.valuemap[0] = input
    digit_recognizer.forwardpropagate()

    num = 0
    best_result = 0
    best_num = 0
    for i in digit_recognizer.valuemap[-1]: 
        if i>best_result: 
            best_result=i
            best_num = num
        print(num, i)
        num += 1
    confidence = digit_recognizer.valuemap[-1][best_num]
    print("_"*24)

    for y in range(rows):
        for x in range(images[3]):
            canvas.create_rectangle(20+20*x, 20+20*y, 20+20*(x+1), 20+20*(y+1), fill = '#%02x%02x%02x' % (image_data[y*rows+x], image_data[y*rows+x], image_data[y*rows+x]))
    canvas.create_text(300, 625, 
                       text="Guessed Number: " +  str(best_num) + ", Confidence: " + str(confidence)[0:5] + ", Real Number: " + str(labels[2][image_num]), 
                       fill="black", font=("Arial", 15))
    image_num += 1

next_button = Button (root, 
    text="load",
    command=load_image,
    fg="black",
    activebackground="black", 
    activeforeground="white",
    font=("Arial", 12),
    height=1,
    width=5,
    justify="center",
)
next_button.pack()

root.mainloop()                
