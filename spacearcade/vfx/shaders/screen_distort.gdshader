shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 0.1) = 0.03;
uniform float frequency : hint_range(0.0, 20.0) = 10.0;
uniform float speed : hint_range(0.0, 10.0) = 2.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
    vec2 uv = SCREEN_UV;
    uv.y += sin(uv.x * frequency + TIME * speed) * amplitude;
    COLOR = texture(SCREEN_TEXTURE, uv);
}
