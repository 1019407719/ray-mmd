texture2D DepthBuffer : RENDERDEPTHSTENCILTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "D24S8";
>;

texture2D ScnMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0,1.0};
    int MipLevels = 1;
    bool AntiAlias = false;
    string Format = "A16B16G16R16F";
>;
sampler ScnSamp = sampler_state {
    texture = <ScnMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture LightMap: OFFSCREENRENDERTARGET <
    string Description = "Multi light source map for ray";
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "skybox_hdr.*=hide;"
        "skybox.*=hide;"
        "AmbientLight*.* =./Lighting/shader/ambient_lighting.fx;"
        "SpotLight*.* =./Lighting/shader/spot_lighting.fx;"
        "PointLight*.* =./Lighting/shader/point_lighting.fx;"
        "SphereLight*.* =./Lighting/shader/sphere_lighting.fx;"
        "RectangleLight*.* =./Lighting/shader/rectangle_lighting.fx;"
        "TubeLight*.* =./Lighting/shader/tube_lighting.fx;"
        "LED*.pmx =./Lighting/shader/LED.fx;"
        "* = hide;";
>;

sampler LightMapSamp = sampler_state {
    texture = <LightMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

#if IBL_QUALITY > 0
texture EnvLightMap: OFFSCREENRENDERTARGET <
    string Description = "Image-based-lighting map for ray";
    float2 ViewPortRatio = {1.0, 1.0};
    string Format = "A16B16G16R16F";
#if IBL_QUALITY > 1
    float4 ClearColor = { 0, 0.5, 0, 0.5 };
#else
    float4 ClearColor = { 0, 0, 0, 0 };
#endif
    float ClearDepth = 1.0;
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "skybox_hdr*.*=./Lighting/shader/envlighting_hdr.fx;"
        "skybox*.*=./Lighting/shader/envlighting.fx;"
        "*= hide;";
>;

sampler EnvLightMapSamp = sampler_state {
    texture = <EnvLightMap>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#endif

shared texture MaterialMap: OFFSCREENRENDERTARGET <
    string Description = "Material cache map for ray";
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    float ClearDepth = 1.0;
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
    string DefaultEffect =
        "self = hide;"
        "ray_controller.pmx=hide;"
        "skybox*.* = ./materials/material_skybox.fx;"
        "LED*.pmx =./materials/material_led.fx;"
        "*.pmd = ./materials/material.fx;"
        "*.pmx = ./materials/material.fx;"
        "*.x = hide;"
        "* = hide;";
>;

sampler Gbuffer1Map = sampler_state {
    texture = <MaterialMap>;
    MinFilter = NONE;
    MagFilter = NONE;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

shared texture Gbuffer2RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0};
    string Format = "A8R8G8B8" ;
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer2Map = sampler_state {
    texture = <Gbuffer2RT>;
    MinFilter = NONE;
    MagFilter = NONE;
    MipFilter = NONE;
    AddressU  = CLAMP;
    AddressV  = CLAMP;
};

shared texture Gbuffer3RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer3Map = sampler_state {
    texture = <Gbuffer3RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer4RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "R16F" ;
    bool AntiAlias = false;
    int MipLevels = 1;
>;
sampler Gbuffer4Map = sampler_state {
    texture = <Gbuffer4RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer5RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer5Map = sampler_state {
    texture = <Gbuffer5RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer6RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer6Map = sampler_state {
    texture = <Gbuffer6RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer7RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A8R8G8B8";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer7Map = sampler_state {
    texture = <Gbuffer7RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};

shared texture Gbuffer8RT: RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "R16F";
    int Miplevels = 1;
    bool AntiAlias = false;
>;

sampler Gbuffer8Map = sampler_state {
    texture = <Gbuffer8RT>;
    MinFilter = NONE;   MagFilter = NONE;   MipFilter = NONE;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
texture2D ShadingMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A16B16G16R16F";
>;
texture2D ShadingMapTemp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A16B16G16R16F";
>;
sampler ShadingMapSamp = sampler_state {
    texture = <ShadingMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
sampler ShadingMapTempSamp = sampler_state {
    texture = <ShadingMapTemp>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
shared texture2D FinalMap : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    float4 ClearColor = { 0, 0, 0, 0 };
    string Format = "A2R10G10B10";
>;
sampler FinalMapSamp = sampler_state {
    texture = <FinalMap>;
    MinFilter = LINEAR; MagFilter = LINEAR; MipFilter = LINEAR;
    AddressU  = CLAMP;  AddressV = CLAMP;
};
#if HDR_BLOOM_QUALITY > 0
texture2D BloomMapX1Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int MipLevels = 1;
#if HDR_BLOOM_QUALITY > 2
    string Format = "A16B16G16R16F";
#else
    string Format = "A2R10G10B10";
#endif
>;
texture2D BloomMapX1 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {1.0, 1.0};
    int MipLevels = 1;
#if HDR_BLOOM_QUALITY > 2
    string Format = "A16B16G16R16F";
#else
    string Format = "A2R10G10B10";
#endif
>;
texture2D BloomMapX2Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int MipLevels = 1;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX2 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.5, 0.5};
    int MipLevels = 1;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX3Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.25, 0.25};
    int MipLevels = 1;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX3 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.25, 0.25};
    int MipLevels = 1;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX4Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.125, 0.125};
    int MipLevels = 1;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX4 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.125, 0.125};
    int MipLevels = 1;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX5Temp : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.0625, 0.0625};
    int MipLevels = 1;
    string Format="A2R10G10B10";
>;
texture2D BloomMapX5 : RENDERCOLORTARGET <
    float2 ViewPortRatio = {0.0625, 0.0625};
    int MipLevels = 1;
    string Format="A2R10G10B10";
>;
sampler2D BloomSampX1Temp = sampler_state {
    texture = <BloomMapX1Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX1 = sampler_state {
    texture = <BloomMapX1>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX2Temp = sampler_state {
    texture = <BloomMapX2Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX2 = sampler_state {
    texture = <BloomMapX2>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX3Temp = sampler_state {
    texture = <BloomMapX3Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX3 = sampler_state {
    texture = <BloomMapX3>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX4Temp = sampler_state {
    texture = <BloomMapX4Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX4 = sampler_state {
    texture = <BloomMapX4>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX5Temp = sampler_state {
    texture = <BloomMapX5Temp>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
sampler2D BloomSampX5 = sampler_state {
    texture = <BloomMapX5>;
    MinFilter = Linear; MagFilter = Linear; MipFilter = NONE;
    AddressU  = CLAMP; AddressV = CLAMP;
};
#endif