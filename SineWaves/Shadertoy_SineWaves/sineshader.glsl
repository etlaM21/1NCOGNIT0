//==============================================================================
// Welcome to shader authoring in Spark AR Studio!
//==============================================================================

#import <gradients>
#import <sdf>

#define M_PI 3.1415926535897932384626433832795
#define M_TWOPI 3.1415926535897932384626433832795*2.0

using namespace std;

const float width = .15;

// const vec2 boxSize = vec2(.015, .025);

const float sinScale = .3;

// Get Brightness
// Source: https://github.com/hughsk/glsl-luma
float luma(vec3 color) {
  return dot(color, vec3(0.299, 0.587, 0.114));
}

// This function description will appear in the inspector
// @main
// @param cameraTex The camera texture to sample from (could also be an image!)
// @param backgroundColor The background color as Vec3 (RGB)
// @param boxSizeScale The scaling of the individual sine waves
vec4 main(Texture2d cameraTex, vec3 backgroundColor, float boxSizeScale){
    vec2 ratio = vec2(getRenderTargetSize().y / getRenderTargetSize().x, getRenderTargetSize().x / getRenderTargetSize().y);
    vec2 boxSize = vec2(.015 * ratio.x, .025);
    vec2 usedBoxSize = boxSize * boxSizeScale;
    // Work w/ camera tex input
    // Get the uv's
    vec2 uv = fragment(getVertexTexCoord());

    // We will get the color from the texture by using the sample function. 
    // The glsl equvalent to this is texture2D(tex, uv);
    // vec4 camColor = cameraTex.sample(uv / 1.5);
    // Pixaltion Shader Source: http://coding-experiments.blogspot.com/2010/06/pixelation.html
    float Pixels = 512.0;
    float dx = (1.0 * usedBoxSize.x);
    float dy =  (1.0 * usedBoxSize.y);
    vec2 Coord = vec2(dx * floor(uv.x / dx),
                      dy * floor(uv.y / dy));
    vec4 camColor = cameraTex.sample(Coord);

    // Invert the color's rgb
    //color.rgb = 1.0 - color.rgb;

    // Normalize
    vec2 fragCoord = fragment(floor(getRenderTargetSize() * getVertexTexCoord())) / getRenderTargetSize();
    // creating boxes
    float x = fragCoord.x / usedBoxSize.x;
    float y = fragCoord.y / usedBoxSize.y;
    float x_index = x - floor(x);
    float y_index = y - floor(y);
    // Sin magic
    float s;
    float y_index_sine = y_index - .5;
    float pxBrightness = abs(luma(camColor.rgb) - (backgroundColor.r));
    float sinewave = smoothstep(y_index_sine, y_index_sine +.1, sin((x) * M_PI) * (sinScale * pxBrightness));
    float sinewavemask =  smoothstep(y_index_sine + width, y_index_sine + width +.1, sin((x) * M_PI) * (sinScale * pxBrightness));
    s = sinewave;
    s = s - sinewavemask;
    // Output
    // vec3 sinecolor = mix(vec3(0.0), vec3(1.0), s);
    vec3 sinecolor = mix(backgroundColor, camColor.rgb, s);
    vec4 Color = vec4(sinecolor.rgb, 1.0);
    // Color = camColor;
    // Color = vec4(sinewave-sinewavemask,sinewave-sinewavemask, sinewave-sinewavemask, 1.0);
    return Color;
}
