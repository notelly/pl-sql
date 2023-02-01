set serveroutput on
--������ ���̽� �ȿ� �ִ� �ý��� ������ �ٲٴ� ��
--sysout �� �� �ִ°�
--���������� �Ϸ� �Ǿ��µ� ����� �ȵǸ� serveroutput on �ѹ��� �������ֱ�

begin
    dbms_output.put_line('hello world!');
end;
/

--pl/sql�� Ʈ������(?)�� �׻� �ϴ��Ϸ� ��Ī�Ǵ� ���� �ƴϴ�.

-- ��������
-- not null�� ����� �� �� ����. ���� ��ȭ�� �����ϴ�.
-- ����� ������ �Ұ����ϴ�
declare
    v_empId constant number(15,0):= 100;
    v_deptId date;
    v_findId number(15,0) not null := v_empId;
    v_salary number(15,2) default 1000;
begin
    -- ����� ���� �Ұ��� v_empId := 1000;
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
    --���� �ҷ������� �÷��� ������Ÿ���� �״�� ���ڴ�.
begin
    select salary
    into v_sal
    from employees
    where employee_id = &eid;
    
    dbms_output.put_line('�Է��� ����� �޿��� ' || v_sal || ' �Դϴ�.');
end;
/

--����
--no data found�� table�� ���� ���� ��
--select�� ������ŭ into�� ������ ���� ���
--������ �ϳ� ����


begin

    update employees
    set salary = salary * 0.9
    where department_id = 20;
    
    dbms_output.put_line('������ ����� ����� ��: ' || sql%rowcount);
    --insert update delete �� ����Ǿ����� Ȯ���ϱ� ����.
end;
/

rollback;

-- 1. �����ȣ�� �Է��� ��� �ش� ����� ��� ��ȣ, ����̸�, �μ��̸� ����ϴ� pl/sql�� �ۼ��ϼ���
declare
    v_empId employees.employee_id%type;
    v_name employees.last_name%type;
    v_deptName departments.department_name%type;
    --�ش� �÷��� Ÿ���� �״�� ������ ���� ���� ���� ���ϴ�.
    --���� Ÿ�Ժ��� �� ũ�� ������ ���� ���� ����, ������ ��������.
begin
    select e.employee_id, e.last_name, d.department_name
    into v_empId, v_name, v_deptName
    --������ �״�� ��� �ǰ� ���̷��� declare�� �ݵ�� ������ ���־�� �Ѵ�.
    from employees e join departments d
    --using(department_id) �ص� �ǳ���
    on e.department_id = d.department_id
    where e.employee_id = &eid;
    
    dbms_output.put('�����ȣ' || v_empId);
    --sysout.print �ȶ��°�
    
    dbms_output.put_line('�����ȣ�� ' || v_empId || '�� ����� �̸��� ' || v_name ||'�̰� �μ��� '|| v_deptName || '�Դϴ�.');
    --sysout.println ���°�
end;
/

--2. �����ȣ�� �Է�(ġȯ�������)�� ���
--����̸�, �޿�, ������ ����ϴ� pl/sql�� �ۼ��ϼ���

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
    where employee_id = &�����ȣ;
    --ġȯ������ �� & �ڿ� �Է��ϴ� ������ �̸��� �˷��ִ� ����
    --���ϴ� �� �ϰų� ��� �ȴ�. ��� ���� �Ұ�
    dbms_output.put_line(v_name || '�� �޿��� $' || v_salary || '�̰� ������ $' || v_ySalary || '�Դϴ�.');
    
    -- �ٸ� ��ĵ� ������ ���� ����� ����� �̻�����
    -- ī�� �̹��� ����.
    
end;
/

--���ǹ�
declare
    v_empId employees.employee_id%type := &�����ȣ;
    v_jobId employees.job_id%type;
    v_sal employees.salary%type;
