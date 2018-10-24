/* 
The following code is gained from https://bl.ocks.org/mbostock/7607535 created by the great Mike Bostock with some small modifications from my :p
changes made by author ninjawulf98 aka Nick Vanden Eynde:
    circle svg adjusts now to the full window size
    size is based on global_sales parameter instead of value parameter
    background and colorrange can be changed
*/

function drawCircle(parsedData, colorSetting ) {
    var width = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth; //read the window width from the browser
    var height = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight; //read the window height from the browser

    var margin = 40; //the margin between the cirkel and the outside of the canvas

    var svg = d3.select('body').append('svg').attr('width', width + 'px').attr('height', height + 'px');

    var diameter = Math.min(width, height); //calculate the diameter of the cirkel based on the window height/width
    var windowCenter = { //set the center of the circle to the center of the screen 
        x: width / 2,
        y: height / 2
    }

    var g = svg.append('g').attr('transform', 'translate(' + windowCenter.x + ',' + windowCenter.y + ')'); //append the group where the circle will be in on the canvas

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
        .style('font-family', 'arial')
        .style('font-size', '20px')
        .style('font-weight', 'bold')
        .style('display', function (d) {
            return d.parent === root ? 'inline' : 'none';
        })
        .text(function (d) {
            return d.data.name;
        });

    var node = g.selectAll('circle,text');

    svg
        .style('background', d3.rgb(colorSetting.background.red, colorSetting.background.green, colorSetting.background.blue))
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
}