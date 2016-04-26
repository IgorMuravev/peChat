import sys
import time

def timer():
    while True:
        line = sys.stdin.readline()
        if not line:
            break
        if line.rstrip() != "time":
            result = "error"
        else:
            result = str(time.time())
        sys.stdout.write("%s\n" % result)
        sys.stdout.flush()

if __name__ == "__main__":
    timer()