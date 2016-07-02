include Facebook::Messenger

Bot.on :message do |message|
  puts message.inspect
  if message.sender['id'] != '255096811549063'
    Bot.deliver(
        recipient: message.sender,
        message: {
            text: 'Hello, human!'
        }
    )
  end
end


# def webhook
#   logger.debug "message?: #{fb_params.first_entry.callback.message?}
# delivery?: #{fb_params.first_entry.callback.delivery?}
# postback?: #{fb_params.first_entry.callback.postback?}"
#
#   if fb_params.first_entry.callback.message?
#     Messenger::Client.send(
#         Messenger::Request.new(
#             Messenger::Elements::Text.new(text: "Your wrote #{fb_params.first_entry.callback.text}"),
#             fb_params.first_entry.sender_id
#         )
#     )
#   end
#
#   unless User.exists?(facebook_id: fb_params.first_entry.sender_id)
#     fb_data = JSON.parse(Messenger::Client.get_user_profile(fb_params.first_entry.sender_id))
#     User.create(
#         facebook_id: fb_params.first_entry.sender_id,
#         first_name: fb_data['first_name'],
#         last_name: fb_data['last_name']
#     )
#
#   end
#   if fb_params.first_entry.callback.postback?
#     value = fb_params.send(:messaging_entry)['postback']['payload']
#     case value
#       when 'Go!'
#         createButtonTemplate(
#             'Great. Which is your favorite color?',
#             'Silver',
#             'Grey',
#             'Gold',
#         )
#       when 'Silver', 'Grey', 'Gold'
#         User.where(facebook_id: fb_params.first_entry.sender_id).update_all(color: value)
#         createButtonTemplate(
#             'What is your preffered mobile platform?',
#             'iOS',
#             'Android',
#             'Windows',
#         )
#       when 'iOS', 'Android', 'Windows'
#         User.where(facebook_id: fb_params.first_entry.sender_id).update_all(platform: value)
#         createButtonTemplate(
#             'In what price tier do you prefer to shop?',
#             'Mass Market (<$200)',
#             'Contemporary ($200-400)',
#             'Luxury ($400-1000+)',
#         )
#       when 'Mass Market (<$200)', 'Contemporary ($200-400)', 'Luxury ($400-1000+)'
#         User.where(facebook_id: fb_params.first_entry.sender_id).update_all(price_category: value)
#         createButtonTemplate(
#             'Cool! Do you like to take fotos?.',
#             'Sure',
#             'Not so much',
#             'Not at all',
#         )
#       when 'Sure', 'Not so much', 'Not at all'
#         User.where(facebook_id: fb_params.first_entry.sender_id).update_all(camera: value)
#         createButtonTemplate(
#             'And how many sim cards you would like to have?',
#             'Only one',
#             'Two',
#             'Three or more',
#         )
#       when 'Only one', 'Two', 'Three or more'
#         User.where(facebook_id: fb_params.first_entry.sender_id).update_all(sim_count: value)
#         createButtonTemplate(
#             'Do you like playing games on your mobile phone?',
#             'I love playing games!',
#             'I play games some times',
#             'I don\'t play games on my phone',
#         )
#       when 'I love playing games!', 'I play games some times', 'I don\'t play games on my phone'
#         User.where(facebook_id: fb_params.first_entry.sender_id).update_all(cpu_category: value)
#         item = User.find_by(facebook_id: fb_params.first_entry.sender_id).matching_item
#         Messenger::Client.send(
#             Messenger::Request.new(
#                 createGenericTemplateForItem(item),
#                 fb_params.first_entry.sender_id
#             )
#         )
#     end
#   end
#   render nothing: true, status: 200
# rescue Exception => e
#   logger.debug "EXCEPTION!!!! #{e.message} #{e.backtrace}"
#   render nothing: true, status: 200
# end
#
# private
#
# def createButtonTemplate(name, *options)
#   buttons = []
#   options.each do |val|
#     buttons.push(Messenger::Elements::Button.new(
#         type: 'postback',
#         title: val,
#         value: val
#     ))
#   end
#
#   Messenger::Client.send(
#       Messenger::Request.new(Messenger::Templates::Buttons.new(
#           text: name,
#           buttons: buttons,
#       ), fb_params.first_entry.sender_id)
#   )
# end
#
# def createGenericTemplateForItem(item)
#   voucher = getVoucher()
#   bubble = Messenger::Elements::Bubble.new(
#       title: item.name,
#       subtitle: "Special price for you $#{item.price}! Use voucher #{voucher} to have a discount!",
#       item_url: item.page_URL,
#       image_url: item.picture_URL,
#       buttons: [
#           Messenger::Elements::Button.new(
#               type: 'web_url',
#               title: 'Buy now!',
#               value: item.page_URL
#           )
#       ]
#   )
#   Messenger::Templates::Generic.new(elements: [bubble])
# end
#
# def getVoucher()
#   rand(36**5).to_s(36)
# end

# def createQuickReplie(name, *options)
# end