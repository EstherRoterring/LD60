shader_type canvas_item;

uniform int pitch_id;
uniform sampler2D pitch_colors_texure: filter_nearest;

void vertex() {
	// Called for every vertex the material is visible on.
}

ivec2 colorIDToTextureCoordinate(int colorID, ivec2 texture_res)
{
	int col = clamp(colorID % texture_res.x, 0, texture_res.x - 1);
	int row = clamp(colorID / texture_res.x, 0, texture_res.y - 1);
	return ivec2(col, row);
}

bool colors_match(vec4 ref_color, sampler2D sampler, ivec2 coord)
{
	return texelFetch(sampler, coord, 0).rgb == ref_color.rgb;
}

void fragment() {
	// Called for every pixel the material is visible on.
	ivec2 color_texture_res = textureSize(pitch_colors_texure, 0);
	vec4 main_c = texture(TEXTURE, UV);	
	if (main_c.a == 0.0) discard;
	
	// we expext the main texture to be colored in the 
	// first three colors of the color texture
	int input_color_id = 0;
	input_color_id += int(colors_match(main_c, pitch_colors_texure, ivec2(1,0))) * 1;
	input_color_id += int(colors_match(main_c, pitch_colors_texure, ivec2(2,0))) * 2;
	
	ivec2 target_color_coord = colorIDToTextureCoordinate(pitch_id * 3 + input_color_id, color_texture_res);
	vec4 remapped_c = texelFetch(pitch_colors_texure, target_color_coord, 0);
	COLOR = remapped_c;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
