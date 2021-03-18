import 'annotation.dart';
import 'basic.dart';
import 'comment.dart';
import 'formatting.dart';
import 'model.dart';
import 'parameter.dart';
import 'statement.dart';
import 'type.dart';
import 'variable_definition.dart';

///  A syntactic entity in the Dart programming language that may be evaluated to determine its value
///  e.g.: 1 or or 1.1 or 1+2 or 1*2 or 'hello' or 'hello' + ' world' or user.name
class Expression extends CodeModel {
  final List<CodeNode> nodes;

  /// =========================================================================
  ///                            CONSTRUCTORS
  /// =========================================================================

  Expression(this.nodes);

  Expression.ofInt(int value) : nodes = [Code(value.toString())];

  Expression.ofDouble(double value) : nodes = [Code(value.toString())];

  Expression.ofBool(bool value) : nodes = [Code(value.toString())];

  Expression.ofDateTime(DateTime value) : nodes = [Code(value.toString())];

  Expression.ofString(String value) : nodes = _createStringNodes(value);

  Expression.ofList(List<Expression> expressions)
      : nodes = [
          Code('['),
          SeparatedValues.forParameters(expressions),
          Code(']')
        ];

  Expression.ofSet(Set<Expression> expressions)
      : nodes = [
          Code('{'),
          SeparatedValues.forParameters(expressions),
          Code('}')
        ];

  Expression.ofMap(Map<Expression, Expression> expressions)
      : nodes = _createMapNodes(expressions);

  static List<CodeNode> _createMapNodes(
          Map<Expression, Expression> expressions) =>
      [
        Code('{'),
        SeparatedValues.forParameters(_createKeyValueExpressions(expressions)),
        Code('}')
      ];

  static List<Expression> _createKeyValueExpressions(
          Map<Expression, Expression> expressions) =>
      expressions.keys
          .map((key) => _createKeyValueExpression(key, expressions[key]))
          .toList();

  static Expression _createKeyValueExpression(
          Expression key, Expression value) =>
      Expression([
        key,
        SpaceWhenNeeded(),
        Code(':'),
        SpaceWhenNeeded(),
        value,
      ]);

  static RegExp _singleQuote = RegExp("'");
  static RegExp _doubleQuote = RegExp('"');
  static RegExp _betweenSingleQuotes = RegExp("^'.*'\$");
  static RegExp _betweenDoubleQuotes = RegExp('^".*"\$');

  static _createStringNodes(String value) {
    if (!_betweenSingleQuotes.hasMatch(value) &&
        !_betweenDoubleQuotes.hasMatch(value)) {
      int nrSingleQuotes = _singleQuote.allMatches(value).length;
      int nrDoubleQuotes = _doubleQuote.allMatches(value).length;
      if (nrSingleQuotes > 0 && nrDoubleQuotes == 0) {
        value = '"$value"';
      } else {
        value = "'$value'";
      }
    }
    return [Code(value.toString())];
  }

  Expression.ofVariable(String name)
      : nodes = [IdentifierStartingWithLowerCase(name)];

  Expression.ofThisField(String name)
      : nodes = [
          KeyWord.this$,
          Code('.'),
          IdentifierStartingWithLowerCase(name)
        ];

  Expression.ofSuperField(String name)
      : nodes = [
          KeyWord.super$,
          Code('.'),
          IdentifierStartingWithLowerCase(name)
        ];

  Expression.callFunction(String name, [ParameterValues parameterValues])
      : nodes = [
          if (name != null) IdentifierStartingWithLowerCase(name),
          Code('('),
          if (parameterValues != null) parameterValues,
          Code(')'),
        ];

  Expression.callConstructor(Type type,
      {String name, ParameterValues parameterValues})
      : nodes = [
          type,
          if (name != null) Code('.'),
          if (name != null) IdentifierStartingWithLowerCase(name),
          Code('('),
          if (parameterValues != null) parameterValues,
          Code(')'),
        ];

  Expression.ofEnum(Type type, String value)
      : nodes = [
          type,
          Code('.'),
          IdentifierStartingWithLowerCase(value),
        ];

  Expression.betweenParentheses(Expression expression)
      : nodes = [Code('('), expression, Code(')')];

  /// =========================================================================
  ///                        OPERATORS AS FLUENT METHODS
  /// =========================================================================

  /// Returns the result of `this` `&&` [other].
  Expression and(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('&&'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `||` [other].
  Expression or(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('||'), SpaceWhenNeeded(), other]);

  /// Returns the result of `!this`.
  Expression negate() => Expression([Code('!'), this]);

  /// Returns the result of `this` `as` [other].
  Expression asA(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('as'), SpaceWhenNeeded(), other]);

