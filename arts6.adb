with Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
use Ada.Text_IO;

procedure arts6 is
    -- This is used to create random delays for each task
    subtype Delay_Time is Integer range 1 .. 4;
    package Random_Integer is new Ada.Numerics.Discrete_Random(Delay_Time);

    type clientID is new integer range 1..6;
    type clientBools is array(clientID) of Boolean;

    protected barrier is
        entry waitOnBarrier(id : in clientID);
    private
        entry releaseCond(clientID'range)(id : in clientID);
        waiting : clientBools := (others => False); -- Initialize to False for every element.
        arrivedCount : integer := 0;
    end barrier;

    protected body barrier is
        entry waitOnBarrier(id : in clientID) when True is -- Accept everything
        begin
            arrivedCount := arrivedCount + 1;

            -- If arrivedCount is now equal to the number of clientIDs then we
            -- know they have all arrived so unlock the first task. This allows
            -- us to release each task in order.
            if arrivedCount = integer(clientID'Last) then
                waiting(1) := True;
            end if;

            requeue releaseCond(id) with abort; -- We want to ensure that the clients can still timeout.
        end waitOnBarrier;

        entry releaseCond(for i in clientID'range)(id: in clientID) when waiting(i) is -- Wait until all previous tasks have run.
        begin
            Put_Line("Client" & clientID'image(id) & " being released from barrier");

            -- Re-Lock the current task
            waiting(i) := False;

            -- Unlock the next task
            if i /= clientID'Last then
                waiting(clientID'Succ(i)) := True;
            end if;
        end releaseCond;
    end barrier;

    task type client(id : clientID);

    task body client is
        Gen : Random_Integer.generator;
        Random_Int : Integer;
    begin
        Random_Integer.Reset(Gen, integer(id));
        Random_Int := Random_Integer.Random(Gen);
        Put_Line("Task" & clientID'Image(id) & " Random delay is" & Integer'Image(Random_Int));
        delay Random_Int * 1.0;

        Put_Line("Client" & clientID'image(id) & " waiting at barrier");
        select
            barrier.waitOnBarrier(id);
        or delay 4.0; -- Random delay could be up to 10 so we want to timeout at that point.
            Put_Line("Client" & clientID'image(id) & " timed out");
        end select;
    end client;
    
    client1 : client(1);
    client2 : client(2);
    client3 : client(3);
    client4 : client(4);
    client5 : client(5);
    client6 : client(6);
begin
    null;
end arts6;
