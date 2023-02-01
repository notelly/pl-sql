set serveroutput on
--데이터 베이스 안에 있는 시스템 설정을 바꾸는 것
--sysout 할 수 있는것
--성공적으로 완료 되었는데 출력이 안되면 serveroutput on 한번더 실행해주기

begin
    dbms_output.put_line('hello world!');
end;
/

--pl/sql과 트랜젝션(?)이 항상 일대일로 매칭되는 것은 아니다.

-- 변수선언
-- not null은 상수가 될 수 없다. 값이 변화가 가능하다.
-- 상수는 수정이 불가능하다
declare
    v_empId constant number(15,0):= 100;
    v_deptId date;
    v_findId number(15,0) not null := v_empId;
    v_salary number(15,2) default 1000;
begin
    -- 상수는 변경 불가능 v_empId := 1000;
    v_deptId := '2023-01-23';
    v_findId := 200;
    v_salary := 1000+10;
end;
/

declare
    v_sal number(7,2) := 60000;
    v_comm number(7,2) := v_sal * .20;
    v_message varchar2(255) := 'eligible for commission';
begin
    declare
        v_sal number(7,2) := 5000;
        v_comm number(7,2) :=0;
        v_total_comp number(7,2) := v_sal + V_comm;
    begin
        v_message :='clerk not' || v_message;
        dbms_output.put_line(v_comm);
        v_comm := v_sal * .30;
    end;
    dbms_output.put_line(v_comm);
    v_message :='salesmen' || v_message;
    dbms_output.put_line(v_message);
end;
/


declare
    v_sal employees.salary%type;
    --내가 불러오려는 컬럼의 데이터타입을 그대로 쓰겠다.
begin
    select salary
    into v_sal
    from employees
    where employee_id = &eid;
    
    dbms_output.put_line('입력한 사원의 급여는 ' || v_sal || ' 입니다.');
end;
/

--오류
--no data found는 table에 값이 없을 때
--select의 변수만큼 into에 변수가 없는 경우
--나머지 하나 뭐지


begin

    update employees
    set salary = salary * 0.9
    where department_id = 20;
    
    dbms_output.put_line('연봉이 변경된 사원의 수: ' || sql%rowcount);
    --insert update delete 가 실행되었는지 확인하기 좋다.
end;
/

rollback;

-- 1. 사원번호를 입력할 경우 해당 사원의 사원 번호, 사원이름, 부서이름 출력하는 pl/sql을 작성하세요
declare
    v_empId employees.employee_id%type;
    v_name employees.last_name%type;
    v_deptName departments.department_name%type;
    --해당 컬럼의 타입을 그대로 가지고 오는 것이 가장 편하다.
    --기존 타입보다 더 크게 가지고 오는 것은 가능, 작으면 오류난다.
begin
    select e.employee_id, e.last_name, d.department_name
    into v_empId, v_name, v_deptName
    --변수는 그대로 적어도 되고 줄이려면 declare에 반드시 선언을 해주어야 한다.
    from employees e join departments d
    --using(department_id) 해도 되나봄
    on e.department_id = d.department_id
    where e.employee_id = &eid;
    
    dbms_output.put('사원번호' || v_empId);
    --sysout.print 안띄우는거
    
    dbms_output.put_line('사원번호가 ' || v_empId || '인 사원의 이름은 ' || v_name ||'이고 부서는 '|| v_deptName || '입니다.');
    --sysout.println 띄우는거
end;
/

--2. 사원번호를 입력(치환변수사용)할 경우
--사원이름, 급여, 연봉을 출력하는 pl/sql을 작성하세요

select last_name, salary, salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12)
from employees
where employee_id = 100;


declare
    v_name employees.last_name%type;
    v_salary employees.salary%type;
    v_ySalary number(15);

