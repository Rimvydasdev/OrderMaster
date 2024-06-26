//+------------------------------------------------------------------+ 
//|                                               ControlsButton.mq5 | 
//|                         Copyright 2000-2024, MetaQuotes Ltd.     |
//|                                             https://www.mql5.com | 
//+------------------------------------------------------------------+ 
#property copyright "Copyright 2017, MetaQuotes Software Corp." 
#property link      "https://www.mql5.com" 
#property version   "1.02"
#property description "Control your orders like a PRO"
#property description "This script only works with one currency pair" 
#property script_show_inputs

#include <Controls\Dialog.mqh> 
#include <Controls\Button.mqh>
#include <Controls\Edit.mqh>
#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>



double takeSlValue;
double takeTPValue;
#define async sTrade.SetAsyncMode(true);
input double InpProfit = 1; // Minimum profit
//+------------------------------------------------------------------+ 
//| defines                                                          | 
//+------------------------------------------------------------------+ 
//--- indents and gaps 
#define INDENT_LEFT                         (11)      // indent from left (with allowance for border width) 
#define INDENT_TOP                          (11)      // indent from top (with allowance for border width) 
#define INDENT_RIGHT                        (11)      // indent from right (with allowance for border width) 
#define INDENT_BOTTOM                       (11)      // indent from bottom (with allowance for border width) 
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate 
#define CONTROLS_GAP_Y                      (5)       // gap by Y coordinate 
//--- for buttons 
#define BUTTON_WIDTH                        (100)     // size by X coordinate 
#define BUTTON_HEIGHT                       (20)      // size by Y coordinate 
//--- for the indication area 
#define EDIT_HEIGHT                         (20)      // size by Y coordinate 
//--- for group controls 
#define GROUP_WIDTH                         (150)     // size by X coordinate 
#define LIST_HEIGHT                         (179)     // size by Y coordinate 
#define RADIO_HEIGHT                        (56)      // size by Y coordinate 
#define CHECK_HEIGHT                        (93)      // size by Y coordinate 
//+------------------------------------------------------------------+ 
//| Class CControlsDialog                                            | 
//| Usage: main dialog of the Controls application                   | 
//+------------------------------------------------------------------+ 
//---
CPositionInfo m_position;
CTrade sTrade;

class CControlsDialog : public CAppDialog 
  { 
private:
   CButton           m_closeSell;                       // the button object  
   CButton           m_closeBuy;                       // the button object  
   CButton           m_closeLosing;                       // the button object 
   CButton           m_closeProfit;                       // the button object 
   CButton           m_closeAll;                       // the fixed button object 
   CEdit             m_AddSLInput;
   CButton           m_AddSL; 
   CButton           m_AddTP; 
   CEdit             m_AddTPInput;
public: 
                     CControlsDialog(void); 
                    ~CControlsDialog(void); 
   //--- create 
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2); 
   //--- chart event handler 
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam); 

protected: 
   //--- create dependent controls 
   bool              CreateCloseSell(void); 
   bool              CreateCloseBuy(void); 
   bool              CreateCloseLosing(void); 
   bool              CreateCloseProfit(void); 
   bool              CreateCloseAll(void); 
   bool              CreateAddSLInput(void); 
   bool              CreateAddSL(void); 
   bool              CreateAddTP(void);
   bool              CreateAddTPInput(void);    
   //--- handlers of the dependent controls events  
   void              OnClickCloseSell(void);   
   void              OnClickCloseBuy(void); 
   void              OnClickCloseLosing(void); 
   void              OnClickCloseProfit(void); 
   void              OnClickCloseAll(void); 
   void              OnChangeAddSLInput(void); 
   void              OnClickAddSL(void); 
   void              OnClickAddTP(void); 
   void              OnChangeAddTPInput(void); 
  };
