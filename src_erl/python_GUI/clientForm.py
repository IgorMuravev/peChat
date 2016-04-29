from tkinter import *
from erlport import Atom, erlang

class guiForm(Frame):
	
	def __init__(self, pid ,parent=None):
		Frame.__init__(self,parent,width=300,height=150)
		self.place(relx=0, rely=0, relwidth=1, relheight=1)

		self.text = Text(self)
		self.text.place(anchor="nw", relx=0, rely=0,relwidth=1,relheight=1, height=-25)
		
		self.frame = Frame(self,height=25)
		self.frame.place(anchor="nw", relx=0, rely=1,y=-25,relwidth=1, height=25)

		self.entry = Entry(self.frame)
		self.entry.place(relx=0,relwidth=0.8)
		self.pid = pid
		def btn_clicked(event=None):
			ennteredtxt = self.entry.get()
			self.append(ennteredtxt)
			self.entry.delete(0, END)
			erlang.call(Atom(b"pe_client"), Atom(b"send"),[self.pid,ennteredtxt])
		
		self.entry.bind("<Return>", btn_clicked)
		self.btn = Button(self.frame, text='send',command=btn_clicked)
		self.btn.place(relx=0.8,relwidth=0.2)


	def append(self, atext):
		self.text.insert(END,atext + "\n")
