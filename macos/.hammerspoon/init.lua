usbWatcher = nil

function usbDeviceCallback(data)
    if (data["productName"] == "Samson Meteor Mic") then
        if (data["eventType"] == "added") then
              hs.osascript.applescriptFromFile([[/Users/rochala/Scripts/SamsonFix.applescript]])
        end
    end
end

usbWatcher = hs.usb.watcher.new(usbDeviceCallback)
usbWatcher:start()