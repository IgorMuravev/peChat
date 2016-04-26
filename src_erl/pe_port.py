import sys

def showMsg():
    while True:
        line = sys.stdin.readline()
        sys.stdout.write(line)
        sys.stdout.flush()

if __name__ == "__main__":
    showMsg()
