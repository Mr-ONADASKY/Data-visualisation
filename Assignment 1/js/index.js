/*sources: https://bl.ocks.org/mbostock/7607535
    dynamic web development 2017 1e zit, taak Nick Vanden Eynde (ikzelf ofc :p)
*/

//if the windows resizes, redraw the canvas
d3.select(window).on('resize', drawCanvas);

//call the function for drawing the canvas when the website loads
drawCanvas();

//remove canvas when exists
function removeCanvas(){
    var svg =  d3.select('body').select('svg');
    if(!svg.empty()){
        svg.remove();
    }
}

function stackByPlatform(array, key = 'platform') {
     //default to 'platform' if platform key is not provided

    currentSortArray = [];
    tempArray = [];
    dataParsedArray = {'name': 'Game Sales', 'children': []};
    
    array.forEach(function(object){
        if(!tempArray[object[key]]){
            tempArray[object[key]] = [];
        }
        tempArray[object[key]].push(object);
    });

    for(key in tempArray){
        dataParsedArray.children.push({'name': key, children: tempArray[key]});
    }
    return dataParsedArray;
}

function stackByPublisher(array, key = 'publisher'){
    //default to 'publisher' if publisher key is not provided

    currentSortArray = [];
    dataParsedArray = {'name': 'Game Sales', 'children': []};
    
    array.children.forEach(function(object){
        tempArray = [];
        object.children.forEach(function(child){
            if(!tempArray[child[key]]){
                tempArray[child[key]] = [];
            }
            tempArray[child[key]].push(child);
        });
        var tempArray2 = [];
        for(name in tempArray){
            tempArray2.push({'name': name, children: tempArray[name]});
        }
        dataParsedArray.children.push({'name': object.name, children: tempArray2});
    });
    return dataParsedArray;
}

//draw the canvas
function drawCanvas() {

    removeCanvas(); //remove canvas if exists

    var parseDate = d3.timeParse('%Y'); //the date object is in the csv a year
    
    var parsedData = []; //array for storing the parsedData
    d3.csv('data/vgsales.csv')
        .then(function(data){
            data.forEach(element => {
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
                other_sales: Number(element.Other_sales),
                global_sales: Number(element.Global_Sales)
                };

                parsedData.push(object);
            });
           parsedData = stackByPlatform(parsedData);
           parsedData = stackByPublisher(parsedData);

            var testData = {
                'name': 'Top game sales',
                 'children': [
                     {
                        'name': 'Wii',
                        'children': [
                            {'name': 'Nintendo',
                            'children': [
                                {'name': 'Wii Sport', 'global_sales':82.74 },
                                {'name': 'Mario kart', 'global_sales':35.82 }
                            ]}
                        ]
                     },
                     {
                        'name': 'NES',
                        'children': [
                            {'name': 'Nintendo',
                            'children': [
                                {'name': 'Super mario bros', 'global_sales':40.24},
                                {'name': 'Duck hunt', 'global_sales':28.31 }
                            ]}
                        ]
                     },
                     {
                        'name': 'X360',
                        'children': [
                            {'name': 'Microsoft Game Studios',
                            'children': [
                                {'name': 'Kinnect', 'global_sales':21.82 },
                                {'name': 'Call of Duty', 'global_sales':14.76 }
                            ]}
                        ]
                     }
                     
                 ]
            }

            console.log(parsedData);
            console.log(testData);

            var width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth; //read the window width from the browser
            var height = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight; //read the window height from the browser

            var margin = 40;

            var svg = d3.select('body').append('svg').attr('width', width + 'px').attr('height', height + 'px');
            
            var diameter = Math.min(width,height);
            var windowCenter = {
                x: width / 2,
                y: height / 2
            }

            var g = svg.append('g').attr('transform', 'translate(' + windowCenter.x + ',' + windowCenter.y + ')');

            var color = d3.scaleLinear()
                .domain([-1, 5])
                .range(['hsl(152,80%,80%)', 'hsl(228,30%,40%)'])
                .interpolate(d3.interpolateHcl);

            var pack = d3.pack()
                .size([diameter - margin, diameter - margin])
                .padding(2);

            var root = d3.hierarchy(parsedData)
                .sum(function (d) {
                    return d.global_sales;
                })
                .sort(function (a, b) {
                    return b.value - a.value
                });

            var focus = root;
            var nodes = pack(root).descendants();
            var view;

            var circle = g.selectAll('circle')
                .data(nodes)
                .enter().append('circle')
                .attr('class', function (d) {
                    return d.parent ? d.children ? 'node' : 'node node--leaf' : 'node node--root';
                })
                .style('fill', function (d) {
                    return d.children ? color(d.depth) : null;
                })
                .on('click', function (d) {
                    if (focus !== d) zoom(d), d3.event.stopPropagation();
                });

            var text = g.selectAll('text')
                .data(nodes)
                .enter().append('text')
                .attr('class', 'label')
                .style('fill-opacity', function (d) {
                    return d.parent === root ? 1 : 0;
                })
                .style('display', function (d) {
                    return d.parent === root ? 'inline' : 'none';
                })
                .text(function (d) {
                    return d.data.name;
                });

            var node = g.selectAll('circle,text');

            svg
                .style('background', color(-1))
                .on('click', function () {
                    zoom(root);
                });

            zoomTo([root.x, root.y, root.r * 2 + margin]);

            function zoom(d) {
                var focus0 = focus;
                focus = d;

                var transition = d3.transition()
                    .duration(d3.event.altKey ? 7500 : 750)
                    .tween('zoom', function (d) {
                        var i = d3.interpolateZoom(view, [focus.x, focus.y, focus.r * 2 + margin]);
                        return function (t) {
                            zoomTo(i(t));
                        };
                    });

                transition.selectAll('text')
                    .filter(function (d) {
                        return d.parent === focus || this.style.display === 'inline';
                    })
                    .style('fill-opacity', function (d) {
                        return d.parent === focus ? 1 : 0;
                    })
                    .on('start', function (d) {
                        if (d.parent === focus) this.style.display = 'inline';
                    })
                    .on('end', function (d) {
                        if (d.parent !== focus) this.style.display = 'none';
                    });
            }

            function zoomTo(v) {
                var k = diameter / v[2];
                view = v;
                node.attr('transform', function (d) {
                    return 'translate(' + (d.x - v[0]) * k + ',' + (d.y - v[1]) * k + ')';
                });
                circle.attr('r', function (d) {
                    return d.r * k;
                });
            }

        });




}