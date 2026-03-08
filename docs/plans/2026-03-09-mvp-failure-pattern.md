# Habit Rabbit MVP 실패 패턴 분석 — Implementation Plan

**Goal:** P1-2 실패 패턴 분석 리포트 (유료, 2주 데이터 필요)

---

## Task 179: FailurePatternUseCase (TDD)

P1-2 AC: "당신은 월요일 밤에 가장 많이 실패해요" 수준의 구체적 패턴. 2주 미만 시 "분석 준비 중" 표시.

**Files:**

- Create: `lib/domain/usecases/failure_pattern_usecase.dart`
- Create: `test/unit/domain/failure_pattern_usecase_test.dart`

**RED**: 테스트:

```dart
test('체크인이 없는 요일이 가장 실패율 높은 요일', () { ... });
test('2주(14일) 미만 데이터면 분석 불가 반환', () { ... });
test('모든 요일 체크인 있으면 실패율 0', () { ... });
```

**GREEN**: `FailurePatternUseCase(checkins, today).worstDay` → int? (요일 0=월~6=일, null=데이터 부족).
`isReady` → bool (2주 이상 데이터 있는지).

**Step 5: 커밋**

```bash
git commit -m "feat: add FailurePatternUseCase for habit pattern analysis"
```

---

## Task 180: StatisticsScreen 실패 패턴 섹션 (유료, TDD)

P1-2 AC: 유료 사용자 2주+ 데이터 시 패턴 표시. 2주 미만 시 "분석 준비 중".

**Files:**

- Modify: `lib/presentation/screens/statistics_screen.dart`
- Modify: `test/widget/statistics_screen_test.dart`

**RED**: 테스트:

```dart
testWidgets('유료 사용자 2주+ 데이터 시 실패 패턴 섹션 표시', (tester) async { ... });
testWidgets('2주 미만 데이터면 "분석 준비 중" 표시', (tester) async { ... });
```

**GREEN**: StatisticsScreen isPremium && checkins.length >= 14 이면 패턴 섹션, 아니면 "분석 준비 중" 표시.

**Step 5: 커밋**

```bash
git commit -m "feat: show failure pattern analysis in StatisticsScreen for premium users"
```

---

## Task 181: 전체 테스트 통과 확인 ✅

```bash
flutter test test/unit/ test/widget/
git commit -m "chore: mvp failure pattern complete"
```
