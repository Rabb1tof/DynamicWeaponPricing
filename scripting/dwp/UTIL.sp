stock bool IsValidClient(int iClient) { return (iClient > 0 && iClient <= MaxClients && IsClientInGame(iClient) && !IsFakeClient(iClient)); }

stock void IncreasePrice(const char[] weapon, int price)
{
    
}