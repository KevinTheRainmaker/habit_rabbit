# Habit Rabbit — Ralph Loop Development Prompt

## 역할

너는 Habit Rabbit Flutter 앱을 TDD로 개발하는 시니어 엔지니어다.
매 반복마다 구현 계획의 다음 미완료 태스크 하나를 TDD 원칙에 따라 구현한다.

## 필수 참조 문서

작업 시작 전 반드시 읽을 것:

- `docs/plans/2026-03-07-mvp-foundation.md` — 도메인 레이어 계획 (Task 0~7) ✅ 완료
- `docs/plans/2026-03-07-mvp-data-layer.md` — 데이터 레이어 계획 (Task 8~11) ✅ 완료
- `docs/plans/2026-03-07-mvp-usecases.md` — 유스케이스 계획 (Task 12~15) ✅ 완료
- `docs/plans/2026-03-07-mvp-auth-providers.md` — 인증/Provider 계획 (Task 16~20) ✅ 완료
- `docs/plans/2026-03-07-mvp-remaining-usecases.md` — 나머지 유스케이스 (Task 21~24) ✅ 완료
- `docs/plans/2026-03-07-mvp-app-shell.md` — 앱 셸/스크린 (Task 25~28) ✅ 완료
- `docs/plans/2026-03-07-mvp-ui-wiring.md` — UI 연결 (Task 29~31) ✅ 완료
- `docs/plans/2026-03-07-mvp-checkin-ui.md` — 체크인 UI (Task 32~34) ✅ 완료
- `docs/plans/2026-03-07-mvp-add-habit.md` — 습관 추가 (Task 35~38) ✅ 완료
- `docs/plans/2026-03-07-mvp-delete-habit.md` — 삭제 UI + Hive 영속성 (Task 39~43) ✅ 완료
- `docs/plans/2026-03-07-mvp-streak-ui.md` — 스트릭 UI + 달성률 (Task 44~48) ✅ 완료
- `docs/plans/2026-03-07-mvp-completion-card-wiring.md` — 달성률 카드 연결 + 편집 (Task 49~52) ✅ 완료
- `docs/plans/2026-03-07-mvp-premium-gate.md` — 프리미엄 게이트 + 구독 (Task 53~57) ✅ 완료
- `docs/plans/2026-03-07-mvp-notification-settings.md` — 오늘 필터 + 알림 설정 (Task 58~62) ✅ 완료
- `docs/plans/2026-03-08-mvp-statistics.md` — 통계 화면 (Task 63~67) ✅ 완료
- `docs/plans/2026-03-08-mvp-onboarding.md` — 온보딩 흐름 (Task 68~72) ✅ 완료
- `docs/plans/2026-03-08-mvp-notification-service.md` — 알림 서비스 + UI (Task 73~77) ✅ 완료
- `docs/plans/2026-03-08-mvp-item-shop.md` — 아이템 샵 (Task 78~83) ✅ 완료
- `docs/plans/2026-03-08-mvp-customization.md` — 꾸미기 시스템 (Task 84~88) ✅ 완료
- `docs/plans/2026-03-08-mvp-streak-recovery.md` — 스트릭 복구권 (Task 89~93) ✅ 완료
- `docs/plans/2026-03-08-mvp-missions.md` — 미션 & 준비 제안 카드 (Task 94~99) ✅ 완료
- `docs/plans/2026-03-08-mvp-integration.md` — MVP 통합 연결 (Task 100~103) ✅ 완료
- `docs/plans/2026-03-08-mvp-polish.md` — MVP 폴리시 (Task 104~107) ✅ 완료
- `docs/plans/2026-03-09-mvp-final.md` — MVP 파이널 (Task 108~111) ✅ 완료
- `docs/plans/2026-03-09-mvp-wiring.md` — MVP 와이어링 (Task 112~115) ✅ 완료
- `docs/plans/2026-03-09-mvp-progress.md` — MVP 진행률 (Task 116~119) ✅ 완료
- `docs/plans/2026-03-09-mvp-refinements.md` — MVP 개선 (Task 120~124) ✅ 완료
- `docs/plans/2026-03-09-mvp-ux-polish.md` — MVP UX 폴리시 (Task 125~128) ✅ 완료
- `docs/plans/2026-03-09-mvp-mission-stats.md` — 미션 & 통계 (Task 129~132) ✅ 완료
- `docs/plans/2026-03-09-mvp-habit-schedule.md` — 습관 스케줄 (Task 133~135) ✅ 완료
- `docs/plans/2026-03-09-mvp-targetdays-wiring.md` — targetDays 연결 (Task 136~138) ✅ 완료
- `docs/plans/2026-03-09-mvp-edit-habit-gate.md` — 편집 요일 + 게이트 (Task 139~141) ✅ 완료
- `docs/plans/2026-03-09-mvp-onboarding-polish.md` — 온보딩 폴리시 (Task 142~144) ✅ 완료
- `docs/plans/2026-03-09-mvp-stats-upsell.md` — 통계 빈 데이터 + 업셀 스팸방지 (Task 145~147) ✅ 완료
- `docs/plans/2026-03-09-mvp-readiness-expire.md` — 준비 카드 억제 + 만료 배너 (Task 148~150) ✅ 완료
- `docs/plans/2026-03-09-mvp-notification-teaser.md` — 알림 토끼언어 + 티저 (Task 151~153) ✅ 완료
- `docs/plans/2026-03-09-mvp-blur-wiring.md` — 블러 연결 + 온보딩 스킵 + 알림 게이트 (Task 154~157) ✅ 완료
- `docs/plans/2026-03-09-mvp-premium-notifications.md` — 알림 isPremium 연결 + 요일별 알림 UI + 심화통계 (Task 158~161) ✅ 완료
- `docs/plans/2026-03-09-mvp-icon-restore.md` — 습관 아이콘 + 구독 복원 (Task 162~165) ✅ 완료
- `docs/plans/2026-03-09-mvp-icon-display.md` — 아이콘 표시 + 편집 (Task 166~168) ✅ 완료
- `docs/plans/2026-03-09-mvp-onboarding-recommend.md` — 온보딩 추천 & 통계 개선 (Task 169~172) ✅ 완료
- `docs/plans/2026-03-09-mvp-login-streak.md` — 로그인 연결 & 현재 스트릭 (Task 173~175) ✅ 완료
- `docs/plans/2026-03-09-mvp-deactivation-reco.md` — 구독 만료 비활성화 & 맞춤 추천 (Task 176~178) ✅ 완료
- `docs/plans/2026-03-09-mvp-failure-pattern.md` — 실패 패턴 분석 (Task 179~181) ← 현재
- `docs/adr-tech-stack.md` — 확정된 기술 스택
- `CLAUDE.md` — 프로젝트 컨텍스트 및 제품 원칙
- `docs/backlog.md` — 전체 유저 스토리

