with Ada.Text_IO;
use Ada.Text_IO;

procedure arts4 is
    type NumberArray is array(0 .. 9) of integer;
    safeNumbers : NumberArray;

    protected ArrayController is
        entry WriteOne(pos : in integer);
        entry WriteSeven(pos : in integer);
    private
        lastNum : integer := 0;
        count : integer := 0;
    end ArrayController;

    protected body ArrayController is
        entry WriteOne(pos : in integer) when lastNum /= 1 is
        begin
            safeNumbers(pos) := 1;
            if count = 0 then
                lastNum := 1;
                count := count + 1;
            else
                count := 0;
            end if;
        end WriteOne;

        entry WriteSeven(pos : in integer) when lastNum /= 7 is
        begin
            safeNumbers(pos) := 7;
            if count = 0 then
                lastNum := 7;
                count := count + 1;
            else
                count := 0;
            end if;
        end WriteSeven;
    end ArrayController;

begin
    -- Wait for all tasks to complete.
    declare
        task writeOne;
        task writeSeven;

        task body writeOne is
        begin
            for pos in 0 .. 9 loop
                ArrayController.WriteOne(pos);
            end loop;
        end writeOne;

        task body writeSeven is
        begin
            for pos in 0 .. 9 loop
                ArrayController.WriteSeven(pos);
            end loop;
        end writeSeven;
    begin
        null;
    end;
    
    for pos in 0 .. 9 loop
        Put_Line(Integer'image(safeNumbers(pos)));
    end loop;
end;
