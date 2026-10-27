-- =========================================================
-- ErrorMate Java 기본 에러 데이터
-- V3__seed_java_errors.sql
-- =========================================================


-- =========================================================
-- 0. Java 언어가 없으면 추가
-- =========================================================

INSERT IGNORE INTO languages (name, slug)
VALUES ('Java', 'java');



-- =========================================================
-- 1. NullPointerException
-- =========================================================

INSERT INTO errors (
    language_id,
    framework_id,
    name,
    type,
    category,
    message_pattern,
    description
)
SELECT
    language_id,
    NULL,
    'NullPointerException',
    'RuntimeException',
    'Null',
    'java.lang.NullPointerException',
    'null인 객체가 필요한 위치에서 해당 객체를 사용하려고 할 때 발생하는 런타임 예외입니다.'
FROM languages
WHERE slug = 'java'
AND NOT EXISTS (
    SELECT 1
    FROM errors
    WHERE name = 'NullPointerException'
);


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       'null인 객체의 메서드를 호출한 경우'
FROM errors
WHERE name = 'NullPointerException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '초기화되지 않은 객체의 필드에 접근한 경우'
FROM errors
WHERE name = 'NullPointerException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '메서드가 null을 반환했지만 null 여부를 확인하지 않고 사용한 경우'
FROM errors
WHERE name = 'NullPointerException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '객체를 사용하기 전에 null인지 확인합니다.'
FROM errors
WHERE name = 'NullPointerException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '객체가 생성되거나 값이 할당되는 위치를 확인합니다.'
FROM errors
WHERE name = 'NullPointerException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '메서드가 null을 반환할 가능성이 있다면 반환값을 확인한 후 사용합니다.'
FROM errors
WHERE name = 'NullPointerException';


INSERT INTO code_examples (
    error_id,
    bad_code,
    good_code,
    explanation
)
SELECT
    error_id,

    'String name = null;
System.out.println(name.length());',

    'String name = null;

if (name != null) {
    System.out.println(name.length());
}',

    'null인 객체에서 length()를 호출하면 NullPointerException이 발생합니다. 객체가 null인지 먼저 확인한 뒤 사용해야 합니다.'

FROM errors
WHERE name = 'NullPointerException';



-- =========================================================
-- 2. IllegalArgumentException
-- =========================================================

INSERT INTO errors (
    language_id,
    framework_id,
    name,
    type,
    category,
    message_pattern,
    description
)
SELECT
    language_id,
    NULL,
    'IllegalArgumentException',
    'RuntimeException',
    'Argument',
    'java.lang.IllegalArgumentException',
    '메서드에 허용되지 않거나 적절하지 않은 인수가 전달되었을 때 발생하는 런타임 예외입니다.'
FROM languages
WHERE slug = 'java'
AND NOT EXISTS (
    SELECT 1
    FROM errors
    WHERE name = 'IllegalArgumentException'
);


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '메서드가 허용하지 않는 범위의 값이 전달된 경우'
FROM errors
WHERE name = 'IllegalArgumentException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '메서드가 요구하는 조건을 만족하지 않는 인수가 전달된 경우'
FROM errors
WHERE name = 'IllegalArgumentException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '입력값 검증 없이 잘못된 값을 메서드에 전달한 경우'
FROM errors
WHERE name = 'IllegalArgumentException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '메서드가 요구하는 인수의 범위와 조건을 확인합니다.'
FROM errors
WHERE name = 'IllegalArgumentException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '메서드를 호출하기 전에 입력값을 검증합니다.'
FROM errors
WHERE name = 'IllegalArgumentException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '잘못된 인수가 전달되었을 때 사용자에게 적절한 안내를 제공하도록 예외 처리를 추가합니다.'
FROM errors
WHERE name = 'IllegalArgumentException';


INSERT INTO code_examples (
    error_id,
    bad_code,
    good_code,
    explanation
)
SELECT
    error_id,

    'int age = -10;

if (age < 0) {
    throw new IllegalArgumentException("나이는 0보다 작을 수 없습니다.");
}',

    'int age = 20;

if (age < 0) {
    throw new IllegalArgumentException("나이는 0보다 작을 수 없습니다.");
}

System.out.println(age);',

    '허용되지 않는 값이 메서드나 로직에 전달되면 IllegalArgumentException을 사용할 수 있습니다. 입력값이 유효한 범위인지 먼저 확인해야 합니다.'

FROM errors
WHERE name = 'IllegalArgumentException';



-- =========================================================
-- 3. NumberFormatException
-- =========================================================

INSERT INTO errors (
    language_id,
    framework_id,
    name,
    type,
    category,
    message_pattern,
    description
)
SELECT
    language_id,
    NULL,
    'NumberFormatException',
    'IllegalArgumentException',
    'Conversion',
    'java.lang.NumberFormatException',
    '문자열을 숫자형으로 변환하려고 했지만 문자열이 올바른 숫자 형식이 아닐 때 발생하는 예외입니다.'
FROM languages
WHERE slug = 'java'
AND NOT EXISTS (
    SELECT 1
    FROM errors
    WHERE name = 'NumberFormatException'
);


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '숫자가 아닌 문자가 포함된 문자열을 숫자로 변환한 경우'
FROM errors
WHERE name = 'NumberFormatException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '빈 문자열을 숫자로 변환하려고 한 경우'
FROM errors
WHERE name = 'NumberFormatException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '변환하려는 숫자가 해당 자료형이 표현할 수 있는 범위를 벗어난 경우'
FROM errors
WHERE name = 'NumberFormatException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '숫자로 변환하기 전에 문자열이 올바른 숫자 형식인지 확인합니다.'
FROM errors
WHERE name = 'NumberFormatException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '사용자 입력값이 비어 있는지 확인합니다.'
FROM errors
WHERE name = 'NumberFormatException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       'Integer.parseInt 등의 변환 코드를 try-catch로 처리하여 잘못된 입력에 대응합니다.'
FROM errors
WHERE name = 'NumberFormatException';


