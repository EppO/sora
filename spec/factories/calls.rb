# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :call do
    call_id "MyString"
    caller_id "MyString"
    called_id "MyString"
    call_type "MyString"
    call_start "2011-10-21 16:12:28"
    call_end "2011-10-21 16:12:28"
  end
end
