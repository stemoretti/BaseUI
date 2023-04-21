#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 pos;
    float radius;
    vec4 color;
    float dpi;
} ubuf;

layout(binding = 2) uniform sampler2D maskSource;

void main()
{
    if (distance(gl_FragCoord.xy / ubuf.dpi, ubuf.pos + ubuf.radius) < ubuf.radius)
        fragColor = ubuf.color * texture(maskSource, qt_TexCoord0).a * ubuf.qt_Opacity;
    else
        fragColor = texture(maskSource, qt_TexCoord0).rgba * ubuf.qt_Opacity;
}
