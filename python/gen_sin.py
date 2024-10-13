import numpy as np
import matplotlib.pyplot as plt

for i in range(1, 2048, 1):
    x = i / 2048 * 2 * np.pi
    y = (np.sin(x) + 1) * 32767
    result = round(y)
    print(f"{result:04X}")
