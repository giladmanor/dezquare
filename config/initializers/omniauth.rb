Rails.application.config.middleware.use OmniAuth::Builder do

  case Rails.env
    when "development"
      provider :twitter, 'NYNDIh7P3SwaNgCZaN72A', 'OhMpUtzaVrXQMuYVlc30OHTiKneXo0kYrjLlQxzt1vI',
               :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location"]

      provider :facebook, '406913132717841', '296547bda97a8e9183593e3a6f8d6769',
               :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location"]

    else
      provider :twitter, 'sWIdd3Qy0s3bGWZKFCcng', 'rwgbfLHxvbWUZLQiTv0OY3ZEYCx9CPRH0JFt577Xi0',
               :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location"]

      provider :facebook, '460855643961038', 'f2ebe1045928763dac2e22a1a4eec399',
               :fields => ["id", "email-address", "first-name", "last-name", "headline", "industry", "picture-url", "public-profile-url", "location"]
  end
end