#!/usr/bin/env python3

class Py3status:

    def main(self):

        status = self.py3.command_output("nmcli --terse --fields 'active,ssid,bars,security' device wifi")
        active = [l.split() for l in status.splitlines() if l[:3] == "yes"]
        return {'full_text': active}
        if not active[3]:
            color = "red"
        else:
            color = "green"

        return {
            'full_text':  bars,
            'color': color
        }

    def on_click(self, event):

        button = event['button']

        if button == 1:
            pass
        elif button == 4:
            pass
        elif button == 5:
            pass
 

if __name__ == "__main__":
    from py3status.module_test import module_test
    module_test(Py3status)