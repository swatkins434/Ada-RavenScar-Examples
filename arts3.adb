with Ada.Text_IO;
use Ada.Text_IO;

procedure arts3 is
    type numberArray is Array(0 .. 9) of Integer;
    unsafeNumbers : numberArray;
begin
    declare    
        task writeOnes;
        task writeSevens;

        task body writeOnes is
        begin
            for i in 0 .. 9 loop
                unsafeNumbers(i) := 1;
            end loop;
        end writeOnes;

        task body writeSevens is
        begin
            for i in 0 .. 9 loop
                unsafeNumbers(i) := 7;
            end loop;
        end writeSevens;

    begin
        null;
    end;

    for i in 0 .. 9 loop
        Put_Line(Integer'image(unsafeNumbers(i)));
    end loop;
end arts3;
