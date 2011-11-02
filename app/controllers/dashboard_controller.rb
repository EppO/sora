# encoding: utf-8

class DashboardController < ApplicationController
  def index
    hours = (0..23).to_a
    days = (1..(Date.today.end_of_month.day)).to_a.map { |d| "#{Date.today.year}-#{Date.today.month}-#{(d < 10 ? "0" : "") + d.to_s }"}
    days_only = (1..(Date.today.end_of_month.day)).to_a.map { |d| "#{d.to_s}" }
    
    @originated_calls_by_hours, @answered_calls_by_hours, @hourly_chart = create_graph( "call_hour", {"call_date" => Date.today.to_s }, hours, 
                                                                                        "Appels par heure durant la journée", hours.map { |h| "#{h}h" }, "Appels / h", 3)
    
    @originated_calls_by_days, @answered_calls_by_days, @daily_chart = create_graph("call_date", {"call_date" => { "$gte" => Date.today.beginning_of_month.to_s }}, days, 
                                                                                    "Appels par jour durant ce mois", days_only, "Appels / j", 100)
  end
  
  private
  
  def create_graph(field, query, range, title, xtitle, ytitle, max_padding)
    originate = collection_to_hash(field, query.merge({ "call_type" => "originate" }))
    answer = collection_to_hash(field, query.merge({"call_type" => "answer" }))
    originated_values = []
    answered_values = []
    max = 0
    range.each do |h|
      originated_values << originate[h]
      answered_values << answer[h]
      max = originate[h] + answer[h] if originate[h] + answer[h] > max
    end
    originate[:total] = originate.inject(0) { |sum,x| sum+x[1] }
    answer[:total] = answer.inject(0) { |sum,x| sum+x[1] }
    calls_total = originate[:total] + answer[:total]
    puts originated_values.inspect
    
    chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:title][:text] = title
      f.options[:chart][:defaultSeriesType] = "column"
      f.options[:xAxis][:categories] = xtitle
      f.options[:yAxis] = [ { :title => { :text => ytitle }, :max => max + max_padding, 
                              :stackLabels => { :enabled =>  true, :style => { :fontWeight => 'bold', :color => 'gray' }}}, 
                            { :title => { :text => nil } } ]
      f.series(:name =>"Appels (originate)", :data => originated_values, :yAxis => 0, :stack => 0 )
      f.series(:name =>"Appels (answer)", :data => answered_values, :yAxis => 0, :stack => 0 )
      f.series(:name => "Type d'appels", :type => "pie", :data => [ { :name => "answer", :y => (answer[:total] / calls_total * 100).round, color: '#AA4643' }, 
                                                                    { :name => "originate", :y => (originate[:total] / calls_total * 100).round, color: '#4572A7' } ], 
                                                                    :center =>  [80, 20], :size =>  100, :showInLegend => false, :yAxis => 1) if calls_total > 0
    end
    [ originate, answer, chart ]
  end
  
  def collection_to_hash(field, query)
    Call.collection.map_reduce(map(field), reduce, { :out => { :inline => 1 }, :query => query}).find.inject(Hash.new(0)) {|h, i| 
      h[i.values[0].class == String ? i.values[0] : i.values[0].to_i] = i.values[1]; h 
    }
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
