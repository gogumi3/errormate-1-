package com.errormate.service;

import com.errormate.dto.analysis.ErrorAnalysisResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;

@Service
public class ErrorAnalysisService {

    /*
        컨트롤러가 String 형태의 에러 로그를 Service에게 넘기면
        Service가 처리하고 ErrorAnalysisResponse 형태로 결과를 돌려줌
     */

    private final RestClient restClient;
    // 다른 서버에 HTTP 요청을 보내는 도구
    // Gemini 서버에 요청을 보내기 위해 RestClient 을 하나 가짐

    @Value("${gemini.api.key}")
    private String apiKey;  // << 실제 api키가 들어오는 변수

    public ErrorAnalysisService() {
        // 이 클래스를 생성시 RestClient를 만들 수 있는 Builder도 생성 (의존성 주입)
        this.restClient = RestClient.builder()
            // 클래스가 가진 변수 , 생성자로 받은 RestClient 제작 도구
                // builder를 이용하여 RestClient룰 만든 다음 restClient 변수에 저장
                .baseUrl("https://generativelanguage.googleapis.com")
                // 기본 서버 주소
                .build();
                // Builder설정이 끝나면 RestClient 객체 생성
    }

    public ErrorAnalysisResponse analyze(String errorLog) { // 에러가 들어올 변수
        // ai 에게 보낼 질문 전체를 하나의 문자열로 만듦
        String prompt = """ 
                너는 초보 개발자를 도와주는 에러 분석 도우미야.

                아래 에러 로그를 분석해줘.

                반드시 아래 형식으로 짧고 쉽게 답해줘.

                요약: 에러가 무엇인지 한 문장
                원인: 가장 가능성 높은 원인
                해결: 초보자가 바로 따라할 수 있는 해결방법

                에러 로그:
                %s
                """.formatted(errorLog); // %s 에 errorLog를 넣음

        // JSON을 자바 코드로 만드는 방법
        // JSON {} = JAVA의 MAP
        // JSON [] = JAVA의 LIST
        // contents 는 하나의 값이 아니라 배열이기 떄문에 List
        // parts 도 배열이기 떄문에 List
        // 그 안에 또 다른 객체가 들어감
        // << String prompt가 들어감
        Map<String, Object> requestBody = Map.of(
                "contents", List.of(
                        Map.of(
                                "parts", List.of(
                                        Map.of("text", prompt)
                                )
                        )
                )
        );
        /// requestBody라는 데이터를 하나 만들 건데,
        /// contents라는 항목 안에 리스트를 만들고,
        /// 그 리스트 안에 parts라는 항목을 만들고,
        /// parts 안에 다시 리스트를 만들고,
        /// 그 안에 text라는 항목에 우리가 만든 prompt를 넣는다.

        // 이 구조로 한 이유 : 제미나이 API가 이러한 구조를 요구

        // Gemini 부분에 post 방식으로 요청을 보냄
        Map response = restClient.post()
                // 실제 경로
                .uri("/v1beta/models/gemini-3.5-flash-lite:generateContent")
                // 내 api 키로 보내는 인증 정보
                .header("x-goog-api-key", apiKey)
                // 위에 requestBody를 실제 요청 본문에 넣음
                .body(requestBody)
                // 응답 받는 부분
                .retrieve()
                // Gemini가 json 형태로 응답시 java의 map 형태로 바꿔서 받음
                .body(Map.class);
        // 실제 답변 문자열만 꺼내는 함수 호출
        String aiText = extractText(response);

        return new ErrorAnalysisResponse(
                aiText,
                "",
                ""
        );
    }

    // 응답 json 전체를 받아서 실제 text만 꺼내서 String 으로 반환하는 메서드
    private String extractText(Map response) {
        List<Map<String, Object>> candidates =
                (List<Map<String, Object>>) response.get("candidates");
        // json의 candidates 값을 꺼냄
        // candidates 는 배열이라서 List로 받음 그 리스트안에 객체가 들어있기 떄문에 Object 사용

        Map<String, Object> content =
                (Map<String, Object>) candidates.get(0).get("content");
        // 첫번째 결과 꺼내고 그 안에 content를 꺼냄 content도 객체여서 String , Object

        List<Map<String, Object>> parts =
                (List<Map<String, Object>>) content.get("parts");
        // content 안에서 parts 를 꺼냄


        return (String) parts.get(0).get("text");
        // parts.get(0)로 첫번째 parts 객체를 꺼내고 그안에 text로 실제 답변을 가져옴
        // 그 값이 문자열이기 때문에 String 형변환
    }
}
