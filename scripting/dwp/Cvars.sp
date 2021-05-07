ConVar      g_cPercentOfPriceReduction, g_cPercentOfPriceIncrease;
int         g_iPercentOfPriceReduction, g_iPercentOfPriceIncrease;

void InitConVars()
{
    /**
    *@  Reduction of price
    **/
    g_cPercentOfPriceReduction = CreateConVar("sm_dwp_percent_of_price_reduction", "5", "How much will the price decrease from the stock price?", _, true, 1.0);
    g_cPercentOfPriceReduction.AddChangeHook(OnPriceReduction);
    g_iPercentOfPriceReduction = g_cPercentOfPriceReduction.IntValue;

    /**
    *@  Increase of price
    **/
    g_cPercentOfPriceIncrease = CreateConVar("sm_dwp_percent_of_price_increase", "10", "How much will the price rise compared to the price of the stock?", _, true, 1.0);
    g_cPercentOfPriceIncrease.AddChangeHook(OnPriceIncrease);
    g_iPercentOfPriceIncrease = g_cPercentOfPriceIncrease.IntValue;

    AutoExecConfig(true, "core", "dwp");
}

public void OnConfigsExecuted()
{
    g_iPercentOfPriceReduction = g_cPercentOfPriceReduction.IntValue;
    g_iPercentOfPriceIncrease = g_cPercentOfPriceIncrease.IntValue;
}

public void OnPriceReduction(ConVar convar, const char[] oldValue, const char[] newValue)   { g_iPercentOfPriceReduction = convar.IntValue; }
public void OnPriceIncrease(ConVar convar, const char[] oldValue, const char[] newValue)    { g_iPercentOfPriceIncrease = convar.IntValue; }