set serveroutput on


--매개변수가 필수는 아니다.
create procedure plus
--out, in out 필수적으로 표기 in은 생략해도 된다.
( v_x number,
  v_y in number,
  v_sum out number)
is
        --필요한 변수, 커서 예외 등을 선언(is..begin)
begin
    v_sum := v_x + v_y;
end;
/
--등록하기 위해서 문법적으로 틀린건 없는지 컴파일 되는 것
--프로시저 등록

declare
    v_result number(10, 0);
begin
    plus(5, 6, v_result);
    
    dbms_output.put_line(v_result);
end;
/

--문제풀기
/* 1. 주민등록번호를 입력하면 다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오
    execute yedam_ju(9501011667777)
    -> 950101-1******
*/

create or REPLACE procedure yedam_ju
( v_num varchar2,
  v_res out varchar2)
-- 매개변수를 쓰면 무조건 밑에 써줘야한다.
is

begin
    v_res := substr(v_num, 1, 6) || '-' || substr(v_num, 7,1) || '******';
end;
/

declare
    v_result varchar2(20);
begin
    yedam_ju('0001011667777', v_result);
    
    dbms_output.put_line(v_result);
end;
/

--교수님

create or REPLACE procedure yedam_ju
( v_num varchar2)
-- 매개변수를 쓰면 무조건 밑에 써줘야한다.
is
    v_res varchar2(15);
    --단순히 출력이 아니라 값을 받아오려면 위와 같이 변수 선언을 해주어야한다.
begin
    v_res := substr(v_num, 1, 6) || '-' || rpad(substr(v_num, 7,1), 7, '*');
    --내가 지정한 자리 만큼 '*'로 대체한다.
    
    dbms_output.put_line(v_res);
end;
/

execute yedam_ju('0001011667777');


/*3.
다음과 같이  PL/SQL 블록을 실행할 경우
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) execute*/

create or replace procedure yedam_emp
(v_empId number)
is
    v_name varchar2(50);
    v_nameres varchar2(50);
    last_name varchar2(50);
begin
    select last_name
    into v_name
    from employees
    where employee_id = v_empId;

    v_nameres := v_name || ' -> ' || rpad(substr(v_name, 1, 1), length(v_name), '*');
    
    dbms_output.put_line(v_nameres);
end;
/

execute yedam_emp(100);

--교수님
--프로시저 : 매개변수
--> 입력: 사원번호;
--> 결과를 내부에서 출력 : 이름 -> 정해진 포맷 out이 필요없다.

create or replace procedure yedam_emp
(v_empId employees.employee_id%type)
is
    v_ename employees.last_name%type;
    v_first_char varchar2(4);
    v_length number(3);
    v_result varchar2(50);
begin
    -- 사원번호 -> 이름 : select
    select last_name
    into v_name
    from employees
    where employee_id = v_empId;
    -- 이름 -> 첫글자만 : substr 짤라내서 표기
    v_first_char := substr(v_name, 1, 1);
    --총 출력글자 수 : length
    v_length := length(v_ename);
    -- 비어있는 공백은 정해진 값으로 채워 넣는다.
    -- ※replace 는 똑같은 크기의 값이 있을 때 사용가능하다.
    -- 정해진 포맷으로 출력 : rpad(출력하고자 하는 문자, 총 출력글자수, 공백을 대체할 문자)
    v_result := rpad(v_first_char, v_length, '*');
       
    --출력
    dbms_output.put_line(v_result);
end;
/

execute yedam_emp(100);


/*부서번호를 입력할 경우
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name)을
출력하는 get_emp 프로시저를 생성하시오
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) execute get_emp(30)*/

create or replace procedure get_emp
(v_deptId employees.department_id%type)
is
--매개변수로 받던걸 프로시저 뭐로 받는다고 생각하기
--한건이 아니기 때문에 cursor를 사용해야 한다.
    cursor emp_info is
        select employee_id, last_name
        from employees
        where department_id = v_deptId;
    --cursor for loop 사용 불가능
    --해당부서에 사원이 없는 경우가 있는 경우
    --for..loop : 내용이 있어야 실행가능, 예외 사용 불가능하기 때문에 기본 루프 사용할 것
    
    --기본 루프를 사용할 경우 변수가 필요하다.
    --레코트 타입이 해당변수에 들어간다.
    emp_record emp_info%rowtype;
    e_no_emp_data exception;
begin
    
    open emp_info;
    loop
        --record 타입을 많이 쓰는데 일반 스칼라 데이터 타입이 아니라 필드가 뭉처있는 형태인 것을 잊지 말기.
        fetch emp_info into emp_record;
        exit when emp_info%notfound;
        -- 주의할 점,
        -- 레코드는 내부에 피드로 존재한다. rowtype은 참조하고 있는 커서의 select에 있는 컬럼을 사용해야한다.
        -- 바꾸고 싶으면 select에서  as로 별칭을 줘야한다. 단, 기존 컬럼명은 사용 불가능하다. R.select한 값을 기준으로 나오기 때문
        dbms_output.put_line(emp_record.employee_id || ', ' || emp_record.last_name);
    end loop;
        --커서가 어디에 도달했는지 보기 때문에 값과는 상관이 없다 주목할 건 rowcount 반복문이 다돌았는데 rowcount가 0이면 값이 없다.
        --예외로 가기위해 raise 필요하다.
        if emp_info%rowcount = 0 then
            raise e_no_emp_data;
        end if;
        
    close emp_info;
