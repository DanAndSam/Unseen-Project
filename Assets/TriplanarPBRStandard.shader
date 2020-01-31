// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TriplanarPBRStandard"
{
	Properties
	{
		_AlbedoAlpha("Albedo/Alpha", 2D) = "white" {}
		_AlbedoColor("AlbedoColor", Color) = (1,1,1,0)
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_Normal("Normal", 2D) = "bump" {}
		_NormalScale("NormalScale", Range( 0 , 10)) = 1
		_MetallicSmoothnessAOEmission("Metallic/Smoothness/AO/Emission", 2D) = "black" {}
		_MetallicScale("MetallicScale", Range( 0 , 1)) = 0
		_SmoothnessScale("SmoothnessScale", Range( 0 , 1)) = 0
		_AOScale("AOScale", Range( 0 , 1)) = 0
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_EmissionScale("EmissionScale", Range( 0 , 1)) = 1
		_TriplanarTilling("TriplanarTilling", Vector) = (1,1,0,0)
		_Triplanar2ndTilling("Triplanar2ndTilling", Vector) = (0,0,0,0)
		_2nd_MetallicSmoothnessAOEmission("2nd_Metallic/Smoothness/AO/Emission", 2D) = "black" {}
		[Toggle]_2ndSmoothAB("2ndSmoothA/B", Float) = 0
		_2ndSmoothnessScale("2ndSmoothnessScale", Range( -1 , 1)) = 0
		_StochasticScale("StochasticScale", Range( 0 , 1.5)) = 0
		_StochasticContrast("StochasticContrast", Range( 0.1 , 0.99)) = 0
		_StochasticTilling("StochasticTilling ", Range( 0 , 10)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "Assets/AmplifyStochasticNode/StochasticSampling.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#define ASE_TEXTURE_PARAMS(textureName) textureName

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
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform float2 _TriplanarTilling;
		uniform float _NormalScale;
		uniform float4 _AlbedoColor;
		uniform sampler2D _AlbedoAlpha;
		uniform sampler2D _MetallicSmoothnessAOEmission;
		uniform float2 _Triplanar2ndTilling;
		uniform float _EmissionScale;
		uniform float4 _EmissionColor;
		uniform float _MetallicScale;
		uniform float _2ndSmoothAB;
		uniform float _StochasticTilling;
		uniform sampler2D _2nd_MetallicSmoothnessAOEmission;
		uniform float _StochasticScale;
		uniform float _StochasticContrast;
		uniform float _2ndSmoothnessScale;
		uniform float _SmoothnessScale;
		uniform float _AOScale;
		uniform float _Cutoff = 0.5;


		inline float3 TriplanarSamplingSNF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			xNorm.xyz = half3( UnpackScaleNormal( xNorm, normalScale.y ).xy * float2( nsign.x, 1.0 ) + worldNormal.zy, worldNormal.x ).zyx;
			yNorm.xyz = half3( UnpackScaleNormal( yNorm, normalScale.x ).xy * float2( nsign.y, 1.0 ) + worldNormal.xz, worldNormal.y ).xzy;
			zNorm.xyz = half3( UnpackScaleNormal( zNorm, normalScale.y ).xy * float2( -nsign.z, 1.0 ) + worldNormal.xy, worldNormal.z ).xyz;
			return normalize( xNorm.xyz * projNormal.x + yNorm.xyz * projNormal.y + zNorm.xyz * projNormal.z );
		}


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 ase_worldBitangent = WorldNormalVector( i, float3( 0, 1, 0 ) );
			float3x3 ase_worldToTangent = float3x3( ase_worldTangent, ase_worldBitangent, ase_worldNormal );
			float3 triplanar2 = TriplanarSamplingSNF( _Normal, ase_worldPos, ase_worldNormal, 1.0, _TriplanarTilling, _NormalScale, 0 );
			float3 tanTriplanarNormal2 = mul( ase_worldToTangent, triplanar2 );
			o.Normal = tanTriplanarNormal2;
			float4 triplanar1 = TriplanarSamplingSF( _AlbedoAlpha, ase_worldPos, ase_worldNormal, 1.0, _TriplanarTilling, 1.0, 0 );
			o.Albedo = ( _AlbedoColor * triplanar1 ).rgb;
			float4 triplanar39 = TriplanarSamplingSF( _MetallicSmoothnessAOEmission, ase_worldPos, ase_worldNormal, 1.0, _Triplanar2ndTilling, 1.0, 0 );
			float temp_output_64_0 = ( triplanar39.w * _EmissionScale );
			o.Emission = ( temp_output_64_0 * _EmissionColor ).rgb;
			float4 triplanar3 = TriplanarSamplingSF( _MetallicSmoothnessAOEmission, ase_worldPos, ase_worldNormal, 1.0, _TriplanarTilling, 1.0, 0 );
			o.Metallic = ( triplanar3.x * _MetallicScale );
			float2 temp_cast_3 = (_StochasticTilling).xx;
			float2 uv_TexCoord30 = i.uv_texcoord * temp_cast_3;
			half3 cw27 = 0;
			float2 uv127 = 0;
			float2 uv227 = 0;
			float2 uv327 = 0;
			float2 dx27 = 0;
			float2 dy27 = 0;
			half4 stochasticSample27 = StochasticSample2DWeightsLum(_2nd_MetallicSmoothnessAOEmission,uv_TexCoord30,cw27,uv127,uv227,uv327,dx27,dy27,_StochasticScale,_StochasticContrast);
			float clampResult33 = clamp( ( temp_output_64_0 + triplanar3.y + ( lerp(stochasticSample27.x,stochasticSample27.y,_2ndSmoothAB) * _2ndSmoothnessScale ) ) , 0.0 , 1.0 );
			o.Smoothness = ( clampResult33 * _SmoothnessScale );
			float clampResult43 = clamp( ( triplanar3.z + _AOScale ) , 0.0 , 1.0 );
			o.Occlusion = clampResult43;
			o.Alpha = 1;
			clip( triplanar1.w - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

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
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
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
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
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
Version=16700
1927;7;1906;1004;1008.594;766.2433;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;31;-1843.697,927.847;Float;False;Property;_StochasticTilling;StochasticTilling ;20;0;Create;True;0;0;False;0;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1269.637,1106.109;Float;False;Property;_StochasticScale;StochasticScale;18;0;Create;True;0;0;False;0;0;1;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-1482.916,906.7057;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;35;-1268.637,1198.109;Float;False;Property;_StochasticContrast;StochasticContrast;19;0;Create;True;0;0;False;0;0;0.99;0.1;0.99;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;50;-1380.603,1294.041;Float;True;Property;_2nd_MetallicSmoothnessAOEmission;2nd_Metallic/Smoothness/AO/Emission;13;0;Create;True;0;0;False;0;None;35e33466b0cc32d469875c951607ba19;False;black;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.AmplifyStochasticNode;27;-938.1909,1167.29;Float;False;4;1;0.15;False;5;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;1;False;3;FLOAT;0.15;False;4;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;6;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT4x4;5
Node;AmplifyShaderEditor.Vector2Node;49;-1392.707,394.5411;Float;False;Property;_Triplanar2ndTilling;Triplanar2ndTilling;12;0;Create;True;0;0;False;0;0,0;0.05,0.05;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;29;-1185.268,648.6647;Float;True;Property;_MetallicSmoothnessAOEmission;Metallic/Smoothness/AO/Emission;5;0;Create;True;0;0;False;0;None;cd5f91ce41d07b440a73b5adf9e454f7;False;black;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.Vector2Node;8;-1399.525,56.40379;Float;False;Property;_TriplanarTilling;TriplanarTilling;11;0;Create;True;0;0;False;0;1,1;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ToggleSwitchNode;62;-603.4695,912.2352;Float;False;Property;_2ndSmoothAB;2ndSmoothA/B;14;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-687.5435,834.9636;Float;False;Property;_EmissionScale;EmissionScale;10;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-387.0507,1116.197;Float;False;Property;_2ndSmoothnessScale;2ndSmoothnessScale;16;0;Create;True;0;0;False;0;0;1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;39;-795.6036,643.9332;Float;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-333.9437,648.8649;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-66.03186,241.0312;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;3;-785.4363,239.3871;Float;True;Spherical;World;False;A;_A;black;3;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-132.6911,538.3513;Float;False;Property;_AOScale;AOScale;8;0;Create;True;0;0;False;0;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;194.1838,144.4269;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;192.807,63.40752;Float;False;Property;_SmoothnessScale;SmoothnessScale;7;0;Create;True;0;0;False;0;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-144.0481,110.5952;Float;False;Property;_MetallicScale;MetallicScale;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1451.604,-70.40303;Float;False;Property;_NormalScale;NormalScale;4;0;Create;True;0;0;False;0;1;1;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;182.6718,287.8284;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;33;365.4926,144.2608;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;75;-609.9163,-328.6447;Float;False;Property;_AlbedoColor;AlbedoColor;1;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-612.5363,434.3872;Float;False;Property;_EmissionColor;EmissionColor;9;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;1;-787,-152.9441;Float;True;Spherical;World;False;Albedo/Alpha;_AlbedoAlpha;white;0;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;52;-389.719,1291.85;Float;False;Property;_2ndMetallicScale;2ndMetallicScale;15;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;43;366.9001,286.0566;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-389.8701,1371.401;Float;False;Property;_2ndAOScale;2ndAOScale;17;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;2;-784.8239,36.52465;Float;True;Spherical;World;True;Normal;_Normal;bump;3;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;185.4265,-30.69759;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-344.1766,421.8588;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;498.407,-82.19234;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-252.9163,-321.6447;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;697.319,-344.6626;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;TriplanarPBRStandard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;31;0
WireConnection;27;0;30;0
WireConnection;27;1;50;0
WireConnection;27;2;36;0
WireConnection;27;3;35;0
WireConnection;62;0;27;1
WireConnection;62;1;27;2
WireConnection;39;0;29;0
WireConnection;39;3;49;0
WireConnection;64;0;39;4
WireConnection;64;1;63;0
WireConnection;61;0;62;0
WireConnection;61;1;56;0
WireConnection;3;0;29;0
WireConnection;3;3;8;0
WireConnection;34;0;64;0
WireConnection;34;1;3;2
WireConnection;34;2;61;0
WireConnection;44;0;3;3
WireConnection;44;1;40;0
WireConnection;33;0;34;0
WireConnection;1;3;8;0
WireConnection;43;0;44;0
WireConnection;2;8;6;0
WireConnection;2;3;8;0
WireConnection;45;0;3;1
WireConnection;45;1;46;0
WireConnection;5;0;64;0
WireConnection;5;1;4;0
WireConnection;48;0;33;0
WireConnection;48;1;47;0
WireConnection;76;0;75;0
WireConnection;76;1;1;0
WireConnection;0;0;76;0
WireConnection;0;1;2;0
WireConnection;0;2;5;0
WireConnection;0;3;45;0
WireConnection;0;4;48;0
WireConnection;0;5;43;0
WireConnection;0;10;1;4
ASEEND*/
//CHKSM=64E5902744F7C58DBB80B6EF5001A56448EA50BD