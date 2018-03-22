
function [response,status]=main_api_call_bittrex(method,params)
default_method_names={'getmarkets','getcurrencies','getticker','getmarketsummaries',...
    'getmarketsummary','getorderbook','getmarkethistory','buylimit','buymarket',...
    'sell','withdrawal_requests','bitcoin_withdrawal',...
    'selllimit','sellmarket','cancel',...
    'getopenorders','getbalances','getbalance','getdepositaddress','withdraw',...
    'getorder','getorderhistory','getwithdrawalhistory','getdeposithistory'};
default_method_types={@bittrex_getmarkets,@bittrex_getcurrencies,...
    @bittrex_getticker,@bittrex_getmarketsummaries,@bittrex_getmarketsummary,...
    @bittrex_getorderbook,@bittrex_getmarkethistory,...
    @bittrex_buylimit,@bittrex_buymarket,@bittrex_sell,...
    @bittrex_withdrawal_requests,@bittrex_bitcoin_withdrawal,...
    @bittrex_selllimit,@bittrex_sellmarket,...
    @bittrex_cancel,@bittrex_getopenorders,@bittrex_getbalances,...
    @bittrex_getbalance,@bittrex_getdepositaddress,@bittrex_withdraw,...
    @bittrex_getorder,@bittrex_getorderhistory,@bittrex_getwithdrawalhistory,@bittrex_getdeposithistory};