--예외도 선언을 해주어야한다.
exception 
    when e_no_emp_data then
        dbms_output.put_line('해당 부서에는 사원이 없습니다.'); 
 
end;
/

execute get_emp(50);


/* 2.
직원들의 사번, 급여 증가치만 입력하면 employees 테이블에 -- 사번 >> 정보가 한개
쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요.
만약 입력한 사원이 없는 경우에는
'No search employee!!'라는 메세지를 출력하세요.(예외처리)
실행) execute y_update(200, 10)
*/

create or replace procedure y_update
(   v_empId employees.employee_id%type,
    v_percent number)
is
    e_name employees.last_name%type;
    e_sal employees.salary%type;
    e_no_emp_date exception;
begin
    --update delete는 어지간하면 오류가 나지 않는다.
    update employees
    set salary = salary*(1+(v_percent/100))
    where employee_id = v_empId;
    
    --암시적 커서(sql/select, insert, update, delete)에 rowcount를 확인해서 실행된 것이 있는지 확인하면 된다.
    --단 직전에 실행된 내역으로 나온다.
    if sql%rowcount = 0 then
        raise e_no_emp_date;
    end if;
    
    select last_name, salary
    into e_name, e_sal
    from employees
    where employee_id = v_empId;
    dbms_output.put_line(e_name|| ', ' || e_sal);

exception 
    when e_no_emp_date then
        dbms_output.put_line('해당 부서에 속한 사원이 없습니다.');
end;
/

execute y_update(10, 20);
rollback;

/**/
create or replace function get_emp_info
(v_eid in employees.employee_id%type)
--in의 가장 큰 특징, 상수로 사용된다.
return number -- 생략 불가능 //크기는 지정필요X
is
    v_sal employees.salary%type;
begin
    select salary
    into v_sal
    from employees
    where employee_id = v_eid;
    
    return v_sal;
end;
/

declare
    v_id employees.employee_id%type :=&사원번호;
    v_result employees.salary%type;
begin
    --함수는 return되는 값을 받아줄 함수가 필요하다.
    v_result := get_emp_info(v_id);
    dbms_output.put_line(v_id || ', ' || v_result);
end;
/

--내부에 사용이 바로 가능했던 것도 return을 통해 값을 바로 던져주는게 바로 가능하기 때문
--프로시저는 불가능하다.
execute dbms_output.put_line(get_emp_info(100));

--function은 sql문에서도 사용 가능하다.
select employee_id, get_emp_info(employee_id) from employees;

/*사용자가 입력한 값을 최대로 두고 짝수 값의 개수를 구하는 함수
입력 : 최대값, 반환: 짝수의 총 갯수
*/
create function get_total_num
( v_num number)
return  number
is
    v_count number(10, 0) := 0;
begin
    for v_n in 1 .. v_num loop
        if mod(v_n, 2) = 0 then --나머지 값을 할때는 mod를 사용하는 것이 가장 좋다.
            v_count := v_count + 1;
        end if;
    end loop;
    
    return v_count;
    -- 조건문으로 나눠주거나 exception 절을 제외하고는 return 뒤에 존재할 수 없다.
end;
/

--dual table을 사용해서 시키겠다.
--간단한 함수의 결과값을 확인하고 싶으면 dual table을 사용해 그냥 원하는 값을 볼 수 있음.
select get_total_num(47) from dual;

/*1.
숫자를 입력할 경우 입력된 숫자까지의 정수의 합계를 출력하는 함수를 작성하시오
실행 예) execute dbms_output.put_line(ysdsum(10))
*/

create or replace function ysdsum
(v_num number)
return number
is
    v_count number(10) := 0;
    v_sum number(10) := 0;
begin
    /*for v_n in 1 .. v_num loop
        v_sum := v_sum + v_n;
    end loop;
    내가 한거*/
    
    while v_count <= v_num loop
        v_sum := v_sum + v_count;
        v_count := v_count +1;
    end loop;
    
    return v_sum;
end;
/

execute dbms_output.put_line(ysdsum(10));


/*2.
사원번호를 입력할 경욷 다음 조건을 만족하는 결과가 출력되는 ydinc 함수를 생성하시오
- 급여가 5000 이하이면 20% 인상된 급여 출력
- 급여가 10000 이하이면 15% 인상된 급여 출력
- 급여가 20000 이하이면 10% 인상된 급여 출력
- 급여가 20000 초과면 급여 그대로 출력

실행) select last_name, salary, ydinc(employee_id)
    from employees;
*/

create or replace function ydinc
(v_empId employees.employee_id%type)
return employees.employee_id%type
is
    v_sal employees.salary%type;
    v_resal employees.salary%type;
