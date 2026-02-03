"use client";

import { useMemo, useState } from "react";
import ToolApiClient from "@/clients/ToolApiClient";
import {
    COMMON_ERROR_MESSAGES,
    COMMON_SUCCESS_MESSAGES,
    MAX_TITLE_LENGTH,
} from "@/constants/AiBox/base/common";
import { SECTION_TITLE } from "@/constants/AiBox/base/style";
import {
    DEFAULT_FORM_STATE,
    ERROR_MESSAGES,
    FormType,
    ResultType,
} from "@/constants/AiBox/services/{serviceName}";
import {
    showErrorToast,
    showSuccessToast,
} from "@/utils/AiBox/toastUtils";

import { useLoadingState } from "@/hooks/AiBox/useLoadingState";
import { useServiceInfo } from "@/hooks/AiBox/useServiceInfo";
import LeftFooterButton from "@/components/AiBox/common/LeftFooterButton";
import PageLayout from "@/components/PageLayout";
import SplitLayout from "@/components/SplitLayout";
import { cn } from "@/components/ui/utils";

export default function { ServiceName } () {
    // 상태 관리
    const [form, setForm] = useState<FormType>(DEFAULT_FORM_STATE);
    const [result, setResult] = useState<ResultType | null>(null);
    const { isLoading, setIsLoading } = useLoadingState();
    const {
        serviceName,
        serviceDescription,
        isLoading: isLoadingServiceInfo,
    } = useServiceInfo();

    // 폼 유효성 검사
    const isFormValid = useMemo(
        () => form.requiredField.trim() !== "",
        [form.requiredField]
    );

    // 폼 필드 업데이트 핸들러
    const updateForm = (
        field: keyof FormType,
        value: FormType[keyof FormType]
    ) => {
        setForm((prev) => ({
            ...prev,
            [field]: value,
        }));
    };

    // 초기화 핸들러
    const handleReset = () => {
        setForm(DEFAULT_FORM_STATE);
        setResult(null);
    };

    // 생성 핸들러
    const handleGenerate = async () => {
        if (isLoading) return;

        setIsLoading(true);

        try {
            const toolApi = ToolApiClient.getInstance();
            const response = await toolApi.sv{ N }.generateSomething({
                // 요청 데이터
            });

            if (!response.success || !response.data) {
                throw new Error(ERROR_MESSAGES.GENERATION_FAILED);
            }

            setResult(response.data);
            showSuccessToast("결과가 생성되었습니다.");
        } catch (error: any) {
            showErrorToast(error, {
                defaultErrorMessage: ERROR_MESSAGES.GENERATION_FAILED,
            });
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <PageLayout className="max-w-[1192px] justify-start">
            <SplitLayout
                leftTitle={serviceName}
                leftDescription={serviceDescription}
                isLoadingServiceInfo={isLoadingServiceInfo}
                rightTitle="결과 확인"
                leftPanel={
                    <div className="flex flex-col gap-6">
                        {/* 입력 섹션 */}
                        <div>
                            <h3 className={SECTION_TITLE}>입력 항목</h3>
                            <textarea
                                className="w-full min-h-[120px] p-3 border border-[#EFEFEF] rounded-[8px] resize-none"
                                placeholder="내용을 입력하세요..."
                                value={form.requiredField}
                                onChange={(e) => updateForm("requiredField", e.target.value)}
                                maxLength={MAX_TITLE_LENGTH}
                            />
                        </div>
                    </div>
                }
                leftFooter={
                    <LeftFooterButton
                        resetLabel="초기화"
                        submitLabel="생성"
                        onReset={handleReset}
                        onSubmit={handleGenerate}
                        isLoading={isLoading}
                        isFormValid={isFormValid}
                    />
                }
                rightPanel={
                    <div className="flex items-center justify-center h-full">
                        {result ? (
                            <div className="p-4">{/* 결과 표시 */}</div>
                        ) : (
                            <p className="text-[#767676]">
                                좌측에서 정보를 입력하고 생성 버튼을 눌러주세요.
                            </p>
                        )}
                    </div>
                }
            />
        </PageLayout>
    );
}
