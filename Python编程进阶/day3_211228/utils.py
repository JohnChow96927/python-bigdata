class ListUtils(object):

    @staticmethod
    def get_max(my_list):
        _max = my_list[0]
        for i in range(1, len(my_list)):
            if _max < my_list[i]:
                _max = my_list[i]
        return _max

    @staticmethod
    def get_min(my_list):
        _min = my_list[0]
        for i in range(1, len(my_list)):
            if _min > my_list[i]:
                _min = my_list[i]
        return _min


class DictUtils(object):
    @staticmethod
    def get_max(my_list):
        _max = my_list[0]
        for i in range(1, len(my_list)):
            if _max < my_list[i]:
                _max = my_list[i]
        return _max

    pass

class StrUtils(object):
    pass