//+------------------------------------------------------------------+ 
//| Event Handling                                                   | 
//+------------------------------------------------------------------+ 
EVENT_MAP_BEGIN(CControlsDialog) 
ON_EVENT(ON_CLICK,m_closeSell,OnClickCloseSell) 
ON_EVENT(ON_CLICK,m_closeBuy,OnClickCloseBuy) 
ON_EVENT(ON_CLICK,m_closeLosing,OnClickCloseLosing) 
ON_EVENT(ON_CLICK,m_closeProfit,OnClickCloseProfit) 
ON_EVENT(ON_CLICK,m_closeAll,OnClickCloseAll) 
ON_EVENT(ON_CHANGE, m_AddSLInput, OnChangeAddSLInput)
ON_EVENT(ON_CLICK, m_AddSL, OnClickAddSL)
ON_EVENT(ON_CLICK, m_AddTP, OnClickAddTP)
ON_EVENT(ON_CHANGE, m_AddTPInput, OnChangeAddTPInput)
EVENT_MAP_END(CAppDialog) 
//+------------------------------------------------------------------+ 
//| Constructor                                                      | 
//+------------------------------------------------------------------+ 
CControlsDialog::CControlsDialog(void) 
  { 
  } 
//+------------------------------------------------------------------+ 
//| Destructor                                                       | 
//+------------------------------------------------------------------+ 
CControlsDialog::~CControlsDialog(void) 
  { 
  } 
  
//+------------------------------------------------------------------+ 
//| Create                                                           | 
//+------------------------------------------------------------------+ 
bool CControlsDialog::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2) 
  {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2)) 
      return(false); 
//--- create dependent controls
   if(!CreateCloseSell()) 
      return(false); 
   if(!CreateCloseBuy()) 
      return(false);  
   if(!CreateCloseLosing()) 
      return(false); 
   if(!CreateCloseProfit()) 
      return(false); 
   if(!CreateCloseAll()) 
      return(false);  
   if(!CreateAddSLInput()) 
      return(false);  
   if(!CreateAddSL()) 
      return(false);  
   if(!CreateAddTP()) 
      return(false);  
   if(!CreateAddTPInput()) 
      return(false); 
//--- succeed 
   return(true); 
  } 
  
  //+------------------------------------------------------------------+ 
//| Create the "Add SL input" button                                      | 
//+------------------------------------------------------------------+ 
bool CControlsDialog::CreateAddSLInput(void) 
  { 
//--- coordinates 
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP; 
   int x2=x1+BUTTON_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_AddSLInput.Create(m_chart_id,m_name+"AddSLInput",m_subwin,x1,y1,x2,y2)) 
      return(false);
//--- allow editing the content 
   if(!m_AddSLInput.ReadOnly(false)) 
      return(false); 
   if(!Add(m_AddSLInput)) 
      return(false); 
//--- succeed 
   return(true); 
  } 
  
  //+------------------------------------------------------------------+ 
//| Create the "Add SL" button                                      | 
//+------------------------------------------------------------------+ 
bool CControlsDialog::CreateAddSL(void) 
  { 
//--- coordinates 
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y); 
   int x2=x1+BUTTON_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_AddSL.Create(m_chart_id,m_name+"AddSL",m_subwin,x1,y1,x2,y2)) 
      return(false);
      m_AddSL.Color(C'255, 255, 255');
      m_AddSL.ColorBackground(C'220, 0, 0');
   if(!m_AddSL.Text("AddSL")) 
      return(false); 
   if(!Add(m_AddSL)) 
      return(false); 
//--- succeed 
   return(true); 
  } 

  //+------------------------------------------------------------------+ 
//| Create the "Add TP" button                                      | 
//+------------------------------------------------------------------+ 
bool CControlsDialog::CreateAddTP(void) 
  { 
//--- coordinates 
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y); 
   int x2=x1+BUTTON_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_AddTP.Create(m_chart_id,m_name+"AddTP",m_subwin,x1,y1,x2,y2)) 
      return(false);
      m_AddTP.Color(C'255, 255, 255');
      m_AddTP.ColorBackground(C'0, 118, 255'); 
   if(!m_AddTP.Text("AddTP")) 
      return(false); 
   if(!Add(m_AddTP)) 
      return(false); 
//--- succeed 
   return(true); 
  } 
  
  //+------------------------------------------------------------------+ 