## 매 반복 실행 절차

### Step 1: 현재 상태 파악

```bash
git log --oneline -10
flutter test test/unit/ 2>&1 | tail -5
```

### Step 2: 다음 태스크 선택

`docs/plans/2026-03-09-mvp-failure-pattern.md`에서 **가장 낮은 번호의 미완료 Task**를 찾아라.
모든 Task가 완료되었으면 → 아래 "완료 조건" 참조.

### Step 3: TDD 사이클 실행

**철칙: 테스트 없는 프로덕션 코드 절대 금지**

1. **RED**: 실패하는 테스트를 먼저 작성
2. **VERIFY RED**: `flutter test <test_file>` 실행 → 반드시 실패 확인
3. **GREEN**: 테스트를 통과하는 최소한의 코드 작성
4. **VERIFY GREEN**: `flutter test <test_file>` 실행 → 통과 확인
5. **REFACTOR**: 중복 제거, 이름 개선 (동작 변경 금지)
6. **VERIFY REFACTOR**: `flutter test` 전체 실행 → 모두 통과 확인

### Step 4: 태스크 완료 처리

계획 파일에서 해당 태스크의 체크박스를 완료로 변경.

### Step 5: 커밋

계획 파일의 커밋 명령을 그대로 실행.

### Step 6: 반복 신호

다음 중 하나를 출력하고 종료:

- 태스크 완료 후 더 남은 것이 있으면: `<promise>ITERATION COMPLETE</promise>`
- 모든 태스크 완료 시: `<promise>ALL TASKS COMPLETE</promise>`

---

## TDD 원칙 (절대 위반 금지)

1. **테스트 먼저** — 프로덕션 코드보다 테스트를 먼저 작성
2. **실패 확인 필수** — 테스트가 실패하는 것을 직접 확인해야 함
3. **최소 코드** — 테스트를 통과하는 가장 단순한 코드만 작성
4. **자주 커밋** — 태스크 단위로 커밋, 메시지는 계획 파일 명세 따름
5. **전체 테스트 통과** — 새 코드 추가 후 기존 테스트가 깨지면 즉시 수정

## Flutter 테스트 명령

```bash
# 특정 테스트 실행
flutter test test/unit/domain/user_test.dart

# 전체 단위 테스트
flutter test test/unit/

# 전체 테스트
flutter test
```

## 막혔을 때

- 컴파일 에러: `flutter analyze` 실행 후 에러 수정
- 의존성 문제: `flutter pub get` 실행
- 테스트가 이상한 이유로 실패: 테스트 코드를 먼저 의심하지 말고 구현 코드를 점검

## 완료 조건

`docs/plans/2026-03-09-mvp-failure-pattern.md`의 Task 179~181이 모두 완료되면:

1. `flutter test test/unit/ test/widget/` 전체 통과 확인

2. `git log --oneline -15` 출력
3. `<promise>ALL TASKS COMPLETE</promise>` 출력
