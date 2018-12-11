/*sources: https://bl.ocks.org/mbostock/7607535
    https://jqueryui.com
    https://jquery.com/

    data:
    https://www.kaggle.com/gregorut/videogamesales/version/2
*/

var initialized = false; //check for avoiding an overide from the color settings to 0 when initializing the sliders

var colorSetting = { //default color settings
    "rangeStart": {
        "red": 163,
        "green": 0,
        "blue": 0
    },
    "rangeStop": {
        "red": 219,
        "green": 39,
        "blue": 15
    },
    "rangeEnd": {
        "red": 100,
        "green": 185,
        "blue": 255
    },
    "background": {
        "red": 15,
        "green": 15,
        "blue": 15
    },
    "data": {
        'type': 'global-simple',
        'console': ''
    }
};

var consoles = [];

//save the current color changes to the localstorage or read the user ones from the localstorage
if (typeof (Storage) !== 'undefined') {
    if (localStorage.getItem('colorSettings') == null) {
        localStorage.setItem('colorSettings', JSON.stringify(colorSetting));
    } else {
        colorSetting = JSON.parse(localStorage.getItem('colorSettings'));
    }
}

//execute some functions when the page is loaded
$(function () {
    //initialize the menu button and set a handler on it
    $('#menu-button').on('click', displayDialog);

    function displayDialog() {
        // display the dialog
        $("#dialog").dialog({
            hide: {
                effect: 'fold',
                duration: 500
            },
            show: {
                effect: 'fold',
                duration: 500
            },
            width: 600,
            modal: true,
            open: function () {
                $("#accordion").accordion();
            },
            close: function () {
                localStorage.setItem('colorSettings', JSON.stringify(colorSetting));
                drawCanvas();

            }
        });
    };

    //to convert rgb to hex values
    function hexFromRGB(r, g, b) {
        var hex = [
            r.toString(16),
            g.toString(16),
            b.toString(16)
        ];
        $.each(hex, function (nr, val) {
            if (val.length === 1) {
                hex[nr] = "0" + val;
            }
        });
        return hex.join("").toUpperCase();
    }

    //refresh the 1st swatch color if one of it slider values changes
    function refreshStartColorSwatch() {
        var red = $("#red-1").slider("value"),
            green = $("#green-1").slider("value"),
            blue = $("#blue-1").slider("value"),
            hex = hexFromRGB(red, green, blue);
        if (initialized) {
            colorSetting.rangeStart.red = red;
            colorSetting.rangeStart.green = green;
            colorSetting.rangeStart.blue = blue;
        }
        $("#swatch-1").css("background-color", "#" + hex);
    }

    //initialize the 1st swatch sliders
    $("#red-1, #green-1, #blue-1").slider({
        orientation: "horizontal",
        range: "min",
        max: 255,
        slide: refreshStartColorSwatch,
        change: refreshStartColorSwatch
    });
    //set the values to the 1st swatch sliders
    $("#red-1").slider("value", colorSetting.rangeStart.red);
    $("#green-1").slider("value", colorSetting.rangeStart.green);
    $("#blue-1").slider("value", colorSetting.rangeStart.blue);

    //refresh the 2nd swatch color if one of it slider values changes
    function refreshStopColorSwatch() {
        var red = $("#red-2").slider("value"),
            green = $("#green-2").slider("value"),
            blue = $("#blue-2").slider("value"),
            hex = hexFromRGB(red, green, blue);
        if (initialized) {
            colorSetting.rangeStop.red = red;
            colorSetting.rangeStop.green = green;
            colorSetting.rangeStop.blue = blue;
        }
        $("#swatch-2").css("background-color", "#" + hex);
    }
    //initialize the 2nd swatch sliders
    $("#red-2, #green-2, #blue-2").slider({
        orientation: "horizontal",
        range: "min",
        max: 255,
        slide: refreshStopColorSwatch,
        change: refreshStopColorSwatch
    });
    //set the values to the 2nd swatch sliders
    $("#red-2").slider("value", colorSetting.rangeStop.red);
    $("#green-2").slider("value", colorSetting.rangeStop.green);
    $("#blue-2").slider("value", colorSetting.rangeStop.blue);

    function refreshEndColorSwatch() {
        var red = $("#red-3").slider("value"),
            green = $("#green-3").slider("value"),
            blue = $("#blue-3").slider("value"),
            hex = hexFromRGB(red, green, blue);
        if (initialized) {
            colorSetting.rangeEnd.red = red;
            colorSetting.rangeEnd.green = green;
            colorSetting.rangeEnd.blue = blue;
        }
        $("#swatch-3").css("background-color", "#" + hex);
    }
    //initialize the 2nd swatch sliders
    $("#red-3, #green-3, #blue-3").slider({
        orientation: "horizontal",
        range: "min",
        max: 255,
        slide: refreshEndColorSwatch,
        change: refreshEndColorSwatch
    });
    //set the values to the 2nd swatch sliders
    $("#red-3").slider("value", colorSetting.rangeEnd.red);
    $("#green-3").slider("value", colorSetting.rangeEnd.green);
    $("#blue-3").slider("value", colorSetting.rangeEnd.blue);

    //refresh the 3rd swatch color if one of it slider values changes
    function refreshSwatch() {
        var red = $("#red").slider("value"),
            green = $("#green").slider("value"),
            blue = $("#blue").slider("value"),
            hex = hexFromRGB(red, green, blue);
        if (initialized) {
            colorSetting.background.red = red;
            colorSetting.background.green = green;
            colorSetting.background.blue = blue;
        }
        $("#swatch").css("background-color", "#" + hex);
    }
    //initialize the 3rd swatch sliders
    $("#red, #green, #blue").slider({
        orientation: "horizontal",
        range: "min",
        max: 255,
        slide: refreshSwatch,
        change: refreshSwatch
    });
    //set the values to the 3rd swatch sliders
    $("#red").slider("value", colorSetting.background.red);
    $("#green").slider("value", colorSetting.background.green);
    $("#blue").slider("value", colorSetting.background.blue);

    initialized = true;
});

