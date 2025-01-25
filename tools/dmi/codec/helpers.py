def escape(text):
    text = text.replace('\\', '\\\\')
    text = text.replace('"', '\\"')
    return f'"{text}"'


def unescape(text, quote='"'):
    if text == 'null':
        return None
    if not (text.startswith(quote) and text.endswith(quote)):
        raise ValueError(text)
    text = text[1:-1]
    text = text.replace('\\"', '"')
    text = text.replace('\\\\', '\\')
    return text


def parse_num(value):
    if '.' in value:
        return float(value)
    return int(value)


def parse_bool(value):
    if value not in ('0', '1'):
        raise ValueError(value)
    return value == '1'
