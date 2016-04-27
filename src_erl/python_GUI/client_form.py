from tkinter import *


class client_f(Frame):
	def __init__(self, parent=None):
		Frame.__init__(self,parent,width=300,height=150)
		self.place(relx=0, rely=0, relwidth=1, relheight=1)

		text = Text(self)
		text.place(anchor="nw", relx=0, rely=0,relwidth=1,relheight=1, height=-25)
		
		frame = Frame(self,height=25)
		frame.place(anchor="nw", relx=0, rely=1,y=-25,relwidth=1, height=25)

		entry = Entry(frame)
		entry.place(relx=0,relwidth=0.8)
		btn = Button(frame, text='send')
		btn.place(relx=0.8,relwidth=0.2)
