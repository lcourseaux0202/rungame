shader_type canvas_item;

uniform vec4 can_boost_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 no_boost_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool can_boost = false;
uniform bool is_full = false;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    float hue = UV.x + TIME * 0.5;
    vec3 rainbow = 0.5 + 0.5 * cos(6.28318 * (vec3(hue) + vec3(0.0, 0.33, 0.67)));

    if (COLOR.r > 0.5) {
        if (is_full) {
            COLOR = vec4(rainbow, tex_color.a);
		} else if (can_boost){
			COLOR = can_boost_color;
        } else {
            COLOR = no_boost_color;
        }
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, tex_color.a);
    }
}