# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요

**Habit Rabbit** — 토끼굴 세계관과 당근 포인트 경제를 기반으로 한 프리미엄 습관 트래커 앱.

- **개발 형태**: 1인 개발, 수익화 목표
- **플랫폼**: iOS / Android (Flutter — `docs/adr-tech-stack.md` 참조)
- **구독 관리**: RevenueCat
- **현재 상태**: MVP Phase 1 로컬 구현 완료 (407개 테스트 통과, 0 analyze 이슈)

## 프리미엄 모델

| 구분    | 무료                    | 유료                         |
| ------- | ----------------------- | ---------------------------- |
| 습관 수 | 최대 3개                | 무제한                       |
| 알림    | 고정 시간 1개           | 요일/시간 세분화             |
| 통계    | 기본 (스트릭, 달성률)   | 심화 (패턴, 추세, 실패 분석) |
| AI 코칭 | -                       | 실패 패턴 분석 + 맞춤 피드백 |
| 복구권  | 최초 1회 무료 체험      | 월 1개 자동 지급 (적립 가능) |
| 아이템  | 기본 아이템 + 미션 보상 | 프리미엄 아이템 추가         |

MVP 제외: 가족/팀 스페이스, 현금 IAP (당근 팩), HealthKit 연동, ML 알림 타이밍

## 핵심 제품 루프

```
습관 완료 → 당근 포인트 적립 (스트릭 보너스) → 아이템 구매 → 토끼/굴 꾸미기
     ↑                                                              ↓
     └────────────── 애착 형성 → 다음날 앱 열기 ──────────────────┘
```

## 성공 지표 (출시 6개월 내)

- Day-30 리텐션 35%
- Day-7 리텐션 55%
- 무료→유료 전환율 3%
- 첫 실패 후 D7 이탈율 50% 이하

## 디자인 원칙

- 토끼굴 세계관 일관성: 모든 UX 언어를 캐릭터 관점으로 작성
- 실패 시 처벌 없는 언어: "0일 리셋" 대신 "오늘 다시 시작"
- "체크박스"가 아닌 "습관 형성" 강조
- 업셀 원칙: 최소 3일 사용 후, 감정적 순간에만 직접 전환 요청

## 문서 구조

```
docs/
├── user-research-report.md      # Reddit 리서치 기반 4개 페르소나, 여정 지도
├── discovery-plan.md            # MVP 범위, 4개 검증 실험 (E1-E4), 타임라인
├── opportunity-solution-tree.md # OST — O1~O3 우선순위 기회 및 솔루션 매핑
├── prd-mvp.md                   # PRD — P0/P1/P2 요구사항, 성공 지표, 페이징
├── backlog.md                   # 28개 유저 스토리, 10개 Epic, 기술 노트
├── test-scenarios.md            # 52개 테스트 시나리오 (Critical/High/Medium)
├── feature-prioritization.md   # ICE 점수표 — 28개 스토리 우선순위, 10주 구현 순서
├── pre-mortem.md               # 11 Tigers, 4 Paper Tigers, 3 Elephants (런칭 리스크)
└── north-star-metric.md        # NSM: Weekly Habit Completers + 5개 Input Metrics
```

## North Star Metric

> **주간 습관 완수자 수 (Weekly Habit Completers)**
> 지난 7일간 설정한 습관의 **80% 이상을 완료한 사용자 수**

- **목표**: 출시 3개월 내 MAU의 35%
- **80% 기준**: "5일 중 4일" — 현실적이고 지속 가능. 스트릭 스트레스 없는 주간 기준
- **선행 지표**: Weekly Completers ↑ → D30 리텐션 ↑ → 구독 전환 ↑
- **상세**: `docs/north-star-metric.md`

## 핵심 가정 (검증 필요)

| 가정                                  | 검증 방법                       | 타임라인      |
| ------------------------------------- | ------------------------------- | ------------- |
| 아이템 꾸미기가 습관 유지 동기로 작동 | E1: 랜딩 페이지 사전 등록 200명 | 개발 전       |
| 첫 실패가 최적 업셀 타이밍            | E2: 베타 복구권 전환율 측정     | 베타 2-4주    |
| AI 코칭 피드백이 실제로 유용          | E3: 컨시어지 MVP (수동 리포트)  | 베타 2주 후   |
| 전환율 2-5% 달성 가능                 | E4: RevenueCat A/B 테스트       | 정식 출시 4주 |

## 기술 스택 (확정)

**`docs/adr-tech-stack.md` 참조**

| 항목       | 결정                                          |
| ---------- | --------------------------------------------- |
| 프레임워크 | **Flutter (Dart)**                            |
| 플랫폼     | **iOS + Android 동시 출시**                   |
| 언어       | **한국어 단독 (초기)**                        |
| 상태 관리  | Riverpod                                      |
| 로컬 DB    | Hive                                          |
| 백엔드     | Firebase (Auth + Firestore + Cloud Functions) |
| 구독       | RevenueCat Flutter SDK                        |
| 알림       | FCM (APNs/FCM 통합)                           |

## 미결정 사항

1. **구독 가격**: 3,900원 vs 6,900원/월 (E4: RevenueCat A/B로 결정)
2. **무료 한도**: 3개 vs 5개 (E5: 베타 A/B로 결정)

## 개발 현황

- **테스트**: 407개 통과, 0 analyze 이슈 (2026-03-09 기준)
- **완료**: 습관 CRUD, 체크인/스트릭/당근 포인트, 프리미엄 게이트, 통계, 알림 설정, 온보딩, 아이템 샵, 자정 갱신, 햅틱, Pull-to-refresh
- **다음 단계**: Firebase Auth 실제 연동 → RevenueCat 구독 → FCM 알림 → Firestore 싱크
- **주요 개발 문서**: `PROMPT.md` (TDD 루프), `docs/plans/` (태스크별 구현 계획), `tasks/lessons.md` (Flutter 테스트 패턴)

## 개발 로드맵

- **Phase 0**: 랜딩 페이지로 수요 검증 (200명 사전 등록 목표)
- **Phase 1**: P0 스토리 MVP 개발 → 베타 출시
- **Phase 2**: E1-E3 실험 실행 → 데이터 기반 기능 확정
- **Phase 3**: 정식 출시 + RevenueCat A/B (E4)
- **Phase 4**: AI 코칭 자동화, 이벤트 아이템, IAP, 가족 스페이스
