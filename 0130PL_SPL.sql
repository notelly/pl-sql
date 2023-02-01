set serveroutput on


--�Ű������� �ʼ��� �ƴϴ�.
create procedure plus
--out, in out �ʼ������� ǥ�� in�� �����ص� �ȴ�.
( v_x number,
  v_y in number,
  v_sum out number)
is
        --�ʿ��� ����, Ŀ�� ���� ���� ����(is..begin)
begin
    v_sum := v_x + v_y;
end;
/
--����ϱ� ���ؼ� ���������� Ʋ���� ������ ������ �Ǵ� ��
--���ν��� ���

declare
    v_result number(10, 0);
begin
    plus(5, 6, v_result);
    
    dbms_output.put_line(v_result);
end;
/

--����Ǯ��
/* 1. �ֹε�Ϲ�ȣ�� �Է��ϸ� ������ ���� ��µǵ��� yedam_ju ���ν����� �ۼ��Ͻÿ�
    execute yedam_ju(9501011667777)
    -> 950101-1******
*/

create or REPLACE procedure yedam_ju
( v_num varchar2,
  v_res out varchar2)
-- �Ű������� ���� ������ �ؿ� ������Ѵ�.
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

--������

create or REPLACE procedure yedam_ju
( v_num varchar2)
-- �Ű������� ���� ������ �ؿ� ������Ѵ�.
is
    v_res varchar2(15);
    --�ܼ��� ����� �ƴ϶� ���� �޾ƿ����� ���� ���� ���� ������ ���־���Ѵ�.
begin
    v_res := substr(v_num, 1, 6) || '-' || rpad(substr(v_num, 7,1), 7, '*');
    --���� ������ �ڸ� ��ŭ '*'�� ��ü�Ѵ�.
    
    dbms_output.put_line(v_res);
end;
/

execute yedam_ju('0001011667777');


/*3.
������ ����  PL/SQL ����� ������ ���
�����ȣ�� �Է��� ��� ����� �̸�(last_name)�� ù��° ���ڸ� �����ϰ��
'*'�� ��µǵ��� yedam_emp ���ν����� �����Ͻÿ�.

����) execute*/

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

--������
--���ν��� : �Ű�����
--> �Է�: �����ȣ;
--> ����� ���ο��� ��� : �̸� -> ������ ���� out�� �ʿ����.

create or replace procedure yedam_emp
(v_empId employees.employee_id%type)
is
    v_ename employees.last_name%type;
    v_first_char varchar2(4);
    v_length number(3);
    v_result varchar2(50);
begin
    -- �����ȣ -> �̸� : select
    select last_name
    into v_name
    from employees
    where employee_id = v_empId;
    -- �̸� -> ù���ڸ� : substr ©�󳻼� ǥ��
    v_first_char := substr(v_name, 1, 1);
    --�� ��±��� �� : length
    v_length := length(v_ename);
    -- ����ִ� ������ ������ ������ ä�� �ִ´�.
    -- ��replace �� �Ȱ��� ũ���� ���� ���� �� ��밡���ϴ�.
    -- ������ �������� ��� : rpad(����ϰ��� �ϴ� ����, �� ��±��ڼ�, ������ ��ü�� ����)
    v_result := rpad(v_first_char, v_length, '*');
       
    --���
    dbms_output.put_line(v_result);
end;
/

execute yedam_emp(100);


/*�μ���ȣ�� �Է��� ���
�ش�μ��� �ٹ��ϴ� ����� �����ȣ, ����̸�(last_name)��
����ϴ� get_emp ���ν����� �����Ͻÿ�
(cursor ����ؾ� ��)
��, ����� ���� ��� "�ش� �μ����� ����� �����ϴ�."��� ���(exception ���)
����) execute get_emp(30)*/

create or replace procedure get_emp
(v_deptId employees.department_id%type)
is
--�Ű������� �޴��� ���ν��� ���� �޴´ٰ� �����ϱ�
--�Ѱ��� �ƴϱ� ������ cursor�� ����ؾ� �Ѵ�.
    cursor emp_info is
        select employee_id, last_name
        from employees
        where department_id = v_deptId;
    --cursor for loop ��� �Ұ���
    --�ش�μ��� ����� ���� ��찡 �ִ� ���
    --for..loop : ������ �־�� ���డ��, ���� ��� �Ұ����ϱ� ������ �⺻ ���� ����� ��
    
    --�⺻ ������ ����� ��� ������ �ʿ��ϴ�.
    --����Ʈ Ÿ���� �ش纯���� ����.
    emp_record emp_info%rowtype;
    e_no_emp_data exception;
