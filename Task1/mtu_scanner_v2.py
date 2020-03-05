import os
import sys


def mtu_scanner():
    hostname = sys.argv[1]
    size = 1400
    while True:
        response = os.system("ping -M do -c 1 -i 0.2 -s " + str(size) + " " + hostname + " > /dev/null")
        size += 1
        if response == 256:
            return f"MTU is {size + 26}"


if __name__ == "__main__":
    print(mtu_scanner())
