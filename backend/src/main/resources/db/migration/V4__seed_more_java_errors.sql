-- =========================================================
-- ErrorMate Java 추가 에러 데이터
-- V4__seed_more_java_errors.sql
-- =========================================================

INSERT IGNORE INTO languages (name, slug)
VALUES ('Java', 'java');


-- =========================================================
-- 1. errors 테이블
-- 25개를 한 번에 추가
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
    l.language_id,
    NULL,
    x.name,
    x.type,
    x.category,
    x.message_pattern,
    x.description
FROM languages l
JOIN (
    SELECT
        'ArrayIndexOutOfBoundsException' AS name,
        'RuntimeException' AS type,
        'Index' AS category,
        'java.lang.ArrayIndexOutOfBoundsException' AS message_pattern,
        '배열의 유효한 인덱스 범위를 벗어난 위치에 접근했을 때 발생하는 예외입니다.' AS description

    UNION ALL SELECT
        'StringIndexOutOfBoundsException',
        'RuntimeException',
        'Index',
        'java.lang.StringIndexOutOfBoundsException',
        '문자열의 유효한 인덱스 범위를 벗어난 위치에 접근했을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'ClassCastException',
        'RuntimeException',
        'Type',
        'java.lang.ClassCastException',
        '객체를 호환되지 않는 타입으로 형변환하려고 할 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'IllegalStateException',
        'RuntimeException',
        'State',
        'java.lang.IllegalStateException',
        '객체나 프로그램의 현재 상태에서 요청한 작업을 수행할 수 없을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'UnsupportedOperationException',
        'RuntimeException',
        'Operation',
        'java.lang.UnsupportedOperationException',
        '현재 객체가 지원하지 않는 연산을 실행하려고 할 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'NoSuchElementException',
        'RuntimeException',
        'Collection',
        'java.util.NoSuchElementException',
        '요청한 요소가 존재하지 않는데 요소를 가져오려고 할 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'ConcurrentModificationException',
        'RuntimeException',
        'Collection',
        'java.util.ConcurrentModificationException',
        '컬렉션을 순회하는 도중 허용되지 않는 방식으로 컬렉션 구조를 변경했을 때 주로 발생하는 예외입니다.'

    UNION ALL SELECT
        'SecurityException',
        'RuntimeException',
        'Security',
        'java.lang.SecurityException',
        '보안 정책이나 권한 문제로 요청한 작업이 허용되지 않을 때 발생할 수 있는 예외입니다.'

    UNION ALL SELECT
        'NegativeArraySizeException',
        'RuntimeException',
        'Array',
        'java.lang.NegativeArraySizeException',
        '음수 크기로 배열을 생성하려고 할 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'EnumConstantNotPresentException',
        'RuntimeException',
        'Enum',
        'java.lang.EnumConstantNotPresentException',
        '프로그램이 존재한다고 예상한 enum 상수가 실제로 존재하지 않을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'ClassNotFoundException',
        'Exception',
        'ClassLoading',
        'java.lang.ClassNotFoundException',
        '문자열로 지정한 클래스를 JVM이 찾거나 로딩하지 못했을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'NoSuchMethodException',
        'ReflectiveOperationException',
        'Reflection',
        'java.lang.NoSuchMethodException',
        '리플렉션을 통해 찾으려는 메서드가 클래스에 존재하지 않을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'NoSuchFieldException',
        'ReflectiveOperationException',
        'Reflection',
        'java.lang.NoSuchFieldException',
        '리플렉션을 통해 찾으려는 필드가 클래스에 존재하지 않을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'InstantiationException',
        'ReflectiveOperationException',
        'Reflection',
        'java.lang.InstantiationException',
        '리플렉션을 사용해 인스턴스를 생성하려 했지만 해당 클래스를 생성할 수 없을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'IllegalAccessException',
        'ReflectiveOperationException',
        'Reflection',
        'java.lang.IllegalAccessException',
        '접근 권한이 없는 클래스, 메서드 또는 필드에 리플렉션으로 접근하려 할 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'InterruptedException',
        'Exception',
        'Thread',
        'java.lang.InterruptedException',
        '대기 또는 실행 중인 스레드가 다른 스레드에 의해 인터럽트되었을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'IOException',
        'Exception',
        'IO',
        'java.io.IOException',
        '파일, 네트워크, 스트림 등 입출력 작업을 처리하는 과정에서 문제가 발생했을 때 사용하는 대표적인 예외입니다.'

    UNION ALL SELECT
        'FileNotFoundException',
        'IOException',
        'File',
        'java.io.FileNotFoundException',
        '열려고 하는 파일을 찾을 수 없거나 파일에 접근할 수 없을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'EOFException',
        'IOException',
        'IO',
        'java.io.EOFException',
        '입력 스트림에서 데이터를 더 읽으려고 했지만 예상보다 먼저 데이터의 끝에 도달했을 때 발생하는 예외입니다.'

    UNION ALL SELECT
        'SQLException',
        'Exception',
        'Database',
        'java.sql.SQLException',
        'JDBC를 이용한 데이터베이스 접근이나 SQL 처리 과정에서 문제가 발생했을 때 사용하는 예외입니다.'

    UNION ALL SELECT
        'StackOverflowError',
        'Error',
        'Stack',
        'java.lang.StackOverflowError',
        '메서드 호출이 지나치게 깊어져 JVM 스택 공간을 초과했을 때 발생하는 에러입니다.'

    UNION ALL SELECT
        'OutOfMemoryError',
        'Error',
        'Memory',
        'java.lang.OutOfMemoryError',
        'JVM이 객체를 생성하는 데 필요한 메모리를 더 이상 확보할 수 없을 때 발생하는 에러입니다.'

    UNION ALL SELECT
        'AssertionError',
        'Error',
        'Assertion',
        'java.lang.AssertionError',
        'assert 문으로 검사한 조건이 거짓일 때 발생하는 에러입니다.'

    UNION ALL SELECT
        'ExceptionInInitializerError',
        'Error',
        'Initialization',
        'java.lang.ExceptionInInitializerError',
        '클래스의 static 초기화 과정에서 예외가 발생했을 때 발생하는 에러입니다.'

    UNION ALL SELECT
        'NoClassDefFoundError',
        'Error',
        'ClassLoading',
        'java.lang.NoClassDefFoundError',
        '컴파일 시 존재했던 클래스를 실행 시점에 JVM이 찾거나 초기화하지 못했을 때 발생하는 에러입니다.'
) x ON 1 = 1

