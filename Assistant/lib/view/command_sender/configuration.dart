import '/common.dart';
import '/utility/wrapper.dart';
import '/utility/convert_helper.dart';
import '/view/command_sender/value_expression.dart';

// ----------------

class PresetConfiguration {
  String              name;
  Map<String, Object> argument;
  PresetConfiguration({
    required this.name,
    required this.argument,
  });
}

enum ArgumentType {
  boolean,
  integer,
  floater,
  size,
  string,
  path,
}

class ArgumentConfiguration {
  String        id;
  String        name;
  ArgumentType  type;
  List<Object>? option;
  ArgumentConfiguration({
    required this.id,
    required this.name,
    required this.type,
    required this.option,
  });
}

class MethodConfiguration {
  String                      id;
  String                      name;
  String                      icon;
  List<ArgumentConfiguration> argument;
  List<String>?               batchable;
  List<PresetConfiguration?>  preset;
  MethodConfiguration({
    required this.id,
    required this.name,
    required this.icon,
    required this.argument,
    required this.batchable,
    required this.preset,
  });
}

class MethodGroupConfiguration {
  String                    id;
  String                    name;
  String                    icon;
  List<MethodConfiguration> item;
  MethodGroupConfiguration({
    required this.id,
    required this.name,
    required this.icon,
    required this.item,
  });
}

// ----------------

class ConfigurationHelper {

  // #region utility

  static Object makeArgumentValueJson(
    ValueExpression value,
  ) {
    return switch (value) {
      BooleanExpression _ => value.value,
      IntegerExpression _ => value.value,
      FloaterExpression _ => value.value,
      SizeExpression    _ => '${ConvertHelper.makeFloaterToString(value.count, false)}${['b', 'k', 'm', 'g'][value.exponent]}',
      StringExpression  _ => value.value,
      PathExpression    _ => '${value.content}',
      _                   => throw Exception(),
    };
  }

  static ValueExpression parseArgumentValueJson(
    ArgumentType type,
    Object       json,
  ) {
    return switch (type) {
      ArgumentType.boolean => BooleanExpression(
        json.asType<Boolean>(),
      ),
      ArgumentType.integer => IntegerExpression(
        json.asType<Integer>(),
      ),
      ArgumentType.floater => FloaterExpression(
        json.asType<Floater>(),
      ),
      ArgumentType.size    => SizeExpression(
        Floater.parse(json.asType<String>().substring(0, json.asType<String>().length - 1)),
        ['b', 'k', 'm', 'g'].indexOf(json.asType<String>()[json.asType<String>().length - 1]).applySelf((it) { assertTest(it != -1); }),
      ),
      ArgumentType.string  => StringExpression(
        json.asType<String>(),
      ),
      ArgumentType.path    => PathExpression(
        json.asType<String>(),
      ),
    };
  }

  // ----------------

  static Map<String, Object> makeArgumentValueListJson(
    List<ArgumentConfiguration>     configuration,
    List<Wrapper<ValueExpression?>> value,
  ) {
    assertTest(configuration.length == value.length);
    var json = <String, Object>{};
    for (var index = 0; index < configuration.length; index++) {
      var itemConfiguration = configuration[index];
      var itemValue = value[index];
      if (itemValue.value != null) {
        json[itemConfiguration.id] = makeArgumentValueJson(itemValue.value!);
      }
    }
    return json;
  }

  static List<Wrapper<ValueExpression?>> parseArgumentValueListJson(
    List<ArgumentConfiguration> configuration,
    Map<String, Object>         json,
  ) {
    var value = List<Wrapper<ValueExpression?>>.empty(growable: true);
    for (var index = 0; index < configuration.length; index++) {
      var itemConfiguration = configuration[index];
      var itemJson = json[itemConfiguration.id];
      value.add(Wrapper(itemJson == null ? null : ConfigurationHelper.parseArgumentValueJson(itemConfiguration.type, itemJson)));
    }
    return value;
  }

  // #endregion

  // #region convert

  static List<MethodGroupConfiguration> parseDataFromJson(
    dynamic json,
  ) {
    var data = (json as List).map((jsonGroup) => MethodGroupConfiguration(
      id: (jsonGroup['id'] as String),
      name: (jsonGroup['name'] as String),
      icon: (jsonGroup['icon'] as String),
      item: (jsonGroup['item'] as List).map((jsonItem) => MethodConfiguration(
        id: (jsonItem['id'] as String),
        name: (jsonItem['name'] as String),
        icon: (jsonItem['icon'] as String),
        argument: (jsonItem['argument'] as List).map((jsonArgument) => ArgumentConfiguration(
          id: (jsonArgument['id'] as String),
          name: (jsonArgument['name'] as String),
          type: ArgumentType.values.byName(jsonArgument['type'] as String),
          option: (jsonArgument['option'] as List?)?.cast<Object>(),
        )).toList(),
        batchable: (jsonItem['batchable'] as List?)?.cast<String>(),
        preset: (jsonItem['preset'] as List).map((jsonPreset) => jsonPreset == null ? null : PresetConfiguration(
          name: (jsonPreset['name'] as String),
          argument: (jsonPreset['argument'] as Map).cast<String, Object>(),
        )).toList(),
      )).toList(),
    )).toList();
    return data;
  }

  // #endregion

}
