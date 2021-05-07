stock bool IsValidClient(int iClient) { return (iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient) && !IsFakeClient(iClient)); }

stock void ChangePrice(const char[] weapon)
{
    for(int i = 0; i < MAX_WEAPONS; ++i)
    {
        if(g_wWeapons[i].name[0])
        {
            #if DEBUG
            PrintToServer("Old price: %d", g_wWeapons[i].price);
            #endif
            if(!strcmp(g_wWeapons[i].name, weapon))
            {
                g_wWeapons[i].price = IncreasePrice(g_wWeapons[i].price);
            }
            else
            {
                g_wWeapons[i].price = ReductionPrice(g_wWeapons[i].price);
            }
            #if DEBUG
            PrintToServer("New price: %d", g_wWeapons[i].price);
            #endif
            ChangePriceDB(g_wWeapons[i].price, g_wWeapons[i].name);
        }
    }
}

stock int IncreasePrice(int oldPrice)
{
    return ((100 + g_iPercentOfPriceIncrease) * oldPrice / 100);
}

stock int ReductionPrice(int oldPrice)
{
    return ((100 - g_iPercentOfPriceReduction) * oldPrice / 100);
}

stock void String_ToUpper(const char[] input, char[] output, int size)
{
	size--;

	int x = 0;
	while (input[x] != '\0' && x < size) {

		output[x] = CharToUpper(input[x]);

		x++;
	}

	output[x] = '\0';
}