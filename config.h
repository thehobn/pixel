/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "-*-terminus-medium-r-*-*-16-*-*-*-*-*-*-*";
static const char normbordercolor[] = "#444444";
static const char normbgcolor[]     = "#222222";
static const char normfgcolor[]     = "#bbbbbb";
static const char selbordercolor[]  = "#005577";
static const char selbgcolor[]      = "#005577";
static const char selfgcolor[]      = "#eeeeee";
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const Bool showbar           = False;    /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            True,        -1 }
};

/* layout(s) */
static const float mfact      = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      view,	          {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      toggletag,      {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      tag,	          {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/zsh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-fn", font, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf", selfgcolor, NULL };
static const char *decnit[] = { "xbacklight", "-dec", "5", NULL };
static const char *incnit[] = { "xbacklight", "-inc", "5", NULL };
static const char *mutedb[] = { "amixer", "set", "Master", "0", NULL };
static const char *decdb[] = { "amixer", "set", "Master", "5-", NULL };
static const char *incdb[] = { "amixer", "set", "Master", "5+", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_grave,  spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_grave,  togglebar,      {0} },
	{ MODKEY,                       XK_F1,     focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_F2,     focusstack,     {.i = -1 } },
	{ MODKEY|ControlMask,		XK_F1,     incnmaster,     {.i = +1 } },
	{ MODKEY|ControlMask,		XK_F2,     incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,		XK_F1,     setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,		XK_F2,     setmfact,       {.f = +0.05} },
	{ MODKEY|Mod1Mask,		XK_F4,	   zoom,           {0} },
	{ MODKEY,			XK_Escape, killclient,     {0} },
	{ MODKEY,                       XK_F4,     setlayout,      {.v = &layouts[2]} },
	{ MODKEY|Mod1Mask,		XK_F5,	   setlayout,      {0} },
	{ MODKEY|ControlMask,		XK_F5,	   togglefloating, {0} },
	{ MODKEY,                       XK_F5,     view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask|ControlMask, XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,			XK_F6,	   spawn,	   {.v = decnit } },
	{ MODKEY,			XK_F7,	   spawn,	   {.v = incnit } },
	{ MODKEY,			XK_F8,	   spawn,	   {.v = mutedb } },
	{ MODKEY,			XK_F9,	   spawn,	   {.v = decdb } },
	{ MODKEY,			XK_F10,	   spawn,	   {.v = incdb } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

