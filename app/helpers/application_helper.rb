module ApplicationHelper
    # Auto-detect URLs in text and make them clickable
      def auto_link_content(text)
        return "" if text.blank?

        # Escape HTML first to prevent XSS
        escaped = ERB::Util.html_escape(text)

        # Replace URLs with clickable links
        # Matches http://, https://, ftp:// links
        auto_linked = escaped.gsub(
          %r{(https?|ftp)://[^\s<]+}i
        ) do |url|
          # Remove trailing punctuation that's likely not part of the URL
          clean_url = url.gsub(/[.,;:!?)\]]+$/, '')
          display = clean_url.length > 60 ? clean_url[0..56] + "..." : clean_url
          "<a href=\"#{clean_url}\" target=\"_blank\" rel=\"noopener noreferrer\" class=\"text-blue-600 hover:underline break-all\">#{display}</a>"
        end

        # Preserve line breaks
        auto_linked.gsub("\n", "<br>").html_safe
      end

end
