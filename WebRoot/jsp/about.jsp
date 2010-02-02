<%@ page language="java" %>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>
<%       
request.setAttribute("active_menu","about");
%>
<tiles:insert page="../tiles/template.jsp" flush="true">
   <tiles:put name="title" type="string" value="Add User" />
   <tiles:put name="header" value="../tiles/top.jsp" />
   <tiles:put name="menu" value="../tiles/menu.jsp" />
   <tiles:put name="body" value="../tiles/aboutBody.jsp" />
   <tiles:put name="bottom" value="../tiles/bottom.jsp" /> 
</tiles:insert>