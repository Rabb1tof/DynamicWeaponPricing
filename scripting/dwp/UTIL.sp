stock bool IsValidClient(int iClient) { return (iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient) && !IsFakeClient(iClient)); }

stock void ChangePrice(const char[] weapon, int price)
{
    for(int i = 0; i < MAX_WEAPONS; ++i)
    {
        if(!strcmp(g_wWeapons[i].name, weapon))
        {
            g_wWeapons[i].price = IncreasePrice(price);
        }
        else
        {
            g_wWeapons[i].price = ReductionPrice(price);
        }
    }
}

stock int IncreasePrice(int oldPrice)
{
    return (100 + g_iPercentOfPriceIncrease) / 100 * oldPrice;
}

stock int ReductionPrice(int oldPrice)
{
    return (100 - g_iPercentOfPriceReduction) / 100 * oldPrice;
}