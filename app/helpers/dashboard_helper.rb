module DashboardHelper
  def chart_options(originate, answered, stat, x_prefix, x_suffix = nil)
    options = "options.plotOptions = { 	pie: { dataLabels: { enabled: true, distance: -20 } }, 
                                        column: { stacking: 'normal', dataLabels: { enabled: true, color: 'white' } } }\n" 
    options += "options.plotOptions.column.dataLabels.formatter = function() { if (this.y) return this.y; }\n"
    options += "options.plotOptions.series = { point: { events: { click: function() { 
        var url = '#{stats_index_url}' + '?stats=#{stat}&src=';
        if (this.series.name == 'Appels (originate)')
          url += encodeURI('originate&y=' + this.y + '&x=#{x_prefix}' + this.x + '#{x_suffix ? x_suffix : ''}'); 
        else
          url += encodeURI('answer&y=' + this.y + '&x=#{x_prefix}' + this.x + '#{x_suffix ? x_suffix : ''}'); 
          window.location =  url;
          }}}}\n"
    options += "options.tooltip = {
        formatter: function() {
          var s;
          if (this.point.name) { // the pie chart
            s = this.point.name +': '+ this.y;
            if (this.point.name == 'originate')
              s += ' % (#{originate[:total]} appels)';
            else
              s += ' % (#{answered[:total]} appels)';
          } else {
            s = this.x  +': '+ this.y;
            if (this.series.name == 'Appels (originate)')
              s+= ' appels (originate)';
            else
              s+= ' appels (answer)';
            }
            return s;
          }
        }\n"
    options
  end
end
