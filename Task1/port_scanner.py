import socket
import multiprocessing.dummy as mp
import getopt
import sys
from _datetime import datetime

server = str()  # server for scanning
port_list = list()  # list for output of port scanner
__SUCCESSFUL = 0
__ERROR_ARGUMENT = 2


def p_scan(port):
    """port scanner
    :param port: int
        port for scanning
    :return: bool
        port status check
    """
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(1)
    try:
        s.connect((server, port))
        port_list.append(f"{port}/Port {port} is OPEN")
        return True
    except Exception as ex:
        if ex.args[0] == 'timed out':
            pass
        port_list.append(f"{port}/Port {port} is close")
        return False


def port_scanner_threads(range_ports):
    """port scan distribution on threads
    :param range_ports: str
        range of ports for scanning
    :return: 0
    """
    start_number = int(str(range_ports).split("-")[0])
    end_number = int(str(range_ports).split("-")[1]) + 1
    p = mp.Pool(8)
    p.map(p_scan, range(start_number, end_number))
    p.close()
    p.join()


def sort_port_list(input_list, range_ports):
    """sort output by port number
    :param input_list: list
        list for sorting
    :param range_ports: str
        range of ports for scanning
    :return: str
        string of sorted list divided \n
    """
    port_scanner_threads(range_ports)
    input_list = [i.split('/') for i in input_list]
    input_list = sorted(input_list, key=lambda x: int(x[0]))
    input_list = [item[1] for item in input_list]
    return "\n".join(input_list)


def manual():
    """function of help
    :return: 0
    """
    print('DESCRIPTION')
    print('\tThe program for port scanning.\n')
    print('\t-s, --server <server> \n\t\t specifying the server for scanning')
    print('\t-p, --port <range_ports> \n\t\t specifying the range of ports for scanning, example: -p 0-80')
    print('\t-h, --help \n\t\t get help about the program')
    print('\n\tThe -s and -p options work only together, and cannot be alone.\n')
    print('  Exit status:')
    print('\t0\t-\tif OK,')
    print('\t1\t-\tif critical error,')
    print('\t2\t-\tif problem with arguments.')
    print('\nAUTHOR')
    print('\tWritten by Oleksandr Frolov.')


def main(argv):
    """Function for processing script parameters
        :param argv: list
            Arguments of script
        :return: 0
    """
    try:
        opts, args = getopt.getopt(argv, "hs:p:", ["help", "server=", "port="])
    except getopt.GetoptError:
        print("An error occurred while specifying program parameters. "
              "To specify the correctness, specify the -h or --help option")
        sys.exit(__ERROR_ARGUMENT)
    # print(opts)
    port_opt = dict()
    port_opt["check_server"] = False
    port_opt["check_port"] = False
    for opt, arg in opts:
        if opt in ('-h', "--help"):
            manual()
            sys.exit(__SUCCESSFUL)
        elif opt in ("-s", "--server"):
            port_opt["check_server"] = True
            port_opt["server"] = arg
        elif opt in ("-p", "--port"):
            port_opt["check_port"] = True
            port_opt["range_ports"] = arg
    #  Check parameters
    if not port_opt["check_server"]:
        print("You forgot to specify the parameter -s.")
        sys.exit(__ERROR_ARGUMENT)
    if not port_opt["check_port"]:
        print("You forgot to specify the parameter -p.")
        sys.exit(__ERROR_ARGUMENT)
    ###########
    global server
    server = port_opt["server"]
    start = datetime.now()
    print(sort_port_list(port_list, port_opt["range_ports"]))
    print("\nTime spent:", datetime.now() - start)


if __name__ == "__main__":
    main(sys.argv[1:])
