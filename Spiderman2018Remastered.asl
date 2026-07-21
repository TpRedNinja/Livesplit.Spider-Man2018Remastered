/*
Shoutouts to JHobz for getting me all the addresses required for the EGS version, and big thanks to Canegar 
for being my guinea pig during the testing phase of the autosplitter :D
_____________________________________________________________________________________________________________

Scanning Best Practices:

For LOADING  : basically a bool - 0 in game and 1 on loading screen. 
When scanning, make sure to look for interior loads, checkpoint loads, fast travel loads. Should be around 7A/7B

For OBJECTIVE: 4byte in cheat engine, has to be uint to read correctly for some reason. Something something signed/unsigned blah blah. 
- You can scan for the following 4Byte values to find the objective address.
    - 0 on main menu
    - 648768089 on first cutscene
    - 3959482847 on swing tutorial
    - 1081701888 when the objective marker for "Clearing The Way" pops up
    - at this point, go back to main menu and search for 0 again. Only gonna be one address remaining

For TOTALXP: 4byte in cheat engine
- You can find the address by doing the following
    - first set cheatengine to search only for address in the spider-man.exe memory option and to make the writing box to be a grey square
    - search for unknown inital unless your on main menu then in that case 0
    - when you gain xp just re-search for increased value by whatever the amount you gained.
    - Rince repeat until u only have 2 addresses left that are green and both are fine but i prefer the 5D address
*/

state("Spider-Man", "Steam v1.812")
{
    bool loading     : 0x7AF85D0; 
    uint objective   : 0x701DE44; 
    int docSmack     : 0x5D1EF18; // really bad lol, find another one
    int acqBackpacks : 0x701B19C; // number of collected backpacks, havent bothered maintaining since no one really seems to run backpacks
}

state("Spider-Man", "EGS v1.812")
{
    bool loading    : 0x7B08B50; 
}

state("Spider-Man", "Steam v1.817")
{
    bool loading    : 0x7AF95D0; 
    uint objective  : 0x6F3E8D8; 
}

state("Spider-Man", "Steam v1.824")
{
    bool loading    : 0x7B1A510; 
    uint objective  : 0x6E90258; 
}

state("Spider-Man", "Steam v1.907")
{
    bool loading    : 0x7B1BA70; 
    uint objective  : 0x6E91288;  
}

state("Spider-Man", "Steam v1.919")
{
    bool loading    : 0x7B1F230;
    uint objective  : 0x6E94958;
}

state("Spider-Man", "Steam v1.1006")
{
    bool loading    : 0x7B63A10;
    uint objective  : 0x6ED6FA8;
}

state("Spider-Man", "Steam v1.1014")
{
    bool loading    : 0x7B69B30;
    uint objective  : 0x6EDB228;
}

state("Spider-Man", "Steam v2.217")
{
    bool loading    : 0x7B720D0;
    uint objective  : 0x7091304;
}

state("Spider-Man", "Steam v2.512")
{
    bool loading    : 0x7B74190;
    uint objective  : 0x6EE5658;
}

state("Spider-Man", "Steam v2.1012")
{
    bool loading    : 0x7B774D0;
    uint objective  : 0x6EEA798;
} 

state("Spider-Man", "Steam v3.618")
{
    bool loading    : 0x7B8995C;                    
    uint objective  : 0x6EFC918;
    int totalxp     : 0x5DB609C;
}

state("Spider-Man", "Steam v4.630")
{
    bool loading    : 0x7B84770;                    
    uint objective  : 0x6EF76E8;
    int totalxp     : 0x5DB105C;
}

