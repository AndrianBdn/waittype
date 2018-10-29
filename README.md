# WaitType

Ever needed to type some complicated string (password) somewhere where just pasting doesn't work? 

For example:
- VirtualBox or VMWare window (sure, it supports copy-paste, but what if it is running some obscure OS or you just need to type serial)
- VNC or RDP client, like typing password in VNC client for logging-in on Mac
- or just some text field where paste function was disabled for whatever reason 

Introducing WaitType: simple Mac app that simulates key press buttons from some string that you have pasted in its text field. 

![screenshot](https://raw.githubusercontent.com/AndrianBdn/waittype/master/Screenshots/ScreenShot20181029.png)

## Motivation 

I used to use [this Python / AppleScript](https://gist.github.com/AndrianBdn/69484820345740156a78059d0219ee0f) to do that, but since macOS Mojave it requires Terminal.app to be added to **Accessibility** section of **Security & Privacy**. 

To avoid this a created a simple separate app specifically for this function. You still have to add it to **Accessibility** section of **Security & Privacy**, but unlike Terminal it does not run arbitrary code all the time. 

In fact the source code of the app is super easy to audit and its entitlements does not allow it using network or reading files. 


## Limitations 

Currently the app expects to work in US keyboard layout only. Feel free to PR the fix. 
