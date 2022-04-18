import numpy as np
import matplotlib.pyplot as plt

#Build up 3D image
fig = plt.figure(figsize=(9,9), dpi=80)
ax = fig.gca(projection = '3d')

r = np.array([213, 159, 191, 250, 250, 254, 83, 235, 235, 225, 168, 71, 53, 58, 55, 136, 82, 106, 62, 76, 137, 41, 31, 77, 153, 238, 251, 246, 255, 95, 243])
g = np.array([107, 16, 33, 54, 195, 153, 61, 195, 200, 209, 162, 100, 114, 185, 162, 197, 247, 227, 122, 142, 151, 40, 21, 36, 65, 29, 65, 117, 247, 14, 83])
b = np.array([103, 11, 22, 39, 161, 57, 39, 134, 51, 72, 39, 27, 32, 34, 59, 153, 175, 185, 134, 254, 206, 58, 182, 99, 186, 224, 197, 174, 250, 25, 103])

colors=[]
for i in range(0, len(r)):
    rc = r[i]/255
    gc = g[i]/255
    bc = b[i]/255
    colors.append([rc, gc, bc]) 

ax.scatter(r, g, b, s=200, c=colors, marker= 'o')
plt.show()





