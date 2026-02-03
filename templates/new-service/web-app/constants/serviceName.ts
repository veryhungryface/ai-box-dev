import { COMMON_RETRY_MESSAGE } from "../base/common";
import { ButtonToggleOptionType } from "../base/component";

// ============================================
// 상수 및 데이터
// ============================================

// 초기 폼 상태
export const DEFAULT_FORM_STATE: FormType = {
    requiredField: "",
    optionalField: "",
};

// 옵션 목록 (필요시)
export const OPTION_LIST: ButtonToggleOptionType[] = [
    { id: "option1", label: "옵션 1" },
    { id: "option2", label: "옵션 2" },
];

// ============================================
// 에러 메시지
// ============================================

export const ERROR_MESSAGES = {
    GENERATION_FAILED: `생성에 실패했습니다. ${COMMON_RETRY_MESSAGE}`,
    REVISION_FAILED: `수정에 실패했습니다. ${COMMON_RETRY_MESSAGE}`,
} as const;

// ============================================
// 타입
// ============================================

// 폼 데이터 타입
export type FormType = {
    requiredField: string;
    optionalField: string;
};

// 결과 타입
export type ResultType = {
    output1: string;
    output2: string[];
};

// API 요청 타입
export type GenerateRequestType = {
    input1: string;
    input2?: string;
};

// API 응답 타입
export type GenerateResponseType = {
    success: boolean;
    data?: ResultType;
    error?: string;
};
