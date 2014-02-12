Happy Together
==============

Requirements:

- Be registered with Apple's iOS Developer Program (in order to install the app on your device)
- Have an up-to-date version of Xcode installed and running on your Mac.

Setup:

1. Make sure your Mac and your iOS device are on the same wifi network.
2. Make sure both your Mac and your iOS device have the songs that you want to work with downloaded in iTunes (on the Mac) and in the Music app (on the iOS device). In other words, you probably want to sync at least those playlists via iTunes.
3. Make note of your Mac's IP address under System Preferences (under where it says Status: Connected, look for some smaller type that says something like "Wi-Fi is connected to YourWifiNetwork and has the IP address 192.168.0.11.")
4. Open both the Mac app and the iOS app in Xcode
5. In the iOS app source code, configure the IP address constant at the top of HOLPlaybackManager.m with your Mac's IP address.
6. Build and run the Mac app via Xcode.
7. Build and run the iOS app via Xcode.
8. Play a song your iOS device's Music app. Playback should stop on the Mac.
9. With either the Music app or the HappyTogether app in the foreground, double tap your iOS device. In the initial version of this prototype, air taps seem to work as well or better than taps on a solid surface.
10. Playback should stop on the iOS device and start on the Mac, with this song at the current time position.
