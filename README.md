### NOTICE (June 2007)

I quit Tree of Savior sometime around September 2016 and have no idea about the current state of the game and the addon community. However just now having signed in on GitHub I noticed there are issue fix requests for some of the addons I made. I would just like to state that I am no longer modding for this game and any fixes needed due to game updates will need to be done by others whom are still actively modding for Tree of Savior.


# Tree of Savior Addons

### FPS Savior

Similar to [adjv's](https://github.com/axjv) SFX Toggle however instead of changing settings based on your fps I made it so you can just toggle between 3 predefined settings High, Low, and Super Low. This is likely obvious but FPS Savior is not compatible SFX Toggle, use only one or the other if you use both they will conflict with each other.

Current Setting is displayed right below the FPS display's default location. This display is movable.

![FPS Savior UI](http://i.imgur.com/vWH9GhG.png)

* [High] Exactly how it sounds, everything is set to high.

* [Low] Lowest settings except effects are still visible. Players drawn outside a certain range from you is limited to 15, and monsters drawn outside a certain range from you is limited to 30.

* [Super Low] This is the lowest I could make the settings while still being able to see what your doing. Not recommended for PvP since some effects are not visible and well... you can't see the players attacking you :P. Players drawn is set to -100 which removes them all besides yourself, and monsters drawn is the same as low mode so as to not make bosses disappear if there are too many mobs or objects that are catagorized as mobs. I created this mode for world bossing, since you don't need to see anything except for the boss and your own aiming circles to dps it.

##### Slash Commands (Use the ingame macro system (f8) to use slash commands more efficiently.)
* `/fpssavior` to toggle between High, Low, and Super Low.
* `/fpssavior lock` to unlock/lock the settings display in order to move it around.
* `/fpssavior default` to restore settings display to its default location.

### Zoomy Plus

This mod is based off of and named after [Excrulon's](https://github.com/Excrulon) Zoomy v1.0.0 that he took off of the [Addon Manager](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager) due to people whining about it being unfair. While it is true that it gives an unfair advantage in Team Battle League many people use it anyway and its available for anyone to download/install. Really IMC should just disable the custom camera zoom function while in Team Battle League fixing the issue all together. Honestly its more unfair to those who didn't install Zoomy before it was taken off the [Addon Manager](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager) since those who already had it installed still have it. Besides, this can be used to capture some very neat pictures at angles normally not possible so I wanted to share.

Current Zoom level and XY coordinates are displayed right below (if you have it) the current FPS Savior setting display which is right below the FPS display's default location. This display is movable and hideable.

![Zoomy Plus UI](http://i.imgur.com/pk2FACc.png)

Use Page Up to zoom in and Page Down to zoom out. Doing so while holding Left Ctrl makes zooming in and out 5 times faster. Also while holding Left Ctrl you can press and hold Right Click to rotate the camera by moving the mouse!

##### Slash Commands (Use the ingame macro system (f8) to use slash commands more efficiently.)
* `/zplus zoom <num>` to go to a specific zoom level anywhere between 50 and 1500!
 * Example: `/zplus zoom 800`
* `/zplus swap <num1> <num2>` or `/zplus switch <num1> <num2>` to swap/switch between two zoom levels!
 * Example: `/zplus swap 350 500`
* `/zplus rotate <x> <y>` to rotate camera to specific coordinates between 0 and 359!
 * Example: `/zplus rotate 90 10`
* `/zplus reset` to restore default xy positioning and zoom level.
* `/zplus reset xy` to restore default positioning to xy only.
* `/zplus display` to show/hide the coordinate display.
* `/zplus lock` to unlock/lock the coordinate display in order to move it around.
* `/zplus default` to restore coordinate display to its default location.
* `/zplus help` for help ingame.

### Wonderland

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

### The Bigger They Are

I've been looking for a way to deal with targeting mounted companions in mouse mode for awhile. ~~I and everyone else I've spoken with in the addon community can't seem to find a way to make selective targets untargetable or switch to the owner of that target. So... I made this instead, it's a bit funny but it works! This addon makes it so when you target a companion that is mounted, the mounted players head triples in size. This will also occur if you happen to successfully target the player that is mounted. If the player is no longer mounted and is targeted or their companion is targeted, their heads size will change back to normal. Now this doesn't fix the issue that you CAN target the companions however it gives you a larger target to actually lock on to.~~ Okay scratch all that, apparently there is a way to make the companion untargetable after all. We can remove its existence from your screen, however there is no way to bring it back (that I know of) other then passing through a loading screen. I don't believe this is much of an issue though when you consider what it is fixing. Now I decided to leave the big heads cause well, it's a pretty good indicator of knowing if the player is mounted or not. Why would you not know they are mounted or not? Because by sending the players companion into the void it will look like they are running around normally... just quicker.

![The Bigger They Are](http://i.imgur.com/Noow3mP.png)

Here is an example of head size being tripled. (The actual addon won't change the size of your own characters head nor will it make your companion disappear into the void if you happen to target it while mounted.)

### Swapit

My main PvE character is a Cannoneer and for awhile now I've been annoyed by the fact that while I never have my cannon out other then when it auto swaps to it for Cannoneer skills I'm forced to have xbow + cannon in one of my swap lines for it to work. So I made another weapon swap to put my xbow + manamana and 2h bow in and swap between, leaving my xbow + cannon in the original weapon swap so it will auto swap to it when using Cannoneer skills. Heres an example of what I mean:

![Swapit](http://i.imgur.com/aCvskAC.png)

Now some might say this would be exploiting, however the game already lets you do this via hotbar slots this is just more user friendly. Also the left side slots which I added uses the same functions as cwSet to equip/unequip, it's just limited to weapons and has a UI. Not only that but I ADDED the requirement of having the 'Weapon Swap' attribute, since IMC doesn't seem to know how to do such things server side I did it for them (not that the attribute costs anything >.>).

##### Slash Commands (Use the ingame macro system (f8) to use slash commands more efficiently.)
* `/swapit` or `/si` to swap your left side weapons.
* `/swapit lock` or `/si lock` to unlock/lock the Swapit display in order to move it around. Be sure to lock it again when you have it where you like, otherwise you can't interact with the slots.
* `/swapit default` or `/si default` to restore Swapit display to its default location.

### Mount 'er Good

Sick of your pet getting stuck somewhere leaving you with nothing to mount? Well here you go, this addon teleports your companion to you if its not within range when you try to mount. When/if the companion breaks (stops moving or doing anything) and you move too far away from it for it to teleport then it will be flagged as "broken". While broken it will automatically deactivate when out of range and reactivate 6 seconds later so that its always (accept for that 6 second downtime, assuming you let it get that far away in the first place) within range to teleport/mount.

I know that sometimes you might not want your companion active, such as for quests where you need to interact with a mob without killing it, or perhaps a picture that you dont want the companion in. So for such cases I added a slash command to turn the pet off, or more importantly stop the addon from automatically reactivating it after 6 seconds pass. To do this type `/nopet`, and until you type it again or restart the client your companion will no longer be automatically activated.

# Download

Install addons via the [Addon Manager](https://github.com/Excrulon/Tree-of-Savior-Addon-Manager).
