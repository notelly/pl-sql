--이거 항상 꼭 먼저 적어주기.
set serveroutput on
--4. 구구단 1~9단 까지 출력되도록 하시오
--(단, 홀수단 출력)

declare
    v_num number(2,0);
    v_count number(2,0);
    v_mod number(2);
begin
    v_num := 1;
    while v_num <= 9 loop
        v_count := 1;
        v_mod := mod(v_num, 2);
        if v_mod != 0 then
            while v_count <=9 loop
                dbms_output.put_line(v_num || '*' || v_count || '=' || v_num*v_count);
            v_count := v_count+1;
            end loop;
            v_num := v_num+1;
        else
            dbms_output.put_line('');
            v_num := v_num+1;
        end if;
    end loop;
end;
/

--교수님
declare
    v_num number(2,0);
    v_count number(2,0);
begin
    loop
        if mod(v_num,2) = 0 then
        v_num :=1;
        loop
            dbms_output.put_line(v_num || '*' || v_count || '=' || v_num*v_count);
            v_count := v_count + 1;
            exit when v_count > 9;
        end loop;
        end if;
        v_num := v_num +1;
        exit when v_num > 9;
    end loop;
end;
/

declare
    v_num number(2,0):= 1;
    v_count number(2,0);
begin
    loop
        v_count :=1;
        loop
            if mod(v_num,2) = 0 then
                exit;
            end if;    
            dbms_output.put_line(v_num || '*' || v_count || '=' || v_num*v_count);
            v_count := v_count + 1;
            exit when v_count > 9;
        end loop;
        v_num := v_num +1;
        exit when v_num > 9;
    end loop;
end;
/


declare
    type emp_record_type is record
    (emp_id employees.employee_id%type,
     emp_name varchar2(2000),
     emp_salary number(20,2) not null := 1000); --field를 정의하면 된다.
     
     --record table이든 이름을 type으로 끝맺음 하면 보기 편하다.
     emp_record emp_record_type;
begin
    --dbms_output.put_line(emp_record);
    --이대로 실행하면 오류가 난다.
    --R: 뭘 출력할지 몰라서 오류가 나는 것.
    --record나 table을 출력할 때는 아래와 같이 뭘 출력할지 지정해주어야한다.
    --dbms_output.put_line(emp_record.emp_salary);
    
    --대신 스칼라 타입 순서대로 select 를 써주면 개별적으로 변수를 선언하지 않아도 값을 받아올 수 있다.
    select employee_id, first_name, salary
    into emp_record
    from employees
    where employee_id = 200;
    
    dbms_output.put_line(emp_record.emp_id);
    dbms_output.put_line(emp_record.emp_name);
    dbms_output.put_line(emp_record.emp_salary);
    --이름은 상관없고 레코드를 구성하는 타입 순서대로 적어주면 된다.
    
end;
/

declare
    emp_record employees%ROWTYPE;
    --변수에 대해서 record type에 대해 그대로 넘기려고 한다.
    -- 또다른 변수로 지정하려면 type 변수를 써야한다.
    --recordtype으로 한번 선언 되어 버리면 걔는 걍 record type이다
    --rowtype이 될 수 없음.
    --컬럼의 정보를 받아오는 것이기 때문에 엄밀히 말하면 타입이 아니다.
    --rowtype으로 넘겨줬는데 안되면 row로 해볼 것.
    test_record emp_record%TYPE;
begin
    select *
    into emp_record
    from employees
    where employee_id = 200;
    
    dbms_output.put_line(emp_record.employee_id);
    dbms_output.put_line(emp_record.first_name);
    dbms_output.put_line(emp_record.salary);
end;
/

declare
    type number_table_type is table of number
        index by binary_integer;
    v_total_data number_table_type;
begin
    for v_counter In -25 .. 25 loop
        if mod(v_counter, 2) <> 0 then
            --index가 필요하다/.
            v_total_data(v_counter) := v_counter;

            --가로로 index글
        end if;
    end loop;
    dbms_output.put_line(v_total_data.count);
    
    for v_index in v_total_data.first .. v_total_data.last loop
        if v_total_data.exists(v_index) then
        dbms_output.put_line(v_total_data(v_index));
        end if;
    end loop;
end;
/
--뭐가 가능한 이유, 순차적으로 값을 넣지 않아서.

-- employees 테이블 모든 값을 하나의 테이블 타입으로 만들어보세요.
-- employee_id : primary key ( unique, not null )+ 0, 양수
--             => min, max (id가 가지고 잇는 최대값과 최소값으로 for문을 돌리면 된다.)
select *
from employees;

