#!/bin/bash
#
# AI Box 서비스를 메인 코드베이스에 통합하는 스크립트 (Mac/Linux)
#
# 사용법:
#   ./integrate-service.sh /path/to/service/folder
#

set -e

# 색상
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# 인자 확인
if [ -z "$1" ]; then
    echo -e "${RED}오류: 서비스 경로를 지정해주세요.${NC}"
    echo "사용법: ./integrate-service.sh /path/to/service/folder"
    exit 1
fi

SERVICE_PATH="$1"

echo ""
echo -e "${CYAN}========================================"
echo "  AI Box 서비스 통합 스크립트"
echo -e "========================================${NC}"
echo ""

# 1. 서비스 경로 확인
if [ ! -d "$SERVICE_PATH" ]; then
    echo -e "${RED}오류: 서비스 경로를 찾을 수 없습니다: $SERVICE_PATH${NC}"
    exit 1
fi

# 2. 설정 파일 읽기
CONFIG_PATH="$SERVICE_PATH/service.config.json"
if [ ! -f "$CONFIG_PATH" ]; then
    echo -e "${RED}오류: service.config.json 파일을 찾을 수 없습니다.${NC}"
    exit 1
fi

# jq가 설치되어 있는지 확인
if ! command -v jq &> /dev/null; then
    echo -e "${YELLOW}jq가 설치되어 있지 않습니다. Homebrew로 설치합니다...${NC}"
    brew install jq
fi

# JSON 파싱
SERVICE_LABEL=$(jq -r '.serviceLabel' "$CONFIG_PATH")
TARGET_BASE=$(jq -r '.targetCodebase' "$CONFIG_PATH")

# Windows 경로를 Unix 경로로 변환 (필요시)
TARGET_BASE=$(echo "$TARGET_BASE" | sed 's/\\/\//g' | sed 's/C:/\/c/i')

echo -e "${YELLOW}서비스명: $SERVICE_LABEL${NC}"
echo -e "${YELLOW}대상 코드베이스: $TARGET_BASE${NC}"
echo ""

# 3. 파일 매핑에 따라 복사
echo -e "${CYAN}파일 복사 시작...${NC}"

COPY_COUNT=0

# 파일 매핑 순회
for key in $(jq -r '.fileMappings | keys[]' "$CONFIG_PATH"); do
    value=$(jq -r ".fileMappings[\"$key\"]" "$CONFIG_PATH")
    
    SOURCE_DIR="$SERVICE_PATH/$key"
    DEST_DIR="$TARGET_BASE/$value"
    
    if [ -d "$SOURCE_DIR" ]; then
        # 대상 디렉토리 생성
        mkdir -p "$DEST_DIR"
        
        # 파일 복사
        for file in "$SOURCE_DIR"/*; do
            if [ -f "$file" ]; then
                FILENAME=$(basename "$file")
                cp "$file" "$DEST_DIR/"
                echo -e "  ${GREEN}복사: $FILENAME -> $value${NC}"
                ((COPY_COUNT++))
            fi
        done
    fi
done

echo ""
echo -e "${GREEN}총 $COPY_COUNT 개 파일 복사 완료!${NC}"

# 4. 등록 작업 안내
echo ""
echo -e "${YELLOW}========================================"
echo "다음 파일들에 수동 등록이 필요합니다:"
echo -e "========================================${NC}"
echo ""

for reg in $(jq -c '.registrations[]' "$CONFIG_PATH"); do
    file=$(echo "$reg" | jq -r '.file')
    action=$(echo "$reg" | jq -r '.action')
    echo -e "  - $file"
    echo -e "    ${GRAY}작업: $action${NC}"
done

echo ""
echo -e "${CYAN}통합 완료!${NC}"
echo -e "${CYAN}AI에게 '등록 코드 추가해줘'라고 요청하세요.${NC}"
echo ""
