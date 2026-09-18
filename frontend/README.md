# ErrorMate 프론트엔드

React + Vite. 기본 디자인이며, 검색·상세 API를 연결한 화면입니다.
이 프로젝트는 프론트엔드만 포함합니다. 기존 Spring Boot 프로젝트와 별도 폴더에서 실행하세요.

## Windows / VSCode 실행

1. ZIP을 모두 추출합니다. 발표자료 폴더 안에 덮어쓰지 마세요.
2. VSCode → 파일 → 폴더 열기 → 압축을 푼 `errormate-frontend` 폴더를 선택합니다.
3. 왼쪽 파일 목록에 `package.json`, `vite.config.js`, `src`가 보이는지 확인합니다.
4. IntelliJ에서 기존 ErrorMate Spring Boot 서버를 실행합니다. 기본 포트는 8080입니다.
5. VSCode → 터미널 → 새 터미널에서 실행합니다.

```powershell
npm.cmd ci
npm.cmd run dev
```

6. 브라우저에서 http://localhost:5173 을 엽니다.
7. 두 서버는 실행 상태로 둡니다. 종료는 터미널에서 Ctrl+C입니다.

Node.js 22.12 이상 필요. 설치한 최신 LTS를 사용하세요.
`npm.cmd`는 Windows PowerShell 실행 정책을 변경하지 않고 npm을 실행합니다.
`npm ci`는 처음 또는 의존성이 변경됐을 때만 필요합니다. 이후에는 `npm.cmd run dev`만 실행하세요.
index.html을 더블클릭하거나 Live Server로 실행하지 마세요.

## 가능한 동작

- 일부 이름 검색(기본) / 정확한 이름 검색 선택
- 검색 버튼 또는 Enter로 검색
- 빈 검색어·공백 입력 안내와 입력창 포커스
- 검색 중 표시 / 결과 개수 / 빈 결과 안내
- 결과 카드에서 상세 화면 이동
- 에러 설명·메시지 예시·원인·해결 방법·코드 예제 표시
- 예제 코드 복사 및 실패 안내
- 유사 에러 이름 클릭 → 정확한 이름 재검색(현재 백엔드가 이름만 반환하기 때문)
- 검색 결과로 돌아가기, 브라우저 뒤로/앞으로, URL 새로고침
- 백엔드 400·404의 message / description / suggestion 표시
- 네트워크 오류·서버 오류·15초 응답 지연 안내 및 재시도
- 이전 요청 취소 처리: 검색이나 페이지가 바뀌어도 늦게 온 결과가 새 화면을 덮지 않음

## 아직 작동하지 않는 기능

즐겨찾기 추가·삭제, 해결 완료 저장, 검색/해결 기록 저장·조회, 로그인.
관련 메뉴는 준비 중 화면으로 이동합니다. 저장 버튼은 disabled 상태입니다.
가짜 로그인·저장·localStorage 기록은 구현하지 않았습니다.

## 연결한 API

| 기능 | GET 요청 |
|---|---|
| 일부 이름 검색 | /errors/search/partial?keyword=Null |
| 정확한 이름 검색 | /errors/search?name=NullPointerException |
| 상세 | /errors/{id} |

목록 응답: id, name, language, type, category, messagePattern, description.
상세 응답: 위 필드 + causes: 문자열 배열, solutions: 문자열 배열,
codeExamples: {badCode, goodCode, explanation} 배열, similarErrors: 문자열 배열.
오류 응답: status, message, description, suggestion.
이 계약은 이 대화에서 확인한 백엔드 코드를 기준으로 합니다.

## 포트 / 서버 연결

Vite 개발 서버가 `/errors` 요청을 http://localhost:8080 으로 프록시합니다.
개발 시 Spring CORS 설정을 바꾸지 않아도 됩니다.
백엔드 포트가 다르면 `.env.example`을 `.env`로 복사한 뒤 BACKEND_URL을 수정하고 프론트를 재시작하세요.
VITE_API_BASE_URL은 로컬 개발에서는 비워 두세요.
5173 포트 사용 중이면 기존 프론트 프로세스를 종료하고 재실행하세요.
검색 결과가 없으면 실제 DB에 해당 이름이 있는지 확인하세요. 프론트는 샘플 데이터를 삽입하지 않습니다.
정확한 이름 조회에서 404는 검색어에 맞는 데이터가 없다는 뜻입니다.

## 파일 역할

- src/main.jsx: 메뉴·검색·상세·준비 중 화면과 상호작용
- src/api.js: 백엔드 호출·오류 변환·타임아웃
- src/style.css: 임시 디자인, 반응형 배치
- vite.config.js: 개발 서버와 백엔드 프록시
- tests/api.test.mjs: API 요청/응답 처리 테스트

## 검증

```powershell
npm.cmd test
npm.cmd run build
```

제작 환경에서 API 처리 테스트 7개와 production build 통과.
테스트는 모의 응답 기반이며 실제 사용자 PC의 Spring Boot/MySQL에는 연결하지 않았습니다.
자동 브라우저 테스트는 실행 환경에 브라우저가 없어 수행하지 못했습니다.
실제 확인: 빈 검색 → 일부 검색 → 상세 클릭 → 코드 복사 → 유사 에러 검색 → 뒤로 가기 → 준비 중 메뉴.

## 나중에 배포할 때

`npm.cmd run build` 결과는 dist 폴더에 만들어집니다.
Vite 개발 프록시는 배포 결과물에는 포함되지 않습니다.
- 같은 도메인: 정적 파일을 서비스하고 `/errors`를 Spring Boot로 전달하도록 운영 서버 설정.
- 별도 도메인: 빌드 전에 VITE_API_BASE_URL에 실제 백엔드 HTTPS 주소 설정, Spring에 프론트 도메인 CORS 허용 필요.
두 경우 모두 DB 비밀번호 등 비밀값을 프론트 환경변수에 넣지 마세요.
화면 이동은 hash URL을 사용하므로 기본 정적 호스팅에서도 상세 화면 새로고침이 가능합니다.
지금은 로컬 실행용 준비이며 배포·GitHub push는 수행하지 않았습니다.

참고: https://vite.dev/guide/ / https://vite.dev/config/server-options.html
