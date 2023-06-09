using System;
using System.Collections.Generic;
using CrowdControl.Common;
using JetBrains.Annotations;
using ConnectorType = CrowdControl.Common.ConnectorType;

namespace CrowdControl.Games.Packs
{
    [UsedImplicitly]
    public class Hades : SimpleTCPPack
    {
        public override string Host => "127.0.0.1";

        public override ushort Port => 58430;

        public override SITimeSpan ResponseTimeout => 20;

        public Hades(UserRecord player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler) : base(player, responseHandler, statusUpdateHandler) { 
            RemoteFunctions = new Dictionary<string, FunctionSet.Callback>
            {
                { "resetPools", (object?[]? args) =>
                    {
                        this.ClearBalance("weaponauction");
                        return true;
                    }
                }
            };
        }

        public override Game Game { get; } = new(84, "Hades", "Hades", "PC", ConnectorType.SimpleTCPConnector);

        // public Dictionary<string, FunctionSet.Callback> RemoteFunctions { get; } = new ()
        // {
        //     {"resetPools", (object?[]? args) => {
        //         ClearBalance("weaponauction");
        //         return true;
        //     } }
        // };

        // do the assignment in the constructor rather than right on the spot
        // that will move you from a static initializer context to an instance 
        // context which will let you reference this.ClearBalances
        // you need to be in an instance context for the implicit this underneath 
        // that ClearBalances reference which is what that error is complaining about

