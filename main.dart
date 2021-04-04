import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:pub_semver/pub_semver.dart';


Future<ParseStringResult> load() async {
  var src = await new File('./source/coupons_all_state.dart').readAsString();
  var ast = parseString(
    content: src,
    featureSet: FeatureSet.fromEnableFlags2(sdkLanguageVersion: Version.parse('2.10.4'), flags: []),
  );
  return ast;
}

main() async {
  var ast = await load();
  printMembers(ast.unit);
}

void printMembers(CompilationUnit unit) {
  var res = [];

  for (CompilationUnitMember unitMember in unit.declarations) {
    if (unitMember is ClassDeclaration) {
      res.add("Class ${unitMember.name.name}");
      for (ClassMember classMember in unitMember.members) {
        if (classMember is MethodDeclaration) {
          // classMember.parameters.toSource();

          // var typeArguments = ((classMember.parameters?.parameters[0].identifier.parent as SimpleFormalParameter).type as NamedType).typeArguments;
          res.add('  Method ${classMember.name} ${classMember.parameters?.parameters?.map((e) => "${e.identifier.parent} ${e.identifier}") ?? ''}: ${classMember.returnType}');
          // res.add('  Method ${classMember.name} ${classMember.parameters?.parameters?.map((e) => "${e.identifier.parent.type.typeArguments.arguments} ${e.identifier}") ?? ''}');
        } else if (classMember is FieldDeclaration) {
          for (VariableDeclaration field in classMember.fields.variables) {
            res.add('  Variable ${field.name.name}');
          }
        } else if (classMember is ConstructorDeclaration) {
          if (classMember.name == null) {
            res.add('  Default constructor ${unitMember.name.name}');
          } else {
            res.add('  Constructor ${unitMember.name.name}.${classMember.name.name}');
          }
        }
      }
    }
  }

  new File('./node_samples.txt').writeAsString(res.join('\n'));
}


main1() async {
  //var src = await new File('./lib/mistletoe.dart').readAsString();
  //var ast = parseFile(src,parseFunctionBodies: true);
  // var ast = parseFile(path: 'C:/Users/User/Desktop/11/source/coupons_all_state.dart', featureSet: FeatureSet.fromEnableFlags2(sdkLanguageVersion: Version.parse('2.10.4'), flags: []));
  // var nodes = flatten_tree(ast.unit);

  var ast = await load();

  var nodes = flatten_tree(ast.unit);

  var types = {};
  for (var n in nodes) {
    types[n.runtimeType] ??= [];
    types[n.runtimeType].add(n);
  }
  var data = [];
  for (var k in types.keys) {
    data.add(k.toString());
    for (var e in types[k]) {
      data.add('\t' + e.toString());
    }
  }
  var data1 = data.join('\n');
  print(data1);
  await new File('./node_samples.txt').writeAsString(data1);
}

List flatten_tree(AstNode n, [int depth = 9999999]) {
  var que = [];
  que.add(n);
  var nodes = [];
  int nodes_count = que.length;
  int dep = 0;
  int c = 0;
  if (depth == 0) return [n];
  while (que.isNotEmpty) {
    var node = que.removeAt(0);
    show(node);
    if (node is! AstNode) continue;
    for (var cn in node.childEntities) {
      nodes.add(cn);
      que.add(cn);
    }
    //Keeping track of how deep in the tree
    ++c;
    if (c == nodes_count) {
      ++dep; // One layer done
      if (depth <= dep) return nodes;
      c = 0;
      nodes_count = que.length;
    }
  }
  return nodes;
}

show(node) {
  print('Type: ${node.runtimeType}, body: $node');
}