//| Create the "Add TP input" button                                      | 
//+------------------------------------------------------------------+ 
bool CControlsDialog::CreateAddTPInput(void)
  { 
//--- coordinates 
   int x1=INDENT_LEFT;
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y); 
   int x2=x1+BUTTON_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_AddTPInput.Create(m_chart_id,m_name+"AddTPInput",m_subwin,x1,y1,x2,y2)) 
      return(false);
//--- allow editing the content 
   if(!m_AddTPInput.ReadOnly(false)) 
      return(false); 
   if(!Add(m_AddTPInput)) 
      return(false); 
//--- succeed 
   return(true); 
  } 

  
//+------------------------------------------------------------------+ 
//| Create the "CloseLosing" button                                      | 
//+------------------------------------------------------------------+ 
bool CControlsDialog::CreateCloseLosing(void) 
  { 
//--- coordinates 
   int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP+(EDIT_HEIGHT+CONTROLS_GAP_Y); 
   int x2=x1+BUTTON_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_closeLosing.Create(m_chart_id,m_name+"CloseLosing",m_subwin,x1,y1,x2,y2)) 
      return(false);
      m_closeLosing.Color(C'255, 255, 255');
      m_closeLosing.ColorBackground(C'220, 0, 0');
   if(!m_closeLosing.Text("Close Lossing")) 
      return(false); 
   if(!Add(m_closeLosing)) 
      return(false); 
//--- succeed 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Create the "CloseProfit" button                                      | 
//+------------------------------------------------------------------+ 
bool CControlsDialog::CreateCloseProfit(void) 
  { 
//--- coordinates 
   int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X); 
   int y1=INDENT_TOP+2*(EDIT_HEIGHT+CONTROLS_GAP_Y); 
   int x2=x1+BUTTON_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_closeProfit.Create(m_chart_id,m_name+"CloseProfit",m_subwin,x1,y1,x2,y2)) 
      return(false);
      m_closeProfit.Color(C'255, 255, 255');
      m_closeProfit.ColorBackground(C'0, 118, 255');
   if(!m_closeProfit.Text("Close Profit")) 
      return(false); 
   if(!Add(m_closeProfit)) 
      return(false); 
//--- succeed 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Create the "CloseAll" fixed button                                | 
//+------------------------------------------------------------------+ 
bool CControlsDialog::CreateCloseAll(void) 
  { 
//--- coordinates 
   int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X); 
   int y1=INDENT_TOP+3*(EDIT_HEIGHT+CONTROLS_GAP_Y); 
   int x2=x1+BUTTON_WIDTH; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_closeAll.Create(m_chart_id,m_name+"CloseAll",m_subwin,x1,y1,x2,y2)) 
      return(false); 
   if(!m_closeAll.Text("Close All")) 
      return(false); 
   if(!Add(m_closeAll)) 
      return(false); 
   m_closeAll.Locking(true); 
//--- succeed 
   return(true); 
  } 

//+------------------------------------------------------------------+ 
//| Create the "CloseSell" fixed button                                | 
//+------------------------------------------------------------------+ 
  bool CControlsDialog::CreateCloseSell(void) 
  { 
//--- coordinates 
   int x1=INDENT_LEFT+(BUTTON_WIDTH+CONTROLS_GAP_X);
   int y1=INDENT_TOP; 
   int x2=x1+BUTTON_WIDTH/2; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_closeSell.Create(m_chart_id,m_name+"CloseSell",m_subwin,x1,y1,x2,y2)) 
      return(false);
      m_closeSell.Color(C'255, 255, 255');
      m_closeSell.ColorBackground(C'220, 0, 0');
   if(!m_closeSell.Text("X Sell")) 
      return(false); 
   if(!Add(m_closeSell)) 
      return(false); 
//--- succeed 
   return(true); 
  } 
 
