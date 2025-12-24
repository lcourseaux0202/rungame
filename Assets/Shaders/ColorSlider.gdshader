shader_type canvas_item;

// Fonction pour convertir le HSV en RGB
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    // On utilise l'UV.x (de 0 à 1) pour définir la teinte (Hue)
    vec3 color = hsv2rgb(vec4(UV.x, 1.0, 1.0, 1.0).rgb);
    COLOR = vec4(color, 1.0);
}