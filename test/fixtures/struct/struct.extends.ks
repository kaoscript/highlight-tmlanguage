struct Point {
    x: Number
    y: Number
}

struct Point3D extends Point {
	z: Number
}

var dyn point = Point3D(0.3, 0.4, 0.5)

console.log(point.x, point.y, point.z)