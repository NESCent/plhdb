<%@ page contentType="text/html" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%@ page import="java.util.*" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>
<title>Primate Life Histories Database</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">   
	
<link rel="stylesheet" type="text/css" href="/js/dijit/themes/tundra/tundra.css" />
<link rel="stylesheet" type="text/css" href="/css/plhdb.css" />
<script type="text/javascript" src="/js/dojo/dojo.js"  djConfig="parseOnLoad: false, isDebug: false"></script>
<script type="text/javascript" src="/js/dijit/dijit.js"></script>


</head><body class="tundra" id="container" style="margin-top:0;padding-top:0;">
<div class="pagewrapper" style="margin-top:0;padding-top:0;">
<div style="clear:both;height:44px;"></div>

   <div class="header">
       <tiles:insert attribute="header" />
       <div id="nav"><tiles:insert attribute="menu" /></div>
   </div>
   <div style="clear:both;height:42px;"></div>
   <div class="content"><tiles:insert attribute="body" /></div>

   </div>

<div class="footer"><tiles:insert attribute="bottom" /></div>

</body>

</html>





