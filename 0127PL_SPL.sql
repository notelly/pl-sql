--����

--�̸� ���ǵ� ���� -> �̸��� �����ϴ� ����
declare
    v_emp_id employees.employee_id%type;
begin
    select employee_id
    into v_emp_id
    from employees
    where department_id = 50;
    --���ܶ�� ��� �� ó�����ִ� �� �ƴϴ�
    --������ Ʋ���� �ƿ� ������ �Ұ��� �ϱ� ������ ���ܵ� ������ �ȵȴ�.
    
exception 
    when no_data_found then
        dbms_output.put_line('�ش� �μ��� ���� ����� �����ϴ�.');
    when to_many_rows then
        dbms_output.put_line('�䱸�� ������� �����Ͱ� �����ϴ�.');
    when other then
        dbms_output.put_line('��Ÿ ���� ������ �߻��߽��ϴ�.');
end;
/

--�̸� �������� ���� ���� -> ����� �ϵ� �̸����� ��ȣ�� �����Ǵ� ����
--����Ŭ document�� ��ȣ���� ���� ��������
declare
    e_delete_dept_fail exception;
    pragma exception_init(e_delete_dept_fail, -2292);
    --���� �������� �̸�, ����Ŭ�� ������ �ִ� ��ȣ
    
begin
    delete from departments
    where department_id = &�μ���ȣ;
    
    dbms_output.put_line('���������� �μ��� �����Ǿ����ϴ�.');
exception
    when e_delete_dept_fail then
        dbms_output.put_line('�ش� �μ��� ���� ����� �����մϴ�.');
    
end;
/
--insert delete update Ư���� �����Ͱ� ���� ��� ���ܰ� �߻��ϴ� ���� �ƴ϶� ���� ����Ǹ鼭 0�� ��ȯ�Ǳ� ������
--����Ŭ ���忡���� ���ܶ�� ���� �ʴ´�. �׷��Ƿ� �츮�� ����� ���� ���ܸ� �������־�� �Ѵ�.
--����� ���� ����

declare
    e_no_dept_info exception;
begin
    delete from departments
    where department_id = &�μ���ȣ;
    
    if sql%rowcount = 0 then
        raise e_no_dept_info;
    end if;
    
exception
    when e_no_dept_info then
        dbms_output.put_line('�ش� �μ��� ������ �������� �ʽ��ϴ�.');
end;
/


--���� Ʈ�� �Լ�
declare
--���ܸ� ���� ���� ���� �ʰ� 
    
begin
    delete from departments
    where department_id = &�μ���ȣ;
    
    dbms_output.put_line('���������� �μ��� �����Ǿ����ϴ�.');
exception
    when no_data_found then
        dbms_output.put_line('�ش� ������ �����ϴ�.');
    when others then
        dbms_output.put_line('������ȣ : ' || sqlcode);
        dbms_output.put_line('���� �޼��� : ' || sqlerrm);
end;
/

rollback;
create table log_table
(code number(10),
message varchar2(200),
info varchar(200));


--�󿩱��� �޴µ� �� �󿩱��� ���޺��� ������ Ȯ���ϰڴ�.

declare
    cursor emp_cursor is
        select employee_id, first_name, salary
        from employees
        where department_id = &�μ���ȣ;
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
    
    dbms_output.put_line('���� �μ��� �ο��� ' || emp_cursor%rowcount || '�� �̰�' ||
                         '������ �� �ݾ��� ' || (5000*emp_cursor%rowcount) || '�޷��Դϴ�.');

exception
    when e_too_many_comm then
      insert into log_table
      values(v_error_code, '���� �μ��� �󿩱��� �޿����� ���� ����� �����մϴ�.', null);
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
        where department_id = &�μ���ȣ;
    exception
        when no_data_found then
           dbms_output.put_line('���� �μ����� �ٹ��ϴ� ����� �����ϴ�.');
    end;
    
    dbms_output.put_line('���� PL/SQL�� ���� �Ǿ����ϴ�.');
exception
    when too_many_rows then
        --dbms_output.put_line('�� ���� �ʰ��Ͽ� ����� ��ȯ�߽��ϴ�.');
        raise_application_error(-20201, 'TEST ERROR MESSAGE');
        
-- ����/���ܰ� �߻��ϸ� �ٷ� �����.
-- exception ���� �ͼ� �ִ°��� ����.
end;
/

/*2.
��� ���̺��� �����ȣ�� �Է�(&���)�޾�
10% �λ�� �޿��� �����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
��, 2005��(����) ���� �Ի��� ����� �������� �ʰ�
"2005�� ���� �Ի��� ����Դϴ�." <- exception �� ���
��� ��µǵ��� �Ͻÿ�.
*/


declare
    e_over_date exception;
