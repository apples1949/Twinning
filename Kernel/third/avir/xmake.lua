-- avir
-- 3.0 24034240a63f99bf18d39f7a1249b323dab0a48b
-- https://github.com/avaneev/avir

target('third.avir', function()
	set_group('source/third')
	set_kind('headeronly')
	add_headerfiles(
		'./avir.h',
		'./avir_dil.h',
		'./avir_float4_sse.h',
		'./avir_float8_avx.h',
		'./lancir.h',
		{ install = false }
	)
	add_files(
		{}
	)
	add_includedirs(
		{ public = true }
	)
	add_deps(
		{}
	)
	on_load(function(target)
		import('helper')
		helper.apply_compiler_option_basic(target)
		helper.apply_compiler_option_warning_disable(target)
	end)
end)
