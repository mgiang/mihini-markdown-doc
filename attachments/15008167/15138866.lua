timer.start()
require "oatWrapper"
m = require "Monitoring"

en gpio.configureDigit(system,100); end print(gpio,err); local function hook() gpio.write(23, system.DI8); end ; connect(onchange('system.DI8'),hook)"
print(m.addscript("test3",script))


for i = 0, 20 do
    script = "user.var" .. i .. "=0; local function hook() print 'updating var " .. i + 1 .."'; user.var" .. i + 1 .." = user.var" ..  i .."; end ; connect(onchange('user.var" .. i .. "'),hook)"
    print("adding t"..i ,m.addscript("test"..i,script))
end

script = "local gpio = loadmodule('gpio'); gpio.configureDigit(system,100); local v = 1; function hook() gpio.write(22, v); v = 1-v; end; connect(onthreshold(1, 'system.DI1','up'), hook)"
print(m.addscript("inputtooutputonup",script))


script = "local gpio = loadmodule('gpio'); gpio.configureDigit(system,100); function hook() gpio.write(23, system.DI2);end; connect(onchange('system.DI2'), hook)"
print(m.addscript("intputtooutput2",script))

script = "local gpio = loadmodule('gpio'); gpio.configureDigit(system,100); function hook() print('new value for I1',system.DI1);end; connect(onchange('system.DI1'), hook)"
print(m.addscript("inputprint",script))

script = "local gpio = loadmodule('gpio'); gpio.configureAnalog(system,400,10); function hook() print('new value for AI1',system.AI1);end; connect(onthreshold(500, 'system.AI1'), hook)"
print(m.addscript("AI1test",script))

for i = 0, 20 do
    script = "local function hook() gpowrite(23, system.I8); end ; connect(onchange('system.I8'),hook)"
    print(m.addscript("test",script))
end


for i = 0 , 10 do
print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("collect"))
    print(collectgarbage("count"))
end



require "gpio"
t = {}
gpio.configureDigit(t,100)


timer.start()
require "oatWrapper"
m = require "Monitoring"

script = [[
local gpio = loadmodule('gpio'); gpio.configureDigit(system,100);
local function hook()
    print('waiting')
    wait(100)
    print('wake up')
end
connect(onchange('system.DI1'), hook)]]
print(m.addscript("i2o1",script))

script = [[
local gpio = loadmodule('gpio');
local function hook()
    gpio.write(22, system.DI1)
end
connect(onchange('system.DI1'), hook)]]
print(m.addscript("i2o2",script))