begin
    select salary
    into v_sal
    from employees
    where employee_id = v_empId;
    
    if v_sal <= 5000 then
        v_resal := v_sal * 1.2;
    elsif v_sal > 5000 and v_sal <= 10000 then
        v_resal := v_sal * 1.15;
    elsif v_sal > 10000 and v_sal <= 20000 then
        v_resal := v_sal * 1.1;
    elsif v_sal > 20000 then
        v_resal := v_sal;
    end if;
    
return v_resal;
end;
/


select last_name, salary, ydinc(employee_id)
from employees;


/*3.
사원변호를 입력하면 해당 사원의 연봉이 출력되는 yd_func 함수를 생성하시오.
-> 연봉계산 : (급여+(급여*인센티브퍼센트))*12
실행) select last_name, salary, yd_func(employee_id)
        from employees;*/
        
create or replace function yd_func
(v_empId employees.employee_id%type)
return number
is
    v_ysal employees.salary%type;
    v_sal employees.salary%type;
    v_pct employees.commission_pct%type;
begin
    select salary, nvl(commission_pct, 0)
    into v_sal, v_pct
    from employees
    where employee_id = v_empId;
    
    --if v_pct is not null then
        v_ysal := v_sal*(1+v_pct)*12;
   -- else
       -- v_ysal := v_sal*12;
    --end if;
return v_ysal;
end;
/

select last_name, salary, yd_func(employee_id)
from employees;


--교수님
create or replace function yd_func
(v_empId employees.employee_id%type)
return number
is
    v_annual employees.salary%type;

begin
    select (salary * (1 + nvl(commission_pct, 0) *12))
    into v_annual
    from employees
    where employee_id = v_empId;
    
return v_annual;
end;
/

--일반 연산
--group decode는 못쓴다.

-----------------null 다루기
/*is null | is not null
nvl(), nvl2() nullif(), coalesce() --db상관없이 지원
nvl 은 null 인 값을 대체해주고 null이 아니면 기존 값을 보내줌
nvl2 는 null일 때 A, null이 아니면 B의 형태를 취한다.
decode() -- oracle에서만 사용가능 */
----------------------------------

/*4.
select last_name, subname(last_name)
from employees;
LAST_NAME       SUBNAME(LA
----------      -----------
KING            K***
SMITH           S****

예제와 같이 출력되는 subname 함수를 작성하시오.
*/

create or replace function subname
(v_name employees.last_name%type)
return varchar2
is
    v_subname employees.last_name%type;
begin
    v_subname := rpad(substr(v_name, 1, 1), length(v_name), '*');
    --v_subname 대신에 RETURN에 바로 적어줘도 된다.
return  v_subname;
end;
/

select last_name, subname(last_name)
from employees;

--rpad(문자, 길이, 대체문자) 'K***'
--lpad(문자, 길이, 대체문자) '***K'

/*2.
사원번호를 입력하면 소속 부서명을 출력하는 y_dept함수를 생성하시오.
(단, 다음과 같은 경우 예외처리(exception)
입력된 사원이 없거나 소속 부서가 없는 경우 -> 사원이 아니거나 소속 부서가 없습니다.

    입력된 사원이 없는 경우 -> 사원이 아닙니다.
    소속 부서가 없는 경우 -> 소속 부서가 없습니다.

실행) execute dbms_output,put_line(y_dep(178))
출력) executive

select employee_id, y_dept(employee_id)
from employees;
*/

select e.employee_id, d.department_name
from departments d right outer join employees e
--outer join join을 기준으로 내가 모두 보고 싶은 테이블이 오른 쪽에 있냐 왼쪽에 있냐
--둘다 보고 싶으면 full outer 조인을 하면 된다.
using(department_id)
order by employee_id;

create or replace function y_dept
(v_empId employees.employee_id%type)
return varchar2
--return 되는 값의 type을 적어주기. --> v_deptName의 타입을 적어줘야하는 거임
is
    v_deptName departments.department_name%type;
    no_dept exception;

begin
    select d.department_name
    into v_deptName
    from departments d right outer join employees e
    on e.department_id = d.department_id
    where e.employee_id = v_empId
    order by employee_id;
    
    
    if v_deptName is null then
        raise no_dept;
    end if;  
return v_deptName;

exception
    when no_dept then
        return '소속 부서가 없습니다.';
    when no_data_found then
        return '사원이 아닙니다.';
end;
/

execute dbms_output.put_line(y_dept(10));

select employee_id, y_dept(employee_id)
from employees;

------------------------- join 안쓰고
create or replace function y_dept
(v_empId employees.employee_id%type)
return varchar2
--return 되는 값의 type을 적어주기. --> v_deptName의 타입을 적어줘야하는 거임
is
    v_deptName departments.department_name%type;
    v_deptId employees.department_id%type;
    no_data exception;
begin
    select department_id
    into v_deptId
    from employees
    where employee_id= v_empId;

    if v_deptId is null then
        raise no_data;
    end if; 
    
    select department_name
    into v_deptName
    from departments
    where department_id = v_deptId;
     
return v_deptName;

exception
    when no_data then
        return '소속 부서가 없습니다.';
    when no_data_found then
        return '사원이 아닙니다.';
end;
/

