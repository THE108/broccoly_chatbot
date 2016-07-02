include Facebook::Messenger

Bot.on :message do |message|
  puts message.inspect
  sender_id = message.sender['id']
  save_user(sender_id)

  unless message.echo?
    if message.text == "secret"
      item = User.find_by(facebook_id: sender_id).matching_item
      createGenericTemplateForItem(sender_id, item)
    else
      Bot.deliver(
          recipient: message.sender,
          message: {
              text: 'Hello, human!'
          }
      )
    end
  end
end

Bot.on :postback do |postback|
  puts postback.inspect

  value = postback.payload
  sender_id = postback.sender['id']

  save_user(sender_id)

  case value
    when 'Go!'
      createButtonTemplate(
          postback.sender,
          'Great. Which is your favorite color?',
          'Silver',
          'Grey',
          'Gold',
      )
    when 'Silver', 'Grey', 'Gold'
      User.where(facebook_id: sender_id).update_all(color: value)
      createButtonTemplate(
          postback.sender,
          'What is your preffered mobile platform?',
          'iOS',
          'Android',
          'Windows',
      )
    when 'iOS', 'Android', 'Windows'
      User.where(facebook_id: sender_id).update_all(platform: value)
      createButtonTemplate(
          postback.sender,
          'In what price tier do you prefer to shop?',
          'Mass Market (<$200)',
          'Contemporary ($200-400)',
          'Luxury ($400-1000+)',
      )
    when 'Mass Market (<$200)', 'Contemporary ($200-400)', 'Luxury ($400-1000+)'
      User.where(facebook_id: sender_id).update_all(price_category: value)
      createButtonTemplate(
          postback.sender,
          'Cool! Do you like to take fotos?.',
          'Sure',
          'Not so much',
          'Not at all',
      )
    when 'Sure', 'Not so much', 'Not at all'
      User.where(facebook_id: sender_id).update_all(camera: value)
      createButtonTemplate(
          postback.sender,
          'And how many sim cards you would like to have?',
          'Only one',
          'Two',
          'Three or more',
      )
    when 'Only one', 'Two', 'Three or more'
      User.where(facebook_id: sender_id).update_all(sim_count: value)
      createButtonTemplate(
          postback.sender,
          'Do you like playing games on your mobile phone?',
          'I love playing games!',
          'I play games some times',
          'I don\'t play games on my phone',
      )
    when 'I love playing games!', 'I play games some times', 'I don\'t play games on my phone'
      User.where(facebook_id: sender_id).update_all(cpu_category: value)
      item = User.find_by(facebook_id: sender_id).matching_item
      createGenericTemplateForItem(sender_id, item)
  end
end

def save_user(sender_id)
  unless User.exists?(facebook_id: sender_id)

    response = HTTParty.get("https://graph.facebook.com/v2.6/#{sender_id}?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token=#{ENV['MESSENGER_PAGE_ACCESS_TOKEN']}")
    fb_data = JSON.parse(response.body)

    User.create(
        facebook_id: sender_id,
        first_name: fb_data['first_name'],
        last_name: fb_data['last_name']
    )

  end
end


def createButtonTemplate(sender, name, *options)
  buttons = []
  options.each do |val|
    buttons.push({
        type: 'postback',
        title: val,
        payload: val
     })
  end

  Bot.deliver(
      recipient: sender,
      message: {
          attachment: {
              type: 'template',
              payload: {
                  template_type: 'button',
                  text: name,
                  buttons: buttons
              }
          }
      }
  )
  end
end

def createQuickReplie(sender, name, *options)
  replies = []
  options.each do |val|
    replies.push({
        content_type: 'text',
        title: val,
        payload: val
     })
  end

  Bot.deliver(
      recipient: sender,
      text: name,
      quick_replies: replies,
  )
end

def createGenericTemplateForItem(sender_id, item)
  voucher = getVoucher()
  Bot.deliver(
      recipient: {
          id: sender_id,
      },
      message:{
          attachment:{
              type: 'template',
              payload: {
                  template_type: "generic",
                  elements:[
                      {
                          title: item.name,
                          image_url: item.picture_URL,
                          subtitle: "Special price for you $#{item.price}! Use voucher #{voucher} to have a discount!",
                          buttons:[
                              {
                                  type:"web_url",
                                  url: item.page_URL,
                                  title:"Buy now!"
                              }
                          ]
                      }
                  ]
              }
          }
      }
  )
end

def getVoucher
  rand(36**5).to_s(36)
end