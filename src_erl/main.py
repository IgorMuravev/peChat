from tkinter import *

def show_form():
    root = Tk()
    frame = Frame(root, width=25)
    frame.pack(side='bottom')
    entry = Entry(frame)
    text1 = Text(root, wrap=WORD)
    btn = Button(frame, text='send', width=25, height=5)
    entry.pack(side='left')
    text1.pack();
    btn.pack(side='right')
    root.mainloop()

if __name__ == "__main__":
    show_form()
