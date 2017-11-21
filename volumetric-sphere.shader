// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/VolumetricSphere"
{
	Properties
	{
		_Center ("Center", Vector) = (0, 0, 0, 0)
		_Radius ("Radius", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			float3 _Center;
			float _Radius;
		
			#define STEPS 64
			#define STEP_SIZE 0.01

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 wPos : TEXCOORD1;
			};

			bool sphereHit(float3 pos)
			{
				return distance(pos, _Center) < _Radius;
			}

			bool raymarchHit(float3 worldPos, float3 viewDir)
			{
				for (int i = 0; i < STEPS; i++)
				{
					if (sphereHit(worldPos))
					{
						return true;
					}

					worldPos += viewDir * STEP_SIZE;
				}

				return false;
			}

			v2f vert (appdata_base input)
			{
				v2f output;
				output.vertex = UnityObjectToClipPos(input.vertex);
				output.wPos = mul(unity_ObjectToWorld, input.vertex).xyz; 

				return output;
			}

			fixed4 frag (v2f input) : SV_Target
			{
				float3 worldPos = input.wPos;
				float3 viewDir = normalize(input.wPos - _WorldSpaceCameraPos);

				fixed4 color;

				if (raymarchHit(worldPos, viewDir))
				{
					color = fixed4(1,0,0,1);
				}
				else
				{
					color = fixed4(1,1,1,1);
				}

				return color;
			}

			ENDCG
		}
	}
}