//if the windows resizes, redraw the canvas
d3.select(window).on('resize', drawCanvas);

//call the function for drawing the canvas when the website loads
drawCanvas();

//remove canvas when exists
function removeCanvas() {
    var svg = d3.select('body').select('svg');
    if (!svg.empty()) {
        svg.remove();
    }
}

function stackByPlatform(array, key = 'platform') {
    //default to 'platform' if platform key is not provided

    if(consoles.length > 0) {
        consoles = [];
        }

    tempArray = []; //een tijdelijke tussen array 
    globalSales = 0 // For counting the total number of sales
    dataParsedArray = { //de uiteindelijke array
        'name': 'Game Sales',
        'children': []
    };

    

    //check every object within the array and store it in an temporal array
    array.forEach(function (object) {
         !isNaN(object.global_sales) ? globalSales += object.global_sales : 0;
        if (!tempArray[object[key]]) {
            tempArray[object[key]] = [];
        }
        tempArray[object[key]].push(object);
    });
    dataParsedArray.global_sales = roundToNumber(globalSales);

    //load the data from the temporal array to convert it to it's final array
    for (key in tempArray) {
        dataParsedArray.children.push({
            name: key,
            children: tempArray[key]
        });
        consoles.push(key);
    }
    return dataParsedArray;
}

function stackByPublisher(array, key = 'publisher') {
    //default to 'publisher' if publisher key is not provided

    currentSortArray = [];
    dataParsedArray = {
        name: 'Game Sales',
        global_sales : array.global_sales,
        children: []
    };

    //check every object within the array and store it in an temporal array
    array.children.forEach(function (object) {
        tempArray = [];
        globalSales = 0;
        europeSales = 0;
        northAmericanSales = 0;
        japanSales = 0;
        otherSales = 0;

        object.children.forEach(function (child) {
            globalSales += child.global_sales;
            europeSales += child.eu_sales;
            northAmericanSales += child.na_sales;
            japanSales += child.jp_sales;
            otherSales += child.other_sales;

            if (!tempArray[child[key]]) {
                tempArray[child[key]] = [];
            }
            tempArray[child[key]].push(child);
        });
        //convert the date from a 1st temporal array to a 2nd array
        var tempArray2 = [];
        for (name in tempArray) {
            publisherGlobalSales = 0;
            publisherEuropeSales = 0;
            publisherNorthAmericanSales = 0;
            publisherJapanSales = 0;
            publisherOtherSales = 0;

            tempArray[name].forEach((game) => {
                !isNaN(game.global_sales) ? publisherGlobalSales += game.global_sales : 0;
                !isNaN(game.eu_sales) ? publisherEuropeSales += game.eu_sales : 0;
                !isNaN(game.na_sales) ? publisherNorthAmericanSales += game.na_sales : 0;
                !isNaN(game.jp_sales) ? publisherJapanSales += game.jp_sales : 0;
                !isNaN(game.other_sales) ? publisherOtherSales += game.other_sales : 0;
            });
            tempArray2.push({
                name: name,
                global_sales: publisherGlobalSales,
                eu_sales: publisherEuropeSales,
                na_sales: publisherNorthAmericanSales,
                jp_sales: publisherJapanSales,
                other_sales: publisherOtherSales,
                children: tempArray[name]
            });
        }

        //load the data from the temporal array to convert it to it's final array
        dataParsedArray.children.push({
            name: object.name,
            global_sales: roundToNumber(globalSales),
            eu_sales: roundToNumber(europeSales),
            na_sales: roundToNumber(northAmericanSales),
            jp_sales: roundToNumber(japanSales),
            other_sales: roundToNumber(otherSales),
            children: tempArray2
        });
    });
    return dataParsedArray;
}

