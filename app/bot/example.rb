include Facebook::Messenger

Bot.on :message do |message|
  puts message.inspect
  sender_id = message.sender['id']
  save_user(sender_id)

  unless message.echo?
    if message.text == 'result'
      items = FbUser.find_by(facebook_id: sender_id).matching_items
      createGenericTemplateForItems(sender_id, items)
    elsif message.text == 'restart'
      start_question(message.sender)
    elsif message.text == 'login'
      login(sender_id)
    elsif message.messaging['message']['quick_reply']
      value = message.text
      case value
        when 'Silver', 'Grey', 'Gold'
          FbUser.where(facebook_id: sender_id).update_all(color: value)
          createQuickReply(
              message.sender,
              'What is your preferred mobile platform?',
              'iOS',
              'Android',
              'Windows',
          )
        when 'iOS', 'Android', 'Windows'
          FbUser.where(facebook_id: sender_id).update_all(platform: value)
          createQuickReply(
              message.sender,
              'In what price tier do you prefer to shop?',
              '<$200',
              '$200-400',
              '$400-1000+',
          )
        when '<$200', '$200-400', '$400-1000+'
          FbUser.where(facebook_id: sender_id).update_all(price_category: value)
          createQuickReply(
              message.sender,
              'Cool! Do you like to take photos?',
              'Sure',
              'Not so much',
              'Not at all',
          )
        when 'Sure', 'Not so much', 'Not at all'
          FbUser.where(facebook_id: sender_id).update_all(camera: value)
          createQuickReply(
              message.sender,
              'And how many SIM cards you would like to have?',
              'Only one',
              'Two',
              'Three or more',
          )
        when 'Only one', 'Two', 'Three or more'
          FbUser.where(facebook_id: sender_id).update_all(sim_count: value)
          createQuickReply(
              message.sender,
              'Do you like playing games on your mobile phone?',
              'I love it',
              'Sometimes',
              'Never',
          )
        when 'I love it', 'Sometimes', 'Never'
          FbUser.where(facebook_id: sender_id).update_all(cpu_category: value)
          items = FbUser.find_by(facebook_id: sender_id).matching_items
          createGenericTemplateForItems(sender_id, items)
      end
    end
  end
end

Bot.on :postback do |postback|
  puts postback.inspect

  value = postback.payload
  sender_id = postback.sender['id']

  save_user(sender_id)

  case value
  when 'Go!', 'restart'
      start_question(postback.sender)
  when 'result'
    items = FbUser.find_by(facebook_id: sender_id).matching_items
    createGenericTemplateForItems(sender_id, items)
  end
end

Bot.on :account_linking do |linking|
  if linking.status == 'linked'
    FbUser.where(facebook_id: linking.sender['id']).update_all(auth_code: linking.authorization_code)
  end
end

Bot.on :optin do |opt|
  Bot.deliver(
    recipient: opt.sender,
    message: {
      text: "You just sent ref: #{opt.ref}"
    }
  )
end

def start_question(sender)
  createQuickReply(
      sender,
      'Hi! Answer some questions and we\'ll find what you like on Lazada and provide you with discount. Which is your favorite color?',
      'Silver',
      'Grey',
      'Gold',
  )
end

def save_user(sender_id)
  unless FbUser.exists?(facebook_id: sender_id)

    response = HTTParty.get("https://graph.facebook.com/v2.6/#{sender_id}?fields=first_name,last_name,profile_pic,locale,timezone,gender&access_token=#{ENV['MESSENGER_PAGE_ACCESS_TOKEN']}")
    fb_data = JSON.parse(response.body)

    FbUser.create(
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

def createQuickReply(sender, name, *options)
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
      message: {
        text: name,
        quick_replies: replies,
      }
  )
end

def createGenericTemplateForItems(sender_id, items)
  voucher = getVoucher()
  elements = []
  items.each do |item|
    elements << {
      title: item.name,
      image_url: item.picture_URL,
      subtitle: "Special price for you $#{item.price}! Use voucher '#{voucher.to_upper}' to have a discount!",
      buttons:[
        {
          type:"web_url",
          url: item.page_URL,
          title:"See details"
        },
        {
          type:"web_url",
          payload: "BUY_NOW",
          title:"Buy now!"
        }
      ]
    }
  end
  Bot.deliver(
      recipient: {
          id: sender_id,
      },
      message:{
          attachment:{
              type: 'template',
              payload: {
                  template_type: "generic",
                  elements: elements,
              }
          }
      }
  )
end

def login(sender_id)
  Bot.deliver(
    recipient: {
      id: sender_id,
    },
    message:{
      attachment:{
        type: 'template',
        payload: {
          template_type: "generic",
          elements: [{
            title: 'Welcome!',
            image_url: 'http://vignette3.wikia.nocookie.net/logopedia/images/f/fb/Lazada_logo_new.png/revision/latest?cb=20150131203825',
            buttons: [{
              type: 'account_link',
              url: 'https://lazada-fb-bot.herokuapp.com/oauth/authorize'
            }]
          }],
        }
      }
    }
  )
end

def getVoucher
  rand(36**5).to_s(36)
end
