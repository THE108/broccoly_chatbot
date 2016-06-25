class MessengerController < Messenger::MessengerController
  def webhook
    # logger.debug "params: #{params}"
    logger.debug "message?: #{fb_params.message?}
delivery?: #{fb_params.delivery?}
postback?: #{fb_params.postback?}"

    unless User.exists?(facebook_id: fb_params.sender_id)
      fb_data = JSON.parse(Messenger::Client.get_user_profile(fb_params.sender_id))
      User.create(
        facebook_id: fb_params.sender_id,
        first_name: fb_data['first_name'],
        last_name: fb_data['last_name']
      )

    end
    if fb_params.postback?
      value = fb_params.send(:messaging_entry)['postback']['payload']
      case value
      when 'lets starts'
        createButtonTemplate(
            'Select gender you identity with',
            'Female',
            'Male',
            'Neutral',
        )
      when 'Male', 'Female', 'Neutral'
        User.where(facebook_id: fb_params.sender_id).update_all(gender: value)
        createButtonTemplate(
            'Great. Now please select type of items are you looking for.',
            'Clothing',
            'Accessories',
            'Shoes',
            # 'All',
        )
        when 'Clothing', 'Accessories', 'Shoes', 'All'
          User.where(facebook_id: fb_params.sender_id).update_all(piece: value)
          createButtonTemplate(
              'What about your aesthetics? Select the word that most matches your style',
              'Casual',
              'Formal',
              'Active',
              # 'Avant-Garde',
          )
        when 'Casual', 'Formal', 'Active', 'Avant-Garde'
          User.where(facebook_id: fb_params.sender_id).update_all(style: value)
          createButtonTemplate(
              'In what price tier do you prefer to shop?',
              'Mass Market (<$200)',
              'Contemporary ($150-450)',
              'Luxury ($400-1000+)',
          )
        when 'Mass Market (<$200)', 'Contemporary ($150-450)', 'Luxury ($400-1000+)'
          User.where(facebook_id: fb_params.sender_id).update_all(price: value)
          createButtonTemplate(
              'Cool! Select the music style you prefer.',
              'Pop/Indie',
              'Rock',
              'Club/Dance',
              # 'Country/Latin',
          )
        when 'Pop/Indie', 'Rock', 'Club/Dance', 'Country/Latin'
          User.where(facebook_id: fb_params.sender_id).update_all(music: value)
          createButtonTemplate(
              'And what word best describes your most common mood?',
              'Fun/Excited',
              'Chill/Relaxed',
              'Focused',
              # 'Sad/Disapointed/confused',
          )
        when 'Fun/Excited', 'Chill/Relaxed', 'Focused', 'Sad/Disapointed/confused',
          User.where(facebook_id: fb_params.sender_id).update_all(mood: value)
          createButtonTemplate(
              'How would you describe your personality?',
              'Adventurous',
              'Self-Centered',
              'Open/Kind',
              # 'Closed/Introvert',
          )
        when 'Adventurous', 'Self-Centered', 'Open/Kind', 'Closed/Introvert',
          User.where(facebook_id: fb_params.sender_id).update_all(personality: value)

          brands = User.find_by(facebook_id: fb_params.sender_id).matching_brands.first(3)
          Messenger::Client.send(
              Messenger::Request.new(
                  Messenger::Elements::Text.new(text: "Your brands are #{brands.map(&:name).join(', ')}"),
                  fb_params.sender_id
              )
          )
          createButtonTemplate(
              'Select a brand that you know and wear or would like to wear.',
              'no data'
          )
      end
    end
    render nothing: true, status: 200
  end

  private

  def createButtonTemplate(name, *options)
    buttons = []
    options.each do |val|
      buttons.push(Messenger::Elements::Button.new(
          type: 'postback',
          title: val,
          value: val
      ))
    end

    Messenger::Client.send(
        Messenger::Request.new(Messenger::Templates::Buttons.new(
            text: name,
            buttons: buttons,
        ), fb_params.sender_id)
    )
  end
end