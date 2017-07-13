'''
My own personal implementations of common ML algorithms.
Primarily intended for reference and personal understanding of how
everything works. (Use Scikit-Learn...!)
'''
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


class LinearRegressor:
    '''
    A first try at a simple linear regression model on one independent
    variable using gradient decent.
        Test data is a list of (x,y) tuples.
    '''
    def __init__(self, alpha=0.005, n_iterations=4000, decimal_places=2):
        self.theta0 = None
        self.theta1 = None
        # "training rate" (alpha) determines how big a change is made on each
        # iteration. If it is too small the algorithm will take too long to
        # find an answer and if it is too large the result can blow up.
        self.alpha = alpha
        self.n_iterations = n_iterations
        self.decimal_places = decimal_places

        # Used to monitor performance via plotting
        self.JoverT = []

    def cost_function(self):
        '''Standard linear regression cost function'''
        J = [(self.theta0 + self.theta1 * point[0] - point[1]) ** 2
             for point in self.training_data]
        return sum(J) / (2 * self.data_len)

    def fit(self, training_data, verbose=False):
        '''Fit the model to the training data using gradient decent'''
        # Convert training data to a numpy array
        data = np.asarray(training_data, dtype=np.float64)
        self.training_data = data
        self.data_len = len(data)
        # Initialise the hypothesis to hθ(x) = 0 + 0x
        self.theta0 = 0
        self.theta1 = 0

        for n in range(self.n_iterations):
            delta0 = sum([(self.theta0 + self.theta1 * t[0] - t[1])
                         for t in self.training_data]) / self.data_len
            delta1 = sum([(self.theta0 + self.theta1 * t[0] - t[1]) * t[0]
                          for t in self.training_data]) / self.data_len

            _theta0 = self.theta0 - self.alpha * delta0
            _theta1 = self.theta1 - self.alpha * delta1

            self.theta0, self.theta1 = _theta0, _theta1

            # if verbose:
            #     self.JoverT.append(self.cost_function())

        self.theta0 = round(self.theta0, self.decimal_places)
        self.theta1 = round(self.theta1, self.decimal_places)

        if verbose:
            print("Regression complete:")
            print("θ0={}, θ1={}, J={}".format(
                    self.theta0, self.theta1, self.cost_function()))
            print("\n--> hθ(x) = {} + {}x".format(self.theta0, self.theta1))

    def predict(self, x_value):
        '''Make a prediction using the fitted model'''
        if self.theta0 and self.theta1:
            return self.theta0 + self.theta1 * x_value
        else:
            print('You must fit the model before making predictions')

    def plot(self):
        '''Visualise the training data and the model'''
        tset = pd.DataFrame(self.training_data)
        tset.columns = ['x', 'y']
        xmax = int(max(tset['x']))
        tset.plot(kind='scatter', x='x', y='y', figsize=(8, 6))
        model = [(self.theta0 + self.theta1 * x) for x in range(xmax)]
        plt.plot(model)
        plt.show()
