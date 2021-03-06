//+------------------------------------------------------------------+
//|                                                   BlackGhost.mq4 |
//|                                                Nematillo Ochilov |
//|                                                Nematillo Ochilov |
//+------------------------------------------------------------------+
#property copyright "Nematillo Ochilov MQL4"
#property link      "https://t.me/Nematillo_Ochilov"

extern double    Lots=0.01;
extern int       TakeProfit=500;
extern int       StopLoss=200;
extern int       MagicNumber=1;


//+------------------------------------------------------------------+
//| robotni ishga tushirish qismi                          |
//+------------------------------------------------------------------+
int init()
  {
//----
   Alert("Nematillo Ochilov tomonidan yaratilgan robot ishga tushmoqda");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//|robot faol holatda                                                |
//+------------------------------------------------------------------+
int start()
  {
  double TP=NormalizeDouble(TakeProfit,Digits);
// stop loss
  double SL=NormalizeDouble(StopLoss,Digits);

// Stop-lossni hisoblash
  double slb=NormalizeDouble(Ask-SL*Point,Digits);
  double sls=NormalizeDouble(Bid+SL*Point,Digits);
  double tpb=NormalizeDouble(Ask+TP*Point,Digits);
  double tps=NormalizeDouble(Bid-TP*Point,Digits);
  double tslb=NormalizeDouble(OrderStopLoss()+SL*Point,Digits);
  double tsls=NormalizeDouble(OrderStopLoss()-SL*Point,Digits);
  double WPR0=iWPR(NULL,0,150,0);
  double WPR1=iWPR(NULL,0,150,1);
//-------------------------------------------------------------------+
// savdo taktikasi
//-------------------------------------------------------------------+

  Comment("Ushbu robotni katta real balansda sinab ko'rmang");


  if(OrdersTotal()>0)
    {
     for(int i=0;i<OrdersTotal();i++)
      {
       if(OrderSelect(i,SELECT_BY_POS)==true)
         {
          if(OrderSymbol()==Symbol()&&OrderMagicNumber()==MagicNumber)
            {
             if(OrderType()==OP_BUY)
               {
                if(tslb<Ask)
                  {
                   if(!OrderModify(OrderTicket(),0,slb,OrderTakeProfit(),0,Aqua))
                     Print("OrderModify BUYda muammo: ",GetLastError());
                  }
               }
             if(OrderType()==OP_SELL)
               {
                if(tsls>Bid)
                  {
                   if(!OrderModify(OrderTicket(),0,sls,OrderTakeProfit(),0,Orange))
                     Print("OrderModify SELLda muammo: ",GetLastError());
                  }
               }
            }
         }
       }
    }


  else if(OrdersTotal()<1)
    {
     if((WPR0>-24)&&(WPR0<-23))
        {
         if(WPR0>WPR1)
           {
            if(!OrderSend(Symbol(),OP_BUY,Lots,Ask,3,slb,tpb,"NO savdo ",MagicNumber,0,Aqua))
              Print("OrderSend BUYda muammo: ",GetLastError());
           }
        }
     if((WPR0>-78)&&(WPR0<-77))
       {
        if(WPR0<WPR1)
          {
          if(!OrderSend(Symbol(),OP_SELL,Lots,Bid,3,sls,tps,"NO savdo ",MagicNumber,0,Red))
            Print("OrderSend SELLda muammo: ",GetLastError());
          }
        }
    }
  return(0);
  }


