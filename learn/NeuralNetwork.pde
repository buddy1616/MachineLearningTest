class NeuralNetwork
{
  int inputNodes;
  int hiddenNodes;
  int outputNodes;
  NeuralNetwork(int inp, int hid, int out)
  {
    inputNodes = inp;
    hiddenNodes = hid;
    outputNodes = out;
  }
}


class Neuron
{
  float[] weights;
}
