# Habit Rabbit MVP 분석 경고 제거 — Implementation Plan

**Goal:** `flutter analyze` info 4건 제거 → 완전히 클린한 분석 상태

---

## Task 185: hive 직접 의존성 추가

`hive_flutter`의 transitive dependency `hive`를 직접 import하므로 pubspec.yaml에 명시 필요.

**Files:**

- Modify: `pubspec.yaml`

**RED**: `flutter analyze` → depend_on_referenced_packages info 2건

**GREEN**: pubspec.yaml dependencies에 `hive: ^2.2.3` 추가.

**Step 5: 커밋**

```bash
git commit -m "chore: add hive as direct dependency to pubspec.yaml"
```

---

## Task 186: withOpacity → withValues() 교체

`withOpacity`는 deprecated. `withValues(alpha:)` 사용으로 교체.

**Files:**

- Modify: `lib/presentation/screens/edit_habit_dialog.dart`
- Modify: `lib/presentation/widgets/premium_blur_overlay.dart`

**RED**: `flutter analyze` → deprecated_member_use info 2건

**GREEN**: `withOpacity(x)` → `withValues(alpha: x)` 교체.

**Step 5: 커밋**

```bash
git commit -m "chore: replace deprecated withOpacity with withValues"
```

---

## Task 187: 전체 테스트 + 분석 클린 통과 확인

```bash
flutter test
flutter analyze --no-fatal-infos
git commit -m "chore: mvp analyze clean complete"
```
