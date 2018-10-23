//if the windows resizes, redraw the canvas
d3.select(window).on('resize', drawCanvas);

//call the function for drawing the canvas when the website loads
drawCanvas();

//draw the canvas
function drawCanvas() {

    //source: https://www.youtube.com/watch?v=x8dwXoWODZ4
    //trying to create a pack layout
    var data = {
        "name": "flare",
        "children": [
         {
          "name": "analytics",
          "children": [
           {
            "name": "cluster",
            "children": [
             {"name": "AgglomerativeCluster", "size": 3938},
             {"name": "CommunityStructure", "size": 3812},
             {"name": "HierarchicalCluster", "size": 6714},
             {"name": "MergeEdge", "size": 743}
            ]
           },
           {
            "name": "graph",
            "children": [
             {"name": "BetweennessCentrality", "size": 3534},
             {"name": "LinkDistance", "size": 5731},
             {"name": "MaxFlowMinCut", "size": 7840},
             {"name": "ShortestPaths", "size": 5914},
             {"name": "SpanningTree", "size": 3416}
            ]
           },
           {
            "name": "optimization",
            "children": [
             {"name": "AspectRatioBanker", "size": 7074}
            ]
           }
          ]
         },
         {
          "name": "animate",
          "children": [
           {"name": "Easing", "size": 17010},
           {"name": "FunctionSequence", "size": 5842},
           {
            "name": "interpolate",
            "children": [
             {"name": "ArrayInterpolator", "size": 1983},
             {"name": "ColorInterpolator", "size": 2047},
             {"name": "DateInterpolator", "size": 1375},
             {"name": "Interpolator", "size": 8746},
             {"name": "MatrixInterpolator", "size": 2202},
             {"name": "NumberInterpolator", "size": 1382},
             {"name": "ObjectInterpolator", "size": 1629},
             {"name": "PointInterpolator", "size": 1675},
             {"name": "RectangleInterpolator", "size": 2042}
            ]
           },
           {"name": "ISchedulable", "size": 1041},
           {"name": "Parallel", "size": 5176},
           {"name": "Pause", "size": 449},
           {"name": "Scheduler", "size": 5593},
           {"name": "Sequence", "size": 5534},
           {"name": "Transition", "size": 9201},
           {"name": "Transitioner", "size": 19975},
           {"name": "TransitionEvent", "size": 1116},
           {"name": "Tween", "size": 6006}
          ]
         },
         {
          "name": "data",
          "children": [
           {
            "name": "converters",
            "children": [
             {"name": "Converters", "size": 721},
             {"name": "DelimitedTextConverter", "size": 4294},
             {"name": "GraphMLConverter", "size": 9800},
             {"name": "IDataConverter", "size": 1314},
             {"name": "JSONConverter", "size": 2220}
            ]
           },
           {"name": "DataField", "size": 1759},
           {"name": "DataSchema", "size": 2165},
           {"name": "DataSet", "size": 586},
           {"name": "DataSource", "size": 3331},
           {"name": "DataTable", "size": 772},
           {"name": "DataUtil", "size": 3322}
          ]
         },
         {
          "name": "display",
          "children": [
           {"name": "DirtySprite", "size": 8833},
           {"name": "LineSprite", "size": 1732},
           {"name": "RectSprite", "size": 3623},
           {"name": "TextSprite", "size": 10066}
          ]
         },
         {
          "name": "flex",
          "children": [
           {"name": "FlareVis", "size": 4116}
          ]
         },
         {
          "name": "physics",
          "children": [
           {"name": "DragForce", "size": 1082},
           {"name": "GravityForce", "size": 1336},
           {"name": "IForce", "size": 319},
           {"name": "NBodyForce", "size": 10498},
           {"name": "Particle", "size": 2822},
           {"name": "Simulation", "size": 9983},
           {"name": "Spring", "size": 2213},
           {"name": "SpringForce", "size": 1681}
          ]
         },
         {
          "name": "scale",
          "children": [
           {"name": "IScaleMap", "size": 2105},
           {"name": "LinearScale", "size": 1316},
           {"name": "LogScale", "size": 3151},
           {"name": "OrdinalScale", "size": 3770},
           {"name": "QuantileScale", "size": 2435},
           {"name": "QuantitativeScale", "size": 4839},
           {"name": "RootScale", "size": 1756},
           {"name": "Scale", "size": 4268},
           {"name": "ScaleType", "size": 1821},
           {"name": "TimeScale", "size": 5833}
          ]
         },
         {
          "name": "util",
          "children": [
           {"name": "Arrays", "size": 8258},
           {"name": "Colors", "size": 10001},
           {"name": "Dates", "size": 8217},
           {
            "name": "heap",
            "children": [
             {"name": "FibonacciHeap", "size": 9354},
             {"name": "HeapNode", "size": 1233}
            ]
           },
           {"name": "IEvaluable", "size": 335},
           {"name": "IPredicate", "size": 383},
           {"name": "IValueProxy", "size": 874},
           {
            "name": "math",
            "children": [
             {"name": "DenseMatrix", "size": 3165},
             {"name": "IMatrix", "size": 2815},
             {"name": "SparseMatrix", "size": 3366}
            ]
           },
           {"name": "Maths", "size": 17705},
           {"name": "Orientation", "size": 1486},
           {
            "name": "palette",
            "children": [
             {"name": "ColorPalette", "size": 6367},
             {"name": "Palette", "size": 1229}
            ]
           }
          ]
         },
         {
          "name": "vis",
          "children": [
           {
            "name": "data",
            "children": [
             {"name": "Data", "size": 20544},
             {"name": "DataList", "size": 19788},
             {"name": "DataSprite", "size": 10349},
             {"name": "EdgeSprite", "size": 3301},
             {"name": "NodeSprite", "size": 19382},
             {
              "name": "render",
              "children": [
               {"name": "ArrowType", "size": 698},
               {"name": "EdgeRenderer", "size": 5569},
               {"name": "IRenderer", "size": 353},
               {"name": "ShapeRenderer", "size": 2247}
              ]
             },
           {
            "name": "operator",
            "children": [
             {
              "name": "distortion",
              "children": [
               {"name": "BifocalDistortion", "size": 4461},
               {"name": "Distortion", "size": 6314},
               {"name": "FisheyeDistortion", "size": 3444}
              ]
             },
             {
              "name": "encoder",
              "children": [
               {"name": "ColorEncoder", "size": 3179},
               {"name": "Encoder", "size": 4060},
               {"name": "PropertyEncoder", "size": 4138},
               {"name": "ShapeEncoder", "size": 1690},
               {"name": "SizeEncoder", "size": 1830}
              ]
             },
             {
              "name": "filter",
              "children": [
               {"name": "FisheyeTreeFilter", "size": 5219},
               {"name": "GraphDistanceFilter", "size": 3165},
               {"name": "VisibilityFilter", "size": 3509}
              ]
             }
          ]
        }
    ]
         }
        ]
    }
    ]
       };

    var svg = d3.select("body").append("svg").attr("height", "960px").attr("width", "960px");
    var margin = 20;
    var diameter = 960;
    var g = svg.append('g').attr('transform', 'translate(' + diameter / 2 + ',' + diameter / 2 + ')');

    var color = d3.scaleLinear()
                    .domain([-1,5])
                    .range(['hsl(152,80%,80%)', 'hsl(228,30%,40%)'])
                    .interpolate(d3.interpolateHcl);

    var pack = d3.pack()
        .size([diameter - margin, diameter - margin])
        .padding(2);

    var root = d3.hierarchy(data)
        .sum(function(d) { return d.size; })
        .sort(function(a, b){ return b.value - a.value});
    
    var focus = root;
    var nodes = pack(root).descendants();
    var view;

    var circle = g.selectAll("circle")
    .data(nodes)
    .enter().append("circle")
      .attr("class", function(d) { return d.parent ? d.children ? "node" : "node node--leaf" : "node node--root"; })
      .style("fill", function(d) { return d.children ? color(d.depth) : null; })
      .on("click", function(d) { if (focus !== d) zoom(d), d3.event.stopPropagation(); });

  var text = g.selectAll("text")
    .data(nodes)
    .enter().append("text")
      .attr("class", "label")
      .style("fill-opacity", function(d) { return d.parent === root ? 1 : 0; })
      .style("display", function(d) { return d.parent === root ? "inline" : "none"; })
      .text(function(d) { return d.data.name; });

  var node = g.selectAll("circle,text");

  svg
      .style("background", color(-1))
      .on("click", function() { zoom(root); });

  zoomTo([root.x, root.y, root.r * 2 + margin]);

  function zoom(d) {
    var focus0 = focus; focus = d;

    var transition = d3.transition()
        .duration(d3.event.altKey ? 7500 : 750)
        .tween("zoom", function(d) {
          var i = d3.interpolateZoom(view, [focus.x, focus.y, focus.r * 2 + margin]);
          return function(t) { zoomTo(i(t)); };
        });

    transition.selectAll("text")
      .filter(function(d) { return d.parent === focus || this.style.display === "inline"; })
        .style("fill-opacity", function(d) { return d.parent === focus ? 1 : 0; })
        .on("start", function(d) { if (d.parent === focus) this.style.display = "inline"; })
        .on("end", function(d) { if (d.parent !== focus) this.style.display = "none"; });
  }

  function zoomTo(v) {
    var k = diameter / v[2]; view = v;
    node.attr("transform", function(d) { return "translate(" + (d.x - v[0]) * k + "," + (d.y - v[1]) * k + ")"; });
    circle.attr("r", function(d) { return d.r * k; });
  }
    
/* 
    console.log(data)

    var width = window.innerWidth||document.documentElement.clientWidth||document.body.clientWidth; //read the window width from the browser
    var height = window.innerHeight||document.documentElement.clientHeight||document.body.clientHeight; //read the window height from the browser

    

    var data1 = {
        source: {x: 10,
                 y: 10
                },
        target: {x: 300,
                y: 300}
    } 

    var tree = d3.tree()
                    .size([400, 400]);


    var nodes = tree.nodes(data); */



/*     var link = d3.linkHorizontal()
        .x(function(d) {
            return d.x;
        })
        .y(function(d) {
            return d.y;
        });

    svg.append('path')
        .attr('fill', 'none')
        .attr('stroke', 'black')
        .attr('d', link(data1)); //https://stackoverflow.com/questions/40845121/where-is-d3-svg-diagonal */

    /* var parseDate = d3.timeParse('%Y');

    d3.csv('data/vgsales')
        .row(function(d) {
            return {
                rank: Number(d.Rank),
                name: d.Name,
                platform: d.Platform,
                year: parseDate(d.Year),
                genre: d.Genre,
                publisher: d.Publisher,
                na_sales: Number(d.NA_Sales),
                eu_sales: Number(d.EU_Sales),
                jp_sales: Number(d.JP_Sales),
                other_sales: Number(d.Other_sales),
                global_sales: Number(d_Global_Sales)
            }
        })
        .get(function(error, data) {

            var width = window.innerWidth||document.documentElement.clientWidth||document.body.clientWidth; //read the window width from the browser
            var height = window.innerHeight||document.documentElement.clientHeight||document.body.clientHeight; //read the window height from the browser

            var maxSales = d3.max(data, function(d){ return d.global_sales});
            var minYear = d3.min(data, function(d){ return d.month; });
            

        }); */
    
   


}