        public override EffectList Effects { get; } = new Effect[]
        {
            new ("Hello World", "MyGoodShades.HelloWorld")
                {Price = 1, Description = "Don't be rude, Zagreus. Say hello!"},
            new ("No Escape", "MyGoodShades.KillHero"){ Duration = 5, Price = 1000, 
                Description = "Send Zag back to the house of Hades, forcing him to start the run over."},
            new ("Boost God Gauge", "MyGoodShades.BuildSuperMeter")
                {Price = 15, Description = "Max out the God Gage, only if Zagreus has a call."},
            new ("Give Death Defiance", "MyGoodShades.DDAdd")
                {Price = 50, Description = "Give Zagreus a Death Defiance!"},
            new ("Take Death Defiance", "MyGoodShades.DDRemove")
                {Price = 100, Description = "Take away a Death Defiance!"},
            new ("Flashbang", "MyGoodShades.Flashbang") 
                {Price = 25, Description = "Flashbang the player for 5 seconds!"},

           
            // Assist pack
            new ("Summon Dusa", "Assists.DusaAssist")
                {Category = "Shades' Aid", Price = 25, Description = "Summon besssssssst girl to help."},
            new ("Summon Skelly", "Assists.SkellyAssist")
                {Category = "Shades' Aid", Price = 25, Description = "Summon Skelly's decoy to distract enemies."},
            new ("Summon Bouldy", "Assists.SisyphusAssist")
                {Category = "Shades' Aid", Price = 20, Description = "Summon Bouldy to smash enemies and drop a smattering of gifts!."},
            // new ("Summon Athena", "Assists.AthenaAssist")
            //     {Price = 20, Description = "Summon Athena to give you invulnerability.", Duration = 5},
            new ("Deus Ex Machina", "Assists.ScreenNuke")
                {Category = "Shades' Aid", Price = 25, Description = "Deal a ton of damage to every enemy in the room!"},

            
            // Cornucopia pack
            new ("Drop Healing", "Cornucopia.DropHeal")
                {Category = "Drop Loot", Price = 1, Description = "Drop a delicious healing gyro."},
            new ("Drop Obol", "Cornucopia.DropMoney")
                {Category = "Drop Loot", Price = 5, Description = "Drop 30 obol! Finder Keepers!"},
            new ("Drop Nectar", "Cornucopia.DropNectar")
                {Category = "Drop Loot", Price = 10, Description = "Drop some yummy nectar."},
            new ("Drop Pom Slice", "Cornucopia.DropPomShard")
                {Category = "Drop Loot", Price = 10, Description = "Drop a pomegranate slice that levels up a random boon!"},
            new ("Styx Antidote", "Cornucopia.PoisonCure")
                {Category = "Drop Loot", Price = 1, Description = "Cures Zagreus from Styx Poison."},
            new ("Drop Boon", "Cornucopia.DropBoon")
                {Category = "Drop Loot", Price = 50, Description = "Airdrops a random god's boon."},
            new ("Drop Hammer", "Cornucopia.DropHammer")
                {Category = "Drop Loot", Price = 50, Description = "Airdrops a Daedalus Hammer."},
            new ("Drop Centaur Heart", "Cornucopia.DropCentaurHeart")
                {Category = "Drop Loot", Price = 25, Description = "Drops a Centaur Heart."},
            new ("Drop Pom of Power", "Cornucopia.DropPom")
                {Category = "Drop Loot", Price = 25, Description = "Drops a Pom of Power."},

            // Legion pack
            new ("Spawn Numbskulls", "Legion.SpawnNumbskull")
                {Category = "Spawn Enemies", Price = 20, Description = "Summon some armoured numbskulls for Zag to butt heads with."},
            new ("Spawn Flamewheels", "Legion.SpawnFlameWheel")
                {Category = "Spawn Enemies", Price = 30, Description = "Spawn some mini chariots that explode when they touch Zag! (Same tho)"},
            new ("Spawn Pests", "Legion.SpawnPest")
                {Category = "Spawn Enemies", Price = 20, Description = "Spawn some mine laying pests!"},
            new ("Spawn a Voidstone", "Legion.SpawnVoidstone")
                {Category = "Spawn Enemies", Price = 30, Description = "Spawn a Voidstone that protects another enemy."},
            new ("Spawn a Soul Catcher", "Legion.SpawnButterflyBall")
                {Category = "Spawn Enemies", Price = 40, Description = "Spawn a soul catcher, also known as that-pink-ball-which-spits-butterflies."},
            new ("Spawn a Snakestone", "Legion.SpawnSnakestone")
                {Category = "Spawn Enemies", Price = 40, Description = "Spawn a laser spewing Snakestone!"},
            new ("Spawn a Satyr", "Legion.SpawnSatyr")
                {Category = "Spawn Enemies", Price = 50, Description = "Not these guys."},

            // Legion pack (bosses)
            new ("Spawn Meg", "Legion.SpawnMeg")
                {Category = "Spawn Bosses", Price = 700, Description = "Hope you picked a safeword."},
            new ("Spawn Alecto", "Legion.SpawnAlecto")
                {Category = "Spawn Bosses", Price = 700, Description = "A safeword might not cut it here."},
            new ("Spawn Tisiphone", "Legion.SpawnTis")
                {Category = "Spawn Bosses", Price = 700, Description = "Safeword is 'Murder'"},
            new ("Spawn Asterius", "Legion.SpawnAsterius")
                {Category = "Spawn Bosses", Price = 850, Description = "Spawn Asterius, the hero of Elysium."},
            new ("Spawn Theseus", "Legion.SpawnTheseus")
                {Category = "Spawn Bosses", Price = 800, Description = "Spawn Asterius's Sidekick."},


            // Auction pack 
            // new ("Weapon Swap", ItemKind.Folder), // new folder for weapon auctions pack
            // new ("Sword Swap", "Auction.SwordSwap")
            //     {Price = 700, Description = "Swap Zagreus's weapon to the sword."},
            // new ("Spear Swap", "Auction.SpearSwap")
            //     {Price = 700, Description = "Swap Zagreus's weapon to the spear."},
            // new ("Shield Swap", "Auction.ShieldSwap")
            //     {Price = 700, Description = "Swap Zagreus's weapon to the shield."},
            // new ("Bow Swap", "Auction.BowSwap")
            //     {Price = 700, Description = "Swap Zagreus's weapon to the bow."},
            // new ("Fist Swap", "Auction.FistSwap")
            //     {Price = 700, Description = "Swap Zagreus's weapon to the fists."},
            // new ("Gun Swap", "Auction.GunSwap")
            //     {Price = 700, Description = "Swap Zagreus's weapon to the gun."},

            // // Auction Bidwar
            // new ("Sword Swap", "Auction.SwordSwap", ItemKind.BidWar)
            //     {Category = "Weapon Swap", Description = "Swap Zagreus's weapon to the sword."},
            // new ("Spear Swap", "Auction.SpearSwap", ItemKind.BidWar)
            //     {Category = "Weapon Swap", Description = "Swap Zagreus's weapon to the spear."},
            // new ("Shield Swap", "Auction.ShieldSwap", ItemKind.BidWar)
            //     {Category = "Weapon Swap", Description = "Swap Zagreus's weapon to the shield."},
            // new ("Bow Swap", "Auction.BowSwap", ItemKind.BidWar)
            //     {Category = "Weapon Swap", Description = "Swap Zagreus's weapon to the bow."},
            // new ("Fist Swap", "Auction.FistSwap", ItemKind.BidWar)
            //     {Category = "Weapon Swap", Description = "Swap Zagreus's weapon to the fists."},
            // new ("Gun Swap", "Auction.GunSwap", ItemKind.BidWar)
            //     {Category = "Weapon Swap", Description = "Swap Zagreus's weapon to the gun."},
            // new ("Clear Bids", "resetPools")
            //     {Price = 10000, Description = "Swap Zagreus's weapon to the gun."},

        };
        

        
    }
        
}