startup
{
    vars.Objectives = new List<string>();
    vars.xpGains = new[] {250, 500, 1500, 2500, 2750, 3000, 3500, 4000, 4100, 5000, 5500};
    vars.xp = new  List<int>(vars.xpGains);
    vars.validXpGains = false;
    
    //Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    //vars.Helper.StartFileLogger("ObjectiveNumbers_Spiderman.log");
    vars.UniqueNumbers = new uint[]
    {
    1230831290, 911656026, 316826671, 404089728, 436592259, 1229283555, 13877668, 3594905414u, 
    3472337876u, 2697528745u, 2157044585u, 2036655449u, 2819266385u, 721949320, 3232178045u, 3974304245u, 
    508893510, 1898405954, 1344066272, 2346266155u, 316826671, 3332005264u, 1946090111, 3917257570u, 
    2641677965u, 139569742, 1654122386, 316826671, 647221538, 2963508943u, 1243652699, 316826671, 
    2080745987, 858338621, 95081780, 316826671, 637965749, 1425281762, 1930171772, 4146664000u
    };

    /*vars.CTNS = new uint[]{}; //work in progress
    vars.TheHeist = new uint[]{}; //work in progress
    vars.TurfWars = new uint[]{}; //work in progress
    vars.SilverLining = new uint[]{}; //work in progress*/

    vars.MissionsNumbers = new List<uint>();
    settings.Add("split options", false, "split options");
        settings.Add("Objectives", false, "Objectives", "split options");
        settings.SetToolTip("Objectives", "Splits slightly sooner on some missions compared to the xp splits.");
        settings.Add("XP", false, "XP", "split options");
        settings.SetToolTip("XP", "Splits when your xp increases on a mission end");
    settings.Add("Speedrun Options", false, "Speedrun Options");
        settings.Add("Main Story", false, "Main Story", "Speedrun Options");
        settings.SetToolTip("Main Story", "choose this if you are doing a main story run");
        settings.Add("DLC", false, "DLC", "Speedrun Options");
            settings.Add("The Heist", false, "The Heist", "DLC");
            settings.SetToolTip("The Heist", "choose this if you are only doing the heist dlc");
            settings.Add("Turf Wars", false, "Turf Wars", "DLC");
            settings.SetToolTip("Turf Wars", "choose this if you are only doing the turf wars dlc");
            settings.Add("Silver Lining", false, "Silver Lining", "DLC");
            settings.SetToolTip("Silver Lining", "choose this if you are only doing the silver lining dlc");
            settings.Add("CTNS", false, "CTNS", "DLC");
            settings.SetToolTip("CTNS", "choose this if you are doing all 3 dlcs");*/

}

init
{
    switch (modules.First().ModuleMemorySize) 
    {
        case 139841536: 
            version = "Steam v1.812";
            break;
        case 139845632: 
            version = "Steam v1.817";
            break;
        case 139911168: 
            version = "EGS v1.812";
            break;
        case 139980800 : 
            version = "Steam v1.824";
            break;
        case 139984896 : 
            version = "Steam v1.907";
            break;
        case 140001280 : 
            version = "Steam v1.919";
            break;
        case 140296192 : 
            version = "Steam v1.1006";
            break;
        case 140320768 : 
            version = "Steam v1.1014";
            break;
        case 140357632 : 
            version = "Steam v2.217";
            break;
        case 140431360 : 
            version = "Steam v2.512";
            break;
        case 140443648 : 
            version = "Steam v2.1012";
            break;
        case 140525568 :
            version = "Steam v3.618";
            break;
        case 140496896 :
            version = "Steam v4.630";
            break;

        default:
            print("Unknown version detected");
            return false;
        }
    
}

update
{
    //DEBUG CODE
    print(modules.First().ModuleMemorySize.ToString());
    //print(current.loading.ToString()); 
    //print(current.objective.ToString());
}

onStart
{
    // This makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
    
    if (settings["Objectives"]) // if user wants to split on objectives instead of xp so sooner splits
    {
        vars.MissionsNumbers.AddRange(vars.UniqueNumbers);
    }

    //work in progress
    /*else if (settings["CTNS"])
    {
        vars.MissionsNumbers.AddRange(vars.CTNS);
    }
    else if (settings["The Heist"])
    {
        vars.MissionsNumbers.AddRange(vars.TheHeist);
    }
    else if (settings["Turf Wars"])
    {
        vars.MissionsNumbers.AddRange(vars.TurfWars);
    }
    else if (settings["Silver Lining"])
    {
        vars.MissionsNumbers.AddRange(vars.SilverLining);
    }
    */
}

start
{
    if(old.objective == 0 && current.objective == 648768089)
    {
        return true;
    }
    else if(current.objective == 4005150524 && old.objective != 4005150524 && (settings["The Heist"] || settings["CTNS"]))
    {
        return true;
    }
    else if(current.objective == 2295251211 && old.objective != 2295251211 && (settings["Turf wars"] || settings["CTNS"]))
    {
        return true;
    }
    else if(current.objective == 1262575096 && old.objective != 1262575096 && (settings["Silver Lining"] || settings["CTNS"]))
    {
        return true;
    }
    
}

split
{
    //will split for all missions but going from 2nd to last mission to last mission sense the value needs to be replaced,
	if(vars.MissionsNumbers.Contains(current.objective) && current.obejctive != old.objective && settings["Objectives"]) //Checks if Missions contains the current obejctive if so it splits
	{
		vars.MissionsNumbers.RemoveAt(0); //Removes the current objective from the list
		return true;
	} else if (vars.xp.Contains(current.totalxp - old.totalxp) && settings["XP"]) //Checks if the xp gained is in the list of xp gains
    {
        return true;
    }
}

onReset
{
    vars.MissionsNumbers.Clear();
}

isLoading
{
   return current.loading;
}

exit
{
    timer.IsGameTimePaused = true;
}
