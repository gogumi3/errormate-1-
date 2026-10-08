# ErrorMate 프론트엔드

React + Vite 기반의 기존 디자인을 유지하고, 현재 백엔드에 구현된 검색·상세 조회·AI 분석만 연결합니다. 백엔드 코드는 수정하지 않았습니다.

## 실행

Node.js 22.12 이상이 필요합니다. 저장소의 `frontend` 폴더에서 실행하세요.

```powershell
npm.cmd install
npm.cmd run dev
```

브라우저: http://localhost:5173

백엔드는 별도로 실행해야 합니다. 현재 백엔드 설정상 MySQL의 `errormate` DB와 `GEMINI_API_KEY` 환경변수가 필요합니다. API 키는 백엔드에만 설정하세요. 검색 결과는 실제 DB 등록 데이터에 따라 달라집니다.

기본 API 대상은 http://localhost:8080 입니다. 주소를 바꾸려면 `frontend/.env.local`을 만들고 다음을 입력한 후 Vite를 재시작하세요.

```dotenv
BACKEND_URL=http://localhost:8080
```

브라우저는 같은 출처의 상대 경로를 호출하고 Vite가 `/errors`, `/api/analyze`를 백엔드에 전달하므로 로컬 개발에서는 백엔드 CORS 수정이 필요하지 않습니다. `VITE_API_BASE_URL`을 설정하면 개발 프록시를 우회하므로 기본 로컬 실행에서는 설정하지 마세요.

배포 시 Vite 개발 프록시는 적용되지 않습니다. 운영 서버에서 위 경로를 백엔드로 전달하거나, `VITE_API_BASE_URL`로 별도 백엔드를 지정하고 해당 서버에서 프론트 출처에 대한 CORS를 허용해야 합니다. 백엔드 설정은 이번 작업에서 변경하지 않았습니다.

## 실제 API와 데이터 흐름

| 사용자 동작 | 호출 위치 | 요청 | 화면 표시 |
|---|---|---|---|
| 검색 버튼/Enter, 기본 부분 검색 | `main.jsx`의 submit → route effect → `api.js`의 searchErrors | `GET /errors/search/partial?keyword=검색어` | 배열의 name, language, description을 결과 카드로 표시 |
| 정확한 이름으로 검색 체크 후 검색 | 동일 | `GET /errors/search?name=검색어` | 단일 DTO를 카드 목록 형태로 표시 |
| 검색 결과의 에러 이름/상세 보기 클릭 | `main.jsx`의 detail route effect → `api.js`의 getError | `GET /errors/{id}` | 기본 정보, causes, solutions, codeExamples, similarErrors |
| AI로 분석하기 버튼 | `ErrorAnalysis.jsx`의 handleAnalyze → `api.js`의 analyzeError | `POST /api/analyze`, JSON `{ "errorLog": "입력한 로그 원문" }` | summary=에러 요약, cause=원인, solution=해결 방법 |

검색어는 앞뒤 공백을 제거하고 URL 인코딩합니다. 상세 조회는 응답의 id를 사용합니다. 분석은 공백뿐인 입력을 차단하되 유효한 로그의 공백·줄바꿈은 원문대로 전송합니다. 사용자 식별자나 인증 정보는 추가하지 않습니다.

상세 DTO의 실제 필드: id, name, language, type, category, messagePattern, description, causes(문자열 배열), solutions(문자열 배열), codeExamples(badCode/goodCode/explanation), similarErrors(이름 배열). 유사 에러는 반환된 이름으로 정확 검색합니다.

현재 ErrorAnalysisService는 AI 응답 전체를 summary에 넣고 cause와 solution은 빈 문자열로 반환합니다. 프론트는 내용을 임의로 분리하거나 추측하지 않습니다. 빈 문자열·null·누락 필드는 빈 값으로 처리하고 해당 영역에 '서버에서 반환된 내용이 없습니다.'를 표시합니다. 이것은 실제 빈 응답 안내이며 임시 mock 결과가 아닙니다.

분석 요청 중에는 '분석 중...'을 표시하고 중복 제출을 차단합니다. 실패 시 오류 안내를 표시하고 재시도가 가능하도록 버튼을 복구합니다. 탭을 떠나면 진행 중인 분석 요청을 취소합니다. 검색/상세는 15초, AI 분석은 60초 후 지연 오류를 안내합니다.

## 수정 파일

- src/api.js: 공통 GET/POST 요청 처리, 분석 API 함수, DTO 빈 필드 처리, 요청 취소 및 시간 제한.
- src/components/ErrorAnalysis.jsx: 임시 안내 제거, 실제 분석 요청 및 결과 3개 영역, 입력 검증·로딩·실패 처리.
- src/main.jsx: 정확 검색 체크박스와 URL 연동, 미구현 사용자 메뉴·페이지·버튼 제거. 기존 검색·상세 연결과 디자인 유지.
- src/style.css: 정확 검색 체크박스의 간격과 정렬만 추가.
- vite.config.js: 기존 검색 프록시에 분석 프록시 추가.
- tests/api.test.mjs: 분석 JSON 전송, 빈 필드, 빈 입력 차단, 서버 실패, 취소 테스트 추가.
- README.md: 실제 실행 조건, API 흐름과 검증 결과 정리.

## 검증 결과

- npm install 성공. 이 작업 환경에서는 기본 npm 캐시 접근 제한으로 작업 디렉터리의 별도 캐시를 지정했습니다.
- npm test: 12개 통과. 테스트의 fetch 대체 응답은 테스트 파일 내부에만 있으며 제품 코드에는 mock 데이터가 없습니다.
- npm run build 성공.
- npm run dev 정상 기동.
- 브라우저에서 두 탭, 빈 검색/분석 입력 검증, 정확/부분 검색 선택, 백엔드 미접속 오류 표시와 분석 버튼 복구 확인.
- Vite 로그에서 `/errors/search?name=NullPointerException`, `/errors/search/partial?keyword=NullPointerException`, `/api/analyze` 요청 전달 확인.
- 이 환경의 백엔드 8080 및 DB 3306이 실행되지 않아 ECONNREFUSED가 발생했습니다. 실제 DB 결과 → 상세 클릭, Gemini 성공 응답의 브라우저 표시는 미검증입니다. 실행 중인 백엔드를 연결한 뒤 확인해야 합니다.
- 기존 의존성의 npm audit 결과 source-map-js 간접 의존성에서 high 1건이 보고되었습니다. 이번 API 연동 범위에서는 패키지 버전과 lockfile을 변경하지 않았습니다.

## 구현하지 않은 기능

로그인, 회원가입, JWT, 즐겨찾기, 검색 기록, 해결 기록, 사용자 기능, 마이페이지, 관리자 페이지는 구현하지 않았습니다. 관련 기존 임시 화면·버튼도 제거했습니다. 새 백엔드 API, DTO/경로 변경, AI 응답 파싱 기능도 추가하지 않았습니다.
