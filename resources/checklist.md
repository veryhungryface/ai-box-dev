# AI Box 새 서비스 생성 체크리스트

## 백엔드 (apps/tool-service)

### 1. 서비스 등록
**파일**: `src/services/services.ts`
```typescript
export const SERVICES = {
  // 기존 서비스들...
  NEW_SERVICE: {
    index: 17,                    // 다음 인덱스
    name: "새 서비스 이름",
    id: "{UUID}",                 // UUID 생성 필요
    type: "new-service",          // kebab-case
    socket: false,                // 소켓 서비스인 경우 true
  },
};
```

### 2. 프롬프트 템플릿
**파일**: `src/prompts/templates/AiBox/{service-name}.ts`

### 3. 비즈니스 로직
**파일**: `src/services/AiBox/{serviceName}.ts`

### 4. 라우터
**파일**: `src/routes/AiBox/{serviceName}.ts`

### 5. 라우터 등록
**파일**: `src/routes/aiBoxRouterConfig.ts`
```typescript
import newServiceRouter from "./AiBox/{serviceName}";

export const AIBOX_ROUTER_CONFIG: RouterConfig[] = [
  // 기존 라우터들...
  {
    serviceKey: "NEW_SERVICE",
    path: "/tools/{service-path}",
    router: newServiceRouter,
  },
];
```

---

## 프론트엔드 (apps/web-app)

### 6. 상수/타입
**파일**: `src/constants/AiBox/services/{serviceName}.ts`

### 7. API 인터페이스
**파일**: `src/clients/AiBox/interfaces.ts`
```typescript
export interface ISV{N}Api {
  generateSomething(request: RequestType): Promise<ResponseType>;
}
```

### 8. API 구현
**파일**: `src/clients/AiBox/implementations.ts`

### 9. ToolApiClient 등록
**파일**: `src/clients/ToolApiClient.ts`

### 10. 메뉴 아이템
**파일**: `src/constants/menuItems.ts`
```typescript
{
  id: "{service-id}",
  serviceId: "{UUID}",
  label: "서비스 이름",
  icon: NewServiceIcon,
  socket: false,
  notReady: false,
},
```

### 11. 페이지 컴포넌트
**파일**: `src/screens/Aibox/{ServiceName}.tsx`

### 12. Next.js 라우팅
**파일**: `src/app/(main)/ai-box/{service-id}/page.tsx`

### 13. 아이콘
**파일**: `src/assets/icons/menu-aibox-{service}.svg`
