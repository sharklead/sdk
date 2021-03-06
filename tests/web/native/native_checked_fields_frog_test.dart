// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'native_testing.dart';

// Test that type checks occur on assignment to properties of native classes.

@Native("A")
class A {
  void set foo(int unused) native;
  int get foo native;
}

@Native("B")
class B {
  void set foo(String unused) native;
  String get foo native;
}

A makeA() native;
B makeB() native;

void setup() {
  JS('', r"""
(function(){
  function A() {}

  function B() {}

  self.makeA = function(){return new A()};
  self.makeB = function(){return new B()};

  self.nativeConstructor(A);
  self.nativeConstructor(B);
})()""");
  applyTestExtensions(['A', 'B']);
}

expectThrows(action()) {
  bool threw = false;
  try {
    action();
  } catch (e) {
    threw = true;
  }
  Expect.isTrue(threw);
}

complianceModeTest() {
  var things = <dynamic>[makeA(), makeB()];
  var a = things[0];
  var b = things[1];

  a.foo = 123;
  expectThrows(() => a.foo = 'xxx');
  Expect.equals(123, a.foo);

  b.foo = 'hello';
  expectThrows(() => b.foo = 123);
  Expect.equals('hello', b.foo);
}

omitImplicitChecksTest() {
  var things = <dynamic>[makeA(), makeB()];
  var a = things[0];
  var b = things[1];

  a.foo = 123;
  Expect.equals(123, a.foo);
  a.foo = 'xxx';
  Expect.equals('xxx', a.foo);

  b.foo = 'hello';
  Expect.equals('hello', b.foo);
  b.foo = 123;
  Expect.equals(b.foo, 123);
}

bool isComplianceMode() {
  var stuff = [1, 'string'];
  var a = stuff[0];
  // Detect whether we are using --omit-implicit-checks.
  try {
    String s = a as dynamic;
    return false;
  } catch (e) {
    // Ignore.
  }
  return true;
}

main() {
  nativeTesting();
  setup();

  if (isComplianceMode()) {
    complianceModeTest();
  } else {
    omitImplicitChecksTest();
  }
}
