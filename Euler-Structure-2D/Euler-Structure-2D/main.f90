
program main
    use Print_data
    implicit none

    call Grid        !�����ȡ������ȡ���ü��β���
    call Flow_init   !������ʼ��
    call Solver
    
    call Cp_cal
    call Output
end program