begin
    
    open emp_info;
    loop
        --record Ÿ���� ���� ���µ� �Ϲ� ��Į�� ������ Ÿ���� �ƴ϶� �ʵ尡 ��ó�ִ� ������ ���� ���� ����.
        fetch emp_info into emp_record;
        exit when emp_info%notfound;
        -- ������ ��,
        -- ���ڵ�� ���ο� �ǵ�� �����Ѵ�. rowtype�� �����ϰ� �ִ� Ŀ���� select�� �ִ� �÷��� ����ؾ��Ѵ�.
        -- �ٲٰ� ������ select����  as�� ��Ī�� ����Ѵ�. ��, ���� �÷����� ��� �Ұ����ϴ�. R.select�� ���� �������� ������ ����
        dbms_output.put_line(emp_record.employee_id || ', ' || emp_record.last_name);
    end loop;
        --Ŀ���� ��� �����ߴ��� ���� ������ ������ ����� ���� �ָ��� �� rowcount �ݺ����� �ٵ��Ҵµ� rowcount�� 0�̸� ���� ����.
        --���ܷ� �������� raise �ʿ��ϴ�.
        if emp_info%rowcount = 0 then
            raise e_no_emp_data;
        end if;
        
    close emp_info;
--���ܵ� ������ ���־���Ѵ�.
exception 
    when e_no_emp_data then
        dbms_output.put_line('�ش� �μ����� ����� �����ϴ�.'); 
 
end;
/

execute get_emp(50);


/* 2.
�������� ���, �޿� ����ġ�� �Է��ϸ� employees ���̺� -- ��� >> ������ �Ѱ�
���� ����� �޿��� ������ �� �ִ� y_update ���ν����� �ۼ��ϼ���.
���� �Է��� ����� ���� ��쿡��
'No search employee!!'��� �޼����� ����ϼ���.(����ó��)
����) execute y_update(200, 10)
*/

create or replace procedure y_update
(   v_empId employees.employee_id%type,
    v_percent number)
is
    e_name employees.last_name%type;
    e_sal employees.salary%type;
    e_no_emp_date exception;
begin
    --update delete�� �������ϸ� ������ ���� �ʴ´�.
    update employees
    set salary = salary*(1+(v_percent/100))
    where employee_id = v_empId;
    
    --�Ͻ��� Ŀ��(sql/select, insert, update, delete)�� rowcount�� Ȯ���ؼ� ����� ���� �ִ��� Ȯ���ϸ� �ȴ�.
    --�� ������ ����� �������� ���´�.
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
        dbms_output.put_line('�ش� �μ��� ���� ����� �����ϴ�.');
end;
/

execute y_update(10, 20);
rollback;

/**/
create or replace function get_emp_info
(v_eid in employees.employee_id%type)
--in�� ���� ū Ư¡, ����� ���ȴ�.
return number -- ���� �Ұ��� //ũ��� �����ʿ�X
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
    v_id employees.employee_id%type :=&�����ȣ;
    v_result employees.salary%type;
begin
    --�Լ��� return�Ǵ� ���� �޾��� �Լ��� �ʿ��ϴ�.
    v_result := get_emp_info(v_id);
    dbms_output.put_line(v_id || ', ' || v_result);
end;
/

--���ο� ����� �ٷ� �����ߴ� �͵� return�� ���� ���� �ٷ� �����ִ°� �ٷ� �����ϱ� ����
--���ν����� �Ұ����ϴ�.
execute dbms_output.put_line(get_emp_info(100));

--function�� sql�������� ��� �����ϴ�.
select employee_id, get_emp_info(employee_id) from employees;

/*����ڰ� �Է��� ���� �ִ�� �ΰ� ¦�� ���� ������ ���ϴ� �Լ�
�Է� : �ִ밪, ��ȯ: ¦���� �� ����
*/
create function get_total_num
( v_num number)
return  number
is
    v_count number(10, 0) := 0;
begin
    for v_n in 1 .. v_num loop
        if mod(v_n, 2) = 0 then --������ ���� �Ҷ��� mod�� ����ϴ� ���� ���� ����.
            v_count := v_count + 1;
        end if;
    end loop;
    
    return v_count;
    -- ���ǹ����� �����ְų� exception ���� �����ϰ�� return �ڿ� ������ �� ����.
end;
/