LEFT JOIN errors e
    ON e.name = x.name

WHERE l.slug = 'java'
AND e.error_id IS NULL;



-- =========================================================
-- 2. 발생 원인
-- =========================================================

INSERT INTO error_causes (error_id, cause_text)
SELECT e.error_id, x.cause_text
FROM errors e
JOIN (

    SELECT 'ArrayIndexOutOfBoundsException' AS name,
           '배열의 마지막 인덱스보다 큰 번호로 접근한 경우' AS cause_text
    UNION ALL SELECT 'ArrayIndexOutOfBoundsException',
           '반복문의 종료 조건을 잘못 작성한 경우'

    UNION ALL SELECT 'StringIndexOutOfBoundsException',
           '문자열 길이보다 크거나 같은 인덱스로 charAt() 등을 호출한 경우'
    UNION ALL SELECT 'StringIndexOutOfBoundsException',
           'substring()의 시작 또는 종료 위치를 잘못 지정한 경우'

    UNION ALL SELECT 'ClassCastException',
           '실제 객체 타입과 관계없는 클래스 타입으로 강제 형변환한 경우'
    UNION ALL SELECT 'ClassCastException',
           'Object 타입 객체의 실제 타입을 확인하지 않고 캐스팅한 경우'

    UNION ALL SELECT 'IllegalStateException',
           '객체가 특정 작업을 수행할 준비가 되지 않은 상태인 경우'
    UNION ALL SELECT 'IllegalStateException',
           '이미 종료되거나 변경된 객체에서 특정 메서드를 다시 호출한 경우'

    UNION ALL SELECT 'UnsupportedOperationException',
           '수정이 불가능한 컬렉션에서 add(), remove() 같은 작업을 수행한 경우'
    UNION ALL SELECT 'UnsupportedOperationException',
           '구현 클래스가 지원하지 않는 메서드를 호출한 경우'

    UNION ALL SELECT 'NoSuchElementException',
           '비어 있는 Optional에서 get()을 호출한 경우'
    UNION ALL SELECT 'NoSuchElementException',
           'Iterator에 다음 요소가 없는데 next()를 호출한 경우'

    UNION ALL SELECT 'ConcurrentModificationException',
           'for-each 반복 중 컬렉션에서 직접 요소를 삭제한 경우'
    UNION ALL SELECT 'ConcurrentModificationException',
           'Iterator 사용 중 컬렉션의 구조를 외부에서 변경한 경우'

    UNION ALL SELECT 'SecurityException',
           '현재 실행 환경에서 요청한 작업의 권한이 부족한 경우'
    UNION ALL SELECT 'SecurityException',
           '보안 정책에 의해 특정 시스템 자원에 대한 접근이 차단된 경우'

    UNION ALL SELECT 'NegativeArraySizeException',
           '배열 생성 크기로 음수 값이 전달된 경우'
    UNION ALL SELECT 'NegativeArraySizeException',
           '배열 크기를 계산하는 과정에서 결과가 음수가 된 경우'

    UNION ALL SELECT 'EnumConstantNotPresentException',
           '존재하지 않는 enum 상수를 프로그램이 참조하려고 한 경우'
    UNION ALL SELECT 'EnumConstantNotPresentException',
           '라이브러리 버전 변경으로 기존 enum 값이 제거된 경우'

    UNION ALL SELECT 'ClassNotFoundException',
           'Class.forName()에 잘못된 클래스 이름을 전달한 경우'
    UNION ALL SELECT 'ClassNotFoundException',
           '필요한 라이브러리가 classpath에 포함되지 않은 경우'

    UNION ALL SELECT 'NoSuchMethodException',
           '리플렉션에서 잘못된 메서드 이름을 검색한 경우'
    UNION ALL SELECT 'NoSuchMethodException',
           '메서드의 파라미터 타입을 잘못 지정한 경우'

    UNION ALL SELECT 'NoSuchFieldException',
           '리플렉션에서 존재하지 않는 필드 이름을 검색한 경우'
    UNION ALL SELECT 'NoSuchFieldException',
           '상속 구조나 접근 대상 클래스를 잘못 지정한 경우'

    UNION ALL SELECT 'InstantiationException',
           '추상 클래스나 직접 생성할 수 없는 클래스를 인스턴스화하려 한 경우'
    UNION ALL SELECT 'InstantiationException',
           '리플렉션으로 객체를 생성하는 과정에서 클래스 조건이 맞지 않은 경우'

    UNION ALL SELECT 'IllegalAccessException',
           'private 멤버에 적절한 접근 설정 없이 리플렉션으로 접근한 경우'
    UNION ALL SELECT 'IllegalAccessException',
           '접근 제한 때문에 생성자 또는 메서드를 실행할 수 없는 경우'

    UNION ALL SELECT 'InterruptedException',
           'sleep() 중인 스레드에 interrupt()가 호출된 경우'
    UNION ALL SELECT 'InterruptedException',
           'wait() 또는 join() 중인 스레드가 인터럽트된 경우'

    UNION ALL SELECT 'IOException',
           '파일이나 네트워크 스트림 처리 중 입출력 문제가 발생한 경우'
    UNION ALL SELECT 'IOException',
           '스트림이 닫혔거나 연결 상태가 올바르지 않은 경우'

    UNION ALL SELECT 'FileNotFoundException',
           '지정한 경로에 파일이 존재하지 않는 경우'
    UNION ALL SELECT 'FileNotFoundException',
           '경로가 잘못되었거나 파일 접근 권한이 없는 경우'

    UNION ALL SELECT 'EOFException',
           '예상한 데이터보다 실제 파일이나 스트림의 데이터가 짧은 경우'
    UNION ALL SELECT 'EOFException',
           'DataInputStream에서 읽을 데이터가 더 이상 없는 경우'

    UNION ALL SELECT 'SQLException',
           'SQL 문법이 잘못되었거나 존재하지 않는 테이블 또는 컬럼을 사용한 경우'
    UNION ALL SELECT 'SQLException',
           '데이터베이스 연결 또는 제약조건 처리 과정에서 문제가 발생한 경우'

    UNION ALL SELECT 'StackOverflowError',
           '종료 조건이 없는 재귀 호출이 계속 실행된 경우'
    UNION ALL SELECT 'StackOverflowError',
           '메서드 호출 깊이가 지나치게 커진 경우'

    UNION ALL SELECT 'OutOfMemoryError',
           '너무 많은 객체를 계속 생성하여 힙 메모리를 모두 사용한 경우'
    UNION ALL SELECT 'OutOfMemoryError',
           '객체 참조가 계속 유지되어 가비지 컬렉션이 메모리를 회수하지 못한 경우'

    UNION ALL SELECT 'AssertionError',
           'assert 문에 지정한 조건이 false가 된 경우'
    UNION ALL SELECT 'AssertionError',
           '프로그램 내부 상태가 개발자가 예상한 조건과 달라진 경우'

    UNION ALL SELECT 'ExceptionInInitializerError',
           'static 필드 초기화 코드에서 예외가 발생한 경우'
    UNION ALL SELECT 'ExceptionInInitializerError',
           'static 초기화 블록에서 런타임 예외가 발생한 경우'

    UNION ALL SELECT 'NoClassDefFoundError',
           '실행 시 필요한 클래스 파일이 classpath에서 사라진 경우'
    UNION ALL SELECT 'NoClassDefFoundError',
           '클래스의 초기화가 이전에 실패하여 JVM이 해당 클래스를 사용할 수 없는 경우'

) x ON e.name = x.name;



