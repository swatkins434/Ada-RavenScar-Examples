with Ada.Text_IO;
with Ada.Real_Time;
with Ada.Execution_Time;
use Ada.Text_IO;
use type Ada.Real_Time.Time_Span;
use type Ada.Execution_Time.CPU_Time;

procedure arts11 is
    procedure finiteWork(cycles : Integer) is
        f : Duration := 0.0;
        i : Integer := 0;
    begin -- finiteWork
        Put_Line("Working");
        loop
            i := i + 1;
            f := 0.0;
            for j in 1 .. 10000 loop
                f := f + Duration(j * 10.0);
            end loop;
            exit when i = cycles;
        end loop;
    exception
        when others =>
            Put_Line("Unexpected Exception");
    end finiteWork;

    task worker;

    task body worker is
        startTime : Ada.Execution_Time.CPU_Time;
        finalTime : Ada.Execution_Time.CPU_Time;
        timeTaken : Ada.Real_Time.Time_Span;
    begin -- worker
        for i in 1 .. 10 loop
            startTime := Ada.Execution_Time.Clock;
            finiteWork(i * 1000);
            finalTime := Ada.Execution_Time.Clock;

            timeTaken := finalTime - startTime;

            Put_Line("Cycles worked for:" & Integer'Image(i) &
                     " | Time taken:" & Duration'Image(Ada.Real_Time.To_Duration(timeTaken)));
        end loop;
    end worker;

begin -- arts11
    null;
end arts11;
