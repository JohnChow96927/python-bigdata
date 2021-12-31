from log import log4p



@log4p()
# outer = logfp()
# print_ad = outer(print_ad)
def print_ad():
    print(name)

@log4p("num.log")
def demo(num):
    print(num / 0)


print_ad()
demo(10)