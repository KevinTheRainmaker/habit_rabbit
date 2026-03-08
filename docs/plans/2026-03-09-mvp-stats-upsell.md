# Habit Rabbit MVP Stats & Upsell Polish — Implementation Plan

**Goal:** 통계 화면 빈 데이터 안내 + 업셀 스팸 방지 + 구독 완료 축하 화면

---

## Task 145: StatisticsScreen 빈 데이터 안내 (TDD) ✅

Story 17 AC: 데이터 없으면 "아직 기록이 없어요" 안내.

**Files:**

- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('체크인 없을 때 "아직 기록이 없어요" 표시', (tester) async { ... });
```

**GREEN**: 체크인 목록이 비어있을 때 안내 메시지 Text 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: show empty state in StatisticsScreen"
```

---

## Task 146: 업셀 스팸 방지 — 동일 세션 3회 이후 숨김 (TDD) ✅

Story 21 AC: 동일 세션에서 3번 이상 시도 시 더 이상 바텀시트 표시 안 함.

**Files:**

- Modify: `lib/presentation/screens/habit_list_screen.dart`
- Modify: `test/widget/habit_list_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('무료 사용자 4번째 시도 시 PremiumGate 미표시', (tester) async { ... });
```

**GREEN**: `_upsellCount` 상태 변수 추가. 3회 이상이면 바텀시트 생략.

**Step 5: 커밋**

```bash
git commit -m "feat: suppress upsell after 3 attempts in same session"
```

---

## Task 147: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp stats upsell complete"
```
