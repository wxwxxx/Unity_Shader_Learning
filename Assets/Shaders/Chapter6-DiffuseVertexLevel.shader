﻿// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Chapter6/DiffuseVertexLevel"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1,1,1,1)
    }
    SubShader
    {
       Pass {
            // 指定 光照模式
            Tags {"LightMode" = "ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // 使用 unity 的内置变量
            #include "Lighting.cginc"

            fixed4 _Diffuse;

            struct a2v{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f{
                float4 pos : SV_POSITION;
                fixed3 color : COLOR;
            };

            v2f vert(a2v v){
                // 定义返回值
                v2f o;
                // 顶点位置 从 模型空间 转换到 剪裁空间
                o.pos = UnityObjectToClipPos(v.vertex);

                // ------计算漫反射光照部分------
                // 本节假设场景中只有一个类型的光源 -》 平行光

                // 计算环境光 内置变量UNITY_LIGHTMODEL_AMBIENT得到环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                // 转换 法线 从对象空间到世界空间
                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                // 得到 光线 在世界空间的方向
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                // 计算 漫反射
                // _LightColor0 光源的颜色和强度信息
                // dot() 是点集
                // saturate() 函数的作用是把参数截取到[0,1]的范围内
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));

                o.color = ambient + diffuse;

                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
                return fixed4(i.color , 1.0);
            }

            ENDCG
       }
    }
    FallBack "Diffuse"
}
