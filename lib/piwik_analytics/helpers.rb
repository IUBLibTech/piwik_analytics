module PiwikAnalytics
  module Helpers
    def piwik_tracking_tag
      config = PiwikAnalytics.configuration
      return if config.disabled?

      if config.trackingTimer
        trackingTimer = <<-CODE
        _paq.push(['setLinkTrackingTimer', #{config.trackingTimer}]); // #{config.trackingTimer} milliseconds
        CODE
      end

      tag = <<-CODE
      <!-- Piwik -->
      <script type="text/javascript">
        var _paq = _paq || [];
          #{trackingTimer}
        _paq.push(['trackPageView']);
        _paq.push(['enableLinkTracking']);
        (function() {
          var u="//#{config.url}/";
          _paq.push(['setTrackerUrl', u+'piwik.php']);
          _paq.push(['setSiteId', #{config.id_site}]);
          var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript';
          g.defer=true; g.async=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
        })();
      </script>
      <noscript><p><img src="https://#{config.url}/piwik.php?idsite=#{config.id_site}&rec=1" style="border:0;" alt="" /></p></noscript>
      <!-- End Piwik Code -->
      CODE
      tag.html_safe
    end
  end
end
