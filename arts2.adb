with Ada.Text_IO;
use Ada.Text_IO;

procedure arts2 is
    task NumberPrinter;
    task CharacterPrinter;

    task body NumberPrinter is
    begin
        for x in Integer range 1 .. 100 loop
            Put_Line(Integer'image(x));
        end loop;
    end NumberPrinter;

    task body CharacterPrinter is
    begin
        for c in Character range 'a' .. 'z' loop
            Put_Line(Character'image(c));
        end loop;
        for c in Character range 'A' .. 'Z' loop
            Put_Line(Character'image(c));
        end loop;
    end CharacterPrinter;
begin
    null;
end arts2;
