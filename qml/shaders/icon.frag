#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec4 color;
} ubuf;

layout(binding = 2) uniform sampler2D maskSource;

void main()
{
    fragColor = ubuf.color * texture(maskSource, qt_TexCoord0).a * ubuf.qt_Opacity;
}
