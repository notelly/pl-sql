--예외

--미리 정의된 예외 -> 이름이 존재하는 예외
declare
    v_emp_id employees.employee_id%type;
begin
    select employee_id
    into v_emp_id
    from employees
    where department_id = 50;
    --예외라고 모든 걸 처리해주는 건 아니다
    --문법이 틀린건 아예 실행이 불가능 하기 때문에 예외도 실행이 안된다.
    
exception 
    when no_data_found then
        dbms_output.put_line('해당 부서에 속한 사원이 없습니다.');
    when to_many_rows then
        dbms_output.put_line('요구한 결과보다 데이터가 많습니다.');
    when other then
        dbms_output.put_line('기타 예외 사항이 발생했습니다.');
end;
/

--미리 정의하지 않은 예외 -> 존재는 하되 이름없이 번호로 관리되는 예외
--오라클 document에 번호들이 많이 나와있음
declare
    e_delete_dept_fail exception;
    pragma exception_init(e_delete_dept_fail, -2292);
    --순서 지정해준 이름, 오라클이 가지고 있는 번호
    
begin
    delete from departments
    where department_id = &부서번호;
    
    dbms_output.put_line('정상적으로 부서가 삭제되었습니다.');
exception
    when e_delete_dept_fail then
        dbms_output.put_line('해당 부서에 속한 사원이 존재합니다.');
    
end;
/
--insert delete update 특정한 데이터가 없는 경우 예외가 발생하는 것이 아니라 정상 실행되면서 0이 반환되기 때문에
--오라클 입장에서는 예외라고 보지 않는다. 그러므로 우리가 사용자 정의 예외를 지정해주어야 한다.
--사용자 정의 예외

declare
    e_no_dept_info exception;
begin
    delete from departments
    where department_id = &부서번호;
    
    if sql%rowcount = 0 then
        raise e_no_dept_info;
    end if;
    
exception
    when e_no_dept_info then
        dbms_output.put_line('해당 부서의 정보가 존재하지 않습니다.');
end;
/


--예외 트랩 함수
declare
--예외를 따로 정의 하지 않고 
    
begin
    delete from departments
    where department_id = &부서번호;
    
    dbms_output.put_line('정상적으로 부서가 삭제되었습니다.');
exception
    when no_data_found then
        dbms_output.put_line('해당 정보가 없습니다.');
    when others then
        dbms_output.put_line('오류번호 : ' || sqlcode);
        dbms_output.put_line('오류 메세지 : ' || sqlerrm);
end;
/

rollback;
create table log_table
(code number(10),
message varchar2(200),
info varchar(200));


--상여금을 받는데 그 상여금이 월급보다 많은지 확인하겠다.

declare
    cursor emp_cursor is
        select employee_id, first_name, salary
        from employees
        where department_id = &부서번호;
    emp_record emp_cursor%rowtype;
        
    v_error_code number(10, 0);
    v_error_message varchar2(100);
    
    e_too_many_comm exception;
    
begin
    open emp_cursor;
    
    loop
        fetch emp_cursor into emp_record;
        exit when emp_cursor%notfound;
        
        if emp_record.salary > 5000 then
            raise e_too_many_comm;
        end if;
    end loop;
    
    close emp_cursor;
    
    dbms_output.put_line('현재 부서의 인원은 ' || emp_cursor%rowcount || '명 이고' ||
                         '지급할 총 금액은 ' || (5000*emp_cursor%rowcount) || '달러입니다.');

exception
    when e_too_many_comm then
      insert into log_table
      values(v_error_code, '현재 부서에 상여금이 급여보다 많은 사원이 존재합니다.', null);
    when others then
        v_error_code := sqlcode;
        v_error_message : = sqlerrm;
        insert into log_table
        values (sqlcode, substr(v_error_message, 1 ,200), 'Oracle Error Occurred');

end;
/

declare

begin
    declare
        emp_record employees%rowtype;
    begin
        select *
        into emp_record
        from employees
        where department_id = &부서번호;
    exception
        when no_data_found then
           dbms_output.put_line('현재 부서에는 근무하는 사원이 없습니다.');
    end;
    
    dbms_output.put_line('안쪽 PL/SQL이 종료 되었습니다.');
exception
    when too_many_rows then
        --dbms_output.put_line('한 행을 초과하여 결과를 반환했습니다.');
        raise_application_error(-20201, 'TEST ERROR MESSAGE');
        
-- 오류/예외가 발생하면 바로 멈춘다.
-- exception 으로 와서 있는가를 본다.
end;
/

/*2.
사원 테이블에서 사원번호를 입력(&사용)받아
10% 인상된 급여로 수정하는 PL/SQL을 작성하시오.
단, 2005년(포함) 이후 입사한 사원은 갱신하지 않고
"2005년 이후 입사한 사원입니다." <- exception 절 사용
라고 출력되도록 하시오.
*/


declare
    e_over_date exception;
begin

    update employees
    set salary = (salary*1.1)
    where employee_id = &사원번호
    and hire_date < to_date('2005-01-01', 'yyyy-mm-dd');
    
    if sql%rowcount = 0 then
        raise e_over_date;
    end if;
        
exception
    when e_over_date then
        dbms_output.put_line('2005년 이후 입사한 사원 입니다.');
end;
/

