import 'code_formatter.dart';
import 'type.dart';

class Context {
  Imports imports;
  String lastCode = '';

  Context(CodeNode codeNode) {
    imports = Imports(codeNode, this);
  }
}

///a tree model that represents DartCode
abstract class CodeNode {
  @override
  String toString() {
    return CodeFormatter().format(this);
  }

  String toUnFormattedString(Context context);
}

/// A (tree) model that represents Dart Code.
/// It contains a list of [CodeNode]s that is generated by using the constructor parameters, fields and or properties of the implementation of [CodeModel]
/// [CodeNode]s can be:
/// - [CodeLeaf]s that can be converted to a string
/// - Other [CodeModel]s that represent part of the code (e.g. a Library, Class, Annotation, Function, Method, Block, Statement, etc)
abstract class CodeModel extends CodeNode {
  List<CodeNode> codeNodes(Context context);

  /// Recursive call to get the unformatted code from all nodes
  @override
  String toUnFormattedString(Context context) {
    StringBuffer buffer = StringBuffer();
    for (CodeNode codeNode in codeNodes(context)) {
      String unformattedCode = codeNode.toUnFormattedString(context);
      if (codeNode is! CodeModel) {
        context.lastCode = unformattedCode;
      }
      buffer.write(unformattedCode);
    }
    return buffer.toString();
  }
}

/// a String representing a piece of Dart code
class Code extends CodeNode {
  final String code;

  Code(this.code);

  @override
  String toUnFormattedString(Context context) {
    return code;
  }
}
