file = File.open("sz003019.day")
file_data = file.read(32)
string = file_data.unpack("H*")[0]
date = string[0,8]
real_date = date[6..7] + date[4..5] + date[2..3] + date[0..1]
puts real_date.to_i(16)
