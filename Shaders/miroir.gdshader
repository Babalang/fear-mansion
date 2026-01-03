shader_type spatial;
render_mode unshaded, cull_back;

// ===== ÉCRAN =====
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

// ===== TEXTURES =====
uniform sampler2D crack_texture; // texture noir/blanc de fissures
uniform sampler2D dirt_texture;  // texture de saleté

// ===== PARAMÈTRES =====
uniform float reflect_strength : hint_range(0.0, 1.0) = 0.9;
uniform float distortion : hint_range(0.0, 0.1) = 0.03;
uniform float crack_strength : hint_range(0.0, 1.0) = 0.8;
uniform float dirt_strength : hint_range(0.0, 1.0) = 0.6;

uniform float pulse_speed : hint_range(0.0, 5.0) = 1.5;
uniform float pulse_amount : hint_range(0.0, 0.3) = 0.08;

uniform vec3 tint : source_color = vec3(0.85, 0.9, 1.0);

void fragment() {
	vec2 uv = SCREEN_UV;

	// ===== PULSATION MALAISE =====
	float pulse = sin(TIME * pulse_speed) * pulse_amount;

	// ===== DISTORSION MIROIR =====
	vec2 distortion_offset = NORMAL.xy * (distortion + pulse);

	// ===== LECTURE ÉCRAN =====
	vec3 reflected = texture(
		SCREEN_TEXTURE,
		uv + distortion_offset
	).rgb;

	// ===== FISSURES =====
	float cracks = texture(crack_texture, UV * 2.0).r;
	reflected = mix(reflected, reflected * 0.2, cracks * crack_strength);

	// ===== SALETÉ =====
	float dirt = texture(dirt_texture, UV * 1.5).r;
	reflected = mix(reflected, reflected * 0.5, dirt * dirt_strength);

	// ===== FRESNEL (effet inquiétant sur les bords) =====
	float fresnel = pow(1.0 - abs(dot(NORMAL, VIEW)), 2.5);

	ALBEDO = reflected * tint * reflect_strength * (0.8 + fresnel * 0.5);
}
