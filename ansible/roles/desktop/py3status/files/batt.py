#!/usr/bin/env python3


class Py3status:

    symbol_charging = "⚡"
    symbol_discharging = "⛁"

    battery_high = 60
    battery_low = 20
    battery_warn = 12
    battery_critical = 8

    # Temp in Perecent
    high_temp = 60
    mid_temp = 40
    low_temp = 1
    increment = 5

    cache_timeout = 5

    cmd_bl_info = "brightnessctl -m info"


    def post_config_hook(self):

        # Convert self.increment from percent into absolute brightness
        bl_out = self.py3.command_output(self.cmd_bl_info).split(",")
        bl_max = int(bl_out[4])
        self.increment = int(self.increment * bl_max / 100)

    def main(self):

        bat = self._acpi_out()

        text = [self.symbol_charging] if bat['charging'] else [self.symbol_discharging]

        percent = int(bat['percent'])
        if percent != 100 or not bat['charging']:
            text.append("{}%".format(percent))

        if (percent <= self.battery_warn) and (not bat['charging']):
            text.append("({})".format(bat['time_until']))

        if percent < self.battery_low:
            color = "#FF0000"
        elif percent < self.battery_high:
            color = "#FFFF00"
        else:
            color = "#00FF00"

        return {
            'full_text': ' '.join(text),
            'cache_timeout': self.cache_timeout,
            'color': color
        }

    def on_click(self, event):

        bl_out = self.py3.command_output(self.cmd_bl_info).split(",")

        bl_current = int(bl_out[2])
        bl_percent = int(bl_out[3].strip('%'))

        button = event['button']

        if button == 1:
            # Left Click
            if bl_percent > self.mid_temp:
                self._backlight_set(self.low_temp, percent=True)
            else:
                self._backlight_set(self.high_temp)

        elif button == 4:
            # Scroll Up
            self._backlight_set(bl_current + self.increment)

        elif button == 5:
            # Scroll Down
            self._backlight_set(bl_current - self.increment)

    def _backlight_set(self, new_bl, percent=False):

        percent = "%" if percent else ""
        cmd = "brightnessctl s {}{}".format(str(new_bl or 1), percent)
        self.py3.command_run(cmd)

    def _acpi_out(self):
        """
        ~ $ acpi -ab
        Battery 0: Discharging, 83%, 08:07:47 remaining
        Battery 1: Unknown, 0%, rate information unavailable
        Adapter 0: off-line

        """
        out = self.py3.command_output("acpi -ab").splitlines()

        batteries = []
        data = {}
        for line in out:
            l = line.split()
            if l[0] == "Battery":
                percent = l[3].strip(',%')
                if percent == "0":
                    continue
                else:
                    data['percent'] = percent
                data['time_until'] = l[4] if (len(l) > 4) else None
            if l[0] == "Adapter":
                data['charging'] = True if l[2] == "on-line" else False

        if 'percent' not in data:
            data = {'percent': "0", 'time_until': ""}

        return data


if __name__ == "__main__":
    from py3status.module_test import module_test
    module_test(Py3status)
