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

        public Hades(IPlayer player, Func<CrowdControlBlock, bool> responseHandler, Action<object> statusUpdateHandler) : base(player, responseHandler, statusUpdateHandler) { }

        public override Game Game { get; } = new(84, "Hades", "Hades", "PC", ConnectorType.SimpleTCPConnector);

        public override List<Effect> Effects { get; } = new()
        {
            new Effect("Hello World", "MyGoodShades.HelloWorld")
                { Price = 1, Description = "Don't be rude, Zagreus. Say hello!"},
            new Effect("No Escape", "MyGoodShades.KillHero"){ Duration = 5, Price = 1000, 
                Description = "Send Zag back to the house of Hades, forcing him to start the run over."},
            new Effect("Boost God Gauge", "MyGoodShades.BuildSuperMeter")
                {Price = 15, Description = "Max out the God Gage, only if Zagreus has a call."},
            new Effect("Give Death Defiance", "MyGoodShades.DDAdd")
                {Price = 50, Description = "Give Zagreus a Death Defiance!"},
            new Effect("Take Death Defiance", "MyGoodShades.DDRemove")
                {Price = 100, Description = "Take away a Death Defiance!"},
            new Effect("Flashbang", "MyGoodShades.Flashbang") 
                {Price = 25, Description = "Flashbang the player for 5 seconds!"},

           
            // Assist pack
            new Effect("Summon Dusa", "Assists.DusaAssist")
                {Price = 25, Description = "Summon besssssssst girl to help."},
            new Effect("Summon Skelly", "Assists.SkellyAssist")
                {Price = 25, Description = "Summon Skelly's decoy to distract enemies."},
            new Effect("Summon Bouldy", "Assists.SisyphusAssist")
                {Price = 20, Description = "Summon Bouldy to smash enemies and drop a smattering of gifts!."},
            // new Effect("Summon Athena", "Assists.AthenaAssist")
            //     {Price = 20, Description = "Summon Athena to give you invulnerability.", Duration = 5},
            new Effect("Deus Ex Machina", "Assists.ScreenNuke")
                {Price = 25, Description = "Deal a ton of damage to every enemy in the room!"},

            
            // Cornucopia pack
            new Effect("Drop Healing", "Cornucopia.DropHeal")
                {Price = 1, Description = "Drop a delicious healing gyro."},
            new Effect("Drop Obol", "Cornucopia.DropMoney")
                {Price = 5, Description = "Drop 30 obol! Finder Keepers!"},
            new Effect("Drop Nectar", "Cornucopia.DropNectar")
                {Price = 10, Description = "Drop some yummy nectar."},
            new Effect("Drop Pom Slice", "Cornucopia.DropPomShard")
                {Price = 10, Description = "Drop a pomegranate slice that levels up a random boon!"},
            new Effect("Styx Antidote", "Cornucopia.PoisonCure")
                {Price = 1, Description = "Cures Zagreus from Styx Poison."},
            new Effect("Drop Boon", "Cornucopia.DropBoon")
                {Price = 50, Description = "Airdrops a random god's boon."},
            new Effect("Drop Hammer", "Cornucopia.DropHammer")
                {Price = 50, Description = "Airdrops a Daedalus Hammer."},
            new Effect("Drop Centaur Heart", "Cornucopia.DropCentaurHeart")
                {Price = 25, Description = "Drops a Centaur Heart."},
            new Effect("Drop Pom of Power", "Cornucopia.DropPom")
                {Price = 25, Description = "Drops a Pom of Power."},

            // Legion pack
            new Effect("Spawn Numbskulls", "Legion.SpawnNumbskull")
                {Price = 20, Description = "Summon some armoured numbskulls for Zag to butt heads with."},
            new Effect("Spawn Flamewheels", "Legion.SpawnFlameWheel")
                {Price = 30, Description = "Spawn some mini chariots that explode when they touch Zag! (Same tho)"},
            new Effect("Spawn Pests", "Legion.SpawnPest" )
                {Price = 20, Description = "Spawn some mine laying pests!"},
            new Effect("Spawn a Voidstone", "Legion.SpawnVoidstone" )
                {Price = 30, Description = "Spawn a Voidstone that protects another enemy."},
            new Effect("Spawn a Soul Catcher", "Legion.SpawnButterflyBall")
                {Price = 40, Description = "Spawn a soul catcher, also known as that-pink-ball-which-spits-butterflies."},
            new Effect("Spawn a Snakestone", "Legion.SpawnSnakestone" )
                {Price = 40, Description = "Spawn a laser spewing Snakestone!"},
            new Effect("Spawn a Satyr", "Legion.SpawnSatyr" )
                {Price = 50, Description = "Not these guys."},

            // Legion pack (bosses)
            new Effect("Spawn Meg", "Legion.SpawnMeg" )
                {Price = 700, Description = "Hope you picked a safeword."},
            new Effect("Spawn Alecto", "Legion.SpawnAlecto" )
                {Price = 700, Description = "A safeword might not cut it here."},
            new Effect("Spawn Tisiphone", "Legion.SpawnTis" )
                {Price = 700, Description = "Safeword is 'Murder'"},
            new Effect("Spawn Asterius", "Legion.SpawnAsterius" )
                {Price = 850, Description = "Spawn Asterius, the hero of Elysium."},
            new Effect("Spawn Theseus", "Legion.SpawnTheseus" )
                {Price = 800, Description = "Spawn Asterius's Sidekick."},


            // Auction pack 
            new Effect("Sword Swap", "Auction.SwordSwap" )
                {Price = 700, Description = "Swap Zagreus's weapon to the sword."},
            new Effect("Spear Swap", "Auction.SpearSwap" )
                {Price = 700, Description = "Swap Zagreus's weapon to the spear."},
            new Effect("Shield Swap", "Auction.ShieldSwap" )
                {Price = 700, Description = "Swap Zagreus's weapon to the shield."},
            new Effect("Bow Swap", "Auction.BowSwap" )
                {Price = 700, Description = "Swap Zagreus's weapon to the bow."},
            new Effect("Fist Swap", "Auction.FistSwap" )
                {Price = 700, Description = "Swap Zagreus's weapon to the fists."},
            new Effect("Gun Swap", "Auction.GunSwap" )
                {Price = 700, Description = "Swap Zagreus's weapon to the gun."},


        };
    }
}