/*3-1
사원 테이블에서 부서번호를 입력(&사용)받아 <- cursor 사용
10% 인상된 급여로 수정하는 PL/SQL을 작성하시오.
단, 2010년 이후 입사한 사원은 갱신하지 않고 
"2010년 이후 입사한 사원은 갱신되지 않습니다." <- 예외 절 사용 라고 출력되도록 하시오*/

declare
    cursor emp_cursor is
        select *
        from employees
        where department_id = &부서번호
        order by hire_date;
        -- order by 로 정리해서 insert 되는 순서를 정해줄 것.
        
        emp_record emp_cursor%rowtype; 
    e_over_date exception;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into emp_record;
        exit when emp_cursor%notfound;
        update employees
        set salary = (salary*1.1)
        --커서는 한행씩 가지고 온다. 정보를 바꿀 것이 필요함 각 행의 employee_id를 가지고 와서 조건을 정해준다.
        where employee_id = emp_record.employee_id
        and hire_date < to_date('2005-01-01', 'yyyy-mm-dd');
        
        
        --if 조건에 hire_date~ 부분을 넣어도 된다. 2번째 방법
        if sql%rowcount = 0 then
            dbms_output.put_line(emp_record.last_name);
            raise e_over_date;
        end if;  
         
    end loop;

exception -- 이렇게 되면 정상종료 rollback되지 않음 / 예외를 만나면 강제종료 되면서 rollback 됨
    when e_over_date then
        dbms_output.put_line('2005년 이후 입사한 사원은 갱신되지 않습니다.');
    close emp_cursor;
end;
/


ROLLBACK;

--프로시저
-- or replace는 되도록이면 쓰지말기
create or replace procedure test_procedure
( v_message in varchar2 )
is
    e_test_data exception;
begin 
    --매개변수를 통해 메세지를 전달받아 출력하는 프로시저
    --v_message := '값을 변경하였습니다';
    --오류생긴다
    -- in 안에 들어가는 것은 전부 상수취급 밖에서 변경해주어야한다.
    if v_message is not null then
      dbms_output.put_line(v_message);   
      dbms_output.put_line('정상적으로 종료되었습니다.');
    else
        raise e_test_data;
    end if;
exception
    when e_test_data then
         dbms_output.put_line('메세지를 입력하지 않았습니다.');
end;
/
-- 위를 실행하면 'Procedure TEST_PROCECURE이(가) 컴파일되었습니다.' 문구가 나온다.

begin
    test_procedure('HELLO WORLD!');
    --test_procedure(null);
end;
/

execute test_procedure('Moments Today');
execute test_procedure(to_char(sysdate, 'yyyy"년"') || '은 흑토끼해입니다.');
--프로시저는 dml insert, delete, update 사용이 불가능하다.


create or replace procedure query_emp_info
( v_id in employees.employee_id%type,
  v_name out employees.first_name%type,
  v_sal in out employees.salary%type,
  --기존에 있던 out에 in을 추가하면 어떻게 될까
  --프로시저에서는 매개변수가 중요한 역할을 한다.
  --내부 모드를 기준으로 움직인다.
  -- out, in out 무조건 변수여야한다. 변수가 아니라 값을 집어넣으면 실행이 되지 않는다.
  v_commission_pct out employees.commission_pct%type )
is

begin
    dbms_output.put_line('v_sal ' || v_sal);
    
    select first_name, salary, commission_pct
    into v_name, v_sal, v_commission_pct
    from employees
    where employee_id = v_id;
end query_emp_info;
/

declare
    v_eid employees.employee_id%type := &사원번호;
    v_ename employees.first_name%type;
    v_sal employees.salary%type not null := 1000;
    v_comm employees.commission_pct%type;
begin
    query_emp_info(v_eid, v_ename, v_sal, v_comm);
    
    dbms_output.put_line('사원번호 : ' || v_eid);
    dbms_output.put_line('- 이름 : ' || v_ename);
    dbms_output.put_line('- 급여 : ' || v_sal);
    dbms_output.put_line('- 상여금 : ' || v_comm);
    
end;
/

-- '01012341234' -> 010-1234-1234
create or replace procedure format_phone
( v_phone_no in out varchar2 )
is

begin
    v_phone_no := substr(v_phone_no, 1, 3) || '-' ||
                substr(v_phone_no, 4, 4) || '-' ||
                substr(v_phone_no, 8, 4);
end;
/

declare
    v_phone varchar2(13) := '&연락처';
    --'&연락처' 감싸는 이유 숫자가 아니라 문자로 받아오려고
    -- 숫자로 받아오면 0이 날아간다.
begin
    format_phone(v_phone);
    
    dbms_output.put_line(v_phone);
end;
/

create or replace procedure query_find_emp
( v_dept_no departments.department_id%type)
is
    cursor emp_cursor
    (v_deptno departments.department_id%type)
    is
        select *
        from employees
        where department_id = V_deptno;
    
    v_ename employees.first_name%type;
    v_sal employees.salary%type;
    v_comm employees.commission_pct%type;
begin
    for emp_record in emp_cursor(v_dept_no) loop
        query_emp_info(emp_record.employee_id, v_ename, v_sal, v_comm);
        
        dbms_output.put_line(v_ename || ', ' || v_sal || ', ' || v_comm);
    end loop;
end;
/

execute query_find_emp(50);

--프로시저 삭제
drop procedure query_find_emp;