function consoleStackByPlatform(array, key = 'platform') {
    //default to 'platform' if platform key is not provided

    tempArray = []; //een tijdelijke tussen array 
    globalSales = 0 // For counting the total number of sales
    dataParsedArray = { //de uiteindelijke array
        name: 'Game Sales',
        children: []
    };
    if(consoles.length > 0) {
        consoles = [];
        }

    

    //check every object within the array and store it in an temporal array
    array.forEach(function (object) {
        
         !isNaN(object.global_sales) ? globalSales += object.global_sales : 0;
        if (!tempArray[object[key]]) {
            tempArray[object[key]] = [];
        }
        tempArray[object[key]].push(object);
    });
    dataParsedArray.global_sales = roundToNumber(globalSales);

    //load the data from the temporal array to convert it to it's final array
    for (key in tempArray) {
        if(key == colorSetting.data.console) {
            dataParsedArray.children.push({
                name: key,
                children: tempArray[key]
            });
        }
        consoles.push(key);
    }

    return dataParsedArray;
}

function consoleStackByPublisher(array, key = 'publisher') {
    //default to 'publisher' if publisher key is not provided

    currentSortArray = [];
    dataParsedArray = {
        name: 'Game Sales',
        global_sales : array.global_sales,
        children: []
    };
    //check every object within the array and store it in an temporal array
    array.children.forEach(function (object) {
        tempArray = [];
        globalSales = 0;
        europeSales = 0;
        northAmericanSales = 0;
        japanSales = 0;
        otherSales = 0;

        object.children.forEach(function (child) {
            globalSales += child.global_sales;
            europeSales += child.eu_sales;
            northAmericanSales += child.na_sales;
            japanSales += child.jp_sales;
            otherSales += child.other_sales;
            if (!tempArray[child[key]]) {
                tempArray[child[key]] = [];
            }
            tempArray[child[key]].push(child);
        });
        //convert the date from a 1st temporal array to a 2nd array
        var tempArray2 = [];
        for (name in tempArray) {
            publisherGlobalSales = 0;
            publisherEuropeSales = 0;
            publisherNorthAmericanSales = 0;
            publisherJapanSales = 0;
            publisherOtherSales = 0;

            tempArray[name].forEach((game) => {
                !isNaN(game.global_sales) ? publisherGlobalSales += game.global_sales : 0;
                !isNaN(game.eu_sales) ? publisherEuropeSales += game.eu_sales : 0;
                !isNaN(game.na_sales) ? publisherNorthAmericanSales += game.na_sales : 0;
                !isNaN(game.jp_sales) ? publisherJapanSales += game.jp_sales : 0;
                !isNaN(game.other_sales) ? publisherOtherSales += game.other_sales : 0;
            });

            tempArray2.push({
                name: name,
                global_sales: publisherGlobalSales,
                eu_sales: publisherEuropeSales,
                na_sales: publisherNorthAmericanSales,
                jp_sales: publisherJapanSales,
                other_sales: publisherOtherSales,
                children: tempArray[name]
            });
        }

        //load the data from the temporal array to convert it to it's final array
        dataParsedArray.children.push({
            name: object.name,
            global_sales: roundToNumber(globalSales),
            children: tempArray2
        });
    });
    return dataParsedArray;
}

