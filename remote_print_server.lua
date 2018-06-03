local component = require "component"
local event = require "event"
local serialize = require "serialization"

local modem = component.modem
local printer = component.printer3d

local function handleMessage(_, localModem, remoteModem, port, distance, header, data)
  print("Incomming data!")
  
  print("Remote address: " .. remoteModem)

  if header == "print3d" then
    print("Valid header! Processing...")
  else
    print("Invalid header :/ Skipping...")
    return
  end

  if data == nil then
    print("Empty payload, skipping...")
    return
  end

  print("Exporting to temp file...")
  local printfile=io.open("/tmp/print.3dm", "w")
  printfile:write(data)
  printfile:close()
  print("Done!")
  
  print("Piping to print3d...")
  os.execute("print3d /tmp/print.3dm")
  print("Done!")
  print("Please check above for results")

  print("Ready to accept more requests...")
end
  
print("Starting remote print server.")
print("Press 'X' to stop accepting requests")
print("------------------------------------")

print("Opening port 78...")
if modem.open(78) == true then
  print("Opened port 78.")
else
  print("Could not open port 78. Is it already open?")
  if modem.isOpen(78) == true then
    print("Port is already open. Continuing execution.")
  else
    print("ERROR: Could not open port 78, port remains closed.")
    os.exit()
  end
end

print("Starting listener...")
event.listen("modem_message", handleMessage)
print("Lister started.")

print("Now accepting packets...")
while true do
  local _, _, char, _, _ = event.pull(10, "key_down")
  if char == 120 then
    print("Now exiting...")
    print("Closing port...")
    modem.close(78)
    print("Stopping listener...")
    event.ignore("modem_message", handleMessage)
    print("Done. Goodbye")
    os.exit()
  end
end