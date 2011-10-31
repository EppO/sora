# encoding: utf-8

class DashboardController < ApplicationController
  def index
    map = "function() { emit(this.call_hour, { count: 1, call_type: this.call_type  }); }"
    reduce = "function(key, values) { var result = {count: 0, answer_count: 0, originate_count: 0}; values.forEach(function(value) { result.count += value.count; if (value.call_type == 'originate') { result.originate_count += value.originate_count; } else { result.answer_count += value.answer_count }; }); return result;}"
    @calls_by_hours = Call.collection.map_reduce(map, reduce, { :query => {"call_date" => Date.today.to_s }}).find.inject(Hash.new(0)) {|h, i| h[i.values[0].to_i] = i.values[1]; h }
    hours = (0..23).to_a
    values = []
    originated = 0
    answered = 0
    totals = 0
    hours.each do |h|
      values << @calls_by_hours[h][:count]
      originated += 1 if @calls_by_hours[h][:call_type] == "originate"
      answered += 1 if @calls_by_hours[h][:call_type] == "answer"
      totals += 1
    end
    
    @hourly_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:title][:text] = "Appels par heure durant la journée"
      f.options[:chart][:defaultSeriesType] = "areaspline"
      f.options[:xAxis][:categories] = hours.map { |h| "#{h}h"}
      f.options[:yAxis][:title] = "Appels / h"
      f.options[:yAxis][:max] = 9
      f.options[:yAxis][:tickInterval] = 2
      f.options[:yAxis][:minorTickInterval] = 1
      f.series(:name =>"Appels / h", :data => values, :yAxis => 0 )
      f.series(:name => "Type d'appels", :type => "pie", :data => [ { :name => "Answer", :yreduce => (answered / totals * 100).round }, { :name => "originate", :y => (originated / totals * 100).round } ], :center =>  [80, 20],
               :size =>  100, :showInLegend => false, :yAxis => 1) if totals > 0
    end
    
    map = "function() { emit(this.call_date, 1); }"
    reduce = "function(k, vals) { var sum = 0; for(var i in vals) sum += vals[i]; return sum; }"
    @calls_by_days = Call.collection.map_reduce(map, reduce).find.inject(Hash.new(0)) {|h, i| h[i.values[0]] = i.values[1]; h }
    days = (1..31).to_a
    values = []
    days.each do |d|
      values << @calls_by_days["2011-10-#{(d < 10 ? "0" : "") + d.to_s }"]
    end
    @daily_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:title][:text] = "Appels par jour durant ce mois"
      f.options[:chart][:defaultSeriesType] = "area"
      f.options[:xAxis][:categories] = days
      f.series(:name=>'Appels / j', :data => values)
    end
  end
end
