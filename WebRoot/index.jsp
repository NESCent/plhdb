<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tiles" %>

<tiles:insert page="/tiles/template.jsp" flush="true">
   <tiles:put name="title" type="string" value="Login" />
   <tiles:put name="header" value="/tiles/top.jsp" />
   <tiles:put name="menu" value="/tiles/menu.jsp" />
   <tiles:put name="body" value="/tiles/homeBody.jsp" />
   <tiles:put name="bottom" value="/tiles/bottom.jsp" />
   
</tiles:insert>