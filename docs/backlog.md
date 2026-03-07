# Backlog: Habit Rabbit MVP

**포맷**: User Stories (As a [user], I want [capability], so that [benefit])
**총 스토리 수**: 28개
**기준 문서**: `docs/prd-mvp.md`
**날짜**: 2026-03-07

---

## Epic 1: 습관 관리 (Habit CRUD)

### Story 1: 습관 생성

**As a user, I want to create a new habit with a name, icon, and target days, so that I can start tracking something I want to build.**

Acceptance Criteria:

- [ ] 이름(필수), 아이콘 선택(기본값 제공), 반복 요일 설정 가능
- [ ] 무료 사용자가 3개 초과 생성 시도 시 업셀 화면으로 이동 (강제 팝업 아님)
- [ ] 생성 완료 후 메인 화면에 즉시 노출

Priority: P0 | Effort: M | Dependencies: 없음

---

### Story 2: 습관 수정 및 삭제

**As a user, I want to edit or delete an existing habit, so that I can adjust my goals over time.**

Acceptance Criteria:

- [ ] 이름, 아이콘, 반복 요일 수정 가능
- [ ] 삭제 시 확인 다이얼로그 표시 ("삭제하면 기록도 사라져요")
- [ ] 삭제 후 해당 습관의 스트릭/통계도 함께 제거

Priority: P0 | Effort: S | Dependencies: Story 1

---

### Story 3: 일일 체크인

**As a user, I want to check off habits as completed on the main screen, so that I can easily log my daily progress.**

Acceptance Criteria:

- [ ] 오늘 날짜 기준으로 해당 요일 습관만 메인 화면에 표시
- [ ] 체크 시 즉각적인 시각적 피드백 (토끼 반응 애니메이션)
- [ ] 자정 기준으로 체크 상태 초기화 (로컬 타임존 기준)
- [ ] 하루 지난 날짜는 소급 체크 불가 (복구권 제외)

Priority: P0 | Effort: M | Dependencies: Story 1

---

### Story 4: 습관 완료율 대안 지표

**As a user, I want to see my monthly completion rate alongside my streak, so that one bad day doesn't feel like total failure.**

Acceptance Criteria:

- [ ] 메인 화면에 현재 스트릭 + 이번 달 달성률(%) 동시 표시
- [ ] 스트릭 0이지만 달성률 70% 이상이면 긍정 메시지 표시 ("이번 달 70% 달성했어, 잘하고 있어!")
- [ ] 달성률 계산: 당월 완료일 수 / 당월 목표일 수

Priority: P1 | Effort: S | Dependencies: Story 3

---

## Epic 2: 스트릭 & 복구 시스템

### Story 5: 스트릭 자동 추적

**As a user, I want my habit streak to be automatically tracked, so that I can see how consistently I've been doing.**

Acceptance Criteria:

- [ ] 오늘 체크 완료 시 스트릭 +1 (자정 기준)
- [ ] 하루라도 미체크 시 스트릭 0 리셋 (복구권 미사용 시)
- [ ] 최장 스트릭(All-time best) 별도 기록 및 표시
- [ ] 스트릭 5, 10, 30, 100일 달성 시 축하 애니메이션

Priority: P0 | Effort: M | Dependencies: Story 3

---

### Story 6: 스트릭 복구권 — 유료 월 지급

**As a subscriber, I want to receive 1 recovery ticket per month that accumulates, so that I have a safety net without pressure.**

Acceptance Criteria:

- [ ] 유료 구독 활성화 상태에서 매월 1일 복구권 1개 자동 지급
- [ ] 미사용 시 다음 달로 적립 (상한 없음)
- [ ] 보유 복구권 수량을 메인 화면 또는 프로필에서 확인 가능
- [ ] RevenueCat webhook 또는 구독 상태 확인으로 지급 트리거

Priority: P0 | Effort: M | Dependencies: Story 13 (RevenueCat)

---

### Story 7: 스트릭 복구권 사용

**As a user, I want to use a recovery ticket to restore a streak I accidentally broke, so that I don't lose my progress over one missed day.**

Acceptance Criteria:

- [ ] 스트릭 깨진 다음날 자정 이내에만 복구 가능 (단, 48시간 이내 허용 검토 필요)
- [ ] 복구 시 해당일 완료로 소급 처리 → 스트릭 이어짐
- [ ] 복구권 1개 차감, 잔여 수량 즉시 업데이트
- [ ] 복구 완료 후 토끼의 안도 애니메이션 표시

