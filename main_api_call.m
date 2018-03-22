function [response,status]=main_api_call(server,method,params)
server_names={'btce','cexio','bitstamp','bitfinex','huobi','gdax','bittrex'};
function_list={@main_api_call_btce,@main_api_call_cexio,@main_api_call_bitstamp,@main_api_call_bitfinex,@main_api_call_huobi,@main_api_call_gdax,@main_api_call_bittrex};
server_select=find(strcmp(server,server_names),1);
[response,status]=function_list{server_select}(method,params);
end