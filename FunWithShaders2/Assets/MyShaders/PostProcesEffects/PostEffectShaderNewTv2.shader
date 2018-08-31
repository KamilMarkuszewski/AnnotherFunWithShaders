Shader "MyShaders/PostEffectShaderNewTv2"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TimeStarted("TimeStarted", Float) = 0
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

				float avg = (col.r + col.g + col.b) / 3;
				float div = 8/time;
				col.r = col.r > avg ? col.r + avg / div : col.r - avg / div;
				col.g = col.g > avg ? col.g + avg / div : col.g - avg / div;
				col.b = col.b > avg ? col.b + avg / div : col.b - avg / div;

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