//+------------------------------------------------------------------+ 
//| Create the "CloseBuy" fixed button                                | 
//+------------------------------------------------------------------+ 
  bool CControlsDialog::CreateCloseBuy(void) 
  { 
//--- coordinates 
   int x1 = (int)(INDENT_LEFT + 1.5 * (BUTTON_WIDTH + CONTROLS_GAP_X));
   int y1=INDENT_TOP; 
   int x2=x1+BUTTON_WIDTH/2-2; 
   int y2=y1+BUTTON_HEIGHT; 
//--- create 
   if(!m_closeBuy.Create(m_chart_id,m_name+"CloseBuy",m_subwin,x1,y1,x2,y2)) 
      return(false);
      m_closeBuy.Color(C'255, 255, 255');
      m_closeBuy.ColorBackground(C'0, 118, 255');
   if(!m_closeBuy.Text("X Buy")) 
      return(false); 
   if(!Add(m_closeBuy)) 
      return(false); 
//--- succeed 
   return(true); 
  } 
//+------------------------------------------------------------------+ 
//| Event handler                                                    | 
//+------------------------------------------------------------------+ 
void CControlsDialog::OnClickCloseLosing(void) 
  { 
  ulong st = GetMicrosecondCount();
  int totalPositions = PositionsTotal();

  async
  for (int cnt = totalPositions - 1; cnt >= 0 && !IsStopped(); cnt--)
  {
    if (PositionSelectByTicket(PositionGetTicket(cnt)) && PositionGetString(POSITION_SYMBOL) == _Symbol)
    {
      if (PositionGetDouble(POSITION_PROFIT) < 0) // losing money
      {
        sTrade.PositionClose(PositionGetInteger(POSITION_TICKET), 100);
        uint code = sTrade.ResultRetcode();
        //Print(IntegerToString(code));
      }
    }
  }
  } 
//+------------------------------------------------------------------+ 
//| Event handler                                                    | 
//+------------------------------------------------------------------+ 
void CControlsDialog::OnClickCloseProfit(void){ 

  async 
  
   for (int i = PositionsTotal() - 1; i >= 0; i--) 
   if (m_position.SelectByIndex(i) && PositionGetString(POSITION_SYMBOL) == _Symbol){
    double profit = m_position.Commission() + m_position.Swap() + m_position.Profit();
    if (profit > InpProfit) // profit money
      sTrade.PositionClose(m_position.Ticket());
  }
  } 
