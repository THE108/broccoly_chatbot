task :thread => [:environment] do

  Facebook::Messenger::Thread.set(
    setting_type: 'call_to_actions',
    thread_state: 'new_thread',
    call_to_actions: [
      {
        payload: 'Go!'
      }
    ]
  )

  Facebook::Messenger::Thread.set(
    setting_type: 'call_to_actions',
    thread_state: 'existing_thread',
    call_to_actions: [
      {
        type: 'postback',
        title: 'Show onsale items',
        payload: 'result'
      },
      {
        type: 'postback',
        title: 'Start a new order',
        payload: 'restart'
      },
      {
        type: 'web_url',
        title: 'Visit Website',
        url: 'http://www.lazada.com.my/'
      }
    ]
  )
end