# AI Box 개발 스킬

issamGPT AI Box 서비스를 독립적으로 개발하고, 메인 코드베이스에 안전하게 통합하기 위한 워크플로우 자동화 도구입니다.

이 스킬을 사용하면 메인 프로젝트와 분리된 환경에서 프로젝트의 규칙에 맞게 서비스를 개발한 뒤, 자동으로 Git 브랜치를 생성하고 통합하여 Pull Request를 쉽게 올릴 수 있습니다.

## 설치 방법

### Windows

```powershell
# 한 줄 설치
irm https://raw.githubusercontent.com/veryhungryface/ai-box-dev/main/scripts/install.ps1 | iex
```

### Mac / Linux

```bash
# 한 줄 설치
curl -fsSL https://raw.githubusercontent.com/veryhungryface/ai-box-dev/main/scripts/install.sh | bash
```

### 수동 설치

1. 이 폴더를 다운로드
2. 전역 스킬 경로에 복사:
   - **Windows**: `%USERPROFILE%\.gemini\antigravity\skills\ai-box-dev\`
   - **Mac/Linux**: `~/.gemini/antigravity/skills/ai-box-dev/`

```bash
# Mac/Linux
cp -r ./ai-box-dev ~/.gemini/antigravity/skills/

# Windows (PowerShell)
Copy-Item -Path ".\ai-box-dev" -Destination "$env:USERPROFILE\.gemini\antigravity\skills\ai-box-dev" -Recurse
```

---

## 사용 방법

### 1. 새 서비스 개발 시작

1. 빈 폴더에서 작업 시작 (예: `~/dev/math001/` 또는 `c:\dev\math001\`)
2. AI에게 요청: `"AI Box 새 서비스 만들어줘"`
3. `service.config.json` 편집:
   - `serviceKey`: 서비스 고유 ID (예: `MATH-QUIZ`)
   - `targetCodebase`: 메인 프로젝트(issamGPT)의 로컬 경로 지정

### 2. 개발 및 통합 (Git Workflow)

개발이 완료되면 AI에게 **"issamGPT 코드베이스에 통합하기"**라고 요청하세요. 스크립트(`integrate-service`)가 다음 작업을 자동으로 수행합니다:

1. **Git 브랜치 자동 생성**:
   - 메인 프로젝트 경로로 이동
   - 최신 `origin/develop`을 기반으로 새 브랜치 생성 (`feature/ai-box/{service-key}`)
2. **파일 복사 및 적용**:
   - 개발한 서비스 파일들을 메인 프로젝트의 올바른 위치로 복사
3. **자동 커밋 및 푸시**:
   - 변경 사항을 스테이징 및 커밋 (`feat(ai-box): integrate ...`)
   - 원격 저장소(`origin`)로 해당 브랜치 푸시
4. **마무리**:
   - GitHub에서 Pull Request(PR) 생성 안내

이후 GitHub에서 `develop` 브랜치로 병합 요청(PR)을 생성하면 됩니다.

---

## 폴더 구조

```
ai-box-dev/
├── SKILL.md              # 핵심 지침
├── README.md             # 이 파일
├── scripts/
│   ├── install.ps1       # Windows 설치 스크립트
│   ├── install.sh        # Mac/Linux 설치 스크립트
│   ├── integrate-service.ps1   # Windows 통합 스크립트
│   └── integrate-service.sh    # Mac/Linux 통합 스크립트
├── templates/            # 코드 템플릿
│   └── new-service/
│       ├── service.config.json
│       ├── web-app/      # 프론트엔드 템플릿
│       └── tool-service/ # 백엔드 템플릿
└── resources/            # 참조 자료
    └── checklist.md
```

---

## 요구사항

### Windows
- Windows 10/11
- PowerShell 5.1 이상

### Mac / Linux
- macOS 10.15+ 또는 Ubuntu 20.04+
- bash, curl, unzip
- jq (통합 스크립트용, 자동 설치됨)

---

## 문제 해결

### Mac에서 스크립트 실행 권한 오류

```bash
chmod +x ~/.gemini/antigravity/skills/ai-box-dev/scripts/*.sh
```

### jq 설치 (수동)

```bash
# Mac
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```
