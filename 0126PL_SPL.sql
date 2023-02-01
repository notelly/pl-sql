--�̰� �׻� �� ���� �����ֱ�.
set serveroutput on
--4. ������ 1~9�� ���� ��µǵ��� �Ͻÿ�
--(��, Ȧ���� ���)

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

--������
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
     emp_salary number(20,2) not null := 1000); --field�� �����ϸ� �ȴ�.
     
     --record table�̵� �̸��� type���� ������ �ϸ� ���� ���ϴ�.
     emp_record emp_record_type;
begin
    --dbms_output.put_line(emp_record);
    --�̴�� �����ϸ� ������ ����.
    --R: �� ������� ���� ������ ���� ��.
    --record�� table�� ����� ���� �Ʒ��� ���� �� ������� �������־���Ѵ�.
    --dbms_output.put_line(emp_record.emp_salary);
    
    --��� ��Į�� Ÿ�� ������� select �� ���ָ� ���������� ������ �������� �ʾƵ� ���� �޾ƿ� �� �ִ�.
    select employee_id, first_name, salary
    into emp_record
    from employees
    where employee_id = 200;
    
    dbms_output.put_line(emp_record.emp_id);
    dbms_output.put_line(emp_record.emp_name);
    dbms_output.put_line(emp_record.emp_salary);
    --�̸��� ������� ���ڵ带 �����ϴ� Ÿ�� ������� �����ָ� �ȴ�.
    
end;
/

declare
    emp_record employees%ROWTYPE;
    --������ ���ؼ� record type�� ���� �״�� �ѱ���� �Ѵ�.
    -- �Ǵٸ� ������ �����Ϸ��� type ������ ����Ѵ�.
    --recordtype���� �ѹ� ���� �Ǿ� ������ �´� �� record type�̴�
    --rowtype�� �� �� ����.
    --�÷��� ������ �޾ƿ��� ���̱� ������ ������ ���ϸ� Ÿ���� �ƴϴ�.
    --rowtype���� �Ѱ���µ� �ȵǸ� row�� �غ� ��.
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
            --index�� �ʿ��ϴ�/.
            v_total_data(v_counter) := v_counter;

            --���η� index��
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
--���� ������ ����, ���������� ���� ���� �ʾƼ�.

-- employees ���̺� ��� ���� �ϳ��� ���̺� Ÿ������ ��������.
-- employee_id : primary key ( unique, not null )+ 0, ���
--             => min, max (id�� ������ �մ� �ִ밪�� �ּҰ����� for���� ������ �ȴ�.)
select *
from employees;

declare
    v_min employees.employee_id%type;
    v_max employees.employee_id%type;
    v_count number(1,0);
    emp_record employees%rowtype;
    
    --������ �ϰ� ���� �� >> for�� ������ ������ �������
    --��� �����͸� �ϳ��� ������ ��������
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
        --�ش� for���� ������ ���ο� loop�� �����ؾ��Ѵ�.
        for v_index in emp_table.first .. emp_table.last loop
            if emp_table.exists(v_index) then
            --�ش� ���̺��� ��ü index�� ������ ������ ���� �ʵ�� �������� ������ ������ ���� �� ���� �߰������� ��������Ѵ�.
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
    -- into ����
    -- select (employee_id, first_name, job_id)���� ��� �÷��� ���� �� �� �ֵ��� ��������Ѵ�.
    -- select �÷� ����ó�� ���������� ���� �־�� �Ѵ�.
    
    loop
        -- ���� ���� �������� loop
        fetch emp_cursor into v_emp_id, v_emp_name, v_job;
        dbms_output.put_line(v_emp_id);
        dbms_output.put_line(v_emp_name);
        dbms_output.put_line(v_job);
        v_counter := v_counter +1;
        exit when v_counter >3;
    end loop;
    dbms_output.put_line('---');
    close emp_cursor;
    --close���� �� open �� �� ����. close�� ������ ���־���Ѵ�.
    open emp_cursor;
    v_counter :=1;
    loop
        --���������� �÷��� ��� ���� ���� �Ұ����ϴ�. select �� �÷��̶� �Ȱ��� �����Ѵ�.
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
        --cursor�� exit when�̶� ���� �����δ�.
        exit when emp_cursor%rowcount >3;
        
        dbms_output.put_line(v_emp_id);
        dbms_output.put_line(v_emp_name);
        dbms_output.put_line(v_job);
        
    end loop;
    
    close emp_cursor;
    
    if not emp_cursor%isopen then
    --open = true
        open emp_cursor;
        --already open => �ݴ�� ���� �Ǳ⸦ ���� if�� not�߰�
    end if;
    dbms_output.put_line('---');
    
    loop
        fetch emp_cursor into v_emp_id, v_emp_name, v_job;
        --cursor�� exit when�̶� ���� �����δ�.
        --xit when emp_cursor%rowcount >3;
        --������ ����ϰ� ���� �� 
        exit when emp_cursor%notfound;
        
        dbms_output.put_line(v_emp_id);
        dbms_output.put_line(v_emp_name);
        dbms_output.put_line(v_job);
        
    end loop;
    
    if not emp_cursor%isopen then
    --open = true
        open emp_cursor;
        --already open => �ݴ�� ���� �Ǳ⸦ ���� if�� not�߰�
    end if;
    dbms_output.put_line(emp_cursor%rowcount);
    --�ݱ�� ���� �ϸ� ���� ������ �� �� �ִ�.
    close emp_cursor;
    --dbms_output.put_line(emp_cursor%rowcount);
    --invalid cursor
    --notfound �Ӽ��� �������. ���� Ŀ���� ���ؼ� ���� �ϰ� �Ǹ�
    --�� ������ ���.