method_select=find(strcmp(method,default_method_names), 1);
if isempty(method_select)
disp('wrong method name for bittrex, please try: getmarkets,getcurrencies,getticker,getmarketsummaries,getmarketsummary,getorderbook,getmarkethistory,buylimit,buymarket,sell,withdrawal_requests,bitcoin_withdrawal,selllimit,sellmarket,cancel,getopenorders,getbalances,getbalance,getdepositaddress,withdraw,getorder,getorderhistory,getwithdrawalhistory,getdeposithistory')
response='error';
status='error';
else
[response,status]=default_method_types{method_select}(params);
end
end
% requests w/o authentication
% getmarkets function
function [response,status]=bittrex_getmarkets(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
url='https://bittrex.com/api/v1.1/public/getmarkets';
[response,status] = urlread2(url,'GET',{},header_1);
end
% getcurrencies function
function [response,status]=bittrex_getcurrencies(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
url='https://bittrex.com/api/v1.1/public/getcurrencies';
[response,status] = urlread2(url,'GET',{},header_1);
end
% getticker function
function [response,status]=bittrex_getticker(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
market_loc=find(strcmp('market',params),1);
if isempty(market_loc)
url='https://bittrex.com/api/v1.1/public/getticker/?market=BTC-LTC';
disp('market missing, used default: BTC-LTC')
else
url=['https://bittrex.com/api/v1.1/public/getticker/?market=',params{market_loc+1}];
end
[response,status] = urlread2(url,'GET',{},header_1);
end
% getmarketsummaries function
function [response,status]=bittrex_getmarketsummaries(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
url='https://bittrex.com/api/v1.1/public/getmarketsummaries';
[response,status] = urlread2(url,'GET',{},header_1);
end
% getmarketsummary function
function [response,status]=bittrex_getmarketsummary(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
market_loc=find(strcmp('market',params),1);
if isempty(market_loc)
url='https://bittrex.com/api/v1.1/public/getmarketsummary/?market=BTC-LTC';
disp('market missing, used default: BTC-LTC')
else
url=['https://bittrex.com/api/v1.1/public/getmarketsummary/?market=',params{market_loc+1}];
end
[response,status] = urlread2(url,'GET',{},header_1);
end
% getorderbook function
function [response,status]=bittrex_getorderbook(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
market_loc=find(strcmp('market',params),1);
type_loc=find(strcmp('type',params),1);
depth_loc=find(strcmp('depth',params),1);
if isempty(market_loc)
url='https://bittrex.com/api/v1.1/public/getmarketsummary/?market=BTC-LTC';
disp('market missing, used default: BTC-LTC')
else
url=['https://bittrex.com/api/v1.1/public/getmarketsummary/?market=',params{market_loc+1}];
end
if isempty(type_loc)
url=[url,'&type=both'];
disp('type missing, used default: both')
else
url=[url,'&type=',params{type_loc+1}];
end
if isempty(depth_loc)
url=[url,'&depth=20'];
disp('depth missing, used default: 20')
else
url=[url,'&depth=',params{depth_loc+1}];
end
[response,status] = urlread2(url,'GET',{},header_1);
end
% getmarkethistory function
function [response,status]=bittrex_getmarkethistory(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
market_loc=find(strcmp('market',params),1);
count_loc=find(strcmp('count',params),1);
if isempty(market_loc)
url='https://bittrex.com/api/v1.1/public/getmarkethistory/?market=BTC-LTC';
disp('market missing, used default: BTC-LTC')
else
url=['https://bittrex.com/api/v1.1/public/getmarkethistory/?market=',params{market_loc+1}];
end
if isempty(count_loc)
url=[url,'&count=20'];
disp('count missing, used default: 20')
else
url=[url,'&count=',params{count_loc+1}];
end
[response,status] = urlread2(url,'GET',{},header_1);
end
% requests with authentication
% header & parameters
function [response,status]=bittrex_authenticated(url_ext,parameter)
    url='https://bittrex.com/api/v1.1/';
    % nonce
    nonce = num2str(floor((now-datenum('1970', 'yyyy'))*8640000000));
    [key,secret,~]=key_secret('bittrex');
    url=[url,parameter,'?apikey=',key,'&nonce=',nonce,url_ext];
    Signature = crypto(url, secret, 'HmacSHA512');
    header1=http_createHeader('User-Agent','Mozilla/4.0 (compatible; Node Bittrex API)');
    header2=http_createHeader('Content-Type','application/x-www-form-urlencoded');
    header3=http_createHeader('APISIGN',char(Signature));
    header=[header1 header2 header3];
    [response,status] = urlread2(url,'GET','',header);
end

% buylimit function
function [response,status]=bittrex_buylimit(params)
parameter='market/buylimit/';
market_loc=find(strcmp('market',params),1);
quantity_loc=find(strcmp('quantity',params),1);
rate_loc=find(strcmp('rate',params),1);
if isempty(market_loc)
    disp('market missing')
    response='error';
    status='error'; 
else
url_ext=['&market=',params{market_loc+1}];
end
if isempty(quantity_loc)
    disp('quantity missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&quantity=',params{quantity_loc+1}];
end
if isempty(rate_loc)
    disp('rate missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&rate=',params{rate_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end

% buymarket function
function [response,status]=bittrex_buymarket(params)
parameter='market/buymarket/';
market_loc=find(strcmp('market',params),1);
quantity_loc=find(strcmp('quantity',params),1);
if isempty(market_loc)
    disp('market missing')
    response='error';
    status='error'; 
else
url_ext=['&market=',params{market_loc+1}];
end
if isempty(quantity_loc)
    disp('quantity missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&quantity=',params{quantity_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end

% selllimit function
function [response,status]=bittrex_selllimit(params)
parameter='market/selllimit/';
market_loc=find(strcmp('market',params),1);
quantity_loc=find(strcmp('quantity',params),1);
rate_loc=find(strcmp('rate',params),1);
if isempty(market_loc)
    disp('market missing')
    response='error';
    status='error'; 
else
url_ext=['&market=',params{market_loc+1}];
end
if isempty(quantity_loc)
    disp('quantity missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&quantity=',params{quantity_loc+1}];
end
if isempty(rate_loc)
    disp('rate missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&rate=',params{rate_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end

% sellmarket function
function [response,status]=bittrex_sellmarket(params)
parameter='market/sellmarket/';
market_loc=find(strcmp('market',params),1);
quantity_loc=find(strcmp('quantity',params),1);
if isempty(market_loc)
    disp('market missing')
    response='error';
    status='error'; 
else
url_ext=['&market=',params{market_loc+1}];
end
if isempty(quantity_loc)
    disp('quantity missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&quantity=',params{quantity_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% cancel function
function [response,status]=bittrex_cancel(params)
parameter='market/cancel/';
uuid_loc=find(strcmp('uuid',params),1);
if isempty(uuid_loc)
    disp('uuid missing')
    response='error';
    status='error'; 
else
url_ext=['&uuid=',params{uuid_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% getopenorders function
function [response,status]=bittrex_getopenorders(params)
parameter='market/getopenorders/';
market_loc=find(strcmp('market',params),1);
if isempty(market_loc)
    disp('market missing')
    response='error';
    status='error'; 
else
url_ext=['&market=',params{market_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% getbalances function
function [response,status]=bittrex_getbalances(~)
parameter='account/getbalances';
url_ext='';
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% getbalance function
function [response,status]=bittrex_getbalance(params)
parameter='account/getbalance/';
currency_loc=find(strcmp('currency',params),1);
if isempty(currency_loc)
    disp('currency missing')
    response='error';
    status='error'; 
else
url_ext=['&currency=',params{currency_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% getdepositaddress function
function [response,status]=bittrex_getdepositaddress(params)
parameter='account/getdepositaddress/';
currency_loc=find(strcmp('currency',params),1);
if isempty(currency_loc)
    disp('currency missing')
    response='error';
    status='error'; 
else
url_ext=['&currency=',params{currency_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% withdraw function
function [response,status]=bittrex_withdraw(params)
parameter='account/withdraw/';
currency_loc=find(strcmp('currency',params),1);
quantity_loc=find(strcmp('quantity',params),1);
address_loc=find(strcmp('address',params),1);
paymentid_loc=find(strcmp('paymentid',params),1);
if isempty(currency_loc)
    disp('currency missing')
    response='error';
    status='error'; 
else
url_ext=['&currency=',params{currency_loc+1}];
end
if isempty(quantity_loc)
    disp('quantity missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&quantity=',params{quantity_loc+1}];
end
if isempty(address_loc)
    disp('address missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&address=',params{address_loc+1}];
end
if isempty(paymentid_loc)
    disp('paymentid missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&paymentid=',params{paymentid_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% getorder function
function [response,status]=bittrex_getorder(params)
parameter='account/getorder/';
uuid_loc=find(strcmp('uuid',params),1);
if isempty(uuid_loc)
    disp('uuid missing')
    response='error';
    status='error'; 
else
url_ext=['&uuid=',params{uuid_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% getorderhistory function
function [response,status]=bittrex_getorderhistory(params)
parameter='account/getorderhistory/';
market_loc=find(strcmp('market',params),1);
count_loc=find(strcmp('count',params),1);
if isempty(market_loc)
    disp('market missing')
    response='error';
    status='error'; 
else
url_ext=['&market=',params{market_loc+1}];
end
if isempty(count_loc)
    disp('count missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&count=',params{count_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% getwithdrawalhistory function
function [response,status]=bittrex_getwithdrawalhistory(params)
parameter='account/getwithdrawalhistory/';
currency_loc=find(strcmp('currency',params),1);
count_loc=find(strcmp('count',params),1);
if isempty(currency_loc)
    disp('currency missing')
    response='error';
    status='error'; 
else
url_ext=['&currency=',params{currency_loc+1}];
end
if isempty(count_loc)
    disp('count missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&count=',params{count_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
% getdeposithistory function
function [response,status]=bittrex_getdeposithistory(params)
parameter='account/getdeposithistory/';
currency_loc=find(strcmp('currency',params),1);
count_loc=find(strcmp('count',params),1);
if isempty(currency_loc)
    disp('currency missing')
    response='error';
    status='error'; 
else
url_ext=['&currency=',params{currency_loc+1}];
end
if isempty(count_loc)
    disp('count missing')
    response='error';
    status='error'; 
else
url_ext=[url_ext,'&count=',params{count_loc+1}];
end
[response,status]=bittrex_authenticated(url_ext,parameter);
end
