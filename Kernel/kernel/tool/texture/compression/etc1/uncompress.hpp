#pragma once

#include "kernel/utility/utility.hpp"
#include "kernel/tool/texture/compression/etc1/common.hpp"
#include "kernel/third/ETCPACK.hpp"

namespace Twinning::Kernel::Tool::Texture::Compression::ETC1 {

	struct Uncompress :
		Common {

		using Common = Common;

		// ----------------

		static auto process_image_rgb (
			IByteStreamView &         data,
			Image::VImageView const & image
		) -> Void {
			assert_test(is_padded_size(image.size().width, k_block_width));
			assert_test(is_padded_size(image.size().height, k_block_width));
			auto image_block = Array<Image::Pixel>{k_block_width * k_block_width};
			for (auto & block_y : SizeRange{image.size().height / k_block_width}) {
				for (auto & block_x : SizeRange{image.size().width / k_block_width}) {
					auto block_part_1 = reverse_endian(data.read_of<IntegerU32>());
					auto block_part_2 = reverse_endian(data.read_of<IntegerU32>());
					Third::ETCPACK::decompressBlockETC2c(
						block_part_1.value,
						block_part_2.value,
						cast_pointer<Third::ETCPACK::uint8>(image_block.begin()).value,
						static_cast<int>(k_block_width.value),
						static_cast<int>(k_block_width.value),
						static_cast<int>(k_begin_index.value),
						static_cast<int>(k_begin_index.value),
						4
					);
					for (auto & pixel_y : SizeRange{k_block_width}) {
						for (auto & pixel_x : SizeRange{k_block_width}) {
							auto & pixel = image[block_y * k_block_width + pixel_y][block_x * k_block_width + pixel_x];
							auto & block_pixel = image_block[pixel_y * k_block_width + pixel_x];
							pixel.red = block_pixel.red;
							pixel.green = block_pixel.green;
							pixel.blue = block_pixel.blue;
						}
					}
				}
			}
			return;
		}

		// ----------------

		static auto process_image (
			IByteStreamView &         data,
			Image::VImageView const & image
		) -> Void {
			process_image_rgb(data, image);
			return;
		}

		// ----------------

		static auto process (
			IByteStreamView &         data_,
			Image::VImageView const & image
		) -> Void {
			M_use_zps_of(data);
			return process_image(data, image);
		}

	};

}
