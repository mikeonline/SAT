App.info({
  id: 'com.HackIt.GovHack-Perth.SAT',
  name: 'SAT',
  description: 'Situational Awareness Tool For country volunteer firefighters',
  author: 'Matt Development Group',
  email: 'contact@example.com',
  website: 'http://example.com'
});


# Set PhoneGap/Cordova preferences
App.setPreference('BackgroundColor', '0xff0000ff')
App.setPreference('HideKeyboardFormAccessoryBar', true)



App.accessRule('*.google.com/*')
App.accessRule('*.googleapis.com/*')
App.accessRule('*.gstatic.com/*')