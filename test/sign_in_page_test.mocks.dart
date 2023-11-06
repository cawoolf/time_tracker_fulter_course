// Mocks generated by Mockito 5.4.2 from annotations
// in time_tracker_flutter_course/test/sign_in_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:flutter/cupertino.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart'
    as _i4;
import 'package:time_tracker_flutter_course/services/auth.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAuthBase_0 extends _i1.SmartFake implements _i2.AuthBase {
  _FakeAuthBase_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeValueNotifier_1<T> extends _i1.SmartFake
    implements _i3.ValueNotifier<T> {
  _FakeValueNotifier_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SignInManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockSignInManager extends _i1.Mock implements _i4.SignInManager {
  @override
  _i2.AuthBase get auth => (super.noSuchMethod(
        Invocation.getter(#auth),
        returnValue: _FakeAuthBase_0(
          this,
          Invocation.getter(#auth),
        ),
        returnValueForMissingStub: _FakeAuthBase_0(
          this,
          Invocation.getter(#auth),
        ),
      ) as _i2.AuthBase);

  @override
  _i3.ValueNotifier<bool> get isLoading => (super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: _FakeValueNotifier_1<bool>(
          this,
          Invocation.getter(#isLoading),
        ),
        returnValueForMissingStub: _FakeValueNotifier_1<bool>(
          this,
          Invocation.getter(#isLoading),
        ),
      ) as _i3.ValueNotifier<bool>);

  @override
  _i5.Future<void> signInAnonymously() => (super.noSuchMethod(
        Invocation.method(
          #signInAnonymously,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> signInWithGoogleWeb() => (super.noSuchMethod(
        Invocation.method(
          #signInWithGoogleWeb,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> signInWithGoogle() => (super.noSuchMethod(
        Invocation.method(
          #signInWithGoogle,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> signInWithFacebook() => (super.noSuchMethod(
        Invocation.method(
          #signInWithFacebook,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}