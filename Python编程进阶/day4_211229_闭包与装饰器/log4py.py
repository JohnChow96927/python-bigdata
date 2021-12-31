import traceback
from functools import wraps


def log4p(log_file="log_file.log"):
    def log_error(fn):
        @wraps(fn)
        def wrapped(*args, **kwargs):
            try:
                result = fn(*args, **kwargs)
                return result
            except Exception:
                with open(log_file, "a", encoding="utf-8") as f:
                    f.write(traceback.format_exc())
                    return

        return wrapped

    return log_error
