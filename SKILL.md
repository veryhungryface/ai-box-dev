---
name: AI Box 서비스 개발 가이드
description: issamGPT AI Box 서비스 개발 시 따라야 할 표준 지침서. 새 서비스 생성, 프론트엔드/백엔드 개발, 통합 워크플로우 포함.
---

# AI Box 서비스 개발 스킬

이 스킬은 issamGPT AI Box 서비스 개발을 위한 표준 가이드라인입니다.

---

## 서비스 유형

| 유형 | 설명 | LLM 사용 |
|------|------|----------|
| **텍스트 생성** | LLM으로 텍스트 콘텐츠 생성 | `generateTextWithFallback` |
| **이미지 생성** | AI 이미지 생성/변환 | `generateImageWithFallback` |
| **소켓 서비스** | 선생님-학생 실시간 상호작용 | Socket.IO + Redis |

---

## 새 서비스 생성 체크리스트

### 백엔드 (tool-service)
1. `src/services/services.ts` - 서비스 등록
2. `src/prompts/templates/AiBox/{service-name}.ts` - 프롬프트 템플릿
3. `src/services/AiBox/{serviceName}.ts` - 비즈니스 로직
4. `src/routes/AiBox/{serviceName}.ts` - Express 라우터
5. `src/routes/aiBoxRouterConfig.ts` - 라우터 등록

### 프론트엔드 (web-app)
6. `src/constants/AiBox/services/{serviceName}.ts` - 상수/타입
7. `src/clients/AiBox/interfaces.ts` - API 인터페이스
8. `src/clients/AiBox/implementations.ts` - API 구현
9. `src/clients/ToolApiClient.ts` - API 등록
10. `src/constants/menuItems.ts` - 메뉴 아이템
11. `src/screens/Aibox/{ServiceName}.tsx` - 페이지 컴포넌트
12. `src/app/(main)/ai-box/{service-id}/page.tsx` - Next.js 라우팅
13. `src/assets/icons/menu-aibox-{service}.svg` - 아이콘

---

## 네이밍 규칙

| 항목 | 규칙 | 예시 |
|------|------|------|
| URL 경로 | kebab-case | `/ai-box/quiz-maker` |
| 서비스 키 | UPPER-KEBAB-CASE | `QUIZ-MAKER` |
| 컴포넌트 | PascalCase | `QuizMaker.tsx` |
| 상수 파일 | camelCase | `quizMaker.ts` |
| 프롬프트 | kebab-case | `quiz-maker.ts` |

---

## 디자인 시스템 핵심

### 색상
- 텍스트 기본: `#222222`
- 텍스트 서브: `#767676`
- 배경: `#FAFBFC`
- 테두리: `#EFEFEF`
- 주요 액션: `#F54F00` (hover: `#E04700`)

### 레이아웃
- `PageLayout` + `SplitLayout` 필수 사용
- 좌측 패널: 368px 고정
- 우측 패널: 최소 504px

---

## 분리 개발 워크플로우

### 개발 폴더 구조
새 서비스를 별도 폴더에서 개발할 때:

```
c:\nas\new_service\{service-name}\
├── web-app\
│   ├── screens\{ServiceName}.tsx
│   ├── constants\{serviceName}.ts
│   └── clients\
│       ├── interfaces.ts (해당 서비스 정의만 작성)
│       └── implementations.ts (해당 서비스 구현만 작성)
├── tool-service\
│   ├── routes\{serviceName}.ts
│   ├── services\{serviceName}.ts
│   └── prompts\{service-name}.ts
└── service.config.json
```

### service.config.json
```json
{
  "serviceName": "math-quiz-battle",
  "serviceLabel": "수학 퀴즈 배틀",
  "serviceKey": "MATH-QUIZ-BATTLE",
  "socket": false,
  "targetCodebase": "c:\\nas\\nas"
}
```

---

## 통합 명령

사용자가 다음과 같이 요청하면 통합을 수행:
- "issamGPT 코드베이스에 통합하기"
- "메인 프로젝트에 병합해줘"

### 통합 단계
1. `service.config.json` 읽기
2. Git 브랜치 생성:
   - Base: `origin/develop`
   - Branch: `feature/ai-box/{service-key}`
3. 각 파일을 대상 경로로 복사:
   - `web-app/screens/` → `apps/web-app/src/screens/Aibox/`
   - `web-app/constants/` → `apps/web-app/src/constants/AiBox/services/`
   - `tool-service/routes/` → `apps/tool-service/src/routes/AiBox/`
   - `tool-service/services/` → `apps/tool-service/src/services/AiBox/`
   - `tool-service/prompts/` → `apps/tool-service/src/prompts/templates/AiBox/`
4. 코드 커밋 및 푸시:
   - `git add .`
   - `git commit -m "feat(ai-box): integrate {service-name}"`
   - `git push origin feature/ai-box/{service-key}`
5. 코드 병합 및 등록 (수동 or 추가 스크립트):
   - `web-app/clients/interfaces.ts` 내용 → `apps/web-app/src/clients/AiBox/interfaces.ts`에 추가
   - `web-app/clients/implementations.ts` 내용 → `apps/web-app/src/clients/AiBox/implementations.ts`에 추가
   - `services.ts`: 서비스 객체 추가
   - `aiBoxRouterConfig.ts`: 라우터 등록 (serviceKey 대문자/대시 확인)
   - `menuItems.ts`: 메뉴 추가
6. PR 생성 및 승인 요청

---

## 참조 파일

- **템플릿**: `templates/new-service/` 폴더
- **체크리스트**: `resources/checklist.md`
- **전체 PRD**: `c:\nas\nas\ai-box-PRD.md`
