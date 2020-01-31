// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StochasticExample"
{
	Properties
	{
		_AlbedoHeight("AlbedoHeight", 2D) = "white" {}
		_SmoothnessAO("SmoothnessAO", 2D) = "white" {}
		_Normal("Normal", 2D) = "bump" {}
		_Contrast("Contrast", Range( 0.01 , 1)) = 0.15
		_Scale("Scale", Range( 0.5 , 1.5)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Assets/AmplifyStochasticNode/StochasticSampling.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Normal;
		uniform sampler2D _AlbedoHeight;
		uniform float _Scale;
		uniform float _Contrast;
		uniform sampler2D _SmoothnessAO;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord1 = i.uv_texcoord * float2( 10,10 );
			half3 cw5 = 0;
			float2 uv15 = 0;
			float2 uv25 = 0;
			float2 uv35 = 0;
			float2 dx5 = 0;
			float2 dy5 = 0;
			half4 stochasticSample5 = StochasticSample2DWeightsA(_AlbedoHeight,uv_TexCoord1,cw5,uv15,uv25,uv35,dx5,dy5,_Scale,_Contrast);
			half3 cw8 = cw5;
			float2 uv18 = uv15;
			float2 uv28 = uv25;
			float2 uv38 = uv35;
			float2 dx8 = dx5;
			float2 dy8 = dy5;
			half4  stochasticSample8 = half4(UnpackNormal(StochasticSample2D(_Normal,cw5,uv15,uv25,uv35,dx5,dy5)), 1);
			o.Normal = stochasticSample8.xyz;
			o.Albedo = stochasticSample5.xyz;
			half3 cw10 = cw8;
			float2 uv110 = uv18;
			float2 uv210 = uv28;
			float2 uv310 = uv38;
			float2 dx10 = dx8;
			float2 dy10 = dy8;
			half4  stochasticSample10 = StochasticSample2D(_SmoothnessAO,cw8,uv18,uv28,uv38,dx8,dy8);
			o.Smoothness = stochasticSample10.y;
			o.Occlusion = stochasticSample10.w;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
168;128;1450;782;1414.125;663.1516;1.436115;False;True
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1017.922,-341.9821;Float;True;Property;_AlbedoHeight;AlbedoHeight;0;0;Create;True;0;0;False;0;880a75ad4e4124da78f400820a0f9f9a;880a75ad4e4124da78f400820a0f9f9a;False;white;LockedToTexture2D;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-667.3453,-98.70889;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;10,10;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2;-1011.463,-463.2511;Float;False;Property;_Contrast;Contrast;3;0;Create;True;0;0;False;0;0.15;0.19;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1006.781,-564.7773;Float;False;Property;_Scale;Scale;4;0;Create;True;0;0;False;0;1;1.05;0.5;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;6;-989.6433,-135.8063;Float;True;Property;_Normal;Normal;2;0;Create;True;0;0;False;0;ead9df3cf7f8140bbaac1d868aa48695;ead9df3cf7f8140bbaac1d868aa48695;True;bump;LockedToTexture2D;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.AmplifyStochasticNode;5;-511.4709,-486.4936;Float;False;3;1;0.15;False;5;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;1;False;3;FLOAT;0.15;False;4;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;6;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT4x4;5
Node;AmplifyShaderEditor.TexturePropertyNode;7;-987.5194,105.5608;Float;True;Property;_SmoothnessAO;SmoothnessAO;1;0;Create;True;0;0;False;0;9a8dd88696a6e4787b38a3fe818ac0f6;9a8dd88696a6e4787b38a3fe818ac0f6;False;white;LockedToTexture2D;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.AmplifyStochasticNode;8;-217.7668,-238.2121;Float;False;4;1;0.15;True;5;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;1;False;3;FLOAT;0.15;False;4;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;6;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT4x4;5
Node;AmplifyShaderEditor.AmplifyStochasticNode;10;96.1446,-18.35288;Float;False;4;1;0.15;False;5;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;1;False;3;FLOAT;0.15;False;4;FLOAT4x4;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;6;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT4x4;5
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;450.4935,-311.7733;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;StochasticExample;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;1;0
WireConnection;5;1;3;0
WireConnection;5;2;4;0
WireConnection;5;3;2;0
WireConnection;8;0;1;0
WireConnection;8;1;6;0
WireConnection;8;4;5;5
WireConnection;10;0;1;0
WireConnection;10;1;7;0
WireConnection;10;4;8;5
WireConnection;0;0;5;0
WireConnection;0;1;8;0
WireConnection;0;4;10;2
WireConnection;0;5;10;4
ASEEND*/
//CHKSM=C2345B1DB94DB51CCD689992DBCF721AAB1059F5