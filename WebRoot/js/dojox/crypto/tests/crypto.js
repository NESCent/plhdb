dojo.provide("dojox.crypto.tests.crypto");
dojo.require("dojox.crypto");

try{
	dojo.require("dojox.crypto.tests.MD5");
	dojo.require("dojox.crypto.tests.Blowfish");
}catch(e){
	doh.debug(e);
}
