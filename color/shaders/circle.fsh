vec4 circle(vec2 uv, vec2 center, float rad) {
	float d = length(center - uv) - rad;
	float t = clamp(d, 0.0, 1.0);
	return vec4(u_color.xyz, 1.0 - t);
}

void main( void ) {
	vec2 uv = gl_FragCoord.xy;
	vec2 lt = vec2(0,0);
	vec2 rt = vec2(u_size.x,0);
	vec2 lb = vec2(0,u_size.y);
	vec2 rb = vec2(u_size.x,u_size.y);
	float d = max(distance(u_center.xy, lt), max(distance(u_center.xy, rt), max(distance(u_center.xy, lb), distance(u_center.xy, rb))));
	float radius = d * (u_elapsed_time/u_total_animation_duration);

   // way 1
	// Background layer
	vec4 layer1 = SKDefaultShading();

	// Circle
	vec4 layer2 = circle(uv, u_center.xy, radius);

	// Blend the two
	gl_FragColor = mix(layer1, layer2, layer2.a);
   
   
   // way2
//   // Circle
//   vec4 layer = circle(uv, u_center.xy, radius);
//   
//   // Blend the two
//   gl_FragColor = mix(SKDefaultShading(), layer, layer.a);   
}

