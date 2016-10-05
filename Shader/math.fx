#ifndef InvLog2
#   define InvLog2 3.32192809489f
#endif

#ifndef InvPIE
#   define InvPIE 0.318309886142f
#endif

#ifndef InvPIE8
#   define InvPIE8 0.039788735767f
#endif

#ifndef InvPIE4
#   define InvPIE4 0.079577471535f
#endif

#ifndef PI
#   define PI 3.141592654f
#endif

#ifndef PI_2
#   define PI_2 (3.141592654f * 2.0)
#endif

#ifndef EPSILON
#   define EPSILON 1e-5
#endif

#define MIDPOINT_8_BIT (127.0f / 255.0f)

float3 srgb2linear(float3 rgb)
{
    const float ALPHA = 0.055f;
    return rgb < 0.04045f ? rgb / 12.92f : pow((rgb + ALPHA) / (1 + ALPHA), 2.4f);
}

float3 linear2srgb(float3 srgb)
{
    const float ALPHA = 0.055f;
    return srgb < 0.0031308f ? 12.92f * srgb : (1 + ALPHA) * pow(srgb, 1.0f / 2.4f) - ALPHA;
}

float4 srgb2linear(float4 c)
{
    return float4(srgb2linear(c.rgb), c.a);
}

float4 linear2srgb(float4 c)
{
    return float4(linear2srgb(c.rgb), c.a);
}

float3 rgb2ycbcr(float3 col)
{
    float3 encode;
    encode.x = dot(float3(0.299, 0.587, 0.114),   col.rgb);
    encode.y = dot(float3(-0.1687, -0.3312, 0.5), col.rgb);
    encode.z = dot(float3(0.5, -0.4186, -0.0813), col.rgb);
    return float3(encode.x, encode.y * MIDPOINT_8_BIT + MIDPOINT_8_BIT, encode.z * MIDPOINT_8_BIT + MIDPOINT_8_BIT);
}

float3 ycbcr2rgb(float3 YCbCr)
{
    YCbCr = float3(YCbCr.x, YCbCr.y / MIDPOINT_8_BIT - 1, YCbCr.z / MIDPOINT_8_BIT - 1);
    float R = YCbCr.x + 1.402 * YCbCr.z;
    float G = dot(float3( 1, -0.3441, -0.7141 ), YCbCr.xyz );
    float B = YCbCr.x + 1.772 * YCbCr.y;
    return float3(R, G, B);
}

float3 rgb2xyz(float3 rgb)
{
    const float3x3 m = float3x3 (
        0.5141364, 0.3238786, 0.16036376,
        0.265068, 0.67023428, 0.06409157,
        0.0241188, 0.1228178, 0.84442666);
    return mul(m, rgb);
}

float3 xyz2rgb(float3 xyz)
{
    const float3x3 m = float3x3(
        2.5651, -1.1665, -0.3986,
        -1.0217, 1.9777, 0.0439,
        0.0753, -0.2543, 1.1892);
    return mul(m, xyz);
}

float3 xyz2yxy(float3 xyz)
{
    float w = xyz.r + xyz.g + xyz.b;
    if (w > 0.0)
    {
        float3 Yxy;
        Yxy.r = xyz.g;
        Yxy.g = xyz.r / w;
        Yxy.b = xyz.g / w;
        return Yxy;
    }
    else
    {
        return float3(0.0, 0.0, 0.0);
    }
}

float3 yxy2xyz(float3 Yxy)
{
    float3 xyz;
    xyz.g = Yxy.r;
    if (Yxy.b > 0.0f)
    {
        xyz.r = Yxy.r * Yxy.g / Yxy.b;
        xyz.b = Yxy.r * (1.0f - Yxy.g - Yxy.b) / Yxy.b;
    }
    else
    {
        xyz.rb = float2(0.0, 0.0);
    }
    return xyz;
}

float3 rgb2hsv(float3 rgb) 
{
    float minValue = min(min(rgb.r, rgb.g), rgb.b);
    float maxValue = max(max(rgb.r, rgb.g), rgb.b);
    float d = maxValue - minValue;

    float3 hsv = 0.0;
    hsv.b = maxValue;
    if (d != 0) 
    {
        hsv.g = d / maxValue;

        float3 delrgb = (((maxValue.xxx - rgb) / 6.0) + d / 2.0) / d;
        if      (maxValue == rgb.r) { hsv.r = delrgb.b - delrgb.g; }
        else if (maxValue == rgb.g) { hsv.r = 1.0 / 3.0 + delrgb.r - delrgb.b; }
        else if (maxValue == rgb.b) { hsv.r = 2.0 / 3.0 + delrgb.g - delrgb.r; }

        if (hsv.r < 0.0) { hsv.r += 1.0; }
        if (hsv.r > 1.0) { hsv.r -= 1.0; }
    }
    return hsv;
}

