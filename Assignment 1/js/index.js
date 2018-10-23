//if the windows resizes, redraw the canvas
d3.select(window).on('resize', drawCanvas);

//call the function for drawing the canvas when the website loads
drawCanvas();

//draw the canvas
function drawCanvas() {

    var parseDate = d3.timeParse('%Y');

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
            

        });
    
   


}