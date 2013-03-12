function printmem()
   for i = 0, 5 do
      collectgarbage("collect")
   end
   print("gcinfo:",collectgarbage("count"))
end


printmem()
require "timer"
timer.start()
require "oatWrapper"
start_agent()
wait(30)

printmem()

m = require "Monitoring"
printmem()

script = "local function action() local data = {var1 = { timestamps = {time()}, data = {system.var1} }}; sendtimestampeddata('system', data); end; connect(onchange('system.var1'),action)"
print(m.addscript("script1",script))
printmem()

script ="local function action() connecttoserver(); end connect(onperiod(120),action)"
print(m.addscript("script2",script))
printmem()

script="local function action() local event = {{timestamp = time(), code = 102, data = system.DI1}}; sendevents('DI1',event); connecttoserver(); end; connect(filter(function() return system.DI1 == 1; end, onchange('system.DI1')), action);"
print(m.addscript("DI1_event",script))
printmem()


script = "if not user.vardb then user.vardb = newsdb({'ts','value', value='max'},20,function() user.flush = true; end); end; local function action()  user.vardb:addrecord(time(), system.var0); end; connect(onchange('system.var0'),action)"
print(m.addscript("sdb0",script))
printmem()

script = "local function action() user.flush = false; local conso = user.vardb:consolidate(); local data = {var1 = { timestamps = {conso.ts}, data = {conso.value} }}; sendtimestampeddata('system.conso.var0', data); connecttoserver();end; connect(onchange('user.flush'), action)"
print(m.addscript("conso1",script))
printmem()

-- write to ouput 22 on DI1 front edge
script = "local gpio = loadmodule('gpio'); gpio.configureDigit(system,100); local v = 1; function hook() gpio.write(23, v); v = 1-v; end; connect(onthreshold(1, 'system.DI2','up'), hook)"
print(m.addscript("gpio1",script))
printmem()

script = "local gpio = loadmodule('gpio'); gpio.configureDigit(system,100); local v = 1; function hook() gpio.write(22, v); v = 1-v; end; connect(onthreshold(1, 'system.DI1','up'), hook)"
print(m.addscript("gpio1",script))
printmem("with gpio2")

script = "local gpio = loadmodule('gpio'); gpio.configureAnalog(system,400,10); function hook() local event = {{timestamp = time(), code = 101, data = system.AI1}}; sendevents('AI1',event); connecttoserver();end; connect(ondeathband(100, 'system.AI1'), hook)"
print(m.addscript("AI1event",script))
printmem()

script = "local gpio = loadmodule('gpio'); gpio.configureAnalog(system,400,10); function hook() local event = {{timestamp = time(), code = 100, data = 'alim OFF'}}; sendevents('power',event); connecttoserver();end; connect(filter(function() return system.PWR < 500 end, onchange('system.PWR')), hook)"
print(m.addscript("alimOFF",script))
printmem()

script = "local gpio = loadmodule('gpio'); gpio.configureAnalog(system,400,10); function hook() local event = {{timestamp = time(), code = 100, data = 'alim ON'}}; sendevents('power',event); connecttoserver();end; connect(filter(function() return system.PWR > 500 end, onchange('system.PWR')), hook)"
print(m.addscript("alimON",script))
printmem()

for i = 0, 50 do
    local script = "user.var" .. i .. "=0; local function hook() print 'var" .. i .." changed'; user.var" .. i + 1 .." = user.var" ..  i .."; end ; connect(onchange('user.var" .. i .. "'),hook)"
    print(m.addscript("chain"..i, script))
    wait(5)
end
printmem()


running = true
function change()
    local t = timer.new(-15)
    local loop = 0
    while running do
        wait(t,"*")
        if loop % 2 == 0 then
            m.system.var0 = loop
            print("system.var0 updated")
        end
        if loop % 5 == 0 then
            m.system.var1 = loop
            print("system.var1 updated")
        end
        if loop % 10 == 0 then
            m.user.var0 = m.user.var0 + 1
            print("user.var0 incremented")
        end
        loop = loop + 1
        printmem()
    end
    timer.cancel(t)
end

run(change)