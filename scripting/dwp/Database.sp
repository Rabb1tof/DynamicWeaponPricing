void InitDb()
{
    char szError[256];

    g_hDb = SQL_Connect("dwp", false, szError, sizeof(szError));

    if(!g_hDb || szError[0])
    {
        SetFailState("[DWP] Could not connect to the database (%s)", szError);
    }

    Handle hDatabaseDriver = view_as<Handle>(g_hDb.Driver);
    if (hDatabaseDriver == SQL_GetDriver("sqlite"))
    {
        SetFailState("[DWP] Plugin can't support SQLite driver. Use MySQL.");
    } 
    else if (hDatabaseDriver == SQL_GetDriver("mysql")) 
    {
            g_hDb.SetCharset("utf8");
            




    } 
    else
        SetFailState("[TF-Rest] InitializeDatabase - driver of database is invalid");
}