//+------------------------------------------------------------------+ 
//| Event handler                                                    | 
//+------------------------------------------------------------------+ 
void CControlsDialog::OnClickCloseAll(void) 
  { 
  ulong st = GetMicrosecondCount();
  async
  
      for (int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
  {
    if (PositionGetTicket(cnt) && PositionGetString(POSITION_SYMBOL) == _Symbol)
    {
      sTrade.PositionClose(PositionGetInteger(POSITION_TICKET), 100);
      uint code = sTrade.ResultRetcode();
    }
  }
  } 
  
void CControlsDialog::OnClickCloseSell(void) 
  { 
  ulong st = GetMicrosecondCount();
  async

      for (int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
  {
    if (PositionGetTicket(cnt) && PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
    {
      sTrade.PositionClose(PositionGetInteger(POSITION_TICKET), 100);
      uint code = sTrade.ResultRetcode();
    }
  }
  }   
 
void CControlsDialog::OnClickCloseBuy(void) 
  { 
  ulong st = GetMicrosecondCount();
  async

      for (int cnt = PositionsTotal() - 1; cnt >= 0 && !IsStopped(); cnt--)
  {
    if (PositionGetTicket(cnt) && PositionGetString(POSITION_SYMBOL) == _Symbol && PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
    {
      sTrade.PositionClose(PositionGetInteger(POSITION_TICKET), 100);
      uint code = sTrade.ResultRetcode();
    }
  }
  }  


//+------------------------------------------------------------------+ 
//| Event handler                                                    | 
//+------------------------------------------------------------------+ 
void CControlsDialog::OnChangeAddSLInput(void)
  { 

  } 
  
 
  
//+------------------------------------------------------------------+ 
//| Event handler                                                    | 
//+------------------------------------------------------------------+ 
void CControlsDialog::OnClickAddSL(void){ 
         string takeSlString = m_AddSLInput.Text();
      takeSlValue = StringToDouble(takeSlString);
  async
    for(int i = PositionsTotal() -1; i >= 0; i--) {
        ulong posTicket = PositionGetTicket(i);
        if(PositionSelectByTicket(posTicket) && PositionGetString(POSITION_SYMBOL) == _Symbol) {
            if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) {
                sTrade.PositionModify(posTicket,takeSlValue,PositionGetDouble(POSITION_TP));
                Print(" > Pos BUY #", posTicket, " was modified...", " price open ", PositionGetDouble(POSITION_PRICE_OPEN), " symbol ", _Symbol, " added SL ", takeSlValue, " TP ", PositionGetDouble(POSITION_TP));
            } else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) {
                sTrade.PositionModify(posTicket,takeSlValue,PositionGetDouble(POSITION_TP));
                 Print(" > Pos SELL #", posTicket, " was modified...", " price open ", PositionGetDouble(POSITION_PRICE_OPEN), " symbol ", _Symbol, " added SL ", takeSlValue, " TP ", PositionGetDouble(POSITION_TP));
            } 
        }
    }
  } 
  
 
  
//+------------------------------------------------------------------+ 
//| Event handler                                                    | 
//+------------------------------------------------------------------+ 
void CControlsDialog::OnClickAddTP(void)
  { 
      string takeTPString = m_AddTPInput.Text();
      takeTPValue = StringToDouble(takeTPString);


async for(int i = PositionsTotal() - 1; i >= 0; i--)
        {
            ulong posTicket = PositionGetTicket(i);
            if(PositionSelectByTicket(posTicket) && PositionGetString(POSITION_SYMBOL) == _Symbol)
            {
                if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                {
                    sTrade.PositionModify(posTicket, PositionGetDouble(POSITION_SL), takeTPValue);
                    Print(" > Pos BUY #", posTicket, " was modified...", PositionGetDouble(POSITION_PRICE_OPEN), " symbol ", _Symbol, " added TP ", takeTPValue, " SL ", PositionGetDouble(POSITION_SL));
                }
                else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                {
                    sTrade.PositionModify(posTicket, PositionGetDouble(POSITION_SL), takeTPValue);
                    Print(" > Pos SELL #", posTicket, " was modified...", PositionGetDouble(POSITION_PRICE_OPEN), " symbol ", _Symbol, " added TP ", takeTPValue, " SL ", PositionGetDouble(POSITION_SL));
                }
            }
        }
  } 
  
 
  
//+------------------------------------------------------------------+ 
//| Event handler                                                    | 
//+------------------------------------------------------------------+ 
void CControlsDialog::OnChangeAddTPInput(void)
  {
    string inputValue = m_AddTPInput.Text();
    
  } 
  

//+--
//+------------------------------------------------------------------+ 
//| Global Variables                                                 | 
//+------------------------------------------------------------------+ 
CControlsDialog ExtDialog; 
//+------------------------------------------------------------------+ 
//| Expert initialization function                                   | 
//+------------------------------------------------------------------+ 
int OnInit() 
  { 
//--- create application dialog 
   if(!ExtDialog.Create(0,"Order Master Control",0,40,40,275,184)) 
      return(INIT_FAILED); 
//--- run application 
   ExtDialog.Run(); 
//--- succeed 
   return(INIT_SUCCEEDED); 
  } 
//+------------------------------------------------------------------+ 
//| Expert deinitialization function                                 | 
//+------------------------------------------------------------------+ 
void OnDeinit(const int reason) 
  { 
//--- clear comments 
   Comment(""); 
//--- destroy dialog 
   ExtDialog.Destroy(reason); 
  } 
//+------------------------------------------------------------------+ 
//| Expert chart event function                                      | 
//+------------------------------------------------------------------+ 
void OnChartEvent(const int id,         // event ID   
                  const long& lparam,   // event parameter of the long type 
                  const double& dparam, // event parameter of the double type 
                  const string& sparam) // event parameter of the string type 
  { 
   ExtDialog.ChartEvent(id,lparam,dparam,sparam); 
  }
  

