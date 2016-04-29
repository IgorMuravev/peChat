from clientForm import *

def listener(form):
	while True:
		msgs = erlang.call(Atom(b"pe_client"), Atom(b"get_msg"), [])
		if len(msgs) > 0:
			for msg in msgs:
				form.append(''.join(chr(i) for i in msg))
		form.update()

def run_gui(pid):
	form = guiForm(pid)
	form.after(1000,listener, form)
	form.mainloop()
