function normal(shader, t_base, t_second, t_detail)
  shader:begin("effects_sun","stub_default_linear")
--        : sorting        (2, false)
--        : blend                (true,blend.srcalpha,blend.invsrcalpha)
--        : blend                (true,blend.one,blend.one)
        : blend                (true,blend.srcalpha,blend.one)
		: zb                (false,false)
--  shader:sampler        ("s_base")       :texture  (t_base)
	shader:dx10texture	("s_base", t_base)
	shader:dx10sampler	("smp_base")
end