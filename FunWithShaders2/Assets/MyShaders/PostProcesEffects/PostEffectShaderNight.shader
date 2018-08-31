Shader "MyShaders/PostEffectShaderNight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TimeStarted("TimeStarted", Float) = 0
		_ColorSubtract("_ColorSubtract", Color) = (0.05, 0.05, 0.05, 1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _TimeStarted;
			fixed4 _ColorSubtract;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float time = 1.0 + (_Time[1] - _TimeStarted);
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				col.r -= time * _ColorSubtract.r;
				col.g -= time * _ColorSubtract.g;
				col.b -= time * _ColorSubtract.b;

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