Priority: P0 | Effort: M | Dependencies: Story 5, Story 6

---

### Story 8: 스트릭 첫 실패 — 위로 플로우 + 무료 복구권 체험

**As a new user, I want to receive a comforting message and a free recovery ticket when I first break a streak, so that I don't give up immediately.**

Acceptance Criteria:

- [ ] 생애 첫 스트릭 깨짐 시에만 트리거 (이후 재발 시 미표시)
- [ ] 토끼 캐릭터 위로 메시지 모달 표시 ("괜찮아, 한 번쯤은 쉴 수 있어")
- [ ] 모달에 "무료 복구권 사용하기" + "괜찮아, 다시 시작할게" 두 가지 선택지
- [ ] 무료 복구권 선택 시: 복구 처리 → "유료 플랜에서 매달 받을 수 있어요" 업셀 카드 표시
- [ ] 무료 복구권은 계정당 1회만 제공

Priority: P0 | Effort: M | Dependencies: Story 5, Story 7, Story 13

---

## Epic 3: 당근 포인트 경제

### Story 9: 당근 포인트 적립

**As a user, I want to earn carrot points when I complete habits, so that I feel rewarded for my consistency.**

Acceptance Criteria:

- [ ] 습관 1회 완료 시 기본 포인트 지급 (예: 10당근, 최종 수치는 베타 밸런스 조정)
- [ ] 스트릭 일수에 따른 보너스 지급 (예: 7일 +5%, 30일 +10%, 최대 +30%)
- [ ] 당근 포인트 잔액 메인 화면에 항상 노출
- [ ] 당근 획득 시 간단한 +N 팝업 애니메이션

Priority: P0 | Effort: S | Dependencies: Story 3

---

### Story 10: 아이템 샵 — 탐색 및 구매

**As a user, I want to browse and purchase items in the shop with my carrot points, so that I can customize my rabbit and burrow.**

Acceptance Criteria:

- [ ] 아이템을 카테고리별로 탐색 가능 (토끼 의상, 굴 인테리어 등)
- [ ] 각 아이템에 이름, 가격(당근), 미리보기 이미지 표시
- [ ] 프리미엄 아이템은 유료 구독자에게만 표시 및 구매 가능 (무료 사용자에게는 자물쇠 아이콘)
- [ ] 잔액 부족 시 "당근이 부족해요" 안내 (구매 불가 처리)
- [ ] 구매 완료 후 즉시 보유 아이템 목록에 추가

Priority: P0 | Effort: L | Dependencies: Story 9

---

### Story 11: 토끼/굴 꾸미기

**As a user, I want to equip purchased items to customize my rabbit and burrow, so that I can create a space that feels uniquely mine.**

Acceptance Criteria:

- [ ] 보유 아이템 목록에서 장착/해제 자유롭게 가능
- [ ] 장착 상태는 앱 재시작 후에도 유지 (로컬 저장)
- [ ] 메인 화면에서 현재 꾸며진 토끼굴 실시간 반영
- [ ] 아이템은 계정에 영구 귀속 (삭제 불가)

Priority: P0 | Effort: L | Dependencies: Story 10

---

### Story 12: 미션 달성 아이템 보상

**As a user, I want to earn basic items by completing milestones, so that I can decorate my space even without spending carrot points.**

Acceptance Criteria:

- [ ] 미션 목록 제공: "첫 습관 완료", "7일 연속 달성", "첫 30일 달성" 등 최소 5개
- [ ] 미션 달성 시 즉시 아이템 지급 + 알림 표시
- [ ] 미션 진행 상황을 별도 화면에서 확인 가능
- [ ] 이미 달성한 미션은 재지급 없음 (중복 방지)

Priority: P1 | Effort: M | Dependencies: Story 10

---

## Epic 4: 온보딩

### Story 13: 온보딩 퀴즈

**As a new user, I want to answer a few questions about my lifestyle and goals, so that I get personalized habit recommendations from the start.**

Acceptance Criteria:

