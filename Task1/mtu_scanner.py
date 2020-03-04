import os
import sys


def mtu_scanner():
    hostname = sys.argv[1]
    size = 0
    while True:
        response = os.system("ping -M do -c 1 -i 0.2 -s " + str(size) + " " + hostname)
        size += 50
        if response == 256:
            break
    while True:
        size -= 1
        response = os.system("ping -M do -c 1 -i 0.2 -s " + str(size) + " " + hostname)
        if response == 0:
            return f"MTU is {size + 28}"


if __name__ == "__main__":
    print(mtu_scanner())
