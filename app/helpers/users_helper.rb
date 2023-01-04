module UsersHelper

    def gravatar_for(user, options = { size: 80, classes:"" })
        size = options[:size]
        classes = options[:classes]
        
        gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
        gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
        image_tag(gravatar_url, alt:user.name, class: "gravatar #{classes}")
    end
end