- [ ] 3-5개의 간단한 질문 (목표 유형, 루틴 시간대, 경험 수준 등)
- [ ] 답변 기반으로 2-3개 맞춤 습관 추천 (예: "아침형이라면 — 물 한 잔, 스트레칭")
- [ ] 추천은 선택 가능하고 직접 입력도 허용
- [ ] 전체 퀴즈 완료 2분 이내 (간결함 우선)

Priority: P0 | Effort: M | Dependencies: 없음

---

### Story 14: "1개부터 시작" 권장

**As a new user, I want to be encouraged to start with just one habit, so that I don't overwhelm myself and actually stick with it.**

Acceptance Criteria:

- [ ] 퀴즈 후 습관 선택 화면에서 "오늘은 1개만 시작해요" 문구 강조 표시
- [ ] 1개 선택 시 긍정 피드백 메시지 ("완벽한 시작이에요!")
- [ ] 2-3개 선택 시에도 허용하되 "처음엔 적을수록 좋아요" 부드러운 안내
- [ ] 3개 초과 선택은 무료 한도로 제한 (Story 1 연계)

Priority: P0 | Effort: S | Dependencies: Story 13

---

## Epic 5: 알림

### Story 15: 습관 알림 설정 (무료)

**As a user, I want to set a notification time for each habit, so that I get reminded at the right moment.**

Acceptance Criteria:

- [ ] 습관별로 알림 시간 1개 설정 가능 (시/분 선택)
- [ ] 알림 텍스트에 토끼 캐릭터 언어 사용 ("당근이 기다리고 있어요!")
- [ ] 알림 활성화/비활성화 토글 제공
- [ ] OS 알림 권한 미허용 시 권한 요청 가이드 표시

Priority: P0 | Effort: M | Dependencies: 없음

---

### Story 16: 알림 세분화 (유료)

**As a subscriber, I want to set different notification times for each day of the week, so that I can align reminders with my varying daily schedule.**

Acceptance Criteria:

- [ ] 요일별 개별 알림 시간 설정 가능 (월~일 각각)
- [ ] 특정 요일 알림 비활성화 가능
- [ ] 무료 사용자가 해당 기능 진입 시 유료 안내 표시

Priority: P1 | Effort: M | Dependencies: Story 15, Story 20 (구독)

---

## Epic 6: 통계

### Story 17: 기본 통계 (무료)

**As a user, I want to see my streak and weekly completion rate, so that I can track my basic progress.**

Acceptance Criteria:

- [ ] 현재 스트릭 일수 표시
- [ ] 이번 주 / 이번 달 달성률(%) 표시
- [ ] 습관별 개별 달성률 확인 가능
- [ ] 최소 1주일 데이터부터 표시 (데이터 없으면 "아직 기록이 없어요" 안내)

Priority: P0 | Effort: M | Dependencies: Story 3, Story 5

---

### Story 18: 심화 통계 (유료)

**As a subscriber, I want to see patterns in my habit completion by day and time, so that I can understand when I succeed or struggle.**

Acceptance Criteria:

- [ ] 요일별 달성률 히트맵 또는 바 차트
- [ ] 월별 달성률 추세 그래프
- [ ] 가장 자주 실패하는 요일/시간대 하이라이트
- [ ] 무료 사용자에게는 블러 처리된 티저로 노출 (Story 19 연계)
- [ ] 최소 2주 데이터 축적 후 활성화 ("분석 준비 중이에요 — N일 후 공개" 표시)

Priority: P0 | Effort: L | Dependencies: Story 17, Story 20

---

### Story 19: 유료 기능 티저 미리보기

**As a free user, I want to see a preview of premium analytics and AI coaching, so that I understand the value before deciding to upgrade.**

Acceptance Criteria:

- [ ] 심화 통계, AI 코칭 화면에 블러 오버레이 적용
- [ ] 블러 위에 "구독하면 이런 인사이트를 받을 수 있어요" 카피 + 업그레이드 CTA
- [ ] CTA 클릭 시 구독 화면으로 이동
- [ ] 티저는 로그인 상태에서만 노출 (미로그인 시 일반 잠금 처리)

Priority: P1 | Effort: S | Dependencies: Story 17, Story 20

---

## Epic 7: 구독 & 수익화

### Story 20: RevenueCat 구독 연동

**As a user, I want to subscribe to the premium plan and have my subscription recognized across devices, so that I can access all premium features reliably.**

Acceptance Criteria:

