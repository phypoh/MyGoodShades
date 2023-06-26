# MyGoodShades: A Hades Mod for Twitch Integration with Crowd Control

Written for [CrowdControl](https://crowdcontrol.live/), a Twitch integration application for streamers. Made for easy one-click installation. 

This was written for Crowd Control 2.0, currently in closed beta.



## List of effects

**General Effects**

| Effect              | Price | Description                                                  |
| ------------------- | ----- | ------------------------------------------------------------ |
| Hello World         | 1     | Don't be rude, Zagreus. Say hello!                           |
| No Escape           | 1000  | Send Zag back to the house of Hades, forcing him to start the run over. |
| Boost God Gauge     | 15    | Max out the God Gage, only if Zagreus has a call.            |
| Give Death Defiance | 50    | Give Zagreus a Death Defiance!                               |
| Take Death Defiance | 100   | Take away a Death Defiance!                                  |
| Flashbang           | 25    | Flashbang the player for 5 seconds!                          |



**Shades' Aid**

| Effect          | Price | Description                                                  |
| --------------- | ----- | ------------------------------------------------------------ |
| Summon Dusa     | 25    | Summon besssssssst girl to help.                             |
| Summon Skelly   | 25    | Summon Skelly's decoy to distract enemies.                   |
| Summon Bouldy   | 20    | Summon Bouldy to smash enemies and drop a smattering of gifts!. |
| Deus Ex Machina | 25    | Deal a ton of damage to every enemy in the room!             |



**Drop Loot**

| Effect             | Price | Description                                            |
| ------------------ | ----- | ------------------------------------------------------ |
| Drop Healing       | 1     | Drop a delicious healing gyro                          |
| Drop Obol          | 5     | Drop 30 obol! Finder's keepers!                        |
| Drop Nectar        | 10    | Drop some yummy nectar.                                |
| Drop Pom Slice     | 10    | Drop a pomegranate slice that levels up a random boon! |
| Styx Antidote      | 1     | Cures Zagreus from Styx Poison.                        |
| Drop Boon          | 50    | Airdrops a random god's boon.                          |
| Drop Hammer        | 50    | Airdrops a Daedalus Hammer.                            |
| Drop Centaur Heart | 25    | Drops a Centaur Heart.                                 |
| Drop Pom of Power  | 25    | Drops a Pom of Power                                   |



**Spawn Enemies**

| Effect               | Price | Description                                                  |
| -------------------- | ----- | ------------------------------------------------------------ |
| Spawn Numbskulls     | 20    | Summon some armoured numbskulls for Zag to butt heads with.  |
| Spawn Flamewheels    | 30    | Spawn some mini chariots that explode when they touch Zag!   |
| Spawn Pests          | 20    | Spawn some mine laying pests!                                |
| Spawn a Voidstone    | 30    | Spawn a Voidstone that protects another enemy.               |
| Spawn a Soul Catcher | 40    | Spawn a soul catcher, also known as that-pink-ball-which-spits-butterflies. |
| Spawn a Snakestone   | 40    | Spawn a laser spewing Snakestone!                            |
| Spawn a Satyr        | 50    | Not these guys.                                              |



**Spawn Bosses**

| Effect          | Price | Description                          |
| --------------- | ----- | ------------------------------------ |
| Spawn Meg       | 700   | Hope you picked a safeword.          |
| Spawn Alecto    | 700   | A safeword might not cut it here.    |
| Spawn Tisiphone | 700   | Safeword is 'Murder'                 |
| Spawn Asterius  | 850   | Spawn Asterius, the hero of Elysium. |
| Spawn Theseus   | 800   | Spawn Asterius's Sidekick.           |



**Weapon Swap**

| Effect      | Price | Description                          |
| ----------- | ----- | ------------------------------------ |
| Sword Swap  | 300   | Swap Zagreus's weapon to the sword.  |
| Spear Swap  | 300   | Swap Zagreus's weapon to the spear.  |
| Shield Swap | 300   | Swap Zagreus's weapon to the shield. |
| Bow Swap    | 300   | Swap Zagreus's weapon to the bow.    |
| Fist Swap   | 300   | Swap Zagreus's weapon to the fists.  |
| Gun Swap    | 300   | Swap Zagreus's weapon to the gun.    |

Note: Weapon Swap is temporarily while waiting for support for bidwars on CrowdControl 2.0 beta 



---

## Crowd Control for SGG Games

Should work on Hades and Pyre and hopefully Hades 2 after some minor alterations.    
This will NOT work on Windows Store / Game Pass games.

You need the latest [`Mod Importer`](https://github.com/SGG-Modding/ModImporter), [`Mod Utility`](https://github.com/SGG-Modding/ModUtil), and [`StyxScribe`](https://github.com/SGG-Modding/StyxScribe).     
(get `Mod Importer` from GitHub releases, and the rest by cloning the respective repositories)

For clarification, `Mod Importer`'s content should be extracted to the `Content` folder, `Mod Utility`'s content should be in a folder called `ModUtil` with a `modfile.txt` directly inside, then put that folder in `Content/Mods`, `StyxScribe`'s content should be put directly into your game's top level directory, so for Hades that's just the folder `Hades.game.app` on macOS and `Hades` on the rest.

You need at least [`python 3.8`](https://www.python.org/downloads/) and you need to run `Mod Importer`'s `modimporter<.ext>` (where `<.ext>` depends on which version you got) first, and then run the appropriate `Subsume<game>.py` such as `SubsumeHades.py` for Hades.
    
For modders, use the [Crowd Control SDK](https://forum.warp.world/t/how-to-setup-and-use-the-crowd-control-sdk/5121) to test effects by loading the a `.cs` file in `Content/CrowdControlContent`.          
You can fork this repo and make pull requests but try to only make changes to the `Packs` folder.   
The [Base Pack](Packs/CrowdControl.Packs.Base.lua) contains a lot of comments that hopefully make the format clear.

For streamers, use the [Crowd Control Twitch extension and the Crowd Control app](https://crowdcontrol.live/setup) to load a `.ccpack` file in `Content/CrowdControlContent`.
You may also need the [Crowd Control SDK](https://forum.warp.world/t/how-to-setup-and-use-the-crowd-control-sdk/5121) to turn a `.cs` file into a `.ccpack`, as that assigns points to the effects.
