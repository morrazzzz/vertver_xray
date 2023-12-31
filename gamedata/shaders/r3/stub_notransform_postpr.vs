#include "common_iostructs.h"

uniform float4		target_screen_res;		// Screen resolution (x-Width,y-Height, zw - 1/resolution)

//////////////////////////////////////////////////////////////////////////////////////////
// Vertex
v2p_postpr main ( v_postpr I )
{
	v2p_postpr	O;

//	O.HPos	= I.P;

	{
//		I.P.xy += 0.5f;
//		O.HPos.x = I.P.x/1024 * 2 - 1;
//		O.HPos.y = (I.P.y/768 * 2 - 1)*-1;
		O.HPos.x = I.P.x * target_screen_res.z * 2 - 1;
		O.HPos.y = (I.P.y * target_screen_res.w * 2 - 1)*-1;
		O.HPos.zw = I.P.zw;
	}


	O.Tex0	= I.Tex0;
	O.Tex1	= I.Tex1;
	O.Tex2	= I.Tex2;
	
	O.Color = I.Color.bgra;	//	swizzle vertex colour
	O.Gray	= I.Gray.bgra;	//	swizzle vertex colour

 	return O;
}