INSERT INTO code_examples (
    error_id,
    bad_code,
    good_code,
    explanation
)
SELECT
    error_id,

    'String value = "12a";
int number = Integer.parseInt(value);',

    'String value = "12a";

try {
    int number = Integer.parseInt(value);
    System.out.println(number);
} catch (NumberFormatException e) {
    System.out.println("숫자 형식이 아닙니다.");
}',

    '12a에는 숫자가 아닌 문자가 포함되어 있기 때문에 Integer.parseInt()로 변환할 수 없습니다. 변환 실패 가능성을 고려해 입력값 검증이나 예외 처리를 해야 합니다.'

FROM errors
WHERE name = 'NumberFormatException';



-- =========================================================
-- 4. IndexOutOfBoundsException
-- =========================================================

INSERT INTO errors (
    language_id,
    framework_id,
    name,
    type,
    category,
    message_pattern,
    description
)
SELECT
    language_id,
    NULL,
    'IndexOutOfBoundsException',
    'RuntimeException',
    'Index',
    'java.lang.IndexOutOfBoundsException',
    '배열, 리스트, 문자열 등에서 사용할 수 있는 인덱스 범위를 벗어난 위치에 접근하려고 할 때 발생하는 런타임 예외입니다.'
FROM languages
WHERE slug = 'java'
AND NOT EXISTS (
    SELECT 1
    FROM errors
    WHERE name = 'IndexOutOfBoundsException'
);


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '리스트의 크기보다 크거나 같은 인덱스에 접근한 경우'
FROM errors
WHERE name = 'IndexOutOfBoundsException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '음수 인덱스를 사용한 경우'
FROM errors
WHERE name = 'IndexOutOfBoundsException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '반복문 조건을 잘못 작성하여 존재하지 않는 위치까지 접근한 경우'
FROM errors
WHERE name = 'IndexOutOfBoundsException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '접근하려는 인덱스가 0 이상이고 컬렉션의 크기보다 작은지 확인합니다.'
FROM errors
WHERE name = 'IndexOutOfBoundsException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '반복문의 종료 조건에서 <= 대신 < 를 사용해야 하는 상황인지 확인합니다.'
FROM errors
WHERE name = 'IndexOutOfBoundsException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       'List의 size() 또는 배열의 length 값을 확인한 후 접근합니다.'
FROM errors
WHERE name = 'IndexOutOfBoundsException';


INSERT INTO code_examples (
    error_id,
    bad_code,
    good_code,
    explanation
)
SELECT
    error_id,

    'List<String> names = List.of("A", "B", "C");

System.out.println(names.get(3));',

    'List<String> names = List.of("A", "B", "C");

if (3 < names.size()) {
    System.out.println(names.get(3));
}',

    '요소가 3개인 리스트의 유효한 인덱스는 0, 1, 2입니다. 인덱스 3은 범위를 벗어나므로 접근 전에 size()를 확인해야 합니다.'

FROM errors
WHERE name = 'IndexOutOfBoundsException';



-- =========================================================
-- 5. ArithmeticException
-- =========================================================

INSERT INTO errors (
    language_id,
    framework_id,
    name,
    type,
    category,
    message_pattern,
    description
)
SELECT
    language_id,
    NULL,
    'ArithmeticException',
    'RuntimeException',
    'Arithmetic',
    'java.lang.ArithmeticException',
    '정수의 0으로 나누기처럼 정상적으로 수행할 수 없는 산술 연산이 발생했을 때 발생하는 런타임 예외입니다.'
FROM languages
WHERE slug = 'java'
AND NOT EXISTS (
    SELECT 1
    FROM errors
    WHERE name = 'ArithmeticException'
);


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '정수를 0으로 나누려고 한 경우'
FROM errors
WHERE name = 'ArithmeticException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '계산에 사용되는 값에 대한 검증 없이 산술 연산을 수행한 경우'
FROM errors
WHERE name = 'ArithmeticException';


INSERT INTO error_causes (error_id, cause_text)
SELECT error_id,
       '사용자 입력이나 계산 결과가 0이 될 가능성을 고려하지 않은 경우'
FROM errors
WHERE name = 'ArithmeticException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '나눗셈을 수행하기 전에 분모가 0인지 확인합니다.'
FROM errors
WHERE name = 'ArithmeticException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '사용자 입력값이나 계산 결과가 예상 범위에 있는지 검증합니다.'
FROM errors
WHERE name = 'ArithmeticException';


INSERT INTO solutions (error_id, solution_text)
SELECT error_id,
       '산술 연산 실패 가능성이 있는 경우 적절한 예외 처리를 추가합니다.'
FROM errors
WHERE name = 'ArithmeticException';


INSERT INTO code_examples (
    error_id,
    bad_code,
    good_code,
    explanation
)
SELECT
    error_id,

    'int a = 10;
int b = 0;

int result = a / b;',

    'int a = 10;
int b = 0;

if (b != 0) {
    int result = a / b;
    System.out.println(result);
} else {
    System.out.println("0으로 나눌 수 없습니다.");
}',

    'Java에서 정수를 0으로 나누면 ArithmeticException이 발생합니다. 나눗셈을 수행하기 전에 분모가 0인지 확인해야 합니다.'

FROM errors
WHERE name = 'ArithmeticException';