- [ ] RevenueCat SDK 연동 (iOS/Android)
- [ ] 월간/연간 플랜 각 1개 이상 제공
- [ ] 구독 상태 앱 실행 시마다 서버 검증 (RevenueCat entitlement 확인)
- [ ] "구독 복원" 버튼 제공 (기기 변경 시 복원 가능)
- [ ] 구독 만료 시 유료 기능 즉시 비활성화

Priority: P0 | Effort: L | Dependencies: 없음 (선행 필수)

---

### Story 21: 4번째 습관 한도 업셀

**As a free user trying to add my 4th habit, I want to see a clear upgrade prompt, so that I understand why I'm blocked and what I'd get by upgrading.**

Acceptance Criteria:

- [ ] 4번째 습관 추가 시도 시 업셀 바텀시트 표시 (전체 화면 팝업 아님)
- [ ] 바텀시트에 유료 혜택 요약 (무제한 습관, AI 코칭, 복구권 등)
- [ ] "업그레이드하기" + "나중에" 두 가지 CTA
- [ ] "나중에" 선택 시 바텀시트 닫힘 (강요 없음)
- [ ] 동일 세션에서 3번 이상 시도 시 더 이상 바텀시트 표시 안 함 (스팸 방지)

Priority: P0 | Effort: S | Dependencies: Story 20

---

### Story 22: 구독 화면 (Paywall)

**As a user, I want to see a compelling subscription screen, so that I can make an informed decision about upgrading.**

Acceptance Criteria:

- [ ] 무료 vs 유료 기능 비교 표시
- [ ] 월간/연간 가격 표시 (연간 할인율 강조)
- [ ] 토끼 캐릭터를 활용한 감성적 구독 화면 디자인
- [ ] 구독 완료 후 "프리미엄 토끼가 됐어요!" 축하 화면
- [ ] 개인정보 처리방침 및 이용약관 링크 포함

Priority: P0 | Effort: M | Dependencies: Story 20

---

## Epic 8: 점진적 성장 지원

### Story 23: 습관 추가 준비 제안

**As a user who has been consistent, I want to be gently prompted to add another habit when I'm ready, so that I can grow my routine without being overwhelmed.**

Acceptance Criteria:

- [ ] 최근 7일 달성률 80% 이상 유지 시 자동 제안 카드 표시
- [ ] "습관 하나 더 추가할 준비됐어요?" 카드 (메인 화면 하단 또는 통계 화면)
- [ ] "추가하기" + "아직은 괜찮아" 두 가지 선택지
- [ ] "아직은 괜찮아" 선택 시 7일간 재노출 없음

Priority: P1 | Effort: S | Dependencies: Story 3, Story 17

---

## Epic 9: 계정 & 데이터

### Story 24: 회원가입 / 로그인

**As a user, I want to create an account and log in, so that my data is synced and accessible across devices.**

Acceptance Criteria:

- [ ] 소셜 로그인 지원 (Apple Sign-In 필수, Google 선택)
- [ ] 이메일/비밀번호 로그인 (선택 사항 — 복잡도 고려)
- [ ] 비로그인 상태에서도 로컬 데이터로 앱 사용 가능
- [ ] 로그인 시 로컬 데이터 → 서버 데이터 자동 병합 또는 선택 마이그레이션

Priority: P0 | Effort: L | Dependencies: 없음 (선행 필수)

---

### Story 25: 데이터 동기화 (오프라인 지원)

**As a user, I want to log habits even without internet, so that my data is never lost due to connectivity issues.**

Acceptance Criteria:

- [ ] 오프라인 상태에서 체크인, 포인트 적립, 아이템 구매 로컬 저장
- [ ] 온라인 복귀 시 자동 싱크 (충돌 시 로컬 우선)
- [ ] 동기화 상태 표시 (마지막 싱크 시간)

Priority: P1 | Effort: L | Dependencies: Story 24

---

## Epic 10: 에러 처리 & 엣지 케이스

### Story 26: 구독 만료 처리

**As a subscriber whose subscription has lapsed, I want to see a clear message explaining what I've lost, so that I can decide whether to renew.**

Acceptance Criteria:

- [ ] 구독 만료 시 유료 기능 비활성화 + 만료 안내 배너
- [ ] 초과된 습관(4개+)은 비활성화 처리 (삭제 아님) — 재구독 시 복원
- [ ] "다시 구독하기" CTA 제공
- [ ] 만료 3일 전 푸시 알림으로 사전 안내

