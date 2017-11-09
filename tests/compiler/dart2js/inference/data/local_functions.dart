// Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/*element: main:[null]*/
main() {
  namedLocalFunctionInvoke();
  unnamedLocalFunctionInvoke();
  namedLocalFunctionGet();
  recursiveLocalFunction();
  namedLocalFunctionInvokeMissingArgument();
  namedLocalFunctionInvokeExtraArgument();
  namedLocalFunctionInvokeExtraNamedArgument();
  closureToString();
  closureCallToString();
}

/*element: namedLocalFunctionInvoke:[exact=JSUInt31]*/
namedLocalFunctionInvoke() {
  /*[exact=JSUInt31]*/ local() => 0;
  return local();
}

/*element: unnamedLocalFunctionInvoke:[null|subclass=Object]*/
unnamedLocalFunctionInvoke() {
  var local = /*[exact=JSUInt31]*/ () => 0;
  return local();
}

/*element: namedLocalFunctionGet:[subclass=Closure]*/
namedLocalFunctionGet() {
  /*[exact=JSUInt31]*/ local() => 0;
  return local;
}

/*element: recursiveLocalFunction:[subclass=Closure]*/
recursiveLocalFunction() {
  /*[subclass=Closure]*/ local() => local;
  return local();
}

/*element: namedLocalFunctionInvokeMissingArgument:[null|subclass=Object]*/
namedLocalFunctionInvokeMissingArgument() {
  /*[exact=JSUInt31]*/ local(/*[empty]*/ x) => 0;
  // ignore: NOT_ENOUGH_REQUIRED_ARGUMENTS
  return local();
}

/*element: namedLocalFunctionInvokeExtraArgument:[null|subclass=Object]*/
namedLocalFunctionInvokeExtraArgument() {
  /*[exact=JSUInt31]*/ local() => 0;
  // ignore: EXTRA_POSITIONAL_ARGUMENTS
  return local(0);
}

/*element: namedLocalFunctionInvokeExtraNamedArgument:[null|subclass=Object]*/
namedLocalFunctionInvokeExtraNamedArgument() {
  /*[exact=JSUInt31]*/ local() => 0;
  // ignore: UNDEFINED_NAMED_PARAMETER
  return local(a: 0);
}

/*element: closureToString:[exact=JSString]*/
closureToString() {
  var local = /*[null]*/ () {};
  local();
  return local. /*invoke: [subclass=Closure]*/ toString();
}

// TODO(johnniwinther): Handle .call on closures correctly the old inference.
/*ast.element: closureCallToString:[empty]*/
/*kernel.element: closureCallToString:[exact=JSString]*/
closureCallToString() {
  var local = /*[null]*/ () {};
  local.call();
  return local
      .
      /*ast.invoke: [empty]*/
      /*kernel.invoke: [subclass=Closure]*/
      toString();
}
