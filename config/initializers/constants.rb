LOCATIONS = [
  "Bay Area",
  "San Francisco",
  "North Bay",
  "Peninsula",
  "East Bay",
  "South Bay"
].freeze

INFO_EMAIL = APP_CONFIG[:email_notifications][:info][:email]

MAIL_FROM_INFO = "\"#{APP_CONFIG[:email_notifications][:info][:name]}\" <#{INFO_EMAIL}>"
MAIL_WEBMASTER = "\"#{APP_CONFIG[:email_notifications][:webmaster][:name]}\" <#{APP_CONFIG[:email_notifications][:webmaster][:email]}>"
MAIL_EDITOR = "\"#{APP_CONFIG[:email_notifications][:editor][:name]}\" <#{APP_CONFIG[:email_notifications][:editor][:email]}>"

SITE_NAME = APP_CONFIG[:customization][:site_name]
PREPEND_STATUS_UPDATE = SITE_NAME

FACEBOOK_URL = APP_CONFIG[:customization][:facebook_url]
TWITTER_URL = APP_CONFIG[:customization][:twitter_url]
FLICKR_URL = APP_CONFIG[:customization][:flickr_url]
BLOG_URL = APP_CONFIG[:customization][:blog_url]

MODEL_NAMES = {
  'suggested' => 'Tip',
  'unfunded' => 'Pitch',
  'almost-funded' => 'Pitch',
  'funded' => 'Pitch',
  'published' => 'Story'
}

FILTERS_STORIES = ActiveSupport::OrderedHash.new
FILTERS_STORIES["unfunded"]="Unfunded"
FILTERS_STORIES["almost-funded"]="Almost Funded"
FILTERS_STORIES["funded"]="Funded"
FILTERS_STORIES["published"]="Published"
FILTERS_STORIES["suggested"]="Suggested"
FILTERS_STORIES_STRING = FILTERS_STORIES.collect{ |key, value| key}.join('|')

FILTERS_CONTRIBUTORS = ActiveSupport::OrderedHash.new
FILTERS_CONTRIBUTORS["donated"]="Recently Donated"
FILTERS_CONTRIBUTORS["donated-most"]="Donated Most"
FILTERS_CONTRIBUTORS["organizations"]="Organizations"
FILTERS_CONTRIBUTORS["reporters"]="Reporters"
FILTERS_CONTRIBUTORS_STRING = FILTERS_CONTRIBUTORS.collect{ |key, value| key}.join('|')
