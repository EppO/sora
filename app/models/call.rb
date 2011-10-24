class Call
  include Mongoid::Document
  field :call_id, :type => String
  field :caller_id, :type => String
  field :called_id, :type => String
  field :call_type, :type => String
  field :call_start, :type => Time
  field :call_end, :type => Time
end
