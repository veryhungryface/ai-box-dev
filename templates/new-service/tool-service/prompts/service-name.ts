import { COMMON_JSON_RESPONSE_INSTRUCTION } from "../../common";
import { PromptTemplate } from "../../types";

/**
 * {서비스명} 프롬프트 템플릿
 */
export const { serviceName }Template: PromptTemplate = {
    id: "{service-name}",
    name: "{서비스 한글명}",
    description: "{서비스 설명}",
    systemPrompt: `당신은 [역할 설명]입니다.

${COMMON_JSON_RESPONSE_INSTRUCTION}

[추가 지침]`,
    userPrompt: `다음 정보를 바탕으로 [작업]을 수행해주세요.

- 입력1: {{input1}}
- 입력2: {{input2}}
{{#if optionalCondition}}
- 선택사항: {{optionalValue}}
{{/if}}

결과는 반드시 지정된 JSON 스키마에 따라 반환해야 합니다.`,
    requiredVariables: ["input1", "input2"],
    defaultVariables: {
        optionalCondition: false,
        optionalValue: "",
    },
};
