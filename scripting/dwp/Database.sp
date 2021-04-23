#define sql_initMainTable "CREATE TABLE `price_list` ( \
	`weapon` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_unicode_ci', \
	`price` INT(11) NULL DEFAULT NULL \
) \
COLLATE='utf8mb4_unicode_ci' \
ENGINE=InnoDB;"

#define sql_getWeapons "SELECT `weapon`, `price` FROM `price_list`;"

void InitDb()
{
    char error[256];

    g_hDb = SQL_Connect("dwp", false, error, sizeof(error));

    if(!g_hDb || error[0])
    {
        SetFailState("[DWP] Could not connect to the database (%s)", error);
    }

    Handle hDatabaseDriver = view_as<Handle>(g_hDb.Driver);
    if (hDatabaseDriver == SQL_GetDriver("sqlite"))
    {
        SetFailState("[DWP] Plugin can't support SQLite driver. Use MySQL.");
    } 
    else if (hDatabaseDriver == SQL_GetDriver("mysql")) 
    {
            g_hDb.SetCharset("utf8");
            
            char query[256];

            g_hDb.Format(query, sizeof(query), sql_initMainTable);
            g_hDb.Query(SQL_InitMainTable, query, _, DBPrio_High);
    } 
    else
        SetFailState("[DWP] InitializeDatabase - driver of database is invalid");
}

void SQL_InitMainTable(Database db, DBResultSet results, const char[] error, any data)
{
    if(!results || error[0])
    {
        SetFailState("[DWP] Error while creating table (%s)", error);
    }

    char query[256];
    g_hDb.Format(query, sizeof(query), sql_getWeapons);
    g_hDb.Query(SQL_GetWeapons, query);
}

void SQL_GetWeapons(Database db, DBResultSet results, const char[] error, any data)
{
    if(!results || error[0])
    {
        SetFailState("[DWP] Error while get weapons (%s)", error);
    }

    for(int i = 0; i < MAX_WEAPONS; ++i)
        g_wWeapons[i].Clear();

    char weapon[64];
    int count = 0;
    while(results.FetchRow())
    {
        results.FetchString(0, weapon, sizeof(weapon));
        g_wWeapons[count].name = weapon;
        g_wWeapons[count].price = results.FetchInt(1);
    }
}

void AddWeaponToDb(const char[] weapon, int price)
{
    
}