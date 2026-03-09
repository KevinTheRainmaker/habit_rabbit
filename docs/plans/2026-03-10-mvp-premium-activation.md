# Habit Rabbit MVP 프리미엄 활성화 연결 — Implementation Plan

**Goal:** 업그레이드 버튼이 실제로 프리미엄을 활성화하도록 연결

현재 문제:

- `PremiumGateScreen`의 "업그레이드하기" 버튼이 스낵바만 표시하고 종료
- `subscriptionRepositoryProvider.purchasePremium()` 미호출
- 앱 재시작 후 여전히 무료 플랜 상태

---

## ✅ Task 221: PremiumGateScreen 업그레이드 버튼 실제 연결 (TDD)

**Files:**

- Modify: `lib/presentation/screens/premium_gate_screen.dart`
- Modify: `test/widget/premium_gate_screen_test.dart`

**RED**: 테스트 추가:

```dart
test('업그레이드 버튼 탭 시 purchasePremium 호출', () { ... });
test('업그레이드 후 isPremiumProvider 갱신', () { ... });
```

**GREEN**:

- `PremiumGateScreen`을 `ConsumerWidget`으로 변환
- 업그레이드 버튼에서 `subscriptionRepositoryProvider.purchasePremium()` 호출
- `ref.invalidate(isPremiumProvider)` 로 캐시 무효화

**Step 5: 커밋**

```bash
git commit -m "fix: connect upgrade button to purchasePremium in PremiumGateScreen"
```

---

## ✅ Task 222: HabitListScreen 프리미엄 체크를 isPremiumProvider로 변경

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`

**GREEN**: `_showAddHabitDialog`에서 `isPremiumProvider.valueOrNull ?? user.isPremium` 사용
(구매 직후에도 프리미엄으로 인식)

**Step 5: 커밋**

```bash
git commit -m "fix: use isPremiumProvider for habit limit check in HabitListScreen"
```

---

## ✅ Task 223: 전체 테스트 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp premium activation complete"
```
