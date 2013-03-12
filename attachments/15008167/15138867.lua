timer.start()
require "oatWrapper"
m = require "Monitoring"
start_agent()

function printmem()
   for i = 0, 5 do
      collectgarbage("collect")
   end
   print("gcinfo:",collectgarbage("count"))
   print("inserted values", #m.user.modbus.sdb1:data().ts)
end

running = true

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- NR 1

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------
-- Modbus request: periodic reading task
-----------------------------------------------------------
script=[[local modbus = loadmodule('modbus');
    if not user.modbus then user.modbus = {} end
    if not user.modbus.instance then user.modbus.instance = modbus.new() end;
    if not user.modbus.instance then print('modbus error'); return nil, 'Modbusmodule can not be loaded'; end;

    user.readwords = 20
    user.modbus.sdb1 = newsdb({'ts', 'w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8', 'w9', 'w10', 'w11', 'w12', 'w13', 'w14', 'w15', 'w16', 'w17', 'w18','w19','w20'},500)
    user.modbus.sdb2 = newsdb({'ts', 'w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8', 'w9', 'w10', 'w11', 'w12', 'w13', 'w14', 'w15', 'w16', 'w17', 'w18','w19','w20'},500)
    user.modbus.sdb3 = newsdb({'ts', 'w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8', 'w9', 'w10', 'w11', 'w12', 'w13', 'w14', 'w15', 'w16', 'w17', 'w18','w19','w20'},500)
    user.modbus.sdb4 = newsdb({'ts', 'w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8', 'w9', 'w10', 'w11', 'w12', 'w13', 'w14', 'w15', 'w16', 'w17', 'w18','w19','w20'},500)
    user.modbus.sdb5 = newsdb({'ts', 'w1', 'w2', 'w3', 'w4', 'w5', 'w6', 'w7', 'w8', 'w9', 'w10', 'w11', 'w12', 'w13', 'w14', 'w15', 'w16', 'w17', 'w18','w19','w20'},500)

    local function action()
        print('reading modbus registers')
        local words, err = user.modbus.instance:read_holding_registers(1,8,user.readwords);
        if not words and err then print('nr1 read error',err);return; end
        user.nr1reg1 = words[1]
        user.nr1reg2 = words[2]
        user.nr1reg3 = words[3]
        user.nr1reg4 = words[4]
        user.nr1reg5 = words[5]
        table.insert(words,1, time())
        user.modbus.sdb1:addrecord(words)
        words = nil

        words, err = user.modbus.instance:read_holding_registers(1,10,user.readwords);
        if not words and err then print('nr2 read error',err) return; end
        user.nr2reg1 = words[1]
        user.nr2reg2 = words[2]
        user.nr2reg3 = words[3]
        user.nr2reg4 = words[4]
        user.nr2reg5 = words[5]
        table.insert(words,1, time())
        user.modbus.sdb2:addrecord(words)
        words = nil

        words, err = user.modbus.instance:read_holding_registers(1,12,user.readwords);
        if not words and err then print('nr3 read error',err) return; end
        user.nr3reg1 = words[1]
        user.nr3reg2 = words[2]
        user.nr3reg3 = words[3]
        user.nr3reg4 = words[4]
        user.nr3reg5 = words[5]
        table.insert(words,1, time())
        user.modbus.sdb3:addrecord(words)
        words = nil

        words, err = user.modbus.instance:read_holding_registers(1,14,user.readwords);
        if not words and err then print('nr4 read error',err) return; end
        user.nr4reg1 = words[1]
        user.nr4eg2 = words[2]
        user.nr4reg3 = words[3]
        user.nr4reg4 = words[4]
        user.nr4reg5 = words[5]
        table.insert(words,1, time())
        user.modbus.sdb4:addrecord(words)
        words = nil

        words, err = user.modbus.instance:read_holding_registers(1,16,user.readwords);
        if not words and err then print('nr4 read error',err) return; end
        user.nr5reg1 = words[1]
        user.nr5eg2 = words[2]
        user.nr5reg3 = words[3]
        user.nr5reg4 = words[4]
        user.nr5reg5 = words[5]
        table.insert(words,1, time())
        user.modbus.sdb5:addrecord(words)

    end;
connect(onperiod(10), action)]]
print(m.addscript("readtask1",script))


function periodicgc()
    local t = timer.new(-5)
    while running do
        wait(t,"*")
        printmem()
    end
end
run(periodicgc)

----------------------------------------------------
-- Modbus request 1 : event if reg1 change
----------------------------------------------------
script=[[
    local function action()
        print('fire event 101: new value nrreg1')
        local event = {{timestamp = time(), code = 101, data = user.nr1reg1}};
        sendevents('nr1reg1',event); connecttoserver(); connecttoserver();
    end;
connect(onchange('user.nr1reg1'), action);]]
print(m.addscript("nr1reg1event",script))

-----------------------------------------------------------
-- event if threshold on reg2->5
-----------------------------------------------------------
for i=2, 5 do
    script=[[
        local function action()
            print('fire event 102: new value nr1reg]] .. i .. [[')
            local event = {{timestamp = time(), code = 102, data = user.nr1reg]].. i .. [[}};
            sendevents('nr1reg]] .. i ..[[',event); connecttoserver(); connecttoserver();
        end;
        connect(onthreshold(500,'user.nr1reg]] .. i .. [['), action);
    ]]
    print(m.addscript("nr1reg"..i.."treshold",script))
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- NR 2

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------
-- Modbus request 1 : event if reg1 change
----------------------------------------------------
script=[[
    local function action()
        print('fire event 101: new value nr2reg1')
        local event = {{timestamp = time(), code = 101, data = user.nr2reg1}};
        sendevents('nr2reg1',event); connecttoserver(); connecttoserver();
    end;
connect(onchange('user.nr2reg1'), action);]]
print(m.addscript("nr2reg1event",script))

-----------------------------------------------------------
-- event if threshold on reg2->5
-----------------------------------------------------------
for i=2, 5 do
    script=[[
        local function action()
            print('fire event 102: new value nr2reg]] .. i .. [[')
            local event = {{timestamp = time(), code = 102, data = user.nr2reg]].. i .. [[}};
            sendevents('nr2reg]] .. i ..[[',event); connecttoserver(); connecttoserver();
        end;
        connect(onthreshold(500,'user.nr2reg]] .. i .. [['), action);
    ]]
    print(m.addscript("nr2reg"..i.."treshold",script))
end



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- NR 3

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------
-- Modbus request 1 : event if reg1 change
----------------------------------------------------
script=[[
    local function action()
        print('fire event 101: new value nr3reg1')
        local event = {{timestamp = time(), code = 101, data = user.nr3reg1}};
        sendevents('nr3reg1',event); connecttoserver(); connecttoserver();
    end;
connect(onchange('user.nr3reg1'), action);]]
print(m.addscript("nr3reg1event",script))

-----------------------------------------------------------
-- event if threshold on reg2->5
-----------------------------------------------------------
for i=2, 5 do
    script=[[
        local function action()
            print('fire event 102: new value nr3reg]] .. i .. [[')
            local event = {{timestamp = time(), code = 102, data = user.nr3reg]].. i .. [[}};
            sendevents('nr3reg]] .. i ..[[',event); connecttoserver(); connecttoserver();
        end;
        connect(onthreshold(500,'user.nr3reg]] .. i .. [['), action);
    ]]
    print(m.addscript("nr3reg"..i.."treshold",script))
end


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- NR 4

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------
-- Modbus request 1 : event if reg1 change
----------------------------------------------------
script=[[
    local function action()
        print('fire event 101: new value nr4reg1')
        local event = {{timestamp = time(), code = 101, data = user.nr4reg1}};
        sendevents('nr4reg1',event); connecttoserver(); connecttoserver();
    end;
connect(onchange('user.nr4reg1'), action);]]
print(m.addscript("nr4reg1event",script))

-----------------------------------------------------------
-- event if threshold on reg2->5
-----------------------------------------------------------
for i=2, 5 do
    script=[[
        local function action()
            print('fire event 102: new value nr4reg]] .. i .. [[')
            local event = {{timestamp = time(), code = 102, data = user.nr4reg]].. i .. [[}};
            sendevents('nr4reg]] .. i ..[[',event); connecttoserver(); connecttoserver();
        end;
        connect(onthreshold(500,'user.nr4reg]] .. i .. [['), action);
    ]]
    print(m.addscript("nr4reg"..i.."treshold",script))
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- NR 5

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------
-- Modbus request 1 : event if reg1 change
----------------------------------------------------
script=[[
    local function action()
        print('fire event 101: new value nr5reg1')
        local event = {{timestamp = time(), code = 101, data = user.nr5reg1}};
        sendevents('nr5reg1',event); connecttoserver(); connecttoserver();
    end;
connect(onchange('user.nr5reg1'), action);]]
print(m.addscript("nr5reg1event",script))

-----------------------------------------------------------
-- event if threshold on reg2->5
-----------------------------------------------------------
for i=2, 5 do
    script=[[
        local function action()
            print('fire event 102: new value nr4reg]] .. i .. [[')
            local event = {{timestamp = time(), code = 102, data = user.nr5reg]].. i .. [[}};
            sendevents('nr5reg]] .. i ..[[',event); connecttoserver(); connecttoserver();
        end;
        connect(onthreshold(500,'user.nr5reg]] .. i .. [['), action);
    ]]
    print(m.addscript("nr5reg"..i.."treshold",script))
end





----------------------------------------------------
-- periodic connect
----------------------------------------------------
script=[[
    if not user.modbus then user.modbus = {} end
    if not user.modbus.instance then user.modbus.instance = modbus.new() end;
    if not user.modbus.instance then print('modbus error'); return nil, 'Modbusmodule can not be loaded'; end;
    local function action()
        print('CONNECTING TO SERVER...')
        connecttoserver()
        user.modbus.sdb1:clean()
        user.modbus.sdb2:clean()
        user.modbus.sdb3:clean()
        user.modbus.sdb4:clean()
        user.modbus.sdb5:clean()
    end;
connect(onperiod('240'), action)]]
print(m.addscript("connecttask",script))




data = {nr1 = { timestamps = m.user.ts1, data = m.user.nr1 }};
      user.modbus.sdb2:clean()
        user.modbus.sdb3:clean()
        user.modbus.sdb4:clean()
        user.modbus.sdb5:clean()

print(m.user.modbus.instance:write_multiple_registers(1,8,1000,2,3,4,5))
data,err = m.user.modbus.instance:read_holding_registers(1,8,20))

--------------------------
-- appli IO
--------------------------
script="local function action() print('fire event for DI1'); local event = {{timestamp = time(), code = 103, data = 'Front edge on DI1'}}; sendevents('DI1',event); connecttoserver(); end; connect(onthreshold(1, 'system.DI1','up'), action);"
m.addscript("DI1_event",script)

script = "local gpio = loadmodule('gpio'); gpio.configureAnalog(system,400,10); function hook() print('fire event for AI1'); local event = {{timestamp = time(), code = 103, data ='..  system.AI1 ..'}}; sendevents('AI1',event); connecttoserver(); end; connect(onthreshold(500, 'system.AI1', 'up'), hook)"
print(m.addscript("AI1test",script))


require "modbus"
m,err=modbus.new();p('err=',err)
timer.start()
function read()
    local i = 0
    while running do
        print(m:read_holding_registers(1,8,10))
        i = i + 1
    end
    print("read :", i)
end
function truc()
    local t = timer.new(60)
    wait(t,"*")
    running = false
    print("end")
end
running = true

run(read)
run(truc)

