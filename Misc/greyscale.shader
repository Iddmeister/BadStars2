shader_type canvas_item;

void fragment() {
	
	vec4 tex = texture(TEXTURE, UV);
	float average = (tex.r+tex.g+tex.b)/3f;
	
	COLOR = vec4(average, average, average, 1);
	
}