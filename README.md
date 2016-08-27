# Tree of Savior Addons

### FPS Savior v1.0.5

Similar to [adjv's](https://github.com/axjv) SFX Toggle however instead of changing settings based on your fps I made it so you can just toggle between 3 predefined settings High, Low, and Super Low. This is likely obvious but FPS Savior is not compatible SFX Toggle, use only one or the other if you use both they will conflict with each other.

Current Setting is displayed right below the FPS display's default location. This display is movable.

![FPS Savior UI](http://i.imgur.com/vWH9GhG.png)

* [High] Exactly how it sounds, everything is set to high.

* [Low] Lowest settings except effects are still visible. Players drawn outside a certain range from you is limited to 15, and monsters drawn outside a certain range from you is limited to 30.

* [Super Low] This is the lowest I could make the settings while still being able to see what your doing. Not recommended for PvP since some effects are not visible and well... you can't see the players attacking you :P. Players drawn is set to -100 which removes themm all besides yourself, and monsters drawn is the same as low mode so as to not make bosses disappear if there are too many mobs or objects that are catagorized as mobs. I created this mode for world bossing, since you don't need to see anything except for the boss and your own aiming circles to dps it.

##### Slash Commands (Use the ingame macro system (f8) to use slash commands more efficiently.)
* `/fpssavior` to toggle between High, Low, and Super Low.
* `/fpssavior lock` to unlock/lock the settings display in order to move it around.
* `/fpssavior default` to restore settings display to its default location.

### Zoomy Plus v1.0.4

This mod is based off of and named after [Excrulon's](https://github.com/Excrulon) Zoomy v1.0.0 that he took off of the [Addon Manager](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager) due to people whining about it being unfair. While it is true that it gives an unfair advantage in Team Battle League many people use it anyway and its available for anyone to download/install. Really IMC should just disable the custom camera zoom function while in Team Battle League fixing the issue all together. Honestly its more unfair to those who didn't install Zoomy before it was taken off the [Addon Manager](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager) since those who already had it installed still have it. Besides, this can be used to capture some very neat pictures at angles normally not possible so I wanted to share.

Current Zoom level and XY coordinates are displayed right below (if you have it) the current FPS Savior setting display which is right below the FPS display's default location. This display is movable and hideable.

![Zoomy Plus UI](http://i.imgur.com/pk2FACc.png)

Use Page Up to zoom in and Page Down to zoom out. Doing so while holding Left Ctrl makes zooming in and out 5 times faster. Also while holding Left Ctrl you can press and hold Right Click to rotate the camera by moving the mouse!

##### Slash Commands (Use the ingame macro system (f8) to use slash commands more efficiently.)
* `/zplus zoom <num>` to go to a specific zoom level anywhere between 50 and 1500!
 * Example: `/zplus zoom 800`
* `/zplus swap <num1> <num2>` to swap between two zoom levels!
 * Example: `/zplus swap 350 500`
* `/zplus rotate <x> <y>` to rotate camera to specific coordinates between 0 and 359!
 * Example: `/zplus rotate 90 10`
* `/zplus reset` to restore default xy positioning and zoom level.
* `/zplus reset xy` to restore default positioning to xy only.
* `/zplus display` to show/hide the coordinate display.
* `/zplus lock` to unlock/lock the coordinate display in order to move it around.
* `/zplus default` to restore coordinate display to its default location.
* `/zplus help` for help ingame.

### Wonderland v1.0.1

Wonderland allows you to increase/decrease the size of yourself and targets, as well as rotate the direction targets are facing, for neat pictures and all around fun. All of these changes are made on your screen only, and do not effect others gameplay. By typing `/wonderland` or `/wl` ingame you can open Wonderland's UI which looks like a book. This book has two pages (well techniquely four but w/e) the self page and the target page. You can switch between these pages by using the next and previous page buttons or by double right clicking the book.

![Wonderland Self Page](http://i.imgur.com/Wz19KUX.png)
![Wonderland Target Page](http://i.imgur.com/u8uG0i5.png)

* __Percent (%)__ controls the amount that you increase/decrease the size of yourself or your target. For example, if you set it to 50% and click the "Eat Me" button on the self page you will grow 50% larger. Keep in mind that if you decrease yourself or your target by 100% then you/they/it will disappear leaving nothing to increase or decrease in size. Go through any loading screen to fix this and reset other changes.

* __Speed__ controls the speed at which size changes occur. Speed 0 being instantaneous and speed 10 being slowest.
 
Need to rotate the direction a target is facing? Use the slash commands mentioned below. The difference between the two commands is rotate1 rotates the target once while rotate2 rotates it twice. Why would a target need to be rotated twice? Well if you only rotate it once it will only rotate the body or if the change in degrees is not enough to change the direction of the body then it wont rotate at all. Sending the command twice makes sure it fully rotates, however I gave the option to rotate once because some of you may want to play around with it and rotate only the body while the head still faces the previous direction. Keep in mind that not all targets are rotatable, an example of this would be the Statue of Goddess Ausrine in Klaipeda. The same goes for increasing/decreasing size, some seem to not be able to be changed. Like the statue in Orsha, though the one in Klaipeda can change size but not rotate, the one in Orsha can't do either. I look forward to seeing creative pictures made by people using this and/or Zoomy Plus in the near future. Enjoy! :P

##### Slash Commands (Use the ingame macro system (f8) to use slash commands more efficiently.)
* `/wonderland` or `/wl` to open & close the wonderland book.
* `/wonderland rotate1 <num°>` or `/wl rotate1 <num°>` to rotate target to designated degrees once.
 * Example: `/wl rotate1 157.51`
* `/wonderland rotate2 <num°>` or `/wl rotate2 <num°>` to rotate target to designated degrees twice.
 * Example: `/wl rotate2 20.93`

### The Bigger They Are v1.0.0

I've been looking for a way to deal with targeting mounted companions in mouse mode for awhile. I and everyone else I've spoken with in the addon community can't seem to find a way to make selective targets untargetable or switch to the owner of that target. So... I made this instead, it's a bit funny but it works! This addon makes it so when you target a companion that is mounted, the mounted players head triples in size. This will also occur if you happen to successfully target the player that is mounted. If the player is no longer mounted and is targeted or their companion is targeted, their heads size will change back to normal. Now this doesn't fix the issue that you CAN target the companions however it gives you a larger target to actually lock on to.

![The Bigger They Are](http://i.imgur.com/Noow3mP.png)

Here is an example of head size being tripled. (The actual addon won't change the size of your own characters head if you happen to target your companion while mounted.)

# Download

Install addons via the [Addon Manager](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager).
