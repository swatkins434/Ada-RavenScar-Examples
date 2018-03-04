with Ada.Text_IO;
use Ada.Text_IO;

procedure arts10 is
    protected controlledInterrupt is
        entry wait;
        procedure interruptAll;
    private
        go : Boolean := false;
    end controlledInterrupt;

    protected body controlledInterrupt is
        entry wait when go is
        begin -- wait
            go := false;
        end wait;

        procedure interruptAll is
        begin -- interruptAll
            go := true;
        end interruptAll;
    end controlledInterrupt;

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
    task boss;

    task body worker is
    begin -- worker
        select
            controlledInterrupt.wait;
            Put_Line("Stopping because controlledInterrupt was released.");
        then abort
            infiniteWork;
            Put_Line("Somehow managed to complete infinite work.");
        end select;
    end worker;

    task body boss is
    begin -- boss
        delay 1.0;
        controlledInterrupt.interruptAll;
    end boss;

begin -- arts10
    null;
end arts10;
