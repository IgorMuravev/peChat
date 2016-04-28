import threading
from client_form import *

class peAPI:

	def job(self,api):
		api.form = client_f()
		api.form.mainloop()

	def show(self):
		def job():
			self.form = client_f()
			self.form.mainloop()
			
		self.window_thread=threading.Thread(target=job)
		self.window_thread.start()

	def appendtext(self,msg):
		self.form.appendtext(msg + "\n")


def get_api():
	return peAPI()

def show_form(api):
	api.show()

def send(api, msg):
	api.appendtext(msg)

