#  tictactoe 

this app was developed for iOS 14.0/14.2 using Xcode 12

it was created using SwiftUI 

uses firebase auth and realtime database


to run the app, make sure you have these things installed:

- Xcode 12
- Simulators running iOS 14.0/14.2 
- Cocoapods 

Then:

- unzip the folder 
- navigate to the working directory and run `pod install`
- double click `tictactoe.xcworkspace` to open it in xcode
- launch two simulators, click the play button at the top left

There might be warnings about updating project settings and stuff,
please ignore those. If you let xcode "fix" them then it breaks 
my project.

The GoogleService-Info.plist file 
is already contained in the subdirectory, 
so firebase should work right away.



resources used

https://developer.apple.com/tutorials/swiftui
https://benmcmahen.com/authentication-with-swiftui-and-firebase/
https://github.com/marty-suzuki/TicTacToe-SwiftUI/blob/master/
https://medium.com/@guilhermegirotto/launch-multiple-simulators-in-a-single-build-xcode-9-xcode-10-5c8d13f01376


a.
A6 - TicTacToe
Luke Ludlow
u1216122
luke.ludlow@utah.edu

b.
// TODO description

c.
c.1. To complete task 1, // TODO

Please note that I define an "open" game slightly differently.
I consider an open game to be one that isn't complete. 
When two players have joined the game, I still allow it 
to be seen on the dashboard so that a player can leave the 
game and come back while it's still in progress.

Also note that not _every_ screen has a logout button,
just the dashboard. I felt like it was unnecessary clutter 
to include a logout button inside the game screens.


c.2. To complete task 2, // TODO

Single-player mode uses the same code as two-player mode. 
A single-player match is still hosted on firebase, it can't be played offline.
I could have made a fully offline mode but I preferred this way because 
it was better code reuse, and it also allows the 
user to leave and come back to the game while it's still in progress, 
even though they're just playing against a CPU.

c.3. To complete task 3, // TODO
c.4. To complete task 4, // TODO


d.
instructions on how to run my app

e.
x hours

f.
x/10 difficulty

