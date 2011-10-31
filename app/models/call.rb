class Call
  include Mongoid::Document
  field :call_id,       :type => String
  field :caller_id,     :type => String
  field :called_id,     :type => String
  field :call_type,     :type => String
  field :call_start,    :type => Time
  field :call_end,      :type => Time
  field :call_duration, :type => Integer
  field :call_date,     :type => String
  field :call_hour,     :type => Integer
end
