# Digit Recognizer
This project revolves around a neural network that classifies handwritten digits from the MNIST dataset. The neural network returns, for each digit 0 to 9, a value between 0 and 1 representing its confidence that the handwritten number is that digit. This project was built with only built-in Python libraries (math, random, time, tkinter, and no PyTorch/Tensorflow).

## Running the Digit Recognizer
To use the neural net to classify digits, run `gui.py`. A window will appear, and by clicking the load button, a new digit will appear, along with its true value, the neural network's guess at its value, and the neural network's confidence that its guess was correct.

## Training the Digit Recognizer
To train the neural net on the MNIST dataset, run `net.py`, and its parameters will be stored in `firstsave`.

## Using the `NeuralNet` Class
- **Initialization:** one can import `net.py` and initialize a neural net, with an arbitrary depth and number of neurons per layer, with `net = NeuralNet(layer1_width, layer2_width,...,layern_width)`
- **Training:** the neural net can be trained with `net.train_example(example)`, where example is a `layer1_width'-wide array of floats, and parameters can be updated according to training results with `net.update_parameters()`
- **Inference:** the neural net can be run on `example`, with the result stored in `result` with `net.value_map[0] = example; net.forwardpropagate(); result=net.value_map[-1]`