begin
    select last_name, salary, salary*12+(nvl(salary,0)*nvl(commission_pct,0)*12)
    into v_name, v_salary, v_ySalary
    from employees
    where employee_id = &사원번호;
    --치환변수할 때 & 뒤에 입력하는 변수의 이름을 알려주는 거임
    --원하는 거 암거나 적어도 된다. 대신 재사용 불가
    dbms_output.put_line(v_name || '의 급여는 $' || v_salary || '이고 연봉은 $' || v_ySalary || '입니다.');
    
    -- 다른 방식도 있지만 위에 사용한 방법이 이상적임
    -- 카톡 이미지 참조.
    
end;
/

--조건문
declare
    v_empId employees.employee_id%type := &사원번호;
    v_jobId employees.job_id%type;
    v_sal employees.salary%type;
begin
    select job_id
    into v_jobId
    from employees
    where employee_id = v_empId;
    --값을 가지고 오고 내가 원하는 값과 일치하는지 본 다음에 조건을 준다.
    if v_jobId like '%IT%' then
        v_sal := 10000;
    else
        v_sal := 8000;
    end if;
    --else를 붙이면 누락되는 경우는 없을 것.
    DBMS_OUTPUT.PUT_LINE('사원번호 ' || v_empId || '의 업무는 ' || v_jobId || '이고'
                        || ' 급여는 ' || v_sal || ' 로 변경될 예정입니다.');
end;
/

declare
    v_age number(10, 0) not null := &나이;
begin
    --if 문 적을 때 기준에서 정렬시키고 순차적으로 적어주어야 함.
    if v_age < 8 then -- x < 8
        dbms_output.put_line('미취학 아동입니다.');
    elsif v_age < 14 then -- 8 <= x < 14
        dbms_output.put_line('초등학생 입니다.');
    elsif v_age < 17 then -- 14 <= x < 17
        dbms_output.put_line('중학생 입니다.');    
    elsif v_age < 20 then -- 17 <= x < 20
        dbms_output.put_line('고등학생 입니다.');
    else -- 20 <= x
        dbms_output.put_line('성인입니다.');    
    end if;
    --다중조건을 주면 조건이 무엇인지 정확하게 파악하여야한다.
end;
/


--3-2 사원번호를 입력(치환변수사용)할 경우
--입사일이 2005년 이후(2005년 포함)이면 'new employee' 출력
--       2005년 이전이면 'Career employee' 출력
-- 단, dmbs_output.put_line ~ 은 한번만 사용한다.
-- 변수를 이용해서 값을 집어 넣어라.

declare
    v_hiredate employees.hire_date%type;
begin
    select hire_date
    into v_hiredate
    from employees
    where employee_id = &사원번호;
    
    if to_char(v_hiredate, 'YYYY') >= 2005 then
        dbms_output.put_line('New employee'); 
    else
        dbms_output.put_line('Career employee');
    end if;
end;
/

--교수님
declare
    v_hiredate employees.hire_date%type;
    v_message varchar(100);
    --별로 좋은건 아님.
begin
    select hire_date
    into v_hiredate
    from employees
    where employee_id = &사원번호;
    
    --2005 라고 적었을때 된건 오라클에서 타입변환을 시켜주기 때문이다.
    --원칙적으로는 '2005'를 써주는게 맞다.
    if to_char(v_hiredate, 'YYYY') >= '2005' then
       v_message  := 'New employees'; 
    else
        v_message  := 'Career employees';
    end if;
    dbms_output.put_line(v_message);
end;
/
declare
    v_hiredate employees.hire_date%type;
    v_message varchar(100);
    --별로 좋은건 아님.
begin
    select hire_date
    into v_hiredate
    from employees
    where employee_id = &사원번호;
    
    -- 버전이 높아서 앞에 했던게 가능한거임
    -- 데이터 타입을 비교할 때 TO_DATE를 사용하는 것이 가장 정확하다는 것을 알고 가야함.
    if v_hiredate >= to_date('05/12/31', 'YY/MM/DD') then
       v_message  := 'New employees'; 
    else
        v_message  := 'Career employees';
    end if;
        dbms_output.put_line(v_message);
end;
/

CREATE TABLE emp_test
as
    select *
    from employees;
