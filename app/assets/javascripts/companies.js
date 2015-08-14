// jshint asi: true
var ready = function(){

  var chart = $('#chart')

  if (chart.length === 1){
    var historyURL = chart.data('history')

    $.getJSON(historyURL, function(data){
      var ohlc = [],
          volume = [],
          dataLength = data.history.length,
          groupingUnits = [[
            'week',
            [1]
          ], [
            'month',
            [1,2,3,4,6]
          ]],

          i = 0

      for (i; i < dataLength; i += 1){
        ohlc.push([
          data.history[i].timestamp,
          data.history[i].open,
          data.history[i].high,
          data.history[i].low,
          data.history[i].close
        ])
        volume.push([
          data.history[i].date,
          data.history[i].volume
        ])
      }

      chart.highcharts('StockChart', {
        rangeSelector: {
          selected: 1
        },
        title: {
          text: data.company.symbol
        },
        yAxis: [
          {
            labels: {
              align: 'right',
              x: -3
            },
            title: {
              text: data.company.symbol
            },
            height: '70%',
            lineWidth: 2
          },
          {
            labels: {
              align: 'right',
              x: -3
            },
            title: {
              text: 'Volume'
            },
            top: '65%',
            height: '20%',
            offset: 0,
            lineWidth: 2
          }
        ],
        series: [
          {
            type: 'candlestick',
            name: data.company.symbol,
            data: ohlc,
            dataGrouping: {
              units: groupingUnits
            }
          },
          {
            type: 'column',
            name: 'Volume',
            data: volume,
            yAxis: 1,
            dataGrouping: {
              units: groupingUnits
            }
          }
        ]
      })
    })

  }

}

$(document).ready(ready)
$(document).on('page:load', ready)