begin
    select job_id
    into v_jobId
    from employees
    where employee_id = v_empId;
    --���� ������ ���� ���� ���ϴ� ���� ��ġ�ϴ��� �� ������ ������ �ش�.
    if v_jobId like '%IT%' then
        v_sal := 10000;
    else
        v_sal := 8000;
    end if;
    --else�� ���̸� �����Ǵ� ���� ���� ��.
    DBMS_OUTPUT.PUT_LINE('�����ȣ ' || v_empId || '�� ������ ' || v_jobId || '�̰�'
                        || ' �޿��� ' || v_sal || ' �� ����� �����Դϴ�.');
end;
/

declare
    v_age number(10, 0) not null := &����;
begin
    --if �� ���� �� ���ؿ��� ���Ľ�Ű�� ���������� �����־�� ��.
    if v_age < 8 then -- x < 8
        dbms_output.put_line('������ �Ƶ��Դϴ�.');
    elsif v_age < 14 then -- 8 <= x < 14
        dbms_output.put_line('�ʵ��л� �Դϴ�.');
    elsif v_age < 17 then -- 14 <= x < 17
        dbms_output.put_line('���л� �Դϴ�.');    
    elsif v_age < 20 then -- 17 <= x < 20
        dbms_output.put_line('����л� �Դϴ�.');
    else -- 20 <= x
        dbms_output.put_line('�����Դϴ�.');    
    end if;
    --���������� �ָ� ������ �������� ��Ȯ�ϰ� �ľ��Ͽ����Ѵ�.
end;
/


--3-2 �����ȣ�� �Է�(ġȯ�������)�� ���
--�Ի����� 2005�� ����(2005�� ����)�̸� 'new employee' ���
--       2005�� �����̸� 'Career employee' ���
-- ��, dmbs_output.put_line ~ �� �ѹ��� ����Ѵ�.
-- ������ �̿��ؼ� ���� ���� �־��.

declare
    v_hiredate employees.hire_date%type;
begin
    select hire_date
    into v_hiredate
    from employees
    where employee_id = &�����ȣ;
    
    if to_char(v_hiredate, 'YYYY') >= 2005 then
        dbms_output.put_line('New employee'); 
    else
        dbms_output.put_line('Career employee');
    end if;
end;
/

--������
declare
    v_hiredate employees.hire_date%type;
    v_message varchar(100);
    --���� ������ �ƴ�.
begin
    select hire_date
    into v_hiredate
    from employees
    where employee_id = &�����ȣ;
    
    --2005 ��� �������� �Ȱ� ����Ŭ���� Ÿ�Ժ�ȯ�� �����ֱ� �����̴�.
    --��Ģ�����δ� '2005'�� ���ִ°� �´�.
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
    --���� ������ �ƴ�.
begin
    select hire_date
    into v_hiredate
    from employees
    where employee_id = &�����ȣ;
    
    -- ������ ���Ƽ� �տ� �ߴ��� �����Ѱ���
    -- ������ Ÿ���� ���� �� TO_DATE�� ����ϴ� ���� ���� ��Ȯ�ϴٴ� ���� �˰� ������.
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
--6. �����ȣ�� �Է��� ��� �ش� ����� �����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
-- ��, �ش� ����� ���� ��� "�ش� ����� �����ϴ�."
delete from emp_test
where employee_id = &�����ȣ;
--������ ���� �ƿ��ȴ���. select�� ���������� ������ �ȵȴ�.
--�׷��Լ��� �����.
-- 1) �׷��Լ� : count()
select count(*) from emp_test where employee_id = 0;

declare
    v_empId employees.employee_id%type := &�����ȣ;
    v_count number(1,0);
begin
    select count(*)
    into v_count
    from employees 
    where employee_id = v_empId;
    
    if v_count = 0 then
        dbms_output.put_line('�ش� ����� �����ϴ�.');
    else 
        delete from emp_test
        where employee_id = v_empId;
    end if;
    
end;
/

-- 2) Ŀ��: insert update delete �� ���
-- SQL%ROWCOUNT �ϳ��� ����. FOUND�� NOTFOUND�� ũ�� �ǹ̰� ����.

