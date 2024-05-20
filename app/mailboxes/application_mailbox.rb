class ApplicationMailbox < ActionMailbox::Base
  # routing /something/i => :somewhere
  routing /reply/i => :applicant_replies
end