--dual table�� ����ؼ� ��Ű�ڴ�.
--������ �Լ��� ������� Ȯ���ϰ� ������ dual table�� ����� �׳� ���ϴ� ���� �� �� ����.
select get_total_num(47) from dual;

/*1.
���ڸ� �Է��� ��� �Էµ� ���ڱ����� ������ �հ踦 ����ϴ� �Լ��� �ۼ��Ͻÿ�
���� ��) execute dbms_output.put_line(ysdsum(10))
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
    ���� �Ѱ�*/
    
    while v_count <= v_num loop
        v_sum := v_sum + v_count;
        v_count := v_count +1;
    end loop;
    
    return v_sum;
end;
/

execute dbms_output.put_line(ysdsum(10));


/*2.
�����ȣ�� �Է��� ��L ���� ������ �����ϴ� ����� ��µǴ� ydinc �Լ��� �����Ͻÿ�
- �޿��� 5000 �����̸� 20% �λ�� �޿� ���
- �޿��� 10000 �����̸� 15% �λ�� �޿� ���
- �޿��� 20000 �����̸� 10% �λ�� �޿� ���
- �޿��� 20000 �ʰ��� �޿� �״�� ���

����) select last_name, salary, ydinc(employee_id)
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
�����ȣ�� �Է��ϸ� �ش� ����� ������ ��µǴ� yd_func �Լ��� �����Ͻÿ�.
-> ������� : (�޿�+(�޿�*�μ�Ƽ���ۼ�Ʈ))*12
����) select last_name, salary, yd_func(employee_id)
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


--������
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

--�Ϲ� ����
--group decode�� ������.

-----------------null �ٷ��
/*is null | is not null
nvl(), nvl2() nullif(), coalesce() --db������� ����
nvl �� null �� ���� ��ü���ְ� null�� �ƴϸ� ���� ���� ������
nvl2 �� null�� �� A, null�� �ƴϸ� B�� ���¸� ���Ѵ�.
decode() -- oracle������ ��밡�� */
----------------------------------

/*4.
select last_name, subname(last_name)
from employees;
LAST_NAME       SUBNAME(LA
----------      -----------
KING            K***
SMITH           S****

������ ���� ��µǴ� subname �Լ��� �ۼ��Ͻÿ�.
*/

create or replace function subname
(v_name employees.last_name%type)
return varchar2
is
    v_subname employees.last_name%type;
begin
    v_subname := rpad(substr(v_name, 1, 1), length(v_name), '*');
    --v_subname ��ſ� RETURN�� �ٷ� �����൵ �ȴ�.
return  v_subname;
end;
/

select last_name, subname(last_name)
from employees;

--rpad(����, ����, ��ü����) 'K***'
--lpad(����, ����, ��ü����) '***K'

/*2.
�����ȣ�� �Է��ϸ� �Ҽ� �μ����� ����ϴ� y_dept�Լ��� �����Ͻÿ�.
(��, ������ ���� ��� ����ó��(exception)
�Էµ� ����� ���ų� �Ҽ� �μ��� ���� ��� -> ����� �ƴϰų� �Ҽ� �μ��� �����ϴ�.

    �Էµ� ����� ���� ��� -> ����� �ƴմϴ�.
    �Ҽ� �μ��� ���� ��� -> �Ҽ� �μ��� �����ϴ�.

����) execute dbms_output,put_line(y_dep(178))
���) executive

select employee_id, y_dept(employee_id)
from employees;
*/

select e.employee_id, d.department_name
from departments d right outer join employees e
--outer join join�� �������� ���� ��� ���� ���� ���̺��� ���� �ʿ� �ֳ� ���ʿ� �ֳ�
--�Ѵ� ���� ������ full outer ������ �ϸ� �ȴ�.
using(department_id)
order by employee_id;

create or replace function y_dept
(v_empId employees.employee_id%type)
return varchar2
--return �Ǵ� ���� type�� �����ֱ�. --> v_deptName�� Ÿ���� ��������ϴ� ����
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
        return '�Ҽ� �μ��� �����ϴ�.';
    when no_data_found then
        return '����� �ƴմϴ�.';
end;
/

execute dbms_output.put_line(y_dept(10));

select employee_id, y_dept(employee_id)
from employees;

------------------------- join �Ⱦ���
create or replace function y_dept
(v_empId employees.employee_id%type)
return varchar2
--return �Ǵ� ���� type�� �����ֱ�. --> v_deptName�� Ÿ���� ��������ϴ� ����
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
        return '�Ҽ� �μ��� �����ϴ�.';
    when no_data_found then
        return '����� �ƴմϴ�.';
end;
/

