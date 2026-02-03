<#
.SYNOPSIS
    AI Box 서비스를 메인 코드베이스에 통합하는 스크립트

.DESCRIPTION
    분리 개발된 서비스 폴더의 파일들을 issamGPT 메인 코드베이스의
    올바른 위치로 복사합니다.

.PARAMETER ServicePath
    통합할 서비스 폴더 경로 (예: c:\nas\new_service\math001)

.EXAMPLE
    .\integrate-service.ps1 -ServicePath "c:\nas\new_service\math001"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ServicePath
)

# 색상 출력 함수
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

# 시작 메시지
Write-ColorOutput "`n========================================" "Cyan"
Write-ColorOutput "  AI Box 서비스 통합 스크립트" "Cyan"
Write-ColorOutput "========================================`n" "Cyan"

# 1. 서비스 경로 확인
if (-not (Test-Path $ServicePath)) {
    Write-ColorOutput "오류: 서비스 경로를 찾을 수 없습니다: $ServicePath" "Red"
    exit 1
}

# 2. 설정 파일 읽기
$configPath = Join-Path $ServicePath "service.config.json"
if (-not (Test-Path $configPath)) {
    Write-ColorOutput "오류: service.config.json 파일을 찾을 수 없습니다." "Red"
    exit 1
}

$config = Get-Content $configPath -Raw | ConvertFrom-Json
$targetBase = $config.targetCodebase

Write-ColorOutput "서비스명: $($config.serviceLabel)" "Yellow"
Write-ColorOutput "대상 코드베이스: $targetBase" "Yellow"
Write-ColorOutput ""

# 2.5. Git 브랜치 작업
Write-ColorOutput "Git 브랜치 설정 중..." "Cyan"

if (-not (Test-Path "$targetBase\.git")) {
    Write-ColorOutput "오류: 대상 경로가 Git 저장소가 아닙니다: $targetBase" "Red"
    exit 1
}

Push-Location $targetBase

try {
    # 기존 상태 확인
    if ((git status --porcelain)) {
        Write-ColorOutput "경고: 대상 저장소에 커밋되지 않은 변경사항이 있습니다." "Yellow"
        # 강제 진행 여부는 사용자 판단에 맡기거나 여기서는 에러로 처리할 수도 있음. 일단 진행.
    }

    # 브랜치 이름 생성 (feature/ai-box/{service-key})
    # serviceKey는 보통 대문자이지만 브랜치명은 소문자 권장
    $branchName = "feature/ai-box/" + $config.serviceKey.ToLower()

    Write-ColorOutput "브랜치 전환: $branchName (Base: origin/develop)" "White"

    # Fetch origin
    git fetch origin

    # 브랜치 생성 및 체크아웃
    # 이미 존재하는 경우 체크아웃, 없으면 생성
    if (git show-ref --verify --quiet "refs/heads/$branchName") {
        Write-ColorOutput "기존 브랜치로 전환합니다." "Gray"
        git checkout $branchName
    } else {
        Write-ColorOutput "새 브랜치를 생성합니다 (from origin/develop)." "Gray"
        git checkout -b $branchName origin/develop
    }
} catch {
    Write-ColorOutput "Git 작업 중 오류 발생: $_" "Red"
    Pop-Location
    exit 1
}

Pop-Location

# 3. 파일 매핑에 따라 복사
Write-ColorOutput "파일 복사 시작..." "Cyan"

$copyCount = 0
foreach ($mapping in $config.fileMappings.PSObject.Properties) {
    $sourceDir = Join-Path $ServicePath $mapping.Name
    $destDir = Join-Path $targetBase $mapping.Value
    
    if (Test-Path $sourceDir) {
        # 대상 디렉토리가 없으면 생성
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        
        # 파일 복사
        $files = Get-ChildItem $sourceDir -File
        foreach ($file in $files) {
            $destPath = Join-Path $destDir $file.Name
            Copy-Item $file.FullName $destPath -Force
            Write-ColorOutput "  복사: $($file.Name) -> $($mapping.Value)" "Green"
            $copyCount++
        }
    }
}

Write-ColorOutput "`n총 $copyCount 개 파일 복사 완료!" "Green"

# 3.5. Git 커밋 및 푸시
if ($copyCount -gt 0) {
    Push-Location $targetBase
    try {
        Write-ColorOutput "`nGit 커밋 생성 중..." "Cyan"
        git add .
        git commit -m "feat(ai-box): integrate $($config.serviceName)"
        
        Write-ColorOutput "Git 푸시 중... (origin $branchName)" "Cyan"
        git push origin $branchName

        Write-ColorOutput "푸시 완료!" "Green"
    } catch {
        Write-ColorOutput "Git 커밋/푸시 중 오류 발생 (수동 확인 필요): $_" "Red"
    }
    Pop-Location
} else {
    Write-ColorOutput "`n복사된 파일이 없어 Git 커밋을 건너뜁니다." "Yellow"
}

# 4. 등록 작업 안내
Write-ColorOutput "`n========================================" "Yellow"
Write-ColorOutput "다음 파일들에 수동 등록이 필요합니다:" "Yellow"
Write-ColorOutput "========================================`n" "Yellow"

foreach ($registration in $config.registrations) {
    Write-ColorOutput "  - $($registration.file)" "White"
    Write-ColorOutput "    작업: $($registration.action)" "Gray"
}

Write-ColorOutput "`n통합 완료!" "Cyan"
Write-ColorOutput "GitHub에서 Pull Request를 생성하여 origin/develop에 병합 요청하세요.`n" "Cyan"
