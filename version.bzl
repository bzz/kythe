def _tuplicate(value, delim):
    rv = ()
    for field in value.split(delim):
        if field.isdigit():
            rv += (int(field),)
        else:
            rv += (field,)
    return rv

def _parse_version(version):
    # Remove any commit tail.
    version = version.split(" ", 1)[0]

    # Split into (release, date) parts.
    parts = version.split("-", 1)
    return _tuplicate(parts[0], ".")

def _bound_size(tup, size, padding = 0):
    if len(tup) >= size:
        return tup[:size]
    ret = tup
    for i in range(size - len(tup)):
        ret += (padding,)
    return ret

def check_version(min_required, max_supported):
    found = native.bazel_version
    found_version = _parse_version(found)
    min = _parse_version(min_required)
    if min > _bound_size(found_version, len(min)):
        fail("You need to update bazel. Required version {} of bazel, found {}".format(min_required, found))
    max = _parse_version(max_supported)
    if max < _bound_size(found_version, len(max)):
        fail("Your bazel is too new. Maximum supported version {} of bazel, found {}".format(max_supported, found))
