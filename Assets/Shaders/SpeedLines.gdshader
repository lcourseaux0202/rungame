shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float line_count : hint_range(1.0, 100.0) = 20.0;
uniform float speed : hint_range(0.0, 10.0) = 2.0;
uniform float line_density : hint_range(0.0, 1.0) = 0.5;

// Fonction de hash simple pour générer de l'aléatoire
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

void fragment() {
    vec2 uv = UV;

    // On décale l'UV X vers la droite pour que le mouvement semble aller vers la gauche
    float time_shift = TIME * speed;

    // On divise l'espace vertical en "cellules" pour chaque ligne potentielle
    float vertical_id = floor(uv.y * line_count);

    // On crée une valeur aléatoire pour chaque ligne (vitesse et décalage différents)
    float random_offset = hash(vertical_id);
    float line_pos = fract(uv.x + time_shift + random_offset);

    // Création du trait fin
    // On utilise step() pour définir la longueur et la présence de la ligne
    float line_mask = step(line_density, line_pos);

    // On affine le trait verticalement (pour ne pas remplir toute la cellule)
    float thickness_mask = step(0.9, fract(uv.y * line_count));

    float final_alpha = line_mask * thickness_mask;

    COLOR = vec4(line_color.rgb, line_color.a * final_alpha);
}