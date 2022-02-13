
/* user and group to drop privileges to */
static const char* user = "nobody";
static const char* group = "nogroup";

static const char* colorname[NUMCOLS] = {
        /* after initialization */
        [INIT] = "black",
    /* during input */
    [INPUT] = "black",
    /* wrong password */
    [FAILED] = "#1F1F1F",
};

/* treat a cleared input like a wrong password (color) */
static const int failonclear = 1;
