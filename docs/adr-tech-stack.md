# ADR: 기술 스택 결정

**날짜**: 2026-03-07
**상태**: 확정
**결정자**: 1인 개발자

---

## 결정 사항

| 항목       | 결정                        | 근거                                     |
| ---------- | --------------------------- | ---------------------------------------- |
| 프레임워크 | **Flutter (Dart)**          | 개발자 기존 숙련 언어                    |
| 플랫폼     | **iOS + Android 동시 출시** | Flutter 단일 코드베이스로 추가 비용 낮음 |
| 언어       | **한국어 단독 (초기)**      | 리소스 절약, 한국 시장 먼저 검증         |
| 구독 가격  | **미확정**                  | RevenueCat A/B 테스트 (E4)로 결정        |

---

## 프레임워크: Flutter

### 선택 이유

1. **개발자 숙련도**: Dart/Flutter 경험 보유 — 신규 언어 학습 곡선 없이 즉시 개발 시작 가능
2. **단일 코드베이스**: iOS + Android 동시 출시를 1인이 관리 가능
3. **RevenueCat SDK**: Flutter SDK 공식 지원, 문서 성숙
4. **애니메이션**: Lottie + Rive 모두 Flutter 공식 패키지 존재 (토끼/굴 애니메이션 필수)
5. **로컬 스토리지**: Hive (Flutter 전용) — 오프라인 체크인 지원에 최적

### 탈락 옵션 및 이유

| 옵션                    | 탈락 이유                                |
| ----------------------- | ---------------------------------------- |
| Swift (iOS Native)      | Android 별도 개발 필요 — 1인 리소스 한계 |
| Kotlin (Android Native) | iOS 별도 개발 필요 — 동시 출시 불가      |
| React Native            | JS/TS 미숙, Dart 대비 학습 비용 발생     |

---

## 플랫폼: iOS + Android 동시 출시

### 선택 이유

- Flutter 단일 코드베이스이므로 플랫폼 추가 비용이 낮음
- iOS 전용 출시 시 한국 Android 사용자(약 75%) 배제
- 사전 등록(E1)도 양쪽 스토어 동시 진행 가능

### 주의 사항

- **Apple Sign-In 필수 (S24)**: iOS에서 소셜 로그인 제공 시 App Store 가이드라인 4.8에 따라 Apple Sign-In 반드시 구현. **Week 1 Day 1 최우선 작업.**
- **APNs + FCM 동시 처리**: 알림 구현 시 양쪽 플랫폼 인증서/토큰 관리 필요
- **Google Play 정책**: Android에서 인앱 결제는 Google Play Billing 사용 필수 — RevenueCat이 자동 처리

---

## 언어: 한국어 단독 (초기)

### 선택 이유

- Phase 0-1에서 한국 시장 수요 검증에 집중
- 다국어 지원 시 카피라이팅 + 스토어 등록 + CS 부담 급증
- Flutter의 `intl` 패키지 사용 시 이후 다국어 추가는 용이함

### 향후 전환 조건

E2 베타에서 해외 사용자 자연 유입이 전체의 20% 이상 시 다국어 검토.

---

## 확정 기술 스택

```
프레임워크:    Flutter (Dart)
상태 관리:     Riverpod (Flutter 권장, 테스트 용이)
로컬 DB:       Hive (경량, Flutter 전용)
인증:          Firebase Auth (Apple Sign-In + Google Sign-In 지원)
구독 관리:     RevenueCat Flutter SDK
백엔드:        Firebase (Firestore + Cloud Functions) — 서버리스, 1인 관리 용이
푸시 알림:     Firebase Cloud Messaging (FCM) — APNs/FCM 통합 처리
애니메이션:    Lottie (복잡 애니메이션) + Rive (인터랙티브 캐릭터)
원격 설정:     Firebase Remote Config (당근 포인트 파라미터, 기능 플래그)
```

### 선택 근거 요약

| 라이브러리         | 선택 근거                                                        |
| ------------------ | ---------------------------------------------------------------- |
| Riverpod           | Provider 대비 컴파일 타임 안전성, 테스트 격리 용이               |
| Hive               | SQLite 대비 Flutter 네이티브, 빠른 I/O, 오프라인 체크인 지원     |
| Firebase Auth      | Apple Sign-In 구현 최단 경로, Flutter 플러그인 성숙              |
| Firebase Firestore | 서버리스, 실시간 동기화, 당근 포인트 서버사이드 멱등성 처리 가능 |
| RevenueCat         | S20 구독 연동 ICE 540점, Flutter SDK 공식 지원                   |

---

## 멱등성 처리 설계 (T3 런칭 블로킹 리스크 대응)

당근 포인트 중복 지급 방지를 위해 Firestore 트랜잭션 사용:

```
문서 경로: users/{uid}/checkins/{habitId}_{date}
쓰기 조건: 해당 문서가 존재하지 않을 때만 포인트 적립
구현:      Cloud Functions 트리거 또는 클라이언트 Firestore 트랜잭션
```

---

## 미확정 사항

| 항목                    | 현황                  | 결정 시점                      |
| ----------------------- | --------------------- | ------------------------------ |
| 구독 가격               | 3,900원 vs 6,900원/월 | E4: RevenueCat A/B (출시 4주)  |
| 무료 한도               | 3개 vs 5개            | E5: 베타 A/B (D30 리텐션 비교) |
| 아이템 샵 MVP 포함 여부 | E1 결과 후 결정       | Phase 0 완료 후                |

---

## 관련 문서

- [PRD](./prd-mvp.md)
- [Backlog](./backlog.md)
- [Pre-mortem](./pre-mortem.md)
- [Feature Prioritization](./feature-prioritization.md)
