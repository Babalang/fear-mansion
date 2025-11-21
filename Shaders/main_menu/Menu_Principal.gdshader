shader_type canvas_item;

uniform float time;

// Intensité des scratches
uniform float scratch_strength : hint_range(0.0, 1.0) = 0.6;

// Intensité des interférences
uniform float interference_strength : hint_range(0.0, 1.0) = 1.4;

// Petit bruit
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 uv = UV;

    // ========= INTERFERENCE (plus forte) =========
    float interBand = fract(uv.y + time * 0.05);
	float inter1 = smoothstep(0.0, 0.15, fract(uv.y * 3.0 + time * 0.05));
	float inter2 = smoothstep(0.0, 0.1, fract(uv.y * 7.0 + time * 0.1));
	float inter3 = smoothstep(0.0, 0.2, fract(uv.y * 12.0 + time * 0.03));

	float inter = (inter1 * 0.6 + inter2 * 0.8 + inter3 * 0.4) * interference_strength;

	uv.x += inter * 0.01;


    // ========= SCRATCHS (beaucoup plus nombreux) =========
    float scratchNoise = rand(vec2(floor(uv.x * 450.0), floor(time * 1.2)));
    float scratchMask = step(0.95, scratchNoise);
    uv.y += scratchMask * (0.015 * scratch_strength);

    // ========= TEXTURE =========
    vec4 col = texture(TEXTURE, uv);

    // ========= Contraste léger =========
    col.rgb = pow(col.rgb, vec3(0.96));

    COLOR = col;
}