-- =========================================================
-- 3. 해결 방법
-- =========================================================

INSERT INTO solutions (error_id, solution_text)
SELECT e.error_id, x.solution_text
FROM errors e
JOIN (

    SELECT 'ArrayIndexOutOfBoundsException' AS name,
           '배열에 접근하기 전에 인덱스가 0 이상이고 length보다 작은지 확인합니다.' AS solution_text
    UNION ALL SELECT 'ArrayIndexOutOfBoundsException',
           '반복문에서는 일반적으로 i < array.length 조건을 사용합니다.'

    UNION ALL SELECT 'StringIndexOutOfBoundsException',
           '문자열 인덱스를 사용하기 전에 length()를 확인합니다.'
    UNION ALL SELECT 'StringIndexOutOfBoundsException',
           'substring()의 시작과 종료 위치가 문자열 범위 안에 있는지 확인합니다.'

    UNION ALL SELECT 'ClassCastException',
           '형변환하기 전에 instanceof를 이용해 실제 타입을 확인합니다.'
    UNION ALL SELECT 'ClassCastException',
           '불필요한 Object 타입 사용을 줄이고 제네릭을 활용합니다.'

    UNION ALL SELECT 'IllegalStateException',
           '메서드를 호출하기 전에 객체의 현재 상태가 올바른지 확인합니다.'
    UNION ALL SELECT 'IllegalStateException',
           '객체의 생성, 사용, 종료 순서를 점검합니다.'

    UNION ALL SELECT 'UnsupportedOperationException',
           '현재 컬렉션이 수정 가능한 컬렉션인지 확인합니다.'
    UNION ALL SELECT 'UnsupportedOperationException',
           '필요하다면 수정 가능한 ArrayList 등의 새 컬렉션으로 복사합니다.'

    UNION ALL SELECT 'NoSuchElementException',
           'Optional은 isPresent() 또는 orElse() 등을 이용해 안전하게 처리합니다.'
    UNION ALL SELECT 'NoSuchElementException',
           'Iterator.next() 전에 hasNext()를 확인합니다.'

    UNION ALL SELECT 'ConcurrentModificationException',
           '반복 중 삭제가 필요하다면 Iterator.remove()를 사용합니다.'
    UNION ALL SELECT 'ConcurrentModificationException',
           '컬렉션 순회 도중 원본 컬렉션의 구조를 직접 변경하지 않습니다.'

    UNION ALL SELECT 'SecurityException',
           '필요한 권한과 실행 환경의 보안 설정을 확인합니다.'
    UNION ALL SELECT 'SecurityException',
           '권한이 필요한 기능은 적절한 API와 접근 범위 안에서 실행합니다.'

    UNION ALL SELECT 'NegativeArraySizeException',
           '배열 생성 전 크기가 0 이상인지 검사합니다.'
    UNION ALL SELECT 'NegativeArraySizeException',
           '배열 크기를 계산하는 수식과 사용자 입력값을 확인합니다.'

    UNION ALL SELECT 'EnumConstantNotPresentException',
           '사용 중인 enum 정의와 라이브러리 버전을 확인합니다.'
    UNION ALL SELECT 'EnumConstantNotPresentException',
           '문자열을 enum으로 변환할 때 존재하는 값인지 먼저 검사합니다.'

    UNION ALL SELECT 'ClassNotFoundException',
           '클래스 이름의 패키지 경로가 정확한지 확인합니다.'
    UNION ALL SELECT 'ClassNotFoundException',
           '필요한 라이브러리가 Gradle 또는 classpath에 포함되어 있는지 확인합니다.'

    UNION ALL SELECT 'NoSuchMethodException',
           '실제 클래스에 존재하는 메서드 이름과 파라미터 타입을 확인합니다.'
    UNION ALL SELECT 'NoSuchMethodException',
           '리플렉션 호출 대상 클래스가 올바른지 확인합니다.'

    UNION ALL SELECT 'NoSuchFieldException',
           '실제 클래스의 필드 이름을 확인합니다.'
    UNION ALL SELECT 'NoSuchFieldException',
           'getField()과 getDeclaredField()의 차이를 확인합니다.'

    UNION ALL SELECT 'InstantiationException',
           '추상 클래스나 인터페이스를 직접 생성하려고 하는지 확인합니다.'
    UNION ALL SELECT 'InstantiationException',
           '실제로 생성 가능한 구현 클래스를 사용합니다.'

    UNION ALL SELECT 'IllegalAccessException',
           '멤버의 접근 제한자를 확인합니다.'
    UNION ALL SELECT 'IllegalAccessException',
           '리플렉션 사용 시 접근 가능 여부와 설계를 다시 확인합니다.'

    UNION ALL SELECT 'InterruptedException',
           'InterruptedException을 catch한 뒤 필요한 경우 인터럽트 상태를 복원합니다.'
    UNION ALL SELECT 'InterruptedException',
           '스레드 종료 및 인터럽트 처리 흐름을 확인합니다.'

    UNION ALL SELECT 'IOException',
           '입출력 대상의 경로와 연결 상태를 확인합니다.'
    UNION ALL SELECT 'IOException',
           'try-with-resources를 사용하여 스트림을 안전하게 닫습니다.'

    UNION ALL SELECT 'FileNotFoundException',
           '파일 경로가 정확한지 확인합니다.'
    UNION ALL SELECT 'FileNotFoundException',
           '파일 존재 여부와 읽기 권한을 확인합니다.'

    UNION ALL SELECT 'EOFException',
           '읽으려는 데이터 개수와 실제 데이터 크기가 일치하는지 확인합니다.'
    UNION ALL SELECT 'EOFException',
           '스트림의 끝을 고려하도록 읽기 로직을 수정합니다.'

    UNION ALL SELECT 'SQLException',
           '실행한 SQL과 테이블 및 컬럼 이름을 확인합니다.'
    UNION ALL SELECT 'SQLException',
           '데이터베이스 연결 정보와 제약조건 위반 여부를 확인합니다.'

    UNION ALL SELECT 'StackOverflowError',
           '재귀 함수에 반드시 정상적으로 종료되는 조건을 추가합니다.'
    UNION ALL SELECT 'StackOverflowError',
           '지나치게 깊은 재귀는 반복문 방식으로 변경하는 것을 고려합니다.'

    UNION ALL SELECT 'OutOfMemoryError',
           '불필요한 객체 생성과 장시간 유지되는 객체 참조를 점검합니다.'
    UNION ALL SELECT 'OutOfMemoryError',
           '메모리 사용량을 분석하고 필요한 경우 JVM 힙 설정을 검토합니다.'

    UNION ALL SELECT 'AssertionError',
           'assert 조건이 실제 프로그램 상태와 맞는지 확인합니다.'
    UNION ALL SELECT 'AssertionError',
           '일반적인 사용자 입력 검증을 assert에 의존하지 않습니다.'

    UNION ALL SELECT 'ExceptionInInitializerError',
           'static 필드와 static 초기화 블록 내부 코드를 확인합니다.'
    UNION ALL SELECT 'ExceptionInInitializerError',
           '에러의 원인이 된 내부 예외를 확인합니다.'

    UNION ALL SELECT 'NoClassDefFoundError',
           '빌드 결과에 필요한 클래스와 라이브러리가 포함되었는지 확인합니다.'
    UNION ALL SELECT 'NoClassDefFoundError',
           'Gradle 의존성과 실행 시 classpath를 확인합니다.'

) x ON e.name = x.name;



