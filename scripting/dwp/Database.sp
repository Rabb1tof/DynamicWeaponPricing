#define sql_initMainTable "CREATE TABLE IF NOT EXISTS `price_list` ( \
	`weapon` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_unicode_ci', \
	`price` INT(11) NULL DEFAULT NULL, \
	`default_price` INT(11) NULL DEFAULT NULL, \
	UNIQUE INDEX `weapon` (`weapon`) USING BTREE \
) \
COLLATE='utf8mb4_unicode_ci' \
ENGINE=InnoDB;"
#define sql_getWeapons "SELECT `weapon`, `price` FROM `price_list`;"
#define sql_addWeapon "INSERT INTO `price_list` (`weapon`, `price`, `default_price`) VALUES ('%s', %d, %d) \
ON DUPLICATE KEY UPDATE `price` = %d;"
#define sql_changePrice "UPDATE `price_list` SET `price` = %d WHERE `weapon` = '%s';"
#define sql_resetAllPrice "UPDATE `price_list` SET `price` = `default_price`;"
#define sql_resetPrice "UPDATE `price_list` SET `price` = `default_price` WHERE `weapon` = '%s';"

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
            #if DEBUG
            LogError(query);
            #endif
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

    GetWeapons();
}

void GetWeapons()
{
    char query[256];
    g_hDb.Format(query, sizeof(query), sql_getWeapons);
    #if DEBUG
    LogError(query);
    #endif
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
        count++;
    }
}

// ? add weapon to database (tables default_price and price are equal)
void AddWeaponToDb(const char[] weapon, int price)
{
    char query[256];
    g_hDb.Format(query, sizeof(query), sql_addWeapon, weapon, price, price, price);
    #if DEBUG
    LogError(query);
    #endif
    g_hDb.Query(SQL_AddWeapon, query);
}

void SQL_AddWeapon(Database db, DBResultSet results, const char[] error, any data)
{
    if(!results || error[0])
    {
        SetFailState("[DWP] Error while add weapon (%s)", error);
    }

    GetWeapons();
}

void ChangePriceDB(int price, char[] weapon)
{
    char query[256];

    g_hDb.Format(query, sizeof(query), sql_changePrice, price, weapon);
    #if DEBUG
    LogError(query);
    #endif
    g_hDb.Query(SQL_ChangePrice, query);
}

void SQL_ChangePrice(Database db, DBResultSet results, const char[] error, any data)
{
    if(!results || error[0])
    {
        SetFailState("[DWP] Error while change price of weapon (%s)", error);
    }
}

void ResetAllPrice()
{
    char query[256];

    g_hDb.Format(query, sizeof(query), sql_resetAllPrice);
    g_hDb.Query(SQL_ResetAllPrice, query);
}

void SQL_ResetAllPrice(Database db, DBResultSet results, const char[] error, any data)
{
    if(!results || error[0])
    {
        SetFailState("[DWP] Error while reset price of weapons (%s)", error);
    }
}

void ResetPriceOfWeapon(char[] weapon)
{
    char query[256];

    g_hDb.Format(query, sizeof(query), sql_resetPrice, weapon);
    g_hDb.Query(SQL_ResetPrice, query);
}

void SQL_ResetPrice(Database db, DBResultSet results, const char[] error, any data)
{
    if(!results || error[0])
    {
        SetFailState("[DWP] Error while reset price of weapon (%s)", error);
    }
}