Priority: P0 | Effort: M | Dependencies: Story 20

---

### Story 27: 당근 포인트 밸런싱 설정

**As a developer, I want to configure carrot point values remotely, so that I can balance the economy without an app update.**

Acceptance Criteria:

- [ ] 기본 포인트 지급량, 스트릭 보너스율을 원격 설정(Remote Config 또는 서버값)으로 관리
- [ ] 기본값은 앱 내 하드코딩으로 폴백 처리
- [ ] 변경 시 앱 재시작 없이 적용 (또는 다음 세션에 적용)

Priority: P1 | Effort: M | Dependencies: Story 9

---

### Story 28: 온보딩 스킵 옵션

**As a returning user or someone who prefers to set up manually, I want to skip the onboarding quiz, so that I'm not forced through a flow I don't need.**

Acceptance Criteria:

- [ ] 온보딩 화면에 "건너뛰기" 옵션 제공
- [ ] 스킵 시 빈 습관 목록으로 바로 진입
- [ ] 스킵 사용자에게는 첫 진입 시 "첫 습관을 추가해보세요" 가이드 카드 표시

Priority: P1 | Effort: S | Dependencies: Story 13

---

## Story Map

```
필수 (P0) ─────────────────────────────────────────────────────
계정     : Story 24 (로그인)
온보딩   : Story 13 (퀴즈) → Story 14 (1개 시작)
습관관리 : Story 1 (생성) → Story 2 (수정/삭제) → Story 3 (체크인)
스트릭   : Story 5 (추적) → Story 8 (첫실패+위로)
복구권   : Story 6 (유료지급) → Story 7 (사용)
당근경제 : Story 9 (적립) → Story 10 (샵) → Story 11 (꾸미기)
통계     : Story 17 (기본) → Story 18 (심화/유료)
알림     : Story 15 (기본)
구독     : Story 20 (RevenueCat) → Story 22 (페이월) → Story 21 (업셀)
에러     : Story 26 (만료처리)

권장 (P1) ──────────────────────────────────────────────────────
Story 4  (달성률 지표)   Story 12 (미션 아이템)
Story 16 (알림 세분화)   Story 18 → Story 19 (티저)
Story 23 (성장 제안)     Story 25 (오프라인 싱크)
Story 27 (포인트 설정)   Story 28 (온보딩 스킵)
```

---

## 기술 노트

| 항목           | 내용                                                                      |
| -------------- | ------------------------------------------------------------------------- |
| **구독 관리**  | RevenueCat SDK — iOS/Android 동시 연동. Entitlement로 유/무료 기능 게이팅 |
| **로컬 저장**  | SQLite 또는 Hive(Flutter 기준). 오프라인 체크인 지원 필수                 |
| **원격 설정**  | 당근 포인트 밸런스용 Firebase Remote Config 또는 자체 서버 엔드포인트     |
| **인증**       | Apple Sign-In (iOS App Store 필수), Google Sign-In                        |
| **알림**       | FCM (Android) + APNs (iOS). 로컬 알림으로 폴백 가능                       |
| **애니메이션** | Lottie 또는 Rive — 토끼 반응, 완료 세리머니, 위로 플로우                  |

---

## Open Questions (구현 전 결정 필요)

| 질문                                                               | 결정 기한        |
| ------------------------------------------------------------------ | ---------------- |
| 크로스플랫폼(Flutter/RN) vs 네이티브 중 어느 것으로 개발할 것인가? | 개발 시작 전     |
| 스트릭 복구 가능 기간: 다음날 자정 vs 48시간?                      | Story 7 구현 전  |
| 당근 포인트 기본 지급량 및 스트릭 보너스율 초기값                  | Story 9 구현 전  |
| 아이템 초기 출시 수량은 몇 개? (최소 15개 이상 권장)               | 디자인 단계      |
| 심화 통계의 "2주 데이터" 기준: 가입일 기준 vs 습관 생성일 기준?    | Story 18 구현 전 |

---

## 관련 문서

- [PRD](./prd-mvp.md)
- [사용자 리서치 리포트](./user-research-report.md)
- [Opportunity Solution Tree](./opportunity-solution-tree.md)
