import { generateTextWithFallback } from "../../llmController/textGenerationWithFallback";
import { TextGenerationOptions } from "../../llmController/types";
import { PromptBuilder } from "../../prompts";
import { createLogger } from "../../utils";
import { SERVICES } from "../services";

const toolLogger = createLogger(SERVICES.{ SERVICE_KEY }.name);

// ============================================================================
// Types
// ============================================================================

export interface OutputData {
    field1: string;
    field2: string[];
}

// ============================================================================
// Schema
// ============================================================================

/**
 * 출력 스키마 (OpenAI 형식)
 */
export const outputSchema = {
    type: "object" as const,
    properties: {
        field1: {
            type: "string" as const,
            description: "필드 설명",
        },
        field2: {
            type: "array" as const,
            items: { type: "string" as const },
            description: "배열 필드 설명",
        },
    },
    required: ["field1", "field2"],
};

// ============================================================================
// Main Service Functions
// ============================================================================

/**
 * 주요 기능 수행
 */
export const generateSomething = async (
    input1: string,
    input2: string,
    userToken?: string
) => {
    try {
        const compiledPrompt = PromptBuilder.fromTemplate("{service-name}")
            .setVariable("input1", input1)
            .setVariable("input2", input2)
            .buildFullPrompt();

        const textOptions: TextGenerationOptions = {
            prompt: compiledPrompt.prompt,
            systemInstruction: compiledPrompt.systemInstruction,
            responseSchema: outputSchema,
            temperature: 0.7,
            maxOutputTokens: 4000,
        };

        const result = await generateTextWithFallback(textOptions, userToken);

        let outputData: any;

        try {
            outputData = JSON.parse(result.text);
        } catch (parseError: any) {
            toolLogger.error(`JSON 파싱 실패: ${parseError.message}`);
            throw new Error("응답 데이터 파싱에 실패했습니다.");
        }

        return {
            ...outputData,
            usedModel: (result as any)?.usedModel,
        };
    } catch (error) {
        toolLogger.error("생성 실패:", error);
        throw error;
    }
};