declare
    v_min employees.employee_id%type;
    v_max employees.employee_id%type;
    v_count number(1,0);
    emp_record employees%rowtype;
    
    --재사용을 하고 싶을 때 >> for문 밖으로 나가면 사라진다
    --모든 데이터를 하나의 변수에 담으려면
    type emp_table_type is table of employees%rowtype
        index by pls_integer;
    
    emp_table emp_table_type;
    
begin    
    select Min(employee_id), max(employee_id)
    into v_min, v_max
    from employees;
    
    for v_emp_id in v_min .. v_max loop
        select count(*)
        into v_count
        from employees
        where employee_id = v_emp_id;
        
        if v_count = 0 then
            continue;
        end if;
        
        select *
        into emp_record
        from employees
        where employee_id = v_emp_id;
        
        emp_table(v_emp_id) := emp_record;
        --
    end loop;
        --해당 for문이 끝나고 새로운 loop를 실행해야한다.
        for v_index in emp_table.first .. emp_table.last loop
            if emp_table.exists(v_index) then
            --해당 테이블의 전체 index로 접근한 다음에 여러 필드로 나눠지기 때문에 무엇에 접근 할 건지 추가적으로 적어줘야한다.
                dbms_output.put_line(emp_table(v_index).employee_id);
                dbms_output.put_line(emp_table(v_index).first_name);
                dbms_output.put_line(emp_table(v_index).job_id);
            end if;
        end loop;
end;
/


declare
    cursor emp_cursor is
        select employee_id, first_name, job_id
        from employees
        where department_id = 50
        order by first_name;
        
    v_emp_id employees.employee_id%type;
    v_emp_name employees.first_name%type;
    v_job employees.job_id%type;
    
    v_counter number (2,0) := 1;
begin
    open emp_cursor;
    -- into 절은
    -- select (employee_id, first_name, job_id)절의 모든 컬럼을 대응 할 수 있도록 적어줘야한다.
    -- select 컬럼 순서처럼 순차적으로 적어 주어야 한다.
    
    loop
        -- 여러 값이 나오도록 loop
        fetch emp_cursor into v_emp_id, v_emp_name, v_job;
        dbms_output.put_line(v_emp_id);
        dbms_output.put_line(v_emp_name);
        dbms_output.put_line(v_job);
        v_counter := v_counter +1;
        exit when v_counter >3;
    end loop;
    dbms_output.put_line('---');
    close emp_cursor;
    --close없이 재 open 할 수 없다. close를 무조건 해주어야한다.
    open emp_cursor;
    v_counter :=1;
    loop
        --선택적으로 컬럼만 들고 오는 것은 불가능하다. select 절 컬럼이랑 똑같이 구성한다.
        fetch emp_cursor into v_emp_id, v_emp_name, v_job;
        dbms_output.put_line(v_emp_id);
        dbms_output.put_line(v_emp_name);
        dbms_output.put_line(v_job);
        v_counter := v_counter +1;
        exit when v_counter >3;
    end loop;
    
    close emp_cursor;
end;
/
declare
    cursor emp_cursor is
        select employee_id, first_name, job_id
        from employees
        where department_id = 50
        order by first_name;
        
    v_emp_id employees.employee_id%type;
    v_emp_name employees.first_name%type;
    v_job employees.job_id%type;
begin
    
    open emp_cursor;
    loop
        fetch emp_cursor into v_emp_id, v_emp_name, v_job;
        --cursor랑 exit when이랑 같이 움직인다.
        exit when emp_cursor%rowcount >3;
        
        dbms_output.put_line(v_emp_id);
        dbms_output.put_line(v_emp_name);
        dbms_output.put_line(v_job);
        
    end loop;
    
    close emp_cursor;
    
    if not emp_cursor%isopen then
    --open = true
        open emp_cursor;
        --already open => 반대로 실행 되기를 원함 if에 not추가
    end if;
    dbms_output.put_line('---');
    
    loop
        fetch emp_cursor into v_emp_id, v_emp_name, v_job;
        --cursor랑 exit when이랑 같이 움직인다.
        --xit when emp_cursor%rowcount >3;
        --끝까지 출력하고 싶을 때 
        exit when emp_cursor%notfound;
        
        dbms_output.put_line(v_emp_id);
        dbms_output.put_line(v_emp_name);
        dbms_output.put_line(v_job);
        
    end loop;
    
    if not emp_cursor%isopen then
    --open = true
        open emp_cursor;
        --already open => 반대로 실행 되기를 원함 if에 not추가
    end if;
    dbms_output.put_line(emp_cursor%rowcount);
    --닫기기 전에 하면 행의 개수를 알 수 있다.
    close emp_cursor;
    --dbms_output.put_line(emp_cursor%rowcount);
    --invalid cursor
    --notfound 속성이 사라진다. 닫힌 커서에 대해서 뭔가 하게 되면
    --저 오류가 뜬다.
