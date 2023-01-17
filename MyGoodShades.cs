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

        public override Game Game { get; } = new(5, "Hades", "Hades", "PC", ConnectorType.SimpleTCPConnector);

        public override List<Effect> Effects { get; } = new()
        {
            new Effect("Hello World", "MyGoodShades.HelloWorld"){Price = 1, 
                Description = "Don't be rude, Zagreus. Say hello!"},
            new Effect("No Escape", "MyGoodShades.KillHero"){ Duration = 5, Price = 500, 
                Description = "Send Zag back to the house of Hades, forcing him to start the run over."},
            new Effect("Build Call", "MyGoodShades.BuildSuperMeter"),
            new Effect("Add Death Defiance", "MyGoodShades.DDAdd"),
            new Effect("Remove Death Defiance", "MyGoodShades.DDRemove"),
            new Effect("Flashbang", "MyGoodShades.Flashbang"),
            new Effect("Screen Nuke", "MyGoodShades.ScreenNuke"),
            
           
            // Assist pack
            new Effect("Dusa Assist", "Assists.DusaAssist"),
            new Effect("Skelly Assist", "Assists.SkellyAssist"),
            
            // Cornucopia pack
            new Effect("Healing Aid", "Cornucopia.DropHeal"),
            new Effect("Money Aid", "Cornucopia.DropMoney"),
            new Effect("Nectar Aid", "Cornucopia.DropNectar"),
            new Effect("Poison Cure", "Cornucopia.PoisonCure"),

            // Legion pack
            new Effect("Numbskulls", "Legion.SpawnNumbskull"),
            new Effect("Flamewheels", "Legion.SpawnFlameWheel"),
            new Effect("Pests", "Legion.SpawnPest" ),
            new Effect("Voidstone", "Legion.SpawnVoidstone" ),
            new Effect("Soul Catcher", "Legion.SpawnButterflyBall"),
            new Effect("Snakestone", "Legion.SpawnSnakestone" ),
            new Effect("Satyr", "Legion.SpawnSatyr" ),

            // Legion pack (bosses)
            new Effect("Meg", "Legion.SpawnMeg" ),
            new Effect("Alecto", "Legion.SpawnAlecto" ),
            new Effect("Tisiphone", "Legion.SpawnTis" ),
            new Effect("Theseus", "Legion.SpawnTheseus" ),
            new Effect("Asterius", "Legion.SpawnAsterius" ),

        };
    }
}
