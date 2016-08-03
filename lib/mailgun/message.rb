module Mailgun
  class Message
    def initialize(mailgun, domain)
      @mailgun = mailgun
      @domain  = domain
    end

    # send email
    def send_email(parameters={})
      # options:
      # :from, :to, :cc, :bcc, :subject, :text, :html
      # :with_attachment
      # :with_attachments
      # :at for delayed delivery time option
      # :in_test_mode BOOL. override the @use_test_mode setting
      # :tags to add tags to the email
      # :track BOOL

      # TODO: check addresses for proper format:
      # display-name <local-part@domain.tld>
      # display-name should be enclosed in quotes
      # to escape these characters ()<>[]:;,@\
      # and not contain any control characters

      Mailgun.submit(:post, send_messages_url, parameters)
    end

    # receive email
    def fetch_email( url )
      # options:
      # key is the identifier returned in the events call
      # for a stored email
      parts = url.split( '//' )
      Mailgun.submit(:get, parts[0] + "//api:#{Mailgun.api_key}@" + parts[1])
    end

    # delete email
    def delete_email( key )
      # options:
      # key is the identifier returned in the events call
      # for a stored email
      Mailgun.submit(:delete, fetch_messages_url+"/"+key)
    end

    def fetch_email_attachment( key, fidx )
      # options:
      # key is the identifier returned in the events call
      # for a stored email
      # fidx is the index of the attachment (from the
      # original message

      # There is no JSON response here ... just the file
      RestClient.send(:get, fetch_messages_url+"/"+key+"/attachments/#{fidx}")
    end

    private

    # Helper method to generate the proper url for Mailgun message API calls
    def send_messages_url
      "#{@mailgun.base_url}/#{@domain}/messages"
    end

    def fetch_messages_url
      "#{@mailgun.base_url}/domains/#{@domain}/messages"
    end
  end
end