begin

    update employees
    set salary = (salary*1.1)
    where employee_id = &�����ȣ
    and hire_date < to_date('2005-01-01', 'yyyy-mm-dd');
    
    if sql%rowcount = 0 then
        raise e_over_date;
    end if;
        
exception
    when e_over_date then
        dbms_output.put_line('2005�� ���� �Ի��� ��� �Դϴ�.');
end;
/

/*3-1
��� ���̺��� �μ���ȣ�� �Է�(&���)�޾� <- cursor ���
10% �λ�� �޿��� �����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
��, 2010�� ���� �Ի��� ����� �������� �ʰ� 
"2010�� ���� �Ի��� ����� ���ŵ��� �ʽ��ϴ�." <- ���� �� ��� ��� ��µǵ��� �Ͻÿ�*/

declare
    cursor emp_cursor is
        select *
        from employees
        where department_id = &�μ���ȣ
        order by hire_date;
        -- order by �� �����ؼ� insert �Ǵ� ������ ������ ��.
        
        emp_record emp_cursor%rowtype; 
    e_over_date exception;
begin
    open emp_cursor;
    loop
        fetch emp_cursor into emp_record;
        exit when emp_cursor%notfound;
        update employees
        set salary = (salary*1.1)
        --Ŀ���� ���྿ ������ �´�. ������ �ٲ� ���� �ʿ��� �� ���� employee_id�� ������ �ͼ� ������ �����ش�.
        where employee_id = emp_record.employee_id
        and hire_date < to_date('2005-01-01', 'yyyy-mm-dd');
        
        
        --if ���ǿ� hire_date~ �κ��� �־ �ȴ�. 2��° ���
        if sql%rowcount = 0 then
            dbms_output.put_line(emp_record.last_name);
            raise e_over_date;
        end if;  
         
    end loop;

exception -- �̷��� �Ǹ� �������� rollback���� ���� / ���ܸ� ������ �������� �Ǹ鼭 rollback ��
    when e_over_date then
        dbms_output.put_line('2005�� ���� �Ի��� ����� ���ŵ��� �ʽ��ϴ�.');
    close emp_cursor;
end;
/


ROLLBACK;

--���ν���
-- or replace�� �ǵ����̸� ��������
create or replace procedure test_procedure
( v_message in varchar2 )
is
    e_test_data exception;
begin 
    --�Ű������� ���� �޼����� ���޹޾� ����ϴ� ���ν���
    --v_message := '���� �����Ͽ����ϴ�';
    --���������
    -- in �ȿ� ���� ���� ���� ������ �ۿ��� �������־���Ѵ�.
    if v_message is not null then
      dbms_output.put_line(v_message);   
      dbms_output.put_line('���������� ����Ǿ����ϴ�.');
    else
        raise e_test_data;
    end if;
exception
    when e_test_data then
         dbms_output.put_line('�޼����� �Է����� �ʾҽ��ϴ�.');
end;
/
-- ���� �����ϸ� 'Procedure TEST_PROCECURE��(��) �����ϵǾ����ϴ�.' ������ ���´�.

begin
    test_procedure('HELLO WORLD!');
    --test_procedure(null);
end;
/

execute test_procedure('Moments Today');
execute test_procedure(to_char(sysdate, 'yyyy"��"') || '�� ���䳢���Դϴ�.');
--���ν����� dml insert, delete, update ����� �Ұ����ϴ�.


create or replace procedure query_emp_info
( v_id in employees.employee_id%type,
  v_name out employees.first_name%type,
  v_sal in out employees.salary%type,
  --������ �ִ� out�� in�� �߰��ϸ� ��� �ɱ�
  --���ν��������� �Ű������� �߿��� ������ �Ѵ�.
  --���� ��带 �������� �����δ�.
  -- out, in out ������ ���������Ѵ�. ������ �ƴ϶� ���� ��������� ������ ���� �ʴ´�.
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
    v_eid employees.employee_id%type := &�����ȣ;
    v_ename employees.first_name%type;
    v_sal employees.salary%type not null := 1000;
    v_comm employees.commission_pct%type;
begin
    query_emp_info(v_eid, v_ename, v_sal, v_comm);
    
    dbms_output.put_line('�����ȣ : ' || v_eid);
    dbms_output.put_line('- �̸� : ' || v_ename);
    dbms_output.put_line('- �޿� : ' || v_sal);
    dbms_output.put_line('- �󿩱� : ' || v_comm);
    
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
    v_phone varchar2(13) := '&����ó';
    --'&����ó' ���δ� ���� ���ڰ� �ƴ϶� ���ڷ� �޾ƿ�����
    -- ���ڷ� �޾ƿ��� 0�� ���ư���.
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

--���ν��� ����
drop procedure query_find_emp;