float3 hsv2rgb(float3 hsv)
{
    float h = hsv.r;
    float s = hsv.g;
    float v = hsv.b;

    float3 rgb = v;
    if (hsv.g != 0.0)
    {
        float h_i = floor(6 * h);
        float f = 6 * h - h_i;

        float p = v * (1.0f - s);
        float q = v * (1.0f - f * s);
        float t = v * (1.0f - (1.0f - f) * s);

        if (h_i == 0) { rgb = float3(v, t, p); }
        else if (h_i == 1) { rgb = float3(q, v, p); }
        else if (h_i == 2) { rgb = float3(p, v, t); }
        else if (h_i == 3) { rgb = float3(p, q, v); }
        else if (h_i == 4) { rgb = float3(t, p, v); }
        else { rgb = float3(v, p, q); }
    }
    return rgb;
}

float luminance(float3 rgb)
{
    const float3 lumfact = float3(0.2126f, 0.7152f, 0.0722f);
    return dot(rgb, lumfact);
}

float pow2(float x)
{
    return x * x;
}

const static float3x3 InverseLogLuv = float3x3(
    6.0013,    -2.700,    -1.7995,
    -1.332,    3.1029,    -5.7720,
    .3007,    -1.088,    5.6268);

float3 DecodeLogLuv(in float4 vLogLuv)
{
    float Le = vLogLuv.z * 255 + vLogLuv.w;
    float3 Xp_Y_XYZp;
    Xp_Y_XYZp.y = exp2((Le - 127) / 2);
    Xp_Y_XYZp.z = Xp_Y_XYZp.y / vLogLuv.y;
    Xp_Y_XYZp.x = vLogLuv.x * Xp_Y_XYZp.z;
    float3 vRGB = mul(Xp_Y_XYZp, InverseLogLuv);
    return max(vRGB, 0);
}

float4 EncodeRGBM(float3 color)
{
    color.r *= 1.0 / 6.0;
    color.g *= 1.0 / 6.0;
    color.b *= 1.0 / 6.0;

    float4 encode;
    encode.a = min(1.0f, max(0.0f, (max(max(color.r, color.g), max(color.b, 1e-6f)))));
    encode.a = ceil(encode.a * 255.0) / 255.0;
    encode.r = color.r / encode.a;
    encode.g = color.g / encode.a;
    encode.b = color.b / encode.a;
    return encode;
}

float3 DecodeRGBM(in float4 rgbm)
{
    return 6 * rgbm.rgb * rgbm.a;
}

float2 PosToCoord(float2 position)
{
    position = position * 0.5 + 0.5;
    return float2(position.x, 1 - position.y);
}

float2 CoordToPos(float2 coord)
{
    coord.y = 1 - coord.y;
    return coord * 2 - 1;
}

float3x3 makeRotate(float eulerX, float eulerY, float eulerZ)
{
    float sj, cj, si, ci, sh, ch;

    sincos(eulerX, si, ci);
    sincos(eulerY, sj, cj);
    sincos(eulerZ, sh, ch);

    float cc = ci * ch;
    float cs = ci * sh;
    float sc = si * ch;
    float ss = si * sh;

    float a1 = cj * ch;
    float a2 = sj * sc - cs;
    float a3 = sj * cc + ss;

    float b1 = cj * sh;
    float b2 = sj * ss + cc;
    float b3 = sj * cs - sc;

    float c1 = -sj;
    float c2 = cj * si;
    float c3 = cj * ci;
    
    float3x3 rotate;
    rotate[0] = float3(a1, a2, a3);
    rotate[1] = float3(b1, b2, b3);
    rotate[2] = float3(c1, c2, c3);
    
    return rotate;
}

float2 computeSphereCoord(float3 normal)
{
    float2 coord = float2(1 - (atan2(normal.x, normal.z) * InvPIE * 0.5f + 0.5f), acos(normal.y) * InvPIE);
    return coord;
}

float3x3 computeTangentBinormalNormal(float3 N, float3 viewdir, float2 coord)
{
    float3 dp1 = ddx(viewdir);
    float3 dp2 = ddy(viewdir);
    float2 duv1 = ddx(coord);
    float2 duv2 = ddy(coord);

    float3x3 M = float3x3(dp1, dp2, cross(dp1, dp2));
    float2x3 I = float2x3(cross(M[1], M[2]), cross(M[2], M[0]));
    float3 T = mul(float2(duv1.x, duv2.x), I);
    float3 B = mul(float2(duv1.y, duv2.y), I);

    return float3x3(normalize(T), normalize(B), N);
}

const static float JitterOffsets[16] = {
     0.215168, -0.243968,   0.625509, -0.623349,
     0.247428, -0.224435,  -0.355875, -0.00792976,
    -0.619941, -0.00287403, 0.238996,  0.344431,
     0.627993, -0.772384,  -0.212489,  0.769486
};

float GetJitterOffset(int2 iuv)
{
    int index = (iuv.x % 4) * 4 + (iuv.y % 4);
#if 0
    return JitterOffsets[index];
#else
    int index2 = ((iuv.x/4) % 4) * 4 + ((iuv.y/4) % 4);
    return (JitterOffsets[index] + JitterOffsets[index2] * 1 / 16.0);
#endif
}

float BilateralWeight(float r, float depth, float center_d, float sigma, float sharpness)
{
    const float blurSigma = sigma * 0.5f;
    const float blurFalloff = 1.0f / (2.0f * blurSigma * blurSigma);

    float ddiff = (depth - center_d) * sharpness;
    return exp2(-r * r * blurFalloff - ddiff * ddiff);
}