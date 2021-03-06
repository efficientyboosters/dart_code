import 'package:dart_code/dart_code.dart';
import 'package:dart_code/src/import.dart';
import 'package:test/test.dart';

main() {
  group('Import class', () {
    test('Given Import => Returns correct code string', () {
      String actual =
          CodeFormatter().unFormatted(Import("package:test/test.dart", "_i1"));
      String expected = 'import \'package:test/test.dart\' as _i1;';
      expect(actual, expected);
    });
  });

  group('Imports class', () {
    test('Given types => Returns correct import string', () {
      Statements statements = Statements([
        Statement(
            [Type("MyFirstClass", libraryUri: "package:test/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUri: "package:test/test2.dart")]),
      ]);
      Context context = Context(statements);
      String actual = CodeFormatter().unFormatted(context.imports);
      String expected =
          'import \'package:test/test1.dart\' as _i1;import \'package:test/test2.dart\' as _i2;';
      expect(actual, expected);
    });

    test('Given types => Returns correct type code strings', () {
      String actual = CodeFormatter().unFormatted(Statements([
        Statement(
            [Type("MyFirstClass", libraryUri: "package:test/test1.dart")]),
        Statement(
            [Type("MySecondClass", libraryUri: "package:test/test2.dart")]),
      ]));
      String expected = '_i1.MyFirstClass;_i2.MySecondClass;';
      expect(actual, expected);
    });
  });
}
