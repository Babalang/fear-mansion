shader_type spatial;
render_mode unshaded, cull_disabled;

// Couleur du halo et du glow
uniform vec3 base_color : source_color = vec3(1.0, 0.2, 0.1);

// Intensité du glow interne
uniform float glow_strength = 3.0;

// Vitesse de pulsation
uniform float pulse_speed = 2.0;

// Amplitude de pulsation
uniform float pulse_intensity = 1.5;

// Taille du halo externe
uniform float halo_radius = 1.5;

// Douceur du halo
uniform float halo_falloff = 2.0;

// Bruit organique
uniform float noise_scale = 4.0;
uniform float noise_strength = 0.4;

// --- Bruit simple (hash) ---
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void fragment() {
    vec3 col = base_color;

    // --- Pulsation organique ---
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);
    pulse = mix(1.0, pulse_intensity, pulse);

    // --- Glow interne ---
    vec3 glow = col * glow_strength * pulse;

    // --- Halo externe basé sur la normale ---
    float halo = pow(1.0 - abs(dot(NORMAL, VIEW)), halo_falloff);
    halo = clamp(halo * halo_radius, 0.0, 1.0);

    // --- Bruit organique ---
    float n = noise(UV * noise_scale + TIME * 0.5);
    glow *= 1.0 + n * noise_strength;

    // --- Sorties Godot 4 ---
    ALBEDO = col;
    EMISSION = glow + col * halo;
}
