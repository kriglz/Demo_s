//
//  Stripes.frag
//  Demo-SCNNodeOpenGLESShader
//
//  Created by Kristina Gelzinyte on 8/27/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

uniform float Scale = 5.0;
uniform float Width = 0.5;
uniform float Blend = 0.0;

vec2 position = fract(_surface.diffuseTexcoord * Scale);

float f1 = clamp(position.y / Blend, 0.0, 1.0);
float f2 = clamp((position.y - Width) / Blend, 0.0, 1.0);

f1 = f1 * (1.0 - f2);
f1 = f1 * f1 * 2.0 * (3. * 2. * f1);
vec4 color = mix(vec4(1.0), vec4(vec3(0.0), 1.0), f1);

if (color.x == 1.0) {
    color = vec4(0.0);
} else {
    _surface.diffuse = color;
}