end;
/

--�����غ���
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
        --���� ���� �� ��.
        
        dbms_output.put_line(v_eid);        
        
    end loop;
    --��ȯ�� ���� ����.
    --close�Ǳ� ���� rowcount�� �̿��ؼ� �� ������ ���� �� �� �ִ�.
        if emp_cursor%rowcount = 0 then
        dbms_output.put_line('���� �������� �ʽ��ϴ�.');
        end if;
    close emp_cursor;
end;
/

-- employees ���̺� ��� ���� �ϳ��� ���̺� Ÿ������ ��������.
-- cursor�� ���� ����
-- 1) employees ���̺� �ִ� ��� ���� 
declare
    cursor all_emp_cursor is
        select *
        from employees
        order by employee_id;
    
    emp_record employees%rowtype;
    
    type emp_table_type is table of employees%rowtype
        index by binary_integer;
    --������ ����Ϸ��� ������ ������ �־���Ѵ�.
    emp_table emp_table_type;
begin

open all_emp_cursor;
    loop
        fetch all_emp_cursor into emp_record;
        exit when all_emp_cursor%notfound;
        
        --all_emp_cursor%rowcount >> ���������� ���� �ְ� ���� ��/�����ϴ� �� �ƴ�
        --�ٵ� primary key�� �ִ°� �� ���ϱ� �ϴ�.
        emp_table(all_emp_cursor%rowcount) := emp_record;
        
    end loop;
    
    close all_emp_cursor;
    
    -- ���� �ܿ��
    for v_index in emp_table.first .. emp_table.last loop
        if not emp_table.exists(v_index) then
            continue;
        end if;
        --�ʹ� ��� ���� �ᵵ ������.
        dbms_output.put_line(emp_table(v_index).employee_id || ', ' || emp_table(v_index).first_name);
    end loop;
    
end;
/

declare
    --��ü ��ȯ�� ����ų ���� for loop �� ���� �����ϴ�.
    cursor all_emp_cursor is
        select * from employees;
begin
    --emp_record�� �ӽú��� all_emp_cursor <= Ŀ��
    --Ŀ���� Ȱ�����տ��� �ڵ����� ��ȯ�ϸ鼭 emp_record�� ���Ե�.->���->end loop->���� ��->�ݺ�
    --���� �����ϸ� �����Ѵ�.
    for emp_record in all_emp_cursor loop
        dbms_output.put_line(emp_record.employee_id || ', ' || emp_record.first_name);
    end loop;
    --������ �ݺ����� ����� ������ ������ �� �� ���ٴ� ��.
    --dbms_output.put_line(all_emp_cursor%rowcount);
    --���̻� Ŀ���� �����������
    --�ڵ������� close���� ���ֱ� ������.
end;
/

begin
    --for emp_record in all_emp_cursor loop
    --���⼭ all_emp_cursor �� sql���� ������ �ִ� ����.
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
    --cursor for loop�� ����ϸ� ���� ���� ���� ��� �ִ� �͵� �Ұ����ϴ�.
end;
/

--�Ű������� ����� ����
select e,first_name, d.department_name, e.hire_date
from employees e join departments d
on e.department_id = d.department_id
where e.department_id = 90
    and to_char(e.hire_date, 'yyyy') = '2018';

declare
    cursor emp_info_cursor
        (v_deptno number, v_hire_year varchar2)
        --����ϰ��� �ϴ� �Ű������� ������ �ָ� �ȴ�.
    is
        select e.first_name, d.department_name, e.hire_date
        from employees e join departments d
        on e.department_id = d.department_id
        where e.department_id = v_deptno
          and to_char(e.hire_date, 'yyyy') = v_hire_year;
    
    emp_info_record emp_info_cursor%rowtype;
begin
    --�ش� �Ű������� �������־���Ѵ�.
    
    open emp_info_cursor(50, '2005'); --�Ű������� �ѱ��
    
   -- open emp_info_cursor(80, '2018'); --���µ� ���¿��� ����� �Ұ� �̷��� �ϸ� �ȵ�
   -- ���ο� �Ű������� �ϰ� �ʹٸ� close�� ���� �ٽ� open
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

--cursor for loop�� ��� �Ű����� ������ ����� ����
declare
    cursor emp_info_cursor
        (v_deptno number, v_hire_year varchar2)
        --����ϰ��� �ϴ� �Ű������� ������ �ָ� �ȴ�.
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

--for update���� where currnet of ��

--�󿩱��� �ְų� �޿� ���� => update �� �ʿ�
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
            --update�� �Ǵ� ������ employees��� �� ��������
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


--��� ���̺��� �����ȣ, �̸�, �Ի翬��, �μ���ȣ�� ���� ���ؿ� �°� ���� ���̺� �Է��Ͻÿ�

-- 1) �Ի�⵵�� 2005��(����) ���� �Ի��� ����� test01 ���̺� �Է�
-- �Ի�⵵�� 2005�� ���� �Ի��� ����� test02 ���̺� �Է� 
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

--loop ���
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