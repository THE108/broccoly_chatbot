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
      when 'Go!'
        createButtonTemplate(
            'Select gender you identity with',
            'Female',
            'Male',
            'Neutral',
        )
      when 'Male', 'Female', 'Neutral'
        User.where(facebook_id: fb_params.sender_id).update_all(gender: value)
        createButtonTemplate(
            'Great. Which is your favorite mobile phone brand?',
            'Apple',
            'Sumsung',
            'Huawei',
        )
      when 'Apple', 'Sumsung', 'Huawei'
        User.where(facebook_id: fb_params.sender_id).update_all(brand: value)
        createButtonTemplate(
            'What is your preffered mobile platform?',
            'iOS',
            'Android',
            'Windows',
        )
      when 'iOS', 'Android', 'Windows'
        User.where(facebook_id: fb_params.sender_id).update_all(platform: value)
        createButtonTemplate(
          'In what price tier do you prefer to shop?',
          'Mass Market (<$200)',
          'Contemporary ($200-400)',
          'Luxury ($400-1000+)',
        )
      when 'Mass Market (<$200)', 'Contemporary ($200-400)', 'Luxury ($400-1000+)'
        User.where(facebook_id: fb_params.sender_id).update_all(price_category: value)
          createButtonTemplate(
              'Cool! Do you like to take fotos?.',
              'Sure',
              'Not so much',
              'Not at all',
          )
      when 'Sure', 'Not so much', 'Not at all'
        User.where(facebook_id: fb_params.sender_id).update_all(camera: value)
        createButtonTemplate(
          'And how many sim cards you wish your phone has?',
          'Only one',
          'Two',
          'Three or more',
        )
      when 'Only one', 'Two', 'Three or more'
        User.where(facebook_id: fb_params.sender_id).update_all(mood: value)
        createButtonTemplate(
          'Do you like playing games on your mobile phone?',
          'I love playing games!',
          'I play games some times',
          'I don\'t play games on my phone',
        )
      when 'I love playing games!', 'I play games some times', 'I don\'t play games on my phone'
        User.where(facebook_id: fb_params.sender_id).update_all(personality: value)

        items = User.find_by(facebook_id: fb_params.sender_id).matching_items.first(3)
        Messenger::Client.send(
          Messenger::Request.new(
            Messenger::Elements::Text.new(text: "Your brands are #{items.map(&:name).join(', ')}"),
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
