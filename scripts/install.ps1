<#
.SYNOPSIS
    AI Box 개발 스킬을 전역으로 설치하는 스크립트

.DESCRIPTION
    GitHub에서 AI Box 개발 스킬을 다운로드하여 
    사용자의 전역 스킬 폴더에 설치합니다.

.EXAMPLE
    # PowerShell에서 한 줄로 설치:
    irm https://raw.githubusercontent.com/{org}/{repo}/main/skills/install.ps1 | iex
#>

$ErrorActionPreference = "Stop"

# 설정
$SkillName = "ai-box-dev"
$RepoUrl = "https://github.com/veryhungryface/ai-box-dev"  # GitHub 저장소
$Branch = "main"
$SkillPath = "$env:USERPROFILE\.gemini\antigravity\skills\$SkillName"

# 색상 출력
function Write-Color {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

Write-Color "`n========================================" "Cyan"
Write-Color "  AI Box 개발 스킬 설치" "Cyan"
Write-Color "========================================`n" "Cyan"

# 1. 기존 스킬 백업
if (Test-Path $SkillPath) {
    $backupPath = "$SkillPath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Color "기존 스킬 백업 중: $backupPath" "Yellow"
    Move-Item $SkillPath $backupPath -Force
}

# 2. 스킬 폴더 생성
Write-Color "스킬 폴더 생성 중..." "White"
New-Item -ItemType Directory -Path $SkillPath -Force | Out-Null

# 3. GitHub에서 다운로드
Write-Color "GitHub에서 스킬 다운로드 중..." "White"

$TempZip = "$env:TEMP\ai-box-skill.zip"
$TempExtract = "$env:TEMP\ai-box-skill-extract"

try {
    # ZIP 다운로드
    $ZipUrl = "$RepoUrl/archive/refs/heads/$Branch.zip"
    Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -UseBasicParsing
    
    # 압축 해제
    Expand-Archive -Path $TempZip -DestinationPath $TempExtract -Force
    
    # 스킬 폴더 복사 (저장소 루트가 스킬 폴더)
    $SourcePath = Get-ChildItem $TempExtract -Directory | Select-Object -First 1
    $SkillSource = $SourcePath.FullName
    
    if (Test-Path $SkillSource) {
        Copy-Item -Path "$SkillSource\*" -Destination $SkillPath -Recurse -Force
        Write-Color "`n✅ 설치 완료!" "Green"
    } else {
        throw "스킬 폴더를 찾을 수 없습니다."
    }
}
catch {
    Write-Color "`n❌ 설치 실패: $_" "Red"
    exit 1
}
finally {
    # 임시 파일 정리
    Remove-Item $TempZip -Force -ErrorAction SilentlyContinue
    Remove-Item $TempExtract -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Color "`n설치 경로: $SkillPath" "Cyan"
Write-Color "이제 어떤 폴더에서든 AI Box 스킬을 사용할 수 있습니다!`n" "Green"
