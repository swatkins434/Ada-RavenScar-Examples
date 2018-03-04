-- Set up the appropriate dispatching policy
pragma Task_Dispatching_Policy(FIFO_Within_Priorities);

with Ada.Text_IO;
with System;
with Ada.Real_Time;
with Ada.Real_Time.Timing_Events;
use Ada.Text_IO;
use Ada.Real_Time;
use Ada.Real_Time.Timing_Events;

procedure arts8 is
    TE : aliased Timing_Event;

    task smallPeriodicTask with Priority => System.Priority'First + 5;
    task slowTask with Priority => System.Priority'First;

    startTime : Time := Clock + Milliseconds(100);

    protected releaser is
        entry waitForRelease;
        procedure release(event : in out Timing_Event);
    private
        timeToGo : Boolean := False;
        nextRelease : Time := startTime;
        releaseInterval : Time_Span := Milliseconds(100);
    end releaser;

    protected body releaser is
        entry waitForRelease when timeToGo is
        begin
            timeToGo := False;
        end waitForRelease;

        procedure release(event : in out Timing_Event) is
        begin
            nextRelease := nextRelease + releaseInterval;
            timeToGo := True;
            TE.Set_Handler(nextRelease, releaser.release'Unrestricted_Access);
        end release;
    end releaser;

    task body smallPeriodicTask is
        releaseCount : Integer := 0;
    begin
        TE.Set_Handler(startTime, releaser.release'Unrestricted_Access);
        loop
            releaser.waitForRelease;
            releaseCount := releaseCount + 1;
            Put_Line("Small task has run" & Integer'image(releaseCount) & " time(s).");
            exit when releaseCount = 100;
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
end arts8;
