#!/bin/bash
#
# AI Box 개발 스킬 설치 스크립트 (Mac/Linux)
#
# 사용법:
#   curl -fsSL https://raw.githubusercontent.com/{org}/{repo}/main/skills/ai-box-dev/scripts/install.sh | bash
#

set -e

# 설정
SKILL_NAME="ai-box-dev"
REPO_URL="https://github.com/veryhungryface/ai-box-dev"  # GitHub 저장소
BRANCH="main"
SKILL_PATH="$HOME/.gemini/antigravity/skills/$SKILL_NAME"

# 색상
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}========================================"
echo "  AI Box 개발 스킬 설치"
echo -e "========================================${NC}"
echo ""

# 1. 기존 스킬 백업
if [ -d "$SKILL_PATH" ]; then
    BACKUP_PATH="${SKILL_PATH}.backup.$(date +%Y%m%d-%H%M%S)"
    echo -e "${YELLOW}기존 스킬 백업 중: $BACKUP_PATH${NC}"
    mv "$SKILL_PATH" "$BACKUP_PATH"
fi

# 2. 스킬 폴더 생성
echo "스킬 폴더 생성 중..."
mkdir -p "$SKILL_PATH"

# 3. GitHub에서 다운로드
echo "GitHub에서 스킬 다운로드 중..."

TEMP_DIR=$(mktemp -d)
TEMP_ZIP="$TEMP_DIR/skill.zip"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# ZIP 다운로드
ZIP_URL="$REPO_URL/archive/refs/heads/$BRANCH.zip"
curl -fsSL "$ZIP_URL" -o "$TEMP_ZIP"

# 압축 해제
unzip -q "$TEMP_ZIP" -d "$TEMP_DIR"

# 스킬 폴더 복사 (저장소 루트가 스킬 폴더)
EXTRACTED_DIR=$(ls -d "$TEMP_DIR"/*/ | head -1)
SKILL_SOURCE="$EXTRACTED_DIR"

if [ -d "$SKILL_SOURCE" ]; then
    cp -r "$SKILL_SOURCE/"* "$SKILL_PATH/"
    echo ""
    echo -e "${GREEN}✅ 설치 완료!${NC}"
else
    echo -e "${RED}❌ 스킬 폴더를 찾을 수 없습니다.${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}설치 경로: $SKILL_PATH${NC}"
echo -e "${GREEN}이제 어떤 폴더에서든 AI Box 스킬을 사용할 수 있습니다!${NC}"
echo ""
