% main function BITFINEX
function [response,status]=main_api_call_gdax(method,params)
default_method_names={'currencies','orders'};
default_method_types={@gdax_currencies,@gdax_orders};
method_select=find(strcmp(method,default_method_names), 1);
if isempty(method_select)
disp('wrong method name for gdax, please try: currencies')
response='error';
status='error';
else
[response,status]=default_method_types{method_select}(params);
end
end
% requests w/o authentication
% pubticker function
function [response,status]=gdax_currencies(params)
url_ext='/currencies';
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
url=['https://api-public.sandbox.gdax.com/',url_ext];
[response,status] = urlread2(url,'GET',{},header_1);
end


% requests with authentication
% header & parameters
function [response,status]=gdax_authenticated(url_ext,parameter,GPD)
    url='https://api.bitfinex.com';
    timestamp = num2str(floor((now-datenum('1970', 'yyyy'))*8640000));
    requestPath='/orders';

    [key,secret,passphrase]=key_secret('gdax');
    url=[url url_ext];
    payload_json=[timestamp,GPD,requestPath,parameter];
    payload_uint8=uint8(payload_json);
    payload=char(org.apache.commons.codec.binary.Base64.encodeBase64(payload_uint8))';
    Signature = char(crypto(payload, secret, 'HmacSHA256'));
    header_1=http_createHeader('CB-ACCESS-KEY',key);
    header_2=http_createHeader('CB-ACCESS-SIGN',Signature);
    header_3=http_createHeader('CB-ACCESS-TIMESTAMP',timestamp);
    header_4=http_createHeader('CB-ACCESS-PASSPHRASE',passphrase);

    header=[header_1 header_2 header_3 header_4];
    [response,status] = urlread2(url,GPD,'',header);
end
% new_order function
function [response,status]=gdax_orders(params)
    GPD='POST';
url_ext='/orders';
paramsss={'client_oid','type','side','product_id','stp','stop','stop_price','price','size','time_in_force','cancel_after','post_only','funds'};
paramsss_def={'client_oid	[optional]: Order ID selected by you to identify your order',...
'type	[optional] limit or market (default is limit)',...
'side	buy or sell',...
'product_id	A valid product id',...
'stp	[optional] Self-trade prevention flag',...
'stop	[optional] Either loss or entry. Requires stop_price to be defined.',...
'stop_price	[optional] Only if stop is defined. Sets trigger price for stop order.',...
'price	Price per bitcoin',...
'size	Amount of BTC to buy or sell',...
'time_in_force	[optional] GTC, GTT, IOC, or FOK (default is GTC)',...
'cancel_after	[optional]* min, hour, day',...
'post_only	[optional]** Post only flag',...
'funds	[optional]* Desired amount of quote currency to use'};
parameter='{"';
k=0;
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
    else
        k=k+1;
        parameters{k}=params{asd};
        k=k+1;
        parameters{k}=num2str(params{asd+1});
    end
end
parameter='{"';
for i=1:length(parameters)/2-1
    parameter=[parameter,parameters{2*i-1},'": "',parameters{2*i},'","'];
end
parameter=[parameter,parameters{end-1},'": "',parameters{end},'"}'];

[response,status]=gdax_authenticated(url_ext,parameter,GPD);

end
