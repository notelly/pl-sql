set serveroutput on


/*1.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
(단, cursor 사용)
*/

declare
    cursor emp_cursor is
    select e.last_name, e.hire_date, d.department_name
    from employees e join departments d
    using (department_id)
    where department_id = &부서번호;
    
    emp_record emp_cursor%rowtype;
begin
    open emp_cursor;
    loop
    fetch emp_cursor into emp_record;
    exit when emp_cursor%notfound;
    
    dbms_output.put_line(emp_record.last_name || ', ' || emp_record.hire_date ||
                         ', ' || emp_record.department_name);
    end loop;

end;
/


/*2.
부서번호를 입력(&사용)하면 
소속된 사원의 사원번호, 사원이름, 부서번호를 출력하는 PL/SQL을 작성하시오.
(단, CURSOR 사용)
*/

declare
    cursor emp_cursor is
    select employee_id, last_name, department_id
    from employees
    where department_id = &부서번호;
    
    emp_record emp_cursor%rowtype;
begin
    open emp_cursor;
    loop
    fetch emp_cursor into emp_record;
    exit when emp_cursor%notfound;
    
    dbms_output.put_line(emp_record.employee_id || ', ' || emp_record.last_name ||
                         ', ' || emp_record.department_id);
    end loop;

end;
/

/*3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
(단, cursor 사용)
*/
declare
    cursor emp_cursor is
    select last_name, salary, salary*12+(salary*nvl(commission_pct, 0)*12) ysalary
    from employees
    where department_id = &부서번호;
    
    emp_record emp_cursor%rowtype;
begin
    open emp_cursor;
    loop
    fetch emp_cursor into emp_record;
    exit when emp_cursor%notfound;
    
    dbms_output.put_line(emp_record.last_name || ', ' || emp_record.salary ||
                         ', ' || emp_record.ysalary);
    end loop;

end;
/
