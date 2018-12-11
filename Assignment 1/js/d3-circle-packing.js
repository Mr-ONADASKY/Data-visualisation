/* 
The following code is gained from https://bl.ocks.org/mbostock/7607535 created by the great Mike Bostock with some small modifications from my :p
changes made by author ninjawulf98 aka Nick Vanden Eynde:
    circle svg adjusts now to the full window size
    size is based on global_sales parameter instead of value parameter
    background and colorrange can be changed
*/

function drawCircle(parsedData, colorSetting) {
    var width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth; //read the window width from the browser
    var height = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight; //read the window height from the browser

    var margin = 40; //the margin between the cirkel and the outside of the canvas

    var svg = d3.select('body').append('svg').attr('width', width + 'px').attr('height', height + 'px');

    var diameter = Math.min(width, height) * .9; //calculate the diameter of the cirkel based on the window height/width & set it to 90%
    var windowCenter = { //set the center of the circle to the center of the screen 
        x: width / 2,
        y: height / 2
    }

    var circleCenter = { //set the center of the circle to the center of the screen 
        x: width / 2,
        y: height * 5 / 9
    }

    var g = svg.append('g').attr('transform', 'translate(' + circleCenter.x + ',' + circleCenter.y + ')'); //append the group where the circle will be in on the canvas
    var textContainer = svg.append('g').attr('transform', 'translate(' + 50 + ',' + 100 + ')'); // Append a text container to the svg

    //sets the color range for te circles based on a linearscale and there depth within the stack
    var color = d3.scaleLinear()
        .domain([0, 5])
        .range(['rgb(' + colorSetting.rangeStart.red + ',' + colorSetting.rangeStart.green + ',' + colorSetting.rangeStart.blue + ')', 'rgb(' + colorSetting.rangeStop.red + ',' + colorSetting.rangeStop.green + ',' + colorSetting.rangeStop.blue + ')'])
        .interpolate(d3.interpolateRgb);


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
            return d.parent ? 'node' : 'node node--root';
        })
        .style('fill', function (d) {
            return d.children ? color(d.depth) : color(colorSetting.rangeEnd.red, colorSetting.rangeEnd.blue, colorSetting.rangeEnd.green);
        })
        .on('click', function (d) {
            if (focus !== d) zoom(d), d3.event.stopPropagation();
        }).on('mouseenter', getCurrentFocusedObject);

        svg.append('text')
        .attr('x', windowCenter.x)
        .attr('y', 50)
        .attr('fill', 'white')
        .attr('text-anchor', 'middle')
        .attr('font-family', 'Helvetica,Arial,sans-serif')
        .attr('font-size', 30)
        .text('Global Game Sales');
    
    
// add all text boxes for data info
    var text = textContainer.append('text')
                            .attr('x', 50)
                            .attr('fill', 'white')
                            .attr('font-family', 'Helvetica,Arial,sans-serif');      

    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'title')
        .attr('font-size', 25)
        .text('Title: ');

    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'publisher')
        .attr('font-size', 20)
        .text('Publisher: ');
    
    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'platform')
        .attr('font-size', 20)
        .text('Platform: '); 
        
    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'genre')
        .attr('font-size', 20)
        .text('Genre: ');

    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'global-sales')
        .attr('font-size', 20)
        .text('Global Sales (millions):');

    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'eu-sales')
        .attr('font-size', 20)
        .text('Europe Sales (millions):');

    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'na-sales')
        .attr('font-size', 20)
        .text('North American Sales (millions):');

    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'jp-sales')
        .attr('font-size', 20)
        .text('Japan Sales (millions):');

    text.append('tspan') 
        .attr('x', 0)
        .attr('dy', '1.2em')
        .attr('class', 'other-sales')
        .attr('font-size', 20)
        .text('Other Sales (millions):');
        

    var node = g.selectAll('circle');

    svg
        .style('background', d3.rgb(colorSetting.background.red, colorSetting.background.green, colorSetting.background.blue))
        .on('click', function () {
            zoom(root);
        });

        svg
        .style('background', d3.rgb(colorSetting.background.red, colorSetting.background.green, colorSetting.background.blue))

    function getCurrentFocusedObject(data) {
        console.log(data.data.name, data);
        $('.title').html('Title: ' + data.data.name);
        $('.publisher').html('Publisher: ' + (data.data.publisher != undefined? data.data.publisher: ''));
        $('.platform').html('Platform: ' + (data.data.platform != undefined? data.data.platform: ''));
        $('.genre').html('Genre: ' + (data.data.genre != undefined? data.data.genre: ''));
        $('.global-sales').html('Global Sales (millions): ' + (data.data.global_sales != undefined? roundToNumber(data.data.global_sales): ''));
        $('.eu-sales').html('Europe Sales (millions): ' + (data.data.eu_sales != undefined? roundToNumber(data.data.eu_sales): ''));
        $('.na-sales').html('North American Sales (millions): ' + (data.data.na_sales != undefined? roundToNumber(data.data.na_sales): ''));
        $('.jp-sales').html('Japan Sales (millions): ' + (data.data.jp_sales != undefined? roundToNumber(data.data.jp_sales): ''));
        $('.other-sales').html('Other Sales (millions): ' + (data.data.other_sales != undefined? roundToNumber(data.data.other_sales): ''));
    }

    zoomTo([root.x, root.y, root.r * 2 + margin]);

    function zoom(d) {
        var focus0 = focus;
        focus = d;
        console.log(focus.data.name);

        var transition = d3.transition()
            .duration(d3.event.altKey ? 7500 : 750)
            .tween('zoom', function (d) {
                var i = d3.interpolateZoom(view, [focus.x, focus.y, focus.r * 2 + margin]);
                return function (t) {
                    zoomTo(i(t));
                };
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
}