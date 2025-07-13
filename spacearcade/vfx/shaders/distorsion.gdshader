shader_type canvas_item;

uniform sampler2D noise_tex : repeat_enable;

uniform float intensity = 0.1;
uniform float speed = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 original_uv = UV;

	// This creates a float based on the noise values that vary over time.
	vec4 noise = texture(noise_tex, UV + TIME * speed);

	vec2 distorted_uv = original_uv + noise.rg * intensity;
	vec4 color = texture(TEXTURE, distorted_uv);
	COLOR = vec4(color.rgb, 1.0);
	COLOR.a = color.a;

}