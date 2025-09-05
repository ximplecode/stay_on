import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stay_on/main.dart';

void main() {
  testWidgets('로그인 버튼 탭 시 메인화면으로 이동', (WidgetTester tester) async {
    await tester.pumpWidget(const StayOnApp());

    // 로그인 버튼 찾기
    final loginBtn = find.byKey(const ValueKey('loginButton'));
    expect(loginBtn, findsOneWidget);

    // 탭 → 전환
    await tester.tap(loginBtn);
    await tester.pumpAndSettle();

    // 메인화면 텍스트로 검증 (타입 import 없이도 가능)
    expect(find.text('Stay On 메인 화면'), findsOneWidget);
  });
}