-- =========================================================
-- 4. 대표 코드 예제
-- 모든 에러에 억지로 예제를 넣지 않고
-- 실제로 코드로 이해하기 좋은 에러 위주로 등록
-- =========================================================


-- ArrayIndexOutOfBoundsException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'int[] numbers = {10, 20, 30};
System.out.println(numbers[3]);',

    'int[] numbers = {10, 20, 30};

if (3 < numbers.length) {
    System.out.println(numbers[3]);
}',

    '길이가 3인 배열의 인덱스는 0부터 2까지입니다. 배열 길이를 확인한 뒤 접근해야 합니다.'

FROM errors
WHERE name = 'ArrayIndexOutOfBoundsException';



-- StringIndexOutOfBoundsException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'String text = "abc";
char value = text.charAt(3);',

    'String text = "abc";

if (3 < text.length()) {
    char value = text.charAt(3);
}',

    'abc의 유효한 인덱스는 0부터 2까지입니다.'

FROM errors
WHERE name = 'StringIndexOutOfBoundsException';



-- ClassCastException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'Object value = "hello";
Integer number = (Integer) value;',

    'Object value = "hello";

if (value instanceof String text) {
    System.out.println(text);
}',

    '실제 객체는 String인데 Integer로 강제 형변환하여 예외가 발생합니다.'