end;
/

--생각해보기
declare
    cursor emp_cursor is
        select employee_id
        from employees
        where department_id = 50;
        
    v_eid employees.employee_id%type;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into v_eid;
        exit when emp_cursor%notfound;
        --exit when emp_cursor%rowcount = 0 || emp_cursor%notfound;
        --절대 하지 말 것.
        
        dbms_output.put_line(v_eid);        
        
    end loop;
    --반환된 행이 없다.
    --close되기 전에 rowcount를 이용해서 총 데이터 수를 알 수 있다.
        if emp_cursor%rowcount = 0 then
        dbms_output.put_line('값이 존재하지 않습니다.');
        end if;
    close emp_cursor;
end;
/

-- employees 테이블 모든 값을 하나의 테이블 타입으로 만들어보세요.
-- cursor를 배우고 나서
-- 1) employees 테이블에 있는 모든 값을 
declare
    cursor all_emp_cursor is
        select *
        from employees
        order by employee_id;
    
    emp_record employees%rowtype;
    
    type emp_table_type is table of employees%rowtype
        index by binary_integer;
    --실제로 사용하려면 변수를 선언해 주어야한다.
    emp_table emp_table_type;
begin

open all_emp_cursor;
    loop
        fetch all_emp_cursor into emp_record;
        exit when all_emp_cursor%notfound;
        
        --all_emp_cursor%rowcount >> 연속적으로 값을 주고 싶을 때/권장하는 건 아님
        --근데 primary key를 주는게 잴 편하긴 하다.
        emp_table(all_emp_cursor%rowcount) := emp_record;
        
    end loop;
    
    close all_emp_cursor;
    
    -- 밑은 외우기
    for v_index in emp_table.first .. emp_table.last loop
        if not emp_table.exists(v_index) then
            continue;
        end if;
        --너무 길면 변수 써도 괜찮다.
        dbms_output.put_line(emp_table(v_index).employee_id || ', ' || emp_table(v_index).first_name);
    end loop;
    
end;
/

declare
    --전체 순환을 일으킬 꺼면 for loop 이 가장 간단하다.
    cursor all_emp_cursor is
        select * from employees;
begin
    --emp_record는 임시변수 all_emp_cursor <= 커서
    --커서의 활성집합에서 자동으로 순환하면서 emp_record로 들어가게됨.->출력->end loop->다음 행->반복
    --끝에 도달하면 종료한다.
    for emp_record in all_emp_cursor loop
        dbms_output.put_line(emp_record.employee_id || ', ' || emp_record.first_name);
    end loop;
    --문제는 반복문을 벗어나면 정보를 가지고 올 수 없다는 것.
    --dbms_output.put_line(all_emp_cursor%rowcount);
    --더이상 커서가 살아있지않음
    --자동적으로 close까지 해주기 때문에.
end;
/

begin
    --for emp_record in all_emp_cursor loop
    --여기서 all_emp_cursor 가 sql문을 가지고 있는 것임.
    for emp_record in (select * from employees) loop
        dbms_output.put_line(emp_record.employee_id || ', ' || emp_record.first_name);
    end loop;
end;
/

declare
    cursor emp_cursor is
        select employee_id, first_name
        from employees
        where department_id = 0;
        
    emp_record emp_cursor%rowtype;
begin
    for emp_info in emp_cursor loop
        dbms_output.put_line(emp_info.employee_id || ', ' || emp_info.first_name);
    end loop;
    --cursor for loop를 사용하면 값이 없을 때는 경고를 주는 것도 불가능하다.
end;
/

--매개변수를 사용한 예제
select e,first_name, d.department_name, e.hire_date
from employees e join departments d
on e.department_id = d.department_id
where e.department_id = 90
    and to_char(e.hire_date, 'yyyy') = '2018';

