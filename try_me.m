clear
clc
close all
[key,secret,username]=key_secret('gdax');

ans1{1}=char(typecast(org.apache.commons.codec.binary.Base64.decodeBase64(uint8(secret)), 'uint8')');
secretcheck=char(org.apache.commons.codec.binary.Base64.encodeBase64(uint8(ans1{1})))';