FROM errors
WHERE name = 'ClassCastException';



-- UnsupportedOperationException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'List<String> names = List.of("A", "B");
names.add("C");',

    'List<String> names =
        new ArrayList<>(List.of("A", "B"));

names.add("C");',

    'List.of()로 만든 리스트는 수정할 수 없습니다. 수정이 필요하면 ArrayList 등으로 복사합니다.'

FROM errors
WHERE name = 'UnsupportedOperationException';



-- NoSuchElementException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'Optional<String> name = Optional.empty();
System.out.println(name.get());',

    'Optional<String> name = Optional.empty();

String result = name.orElse("이름 없음");
System.out.println(result);',

    '비어 있는 Optional에서 get()을 호출하면 NoSuchElementException이 발생할 수 있습니다.'

FROM errors
WHERE name = 'NoSuchElementException';



-- ConcurrentModificationException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'List<String> names =
    new ArrayList<>(List.of("A", "B", "C"));

for (String name : names) {
    if (name.equals("B")) {
        names.remove(name);
    }
}',

    'List<String> names =
    new ArrayList<>(List.of("A", "B", "C"));

Iterator<String> iterator = names.iterator();

while (iterator.hasNext()) {
    if (iterator.next().equals("B")) {
        iterator.remove();
    }
}',

    'for-each 순회 중 컬렉션 구조를 직접 변경하지 않고 Iterator의 remove()를 사용할 수 있습니다.'

