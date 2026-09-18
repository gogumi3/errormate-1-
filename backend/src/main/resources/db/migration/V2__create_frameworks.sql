-- frameworks가 두번째인 이유 : languages > frameworks > errors 순으로 참조 하기 때문
CREATE TABLE frameworks (
    framework_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    language_id BIGINT,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_framework_language
        FOREIGN KEY (language_id)
        REFERENCES languages(language_id)
);

CREATE TABLE errors (
    error_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    language_id BIGINT NOT NULL,
    framework_id BIGINT,
    -- 자바의 예외 같은 경우에는 프레임워크에 null 이 허용가능
    -- 예외나 에러는 어떤 언어에서 나온건지 알아야하기 때문에 null 불가능
    name VARCHAR(150) NOT NULL,
    type VARCHAR(100),
    category VARCHAR(100),
    -- type 과 category 차이점
        -- type 은 에러의 종류
        -- ex) Exception , Error , Warning 등등
        -- category 주제 분류
        -- ex) null, database , security
        -- 전체 예시 : NullPointException    , SQLException
        -- type : Exception                 , Exception
        -- category : Null                  , Database
        -- 모든 데이터가 type 과 category를 가지고 있지 않기 때문에 둘다 null 허용
    message_pattern VARCHAR(500),
    -- 사용자가 특정 에러가 아닌 에러문구를 통째로 붙여넣기 했을때 에러를 찾게 해주는 컬럼
        -- ex) java.lang.NullPointerException: Cannot invoke "String.length()" because "name" is null
        -- 라고 입력시 name = NullPointerException
        --           message_pattern = java.lang.NullPointerException 식으로 error 테이블에 저장
        -- 메세지 안에서 특정 단어 보고 해당 에러 찾기
    description TEXT,
    -- 사용자가 에러를 검색했을때 이 에러가 무엇인지에 대한 기본 설명
    -- 추후에 왜 발생했는지 , 어떻게 해결하는지 , 잘못된 코드 / 올바른 코드는 무엇인지
    -- 따로 테이블로 분류할것이기 때문에 이 에러에 대한 기본 설명 컬럼
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    -- 관리자가 설명 내용을 수정하게 되면 수정시간을 바꿔서 저장해주는 컬럼
    CONSTRAINT fk_error_language FOREIGN KEY (language_id) REFERENCES languages(language_id),
    CONSTRAINT fk_error_framework FOREIGN KEY (framework_id) REFERENCES frameworks(framework_id)
);

-- 에러가 왜 발생했는가? 에 대한 테이블
-- 에러,예외 발생시 원인이 여러 개 있을 수 있기 때문에 원인 하나당 한 행으로 저장
CREATE TABLE error_causes (
    cause_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    -- 원인 데이터 자체 번호
    error_id BIGINT NOT NULL,
    -- 어떤 에러의 원인인지
    cause_text TEXT NOT NULL,
    -- 실제 원인 설명
    CONSTRAINT fk_error_cause_error FOREIGN KEY (error_id) REFERENCES errors(error_id)
);

-- 에러를 어떻게 해결해야하는지 에 대한 테이블
-- 해결 방법도 여러 개 있을 수 있기 때문에 한 행으로 저장
CREATE TABLE solutions (
    solution_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    error_id BIGINT NOT NULL,
    solution_text TEXT NOT NULL,

    CONSTRAINT fk_solution_error FOREIGN KEY (error_id) REFERENCES errors(error_id)
);

-- 잘못된 코드를 올바르게 고쳐주고 왜 이렇게 고쳤는지 설명 해주는 테이블
CREATE TABLE code_examples (
   example_id BIGINT AUTO_INCREMENT PRIMARY KEY,
   error_id BIGINT NOT NULL,
   bad_code TEXT,
   good_code TEXT,
   explanation TEXT,
   -- 모든 코드가 코드 예제를 갖는건 아니기 때문에 null 허용

   CONSTRAINT fk_example_error FOREIGN KEY (error_id) REFERENCES errors(error_id)
);

-- 비슷한 에러는 어떤 에러들이 있는가
CREATE TABLE similar_errors (
    similar_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    error_id BIGINT NOT NULL,
    similar_error_id BIGINT NOT NULL,
    -- 이 에러와 비슷하다고 연결할 다른 에러

    CONSTRAINT fk_similar_error FOREIGN KEY (error_id) REFERENCES errors(error_id),
    -- 기준이 되는 에러
    CONSTRAINT fk_similar_similar_error FOREIGN KEY (similar_error_id) REFERENCES errors(error_id)
    -- 위에 에러와 비슷한 에러
);

-- 회원 (로그인)
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(100) NOT NUll,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 검색 기록
CREATE TABLE search_history (
    history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    -- 누가 검색했는지
    error_id BIGINT,
    -- 검색 결과로 어떤 에러를 찾았는지 , 사용자가 없는 에러 검색시 null
    keyword VARCHAR(255) NOT NULL,
    -- 검색 기록 (어떤 글자를 쳤는지)
    searched_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_search_history_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_search_history_error FOREIGN KEY (error_id) REFERENCES errors(error_id)
);

-- 즐겨찾기
CREATE TABLE favorites (
    favorite_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    error_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_favorite_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_favorite_error FOREIGN KEY (error_id) REFERENCES errors(error_id)
);

CREATE TABLE solved_history (
    solved_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    error_id BIGINT NOT NULL,
    solved_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_solved_history_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT fk_solved_history_error FOREIGN KEY (error_id) REFERENCES errors(error_id)
);
