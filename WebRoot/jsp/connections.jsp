<%@ page contentType="text/csv" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="org.nescent.plhdb.hibernate.HibernateSessionFactory" %>
<%       
Object [] objs=HibernateSessionFactory.getConnectionMap().keySet().toArray();

for (int i=0;i< objs.length; i++) {
	Connection conn = (Connection) objs[i];
	if (conn != null) {
		out.write(conn.toString()+"<br/>     " + conn.getCatalog() + "<br/>  "+conn.hashCode());
	}
}
%>