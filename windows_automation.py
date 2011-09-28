import win32com.client

igor = win32com.client.Dispatch("IgorPro.Application")
igor.Visible = True                     # if you want to look at Igor Pro instance
igor.Execute("<some command>")


# input parameters
flags = 0
code_page = 0
cmd = "print 1"

# output parameters
err_code = 0
err_msg = ""
history_msg = ""
results_msg = ""
igor.Execute2(0, 0, cmd, error_code, err_msg, history_msg, results_msg)
# returns a tuple of error_code, err_msg, history_msg, results_msg
