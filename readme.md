#  tictactoe 

## a
A6 - tictactoe
Luke Ludlow
u1216122
luke.ludlow@utah.edu


## b
This app was developed for iOS 14.0/14.2 using Xcode 12.
It was created using SwiftUI.
It uses firebase for authorization and for realtime database services.

This is a simple tic tac toe app where players 
can play against each other in realtime or play solo against a CPU.
player wins and losses are recorded so they can see their own performance.
Players must register for an account to use the service.

No known bugs.


## c

### Task 1

I created a main ContentView that checks if 
the user is logged in or not. If the user hasn't 
logged in yet, they go to the authorization screen.
While the user is logged in, they'll be directed to the dashboard.
Task 1 was accomplished with things in the Login directory and the
main directory.
I used firebase for authorization. 

Please note that I define an "open" game slightly differently.
I consider an open game to be one that isn't complete. 
When two players have joined the game, I still allow it 
to be seen on the dashboard so that a player can leave the 
game and come back while it's still in progress.

Also note that not _every_ screen has a logout button,
just the dashboard. I felt like it was unnecessary clutter 
to include a logout button inside the game screens.

### Task 2

Single-player mode uses the same code as two-player mode. 
A single-player match is still hosted on firebase, it can't be played offline.
I could have made a fully offline mode but I preferred this way because 
it was better code reuse, and it also allows the 
user to leave and come back to the game while it's still in progress, 
even though they're just playing against a CPU.

### Task 3

Task 3 was accomplished mostly in the Game directory. 
There is a MultiPlayerGameView which handles syncing state.
The Game class is an object that's manipulated and synced 
between clients using firebase.

### Task 4

To shake the device, it was difficult to do this with SwiftUI.
I accomplished it by creating a custom NSNotification type, 
then creating an extension for UIWindow, then in my dashboard view 
I added a .onReceive to the body that listens to the device shaken publisher.
It checks the navigationAction state to see if the user is currently 
in the dashboard, because the shake gesture should only be registered 
while in the dashboard.


## d

To run the app, make sure you have these things installed:

- Xcode 12
- Simulators running iOS 14.0/14.2 
- Cocoapods 

Then:

- Unzip the folder 
- Navigate to the working directory and run `pod install`
- Double click `tictactoe.xcworkspace` to open it in xcode
- Launch two simulators, click the play button at the top left

There might be warnings about updating project settings and stuff,
please ignore those. If you let xcode "fix" them then it breaks 
my project.

The GoogleService-Info.plist file 
is already contained in the subdirectory, 
so firebase should work right away.


## e

25 hours

## f

10/10 difficulty. This is because I chose to
do the iOS app and I had to teach myself everything about 
iOS development. But it was worth it!


## resources used

https://developer.apple.com/tutorials/swiftui
https://benmcmahen.com/authentication-with-swiftui-and-firebase/
https://github.com/marty-suzuki/TicTacToe-SwiftUI/blob/master/
https://medium.com/@guilhermegirotto/launch-multiple-simulators-in-a-single-build-xcode-9-xcode-10-5c8d13f01376
https://www.iditect.com/how-to/58549151.html
