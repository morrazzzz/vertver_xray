#include "common.h"

uniform float4 		consts; // {1/quant,1/quant,diffusescale,ambient}
uniform float4 		array[61*4];
uniform float4x4	wv;

v2p_flat 	main (v_detail v)
{
	v2p_flat 		O;
	// index
	int 	i 	= v.misc.w;
	float4  m0 	= array[i+0];
	float4  m1 	= array[i+1];
	float4  m2 	= array[i+2];
	float4  c0 	= array[i+3];

	// Transform pos to world coords
	float4 	pos;
 	pos.x 		= dot	(m0, v.pos);
 	pos.y 		= dot	(m1, v.pos);
 	pos.z 		= dot	(m2, v.pos);
	pos.w 		= 1;

	// Normal in world coords
	float3 	norm;	
		norm.x 	= pos.x - m0.w	;
		norm.y 	= pos.y - m1.w	+ .75f;	// avoid zero
		norm.z	= pos.z - m2.w	;

	// Final out
	O.hpos 		= mul		(m_VP,	pos				);	
	O.cur_hpos	= mul		(m_VP_Unjittered,	float4(pos.x, pos.y, pos.z, 1.0f)				);	
	O.prev_hpos	= mul 		(m_prevVP_Unjittered, float4(pos.x, pos.y, pos.z, 1.0f) 		);
	O.N 		= mul		(wv,  normalize(norm)	);
	float3	Pe	= mul		(wv,  pos				);
	O.tcdh 		= float4	((v.misc * consts).xyyy	);

# if defined(USE_R2_STATIC_SUN)
	O.tcdh.w	= c0.x;								// (,,,dir-occlusion)
# endif

	O.position	= float4	(Pe, 		c0.w		);

	return O;
}
FXVS;
