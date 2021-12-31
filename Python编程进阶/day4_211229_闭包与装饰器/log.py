import traceback


def log4p(path="error.log"):
    def outer(fn):
        def inner(*args, **kwargs):
            try:
                result = fn(*args, **kwargs)
                return result
            except Exception as e:
                with open(path, "a", encoding="utf-8") as f:
                    print(traceback.format_exc())
                    f.write(traceback.format_exc())

        return inner

    return outer
