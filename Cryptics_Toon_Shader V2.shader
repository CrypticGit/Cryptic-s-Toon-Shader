// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cryptics_Toon_Shader V2"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_OutlineThickness("Outline Thickness", Float) = 200
		[Toggle]_OutlineDiffuseorColor("Outline Diffuse or Color", Float) = 0
		_Offset("Offset", Float) = 0.45
		_Scale("Scale", Float) = 0.5
		_RimPower("Rim Power", Range( 0 , 1)) = 0
		_Tint("Tint", Color) = (0.8301887,0.8301887,0.8301887,0)
		_Albedo("Albedo", 2D) = "white" {}
		_FaceGradientOverlay("Face Gradient Overlay", 2D) = "white" {}
		_FaceGradientStrength("Face Gradient Strength", Float) = 1
		_AO("AO", 2D) = "white" {}
		_OutlineColor("Outline Color", Color) = (0,0,0,0)
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_Normals("Normals", 2D) = "bump" {}
		_SpecularMap("Specular Map", 2D) = "white" {}
		_Min("Min", Float) = 7
		_Max("Max", Float) = 4
		_SpecularColor("Specular Color", Color) = (1,1,1,1)
		_SpecIntensity("Spec Intensity", Range( 0 , 1)) = 0
		_SpecTransition("Spec Transition", Range( 0 , 1)) = 0
		_Gloss("Gloss", Float) = 0.32
		_RimTint("Rim Tint", Color) = (0,1,0.9903991,0)
		_RimOffset("Rim Offset", Float) = 0.5
		[Toggle]_RimTintControl("Rim Tint Control", Float) = 0
		_RimBrightness("Rim Brightness", Float) = 1
		_OverlayColor("Overlay Color", Color) = (1,0,0,0)
		_StarColor("Star Color", Color) = (1,1,1,0)
		_StarStr("Star Str", Float) = 2
		_OverlayStrength("Overlay Strength", Float) = 5
		_Overlay("Overlay", 2D) = "black" {}
		_testoverlaything("test overlay thing", Float) = 35
		_OverlayTest("Overlay Test", Float) = 22
		_OverlayStars("Overlay Stars", 2D) = "white" {}
		_SoeedMultiplier("Soeed Multiplier", Vector) = (-0.5,0.5,0,0)
		_Tiling("Tiling", Vector) = (1,0.2,0,0)
		_NoiseStrength("Noise Strength", Float) = 4
		_Noise("Noise", 2D) = "black" {}
		_Noise2("Noise2", 2D) = "black" {}
		_ShadeSmoothness("Shade Smoothness", Float) = 2
		_ShadowStr("Shadow Str", Float) = 1
		_CustomShadowthing("Custom Shadow thing", 2D) = "white" {}
		_LightingTest("Lighting Test", Float) = 1
		_FakelightDirectionControl("Fakelight Direction Control", Color) = (1,1,1,0)
		_FakeLightRimlightSTRENGTH("FakeLight Rimlight STRENGTH", Float) = 30
		_FakelightTintTest("FakelightTint Test", Color) = (0.8301887,0.8301887,0.8301887,0)
		[Toggle]_FakeLightTintTest("FakeLight Tint Test", Float) = 0
		_FakelighttintSTR("Fakelight tint STR", Float) = 4
		_FakeLightRimDirSTR("Fake Light Rim Dir&STR", Float) = 2.7
		_FakeTintStrength("Fake Tint Strength", Float) = 11
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0"}
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float VertexPaint122 = ( v.color.r * 1.0 );
			float outlineVar = ( 1E-05 * _OutlineThickness * VertexPaint122 );
			v.vertex.xyz += ( v.normal * outlineVar );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode20 = tex2D( _Albedo, uv_Albedo );
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float2 uv_FaceGradientOverlay = i.uv_texcoord * _FaceGradientOverlay_ST.xy + _FaceGradientOverlay_ST.zw;
			float4 temp_output_771_0 = ( tex2DNode20 * tex2D( _AO, uv_AO ) * ( tex2D( _FaceGradientOverlay, uv_FaceGradientOverlay ) * _FaceGradientStrength ) );
			float4 Albedo33 = ( _Tint * ( temp_output_771_0 + float4( 0,0,0,0 ) ) );
			float A782 = tex2DNode20.a;
			o.Emission = (( _OutlineDiffuseorColor )?( Albedo33 ):( _OutlineColor )).rgb;
			clip( A782 - _Cutoff );
		}
		ENDCG
		

		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _Tint;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _AO;
		uniform float4 _AO_ST;
		uniform sampler2D _FaceGradientOverlay;
		uniform float4 _FaceGradientOverlay_ST;
		uniform float _FaceGradientStrength;
		uniform sampler2D _Overlay;
		uniform float4 _Overlay_ST;
		uniform sampler2D _Noise;
		uniform float2 _Tiling;
		uniform float2 _SoeedMultiplier;
		uniform sampler2D _Noise2;
		uniform float4 _Noise2_ST;
		uniform float _NoiseStrength;
		uniform float _OverlayStrength;
		uniform float4 _OverlayColor;
		uniform float _testoverlaything;
		uniform float4 _StarColor;
		uniform sampler2D _OverlayStars;
		uniform float _StarStr;
		uniform float _OverlayTest;
		uniform float _ShadowStr;
		uniform sampler2D _Normals;
		uniform float4 _Normals_ST;
		uniform sampler2D _CustomShadowthing;
		uniform float4 _CustomShadowthing_ST;
		uniform float _ShadeSmoothness;
		uniform sampler2D _ToonRamp;
		uniform float _Scale;
		uniform float _Offset;
		uniform float _LightingTest;
		uniform float4 _FakelightDirectionControl;
		uniform float _FakeLightTintTest;
		uniform float4 _FakelightTintTest;
		uniform float _FakeTintStrength;
		uniform float _FakelighttintSTR;
		uniform float _FakeLightRimlightSTRENGTH;
		uniform float _FakeLightRimDirSTR;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float _RimTintControl;
		uniform float _RimBrightness;
		uniform float4 _RimTint;
		uniform float _Min;
		uniform float _Max;
		uniform float _Gloss;
		uniform sampler2D _SpecularMap;
		uniform float4 _SpecularMap_ST;
		uniform float4 _SpecularColor;
		uniform float _SpecTransition;
		uniform float _SpecIntensity;
		uniform float _Cutoff = 0.5;
		uniform float _OutlineThickness;
		uniform float _OutlineDiffuseorColor;
		uniform float4 _OutlineColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 Outline110 = 0;
			v.vertex.xyz += Outline110;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode20 = tex2D( _Albedo, uv_Albedo );
			float A782 = tex2DNode20.a;
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float2 uv_FaceGradientOverlay = i.uv_texcoord * _FaceGradientOverlay_ST.xy + _FaceGradientOverlay_ST.zw;
			float4 temp_output_771_0 = ( tex2DNode20 * tex2D( _AO, uv_AO ) * ( tex2D( _FaceGradientOverlay, uv_FaceGradientOverlay ) * _FaceGradientStrength ) );
			float4 Albedo33 = ( _Tint * ( temp_output_771_0 + float4( 0,0,0,0 ) ) );
			float2 uv_Normals = i.uv_texcoord * _Normals_ST.xy + _Normals_ST.zw;
			float3 Normals3 = UnpackNormal( tex2D( _Normals, uv_Normals ) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult13 = dot( normalize( (WorldNormalVector( i , Normals3 )) ) , ase_worldlightDir );
			float NormalLightDirection23 = dotResult13;
			float2 uv_CustomShadowthing = i.uv_texcoord * _CustomShadowthing_ST.xy + _CustomShadowthing_ST.zw;
			float4 tex2DNode716 = tex2D( _CustomShadowthing, uv_CustomShadowthing );
			float4 temp_cast_3 = (_ShadowStr).xxxx;
			float dotResult297 = dot( ( _ShadowStr * NormalLightDirection23 * tex2DNode716 * 2.0 ) , temp_cast_3 );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult10 = dot( normalize( (WorldNormalVector( i , Normals3 )) ) , ase_worldViewDir );
			float NormalViewDir16 = dotResult10;
			float blendOpSrc307 = ( dotResult297 * NormalViewDir16 * _ShadeSmoothness );
			float blendOpDest307 = 0.0;
			float2 temp_cast_4 = ((NormalLightDirection23*_Scale + _Offset)).xx;
			float4 Shadow59 = ( Albedo33 * ( ( saturate(  (( blendOpSrc307 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc307 - 0.5 ) ) * ( 1.0 - blendOpDest307 ) ) : ( 2.0 * blendOpSrc307 * blendOpDest307 ) ) )) * tex2D( _ToonRamp, temp_cast_4 ) ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_cast_5 = (0.4).xxxx;
			float4 temp_cast_6 = (1.0).xxxx;
			float4 clampResult861 = clamp( ase_lightColor , temp_cast_5 , temp_cast_6 );
			UnityGI gi83 = gi;
			float3 diffNorm83 = WorldNormalVector( i , Normals3 );
			gi83 = UnityGI_Base( data, 1, diffNorm83 );
			float3 indirectDiffuse83 = gi83.indirect.diffuse + diffNorm83 * 0.0001;
			float4 Lighting73 = ( Shadow59 * ( clampResult861 * ( float4( indirectDiffuse83 , 0.0 ) + ase_lightAtten + Albedo33 + _LightingTest ) ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult642 = dot( _FakelightDirectionControl , float4( ase_worldNormal , 0.0 ) );
			float clampResult646 = clamp( ( 0.0 * dotResult642 ) , 0.0 , 1.0 );
			float clampResult652 = clamp( floor( clampResult646 ) , 0.0 , 22.0 );
			float lerpResult639 = lerp( ( 0.03 * dotResult642 ) , 1.0 , clampResult652);
			float lerpResult638 = lerp( -0.07 , 0.055 , 0.0);
			float4 Albedo2752 = ( ( temp_output_771_0 + float4( 0,0,0,0 ) ) * _FakelightTintTest * _FakeTintStrength );
			float4 CST757 = tex2DNode716;
			float4 temp_cast_9 = (1.0).xxxx;
			float4 clampResult634 = clamp( ( dotResult642 * 2.0 * dotResult642 * ( CST757 + NormalLightDirection23 + dotResult642 ) ) , float4( 0,0,0,0 ) , temp_cast_9 );
			float4 temp_cast_10 = (22.0).xxxx;
			float4 clampResult637 = clamp( floor( clampResult634 ) , float4( 0,0,0,0 ) , temp_cast_10 );
			float4 FakeLIGHT668 = ( saturate( ( lerpResult639 + lerpResult638 ) ) + ( (( _FakeLightTintTest )?( ( Albedo2752 * _FakelighttintSTR ) ):( Albedo33 )) * clampResult637 ) + saturate( ( saturate( ( pow( ( 1.0 - saturate( ( 0.5 + NormalViewDir16 ) ) ) , 1.0 ) * ( dotResult642 * dotResult642 ) ) ) * ( dotResult642 * ( Albedo33 * _FakeLightRimlightSTRENGTH * CST757 ) ) * CST757 * ( CST757 * _FakeLightRimDirSTR ) ) ) );
			float4 temp_cast_11 = (0.4).xxxx;
			float4 temp_cast_12 = (1.0).xxxx;
			float4 clampResult867 = clamp( ase_lightColor , temp_cast_11 , temp_cast_12 );
			float4 RimLight72 = ( saturate( ( pow( ( 1.0 - saturate( ( _RimOffset + NormalViewDir16 ) ) ) , _RimPower ) * ( NormalLightDirection23 * ase_lightAtten ) ) ) * ( clampResult867 * (( _RimTintControl )?( _RimTint ):( ( Albedo33 * _RimBrightness ) )) ) );
			float dotResult46 = dot( ( ase_worldViewDir + _WorldSpaceLightPos0.xyz ) , normalize( (WorldNormalVector( i , Normals3 )) ) );
			float smoothstepResult60 = smoothstep( _Min , _Max , pow( dotResult46 , _Gloss ));
			float2 uv_SpecularMap = i.uv_texcoord * _SpecularMap_ST.xy + _SpecularMap_ST.zw;
			float4 temp_cast_13 = (0.4).xxxx;
			float4 temp_cast_14 = (1.0).xxxx;
			float4 clampResult870 = clamp( ase_lightColor , temp_cast_13 , temp_cast_14 );
			float4 lerpResult54 = lerp( _SpecularColor , clampResult870 , _SpecTransition);
			float4 Specular75 = ( ase_lightAtten * ( ( smoothstepResult60 * ( tex2D( _SpecularMap, uv_SpecularMap ) * lerpResult54 ) ) * _SpecIntensity ) );
			c.rgb = ( ( (( Lighting73 > FakeLIGHT668 ) ? Lighting73 :  FakeLIGHT668 ) + RimLight72 ) + Specular75 ).rgb;
			c.a = 1;
			clip( A782 - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 tex2DNode20 = tex2D( _Albedo, uv_Albedo );
			float2 uv_AO = i.uv_texcoord * _AO_ST.xy + _AO_ST.zw;
			float2 uv_FaceGradientOverlay = i.uv_texcoord * _FaceGradientOverlay_ST.xy + _FaceGradientOverlay_ST.zw;
			float4 temp_output_771_0 = ( tex2DNode20 * tex2D( _AO, uv_AO ) * ( tex2D( _FaceGradientOverlay, uv_FaceGradientOverlay ) * _FaceGradientStrength ) );
			float4 Albedo33 = ( _Tint * ( temp_output_771_0 + float4( 0,0,0,0 ) ) );
			float2 uv_Overlay = i.uv_texcoord * _Overlay_ST.xy + _Overlay_ST.zw;
			float4 tex2DNode152 = tex2D( _Overlay, uv_Overlay );
			float2 uv_Noise2 = i.uv_texcoord * _Noise2_ST.xy + _Noise2_ST.zw;
			float4 temp_output_180_0 = ( tex2D( _Noise, ( ( i.uv_texcoord * _Tiling ) + ( _SoeedMultiplier * _Time.y ) ) ) * tex2D( _Noise2, uv_Noise2 ) * _NoiseStrength );
			float4 temp_output_836_0 = ( tex2DNode152 * _OverlayColor );
			float4 OverlayNoise167 = ( ( ( tex2DNode152 * ( temp_output_180_0 + temp_output_180_0 ) * _OverlayStrength ) * ( temp_output_836_0 * _testoverlaything * tex2DNode152 * temp_output_836_0 ) ) + ( _StarColor * tex2D( _OverlayStars, ( float4( ( i.uv_texcoord * float2( 2,2 ) ), 0.0 , 0.0 ) + ( float4(0.1,0.1,0,0) * _Time.y ) ).xy ) * tex2DNode152 * _StarStr ) );
			float4 aaaaa855 = tex2DNode152;
			float4 lerpResult854 = lerp( Albedo33 , ( OverlayNoise167 * _OverlayTest ) , step( Albedo33 , aaaaa855 ));
			o.Emission = lerpResult854.rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18000
-1811;-1681;1857;984;5766.999;1452.698;5.363572;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-6064.857,-1325.447;Inherit;False;680.425;280;Comment;2;3;2;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-6014.857,-1275.447;Inherit;True;Property;_Normals;Normals;13;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;3;-5627.432,-1250.792;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;5;-4931.692,-1300.85;Inherit;False;1094.509;416.4844;Comment;5;23;13;12;11;9;Normal Light Dir.;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;4;-4948.192,-381.2226;Inherit;False;1086.897;547.3123;Comment;5;6;16;10;7;8;Normal View Dir.;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-4909.654,-1252.231;Inherit;False;3;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;6;-4931.422,-336.6937;Inherit;False;3;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;14;-2975.203,-1809.635;Inherit;False;2085.996;1536.952;Comment;18;33;705;22;116;314;20;310;315;750;751;752;771;772;773;779;780;782;839;Albedo;0,1,0.9648104,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-4733.396,-188.1846;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;7;-4742.518,-331.2228;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;12;-4915.625,-1110.756;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;11;-4673.465,-1250.85;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;315;-2615.125,-667.6745;Inherit;False;Property;_FaceGradientStrength;Face Gradient Strength;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;310;-2929.213,-728.2925;Inherit;True;Property;_FaceGradientOverlay;Face Gradient Overlay;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;10;-4450.395,-330.4846;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;13;-4323.401,-1136.198;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-4241.395,-336.4846;Inherit;False;NormalViewDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-2930.368,-959.7806;Inherit;True;Property;_AO;AO;10;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-2940.033,-1495.615;Inherit;True;Property;_Albedo;Albedo;7;0;Create;True;0;0;False;0;-1;None;826f80ee0ad07444c8558af826a4df2e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;667;-6507.385,2010.221;Inherit;False;2527.865;1536.29;Comment;54;668;655;640;698;639;697;696;638;650;692;652;649;651;636;695;637;685;690;691;648;686;654;647;635;646;634;687;632;644;633;645;682;642;681;653;631;679;680;704;708;709;714;715;748;753;754;755;758;759;760;761;766;767;770;FakeLight;0.9054002,0.6933962,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;-2571.768,-901.7955;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-4126.188,-1123.997;Inherit;False;NormalLightDirection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-2956.474,102.8155;Inherit;False;1956.548;1190.069;Comment;19;96;36;29;27;59;53;41;292;294;295;297;301;302;303;307;309;716;745;757;Shadow;0.2641509,0.1906372,0.2610359,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;680;-6466.926,3054.286;Inherit;False;16;NormalViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;295;-2539.745,209.0301;Inherit;False;Property;_ShadowStr;Shadow Str;40;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;-2898.008,423.2917;Inherit;False;23;NormalLightDirection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;704;-6447.655,2504.883;Inherit;False;Property;_FakelightDirectionControl;Fakelight Direction Control;43;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;679;-6426.061,2957.879;Float;False;Constant;_Float5;Float 5;24;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;771;-2374.097,-1459.369;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;631;-6434.385,2725.223;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;745;-2279.317,863.0934;Inherit;False;Constant;_Float1;Float 1;41;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;716;-2897.374,188.4456;Inherit;True;Property;_CustomShadowthing;Custom Shadow thing;41;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-2567.455,367.0552;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;681;-6203.727,2997.372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;642;-6169.386,2620.222;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;757;-2668.012,680.8173;Inherit;False;CST;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;166;-852.9466,270.08;Inherit;False;2418.843;1665.741;Comment;34;167;855;857;858;843;860;859;192;189;173;195;190;191;836;181;180;152;174;199;198;202;179;200;196;194;151;186;153;156;157;164;163;158;165;Overlay Noise;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;780;-2120.174,-1563.612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;-2908.432,-1706.725;Inherit;False;Property;_Tint;Tint;6;0;Create;True;0;0;False;0;0.8301887,0.8301887,0.8301887,0;0.1981132,0.1981132,0.1981132,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;297;-2280.787,248.957;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;163;-793.2737,483.08;Inherit;False;Property;_Tiling;Tiling;34;0;Create;True;0;0;False;0;1,0.2;1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;767;-6425.555,2277.805;Inherit;False;23;NormalLightDirection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;645;-5829.886,2452.022;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;302;-2365.187,492.5918;Inherit;False;16;NormalViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-2866.901,1097.597;Inherit;False;Property;_Offset;Offset;3;0;Create;True;0;0;False;0;0.45;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2868.112,1010.363;Inherit;False;Property;_Scale;Scale;4;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;682;-6075.846,3003.281;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;644;-5849.386,2572.222;Float;False;Constant;_Float3;Float 3;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;766;-6397.272,2169.189;Inherit;False;757;CST;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;164;-787.2737,616.0802;Inherit;False;Property;_SoeedMultiplier;Soeed Multiplier;33;0;Create;True;0;0;False;0;-0.5,0.5;-0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;15;-3017.229,2571.522;Inherit;False;2016.228;818.548;Comment;24;72;70;65;64;57;56;55;52;51;42;40;39;32;25;19;17;87;89;86;115;114;865;866;867;Rimlight;1,0.9475075,0,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;165;-786.1458,771.4384;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;779;-1925.008,-1339.403;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;773;-1958.817,-770.1169;Inherit;False;Property;_FakeTintStrength;Fake Tint Strength;49;0;Create;True;0;0;False;0;11;11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;751;-2054.073,-1037.829;Inherit;False;Property;_FakelightTintTest;FakelightTint Test;45;0;Create;True;0;0;False;0;0.8301887,0.8301887,0.8301887,0;0.8301887,0.8301887,0.8301887,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;772;-1933.209,-1676.01;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;158;-789.2737,320.08;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;303;-2357.636,627.2515;Inherit;False;Property;_ShadeSmoothness;Shade Smoothness;38;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-446.7533,488.0509;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;646;-5641.176,2444.222;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;36;-2644.414,1012.963;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-2016.279,405.3545;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;687;-5885.461,3004.435;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-2971.128,2742.124;Inherit;False;16;NormalViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;750;-1711.667,-1312.543;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1540.832,-1668.716;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;770;-6132.35,2342.196;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;653;-6105.386,2876.222;Float;False;Constant;_ShinePush;Shine Push;18;0;Create;True;0;0;False;0;2;1.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;18;-3207.946,3743.55;Inherit;False;2297.76;1281.211;Comment;26;75;71;69;67;66;61;60;54;50;49;48;47;46;44;43;38;37;35;34;31;26;24;85;868;869;870;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-456.7533,631.0509;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-2903.453,2621.522;Float;False;Property;_RimOffset;Rim Offset;22;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-283.1752,569.382;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;58;-2900.964,1474.196;Inherit;False;1636.269;870.8802;Comment;14;81;80;63;747;83;124;84;78;73;68;62;861;862;863;Real Lighting;0.9914972,1,0.6273585,1;0;0
Node;AmplifyShaderEditor.SamplerNode;96;-2380.785,976.311;Inherit;True;Property;_ToonRamp;Toon Ramp;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;307;-2034.342,699.043;Inherit;True;HardLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;26;-3103.819,3793.55;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;632;-5833.386,2828.222;Float;False;Constant;_Float2;Float 2;20;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;24;-3157.946,3985.892;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;758;-5951.404,3469.352;Inherit;False;757;CST;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;686;-6024.067,3375.535;Inherit;False;Property;_FakeLightRimlightSTRENGTH;FakeLight Rimlight STRENGTH;44;0;Create;True;0;0;False;0;30;30;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-2691.228,2671.824;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;654;-5401.386,2060.221;Float;False;Constant;_ShadowIntensity;Shadow Intensity;14;0;Create;True;0;0;False;0;0.03;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;685;-5844.265,3284.141;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;633;-5874.944,2662.283;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;647;-5449.386,2604.222;Float;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;22;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;752;-1426.224,-1306.374;Inherit;False;Albedo2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;691;-5668.969,3043.68;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;690;-5778.15,3172.63;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-3131.946,4126.892;Inherit;False;3;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FloorOpNode;648;-5433.386,2460.222;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2788.459,1903.837;Inherit;False;3;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;651;-5161.386,2572.222;Float;False;Constant;_Float6;Float 6;4;0;Create;True;0;0;False;0;-0.07;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;179;-321.4086,968.2393;Inherit;True;Property;_Noise2;Noise2;37;0;Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;650;-5305.386,2364.222;Float;False;Constant;_LightIntensity;Light Intensity;6;0;Create;True;0;0;False;0;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;753;-5557.672,2917.94;Inherit;False;752;Albedo2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;634;-5705.386,2718.223;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;868;-2092.305,4728.104;Inherit;False;Constant;_Float10;Float 0;50;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;202;-679.2495,1418.443;Inherit;False;Constant;_Vector1;Vector 1;35;0;Create;True;0;0;False;0;0.1,0.1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;186;-6.879244,1031.892;Inherit;False;Property;_NoiseStrength;Noise Strength;35;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;695;-5481.215,3055.996;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;32;-2525.228,2679.824;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;38;-2307.171,4785.188;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.WorldNormalVector;34;-2866.946,4136.892;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;649;-5161.386,2220.221;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;636;-5170.663,2641.501;Float;False;Constant;_ShineIntensity;Shine Intensity;19;0;Create;True;0;0;False;0;0.055;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;200;-650.0698,1593.544;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;869;-1982.305,4835.104;Inherit;False;Constant;_Float11;Float 7;50;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;123;-712.4779,-783.6612;Inherit;False;946.5361;506.308;Comment;5;118;122;120;121;119;Vertex Paint;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;196;-679.2377,1283.286;Inherit;False;Constant;_Vector0;Vector 0;30;0;Create;True;0;0;False;0;2,2;1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;194;-674.2377,1120.285;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;151;-308.1957,742.5158;Inherit;True;Property;_Noise;Noise;36;0;Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;759;-6387.218,3184.237;Inherit;False;757;CST;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;-1718.667,746.3384;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;652;-5273.386,2460.222;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;761;-6347.977,3287.711;Inherit;False;Property;_FakeLightRimDirSTR;Fake Light Rim Dir&STR;48;0;Create;True;0;0;False;0;2.7;2.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;41;-1703.948,532.0325;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;754;-5538.672,2992.94;Inherit;False;Property;_FakelighttintSTR;Fakelight tint STR;47;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-2819.946,3873.893;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;692;-5654.021,3294.507;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;747;-2263.635,2042.414;Inherit;False;Property;_LightingTest;Lighting Test;42;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;639;-4969.386,2428.221;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;84;-2508.719,2033.033;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;46;-2644.945,3995.891;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1451.948,589.0325;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;119;-662.478,-733.6613;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;125.5386,762.2905;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;638;-4875.386,2615.222;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;862;-2478.72,1685.212;Inherit;False;Constant;_Float0;Float 0;50;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;863;-2368.72,1792.212;Inherit;False;Constant;_Float7;Float 7;50;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-341.7162,1431.255;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;755;-5324.672,2936.94;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;83;-2519.428,1911.272;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;174;-6.72983,1107.447;Inherit;False;Property;_OverlayColor;Overlay Color;25;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;63;-2492.114,1577.521;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;152;-111.7611,347.0861;Inherit;True;Property;_Overlay;Overlay;29;0;Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2824.856,1966.548;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2360.908,2878.062;Inherit;False;Property;_RimPower;Rim Power;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;696;-5303.672,3057.209;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;870;-1851.305,4720.104;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-426.1257,-482.3533;Inherit;False;Constant;_VertexPaint;Vertex Paint;25;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2247.171,4912.188;Float;False;Property;_SpecTransition;Spec Transition;19;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;37;-2179.171,4573.188;Inherit;False;Property;_SpecularColor;Specular Color;17;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;86;-2338.614,3127.81;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;697;-5401.314,3282.316;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-2209.502,3167.062;Inherit;False;Property;_RimBrightness;Rim Brightness;24;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;760;-6058.888,3133.902;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-331.7162,1288.255;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-2014.023,3134.859;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;714;-5375.116,2846.322;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;40;-2374.777,2992.118;Inherit;False;23;NormalLightDirection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-2255.227,2689.824;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;635;-5433.386,2716.223;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-2523.946,4174.891;Float;False;Property;_Gloss;Gloss;20;0;Create;True;0;0;False;0;0.32;0.32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;865;-1873.506,3037.102;Inherit;False;Constant;_Float8;Float 8;50;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;637;-5211.815,2716.139;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;861;-2237.72,1677.212;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;640;-4748.385,2497.222;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-168.139,1369.587;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;191;361.2867,915.5255;Inherit;False;Property;_testoverlaything;test overlay thing;30;0;Create;True;0;0;False;0;35;35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;190;426.9986,697.6359;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2220.944,4218.891;Inherit;False;Property;_Max;Max;16;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-1889.112,3232.593;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2015.909,3029.349;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2220.944,4143.891;Inherit;False;Property;_Min;Min;15;0;Create;True;0;0;False;0;7;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;48;-2178.706,4329.094;Inherit;True;Property;_SpecularMap;Specular Map;14;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-173.1259,-678.3533;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;392.5083,489.2599;Inherit;False;Property;_OverlayStrength;Overlay Strength;28;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;748;-5140.124,2858.689;Inherit;False;Property;_FakeLightTintTest;FakeLight Tint Test;46;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;47;-2398.946,4020.891;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;55;-1584.913,3217.13;Inherit;False;Property;_RimTint;Rim Tint;21;0;Create;True;0;0;False;0;0,1,0.9903991,0;0,1,0.9903991,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1271.454,634.4502;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;54;-1837.171,4556.188;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;698;-5099.663,3053.186;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;836;436.7163,973.6917;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;56;-1853.182,2898.554;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-2186.038,1900.167;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;52;-2038.734,2729.069;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;866;-1763.506,3144.102;Inherit;False;Constant;_Float9;Float 9;50;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2070.504,1540.217;Inherit;False;59;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;859;225.6264,1174.261;Inherit;False;Property;_StarColor;Star Color;26;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;708;-4612.851,2490.979;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;860;376.1146,1443.333;Inherit;False;Property;_StarStr;Star Str;27;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;60;-2028.928,4028.878;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;108;-5011.699,577.2057;Inherit;False;1225.321;1048.024;Comment;11;110;135;136;137;138;139;140;132;133;142;824;Outline;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;715;-4963.958,2719.988;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-2051.617,1783.012;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-1850.98,2741.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;709;-4736.792,2779.934;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-10.94206,-678.2512;Inherit;False;VertexPaint;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;189;-6.491549,1342.772;Inherit;True;Property;_OverlayStars;Overlay Stars;32;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1800.136,4380.209;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;867;-1632.506,3029.102;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;704.2876,736.3068;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;89;-1334.704,3155.408;Inherit;False;Property;_RimTintControl;Rim Tint Control;23;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;682.4302,486.371;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;64;-1673.438,2742.598;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-4973.449,1054.498;Inherit;False;122;VertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;858;519.4667,1239.324;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1656.878,4237.93;Inherit;False;Property;_SpecIntensity;Spec Intensity;18;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;843;895.5731,524.4265;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1755.86,4030.403;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1460.969,3033.07;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;655;-4536.293,2610.913;Inherit;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1691.085,1573.791;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-4709.904,964.8415;Float;False;Property;_OutlineThickness;Outline Thickness;1;0;Create;True;0;0;False;0;200;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;136;-4718.336,1081.462;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LightAttenuation;85;-1702.906,3909.159;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;668;-4303.273,2688.456;Inherit;False;FakeLIGHT;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;782;-2609.349,-1261.877;Inherit;False;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1507.696,1562.898;Inherit;False;Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;857;1149.073,586.7746;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;132;-4973.294,657.2835;Float;False;Property;_OutlineColor;Outline Color;11;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1573.005,4043.436;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-4604.98,885.8935;Float;False;Constant;_Float46;Float 46;17;0;Create;True;0;0;False;0;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-4974.323,857.0765;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-1469.428,2738.575;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;855;311.0025,342.179;Inherit;False;aaaaa;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;781;548.2433,-409.1989;Inherit;False;73;Lighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-1376.877,4034.931;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-1243.999,2709.691;Inherit;False;RimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-4363.509,1002.171;Inherit;False;3;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;139;-4473.064,723.1115;Inherit;False;Property;_OutlineDiffuseorColor;Outline Diffuse or Color;2;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;669;590.6646,-271.1511;Inherit;False;668;FakeLIGHT;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;824;-4390.019,892.1899;Inherit;False;782;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;1259.128,513.9563;Float;False;OverlayNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareGreater;607;1020.682,-379.2727;Inherit;False;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;856;1792.271,-242.4102;Inherit;False;855;aaaaa;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;140;-4118.659,995.378;Inherit;False;0;True;Masked;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;774;1397.794,-297.2659;Inherit;False;Property;_OverlayTest;Overlay Test;31;0;Create;True;0;0;False;0;22;22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;1068.069,-170.0996;Inherit;False;72;RimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;1355.259,-509.382;Inherit;False;167;OverlayNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-1164.877,4037.931;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;1594.928,-592.6704;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;853;2042.777,-268.2355;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;1424.541,-108.6673;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;1256.317,55.59018;Inherit;False;75;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;776;1617.96,-357.4421;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-4057.843,863.2431;Inherit;False;Outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;705;-2934.635,-1275.469;Inherit;True;Property;_ColorMask;Color Mask;39;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;839;-1618.408,-1051.087;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;1682.461,-52.65336;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;808;1976.419,112.7967;Inherit;False;782;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;854;2197.154,-408.0471;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;118;-412.5389,-679.1293;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;1982.886,210.3449;Inherit;False;110;Outline;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;851;2536.777,-220.3511;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Cryptics_Toon_Shader V2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;149;-5189.434,-2323.848;Inherit;False;1075.082;100;I watched this video to create this shader: https://youtu.be/MawzivWLCoo;0;Credits: Shader is created by CrypticLight using Amplified Shader Editor;0.9994125,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;150;-5018.969,7146.9;Inherit;False;1075.082;100;I watched this video to create this shader: https://youtu.be/MawzivWLCoo;0;Credits: Shader is created by CrypticLight using Amplified Shader Editor;0.9994125,0,1,1;0;0
WireConnection;3;0;2;0
WireConnection;7;0;6;0
WireConnection;11;0;9;0
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;16;0;10;0
WireConnection;314;0;310;0
WireConnection;314;1;315;0
WireConnection;23;0;13;0
WireConnection;771;0;20;0
WireConnection;771;1;116;0
WireConnection;771;2;314;0
WireConnection;294;0;295;0
WireConnection;294;1;292;0
WireConnection;294;2;716;0
WireConnection;294;3;745;0
WireConnection;681;0;679;0
WireConnection;681;1;680;0
WireConnection;642;0;704;0
WireConnection;642;1;631;0
WireConnection;757;0;716;0
WireConnection;780;0;771;0
WireConnection;297;0;294;0
WireConnection;297;1;295;0
WireConnection;645;1;642;0
WireConnection;682;0;681;0
WireConnection;779;0;771;0
WireConnection;772;0;22;0
WireConnection;772;1;780;0
WireConnection;156;0;158;0
WireConnection;156;1;163;0
WireConnection;646;0;645;0
WireConnection;646;2;644;0
WireConnection;36;0;292;0
WireConnection;36;1;29;0
WireConnection;36;2;27;0
WireConnection;301;0;297;0
WireConnection;301;1;302;0
WireConnection;301;2;303;0
WireConnection;687;0;682;0
WireConnection;750;0;779;0
WireConnection;750;1;751;0
WireConnection;750;2;773;0
WireConnection;33;0;772;0
WireConnection;770;0;766;0
WireConnection;770;1;767;0
WireConnection;770;2;642;0
WireConnection;157;0;164;0
WireConnection;157;1;165;0
WireConnection;153;0;156;0
WireConnection;153;1;157;0
WireConnection;96;1;36;0
WireConnection;307;0;301;0
WireConnection;25;0;17;0
WireConnection;25;1;19;0
WireConnection;633;0;642;0
WireConnection;633;1;653;0
WireConnection;633;2;642;0
WireConnection;633;3;770;0
WireConnection;752;0;750;0
WireConnection;691;0;687;0
WireConnection;690;0;642;0
WireConnection;690;1;642;0
WireConnection;648;0;646;0
WireConnection;634;0;633;0
WireConnection;634;2;632;0
WireConnection;695;0;691;0
WireConnection;695;1;690;0
WireConnection;32;0;25;0
WireConnection;34;0;31;0
WireConnection;649;0;654;0
WireConnection;649;1;642;0
WireConnection;151;1;153;0
WireConnection;309;0;307;0
WireConnection;309;1;96;0
WireConnection;652;0;648;0
WireConnection;652;2;647;0
WireConnection;35;0;26;0
WireConnection;35;1;24;1
WireConnection;692;0;685;0
WireConnection;692;1;686;0
WireConnection;692;2;758;0
WireConnection;639;0;649;0
WireConnection;639;1;650;0
WireConnection;639;2;652;0
WireConnection;46;0;35;0
WireConnection;46;1;34;0
WireConnection;53;0;41;0
WireConnection;53;1;309;0
WireConnection;180;0;151;0
WireConnection;180;1;179;0
WireConnection;180;2;186;0
WireConnection;638;0;651;0
WireConnection;638;1;636;0
WireConnection;198;0;202;0
WireConnection;198;1;200;0
WireConnection;755;0;753;0
WireConnection;755;1;754;0
WireConnection;83;0;78;0
WireConnection;696;0;695;0
WireConnection;870;0;38;0
WireConnection;870;1;868;0
WireConnection;870;2;869;0
WireConnection;697;0;642;0
WireConnection;697;1;692;0
WireConnection;760;0;759;0
WireConnection;760;1;761;0
WireConnection;199;0;194;0
WireConnection;199;1;196;0
WireConnection;39;0;32;0
WireConnection;635;0;634;0
WireConnection;637;0;635;0
WireConnection;637;2;647;0
WireConnection;861;0;63;0
WireConnection;861;1;862;0
WireConnection;861;2;863;0
WireConnection;640;0;639;0
WireConnection;640;1;638;0
WireConnection;195;0;199;0
WireConnection;195;1;198;0
WireConnection;190;0;180;0
WireConnection;190;1;180;0
WireConnection;114;0;87;0
WireConnection;114;1;115;0
WireConnection;51;0;40;0
WireConnection;51;1;86;0
WireConnection;120;0;119;1
WireConnection;120;1;121;0
WireConnection;748;0;714;0
WireConnection;748;1;755;0
WireConnection;47;0;46;0
WireConnection;47;1;44;0
WireConnection;59;0;53;0
WireConnection;54;0;37;0
WireConnection;54;1;870;0
WireConnection;54;2;43;0
WireConnection;698;0;696;0
WireConnection;698;1;697;0
WireConnection;698;2;758;0
WireConnection;698;3;760;0
WireConnection;836;0;152;0
WireConnection;836;1;174;0
WireConnection;80;0;83;0
WireConnection;80;1;84;0
WireConnection;80;2;124;0
WireConnection;80;3;747;0
WireConnection;52;0;39;0
WireConnection;52;1;42;0
WireConnection;708;0;640;0
WireConnection;60;0;47;0
WireConnection;60;1;50;0
WireConnection;60;2;49;0
WireConnection;715;0;748;0
WireConnection;715;1;637;0
WireConnection;81;0;861;0
WireConnection;81;1;80;0
WireConnection;57;0;52;0
WireConnection;57;1;51;0
WireConnection;709;0;698;0
WireConnection;122;0;120;0
WireConnection;189;1;195;0
WireConnection;61;0;48;0
WireConnection;61;1;54;0
WireConnection;867;0;56;0
WireConnection;867;1;865;0
WireConnection;867;2;866;0
WireConnection;192;0;836;0
WireConnection;192;1;191;0
WireConnection;192;2;152;0
WireConnection;192;3;836;0
WireConnection;89;0;114;0
WireConnection;89;1;55;0
WireConnection;173;0;152;0
WireConnection;173;1;190;0
WireConnection;173;2;181;0
WireConnection;64;0;57;0
WireConnection;858;0;859;0
WireConnection;858;1;189;0
WireConnection;858;2;152;0
WireConnection;858;3;860;0
WireConnection;843;0;173;0
WireConnection;843;1;192;0
WireConnection;67;0;60;0
WireConnection;67;1;61;0
WireConnection;65;0;867;0
WireConnection;65;1;89;0
WireConnection;655;0;708;0
WireConnection;655;1;715;0
WireConnection;655;2;709;0
WireConnection;68;0;62;0
WireConnection;68;1;81;0
WireConnection;136;0;142;0
WireConnection;668;0;655;0
WireConnection;782;0;20;4
WireConnection;73;0;68;0
WireConnection;857;0;843;0
WireConnection;857;1;858;0
WireConnection;69;0;67;0
WireConnection;69;1;66;0
WireConnection;70;0;64;0
WireConnection;70;1;65;0
WireConnection;855;0;152;0
WireConnection;71;0;85;0
WireConnection;71;1;69;0
WireConnection;72;0;70;0
WireConnection;138;0;135;0
WireConnection;138;1;137;0
WireConnection;138;2;136;0
WireConnection;139;0;132;0
WireConnection;139;1;133;0
WireConnection;167;0;857;0
WireConnection;607;0;781;0
WireConnection;607;1;669;0
WireConnection;607;2;781;0
WireConnection;607;3;669;0
WireConnection;140;0;139;0
WireConnection;140;2;824;0
WireConnection;140;1;138;0
WireConnection;75;0;71;0
WireConnection;853;0;111;0
WireConnection;853;1;856;0
WireConnection;76;0;607;0
WireConnection;76;1;82;0
WireConnection;776;0;168;0
WireConnection;776;1;774;0
WireConnection;110;0;140;0
WireConnection;79;0;76;0
WireConnection;79;1;77;0
WireConnection;854;0;111;0
WireConnection;854;1;776;0
WireConnection;854;2;853;0
WireConnection;118;0;119;3
WireConnection;118;1;119;2
WireConnection;118;2;119;1
WireConnection;118;3;119;4
WireConnection;851;2;854;0
WireConnection;851;10;808;0
WireConnection;851;13;79;0
WireConnection;851;11;109;0
ASEEND*/
//CHKSM=42D7749711F30513DE01CCE97FE2E35D60F4D8EC