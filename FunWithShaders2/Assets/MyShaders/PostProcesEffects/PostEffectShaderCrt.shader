Shader "MyShaders/PostEffectShaderCrt"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TimeStarted("TimeStarted", Float) = 0
		_Divider("Divider", float) = 50
		_Thickness("_Thickness", float) = 0.2
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
			float _Divider;
			float _Thickness;
			
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

				int intMod = i.vertex.y / _Divider;
				float floatMod = i.vertex.y / _Divider;

				if (floatMod - intMod < _Thickness)
				{
					col.r += 0.05 * time;
				}
				if (floatMod - intMod > _Thickness && floatMod - intMod < _Thickness*2)
				{
					col.g += 0.05 * time;
				}
				if (floatMod - intMod > _Thickness*2 && floatMod - intMod < _Thickness*3)
				{
					col.b += 0.05 * time;
				}

				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
