import '/common.dart';

// ----------------

class TranslateTransform {
  Floater x;
  Floater y;
  TranslateTransform({
    required this.x,
    required this.y,
  });
}

class RotateTranslateTransform {
  Floater angle;
  Floater x;
  Floater y;
  RotateTranslateTransform({
    required this.angle,
    required this.x,
    required this.y,
  });
}

class MatrixTranslateTransform {
  Floater a;
  Floater b;
  Floater c;
  Floater d;
  Floater x;
  Floater y;
  MatrixTranslateTransform({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.x,
    required this.y,
  });
}

class VariantTransform {
  Object value;
  VariantTransform({
    required this.value,
  });
}

class Color {
  Floater red;
  Floater green;
  Floater blue;
  Floater alpha;
  Color({
    required this.red,
    required this.green,
    required this.blue,
    required this.alpha,
  });
}

class Rectangle {
  (Floater, Floater) position;
  (Floater, Floater) size;
  Rectangle({
    required this.position,
    required this.size,
  });
}

class Command {
  String command;
  String argument;
  Command({
    required this.command,
    required this.argument,
  });
}

class LayerRemove {
  Integer index;
  LayerRemove({
    required this.index,
  });
}

class LayerAppend {
  Integer index;
  String? name;
  Integer resource;
  Boolean sprite;
  Boolean additive;
  Integer preloadFrame;
  Floater timeScale;
  LayerAppend({
    required this.index,
    required this.name,
    required this.resource,
    required this.sprite,
    required this.additive,
    required this.preloadFrame,
    required this.timeScale,
  });
}

class LayerChange {
  Integer          index;
  VariantTransform transform;
  Color?           color;
  Integer?         spriteFrameNumber;
  Rectangle?       sourceRectangle;
  LayerChange({
    required this.index,
    required this.transform,
    required this.color,
    required this.spriteFrameNumber,
    required this.sourceRectangle,
  });
}

class Frame {
  String?           label;
  Boolean           stop;
  List<Command>     command;
  List<LayerRemove> remove;
  List<LayerAppend> append;
  List<LayerChange> change;
  Frame({
    required this.label,
    required this.stop,
    required this.command,
    required this.remove,
    required this.append,
    required this.change,
  });
}

class Sprite {
  String?             name;
  Floater?            frameRate;
  (Integer, Integer)? workArea;
  List<Frame>         frame;
  Sprite({
    required this.name,
    required this.frameRate,
    required this.workArea,
    required this.frame,
  });
}

class Image {
  String              name;
  (Integer, Integer)? size;
  VariantTransform    transform;
  Image({
    required this.name,
    required this.size,
    required this.transform,
  });
}

class Animation {
  Integer            frameRate;
  (Floater, Floater) position;
  (Floater, Floater) size;
  List<Image>        image;
  List<Sprite>       sprite;
  Sprite?            mainSprite;
  Animation({
    required this.frameRate,
    required this.position,
    required this.size,
    required this.image,
    required this.sprite,
    required this.mainSprite,
  });
}

// ----------------

class ModelHelper {

  // #region utility

  static VariantTransform parseVariantTransformFromList(
    List<Floater> list,
  ) {
    return VariantTransform(value: switch (list.length) {
      2 => TranslateTransform(x: list[0], y: list[1]),
      3 => RotateTranslateTransform(angle: list[0], x: list[1], y: list[2]),
      6 => MatrixTranslateTransform(a: list[0], b: list[1], c: list[2], d: list[3], x: list[4], y: list[5]),
      _ => throw Exception(),
    });
  }

  // #endregion

  // #region convert

