#include "common.h"

#if defined(USE_R2_STATIC_SUN) && !defined(USE_LM_HEMI)
#define	v_in	v_static_color
#else
#define	v_in	v_static
#endif


v2p_flat main ( v_in I )
{
	I.Nh			= unpack_D3DCOLOR(I.Nh);
	I.T				= unpack_D3DCOLOR(I.T);
	I.B				= unpack_D3DCOLOR(I.B);

	// Eye-space pos/normal
	v2p_flat 		O;
	float4 pos 	= I.P;
	O.hpos 		= mul( m_VP, pos );
	O.cur_hpos	= mul( m_VP_Unjittered, float4(pos.x, pos.y, pos.z, 1.0f) );
	O.prev_hpos	= mul( m_prevVP_Unjittered, float4(pos.x, pos.y, pos.z, 1.0f) );
	O.N 		= mul( (float3x3)m_WV, unpack_bx2(I.Nh) );
	float3	Pe	= mul( m_WV, I.P );

	float2	tc 	= unpack_tc_base( I.tc, I.T.w, I.B.w);	// copy tc
	O.tcdh		= float4( tc.xyyy );
	O.position	= float4( Pe, I.Nh.w );

#if defined(USE_R2_STATIC_SUN) && !defined(USE_LM_HEMI)
	float 	s	= I.color.w	;							// (r,g,b,dir-occlusion)
	O.tcdh.w	= s;
#endif

#ifdef	USE_TDETAIL
	O.tcdbump	= O.tcdh * dt_params;					// dt tc
#endif

#ifdef	USE_LM_HEMI
	O.lmh 		= unpack_tc_lmap( I.lmh );
#endif

	return	O;
}
FXVS;
