import 'package:dart_code/dart_code.dart';

/// OUTPUTS:
/// import 'package:my_package/person.dart' as _i1;
/// import 'package:my_package/skills.dart' as _i2;
///
/// abstract class Employee extends _i1.Person implements _i2.Skills {
///
/// }
main() {
  print(Class(
    'Employee',
    superClass: Type('Person', libraryUrl: 'package:my_package/person.dart'),
    implements: [Type('Skills', libraryUrl: 'package:my_package/skills.dart')],
    abstract: true,
  ).toString());
}