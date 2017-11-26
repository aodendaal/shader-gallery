Shader "Custom/PixelateBackground"
{
	Properties 
	{
		[Toggle] _Pixelate("Pixelate", Float) = 0
		_PixelSize ("Pixel Size", Range(0.01, 0.1)) = 0.05
	}
	SubShader
	{
		Tags { "Queue"="Transparent" }

		GrabPass
        {
        }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			float _PixelSize;
			float _Pixelate;

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 grabPos : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};

			sampler2D _GrabTexture;
			float4 _GrabTexture_ST;
			
			v2f vert (appdata_base input)
			{
				v2f output;

				output.vertex = UnityObjectToClipPos(input.vertex);
				output.grabPos = ComputeGrabScreenPos(output.vertex);

				return output;
			}
			
			float4 frag (v2f input) : SV_Target
			{
				float4 col;

				if (_Pixelate == 1)
				{
					col = tex2Dproj(_GrabTexture, floor(input.grabPos / _PixelSize));
				}
				else
				{
					col = tex2Dproj(_GrabTexture, input.grabPos);
				}

				// Convert to grey scale
				// The constants 0.3, 0.59, and 0.11 are because the human eye is more sensitive to green light, and less to blue.
				col = dot(col.rgb, float3(0.3, 0.59, 0.11));

				// Split grey scale into 4 GameBoy colors
				if (col.r <= 0.25)
				{
					col = float4(0.06, 0.22, 0.06, 1);
				}
				else if (col.r > 0.25 && col.r <= 0.5)
				{
					col = float4(0.19, 0.38, 0.19, 1);				
				}
				else if (col.r > 0.5 && col.r <= 0.75)
				{
					col = float4(0.55, 0.67, 0.06, 1);				
				}
				else if (col.r > 0.75)
				{
					col = float4(0.6, 0.74, 0.06, 1);				
				}

				return col;
			}
			ENDCG
		}
	}
}
