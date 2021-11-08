"""Short description in RST format

   please have a look at other modules, this will go into the
   documentation verbatim (list of modules)
"""
import threading

import dbus

import core.input
import core.module
import core.widget
import core.event
import bluetooth


def proxy_object(bus, path, interface):
    """ commodity to apply an interface to a proxy object """
    obj = bus.get_object('org.bluez', path)
    return dbus.Interface(obj, interface)


def filter_by_interface(objects, interface_name):
    """ filters the objects based on their support
        for the specified interface """
    result = []
    for path in objects.keys():
        interfaces = objects[path]
        for interface in interfaces.keys():
            if interface == interface_name:
                result.append(path)
    return result


def get_device_info(device_mac):
    bus = dbus.SystemBus()

    # we need a dbus object manager
    manager = proxy_object(bus, "/", "org.freedesktop.DBus.ObjectManager")
    objects = manager.GetManagedObjects()

    # once we get the objects we have to pick the bluetooth devices.
    # They support the org.bluez.Device1 interface
    devices = filter_by_interface(objects, "org.bluez.Device1")

    # now we are ready to get the information we need
    for device in devices:
        obj = proxy_object(bus, device, 'org.freedesktop.DBus.Properties')

        address = str(obj.Get("org.bluez.Device1", "Address"))
        if address == device_mac:
            connected = bool(obj.Get("org.bluez.Device1", "Connected"))
            name = str(obj.Get("org.bluez.Device1", "Name"))
            return connected, name

    return False, "Unknown"


def send(sock, message):
    """
    This function sends a message through a bluetooth socket
    """
    sock.send(b"\r\n" + message + b"\r\n")


class Module(core.module.Module):

    @core.decorators.every(seconds=10)
    def __init__(self, config, theme):
        super().__init__(config, theme, core.widget.Widget(self.full_text))
        self._device_mac_address = self.parameter("device", "Unknown")
        self._device_available = False
        self._device_name = self._device_mac_address
        self._battery_level = -1
        self._device_port = None
        self._battery_level_reload_counter = 0 
        self._battery_level_reload_counter_limit = self.parameter("battery_check_interval", 600) / 10
        self._device_connect_command = self.parameter("connect_command", "bluetoothctl connect")
        self._device_disconnect_command = self.parameter("disconnect_command", "bluetoothctl disconnect")

        if self._device_mac_address != "Unknown":
            core.input.register(self, button=core.input.LEFT_MOUSE,
                                cmd=f"{self._device_connect_command} {self._device_mac_address}")

            core.input.register(self, button=core.input.RIGHT_MOUSE,
                                cmd=f"{self._device_disconnect_command} {self._device_mac_address}")

    def loop_set_device_port(self):
        if self._device_port is not None:
            return

        limit = 0

        while self.set_device_port() and limit < 10:
            limit = limit + 1
            pass

        if self._device_port is not None:
            core.event.trigger("update", [self.id], redraw_only=True)

    def set_device_port(self):
        uuid = "0000111e-0000-1000-8000-00805f9b34fb"
        proto = bluetooth.find_service(address=self._device_mac_address, uuid=uuid)
        if len(proto) == 0:
            return True

        for pr in proto:
            if 'protocol' in pr and pr['protocol'] == 'RFCOMM':
                self._device_port = pr['port']
                return False
        return True

    def refresh_if_available(self):
        if self._device_mac_address is not None:
            lookup_name = bluetooth.lookup_name(address=self._device_mac_address)
            if lookup_name is not None:
                core.event.trigger("update", [self.id], redraw_only=True)

    def full_text(self, widget):
        #return f"{self._device_name}{'' if self._battery_level < 0 else ':'}"
        return f"{self._device_name}: {self._battery_level}"  # Debug only

    def state(self, widget):
        result = []
        if self._battery_level > 0:
            threshold = self.threshold_state(100 - self._battery_level, 49, 79)
            if threshold is None:
                result.append("normal" if self._battery_level > 80 else "normal-80")
            else:
                result.append(threshold)

        result.append("connected" if self._device_available is True else "disconnected")
        return result

    def update(self):
        new_status, self._device_name = get_device_info(self._device_mac_address)

        if self._device_available is False and new_status is True:
            self.loop_set_device_port()
            self._battery_level = -1

        self._device_available = new_status

        if self._device_available is True:
            self._battery_level_reload_counter += 1
            if self._battery_level_reload_counter > self._battery_level_reload_counter_limit or self._battery_level < 0:
                self._battery_level_reload_counter = 0
                self.update_battery_in_different_thread()

    def update_battery_in_different_thread(self):
        if self._device_available is True and self._device_port is not None:
            battery_check_thread = threading.Thread(target=self.update_battery_level)
            battery_check_thread.start()

    def update_battery_level(self):
        try:
            sock = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
            sock.connect((self._device_mac_address, self._device_port))

            limit = 0

            while self.send_commands(sock, sock.recv(128)) and limit < 100:
                limit = limit + 1
                pass
            core.event.trigger("update", [self.id], redraw_only=True)
            sock.close()
        except OSError as err:
            self._device_available = False

    def send_commands(self, sock, line):
        """
        Will try to get and print the battery level of supported devices
        """
        blevel = -1

        if b"BRSF" in line:
            send(sock, b"+BRSF: 1024")
            send(sock, b"OK")
        elif b"CIND=" in line:
            send(sock, b"+CIND: (\"battchg\",(0-5))")
            send(sock, b"OK")
        elif b"CIND?" in line:
            send(sock, b"+CIND: 5")
            send(sock, b"OK")
        elif b"BIND=?" in line:
            # Announce that we support the battery level HF indicator
            # https://www.bluetooth.com/specifications/assigned-numbers/hands-free-profile/
            send(sock, b"+BIND: (2)")
            send(sock, b"OK")
        elif b"BIND?" in line:
            # Enable battery level HF indicator
            send(sock, b"+BIND: 2,1")
            send(sock, b"OK")
        elif b"XAPL=" in line:
            send(sock, b"+XAPL: iPhone,7")
            send(sock, b"OK")
        elif b"IPHONEACCEV" in line:
            parts = line.strip().split(b',')[1:]
            if len(parts) > 1 and (len(parts) % 2) == 0:
                parts = iter(parts)
                params = dict(zip(parts, parts))
                if b'1' in params:
                    blevel = (int(params[b'1']) + 1) * 10
        elif b"BIEV=" in line:
            params = line.strip().split(b"=")[1].split(b",")
            if params[0] == b"2":
                blevel = int(params[1])
        elif b"XEVENT=BATTERY" in line:
            params = line.strip().split(b"=")[1].split(b",")
            blevel = int(params[1]) / int(params[2]) * 100
        else:
            send(sock, b"OK")

        if blevel != -1:
            self._battery_level = blevel
            return False

        return True


