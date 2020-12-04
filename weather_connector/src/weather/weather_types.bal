
public type Weather record {
    int id;
    string main;
    string description;
    string icon;
};


public type Coordinate record {
    decimal lon;
    decimal lat;
};

public type Main record {
    decimal temp?;
    decimal feels_like?;
    decimal temp_min?;
    decimal temp_max?;
    int pressure?;
    int humidity?;
};

public type Wind record {
    decimal speed;
    decimal deg;
};

public type Clouds record {
    decimal all;
};

public type General record {
    int 'type;
    int id;
    string country;
    decimal sunrise;
    decimal sunset;
};

public type WeatherDataResponse record {
    Coordinate cood = { lon:0, lat:0 };
    Weather[] weather = [{id:-1 , main:"", description:"", icon:""}];
    string base = "";
    Main main={ temp:0, feels_like:0, temp_min:0, temp_max:0, pressure:0, humidity:0};
    int visibility= 0;
    Wind Wind={speed:0, deg:0};
    Clouds clouds = {all:0};
    int dt = 0;
    General sys = {'type: 0, id:0, country:"", sunrise:0, sunset:0};
    int timezone=0;
    int id?;
    string name?;
    int cod?;
};