-- FOUND�� NOTFOUND ��ȯ�� ���� �ִ��Ĵ� �޸� �� �ö󰡰�
-- ����ϰ� �ϴ� �� �� �޸𸮻� �ö󰣰� ��ȯ ��Ű�� ����
-- �� �޸𸮿� ����� �־�� �� �� �ִµ�
-- insert update delete ����� ��ȯ�Ǵ� �� ���� ������ �� ���� ����.

begin
    delete from emp_test
    where employee_id = &�����ȣ;
    
    if SQL%ROWCOUNT = 0 then
         dbms_output.put_line('�ش� ����� �����ϴ�.');
    end if;
end;
/

-- 1���� 10���� ��� ������ ���� ���

-- �⺻ LOOP
-- ������ �ʿ��ϴ�.

declare
    v_counter number(10, 0) := 1;
    -- 1~10���� ������ ����� ����
    v_sum number(10,0) := 0;
    -- �츮�� ������ �ʿ��� ��
begin
    loop 
        v_sum := v_sum + v_counter;
        v_counter := v_counter + 1;
        exit when v_counter > 10;
        -- Ż���ϴ� �����̱� ������ 10�̻� �� �� Ż���ϴ�.
        -- exit�� ������ �������. R. �⺻ ������ �ʼ������� �ƴϱ� ������ ��� �ֵ� �������.
        -- exit �׻� ���ٰ� �����ؾ��Ѵ�.
    end loop;
        dbms_output.put_line(v_sum);
end;
/

-- for loop
--count�� ���� �ӽ� ������ �ֱ� ������

declare
    v_sum number(10,0) := 0;
begin
    -- in�� �������� ���� �ӽú��� ������ ���ʿ� ����� ������ ������ ����
    -- �� 1..10�� �ʿ䰡 ����.
    -- ��� ���� ������ ū ������ �ּҿ��� �ִ��
    -- �Ųٷ� �ϰ� �ʹٸ� in ������ reverse�� �߰� ���ָ� �ȴ�.
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
    --�ݺ� ����
    -- �⺻������ exit when�� ������ �ݴ� ������ while �� loop ���̿� ���� �ȴ�.
    -- �װ��� �����ϰ�� ���� ����� �Ȱ���.
    -- �ε�ȣ ������ ��
    while v_counter <= 10 loop
        v_sum := v_sum + v_counter;
        v_counter := v_counter + 1;
    end loop;
    dbms_output.put_line(v_sum);
end;
/

-- 345 -> 3+4+5 = 12
-- MOD() : �������� ���Ҷ� ����ϴ� �Լ�

--�⺻ LOOP
declare
    v_num number(10, 0) := &����;
    v_sum number(10, 0) := 0;
begin
    loop
        v_sum := v_sum + mod(v_num, 10);
        v_num := floor(v_num / 10);
        --floor = trunc �Ҽ��� ����
        dbms_output.put_line('v_sum: ' ||v_sum|| ', v_num : ' || v_num);
        exit when v_num <= 0;
    end loop;
    dbms_output.put_line('��� : ' || v_sum);
end;
/

declare
    v_num number(10, 0) := &����;
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
1. ������ ���� ��µǵ��� �Ͻÿ�
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
        -- ���鿡�� *�� �ϳ��� �ϳ��� �����鼭 ��� ���
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
    --for �̶�� �ؼ� �� i�� ���� �� �ƴϴ�.
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

--2. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� �ش� �������� ��µǵ��� �Ͻÿ�.
--�⺻ loop
declare
    v_num number(10,0) := &���;
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
    v_num number(10,0) := &���;
begin
    for i in 1..9 loop
        dbms_output.put_line(v_num || '*' || i || '=' || v_num*i);
    end loop;
end;
/
--while loop
declare
    v_num number(10,0) := &���;
    v_count number(2,0) := 1;
begin
    while v_count <=9 loop
         dbms_output.put_line(v_num || '*' || v_count || '=' || v_num*v_count);
          v_count := v_count+1;
    end loop;
end;
/

--������ 2~9�ܱ��� ��µǵ��� �ϼ���.

--�⺻loop
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