/*
var chart;
$(document).ready(function() {
   chart = new Highcharts.Chart({
      chart: {
         renderTo: 'container',
         plotBackgroundColor: null,
         plotBorderWidth: null,
         plotShadow: false
      },
      title: {
         text: 'Browser market shares at a specific website, 2010'
      },
      tooltip: {
         formatter: function() {
            return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
         }
      },
      plotOptions: {
         pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
               enabled: true,
               color: '#000000',
               connectorColor: '#000000',
               formatter: function() {
                  return '<b>'+ this.point.name +'</b>: '+ this.percentage +' %';
               }
            }
         }
      },
       series: [{
         type: 'pie',
         name: 'Browser share',
         data: [
            { 	name: 'Firefox',   
				y: 45.0,
				drilldown: {
				               name: 'MSIE versions',
				               categories: ['MSIE 6.0', 'MSIE 7.0', 'MSIE 8.0', 'MSIE 9.0'],
				               data: [10.85, 7.35, 33.06, 2.81], 
				}
			},
            {	name: 'IE', 
      			y: 26.8,
				drilldown: {
				               name: 'Firefox versions',
				               categories: ['Firefox 2.0', 'Firefox 3.0', 'Firefox 3.5', 'Firefox 3.6', 'Firefox 4.0'],
				               data: [0.20, 0.83, 1.58, 13.12, 5.43]
				}
			},
            {
               	name: 'Chrome',    
               	y: 12.8,
               	sliced: true,
               	selected: true,
				drilldown: {
							   name: 'Chrome versions',
				               categories: ['Chrome 5.0', 'Chrome 6.0', 'Chrome 7.0', 'Chrome 8.0', 'Chrome 9.0', 
				                  'Chrome 10.0', 'Chrome 11.0', 'Chrome 12.0'],
				               data: [0.12, 0.19, 0.12, 0.36, 0.32, 9.91, 0.50, 0.22]
				}
            },
            {	
				name: 'Safari',    
				y: 8.5,
				drilldown: {
				               name: 'Safari versions',
				               categories: ['Safari 5.0', 'Safari 4.0', 'Safari Win 5.0', 'Safari 4.1', 'Safari/Maxthon', 
				                  'Safari 3.1', 'Safari 4.1'],
				               data: [4.55, 1.42, 0.23, 0.21, 0.20, 0.19, 0.14]
				}
			},
            {
				name: 'Opera', 
				y: 6.2,
				drilldown: {
				               name: 'Opera versions',
				               categories: ['Opera 9.x', 'Opera 10.x', 'Opera 11.x'],
				               data: [ 0.12, 0.37, 1.65]
				}
			},
            {
				name: 'Others',   
				y: 0.7,
				drilldown: {
				               name: 'Others versions',
				               categories: ['Others'],
				               data: [ 0.7 ]
				}
			}
         ]
      }]
   });
});
*/