shader_type canvas_item;

uniform vec4 light_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float radius : hint_range(0.0, 1.5) = 1.0;
uniform float softness : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv) / radius;
    float intensity = smoothstep(1.0, 1.0 - softness, dist);
    COLOR = light_color * (1.0 - intensity);
}