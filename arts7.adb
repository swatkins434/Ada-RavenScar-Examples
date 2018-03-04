-- Set up the appropriate dispatching policy
pragma Task_Dispatching_Policy(FIFO_Within_Priorities);

with Ada.Text_IO;
with System;
with Ada.Real_Time;
use Ada.Text_IO;
use Ada.Real_Time;

procedure arts7 is
    task smallPeriodicTask with Priority => System.Priority'First + 5;
    task slowTask with Priority => System.Priority'First;

    startTime : Time := Clock + Milliseconds(100);

    task body smallPeriodicTask is
        nextRelease : Time := startTime;
        -- The practical asked for a period of 100 milliseconds but the solution
        -- has a period of 900 milliseconds, I've set it to 900 so the output is
        -- the same. This was essentially so that I knew I had the right
        -- implementation.
        releaseInterval : Time_Span := Milliseconds(900);
        releaseCount : Integer := 0;
    begin
        nextRelease := nextRelease + releaseInterval;
        loop
            delay until nextRelease;
            releaseCount := releaseCount + 1;
            Put_Line("Small task has run" & Integer'image(releaseCount) & " time(s).");
            nextRelease := nextRelease + releaseInterval;
            exit when releaseCount = 10;
        end loop;
    end smallPeriodicTask;

    task body slowTask is
        I : Integer := 0;
        J : Integer := 0;
    begin
        delay until startTime;
        Put_Line("Slow task starting.");
        loop
            loop
                J := J + 1;
                exit when J = 11000000;
            end loop;
            J := 0;
            I := I + 1;
            Put_Line("Slow task still running...");
            exit when I = 300;
        end loop;
    end slowTask;

begin
    null;
end arts7;
