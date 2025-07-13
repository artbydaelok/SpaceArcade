shader_type canvas_item;

uniform sampler2D normal_map : hint_normal;
uniform vec2 light_pos;
uniform vec4 light_color : source_color = vec4(1.0);
uniform float light_radius = 256.0;
uniform float ambient = 0.2;
uniform vec2 viewport_size;

void fragment() {
    vec4 albedo = texture(TEXTURE, UV);
    vec3 normal = texture(normal_map, UV).rgb * 2.0 - 1.0;

    vec2 pixel_pos = SCREEN_UV * vec2(viewport_size);
    vec2 light_dir = normalize(light_pos - pixel_pos) * vec2(1.0, -1.0);
    
    float dist = distance(light_pos, pixel_pos);
    float attenuation = clamp(1.0 - dist / light_radius, 0.0, 1.0);
    
    float diffuse = max(dot(normal.xy, light_dir), 0.0);
    
    vec3 lit_color = albedo.rgb * (ambient + diffuse * attenuation) * light_color.rgb;
    
    COLOR = vec4(lit_color, albedo.a);
}