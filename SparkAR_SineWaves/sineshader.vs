#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795
#define M_TWOPI 3.1415926535897932384626433832795*2.0

uniform vec2 u_resolution;
uniform float u_time;

float width = 0.1;

vec2 boxSize = vec2(.025, .025);

float sinScale = .3 * sin(u_time);

void main()
{
    // Normalizing
    vec2 coord = (gl_FragCoord.xy / u_resolution) -.5;
    // creating boxes
    float x = coord.x / boxSize.x;
    float y = coord.y / boxSize.y;
    float x_index = x - floor(x);
    float y_index = y - floor(y);
    // Sin magic
    float s;
    float y_index_sine = y_index - .5;
    float sinewave = smoothstep(y_index_sine, y_index_sine +.1, sin((x) * M_PI) * sinScale);
    float sinewavemask =  smoothstep(y_index_sine + width, y_index_sine + width +.1, sin((x) * M_PI) * sinScale);
    s -= sinewavemask;
    s += sinewave;
    // float s = step(y_index + 1. +y, sin((x) * M_PI) * sinScale) - step(y_index + y + 1. + width, sin((x) * M_PI) * sinScale);
    // s += step(y_index + y + 2., sin((x) * M_PI) * sinScale) - step(y_index + y + 2. + width, sin((x) * M_PI) * sinScale);
    vec3 color = mix(vec3(0.0), vec3(1.0), s);
    gl_FragColor = vec4(color, 1.0);
}