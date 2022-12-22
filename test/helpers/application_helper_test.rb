require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase 

    def setup
        @base_title = "Ruby on Rails Tutorial Sample App"
    end


    test "full title helper" do
        assert_equal page_full_title, @base_title
        assert_equal page_full_title("Help"), "Help | #{@base_title}"
    end
end
