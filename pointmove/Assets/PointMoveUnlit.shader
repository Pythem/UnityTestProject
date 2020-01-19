﻿Shader "Unlit/PointMoveUnlit"
{
    Properties
    {
        _Color("Color",color)=(1,0,0.65,1)
        _Direction("Direection",vector)=(0,0,0,1)
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                fixed NdotD:TEXCOORD1;
            };

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            vector _Direction;

            v2f vert (appdata v)
            {
                v2f o;

                //模型空间转世界空间
               float4 wPos = mul(unity_ObjectToWorld,v.vertex);

               //法线模型空间转世界空间
                half3 wNormal = UnityObjectToWorldNormal(v.normal);


                fixed NdotD = max(0,dot(wNormal,_Direction));
                o.NdotD = NdotD;
                float noise = frac(sin(dot(v.uv.xy, float2(12.9898, 78.233))) * 43758.5453);
                wPos.xyz += _Direction.xyz * _Direction.w * noise * NdotD;
                o.vertex=mul(UNITY_MATRIX_VP,wPos);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col+=i.NdotD*_Color;
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
