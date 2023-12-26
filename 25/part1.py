import networkx as nx

data = open(0).readlines()

g = nx.Graph()

for line in data:
    [name,rest] = line.split(':')
    others = rest[1:].split()
    g.add_node(name)
    for other in others:
        g.add_edge(name, other)

nodes = list(g.nodes)
edges = nx.minimum_edge_cut(g)
g.remove_edges_from(edges)
group_1_size = len(nx.node_connected_component(g,nodes[0]))
print(group_1_size * (len(nodes) - group_1_size))
