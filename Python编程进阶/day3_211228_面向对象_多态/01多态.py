class AliPay(object):
    def pay(self):
        pass


class WechatPay(object):
    def pay(self):
        pass


def ali_qrcode(alipay):
    alipay.pay()


def wechat_qrcode(wechatpay):
    wechatpay.pay()


# 多态
def qrcode(unipay):
    unipay.pay()
