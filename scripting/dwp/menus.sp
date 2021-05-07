void ShowMainMenu(int client)
{
    char buffer[128];
    Menu menu = new Menu(Handler_MainMenu);
    menu.SetTitle("%T:\n\n%T", "MainTitle", client, "ChooseWeaponToReset", client);

    Format(buffer, sizeof(buffer), "%T", "ResetAll", client);
    menu.AddItem("reset", buffer);

    for(int i = 0; i < MAX_WEAPONS; ++i)
    {
        String_ToUpper(g_wWeapons[i].name, buffer, sizeof(buffer));
        Format(buffer, sizeof(buffer), "[%d] %s", g_wWeapons[i].price, buffer);
        menu.AddItem(g_wWeapons[i].name, buffer);
    }
}

int Handler_MainMenu(Menu menu, MenuAction action, int client, int item)
{
    switch(action)
    {
        case MenuAction_End:    menu.Close();
        case MenuAction_Select:
        {
            char info[64];
            menu.GetItem(item, info, sizeof(info));
            if(!strcmp(info, "reset"))
            {
                ResetAllPrice();
            }
            else
            {
                ResetPriceOfWeapon(info);
            }

            ShowMainMenu(client);
        }
    }
}