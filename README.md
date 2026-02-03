# AI Box 개발 스킬

issamGPT AI Box 서비스를 개발하기 위한 Antigravity 스킬입니다.

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
3. `service.config.json`에서 `targetCodebase`를 본인의 메인코드베이스 폴더경로로 수정

### 2. 개발 완료 후 통합

AI에게 요청: `"issamGPT 코드베이스에 통합하기"`

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
