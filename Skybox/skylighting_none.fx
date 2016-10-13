shared texture LightAlphaMap : RENDERCOLORTARGET;
shared texture EnvLightSpecMap : RENDERCOLORTARGET;

const float4 BackColor = float4(0,0,0,0);
const float4 IBLColor = float4(0,0.5,0,0.5);

#define OBJECT_TEC(name, mmdpass) \
    technique name < string MMDPass = mmdpass;\
    string Script = \
        "RenderColorTarget0=LightAlphaMap;"\
        "ClearSetColor=BackColor;"\
        "Clear=Color;"\
        "RenderColorTarget0=EnvLightSpecMap;" \
        "ClearSetColor=IBLColor;"\
        "Clear=Color;"\
    ;> { \
    }

OBJECT_TEC(MainTec0, "object")
OBJECT_TEC(MainTecBS0, "object_ss")

technique EdgeTec < string MMDPass = "edge"; > {}
technique ShadowTech < string MMDPass = "shadow";  > {}
technique ZplotTec < string MMDPass = "zplot"; > {}