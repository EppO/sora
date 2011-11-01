# encoding: utf-8

class DashboardController < ApplicationController
  def index
    @originated_calls_by_hours = Call.collection.map_reduce(map("call_hour"), reduce, { :out => { :inline => 1 }, :query => {"call_date" => Date.today.to_s, "call_type" => "originate" }}).find.inject(Hash.new(0)) {|h, i| h[i.values[0].to_i] = i.values[1]; h }
    @answered_calls_by_hours = Call.collection.map_reduce(map("call_hour"), reduce, { :out => { :inline => 1 }, :query => {"call_date" => Date.today.to_s, "call_type" => "answer" }}).find.inject(Hash.new(0)) {|h, i| h[i.values[0].to_i] = i.values[1]; h }
    hours = (0..23).to_a
    originated_h = []
    answered_h = []
    max_hour = 0
    hours.each do |h|
      originated_h << @originated_calls_by_hours[h]
      answered_h << @answered_calls_by_hours[h]
      max_hour = @originated_calls_by_hours[h] + @answered_calls_by_hours[h] if @originated_calls_by_hours[h] + @answered_calls_by_hours[h] > max_hour
    end
    @originated_calls_by_hours[:total] = @originated_calls_by_hours.inject(0) { |sum,x| sum+x[1] }
    @answered_calls_by_hours[:total] = @answered_calls_by_hours.inject(0) { |sum,x| sum+x[1] }
    hourly_calls_total = @originated_calls_by_hours[:total] + @answered_calls_by_hours[:total]
    
    @hourly_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:title][:text] = "Appels par heure durant la journée"
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:xAxis][:categories] = hours.map { |h| "#{h}h"}
      f.options[:yAxis] = [ { :title => { :text => "Appels / h" }, :max => max_hour + 3, :tickInterval => 2, :minorTickInterval => 1, 
                              :stackLabels => { :enabled =>  true, :style => { :fontWeight => 'bold', :color => 'gray' }}}, 
                            { :title => { :text => nil } } ]
      f.series(:name =>"Appels (originate)", :data => originated_h, :yAxis => 0, :stack => 0 )
      f.series(:name =>"Appels (answer)", :data => answered_h, :yAxis => 0, :stack => 0 )
      f.series(:name => "Type d'appels", :type => "pie", :data => [ { :name => "answer", :y => (@answered_calls_by_hours[:total] / hourly_calls_total * 100).round, color: '#AA4643' }, 
                                                                    { :name => "originate", :y => (@originated_calls_by_hours[:total] / hourly_calls_total * 100).round, color: '#4572A7' } ], 
                                                                    :center =>  [80, 20], :size =>  100, :showInLegend => false, :yAxis => 1) if hourly_calls_total > 0
    end
    
    @originated_calls_by_days = Call.collection.map_reduce(map("call_date"), reduce, { :out => { :inline => 1 }, :query => { "call_type" => "originate" }}).find.inject(Hash.new(0)) {|h, i| h[i.values[0]] = i.values[1]; h }
    @answered_calls_by_days = Call.collection.map_reduce(map("call_date"), reduce, { :out => { :inline => 1 }, :query => { "call_type" => "answer" } }).find.inject(Hash.new(0)) {|h, i| h[i.values[0]] = i.values[1]; h }
    days = (1..(Date.today.end_of_month.day)).to_a
    originated_d = []
    answered_d = []
    max_day = 0
    days.each do |d|
      date = "#{Date.today.year}-#{Date.today.month}-#{(d < 10 ? "0" : "") + d.to_s }"
      originated_d << @originated_calls_by_days[date]
      answered_d << @answered_calls_by_days[date]
      max_day = @originated_calls_by_days[date] + @answered_calls_by_days[date] if @originated_calls_by_days[date] + @answered_calls_by_days[date] > max_day
    end
    @originated_calls_by_days[:total] = @originated_calls_by_hours.inject(0) { |sum,x| sum+x[1] }
    @answered_calls_by_days[:total] = @answered_calls_by_hours.inject(0) { |sum,x| sum+x[1] }
    daily_calls_total = @originated_calls_by_days[:total] + @answered_calls_by_days[:total]
    
    @daily_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:title][:text] = "Appels par jour durant ce mois"
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:xAxis][:categories] = days
      f.options[:yAxis] = [ { :title => { :text => "Appels / h" }, :max => max_day + 100, 
                              :stackLabels => { :enabled =>  true, :style => { :fontWeight => 'bold', :color => 'gray' }}}, 
                            { :title => { :text => nil } } ]
      f.series(:name=>'Appels (originate)', :data => originated_d, :stack => 0 )
      f.series(:name=>'Appels (answer)', :data => answered_d, :stack => 0 )
      f.series(:name => "Type d'appels", :type => "pie", :data => [ { :name => "answer", :y => (@answered_calls_by_days[:total] / daily_calls_total * 100).round, color: '#AA4643' }, 
                                                                    { :name => "originate", :y => (@originated_calls_by_days[:total] / daily_calls_total * 100).round, color: '#4572A7' } ], 
                                                                    :center =>  [80, 20], :size =>  100, :showInLegend => false, :yAxis => 1) if daily_calls_total > 0
    end
  end
  
  def map(arg)
    query = <<-MAP
      function() { 
        emit(this.%<arg>s, 1); 
      }
    MAP
    query % { :arg => arg }
  end
  
  def reduce
    <<-REDUCE
      function(key, values) { 
        var result = 0; 
        values.forEach(function(value) { 
          result += value; 
        }); 
        return result;
      }
    REDUCE
  end
end
