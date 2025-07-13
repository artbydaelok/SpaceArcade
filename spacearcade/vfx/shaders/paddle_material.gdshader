shader_type canvas_item;

uniform sampler2D gradient_texture;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);

	// Grayscale based on average
	float average = (original_color.r + original_color.g + original_color.b) / 3.0;
	vec4 grayscale_color = vec4(vec3(average), original_color.a);

	// Creates a vector2 based on the greyscale average
	vec2 grayscale = vec2(average);
	// and it gets used as a UV to sample the gradient texture
	vec4 final_color = texture(gradient_texture, grayscale);

	COLOR.rgb = final_color.rgb;
}
