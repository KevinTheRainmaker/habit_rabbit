# /flutter-commit — Flutter 안전 커밋

커밋 전 테스트와 분석을 자동으로 실행하고, 통과 시에만 커밋합니다.

## 사용법

```
/flutter-commit "feat: add new feature"
/flutter-commit "fix: resolve checkin state bug"
/flutter-commit "chore: update plan files"
```

## 실행 단계

1. **flutter test** 실행
   - FAIL → 실패한 테스트 목록 출력 후 **중단** (커밋 안 함)
   - PASS → 다음 단계 진행

2. **flutter analyze --no-fatal-infos** 실행
   - 에러 있음 → 에러 목록 출력 후 **중단** (커밋 안 함)
   - 에러 없음 → 다음 단계 진행

3. **git add** 및 **git commit** 실행
   - `git add <staged files>` (이미 스테이징된 파일 또는 변경된 파일)
   - `git commit -m "$MESSAGE"`

4. 결과 보고
   - 커밋 해시, 통과한 테스트 수, 커밋된 파일 목록 출력

## 커밋 메시지 prefix 컨벤션

| prefix      | 사용 시점                      |
| ----------- | ------------------------------ |
| `feat:`     | 새 기능 추가                   |
| `fix:`      | 버그 수정                      |
| `chore:`    | 설정, 계획 파일, 기타 유지보수 |
| `refactor:` | 동작 변경 없는 코드 개선       |
| `test:`     | 테스트만 변경                  |

## 참조

- `PROMPT.md` Step 4-5: 태스크 완료 처리 및 커밋 절차
- `tasks/lessons.md`: Flutter 테스트 패턴 참조