FROM errors
WHERE name = 'ConcurrentModificationException';



-- NegativeArraySizeException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'int size = -5;
int[] numbers = new int[size];',

    'int size = -5;

if (size >= 0) {
    int[] numbers = new int[size];
}',

    '배열의 크기는 음수가 될 수 없습니다.'

FROM errors
WHERE name = 'NegativeArraySizeException';



-- ClassNotFoundException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'Class.forName("com.example.NotExistClass");',

    'try {
    Class.forName("com.example.User");
} catch (ClassNotFoundException e) {
    System.out.println("클래스를 찾을 수 없습니다.");
}',

    '클래스 이름과 패키지 경로가 실제 classpath에 존재하는지 확인해야 합니다.'

FROM errors
WHERE name = 'ClassNotFoundException';



-- InterruptedException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'try {
    Thread.sleep(5000);
} catch (InterruptedException e) {
}',

    'try {
    Thread.sleep(5000);
} catch (InterruptedException e) {
    Thread.currentThread().interrupt();
}',

    'InterruptedException을 무시하지 말고 필요한 경우 현재 스레드의 인터럽트 상태를 복원합니다.'

FROM errors
WHERE name = 'InterruptedException';



-- IOException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'FileReader reader = new FileReader("data.txt");
reader.read();
reader.close();',

    'try (FileReader reader = new FileReader("data.txt")) {
    reader.read();
}',

    'try-with-resources를 사용하면 입출력 스트림을 안전하게 닫을 수 있습니다.'

