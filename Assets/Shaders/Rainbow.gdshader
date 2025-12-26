shader_type canvas_item;

uniform vec4 can_boost_color : source_color = vec4(0.0, 1.0, 0.5, 1.0);
uniform vec4 no_boost_color : source_color = vec4(1.0, 0.2, 0.2, 1.0);
uniform bool can_boost = false;
uniform bool is_full = false;

void fragment() {
    // 1. Récupérer la texture et sa transparence
    vec4 tex_color = texture(TEXTURE, UV);

    // 2. CALCUL DE L'ANGLE (Coordonnées Polaires)
    // On centre les UV de (0 à 1) vers (-0.5 à 0.5)
    vec2 center_uv = UV - vec2(0.5);
    // atan2 renvoie l'angle en radians entre -PI et PI
    float angle = atan(center_uv.y, center_uv.x);

    // 3. ARC-EN-CIEL CIRCULAIRE
    // On normalise l'angle pour l'utiliser dans le cosinus
    // On ajoute TIME pour faire tourner l'arc-en-ciel sur le cercle
    float hue = (angle / 6.28318) + TIME * 0.5;
    vec3 rainbow = 0.5 + 0.5 * cos(6.28318 * (vec3(hue) + vec3(0.0, 0.33, 0.67)));

    vec4 final_color;

    // 4. LOGIQUE DE COULEUR
    if (COLOR.r > 0.1) {
        if (is_full) {
            final_color = vec4(rainbow, tex_color.a);
        } else if (can_boost) {
            final_color = can_boost_color;
        } else {
            final_color = no_boost_color;
        }
    } else {
        final_color = vec4(0.0, 0.0, 0.0, tex_color.a);
    }

    // Appliquer la couleur finale en respectant la forme du sprite
    COLOR = final_color;
    COLOR.a *= tex_color.a;
}