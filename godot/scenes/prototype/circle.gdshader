shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float r =  0.25 * (1.0 + 1.0);
	float ab = length(UV - vec2(0.5, 0.5));
	float alpha = 1.0 - step(r,ab);
	COLOR = vec4(1.0, 1.0, 0.0, alpha);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
