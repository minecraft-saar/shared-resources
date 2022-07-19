import sys
import matplotlib.pyplot as plt
import numpy as np
from collections import defaultdict

path = None

if len(sys.argv) == 2:
    path = sys.argv[1]

if path is None:
    print("Only provide one argument. The file to be illustrated.")
    exit()

# pseudo tuple with numpy broadcasting
def t(*args): 
    return np.array([*args])

class BuildBlock:
    # only interested in x, y, z; other args automatically forwarded
    def __init__(self, x, y, z, _, __, ___): 
        self.blocks = [t(x, y, z)]

def get_dir_modifier(dir):
    return {
        1: t(1, 0, 0), # east
        2: t(-1, 0, 0), # west
        3: t(0, 1, 0), # north
        4: t(0, -1, 0) # south
    }[dir]

class BuildWall:
    def __init__(self, x, y, z, length, height, dir):
        dir_modfier = get_dir_modifier(dir)
        self.blocks = []
        for i in range(length):
            for j in range(height):
                self.blocks.append(t(x, y, z) + i * dir_modfier + t(0, 0, j))

class BuildPillar:
    def __init__(self, x, y, z, height):
        self.blocks = [t(x, y, z+i) for i in range(height)]

d = defaultdict(lambda: None)
d["!build-wall"] = BuildWall
d["!place-block"] = BuildBlock
d["!build-pillar"] = BuildPillar

def translate_line(l):
    l = l.replace("(", "")
    l = l.replace(")", "")
    l = l.split(" ")[:-3]
    c = d[l[0]]
    return c(*list(map(lambda el: int(float(el)), l[1:]))) if c is not None else None

# translate input to block wrapper classes
constr = []
with open(path) as f:
    lines = f.read().split("\n")
    lines = [l for l in lines if "(" in l and ")" in l]
    
    for l in lines:
        transl = translate_line(l)
        if transl is not None:
            constr.append(transl)

# collect blocks
all_blocks = set.union(*[set(map(tuple, c.blocks)) for c in constr])

# normalize coordinates
x_min = min(x for x, _, _ in all_blocks)
y_min = min(y for _, y, _ in all_blocks)
z_min = min(z for _, _, z in all_blocks)
all_blocks = map(lambda e: t(*e)-t(x_min,y_min,z_min), all_blocks)
all_blocks = set(map(tuple, all_blocks))

# create plotable numpy array
x_max = max(x for x, _, _ in all_blocks)
y_max = max(y for _, y, _ in all_blocks)
z_max = max(z for _, _, z in all_blocks)
one_max = max(x_max, y_max, z_max)

plt_data = []
for x in range(one_max+1):
    for y in range(one_max+1):
        for z in range(one_max+1):
            plt_data.append((x, y, z) in all_blocks)

voxels = np.array(plt_data).reshape(one_max+1, one_max+1, one_max+1)

# plot
ax = plt.figure().add_subplot(projection='3d')
#set_axes_equal(ax)
ax.voxels(voxels, edgecolor='k')

plt.show()