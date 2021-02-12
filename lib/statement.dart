import 'package:dart_code/annotation.dart';
import 'package:dart_code/basic.dart';
import 'package:dart_code/comment.dart';
import 'package:dart_code/model.dart';

import 'expression.dart';

class Statement extends CodeModel {
  final List<CodeNode> nodes;

  Statement(this.nodes);

  Statement.assignVariable(String name, Expression value,
      {bool nullAware = false})
      : this([
          IdentifierStartingWithLowerCase(name),
          SpaceWhenNeeded(),
          nullAware == true ? Code('??=') : Code('='),
          SpaceWhenNeeded(),
          value,
        ]);

  Statement.return$(Expression expression)
      : this([KeyWord.return$, SpaceWhenNeeded(), expression]);

  @override
  List<CodeNode> codeNodes(Context context) => [
        for (CodeNode codeNode in nodes) codeNode,
        if (nodes.isNotEmpty) EndOfStatement(),
      ];
}

class VariableDefinition extends Statement {
  final List<DocComment> docComments;
  final List<Annotation> annotations;

  /// If a static prefix is needed (only required for class fields)
  final bool static;
  final Modifier modifier;
  final Type type;
  final IdentifierStartingWithLowerCase name;
  final Expression value;

  VariableDefinition._(this.modifier, this.name,
      {this.docComments = const [],
      this.annotations = const [],
      this.static = false,
      this.type,
      this.value})
      : super([
          for (DocComment docComment in docComments) docComment,
          for (Annotation annotation in annotations) annotation,
          if (static == true) KeyWord.static$,
          SpaceWhenNeeded(),
          if (modifier == Modifier.var$ && type == null) KeyWord.var$,
          if (modifier == Modifier.final$) KeyWord.final$,
          if (modifier == Modifier.const$) KeyWord.const$,
          SpaceWhenNeeded(),
          if (type != null) type,
          SpaceWhenNeeded(),
          name,
          if (value != null) SpaceWhenNeeded(),
          if (value != null) Code('='),
          if (value != null) SpaceWhenNeeded(),
          if (value != null) value,
        ]);

  VariableDefinition.var$(String name,
      {List<DocComment> docComments = const [],
      List<Annotation> annotations = const [],
      bool static = false,
      Type type,
      Expression value})
      : this._(Modifier.var$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);

  VariableDefinition.final$(
    String name,
    Expression value, {
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : this._(Modifier.final$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);

  VariableDefinition.const$(
    String name,
    Expression value, {
    List<DocComment> docComments = const [],
    List<Annotation> annotations = const [],
    bool static = false,
    Type type,
  }) : this._(Modifier.const$, IdentifierStartingWithLowerCase(name),
            docComments: docComments,
            annotations: annotations,
            static: static,
            type: type,
            value: value);
}

enum Modifier { var$, final$, const$ }

class Statements extends CodeModel {
  final List<Statement> statements;

  Statements(this.statements);

  @override
  List<CodeNode> codeNodes(Context context) => statements;
}

/// ;
class EndOfStatement extends CodeModel {
  @override
  List<CodeNode> codeNodes(Context context) => [
        NoneRepeatingCode(';'),
        NoneRepeatingCode(context.newLine),
      ];
}
