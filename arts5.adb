with Ada.Text_IO;
use Ada.Text_IO;

procedure arts5 is
    type clientID is new integer range 1..6;

    protected barrier is
        entry waitOnBarrier(id : in clientID);
    private
        entry releaseCond(id : in clientID);
        releaseID : clientID := 3;
        locked : boolean := True;
    end barrier;

    protected body barrier is
        entry waitOnBarrier(id : in clientID) when True is -- Accept everything
        begin
            if id = releaseID then
                locked := False;
            end if;

            requeue releaseCond with abort; -- We want to ensure that the clients can still timeout.
        end waitOnBarrier;

        entry releaseCond(id: in clientID) when not locked is -- Allow everything in when we are not locked.
        begin
            Put_Line("Client" & clientID'image(id) & " being released from barrier");

            -- Re-lock the barrier when we have run out of tasks to release
            if releaseCond'count = 0 then
                locked := True;
            end if;
        end releaseCond;
    end barrier;

    task type client(id : clientID);

    task body client is
    begin
        Put_Line("Client" & clientID'image(id) & " waiting at barrier");
        select
            barrier.waitOnBarrier(id);
            Put_Line("Client" & clientID'image(id) & " released from barrier");
        or delay 3.0;
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
end arts5;