--6. 사원번호를 입력할 경우 해당 사원을 삭제하는 PL/SQL을 작성하시오.
-- 단, 해당 사원이 없는 경우 "해당 사원이 없습니다."
delete from emp_test
where employee_id = &사원번호;
--변수의 값이 아예안담긴다. select가 정상적으로 감지가 안된다.
--그룹함수를 써야함.
-- 1) 그룹함수 : count()
select count(*) from emp_test where employee_id = 0;

declare
    v_empId employees.employee_id%type := &사원번호;
    v_count number(1,0);
begin
    select count(*)
    into v_count
    from employees 
    where employee_id = v_empId;
    
    if v_count = 0 then
        dbms_output.put_line('해당 사원이 없습니다.');
    else 
        delete from emp_test
        where employee_id = v_empId;
    end if;
    
end;
/

-- 2) 커서: insert update delete 일 경우
-- SQL%ROWCOUNT 하나만 쓴다. FOUND와 NOTFOUND는 크게 의미가 없다.

-- FOUND와 NOTFOUND 반환된 행이 있느냐는 메모리 상에 올라가고
-- 출력하고 하는 건 그 메모리상에 올라간걸 반환 시키는 거임
-- 즉 메모리에 결과가 있어야 할 수 있는데
-- insert update delete 결과로 반환되는 게 없기 때문에 못 쓰는 거임.

begin
    delete from emp_test
    where employee_id = &사원번호;
    
    if SQL%ROWCOUNT = 0 then
         dbms_output.put_line('해당 사원이 없습니다.');
    end if;
end;
/

-- 1부터 10까지 모든 정수의 합을 출력

-- 기본 LOOP
-- 변수가 필요하다.

declare
    v_counter number(10, 0) := 1;
    -- 1~10까지 정수를 담아줄 꺼고
    v_sum number(10,0) := 0;
    -- 우리가 실제로 필요한 것
begin
    loop 
        v_sum := v_sum + v_counter;
        v_counter := v_counter + 1;
        exit when v_counter > 10;
        -- 탈출하는 조건이기 때문에 10이상 일 때 탈출하다.
        -- exit는 순서가 상관없다. R. 기본 루프에 필수조건이 아니기 때문에 어디 있든 상관없다.
        -- exit 항상 쓴다고 생각해야한다.
    end loop;
        dbms_output.put_line(v_sum);
end;
/

-- for loop
--count가 없음 임시 변수가 있기 때문에

declare
    v_sum number(10,0) := 0;
begin
    -- in을 기준으로 왼쪽 임시변수 오른쪽 왼쪽에 선언된 변수가 가지는 범위
    -- 꼭 1..10일 필요가 없다.
    -- 대신 작은 값에서 큰 값으로 최소에서 최대로
    -- 거꾸로 하고 싶다면 in 다음에 reverse를 추가 해주면 된다.
    for i in reverse -1 .. 10 loop
        dbms_output.put_line(i);
    end loop;
end;
/

declare
    v_sum number(10,0) := 0;
begin
    for i in to_number(to_char(sysdate+10, 'dd')).. to_number(to_char(sysdate, 'dd')) loop
        dbms_output.put_line(i);
    end loop;
end;
/

declare
    v_sum number(10,0) := 0;
begin
    for i in 1..10 loop
        v_sum := v_sum + i;
    end loop;
        dbms_output.put_line(v_sum);
end;
/

--while loop
DECLARE
    v_counter number(10,0) :=1;
    v_sum number(10,0) :=0;
begin
    --반복 조건
    -- 기본조건의 exit when의 내용의 반대 내용이 while 과 loop 사이에 오면 된다.
    -- 그것을 제외하고는 내부 모양은 똑같다.
    -- 부등호 주의할 것
    while v_counter <= 10 loop
        v_sum := v_sum + v_counter;
        v_counter := v_counter + 1;
    end loop;
    dbms_output.put_line(v_sum);
end;
/

-- 345 -> 3+4+5 = 12
-- MOD() : 나머지를 구할때 사용하는 함수

