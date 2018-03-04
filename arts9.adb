with Ada.Text_IO;
use Ada.Text_IO;

procedure arts9 is
    procedure infiniteWork is
        F : Duration := 0.0;
    begin -- infiniteWork
        Put_Line("Working.");
        loop
            F := 0.0;
            for J in 1 .. 10000 loop
                F := F + 1.11;
            end loop;
            Put_Line("Still Working.");
        end loop;
    exception
        when others =>
            Put_Line("Unexpected exception in call to infiniteWork.");
    end infiniteWork;

    task worker;

    task body worker is
    begin -- worker
        select
            delay 1.0;
            Put_Line("Aborted after 1 second.");
        then abort
            infiniteWork;
            Put_Line("Somehow managed to complete infinite work.");
        end select;
    end worker;
begin -- arts9
    null;
end arts9;
