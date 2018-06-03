local component = require "component"
local event = require "event"

local modem = component.modem

print("Please enter path of 3dm file...")
local path = io.read()
print("File selected.")
print("Reading contents...")

local file = io.open(path, "r")
local printcode = file:read("*a")
file:close()

print("Got printer code!")
print("Broadcasting...")
modem.broadcast(78, "print3d", printcode)

print("Done!")