declare
    cursor emp_info_cursor
        (v_deptno number, v_hire_year varchar2)
        --사용하고자 하는 매개변수를 정의해 주면 된다.
    is
        select e.first_name, d.department_name, e.hire_date
        from employees e join departments d
        on e.department_id = d.department_id
        where e.department_id = v_deptno
          and to_char(e.hire_date, 'yyyy') = v_hire_year;
    
    emp_info_record emp_info_cursor%rowtype;
begin
    --해당 매개변수를 지정해주어야한다.
    
    open emp_info_cursor(50, '2005'); --매개변수값 넘기기
    
   -- open emp_info_cursor(80, '2018'); --오픈된 상태에서 재오픈 불가 이렇게 하면 안됨
   -- 새로운 매개변수로 하고 싶다면 close한 다음 다시 open
    loop
        fetch emp_info_cursor into emp_info_record;
        exit when emp_info_cursor%notfound;
        
        dbms_output.put_line(emp_info_record.first_name || ', '
                            || emp_info_record.department_name || ', '
                            || emp_info_record.hire_date);
    end loop;
    
    close emp_info_cursor;
    
end;
/

--cursor for loop의 경우 매개변수 유무가 상관이 없다
declare
    cursor emp_info_cursor
        (v_deptno number, v_hire_year varchar2)
        --사용하고자 하는 매개변수를 정의해 주면 된다.
    is
        select e.first_name, d.department_name, e.hire_date
        from employees e join departments d
        on e.department_id = d.department_id
        where e.department_id = v_deptno
          and to_char(e.hire_date, 'yyyy') = v_hire_year;
    
    emp_info_record emp_info_cursor%rowtype;
begin
    for emp_info in emp_info_cursor(50, '2005') loop       
        dbms_output.put_line(emp_info.first_name || ', '
                            || emp_info.department_name || ', '
                            || emp_info.hire_date);
    end loop;
end;
/

--for update절과 where currnet of 절

--상여금을 주거나 급여 변경 => update 가 필요
declare
    cursor dept_50_cursor is
        select first_name, hire_date, salary
        from employees
        where department_id = 50
        order by first_name
        for update of salary nowait;
begin
    for emp_info in dept_50_cursor loop
        if emp_info.hire_date < to_date('2018-01-01', 'yyyy-mm-dd') then
            --update가 되는 추제는 employees라는 거 잊지말기
            update employees
            set salary = salary * 1.15
            where current of dept_50_cursor;
        end if;
    end loop;
end;
/
drop table test01;
drop table test02;


create table test01
as
    select employee_id, first_name, hire_date, department_id
    from employees
    where employee_id = 0;
    


create table test02
as
    select employee_id, first_name, hire_date, department_id
    from employees
    where employee_id = 0;


--사원 테이블에서 사원번호, 이름, 입사연도, 부서번호를 다음 기준에 맞게 각각 테이블에 입력하시오

-- 1) 입사년도가 2005년(포함) 이전 입사한 사원은 test01 테이블에 입력
-- 입사년도가 2005년 이후 입사한 사원은 test02 테이블에 입력 
declare
    cursor emp_05_cursor is
        select employee_id, first_name, hire_date, department_id
        from employees
        order by employee_id;
begin
    for test_info in emp_05_cursor loop
        if test_info.hire_date <= to_date('2005-12-31', 'yyyy-mm-dd') then
            insert into test01 (employee_id, first_name, hire_date, department_id)
            values (test_info.employee_id,
                    test_info.first_name,
                    test_info.hire_date,
                    test_info.department_id);
        else
            insert into test02 (employee_id, first_name, hire_date, department_id)
            values (test_info.employee_id,
                    test_info.first_name,
                    test_info.hire_date,
                    test_info.department_id);
        end if;
    end loop;
end;
/

select *
from test01;
select *
from test02;

--loop 사용
declare
    cursor emp_05_cursor is
        select employee_id, first_name, hire_date, department_id
        from employees
        order by employee_id;
    emp_record  emp_05_cursor%rowtype;
begin
    open emp_05_cursor;
    loop
        fetch emp_05_cursor into emp_record;
        exit when emp_05_cursor%notfound;
        
        if emp_record.hire_date <= to_date('2005-12-31', 'yyyy-mm-dd') then
        
        insert into test01 (employee_id, first_name, hire_date, department_id)
            values (emp_record.employee_id,
                    emp_record.first_name,
                    emp_record.hire_date,
                    emp_record.department_id);
        else
            insert into test02 (employee_id, first_name, hire_date, department_id)
            values (emp_record.employee_id,
                    emp_record.first_name,
                    emp_record.hire_date,
                    emp_record.department_id);
        end if;
        end loop;
end;
/