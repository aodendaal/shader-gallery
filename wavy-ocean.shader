// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/WavyOcean"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			static const float mpi = 3.141592654;

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct vertOutput
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			vertOutput vert (appdata_base input)
			{
				vertOutput output;

				output.vertex = UnityObjectToClipPos(input.vertex);
				
				float2 dtexcoord = input.texcoord;
				dtexcoord.x = dtexcoord.x + sin(dtexcoord.y * 2 * mpi + _Time[0] * 2) * 0.1;

				output.uv = TRANSFORM_TEX(dtexcoord, _MainTex);

				return output;
			}
			
			fixed4 frag (vertOutput input) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, input.uv);
				return col;
			}
			ENDCG
		}
	}
}
