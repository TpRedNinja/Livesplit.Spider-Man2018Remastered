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
*/

state("Spider-Man", "Steam v1.812")
{
    bool loading      : 0x7AF85D0; 
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
    uint objective : 0x6F3E8D8; 
} 

state("Spider-Man", "Steam v1.824")
{
    bool loading    : 0x7B1A510; 
    uint objective : 0x6E90258; 
} 


state("Spider-Man", "Steam v1.907")
{
    bool loading    : 0x7B1BA70; 
    uint objective : 0x6E91288;  
} 

state("Spider-Man", "Steam v1.919")
{
    bool loading    : 0x7B1F230;
    uint objective : 0x6E94958;
} 

state("Spider-Man", "Steam v1.1006")
{
    bool loading    : 0x7B63A10;
    uint objective : 0x6ED6FA8;
} 

state("Spider-Man", "Steam v1.1014")
{
    bool loading    : 0x7B69B30;
    uint objective : 0x6EDB228;
} 

state("Spider-Man", "Steam v2.217")
{
    bool loading    : 0x7B720D0;
    uint objective : 0x7091304;
} 

state("Spider-Man", "Steam v2.512")
{
    bool loading    : 0x7B74190;
    uint objective : 0x6EE5658;
} 

state("Spider-Man", "Steam v2.1012")
{
    bool loading    : 0x7B774D0;
    uint objective : 0x6EEA798;
} 

state("Spider-Man", "Steam v3.618")
{
    bool loading    : 0x7B8995C;                    
    uint objective  : 0x6EFC918;
    int totalxp     : 0x5DB609C;
}

init
{
    vars.loading = false;

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
    default:
        print("Unknown version detected");
        return false;
    }
}

startup
  {
		if (timer.CurrentTimingMethod == TimingMethod.RealTime)
// Asks user to change to game time if LiveSplit is currently set to Real Time.
    {        
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | Marvel's Spider-Man",
            MessageBoxButtons.YesNo,MessageBoxIcon.Question
        );
        
        if (timingMessage == DialogResult.Yes)
        {
            timer.CurrentTimingMethod = TimingMethod.GameTime;
        }
    }
	vars.ObjectiveNumbers = new[]{
    1230831290, 911656026, 316826671, 404089728, 436592259, 1229283555, 13877668, 3594905414, 
    3472337876, 2697528745, 2157044585, 2036655449, 2819266385, 721949320, 3232178045, 3974304245, 
    508893510, 1898405954, 1344066272, 2346266155, 316826671, 3332005264, 1946090111, 3917257570, 
    2641677965, 139569742, 1654122386, 316826671, 647221538, 2963508943, 1243652699, 316826671, 
    2080745987, 858338621, 95081780, 316826671, 637965749, 1425281762, 1930171772
}; //list of all valid objective numbers for splitting
vars.Missions = new List<int>[]; //list so we can make sure it doesnt double split

}
}

onStart
{
    // This makes sure the timer always starts at 0.00
    timer.IsGameTimePaused = true;
//setting it equal to the array so we can remove the stuff from the list sense you cant from a array to help avoid double splits
vars.Missions = new List<int>[vars.ObjectiveNumbers] 
}

update
{
//DEBUG CODE
//print(modules.First().ModuleMemorySize.ToString());
print(current.loading.ToString()); 
//print(current.objective.ToString());
}

start
{
	return (old.objective == 0 && current.objective == 648768089);
}


split 
{ 
	//will split for all missions but going from 2nd to last mission to last mission sense the value needs to be replaced,
	if(vars.Missions.Contains(current.objective) && version != "EGS v1.812") //Checks if Missions contains the current obejctive if so it splits
	{
		vars.Missions.RemoveAt[0];
		return true;
	}
    //(current.objective == 3166672678) && (old.objective != 3166672678); // Moves from The Heart of The Matter - Pax in Bello (REPLACE)
    //(current.docSmack  == 167) && (old.docSmack  == 166) && (current.objective == 3934225188); // splits when doc gets a big ol smack
}

/* commenting out until i have the motivation to come back and polish this mess
//bad values, dont use
//1279309092
//3064705042
//2254468055
//3549062773
//316826671

//3145605413 is kinda ehhhh cause its basically the "leave the lab" obj. Keeping for now cause it might work... but might not.
*/

onRest
{
vars.Missions.Clear();
}

isLoading
{
    return current.loading;
}

exit
{
	timer.IsGameTimePaused = true;
}
