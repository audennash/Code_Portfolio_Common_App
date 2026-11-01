from math import *
from random import randint, shuffle
import mnist
from time import sleep

#relevant functions
def sigmoid(x):
    return 1/(1+e**-x)

def dsigmoid(x):
    try:
        return e**-x/(1+e**-x)**2
    except:
        return 2**-8

def dotproduct(a, b): #yes i stole this from here https://stackoverflow.com/questions/32669855/dot-product-of-two-lists-in-python
    return sum(i[0] * i[1] for i in zip(a, b, strict=True))

def initrandom():
    return randint(-1000, 1000)/1000

def cost(a, b):
    return sum([(i[0]-i[1])**2 for i in zip(a, b, strict=True)])

class NeuralNet:
    def __init__(self, *layers):
        self.layers = layers
        self.valuemap=[[0 for j in range(i)] for i in layers] #value map stores sigmoided data
        self.valuemap_unsigmoided=[[0 for j in range(i)] for i in layers]
        self.trainmap=[[0 for j in range(i)] for i in layers][1:]
        self.weights=[]
        self.weight_derivatives = []
        self.biases=[]
        self.bias_derivatives = []
        for index, size in enumerate(layers[1:]): #for each layer
            self.weights.append([[initrandom() for j in range(layers[index])] for i in range(size)]) #for each neuron (i), add a weight for each neuron in the previous layer (iterated with j)
            self.weight_derivatives.append([[0 for j in range(layers[index])] for i in range(size)])
            self.biases.append([initrandom() for i in range(size)]) #add a bias for each neuron
            self.bias_derivatives.append([0 for i in range(size)])
        self.forwardindex = 0
        self.backwardindex = 1
        self.bsize=1
        self.lrate=1

    def batchsize(self, bsize):
        self.bsize = bsize

    def learningrate(self, lrate):
        self.lrate = lrate
    
    def load(self, fp):
        with open(fp, mode="r") as rawdata:
            rawdata = rawdata.read()
            data=eval(rawdata)
            self.valuemap=[[0 for j in range(i)] for i in data["layers"]]
            self.valuemap_unsigmoided=[[0 for j in range(i)] for i in data["layers"]]
            self.trainmap=[[0 for j in range(i)] for i in data["layers"]][1:]
            self.weights=data["weights"]
            self.biases=data["biases"]
    
    def save(self, fp):
        with open(fp, mode="w") as file:
            file.write(str({"layers": self.layers, "weights": self.weights, "biases": self.biases}))

    def singleforward(self): 
        for i in range(self.layers[self.forwardindex+1]):
            #this is the weights for one layer of neurons times the values of the previous plus the respective biases.
            #note that the weights and biases list ignores the input layer, so self.forwardindex in these lists actually refers to the weights and biases of the layer after
            unactivated = dotproduct(self.valuemap[self.forwardindex], self.weights[self.forwardindex][i])+self.biases[self.forwardindex][i]
            self.valuemap[self.forwardindex+1][i] = sigmoid(unactivated)
            self.valuemap_unsigmoided[self.forwardindex+1][i] = unactivated
        self.forwardindex += 1
        
    def forwardpropagate(self):
        for i in range(len(self.layers)-1):
            self.singleforward()
        self.forwardindex=0
    
    def desiredoutput(self, dout):
        self.dout=dout

    def singlebackward(self):
        for i in range(self.layers[-self.backwardindex]): #for each neuron in the layer
            #the final derivative is the derivative of the activated output to the cost function
            if self.backwardindex==1: #if its the output one, the change to the cost is just the derivative of the cost function
                final_derivative=2*(self.valuemap[-1][i]-self.dout[i]) #this just multiplies the output of a  in the last layer by its desired output
            else: #otherwsise its the derivative of the activated function to the cost function
                final_derivative=sum([self.trainmap[-self.backwardindex+1][j]*self.weights[-self.backwardindex+1][j][i] for j in range(self.layers[-self.backwardindex+1])])
                #above multiplies the final derivative (necessary for all computable values) of the one layer forward in the network by the weight connecting it to the neuron
                #in the current layer of the network, thereby computing the derivative of the activation of this neuron to the cost. 
            final_derivative *= dsigmoid(self.valuemap_unsigmoided[-self.backwardindex][i])
            
            for j in range(self.layers[-self.backwardindex-1]): #for every weight (or rather neuron in the previous layer)
                self.weight_derivatives[-self.backwardindex][i][j] += final_derivative*self.valuemap[-self.backwardindex-1][j]/self.bsize #the weight to the cost is simply the output to the cost times the 
                #output of the respective neuron for the weight (remember they are unsigmoided)
            self.bias_derivatives[-self.backwardindex][i] += final_derivative/self.bsize
            self.trainmap[-self.backwardindex][i] = final_derivative

        self.backwardindex += 1

    def backpropagate(self):
        for i in range(len(self.layers)-1):
            self.singlebackward()
        self.backwardindex=1

    def trainexample(self, input, dout):
        self.valuemap[0] = input
        self.valuemap_unsigmoided[0] = input
        self.desiredoutput(dout)
        self.forwardpropagate()
        self.backpropagate()
        #print("real values:", self.valuemap[-1], "target values:", self.dout, "cost:",cost(self.valuemap[-1], dout))

    def updateparameters(self):
        for count1, ele1 in enumerate(self.weight_derivatives):
            for count2, ele2 in enumerate(ele1):
                for count3, ele3 in enumerate(ele2):
                    self.weights[count1][count2][count3] -= ele3*self.lrate
                    self.weight_derivatives[count1][count2][count3] = 0
                self.biases[count1][count2] -= self.bias_derivatives[count1][count2]*self.lrate
                self.bias_derivatives[count1][count2] = 0          

'''
dCost/dWeight=
dInitial/dWeight * dActivated/dInitial * dCost/dActivated =
Previous layer's output * dSigmoid(initial) * 2*(Activated-DesiredOutput)

dCost/dBias=
dInitial/dBias * dActivted/dInitial * dCost/dActivated =
1*dSigmoid(initial) * 2*(Activated-DesiredOutput)

dCost/dPreviousActivation=
dInitial/dPreviousActivation * dActivated/dInintial * dCost/dActivated =
Weight * dSigmoid(initial) * 2*(Activated-Desiredoutput)

(if not output neuron) replace 2*(Activated-DesiredOutput) with dCost/dThisActivation

However it will have to sum this over the next layer
'''

#main code
if __name__ == "__main__":
    digit_recognizer=NeuralNet(784, 16, 16, 10)
    #digit_recognizer.load("firstsave")
    digit_recognizer.batchsize(10)
    digit_recognizer.learningrate(3)
    images=mnist.openimage("train-images-idx3-ubyte", test=True)
    print("loaded images")
    labels=mnist.openlabel("train-labels-idx1-ubyte")
    print("loaded labels")
    imagedata=images[4] 
    labeldata=labels[2]

    def trainimage(index):
        label=labeldata[index]
        digit_recognizer.trainexample([i/256 for i in imagedata[index]], [0]*(label)+[1]+[0]*(9-label))

    shuffled = [i for i in range(60000)]
    shuffle(shuffled)
    for epoch in range(2):
        for batch in range(6000):
            for example in range(10):
                trainimage(shuffled[(batch)*10+example])
            digit_recognizer.updateparameters()
            print(epoch, batch*10)

    digit_recognizer.save("firstsave")
