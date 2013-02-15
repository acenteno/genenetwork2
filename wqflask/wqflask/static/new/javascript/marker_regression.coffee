$ ->

    class Manhattan_Plot

        constructor: ->
            @qtl_results = js_data.qtl_results
            @max_chr = @get_max_chr()

            @plot_height = 500
            @plot_width = 1000

            @x_coords = []
            @y_coords = []
            @get_coordinates()
            
            @x_max = d3.max(@x_coords)
            @y_max = d3.max(@y_coords)

            @plot_coordinates = _.zip(@x_coords, @y_coords)
            @create_graph()


        get_max_chr: () ->
            max_chr = 0
            for result in @qtl_results
                chr = parseInt(result.chr)
                console.log("foo:", chr, typeof(chr))
                if not _.isNaN(chr) 
                    if chr > max_chr
                        max_chr = chr
            return max_chr


        get_coordinates: () ->
            for result in js_data.qtl_results
                chr = parseInt(result.chr)
                if _.isNaN(chr)
                    if result.chr == "X"
                        chr = @max_chr + 1
                    else if result.chr == "Y"
                        chr = @max_chr + 2
        
                @x_coords.push(((chr-1) * 200) + parseFloat(result.Mb))
                @y_coords.push(result.lrs_value)


        create_graph: () ->
            svg = d3.select("#manhattan_plots")
                        .append("svg")
                        .style('border', '2px solid black')
                        .attr("width", @plot_width)
                        .attr("height", @plot_height)
        
            svg.selectAll("circle")
                .data(@plot_coordinates)
                .enter()
                .append("circle")
                .attr("cx", (d) =>
                    return (@plot_width * d[0]/@x_max)
                )
                .attr("cy", (d) =>
                    return @plot_height - ((0.8*@plot_height) * d[1]/@y_max)
                )
                .attr("r", 2)

            x = d3.scale.linear()
                .domain([0, @x_max])
                .range([0, @plot_width])
                
            y = d3.scale.linear()
                .domain([0, @y_max])
                .range([0, @plot_height])
                
            svg.selectAll("line")
                .data(x.ticks(@max_chr))
                .enter()
                .append("line")
                .attr("x1", x)
                .attr("x2", x)
                .attr("y1", 0)
                .attr("y2", @plot_height)
                .style("stroke", "#ccc")

    new Manhattan_Plot
