FactoryGirl.define do
  factory :user do
    email         'test@example.com'
    password      'f4k3p455w0rd'
    confirmed_at  Time.now
  end
end
