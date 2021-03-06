
module PiwikAnalytics
  class Configuration

    #
    # The url of the Piwik instance
    # Defaults to localhost
    #
    def url
      @url ||= (user_configuration_from_key('url') || 'localhost')
    end

    #
    # The ID of the tracked website
    # Defaults to 1
    #
    def id_site
      @id_site ||= (user_configuration_from_key('id_site'))
    end

    # When a user clicks to download a file, or clicks on an outbound link, 
    # Piwik records it. In order to do so, it adds a small delay before the 
    # user is redirected to the requested file or link. 
    # The default value is 500ms, but you can set it to a shorter or longer
    # length of time. 
    # The time should carefully selectet, too short results in the risk that 
    # this period of time is not long enough for the data to be recorded in 
    # Piwik and too long periods results in unwanted delays.
    # http://developer.piwik.org/api-reference/tracking-javascript
    # Defaults to false.
    #
    def trackingTimer
      @trackingTimer ||= (user_configuration_from_key('trackingTimer') || false)
    end

    #
    # Whether or not to disable Piwik.
    # Defaults to false.
    #
    #
    def disabled?
      @disabled ||= (user_configuration_from_key('disabled') || id_site.nil? || false)
    end

    private

    # 
    # return a specific key from the user configuration in config/piwik.yml
    #
    # ==== Returns
    #
    # Mixed:: requested_key or nil
    #
    def user_configuration_from_key( *keys )
      keys.inject(user_configuration) do |hash, key|
        hash[key] if hash
      end
    end

    #
    # Memoized hash of configuration options for the current Rails environment
    # as specified in config/piwik.yml
    #
    # ==== Returns
    #
    # Hash:: configuration options for current environment
    #
    def user_configuration
      @user_configuration ||= begin
        path = File.join(::Rails.root, 'config', 'piwik.yml')
        if File.exist?(path)
          File.open(path) do |file|
            processed = ERB.new(file.read).result
            YAML.load(processed)[::Rails.env]['piwik']
          end
        else
          {}
        end
      end
    end
  end
end
