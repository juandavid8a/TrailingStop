using System;
using System.Linq;
using cAlgo.API;
using cAlgo.API.Indicators;
using cAlgo.API.Internals;
using cAlgo.Indicators;

namespace cAlgo
{
    [Robot(TimeZone = TimeZones.UTC, AccessRights = AccessRights.None)]
    public class PositionAdministration : Robot
    {
        [Parameter("Trailing", Group = "trailing", DefaultValue = 2, MinValue = 0)]
        public int GlobalStop { get; set; }
        [Parameter("Spread BUY", Group = "trailing", DefaultValue = 6, MinValue = 0)]
        public int GlobalSpreadBuy { get; set; }
        [Parameter("Spread SELL", Group = "trailing", DefaultValue = 6, MinValue = 0)]
        public int GlobalSpreadSell { get; set; }

        private double GlobalPositionOpen = 0;
        private double GlobalPositionTrailing = 0;
        private double GlobalPositionStop = 0;
        private double GlobalPrice = 0;

        protected override void OnStart()
        {
            Print("Have Fun !!");
        }

        protected override void OnTick()
        {
            GlobalPrice = Symbol.Bid;
            var pos = Positions.FirstOrDefault();
            if (pos != null)
            {
                GlobalPositionOpen = pos.EntryPrice;
                bool isBuy = pos.TradeType == TradeType.Buy;
                GlobalPositionTrailing = CalculatePositionTrailing(isBuy);
                PrintPositionInfo(pos);

                if (isBuy ? GlobalPrice > GlobalPositionTrailing : GlobalPrice < GlobalPositionTrailing)
                {
                    GlobalPositionTrailing = GlobalPrice;
                    UpdateGlobalPositionStop(isBuy);
                }

                if (GlobalPositionStop > 0 && (isBuy ? GlobalPrice <= GlobalPositionStop : GlobalPrice >= GlobalPositionStop))
                {
                    ClosePosition(pos);
                    Reset();
                }
            }
        }

        private double CalculatePositionTrailing(bool isBuy)
        {
            return Math.Round(GlobalPositionOpen + (isBuy ? GlobalSpreadBuy : -GlobalSpreadSell) * Symbol.TickSize, 5);
        }

        private void UpdateGlobalPositionStop(bool isBuy)
        {
            double newStop = Math.Round(GlobalPositionTrailing + (isBuy ? -GlobalStop : GlobalStop) * Symbol.TickSize, 5);

            if ((isBuy ? newStop > GlobalPositionStop : newStop < GlobalPositionStop) || GlobalPositionStop == 0)
            {
                GlobalPositionStop = newStop;
                Print("New StopLoss: " + GlobalPositionStop);
            }
        }

        private void PrintPositionInfo(Position pos)
        {
            Print(".............");
            Print($"Profit: {pos.NetProfit}");
            Print($"Price: {GlobalPrice}");
            Print($"StopLoss: {GlobalPositionStop}");
            Print($"Trailing: {GlobalPositionTrailing}");
            Print($"Open: {GlobalPositionOpen}");
            Print(".............");
        }

        protected void Reset()
        {
            GlobalPositionOpen = 0;
            GlobalPositionTrailing = 0;
            GlobalPositionStop = 0;
            GlobalPrice = 0;
        }

        protected override void OnStop()
        {
            Print("cBot was stopped.");
        }
    }
}