  /// Returns accessing the index operator (`[]`) on `this`.
  Expression index(Expression index) =>
      Expression([this, Code('['), index, Code(']')]);

  /// Returns the result of `this` `is` [other].
  Expression isA(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('is'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `is!` [other].
  Expression isNotA(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('is!'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `==` [other].
  Expression equalTo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('=='), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `!=` [other].
  Expression notEqualTo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('!='), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `>` [other].
  Expression greaterThan(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('>'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `<` [other].
  Expression lessThan(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('<'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `>=` [other].
  Expression greaterOrEqualTo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('>='), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `<=` [other].
  Expression lessOrEqualTo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('<='), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `+` [other].
  Expression add(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('+'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `-` [other].
  Expression subtract(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('-'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `/` [other].
  Expression divide(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('/'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `*` [other].
  Expression multiply(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('*'), SpaceWhenNeeded(), other]);

  /// Returns the result of `this` `%` [other].
  Expression modulo(Expression other) => Expression(
      [this, SpaceWhenNeeded(), Code('%'), SpaceWhenNeeded(), other]);

  /// Returns the result of this++ or ++this.
  Expression increment({after = true}) =>
      after ? Expression([this, Code('++')]) : Expression([Code('++'), this]);

  /// Returns the result of this-- or --this.
  Expression decrement({after = true}) =>
      after ? Expression([this, Code('--')]) : Expression([Code('--'), this]);

  Expression conditional(Expression whenTrue, Expression whenFalse) =>
      Expression([
        this,
        SpaceWhenNeeded(),
        Code('?'),
        SpaceWhenNeeded(),
        whenTrue,
        SpaceWhenNeeded(),
        Code(':'),
        SpaceWhenNeeded(),
        whenFalse
      ]);

  /// This expression preceded by `await`.
  Expression awaited() => Expression([Code('await'), SpaceWhenNeeded(), this]);

  /// Return `{other} ?? {this}`.
  Expression ifNullThen(Expression other) => Expression(
      [other, SpaceWhenNeeded(), Code('??'), SpaceWhenNeeded(), this]);

  ///===========================================================================
  ///                     OTHER FLUENT METHODS
  ///===========================================================================

  Expression callMethod(String name,
          {ParameterValues parameterValues, bool cascade = false}) =>
      Expression([
        this,
        if (!cascade) Code('.'),
        if (cascade) NewLine(),
        if (cascade) Code('..'),
        IdentifierStartingWithLowerCase(name),
        Code('('),
        if (parameterValues != null) parameterValues,
        Code(')'),
      ]);

  Expression getProperty(String name, {bool cascade = false}) => Expression([
        this,
        if (!cascade) Code('.'),
        if (cascade) NewLine(),
        if (cascade) Code('..'),
        IdentifierStartingWithLowerCase(name),
      ]);

  Expression setProperty(String name, Expression value,
          {bool cascade = false}) =>
      Expression([
        this,
        if (!cascade) Code('.'),
        if (cascade) NewLine(),
        if (cascade) Code('..'),
        IdentifierStartingWithLowerCase(name),
        SpaceWhenNeeded(),
        Code('='),
        SpaceWhenNeeded(),
        value,
      ]);

  Statement assignVariable(String name, {Type type, nullAware = false}) =>
      Statement.assignVariable(name, this, nullAware: nullAware);

  Statement defineVariable(String name,
          {List<DocComment> docComments = const [],
          List<Annotation> annotations = const [],
          bool static = false,
          Type type,
          Expression value}) =>
      VariableDefinition.var$(
        name,
        docComments: docComments,
        annotations: annotations,
        static: static,
        type: type,
        value: this,
      );

  Statement defineFinal(String name,
          {List<DocComment> docComments = const [],
          List<Annotation> annotations = const [],
          bool static = false,
          Type type,
          Expression value}) =>
      VariableDefinition.final$(
        name,
        value: this,
        docComments: docComments,
        annotations: annotations,
        static: static,
        type: type,
      );

  Statement defineConst(String name,
          {List<DocComment> docComments = const [],
          List<Annotation> annotations = const [],
          bool static = false,
          Type type,
          Expression value}) =>
      VariableDefinition.const$(
        name,
        this,
        docComments: docComments,
        annotations: annotations,
        static: static,
        type: type,
      );

  ///===========================================================================
  ///                             codeNodes
  ///===========================================================================

  @override
  List<CodeNode> codeNodes(Context context) => nodes;
}