function stackByPublisherSimple(array, key = 'platform') {
    //default to 'platform' if platform key is not provided

    globalSales = 0;

    if(consoles.length > 0) {
        consoles = [];
        }
    globalSalesPublisher = [];
    europelSalesPublisher = [];
    northAmericanSalesPublisher = [];
    JapanSalesPublisher = [];
    otherSalesPublisher = [];

    dataParsedArray = { //de uiteindelijke array
        name: 'Game Sales',
        children: []
    };

    //check every object within the array and store it in an temporal array
    array.forEach(function (object) {
        if(globalSalesPublisher[object.platform] == undefined) {
            globalSalesPublisher[object.platform] = 0;
            europelSalesPublisher[object.platform] = 0;
            northAmericanSalesPublisher[object.platform] = 0;
            JapanSalesPublisher[object.platform] = 0;
            otherSalesPublisher[object.platform] = 0;
        }
        !isNaN(object.global_sales) ? globalSalesPublisher[object.platform] += object.global_sales : 0;
        !isNaN(object.eu_sales) ? europelSalesPublisher[object.platform] += object.eu_sales : 0;
        !isNaN(object.na_sales) ? northAmericanSalesPublisher[object.platform] += object.na_sales : 0;
        !isNaN(object.jp_sales) ? JapanSalesPublisher[object.platform] += object.jp_sales : 0;
        !isNaN(object.other_sales) ? otherSalesPublisher[object.platform] += object.other_sales : 0;
        !isNaN(object.global_sales) ? globalSales += object.global_sales : 0;
    });
    dataParsedArray.global_sales = roundToNumber(globalSales);
    //load the data from the temporal array to convert it to it's final array
    for (key in globalSalesPublisher) {
        consoles.push(key);
        dataParsedArray.children.push({
            name: key,
            global_sales: globalSalesPublisher[key],
            eu_sales: europelSalesPublisher[key],
            na_sales: northAmericanSalesPublisher[key],
            jp_sales: northAmericanSalesPublisher[key],
            other_sales: otherSalesPublisher[key]
        });
    }
    return dataParsedArray;
}

//draw the canvas
function drawCanvas() {

    removeCanvas(); //remove canvas if exists

    var parseDate = d3.timeParse('%Y'); //the date object is in the csv a year

    var parsedData = []; //array for storing the parsedData
    d3.csv('data/vgsales.csv') //load the csv data
        .then(function (data) {
            data.forEach(element => { //rearange the csv array data into a personal prefered format
                var object = {
                    rank: Number(element.Rank),
                    name: element.Name,
                    platform: element.Platform,
                    year: parseDate(element.Year),
                    genre: element.Genre,
                    publisher: element.Publisher,
                    na_sales: Number(element.NA_Sales),
                    eu_sales: Number(element.EU_Sales),
                    jp_sales: Number(element.JP_Sales),
                    other_sales: Number(element.Other_Sales),
                    global_sales: Number(element.Global_Sales)
                };
                parsedData.push(object);
            });
            
            if(colorSetting.data.type == 'global-all') {
                parsedData = stackByPlatform(parsedData); //stack the data by platform
                parsedData = stackByPublisher(parsedData); //stack the data has been stacked by platform also bij Publisher
            } else if (colorSetting.data.type == 'publisher'){
                parsedData = stackByPublisherSimple(parsedData);
            } else if (colorSetting.data.type == 'console') {
                parsedData = consoleStackByPlatform(parsedData);
                parsedData = consoleStackByPublisher(parsedData);
            }
            consoles = consoles.sort();
            changeConsolesSelect();

            drawCircle(parsedData, colorSetting); //call the drawcircle function, created by the great Mike Bostock with some extra juicy cherry's from my garden on top of that cake :p

        });

}

function changeConsolesSelect() {
    consoles.forEach((consoleName) => {
        $('#console-select').append('<option value="' + consoleName + '">' + consoleName + '</option>');
    });
}

function changeConsole() {
    colorSetting.data.console = $('#console-select').val();
    localStorage.setItem('colorSettings', JSON.stringify(colorSetting));
}

function setDisplay(display) {
    if(display == 'console' && colorSetting.data.console == '') {
        colorSetting.data.console = $('#console-select').val();
        if(colorSetting.data.console == '') {
            alert('Please set console first');
        }   
    } else {
        colorSetting.data.type = display;
        localStorage.setItem('colorSettings', JSON.stringify(colorSetting));
        drawCanvas();
    }
}

// Round to a certain amount of numbers behind the comma, default: 2
function roundToNumber(number, amount = 2) { 
    var tempNumber = Math.round(number * Math.pow(10, amount));
    return tempNumber / Math.pow(10, amount);
}