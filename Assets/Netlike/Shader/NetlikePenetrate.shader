Shader "ShaderLib/NetlikePenetrate"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 screenPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			int global_pixel_penetrate_count;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				o.screenPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);

				// wcoord:
				// 0,1      1,1
				//
				// 0,0      1,0
				float2 wcoord = (i.screenPos.xy / i.screenPos.w);
				// 屏幕像素位置
				float2 screen_pixel_coord = wcoord * _ScreenParams.xy;

				float2 penetrate_factor = 1.0 / global_pixel_penetrate_count;
				//　浮点地板 * 0.5
				//screen_pixel_coord = floor(screen_pixel_coord * 0.25) * 0.5;
				screen_pixel_coord = floor(screen_pixel_coord * penetrate_factor) * 0.5;
				// 取小数
				float checker = -frac(screen_pixel_coord.x + screen_pixel_coord.y);
				// clip HLSL instruction stops rendering a pixel if value is negative
				clip(checker);

				// 输出wcoord数值
				//return fixed4(wcoord.xy, 0.0, 1.0);

				return col;
			}
			ENDCG
		}
	}
}
