#pragma once

#include "kernel/utility/trait/base.hpp"
#include "kernel/utility/trait/category.hpp"
#include "kernel/utility/trait/reflection/string.hpp"

namespace TwinStar::Kernel::Trait::Reflection {

	#pragma region base

	template <auto t_name, auto t_value> requires
		CategoryConstraint<>
		&& (IsTemplateInstanceOfV<decltype(t_name), String>)
	struct Field {

		inline static constexpr auto name = t_name;

		inline static constexpr auto value = t_value;

	};

	#pragma endregion

	#pragma region class

	template <auto t_name, auto t_value, auto t_is_static, auto t_is_function> requires
		CategoryConstraint<>
		&& (IsTemplateInstanceOfV<decltype(t_name), String>)
		&& (IsSameV<t_is_static, ZBoolean>)
		&& (IsSameV<t_is_function, ZBoolean>)
	// TODO : && ((t_is_static && IsBuiltinPointer<decltype(t_value)>) || (!t_is_static && IsBuiltinMemberPointer<decltype(t_value)>))
	// TODO : check t_is_function & t_value
	struct ClassField :
		Field<t_name, t_value> {

		inline static constexpr auto is_static = ZBoolean{t_is_static};

		inline static constexpr auto is_function = ZBoolean{t_is_function};

		// ----------------

		static constexpr auto value_of (
		) -> auto && requires
			(is_static) {
			return *(Field<t_name, t_value>::value);
		}

		template <typename Class> requires
			AutoConstraint // TODO : check type
		static constexpr auto value_of (
			Class && thix
		) -> auto && requires
			(!is_static) {
			return as_forward<Class>(thix).*(Field<t_name, t_value>::value);
		}

	};

	// ----------------

	template <auto t_name, auto t_value> requires
		AutoConstraint
	using MemberVariableField = ClassField<t_name, t_value, false, false>;

	template <auto t_name, auto t_value> requires
		AutoConstraint
	using MemberFunctionField = ClassField<t_name, t_value, false, true>;

	template <auto t_name, auto t_value> requires
		AutoConstraint
	using StaticVariableField = ClassField<t_name, t_value, true, false>;

	template <auto t_name, auto t_value> requires
		AutoConstraint
	using StaticFunctionField = ClassField<t_name, t_value, true, true>;

	#pragma endregion

	#pragma region enumeration

	template <auto t_name, auto t_value> requires
		CategoryConstraint<>
		&& (IsTemplateInstanceOfV<decltype(t_name), String>)
	struct EnumerationField :
		Field<t_name, t_value> {

	};

	// ----------------

	template <auto t_name, auto t_value> requires
		AutoConstraint
	using EnumerationValueField = EnumerationField<t_name, t_value>;

	#pragma endregion

}
