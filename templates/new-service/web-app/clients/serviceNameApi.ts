import { AxiosInstance } from "axios";
import { GenerateRequestType, GenerateResponseType } from "@/constants/AiBox/services/{serviceName}";

const PREFIX = "/api/v1";

// ============================================
// 인터페이스
// ============================================

export interface ISV { N }Api {
    generateSomething(request: GenerateRequestType): Promise<GenerateResponseType>;
}

// ============================================
// 구현
// ============================================

export class SV { N }Api implements ISV{ N }Api {
    constructor(private axios: AxiosInstance) { }

    generateSomething = (request: GenerateRequestType) => {
        return this.axios
            .request<GenerateResponseType>({
                method: "POST",
                url: `${PREFIX}/tools/{service-path}/generate`,
                data: request,
            })
            .then((response) => response.data);
    };
}
