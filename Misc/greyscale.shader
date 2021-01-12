shader_type canvas_item;

uniform bool enabled = false;

void fragment() {

	vec4 tex = texture(TEXTURE, UV);
	
	if (!enabled) {
		COLOR = tex
	} else {
	
		float average = (tex.r+tex.g+tex.b)/3f;
		
		if (tex.a > 0f) {
			COLOR = vec4(average, average, average, 1);
		} else {
			COLOR = vec4(1, 1, 1, 0);
		}
	}
}