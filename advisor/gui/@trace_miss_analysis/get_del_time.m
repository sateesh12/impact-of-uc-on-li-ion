function array = get_del_time(tm)

array = conv([0.5 0.5], diff(tm.time));
