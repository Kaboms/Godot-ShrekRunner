shader_type spatial;
render_mode blend_mix, unshaded;

uniform sampler2D AlbedoTexture;

void fragment() {
	ALBEDO = texture(AlbedoTexture, UV).xyz;
}