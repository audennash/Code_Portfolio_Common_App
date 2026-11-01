def openimage(filepath, test=False):
    with open(filepath, mode='rb') as image_file:

        magic_num=int.from_bytes(image_file.read(4), "big")
        num_images=int.from_bytes(image_file.read(4), "big")
        rows=int.from_bytes(image_file.read(4), "big")
        columns=int.from_bytes(image_file.read(4), "big")

        images=[]
        for i in range(num_images):
            if test: print(i+1)
            images.append([])
            for y in range(rows):
                for x in range(columns):
                    color = int.from_bytes(image_file.read(1), "big")
                    images[-1].append(color)
        
        if test: print(magic_num, num_images, rows, columns)
        image_file.close()
    return magic_num, num_images, rows, columns, images

def openlabel(filepath, test=False):
    with open (filepath, mode='rb') as label_file:
        magic_num=int.from_bytes(label_file.read(4), "big")
        num_labels=int.from_bytes(label_file.read(4), "big")

        labels=[]
        for i in range(num_labels):
            if test: print(i+1)
            labels.append(int.from_bytes(label_file.read(1), "big"))
        
        if test: print(magic_num, num_labels)
        label_file.close()
    return magic_num, num_labels, labels

def test():
    openimage("train-images-idx3-ubyte", True)
    openlabel("train-labels-idx1-ubyte", True)


