shader_type canvas_item;

uniform float offset = .5;
uniform vec2 direction = vec2(1.,1.);
const float radius = .1;
const float PI = 3.14159265358979323846;
const float aspect = 1.;

void fragment(){
	vec2 uv = UV.xy * vec2(aspect, 1.);
	vec2 norm_dir = normalize(direction);
	
	vec2 mouse = offset * vec2(aspect, 1.);
	vec2 mouseDir = norm_dir;
    vec2 origin = clamp(mouse - mouseDir * mouse.x / mouseDir.x, 0., 1.);
    
    float mouseDist = clamp(length(mouse - origin) 
        + (aspect - (abs(direction.x)) * aspect) / mouseDir.x, 0., aspect / mouseDir.x);
    
    if (mouseDir.x < 0.)
    {
        mouseDist = distance(mouse, origin);
    }

	float proj = dot(uv - origin, mouseDir);
	float dist = proj - mouseDist;

	vec2 linePoint = uv - dist * direction;
	if (dist > radius) 
    {
		COLOR.a = 0.;
//        COLOR = texture(TEXTURE, uv * vec2(1. / aspect, 1.));
//        COLOR.rgb *= pow(clamp(dist - radius, 0., 1.) * 1.5, .2);
    }
    else if (dist >= 0.)
    {
		// map to cylinder point
	    float theta = asin(dist / radius);
	    vec2 p2 = linePoint + direction * (PI - theta) * radius;
	    vec2 p1 = linePoint + direction * theta * radius;
	    uv = (p2.x <= 1. && p2.y <= 1. && p2.x > 0. && p2.y > 0.) ? p2 : p1;
        vec4 color1 = texture(TEXTURE, uv * vec2(1. / aspect, 1.));
		float alpha = step (0.3, 1. - texture(TEXTURE, uv).a);
		vec4 color2 =  alpha * texture(TEXTURE, UV);
		color1.a = 1. - alpha;
		color1.rgb = color1.rgb * (1.-alpha);
		COLOR = color1 + color2;
	    COLOR.rgb *= pow(clamp((radius - dist) / radius, 0., 1.), .2);
	}
    else 
    {
        vec2 p = linePoint + direction * (abs(dist) + PI * radius);
        uv = (p.x <= aspect && p.y <= 1. && p.x > 0. && p.y > 0.) ? p : uv;
        vec4 color1 = texture(TEXTURE, uv * vec2(1. / aspect, 1.));
		float alpha = step (0.3, 1. - texture(TEXTURE, uv).a);
		vec4 color2 =  alpha * texture(TEXTURE, UV);
		color1.a = 1. - alpha;
		color1.rgb = color1.rgb * (1.-alpha);
		COLOR = color1 + color2;
    }
}