import { Router } from "express";
import { PRO_FUNCTION } from "../../commonVariable/common";
import { extractUserTier } from "../../queueManagement/queueHelpers";
import { SubscriptionTier } from "../../queueManagement/types";
import { generateSomething } from "../../services/AiBox/{serviceName}";
import { SERVICES } from "../../services/services";
import { toKSTISOString } from "../../utils/dateUtils";
import { createLogger } from "../../utils/logger";
import { sendErrorResponse } from "../../utils/unifiedErrorHandler";
import { updateAiBoxUsageCount } from "../../utilsForAiBox/aiBoxUsageCount";
import {
    estimateTokensFromObject,
    extractUserIdFromToken,
    logActivityError,
    logActivitySuccess,
    logApiCallEnd,
    logApiCallError,
    logApiCallStart,
} from "../../utilsForAiBox/apiLogging";

const serviceRouter: any = Router();
const toolLogger = createLogger(SERVICES.{ SERVICE_KEY }.name);

/**
 * POST /api/{service-path}/generate
 * 주요 기능 수행
 */
serviceRouter.post("/generate", async (req: any, res: any) => {
    const userToken = req.headers.authorization as string | undefined;
    const userId = extractUserIdFromToken(userToken);
    const apiPath = "/{service-path}/generate";

    logApiCallStart(userId, apiPath);

    try {
        // 1. 티어 체크 (Pro 전용 기능인 경우)
        const tier: SubscriptionTier = extractUserTier(userToken);
        if (tier === "free") {
            return res.status(403).json({
                success: false,
                error: PRO_FUNCTION,
            });
        }

        // 2. 요청 데이터 추출
        const { input1, input2 } = req.body;

        // 3. 입력 토큰 추정
        const inputTokens = estimateTokensFromObject({ input1, input2 });

        // 4. 필수 파라미터 검증
        if (!input1) {
            toolLogger.error("필수 파라미터 없음");
            return res.status(400).json({
                error: "필수 정보를 모두 입력해주세요.",
            });
        }

        // 5. 서비스 로직 호출
        const result = await generateSomething(input1, input2, userToken);

        // 6. 사용량 카운트 업데이트
        await updateAiBoxUsageCount(
            SERVICES.{ SERVICE_KEY }.id,
            toolLogger,
            userToken
        );

        // 7. 출력 토큰 추정 및 로깅
        const outputTokens = estimateTokensFromObject(result);
        const usedModel = (result as any)?.usedModel;

        logApiCallEnd(userId, apiPath, inputTokens, outputTokens, true, undefined, usedModel);

        await logActivitySuccess(
            req,
            userId,
            "{service-type}",
            "generate",
            { input1 },
            "TEXT_API_USED",
            toolLogger,
            "로그 기록 중 오류 발생",
            usedModel
        );

        // 8. res.locals 설정 (HTTP 로깅용)
        res.locals.model = usedModel;
        res.locals.inputTokens = inputTokens;
        res.locals.outputTokens = outputTokens;

        // 9. 응답 반환
        res.json({
            success: true,
            data: result,
            timestamp: toKSTISOString(new Date())!,
        });
    } catch (error: unknown) {
        const errorObj = error as any;
        const errorCode =
            errorObj?.code || errorObj?.response?.status || "UNKNOWN_ERROR";

        toolLogger.error("생성 실패:", error);
        logApiCallError(userId, apiPath, String(errorCode));

        await logActivityError(
            req,
            userId,
            "{service-type}",
            "generate",
            error,
            "생성에 실패했습니다.",
            toolLogger,
            "실패 로그 기록 중 오류 발생"
        );

        sendErrorResponse(res, error, "생성에 실패했습니다.");
    }
});

export default serviceRouter;
