#!/usr/bin/env python3

class Py3status:

    cache_timeout = 1
    device = "pulse"
    increment = 5

    def main(self):
        out = self.py3.command_output("amixer -D {} get Master".format(self.device))
        lines = out.splitlines()
        data = [l.split()[4:6] for l in lines if '[' in l][0]
        data = [i.strip('[').strip(']') for i in data]

        if data[1] == "off":
            text = "MUTE"
        else:
            text = "♪" + data[0]

        return {
            'full_text':  text,
            'cache_timeout': self.cache_timeout,
        }

    def on_click(self, event):

        button = event['button']

        if button == 1:
            self.py3.command_run("amixer -D {} sset Master toggle".format(self.device))
        elif button == 3:
            self.py3.command_run("pavucontrol")
        elif button == 4:
            self.py3.command_run("amixer -D {} sset Master {}%+ unmute".format(self.device, self.increment))
        elif button == 5:
            self.py3.command_run("amixer -D {} sset Master {}%- unmute".format(self.device, self.increment))


if __name__ == "__main__":
    from py3status.module_test import module_test
    module_test(Py3status)
