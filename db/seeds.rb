# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

callers = %w( 0142123456 0209872453 0145279865 0164521192 0512333316 0149730211 0309730376 0509736676 0129834376 )
called = %w( 0145081223 0148341315 0164272845 0160981432 0419723322 0148341315 0168673315 0155351316 0131311315 0248341944 )
dates = ((Date.today - 3.month)..Date.today).to_a
call_types = [ "answer", "originate" ]

for i in 500..rand(10000)+500 do
  call_date = dates[rand(dates.size)]
  begin
    call_start = call_date.to_time + rand(24).hours + rand(60).minutes + rand(60).seconds
    call_end = call_start + rand(60).minutes + rand(60).seconds
    duration = call_end.to_time - call_start.to_time
  end until (call_date != Date.today) || (call_end.to_time < Time.now)
  Call.create(:call_id => rand(100)*rand(100)*rand(100)*rand(100), :caller_id => callers[rand(callers.size)], :called_id => called[rand(called.size)], 
              :call_type => call_types[rand(call_types.size)], :call_start => call_start, :call_end => call_end, 
              :call_date => call_date, :call_hour => call_start.hour, :call_duration => duration)
end