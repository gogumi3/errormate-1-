-- flyaway 를 사용하기 때문에 v1 에다가 수정할 필요 없이 v2 로 넘어가서 수정 내용 작성
-- flyaway 가 알아서 연결

-- 언어 테이블 부터 만드는 이유 : errors 테이블이 언어 테이블을 참조하여 사용하기 때문
CREATE TABLE languages (
    language_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
--    사용자에게 보여지는 이름
    slug VARCHAR(50) NOT NULL UNIQUE,
--    프로그램 , 검색 조건에서 사용하기 편한 값 name 컬럼과 다름
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);