FROM errors
WHERE name = 'IOException';



-- FileNotFoundException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'FileInputStream input =
    new FileInputStream("not-found.txt");',

    'File file = new File("data.txt");

if (file.exists()) {
    FileInputStream input =
        new FileInputStream(file);
}',

    '파일을 열기 전에 경로와 파일 존재 여부를 확인할 수 있습니다.'

FROM errors
WHERE name = 'FileNotFoundException';



-- SQLException

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'String sql = "SELECT * FORM users";',

    'String sql = "SELECT * FROM users";

try (PreparedStatement ps =
        connection.prepareStatement(sql)) {

    ps.executeQuery();
}',

    'SQL 문법, 테이블 및 컬럼 이름과 데이터베이스 연결 상태를 확인해야 합니다.'

FROM errors
WHERE name = 'SQLException';



-- AssertionError

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'int age = -1;
assert age >= 0;',

    'int age = 20;
assert age >= 0;',

    'assert 조건이 false라면 AssertionError가 발생합니다.'

FROM errors
WHERE name = 'AssertionError';



-- ExceptionInInitializerError

INSERT INTO code_examples (
    error_id, bad_code, good_code, explanation
)
SELECT
    error_id,

    'static int value = 10 / 0;',

    'static int value = 10 / 2;',

    'static 필드 초기화 과정에서 예외가 발생하면 ExceptionInInitializerError로 이어질 수 있습니다.'

FROM errors
WHERE name = 'ExceptionInInitializerError';