--기본 LOOP
declare
    v_num number(10, 0) := &숫자;
    v_sum number(10, 0) := 0;
begin
    loop
        v_sum := v_sum + mod(v_num, 10);
        v_num := floor(v_num / 10);
        --floor = trunc 소수점 제거
        dbms_output.put_line('v_sum: ' ||v_sum|| ', v_num : ' || v_num);
        exit when v_num <= 0;
    end loop;
    dbms_output.put_line('결과 : ' || v_sum);
end;
/

declare
    v_num number(10, 0) := &숫자;
    v_sum number(10, 0) := 0;
begin
    while v_num > 0 loop
        v_sum := v_sum + mod(v_num, 10);
        v_num := trunc(v_num / 10);
    end loop;
    dbms_output.put_line('v_sum: ' ||v_sum|| ', v_num : ' || v_num);
end;
/

/*
1. 다음과 같이 출력되도록 하시오
*
**
***
****
*****
*/

declare
    v_counter number(1,0) :=1;
    v_tree varchar2(15) := '';
begin
    loop
        -- 공백에서 *가 하나씩 하나씩 붙으면서 계속 출력
        v_tree := v_tree || '*';
        dbms_output.put_line(v_tree);
        v_counter := v_counter + 1;   
        exit when v_counter > 5; 
    end loop;
end;
/

--for loop
declare
    v_tree varchar2(15) := '';
    
begin
    --for 이라고 해서 꼭 i를 쓰는 건 아니다.
    for i in 1..5 loop
    v_tree := v_tree || '*';
    dbms_output.put_line(v_tree);
    end loop;
end;
/

-- while loop
declare
    v_counter number(1,0) := 1;
    v_tree varchar2(15) := '';
begin
    while v_counter <=5 loop
        v_tree := v_tree || '*';
        v_counter := v_counter+1;
        dbms_output.put_line(v_tree);
    end loop;
end;
/

--2. 치환변수(&)를 사용하면 숫자를 입력하면 해당 구구단이 출력되도록 하시오.
--기본 loop
declare
    v_num number(10,0) := &몇단;
    v_count number(2,0) := 1;
begin
    loop
        dbms_output.put_line(v_num || '*' || v_count || '=' || v_num*v_count);
        v_count := v_count+1;
        exit when v_count > 9;
    end loop;
end;
/

--for loop
declare
    v_num number(10,0) := &몇단;
begin
    for i in 1..9 loop
        dbms_output.put_line(v_num || '*' || i || '=' || v_num*i);
    end loop;
end;
/
--while loop
declare
    v_num number(10,0) := &몇단;
    v_count number(2,0) := 1;
begin
    while v_count <=9 loop
         dbms_output.put_line(v_num || '*' || v_count || '=' || v_num*v_count);
          v_count := v_count+1;
    end loop;
end;
/

--구구단 2~9단까지 출력되도록 하세요.

--기본loop
declare
    v_num number(2,0);
    v_count number(2,0);
begin
    v_num :=2;
    loop
        v_count :=1;
        loop
            dbms_output.put_line(v_num || '*' || v_count || '=' || v_num*v_count);
            v_count := v_count+1;
        exit when v_count >9;
        end loop;
            dbms_output.put_line('');
            v_num := v_num+1;
        exit when v_num > 9;
    end loop;
end;
/

--for loop

begin
    for j in 2..9 loop
        for i in 1..9 loop
            dbms_output.put_line(j || '*' || i || '=' || j*i);
        end loop;
            dbms_output.put_line('');
    end loop; 
end;
/


--while loop
declare
    v_num number(2,0);
    v_count number(2,0);
begin
    v_num :=2;
    while v_num <=9 loop
        v_count :=1;
        while v_count <=9 loop
            dbms_output.put_line(v_num || '*' || v_count || '=' || v_num*v_count);
            v_count := v_count+1;
        end loop;
            dbms_output.put_line('');
            v_num := v_num+1;
    end loop;
end;
/