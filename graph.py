# File: draw.py
# The actual image-generation script

import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

import numpy as np

# Load data from CSV
data = np.genfromtxt(
    'graph-results.csv',
    delimiter=',',
    names=True,
)

# Start an XKCD graph
plt.xkcd()

# Make the image pretty
figure = plt.figure()
figure.set_dpi(300)
figure.set_size_inches(8, 7.5)

figure.suptitle(
    'Scaling containers on AWS\n@iamvlaaaaaaad',
    fontsize=16,
)
plt.xlabel('Minutes')
plt.ylabel('Containers')

plt.xticks(np.arange(0, 70, step=10))

# Colors from https://jfly.uni-koeln.de/color/
plt.plot(
    data['EKS'],
    label="EKS with EC2",
    color=(0.8, 0.4, 0.7),
)
plt.plot(
    data['TunedFargate'],
    label="Tuned Fargate",
    color=(0.9, 0.6, 0.0),
)
plt.plot(
    data['FargateOnECS'],
    label="Fargate on ECS",
    color=(0.0, 0.45, 0.70),
)
plt.plot(
    data['FargateOnEKS'],
    label="Fargate on EKS",
    color=(0.35, 0.70, 0.90),
)

# Add a legend to the graph
#  using default labels
plt.legend(
    loc='lower right',
    borderaxespad=1
)

# Export the image
figure.savefig('containers.svg')
figure.savefig('containers.png')
