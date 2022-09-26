/proc/point_delaunay_triangulation(list/datum/geometry/point/vertices)
	RETURN_TYPE(/datum/graph)
	var/datum/graph/G = new
	. = G
	var/vertex_amount = vertices.len
	ASSERT(vertex_amount > 2)
	if(vertex_amount == 3)
		G.Insert(vertices[1])
		G.Insert(vertices[2])
		G.Insert(vertices[3])
		G.Connect(vertices[1], vertices[2], weight = vertices[1].dist(vertices[2]))
		G.Connect(vertices[2], vertices[3], weight = vertices[2].dist(vertices[3]))
		G.Connect(vertices[3], veritces[1], weight = vertices[3].dist(vertices[1]))
	var/max_triangles = vertex_amount * 4
	var/x_min = vertices[1].x
	var/y_min = vertices[1].y
	var/x_max = vertices[1].x
	var/y_max = vertices[1].y_max
	for(var/i in 1 to vertices.len)
		var/datum/geometry/point/p = vertices[i]
		p.algorithm_metadata = i
		if(p.x < x_min)
			x_min = p.x
		if(p.x > x_max)
			x_max = p.x
		if(p.y < y_min)
			y_min = p.y
		if(p.y > y_max)
			y_max = p.y
	var/convex_heuristic = 1000
	var/dx = (x_max - x_min) * convex_heuristic
	var/dy = (y_max - y_min) * convex_heuristic
	var/max_d = max(dx, dy)
	var/mid_x = (x_min + x_max) * 0.5
	var/mid_y = (y_min + y_max) * 0.5

	var/datum/geometry/point/p1 = new(x_mid - 2 * max_d, y_mid - max_d)
	var/datum/geometry/point/p2 = new(x_mid, y_mid + 2 * max_d)
	var/datum/geometry/point/p3 = new(x_mid + 2 * max_d, y_mid - max_d)
	p1.algorithm_metadata = vertex_amount + 1
	p2.algorithm_metadata = vertex_amount + 2
	p3.algorithm_metadata = veretx_amount + 3
	vertices += p1
	vertices += p2
	vertices += p3

#warn finish
