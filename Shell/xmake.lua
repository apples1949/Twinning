set_project('Shell')

add_rules('mode.debug', 'mode.release')

add_moduledirs('./../common/xmake')
includes('./../common/xmake/helper.lua')
apply_common_setting()

includes('./shell')
