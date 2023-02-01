set serveroutput on


/*1.
�μ���ȣ�� �Է��� ���(&ġȯ���� ���)
�ش��ϴ� �μ��� ����̸�, �Ի�����, �μ����� ����Ͻÿ�.
(��, cursor ���)
*/

declare
    cursor emp_cursor is
    select e.last_name, e.hire_date, d.department_name
    from employees e join departments d
    using (department_id)
    where department_id = &�μ���ȣ;
    
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
�μ���ȣ�� �Է�(&���)�ϸ� 
�Ҽӵ� ����� �����ȣ, ����̸�, �μ���ȣ�� ����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
(��, CURSOR ���)
*/

declare
    cursor emp_cursor is
    select employee_id, last_name, department_id
    from employees
    where department_id = &�μ���ȣ;
    
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
�μ���ȣ�� �Է�(&���)�� ��� 
����̸�, �޿�, ����->(�޿�*12+(�޿�*nvl(Ŀ�̼��ۼ�Ʈ,0)*12))
�� ����ϴ�  PL/SQL�� �ۼ��Ͻÿ�.
(��, cursor ���)
*/
declare
    cursor emp_cursor is
    select last_name, salary, salary*12+(salary*nvl(commission_pct, 0)*12) ysalary
    from employees
    where department_id = &�μ���ȣ;
    
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
