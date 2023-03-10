set_project('WindowsExplorerExtension')

add_rules('mode.debug', 'mode.release')

add_moduledirs('../common/xmake')
includes('../common/xmake/custom.lua')
apply_common_setting()

includes('./implement')

add_requires('vcpkg::wil')
