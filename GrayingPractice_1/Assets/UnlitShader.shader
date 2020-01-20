Shader "Unlit/UnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        //灰度圆心
        _Position("World Position",Vector) = (0,0,0,1)
        //半径
        _Radius("Radius",Range(0,100)) = 3
        //中心到边远的过度
        _Softness("Softness",Range(0,100))=5
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

                 //各顶点在世界坐标的寄存器，用于在frag函数中做distance计算
                float4 w_p : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
           

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

               //unityOObjectTOWorld是内置的模型空间转世界空间的矩阵
                o.w_p =mul(unity_ObjectToWorld,v.vertex);

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            //引入属性
            float _Radius;
            float4 _Position;
            float _Softness;
            //lerp(a,b,w)函数有三个参数a b w，它的内部的实现通过(1-w)*a+w*b ,（当w等于0时返回a，当w等于1时返回b，当0<w<1则会对a与b进行融合）
            
            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);

                //灰度化（加权平均法）
                fixed val = 0.299*col.r+0.578*col.g *0.114*col.b;
                //灰度化
                fixed3 grayScale = fixed3(val,val,val);
                //Radius-distance的最小值为0
                half d = saturate((_Radius-distance(_Position.xyz,i.w_p.xyz))/_Softness);
                //Radius大于distance时，才处理灰度化，头则就为图片原来的颜色
                col =lerp(col, fixed4(grayScale,1.0),d);

                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
