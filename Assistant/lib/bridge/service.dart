import '/common.dart'; // ignore: unused_import
import '/bridge/data.dart';
import 'dart:ffi' as ffi;

// ----------------

final class Service extends ffi.Struct {
  external ffi.Pointer<Executor> executor;
}
