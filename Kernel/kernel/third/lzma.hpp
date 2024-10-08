#pragma once

#if defined M_compiler_msvc
#pragma warning(push, 0)
#endif
#if defined M_compiler_clang
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Weverything"
#endif

#include "third/lzma/LzmaLib.h"

#if defined M_compiler_msvc
#pragma warning(pop)
#endif
#if defined M_compiler_clang
#pragma clang diagnostic pop
#endif

namespace Twinning::Kernel::Third::lzma {

	using Byte = ::Byte;

	inline constexpr auto SZ_OK_ = SZ_OK;

	inline constexpr auto LzmaCompress = ::LzmaCompress;

	inline constexpr auto LzmaUncompress = ::LzmaUncompress;

	inline constexpr auto LZMA_PROPS_SIZE_ = LZMA_PROPS_SIZE;

}
