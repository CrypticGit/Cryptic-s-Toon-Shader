// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Cryptics_RealLight_Toon_Shader V2"
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
		_ShineSize("Shine Size", Float) = 1.6
		_ShineSmoothness("Shine Smoothness", Float) = 0
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
			float4 Albedo33 = ( _Tint * ( ( tex2DNode20 * tex2D( _AO, uv_AO ) * ( tex2D( _FaceGradientOverlay, uv_FaceGradientOverlay ) * _FaceGradientStrength ) ) + float4( 0,0,0,0 ) ) );
			float A782 = tex2DNode20.a;
			o.Emission = (( _OutlineDiffuseorColor )?( Albedo33 ):( _OutlineColor )).rgb;
			clip( A782 - _Cutoff );
		}
		ENDCG
		

		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Off
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
		uniform float _ShineSize;
		uniform float _ShadeSmoothness;
		uniform sampler2D _ToonRamp;
		uniform float _Scale;
		uniform float _Offset;
		uniform float _ShineSmoothness;
		uniform float _LightingTest;
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
			float4 Albedo33 = ( _Tint * ( ( tex2DNode20 * tex2D( _AO, uv_AO ) * ( tex2D( _FaceGradientOverlay, uv_FaceGradientOverlay ) * _FaceGradientStrength ) ) + float4( 0,0,0,0 ) ) );
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
			float dotResult297 = dot( ( _ShadowStr * NormalLightDirection23 * tex2DNode716 * _ShineSize ) , temp_cast_3 );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult10 = dot( normalize( (WorldNormalVector( i , Normals3 )) ) , ase_worldViewDir );
			float NormalViewDir16 = dotResult10;
			float blendOpSrc307 = ( dotResult297 * NormalViewDir16 * _ShadeSmoothness );
			float blendOpDest307 = 0.0;
			float2 temp_cast_4 = ((NormalLightDirection23*_Scale + _Offset)).xx;
			float temp_output_2_0_g3 = 0.0;
			float temp_output_3_0_g3 = ( 1.0 - temp_output_2_0_g3 );
			float3 appendResult7_g3 = (float3(temp_output_3_0_g3 , temp_output_3_0_g3 , temp_output_3_0_g3));
			float4 Shadow59 = ( Albedo33 * float4( ( ( ( ( saturate(  (( blendOpSrc307 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpSrc307 - 0.5 ) ) * ( 1.0 - blendOpDest307 ) ) : ( 2.0 * blendOpSrc307 * blendOpDest307 ) ) )) * tex2D( _ToonRamp, temp_cast_4 ) ).rgb * temp_output_2_0_g3 ) + appendResult7_g3 ) , 0.0 ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 temp_cast_7 = (0.4).xxxx;
			float4 temp_cast_8 = (1.0).xxxx;
			float4 clampResult885 = clamp( ase_lightColor , temp_cast_7 , temp_cast_8 );
			UnityGI gi83 = gi;
			float3 diffNorm83 = WorldNormalVector( i , Normals3 );
			gi83 = UnityGI_Base( data, 1, diffNorm83 );
			float3 indirectDiffuse83 = gi83.indirect.diffuse + diffNorm83 * 0.0001;
			float4 Lighting73 = ( Shadow59 * ( clampResult885 * ( float4( ( indirectDiffuse83 * _ShineSmoothness ) , 0.0 ) + ase_lightAtten + Albedo33 + _LightingTest ) ) );
			float4 temp_cast_10 = (0.4).xxxx;
			float4 temp_cast_11 = (1.0).xxxx;
			float4 clampResult908 = clamp( ase_lightColor , temp_cast_10 , temp_cast_11 );
			float4 RimLight912 = ( saturate( ( pow( ( 1.0 - saturate( ( _RimOffset + NormalViewDir16 ) ) ) , _RimPower ) * ( NormalLightDirection23 * ase_lightAtten ) ) ) * ( clampResult908 * (( _RimTintControl )?( _RimTint ):( ( Albedo33 * _RimBrightness ) )) ) );
			float dotResult46 = dot( ( ase_worldViewDir + _WorldSpaceLightPos0.xyz ) , normalize( (WorldNormalVector( i , Normals3 )) ) );
			float smoothstepResult60 = smoothstep( _Min , _Max , pow( dotResult46 , _Gloss ));
			float2 uv_SpecularMap = i.uv_texcoord * _SpecularMap_ST.xy + _SpecularMap_ST.zw;
			float4 lerpResult54 = lerp( _SpecularColor , ase_lightColor , _SpecTransition);
			float4 Specular75 = ( ase_lightAtten * ( ( smoothstepResult60 * ( tex2D( _SpecularMap, uv_SpecularMap ) * lerpResult54 ) ) * _SpecIntensity ) );
			c.rgb = ( ( Lighting73 + RimLight912 ) + Specular75 ).rgb;
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
			float4 Albedo33 = ( _Tint * ( ( tex2DNode20 * tex2D( _AO, uv_AO ) * ( tex2D( _FaceGradientOverlay, uv_FaceGradientOverlay ) * _FaceGradientStrength ) ) + float4( 0,0,0,0 ) ) );
			float2 uv_Overlay = i.uv_texcoord * _Overlay_ST.xy + _Overlay_ST.zw;
			float4 tex2DNode152 = tex2D( _Overlay, uv_Overlay );
			float2 uv_Noise2 = i.uv_texcoord * _Noise2_ST.xy + _Noise2_ST.zw;
			float4 temp_output_180_0 = ( tex2D( _Noise, ( ( i.uv_texcoord * _Tiling ) + ( _SoeedMultiplier * _Time.y ) ) ) * tex2D( _Noise2, uv_Noise2 ) * _NoiseStrength );
			float4 temp_output_836_0 = ( tex2DNode152 * _OverlayColor );
			float4 OverlayNoise167 = ( ( ( tex2DNode152 * ( temp_output_180_0 + temp_output_180_0 ) * _OverlayStrength ) * ( temp_output_836_0 * _testoverlaything * tex2DNode152 * temp_output_836_0 ) ) + ( _StarColor * tex2D( _OverlayStars, ( float4( ( i.uv_texcoord * float2( 2,2 ) ), 0.0 , 0.0 ) + ( float4(0.1,0.1,0,0) * _Time.y ) ).xy ) * tex2DNode152 * _StarStr ) );
			float4 aaaaa855 = tex2DNode152;
			float4 lerpResult854 = lerp( Albedo33 , ( OverlayNoise167 * _OverlayTest ) , step( Albedo33 , aaaaa855 ));
			o.Albedo = lerpResult854.rgb;
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
-1857;-1846;1857;984;6641.964;1342.735;5.268524;True;True
Node;AmplifyShaderEditor.CommentaryNode;1;-6064.857,-1325.447;Inherit;False;917.425;424;Comment;2;3;2;Normals;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;2;-6014.857,-1275.447;Inherit;True;Property;_Normals;Normals;13;0;Create;True;0;0;False;0;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;5;-4931.692,-1300.85;Inherit;False;1094.509;416.4844;Comment;5;23;13;12;11;9;Normal Light Dir.;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;3;-5527.432,-1247.792;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;9;-4909.654,-1252.231;Inherit;False;3;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;12;-4915.625,-1110.756;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;4;-4948.192,-381.2226;Inherit;False;1086.897;547.3123;Comment;5;6;16;10;7;8;Normal View Dir.;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;11;-4673.465,-1250.85;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;13;-4323.401,-1136.198;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;6;-4931.422,-336.6937;Inherit;False;3;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;8;-4733.396,-188.1846;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-4126.188,-1123.997;Inherit;False;NormalLightDirection;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;21;-2956.474,102.8155;Inherit;False;1956.548;1190.069;Comment;20;96;36;29;27;59;53;41;292;294;295;297;301;302;303;307;309;716;745;757;913;Shadow;0.2641509,0.1906372,0.2610359,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;14;-2975.203,-1809.635;Inherit;False;2085.996;1536.952;Comment;13;33;705;22;116;314;20;310;315;771;772;780;782;884;Albedo;0,1,0.9648104,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;7;-4742.518,-331.2228;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;310;-2929.213,-728.2925;Inherit;True;Property;_FaceGradientOverlay;Face Gradient Overlay;8;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;292;-2898.008,423.2917;Inherit;False;23;NormalLightDirection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;10;-4450.395,-330.4846;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;716;-2897.374,188.4456;Inherit;True;Property;_CustomShadowthing;Custom Shadow thing;43;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;745;-2903.316,539.3938;Inherit;False;Property;_ShineSize;Shine Size;17;0;Create;True;0;0;False;0;1.6;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;-2615.125,-667.6745;Inherit;False;Property;_FaceGradientStrength;Face Gradient Strength;9;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;295;-2539.745,209.0301;Inherit;False;Property;_ShadowStr;Shadow Str;42;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;314;-2571.768,-901.7955;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;166;-864.4107,350.3289;Inherit;False;2418.843;1665.741;Comment;34;167;855;857;858;843;860;859;192;189;173;195;190;191;836;181;180;152;174;199;198;202;179;200;196;194;151;186;153;156;157;164;163;158;165;Overlay Noise;1,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;16;-4241.395,-336.4846;Inherit;False;NormalViewDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;116;-2930.368,-959.7806;Inherit;True;Property;_AO;AO;10;0;Create;True;0;0;False;0;-1;None;4c366e408e235524d97821ebfce30a48;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-2940.033,-1495.615;Inherit;True;Property;_Albedo;Albedo;7;0;Create;True;0;0;False;0;-1;None;3d01980a26448054693d95db36373734;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-2567.455,367.0552;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;303;-2357.636,627.2515;Inherit;False;Property;_ShadeSmoothness;Shade Smoothness;40;0;Create;True;0;0;False;0;2;216.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;302;-2365.187,492.5918;Inherit;False;16;NormalViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-2868.112,1010.363;Inherit;False;Property;_Scale;Scale;4;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;297;-2280.787,248.957;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;164;-798.7378,696.329;Inherit;False;Property;_SoeedMultiplier;Soeed Multiplier;35;0;Create;True;0;0;False;0;-0.5,0.5;-0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;888;-3010.208,2549.086;Inherit;False;2016.228;818.548;Comment;24;912;911;910;909;908;907;906;905;904;903;902;901;900;899;898;897;896;895;894;893;892;891;890;889;Rimlight;1,0.9475075,0,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;165;-797.6099,851.6873;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;158;-800.7378,400.3289;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;771;-2374.097,-1459.369;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;163;-804.7378,563.3289;Inherit;False;Property;_Tiling;Tiling;36;0;Create;True;0;0;False;0;1,0.2;1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;27;-2866.901,1097.597;Inherit;False;Property;_Offset;Offset;3;0;Create;True;0;0;False;0;0.45;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;22;-2908.432,-1706.725;Inherit;False;Property;_Tint;Tint;6;0;Create;True;0;0;False;0;0.8301887,0.8301887,0.8301887,0;0.2264151,0.2264151,0.2264151,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;36;-2644.414,1012.963;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;889;-2896.432,2599.086;Float;False;Property;_RimOffset;Rim Offset;24;0;Create;True;0;0;False;0;0.5;0.83;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-458.2174,568.2998;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;890;-2964.107,2719.688;Inherit;False;16;NormalViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;18;-3207.946,3743.55;Inherit;False;2297.76;1281.211;Comment;23;75;71;69;67;66;61;60;54;50;49;48;47;46;44;43;38;37;35;34;31;26;24;85;Specular;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-468.2174,711.2998;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;780;-2120.174,-1563.612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;301;-2016.279,405.3545;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;96;-2356.085,981.5109;Inherit;True;Property;_ToonRamp;Toon Ramp;12;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;772;-1933.209,-1676.01;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;891;-2684.208,2649.388;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;31;-3131.946,4126.892;Inherit;False;3;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;24;-3157.946,3985.892;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;58;-3000.964,1464.196;Inherit;False;1636.269;870.8802;Comment;16;81;80;63;747;83;124;84;78;73;68;62;871;872;885;886;887;Real Lighting;0.9914972,1,0.6273585,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;153;-294.6393,649.6309;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;307;-1957.071,686.7499;Inherit;True;HardLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;26;-3103.819,3793.55;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;151;-319.6599,822.7646;Inherit;True;Property;_Noise;Noise;38;0;Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;78;-2948.459,1845.837;Inherit;False;3;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;309;-1635.667,842.3384;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;200;-661.5339,1673.793;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;123;-712.4779,-783.6612;Inherit;False;946.5361;506.308;Comment;5;118;122;120;121;119;Vertex Paint;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-2819.946,3873.893;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector2Node;196;-690.7018,1363.535;Inherit;False;Constant;_Vector0;Vector 0;30;0;Create;True;0;0;False;0;2,2;1,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector4Node;202;-690.7136,1498.692;Inherit;False;Constant;_Vector1;Vector 1;35;0;Create;True;0;0;False;0;0.1,0.1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;34;-2866.946,4136.892;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexCoordVertexDataNode;194;-685.7018,1200.534;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;892;-2518.208,2657.388;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;179;-332.8727,1048.488;Inherit;True;Property;_Noise2;Noise2;39;0;Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;33;-1531.164,-1677.003;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-18.34337,1112.141;Inherit;False;Property;_NoiseStrength;Noise Strength;37;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;114.0745,842.5394;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;152;-123.2252,427.335;Inherit;True;Property;_Overlay;Overlay;31;0;Create;True;0;0;False;0;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;897;-2007.002,3112.423;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-426.1257,-482.3533;Inherit;False;Constant;_VertexPaint;Vertex Paint;25;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;119;-662.478,-733.6613;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;37;-2179.171,4573.188;Inherit;False;Property;_SpecularColor;Specular Color;19;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;41;-1703.948,532.0325;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;46;-2644.945,3995.891;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;83;-2739.428,1851.272;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LightColorNode;38;-2138.171,4777.188;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;913;-1521.156,727.7179;Inherit;False;Lerp White To;-1;;3;047d7c189c36a62438973bad9d37b1c2;0;2;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-353.1803,1511.504;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-2247.171,4912.188;Float;False;Property;_SpecTransition;Spec Transition;21;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-343.1803,1368.504;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;895;-2202.481,3144.626;Inherit;False;Property;_RimBrightness;Rim Brightness;26;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;898;-2353.887,2855.626;Inherit;False;Property;_RimPower;Rim Power;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;896;-2367.757,2969.682;Inherit;False;23;NormalLightDirection;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;893;-2248.207,2667.388;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;894;-2371.594,3060.374;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;174;-18.19395,1187.696;Inherit;False;Property;_OverlayColor;Overlay Color;27;0;Create;True;0;0;False;0;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;44;-2523.946,4174.891;Float;False;Property;_Gloss;Gloss;22;0;Create;True;0;0;False;0;0.32;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;872;-2662.248,1961.019;Inherit;False;Property;_ShineSmoothness;Shine Smoothness;18;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-1837.171,4556.188;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;47;-2398.946,4020.891;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;904;-1792.75,3091.298;Inherit;False;Constant;_Float3;Float 3;30;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-2220.944,4218.891;Inherit;False;Property;_Max;Max;16;0;Create;True;0;0;False;0;4;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;349.8226,995.7744;Inherit;False;Property;_testoverlaything;test overlay thing;32;0;Create;True;0;0;False;0;35;35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;-2643.187,1753.355;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;886;-2545.992,1522.8;Inherit;False;Constant;_Float1;Float 1;49;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-2220.944,4143.891;Inherit;False;Property;_Min;Min;15;0;Create;True;0;0;False;0;7;0.68;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;195;-179.6031,1449.836;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;181;381.0442,569.5088;Inherit;False;Property;_OverlayStrength;Overlay Strength;30;0;Create;True;0;0;False;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;836;425.2522,1053.941;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-173.1259,-678.3533;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;48;-2178.706,4329.094;Inherit;True;Property;_SpecularMap;Specular Map;14;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1451.948,589.0325;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;84;-2618.719,2126.033;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;905;-1577.892,3194.694;Inherit;False;Property;_RimTint;Rim Tint;23;0;Create;True;0;0;False;0;0,1,0.9903991,0;0,1,0.9903991,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;902;-2031.714,2706.633;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;887;-2781.992,1574.8;Inherit;False;Constant;_Float2;Float 2;49;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;899;-1786.75,3164.298;Inherit;False;Constant;_Float4;Float 4;30;0;Create;True;0;0;False;0;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;901;-1882.092,3210.157;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;900;-2008.889,3006.913;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;63;-2584.114,1612.521;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;747;-2607.635,2045.414;Inherit;False;Property;_LightingTest;Lighting Test;44;0;Create;True;0;0;False;0;1;0.69;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;871;-2468.248,1867.019;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;190;415.5345,777.8848;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;903;-1844.407,2961.139;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;60;-2028.928,4028.878;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;860;364.6505,1523.582;Inherit;False;Property;_StarStr;Star Str;29;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-10.94206,-678.2512;Inherit;False;VertexPaint;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1800.136,4380.209;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;192;692.8235,816.5557;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-1271.454,634.4502;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;108;-5011.699,577.2057;Inherit;False;1225.321;1048.024;Comment;11;110;135;136;137;138;139;140;132;133;142;824;Outline;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;80;-2284.038,1890.167;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;189;-17.95568,1423.021;Inherit;True;Property;_OverlayStars;Overlay Stars;34;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;885;-2320.992,1652.8;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;906;-1843.959,2718.949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;908;-1635.273,2976.001;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;859;214.1622,1254.51;Inherit;False;Property;_StarColor;Star Color;28;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;173;670.9661,566.6199;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;907;-1327.683,3132.972;Inherit;False;Property;_RimTintControl;Rim Tint Control;25;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;909;-1453.948,3010.634;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;858;508.0026,1319.573;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;81;-2151.617,1773.012;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;843;884.109,604.6754;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;910;-1666.417,2720.162;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-4973.449,1054.498;Inherit;False;122;VertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-1755.86,4030.403;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;62;-2170.504,1530.217;Inherit;False;59;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1656.878,4237.93;Inherit;False;Property;_SpecIntensity;Spec Intensity;20;0;Create;True;0;0;False;0;0;0.143;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-4604.98,885.8935;Float;False;Constant;_Float46;Float 46;17;0;Create;True;0;0;False;0;1E-05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;-4709.904,964.8415;Float;False;Property;_OutlineThickness;Outline Thickness;1;0;Create;True;0;0;False;0;200;200;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;132;-4973.294,657.2835;Float;False;Property;_OutlineColor;Outline Color;11;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;857;1137.609,667.0234;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-4974.323,857.0765;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;782;-2609.349,-1261.877;Inherit;False;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;136;-4718.336,1081.462;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;911;-1462.407,2716.139;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1880.786,1567.691;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1573.005,4043.436;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;85;-1702.906,3909.159;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-4363.509,1002.171;Inherit;False;3;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1607.696,1552.898;Inherit;False;Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;1247.664,594.2051;Float;False;OverlayNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;824;-4390.019,892.1899;Inherit;False;782;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;912;-1236.979,2687.255;Inherit;False;RimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;139;-4473.064,723.1115;Inherit;False;Property;_OutlineDiffuseorColor;Outline Diffuse or Color;2;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-1376.877,4034.931;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;855;299.5384,422.4279;Inherit;False;aaaaa;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;1036.669,-181.7996;Inherit;False;912;RimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OutlineNode;140;-4118.659,995.378;Inherit;False;0;True;Masked;0;0;Front;3;0;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;111;1594.928,-592.6704;Inherit;False;33;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-1164.877,4037.931;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;856;1811.771,-206.0102;Inherit;False;855;aaaaa;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;1355.259,-509.382;Inherit;False;167;OverlayNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;774;1397.794,-297.2659;Inherit;False;Property;_OverlayTest;Overlay Test;33;0;Create;True;0;0;False;0;22;22;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;861;1035.31,-301.1521;Inherit;False;73;Lighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;853;2042.777,-268.2355;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;1256.317,55.59018;Inherit;False;75;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;1390.011,-151.8294;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;776;1617.96,-357.4421;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;-4057.843,863.2431;Inherit;False;Outline;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;757;-2612.112,653.5175;Inherit;False;CST;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;79;1682.461,-52.65336;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;884;-2503.517,-1582.189;Inherit;False;tex;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;808;1976.419,112.7967;Inherit;False;782;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;854;2197.154,-408.0471;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;118;-412.5389,-679.1293;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;109;1982.886,210.3449;Inherit;False;110;Outline;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;705;-2934.635,-1275.469;Inherit;True;Property;_ColorMask;Color Mask;41;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;851;2536.777,-220.3511;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Cryptics_RealLight_Toon_Shader V2;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.CommentaryNode;149;-5189.434,-2323.848;Inherit;False;1075.082;100;I watched this video to create this shader: https://youtu.be/MawzivWLCoo;0;Credits: Shader is created by CrypticLight using Amplified Shader Editor;0.9994125,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;150;-5018.969,7146.9;Inherit;False;1075.082;100;I watched this video to create this shader: https://youtu.be/MawzivWLCoo;0;Credits: Shader is created by CrypticLight using Amplified Shader Editor;0.9994125,0,1,1;0;0
WireConnection;3;0;2;0
WireConnection;11;0;9;0
WireConnection;13;0;11;0
WireConnection;13;1;12;0
WireConnection;23;0;13;0
WireConnection;7;0;6;0
WireConnection;10;0;7;0
WireConnection;10;1;8;0
WireConnection;314;0;310;0
WireConnection;314;1;315;0
WireConnection;16;0;10;0
WireConnection;294;0;295;0
WireConnection;294;1;292;0
WireConnection;294;2;716;0
WireConnection;294;3;745;0
WireConnection;297;0;294;0
WireConnection;297;1;295;0
WireConnection;771;0;20;0
WireConnection;771;1;116;0
WireConnection;771;2;314;0
WireConnection;36;0;292;0
WireConnection;36;1;29;0
WireConnection;36;2;27;0
WireConnection;156;0;158;0
WireConnection;156;1;163;0
WireConnection;157;0;164;0
WireConnection;157;1;165;0
WireConnection;780;0;771;0
WireConnection;301;0;297;0
WireConnection;301;1;302;0
WireConnection;301;2;303;0
WireConnection;96;1;36;0
WireConnection;772;0;22;0
WireConnection;772;1;780;0
WireConnection;891;0;889;0
WireConnection;891;1;890;0
WireConnection;153;0;156;0
WireConnection;153;1;157;0
WireConnection;307;0;301;0
WireConnection;151;1;153;0
WireConnection;309;0;307;0
WireConnection;309;1;96;0
WireConnection;35;0;26;0
WireConnection;35;1;24;1
WireConnection;34;0;31;0
WireConnection;892;0;891;0
WireConnection;33;0;772;0
WireConnection;180;0;151;0
WireConnection;180;1;179;0
WireConnection;180;2;186;0
WireConnection;46;0;35;0
WireConnection;46;1;34;0
WireConnection;83;0;78;0
WireConnection;913;1;309;0
WireConnection;198;0;202;0
WireConnection;198;1;200;0
WireConnection;199;0;194;0
WireConnection;199;1;196;0
WireConnection;893;0;892;0
WireConnection;54;0;37;0
WireConnection;54;1;38;0
WireConnection;54;2;43;0
WireConnection;47;0;46;0
WireConnection;47;1;44;0
WireConnection;195;0;199;0
WireConnection;195;1;198;0
WireConnection;836;0;152;0
WireConnection;836;1;174;0
WireConnection;120;0;119;1
WireConnection;120;1;121;0
WireConnection;53;0;41;0
WireConnection;53;1;913;0
WireConnection;902;0;893;0
WireConnection;902;1;898;0
WireConnection;901;0;897;0
WireConnection;901;1;895;0
WireConnection;900;0;896;0
WireConnection;900;1;894;0
WireConnection;871;0;83;0
WireConnection;871;1;872;0
WireConnection;190;0;180;0
WireConnection;190;1;180;0
WireConnection;60;0;47;0
WireConnection;60;1;50;0
WireConnection;60;2;49;0
WireConnection;122;0;120;0
WireConnection;61;0;48;0
WireConnection;61;1;54;0
WireConnection;192;0;836;0
WireConnection;192;1;191;0
WireConnection;192;2;152;0
WireConnection;192;3;836;0
WireConnection;59;0;53;0
WireConnection;80;0;871;0
WireConnection;80;1;84;0
WireConnection;80;2;124;0
WireConnection;80;3;747;0
WireConnection;189;1;195;0
WireConnection;885;0;63;0
WireConnection;885;1;886;0
WireConnection;885;2;887;0
WireConnection;906;0;902;0
WireConnection;906;1;900;0
WireConnection;908;0;903;0
WireConnection;908;1;899;0
WireConnection;908;2;904;0
WireConnection;173;0;152;0
WireConnection;173;1;190;0
WireConnection;173;2;181;0
WireConnection;907;0;901;0
WireConnection;907;1;905;0
WireConnection;909;0;908;0
WireConnection;909;1;907;0
WireConnection;858;0;859;0
WireConnection;858;1;189;0
WireConnection;858;2;152;0
WireConnection;858;3;860;0
WireConnection;81;0;885;0
WireConnection;81;1;80;0
WireConnection;843;0;173;0
WireConnection;843;1;192;0
WireConnection;910;0;906;0
WireConnection;67;0;60;0
WireConnection;67;1;61;0
WireConnection;857;0;843;0
WireConnection;857;1;858;0
WireConnection;782;0;20;4
WireConnection;136;0;142;0
WireConnection;911;0;910;0
WireConnection;911;1;909;0
WireConnection;68;0;62;0
WireConnection;68;1;81;0
WireConnection;69;0;67;0
WireConnection;69;1;66;0
WireConnection;138;0;135;0
WireConnection;138;1;137;0
WireConnection;138;2;136;0
WireConnection;73;0;68;0
WireConnection;167;0;857;0
WireConnection;912;0;911;0
WireConnection;139;0;132;0
WireConnection;139;1;133;0
WireConnection;71;0;85;0
WireConnection;71;1;69;0
WireConnection;855;0;152;0
WireConnection;140;0;139;0
WireConnection;140;2;824;0
WireConnection;140;1;138;0
WireConnection;75;0;71;0
WireConnection;853;0;111;0
WireConnection;853;1;856;0
WireConnection;76;0;861;0
WireConnection;76;1;82;0
WireConnection;776;0;168;0
WireConnection;776;1;774;0
WireConnection;110;0;140;0
WireConnection;757;0;716;0
WireConnection;79;0;76;0
WireConnection;79;1;77;0
WireConnection;884;0;20;0
WireConnection;854;0;111;0
WireConnection;854;1;776;0
WireConnection;854;2;853;0
WireConnection;118;0;119;3
WireConnection;118;1;119;2
WireConnection;118;2;119;1
WireConnection;118;3;119;4
WireConnection;851;0;854;0
WireConnection;851;10;808;0
WireConnection;851;13;79;0
WireConnection;851;11;109;0
ASEEND*/
//CHKSM=01B3794401EBF39F2D48CB36E2CADD36A91564DD