  static Animation parseDataFromJson(
    dynamic json,
  ) {
    return Animation(
      frameRate: (json['frame_rate'] as Integer),
      position: (json['position'] as List<dynamic>).cast<Floater>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
      size: (json['size'] as List<dynamic>).cast<Floater>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
      image: (json['image'] as List<dynamic>).map((jsonItem) => Image(
        name: (jsonItem['name'] as String),
        size: (jsonItem['size'] as List<dynamic>).cast<Integer>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
        transform: (jsonItem['transform'] as List<dynamic>).cast<Floater>().selfLet(parseVariantTransformFromList),
      )).toList(),
      sprite: (json['sprite'] as List<dynamic>).map((jsonItem) => Sprite(
        name: (jsonItem['name'] as String?),
        frameRate: (jsonItem['frame_rate'] as Floater?),
        workArea: (jsonItem['size'] as List<dynamic>?)?.cast<Integer>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
        frame: (jsonItem['frame'] as List<dynamic>).map((jsonElement) => Frame(
          label: (jsonElement['label'] as String?),
          stop: (jsonElement['stop'] as Boolean),
          command: (jsonElement['command'] as List<dynamic>).map((jsonPart) => Command(
            command: (jsonPart[0] as String),
            argument: (jsonPart[1] as String),
          )).toList(),
          remove: (jsonElement['remove'] as List<dynamic>).map((jsonPart) => LayerRemove(
            index: (jsonPart['index'] as Integer),
          )).toList(),
          append: (jsonElement['append'] as List<dynamic>).map((jsonPart) => LayerAppend(
            index: (jsonPart['index'] as Integer),
            name: (jsonPart['name'] as String?),
            resource: (jsonPart['resource'] as Integer),
            sprite: (jsonPart['sprite'] as Boolean),
            additive: (jsonPart['additive'] as Boolean),
            preloadFrame: (jsonPart['preload_frame'] as Integer),
            timeScale: (jsonPart['time_scale'] as Floater),
          )).toList(),
          change: (jsonElement['change'] as List<dynamic>).map((jsonPart) => LayerChange(
            index: (jsonPart['index'] as Integer),
            transform: (jsonPart['transform'] as List<dynamic>).cast<Floater>().selfLet(parseVariantTransformFromList),
            color: (jsonPart['color'] as List<dynamic>?)?.cast<Floater>().selfAlso((it) { assertTest(it.length == 4); }).selfLet((it) => Color(red: it[0], green: it[1], blue: it[2], alpha: it[3])),
            spriteFrameNumber: (jsonPart['sprite_frame_number'] as Integer?),
            sourceRectangle: (jsonPart['source_rectangle'] as Map<dynamic, dynamic>?)?.selfLet((jsonChild) => Rectangle(
              position: (jsonChild['position'] as List<dynamic>).cast<Floater>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
              size: (jsonChild['size'] as List<dynamic>).cast<Floater>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
            )),
          )).toList(),
        )).toList(),
      )).toList(),
      mainSprite: (json['main_sprite'] as Map<dynamic, dynamic>?)?.selfLet((jsonItem) => Sprite(
        name: (jsonItem['name'] as String?),
        frameRate: (jsonItem['frame_rate'] as Floater?),
        workArea: (jsonItem['size'] as List<dynamic>?)?.cast<Integer>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
        frame: (jsonItem['frame'] as List<dynamic>).map((jsonElement) => Frame(
          label: (jsonElement['label'] as String?),
          stop: (jsonElement['stop'] as Boolean),
          command: (jsonElement['command'] as List<dynamic>).map((jsonPart) => Command(
            command: (jsonPart[0] as String),
            argument: (jsonPart[1] as String),
          )).toList(),
          remove: (jsonElement['remove'] as List<dynamic>).map((jsonPart) => LayerRemove(
            index: (jsonPart['index'] as Integer),
          )).toList(),
          append: (jsonElement['append'] as List<dynamic>).map((jsonPart) => LayerAppend(
            index: (jsonPart['index'] as Integer),
            name: (jsonPart['name'] as String?),
            resource: (jsonPart['resource'] as Integer),
            sprite: (jsonPart['sprite'] as Boolean),
            additive: (jsonPart['additive'] as Boolean),
            preloadFrame: (jsonPart['preload_frame'] as Integer),
            timeScale: (jsonPart['time_scale'] as Floater),
          )).toList(),
          change: (jsonElement['change'] as List<dynamic>).map((jsonPart) => LayerChange(
            index: (jsonPart['index'] as Integer),
            transform: (jsonPart['transform'] as List<dynamic>).cast<Floater>().selfLet(parseVariantTransformFromList),
            color: (jsonPart['color'] as List<dynamic>?)?.cast<Floater>().selfAlso((it) { assertTest(it.length == 4); }).selfLet((it) => Color(red: it[0], green: it[1], blue: it[2], alpha: it[3])),
            spriteFrameNumber: (jsonPart['sprite_frame_number'] as Integer?),
            sourceRectangle: (jsonPart['source_rectangle'] as Map<dynamic, dynamic>?)?.selfLet((jsonChild) => Rectangle(
              position: (jsonChild['position'] as List<dynamic>).cast<Floater>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
              size: (jsonChild['size'] as List<dynamic>).cast<Floater>().selfAlso((it) { assertTest(it.length == 2); }).selfLet((it) => (it[0], it[1])),
            )),
          )).toList(),
        )).toList(),
      )),
    );
  }

  // #endregion

}
