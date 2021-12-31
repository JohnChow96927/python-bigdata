class ChinaPay(object):
    def pay(self):
        print("检测....")
        print("支付....")


class AliPay(ChinaPay):
    def pay(self):
        print("扫二维码...")
        super(AliPay, self).pay()
        print("支付成功...")


class WXPay(ChinaPay):
    def pay(self):
        print("微信支付功能....")
        super().pay()
        print("微信支付成功....")


class JXPay(ChinaPay):
    def jxlPay(self):
        print("使用我的进行支付")


# 商家提供二维码
# 解决通用性问题, 增强通用性
def shop_pay(pay):
    pay.pay()


alipay = AliPay()
shop_pay(alipay)

wxpay = WXPay()
shop_pay(wxpay)

jxpay = JXPay()
shop_pay(jxpay)
